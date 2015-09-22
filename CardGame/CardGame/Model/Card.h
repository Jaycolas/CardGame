//
//  Card.h
//  Matchismo
//
//  Created by Nan Shen on 14-9-3.
//  Copyright (c) 2014年 Nan Shen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Card : NSObject

@property (strong, nonatomic) NSString *contents;

@property (nonatomic, getter = isChosen) BOOL chosen;

@property (nonatomic, getter = isMatched) BOOL matched;

- (int) match: (NSArray *)otherCards;

- (Card *) copyCard:(Card *) otherCard;

- (NSString *) cardType;


@end
