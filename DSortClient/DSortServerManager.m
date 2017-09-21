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
    NSLog(@"%@", urlStr);
    
    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfig];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    request.HTTPMethod = @"POST";

    [request addValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    // in the body of the http request, we add the array of integers to be sorted
    request.HTTPBody = [NSJSONSerialization dataWithJSONObject:array options:0 error:nil];

    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            NSLog(@"Error: %@", error);
        } else {
            // successful response
            // parse the response data to an array
            NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"%@", jsonArray);
            // append the sorted array to the array of 'sorted arrays'
            [self.sortedArrays insertObject:jsonArray atIndex:self.sortedArrays.count];
        }
    }];
    
    [task resume];
    [session finishTasksAndInvalidate]; // ?
}

#pragma mark - Getters

- (NSMutableArray *)sortedArrays
{
    if (!_sortedArrays) {
        _sortedArrays = [[NSMutableArray alloc] init];
    }
    
    return _sortedArrays;
}

#pragma mark - Setters



@end
