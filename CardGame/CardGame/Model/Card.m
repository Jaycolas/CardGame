//
//  Card.m
//  Matchismo
//
//  Created by Nan Shen on 14-9-3.
//  Copyright (c) 2014年 Nan Shen. All rights reserved.
//

#import "Card.h"

@implementation Card

- (int) match:(NSArray *)otherCards
{
    int score = 0;
    for (Card * card in otherCards){
        if ([card.contents isEqualToString:self.contents]){
            score = 1;
        }
    }
    
    return score;
}

- (Card *) copyCard:(Card *) otherCard
{
    Card * card = [[Card alloc] init];
    card.contents = [card.contents initWithString:otherCard.contents];
    card.chosen = otherCard.chosen;
    card.matched = otherCard.matched;
    NSLog(@"card contents is %@", card.contents);
    return card;
}

- (NSString *) cardType
{
    NSString * cardTypePrint;
    cardTypePrint = [cardTypePrint initWithString:@"No specific card is implemented"];
    return cardTypePrint;
    
}

@end
