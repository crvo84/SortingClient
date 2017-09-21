//
//  RandomNumbersGenerator.m
//  DSortClient
//
//  Created by Carlos Villanueva Ousset on 9/20/17.
//  Copyright © 2017 villou. All rights reserved.
//

#import "RandomNumbersGenerator.h"

@implementation RandomNumbersGenerator

+ (NSArray *)arrayOfIntegerNumbersWithSize:(uint32_t)size maximum:(uint32_t)max
{
    NSMutableArray *result = [[NSMutableArray alloc] initWithCapacity:size];
    
    for (int i = 0; i < size; i++) {
        NSNumber *randomNum = @(arc4random_uniform(max));
        [result insertObject:randomNum atIndex:i];
    }
    
    return result;
}

@end
