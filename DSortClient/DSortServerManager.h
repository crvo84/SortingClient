//
//  DSortServerManager.h
//  DSortMaster
//
//  Created by Carlos Villanueva Ousset on 9/20/17.
//  Copyright © 2017 villou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DSortServerManager : NSObject

@property (nonatomic) int numberOfServers;
@property (strong, nonatomic) NSMutableArray *sortedArrays; // of NSArray
@property (strong, nonatomic) NSMutableArray *communicationTimes; // of NSNumber
@property (strong, nonatomic) NSMutableArray *computationTimes; // of NSNumber

- (instancetype)initWithNumberOfServers:(int)numberOfServers;

- (void)askServerWithIndex:(int)serverIndex
               toSortArray:(NSArray *)array
            withCompletion:(void (^)(NSError *))completion;

- (double)getCommunicationTimeSum;
- (double)getComputationTimeSum;

- (double)getMaxCommunicationTime;
- (double)getMaxComputationTime;

@end
