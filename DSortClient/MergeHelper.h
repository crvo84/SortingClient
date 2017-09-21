//
//  MergeHelper.h
//  DSortMaster
//
//  Created by Carlos Villanueva Ousset on 9/20/17.
//  Copyright © 2017 villou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MergeHelper : NSObject

+ (NSArray *)mergeLeftArray:(NSArray *)left withRightArray:(NSArray *)right;
+ (NSArray *)mergeArrays:(NSArray *)arrays;

@end
