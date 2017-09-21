//
//  main.m
//  DSortMaster
//
//  Created by Carlos Villanueva Ousset on 9/20/17.
//  Copyright © 2017 villou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DSortServerManager : NSObject

@property (nonatomic) int numberOfServers;
@property (strong, nonatomic) NSMutableArray *sortedArrays; // of NSArray
@property (strong, nonatomic) NSMutableArray *communicationTimes; // of NSNumber
@property (strong, nonatomic) NSMutableArray *computationTimes; // of NSNumber

- (instancetype)initWithNumberOfServers:(int)numberOfServers;

- (void)askServerWithIndex:(int)serverIndex
               toSortArray:(NSArray *)array
            withCompletion:(void (^)(NSError *))completion;

- (double)getCommunicationTimeSum;
- (double)getComputationTimeSum;

- (double)getMaxCommunicationTime;
- (double)getMaxComputationTime;

@end

@implementation DSortServerManager

- (instancetype)initWithNumberOfServers:(int)numberOfServers
{
    self = [super init];
    
    if (self) {
        self.numberOfServers = numberOfServers;
    }
    
    return self;
}

- (void)askServerWithIndex:(int)serverIndex
               toSortArray:(NSArray *)array
            withCompletion:(void (^)(NSError *))completion
{
    // create the url (hosted on Heroku) with the given server index
    NSString *urlStr = [[NSString alloc] initWithFormat:@"https://crvo84-dsort%d.herokuapp.com/sort", serverIndex + 1];
    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfig];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    request.HTTPMethod = @"POST";
    
    [request addValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    // in the body of the http request, we add the array of integers to be sorted
    request.HTTPBody = [NSJSONSerialization dataWithJSONObject:array options:0 error:nil];
    
    NSDate *start = [NSDate date]; // START TIME
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (!error) { // successful response
            NSDate *end = [NSDate date]; // END DATE
            double totalTime = [end timeIntervalSinceDate:start];
            
            // parse the response data to a dictionary
            NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:data
                                                                         options:NSJSONReadingMutableContainers error:nil];
            NSArray *resultArray = responseDict[@"result"];
            NSNumber *computationTimeNum = responseDict[@"time"];
            double computationTime = [computationTimeNum doubleValue];
            double communicationTime = totalTime - computationTime;
            
            [self.sortedArrays insertObject:resultArray atIndex:self.sortedArrays.count];
            [self.communicationTimes insertObject:@(communicationTime) atIndex:self.communicationTimes.count];
            [self.computationTimes insertObject:@(computationTime) atIndex:self.computationTimes.count];
        }
        
        completion(error);
    }];
    
    [task resume];
    [session finishTasksAndInvalidate];
}

// TOTAL Times

- (double)getCommunicationTimeSum
{
    double totalTime = 0;
    for (int i = 0; i < self.communicationTimes.count; i++) {
        NSNumber *timeNum = self.communicationTimes[i];
        totalTime += [timeNum doubleValue];
    }
    
    return totalTime;
}

- (double)getComputationTimeSum
{
    double totalTime = 0;
    for (int i = 0; i < self.computationTimes.count; i++) {
        NSNumber *timeNum = self.computationTimes[i];
        totalTime += [timeNum doubleValue];
    }
    
    return totalTime;
}

// AVERAGE TIMES

- (double)getMaxCommunicationTime
{
    double max = 0;
    for (int i = 0; i < self.communicationTimes.count; i++) {
        double time = [self.communicationTimes[i] doubleValue];
        if (time > max) {
            max = time;
        }
    }
    
    return max;
}

- (double)getMaxComputationTime
{
    double max = 0;
    for (int i = 0; i < self.computationTimes.count; i++) {
        double time = [self.computationTimes[i] doubleValue];
        if (time > max) {
            max = time;
        }
    }
    
    return max;
}

#pragma mark - Getters

- (NSMutableArray *)sortedArrays
{
    if (!_sortedArrays) {
        _sortedArrays = [[NSMutableArray alloc] init];
    }
    
    return _sortedArrays;
}

- (NSMutableArray *)communicationTimes
{
    if (!_communicationTimes) {
        _communicationTimes = [[NSMutableArray alloc] init];
    }
    
    return _communicationTimes;
}

- (NSMutableArray *)computationTimes
{
    if (!_computationTimes) {
        _computationTimes = [[NSMutableArray alloc] init];
    }
    
    return _computationTimes;
}

#pragma mark - Setters



@end


@interface MergeHelper : NSObject

+ (NSArray *)mergeLeftArray:(NSArray *)left withRightArray:(NSArray *)right;
+ (NSArray *)mergeArrays:(NSArray *)arrays;
+ (NSArray *)mergeSort:(NSArray *)array;

@end

@implementation MergeHelper

+ (NSArray *)mergeLeftArray:(NSArray *)left withRightArray:(NSArray *)right
{
    if (!left || !right) {
        return nil;
    }
    
    NSMutableArray *result = [[NSMutableArray alloc] initWithCapacity:(left.count + right.count)];
    
    // merge left and right arrays
    int i = 0; // left array index
    int j = 0; // right array index
    int k = 0; // result array index
    
    while (i < left.count && j < right.count) {
        if (left[i] <= right[j]) {
            result[k] = left[i];
            i++;
        } else {
            result[k] = right[j];
            j++;
        }
        k++;
    }
    
    // copy remaining elements in the left array
    while (i < left.count) {
        result[k] = left[i];
        i++;
        k++;
    }
    
    // copy remaining elements in the right array
    while (j < right.count) {
        result[k] = right[j];
        j++;
        k++;
    }
    
    return result;
}

+ (NSArray *)mergeArrays:(NSArray *)arrays
{
    if (!arrays) { return nil; }
    
    if (arrays.count <= 1) { return arrays; } // nothing no merge
    
    NSArray *arraysLeft = [arrays mutableCopy];
    
    while (arraysLeft.count > 1) {
        NSMutableArray *newArraysLeft = [[NSMutableArray alloc] init];
        
        for (int i = 0; i < arraysLeft.count; i += 2) {
            if (i == arraysLeft.count - 1) {
                // last array, append without merging
                [newArraysLeft insertObject:arraysLeft[i] atIndex:newArraysLeft.count];
            } else {
                // merge array with next index, and append
                NSArray *left = arraysLeft[i];
                NSArray *right = arraysLeft[i + 1];
                NSArray *mergedArray = [MergeHelper mergeLeftArray:left
                                                    withRightArray:right];
                [newArraysLeft insertObject:mergedArray atIndex:newArraysLeft.count];
            }
        }
        arraysLeft = newArraysLeft;
    }
    
    return arraysLeft;
}

+ (NSArray *)mergeSort:(NSArray *)array
{
    NSUInteger count = array.count;
    
    // if the number of elements is <= 1, return same array
    if (array.count <= 1) { return array; }
    
    NSUInteger leftHalfSize = count / 2;
    
    NSArray *left = [MergeHelper mergeSort:[array subarrayWithRange:NSMakeRange(0, leftHalfSize)]];
    NSArray *right = [MergeHelper mergeSort:[array subarrayWithRange:NSMakeRange(leftHalfSize, count - leftHalfSize)]];
    
    NSArray *result = [MergeHelper mergeLeftArray:left withRightArray:right];
    
    if (result.count != left.count + right.count) {
        NSLog(@"Error in merge sorting.");
    }
    
    return result;
}

@end

@interface RandomNumbersGenerator : NSObject

+ (NSArray *)arrayOfIntegerNumbersWithSize:(uint32_t)size maximum:(uint32_t)max;

@end

#import "RandomNumbersGenerator.h"

@implementation RandomNumbersGenerator

+ (NSArray *)arrayOfIntegerNumbersWithSize:(uint32_t)size maximum:(uint32_t)max
{
    NSMutableArray *result = [[NSMutableArray alloc] initWithCapacity:size];
    
    for (int i = 0; i < size; i++) {
        NSNumber *randomNum = @(arc4random_uniform(max));
        [result insertObject:randomNum atIndex:i];
    }
    
    return result;
}

@end

int main(int argc, const char * argv[])
{
    @autoreleasepool {
        // 2 arguments
        if (argc != 3) {
            NSLog(@"Two arguments required.\nn = size of array\nm = number of servers (max 4)");
            return 0;
        }
        
        int n = atoi(argv[1]);
        int m = atoi(argv[2]);
        int max = 999;
        
        // max 4 servers
        if (m > 4) {
            NSLog(@"Max 4 servers.");
            return 0;
        }
        
        // n multiplo de m
        if (n % m != 0) {
            NSLog(@"n % m != 0");
            return 0;
        }
        
        // n minimo 2m
        if (n < 2*m) {
            NSLog(@"n < 2*m");
            return 0;
        }
        
        NSArray *randomArray = [RandomNumbersGenerator arrayOfIntegerNumbersWithSize:n maximum:max];
        
        NSArray *distributedResult;
        NSArray *localResult;
        
        /* ------------------- */
        /* DISTRIBUTED SORTING */
        /* ------------------- */
        int subarraySize = n/m; // size of each array to be sorted by each server
        
        NSMutableArray *subarraysToSort = [[NSMutableArray alloc] init]; // array of arrays
        
        for (int i = 0; i < m; i++) {
            NSRange range = NSMakeRange(i*subarraySize, subarraySize);
            NSArray *subarray = [randomArray subarrayWithRange:range];
            [subarraysToSort insertObject:subarray atIndex:i];
        }
        
        DSortServerManager *serverManager = [[DSortServerManager alloc] initWithNumberOfServers:1];
        
        dispatch_group_t serviceGroup = dispatch_group_create();
        
        for (int i = 0; i < subarraysToSort.count; i++) {
            dispatch_group_enter(serviceGroup);
            [serverManager askServerWithIndex:i // server index
                                  toSortArray:subarraysToSort[i]
                               withCompletion:^(NSError *error) {
                                   if (error) { NSLog(@"%@", error); }
                                   
                                   dispatch_group_leave(serviceGroup);
                               }];
        }
        // all m subarrays must be sorted at this point
        dispatch_group_wait(serviceGroup, DISPATCH_TIME_FOREVER);
        
        NSArray *result = [MergeHelper mergeArrays:serverManager.sortedArrays];
        if (result != nil && result.count == 1) {
            distributedResult = result[0];
        } else {
            NSLog(@"Error: Failed to merge sort arrays");
        }
        
        /* ------------------- */
        /* -- LOCAL SORTING -- */
        /* ------------------- */
        NSDate *localStart = [NSDate date];
        localResult = [MergeHelper mergeSort:randomArray];
        NSDate *localEnd = [NSDate date];
        
        double localComputationTime = [localEnd timeIntervalSinceDate:localStart];
        
        
        
        NSLog(@"-----------------------------------\nn = %d\nm = %d\n-----------------------------------\nDISTRIBUIDO\nTiempo Total = %f\nTiempo de Comunicación = %f\nTiempo de Computación = %f\n-----------------------------------\nLOCAL\nTiempo de Computación = %f\n-----------------------------------", n, m, serverManager.getMaxComputationTime + serverManager.getMaxCommunicationTime, serverManager.getMaxCommunicationTime, serverManager.getMaxComputationTime, localComputationTime);
    }
    
    return 0;
}
