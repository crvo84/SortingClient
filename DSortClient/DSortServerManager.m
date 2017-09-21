//
//  DSortServerManager.m
//  DSortMaster
//
//  Created by Carlos Villanueva Ousset on 9/20/17.
//  Copyright © 2017 villou. All rights reserved.
//

#import "DSortServerManager.h"
#import "AFNetworking.h"

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
    NSString *urlStr = [[NSString alloc] initWithFormat:@"http://0.0.0.0:8080/sort"];
    NSLog(@"%@", urlStr);
    
    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfig];
    
    NSURL *url = [NSURL URLWithString:urlStr];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    request.HTTPMethod = @"POST";

    [request addValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    request.HTTPBody = [NSJSONSerialization dataWithJSONObject:array options:0 error:nil];

    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            NSLog(@"Error: %@", error);
        } else {
            NSLog(@"Success");
            NSError *error = nil;
            NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData: data options: NSJSONReadingMutableContainers error: &error];
            NSLog(@"%@", jsonArray);
        }
    }];
    
    [task resume];
    [session finishTasksAndInvalidate]; // ?
    
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    manager.requestSerializer = [AFJSONRequestSerializer serializer];
////    manager.responseSerializer = [AFJSONResponseSerializer serializer];
//    [manager POST:urlStr parameters:array progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"JSON: %@", responseObject);
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        NSLog(@"Error: %@", error);
//    }];
    
    
//    NSURL *url = [NSURL URLWithString:urlStr];
//    NSLog(@"%@", url);

//    NSString *urlStr = [[NSString alloc] initWithFormat:@"https://crvo84-dsort%d.herokuapp.com/sort", serverIndex + 1];
//    NSError *requestError;
//    NSURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST"
//                                                                          URLString:urlStr
//                                                                         parameters:array error:&requestError];
//    
//    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
//    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
//    
//    
//    NSURLSessionDownloadTask *sortTask = [manager downloadTaskWithRequest:request
//                                                                 progress:nil
//                                                              destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
//    
//        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
//        
//        return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
//        
//    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
//        NSLog(@"File downloaded to: %@", filePath);
//        NSData *jsonData = [[NSData alloc] initWithContentsOfURL:filePath];
//        
//        NSError *serializationError = nil;
//        NSArray *result = [NSJSONSerialization JSONObjectWithData: jsonData
//                                                          options: NSJSONReadingMutableContainers
//                                                            error: &serializationError];
//        if (!serializationError) {
//            [self.sortedArrays insertObject:result atIndex:0];
//        }
//        
//        completion(serializationError);
//    }];
//    
//    [sortTask resume];
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
