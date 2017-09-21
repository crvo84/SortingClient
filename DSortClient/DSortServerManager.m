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
    NSString *urlStr = [[NSString alloc] initWithFormat:@"https://crvo84-dsort%d.herokuapp.com", serverIndex + 1];
    NSError *requestError;
    NSURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST"
                                                                          URLString:urlStr
                                                                         parameters:array error:&requestError];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
        NSURLSessionDownloadTask *sortTask = [manager downloadTaskWithRequest:request
                                                                     progress:nil
                                                                  destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        
        return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
        
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        NSLog(@"File downloaded to: %@", filePath);
        NSData *jsonData = [[NSData alloc] initWithContentsOfURL:filePath];
        
        NSError *serializationError = nil;
        NSArray *result = [NSJSONSerialization JSONObjectWithData: jsonData
                                                          options: NSJSONReadingMutableContainers
                                                            error: &serializationError];
        if (!serializationError) {
            [self.sortedArrays insertObject:result atIndex:0];
        }
        
        completion(serializationError);
    }];
    
    [sortTask resume];
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
