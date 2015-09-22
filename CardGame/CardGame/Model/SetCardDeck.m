//
//  SetCardDeck.m
//  Matchismo
//
//  Created by Nan Shen on 14/10/19.
//  Copyright (c) 2014年 Nan Shen. All rights reserved.
//

#import "SetCardDeck.h"
#import "SetCard.h"

@implementation SetCardDeck

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        for (NSInteger symbol = 0; symbol < SET_CARD_SYMBOL_MAX; symbol++) {
            for (NSInteger number_index = 1; number_index <= [SetCard maxRank]; number_index ++) {
                for (int shading_index = 0; shading_index < MAX_SHADING_NUMBER; shading_index++) {
                    for (int color_index = 0; color_index < SET_CARD_COLOR_MAX; color_index++) {
                        SetCard * setCard = [[SetCard alloc] init];
                        setCard.symbol = (enum SymbolType)symbol;
                        setCard.number = number_index;
                        setCard.shadingType = shading_index;
                        setCard.color = color_index;
                        [self addCard:setCard];
                    }
                }
            }
        }
    }
    

    
    return self;
}

@end
