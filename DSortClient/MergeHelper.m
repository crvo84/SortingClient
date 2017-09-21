//
//  MergeHelper.m
//  DSortMaster
//
//  Created by Carlos Villanueva Ousset on 9/20/17.
//  Copyright © 2017 villou. All rights reserved.
//

#import "MergeHelper.h"

@implementation MergeHelper

+ (NSArray *)mergeLeftArray:(NSArray *)left withRightArray:(NSArray *)right {
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

@end
