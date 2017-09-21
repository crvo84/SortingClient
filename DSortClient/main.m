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

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        BOOL distributed = true;
        
        if (distributed) {
            NSArray *array = @[@2, @1, @8, @6, @0, @1000, @3, @67, @999];
            
            DSortServerManager *serverManager = [[DSortServerManager alloc] initWithNumberOfServers:1];
            
            dispatch_group_t serviceGroup = dispatch_group_create();
            
            dispatch_group_enter(serviceGroup);
            [serverManager askServerWithIndex:0 toSortArray:array withCompletion:^(NSError *error) {
                if (error) {
                    NSLog(@"%@", error);
                }
                
                dispatch_group_leave(serviceGroup);
            }];
            
            dispatch_group_wait(serviceGroup, DISPATCH_TIME_FOREVER);
        } else {
            // TODO: merge locally
        }
    }
    
    return 0;
}

