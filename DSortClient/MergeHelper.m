//
//  MergeHelper.m
//  DSortMaster
//
//  Created by Carlos Villanueva Ousset on 9/20/17.
//  Copyright © 2017 villou. All rights reserved.
//

#import "MergeHelper.h"

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

@end
