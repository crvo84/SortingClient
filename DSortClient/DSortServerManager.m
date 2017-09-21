//
//  DSortServerManager.m
//  DSortMaster
//
//  Created by Carlos Villanueva Ousset on 9/20/17.
//  Copyright © 2017 villou. All rights reserved.
//

#import "DSortServerManager.h"

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
