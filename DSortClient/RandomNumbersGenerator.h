//
//  RandomNumbersGenerator.h
//  DSortClient
//
//  Created by Carlos Villanueva Ousset on 9/20/17.
//  Copyright © 2017 villou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RandomNumbersGenerator : NSObject

+ (NSArray *)arrayOfIntegerNumbersWithSize:(uint32_t)size maximum:(uint32_t)max;

@end
