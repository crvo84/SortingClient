//
//  main.m
//  DSortMaster
//
//  Created by Carlos Villanueva Ousset on 9/20/17.
//  Copyright © 2017 villou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MergeHelper.h"
#import "DSortServerManager.h"
#import "RandomNumbersGenerator.h"

int main(int argc, const char * argv[])
{
    @autoreleasepool {
        BOOL distributed = YES;
        int n = 1000;
        int m = 4; // max 4
        int max = 999;
        
        if (distributed) { // distributed merge
            int subarraySize = n/m; // size of each array to be sorted by each server
            
            NSMutableArray *subarraysToSort = [[NSMutableArray alloc] init]; // array of arrays
            for (int i = 0; i < m; i++) {
                NSArray *subarray = [RandomNumbersGenerator arrayOfIntegerNumbersWithSize:subarraySize
                                                                                  maximum:max];
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
            
            // TODO: merge sorted subarrays
            NSLog(@"");
            
        } else {
            // TODO: merge locally
        }
    }
    
    return 0;
}

