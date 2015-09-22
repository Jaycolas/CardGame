//
//  PlayingCard.h
//  Matchismo
//
//  Created by Nan Shen on 14-9-3.
//  Copyright (c) 2014年 Nan Shen. All rights reserved.
//

#import "Card.h"

@interface PlayingCard : Card

@property (strong, nonatomic) NSString * suit;
@property (nonatomic) NSUInteger rank;

+ (NSArray *)validSuits;
+ (NSUInteger)maxRank;
- (NSString *)rankAsString;

- (PlayingCard *)copyCard: (PlayingCard *) otherCard;

@end
