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
        // insert code here...
        NSArray *left = @[@2, @4, @6, @9, @22, @59];
        NSArray *right = @[@5, @6, @8, @15, @17, @70];
        //        NSArray *merged = [MergeHelper mergeLeftArray:left withRightArray:right];
        //
        //        NSLog(@"%@", merged);
        DSortServerManager *serverManager = [[DSortServerManager alloc] initWithNumberOfServers:1];
        
        [serverManager askServerWithIndex:0 toSortArray:left withCompletion:^(NSError *error) {
            if (error) {
                print(error);
            }
        }];
    }
    
    return 0;
}

