//
//  SetCard.h
//  Matchismo
//
//  Created by Nan Shen on 14/10/19.
//  Copyright (c) 2014年 Nan Shen. All rights reserved.
//

#import "Card.h"

@interface SetCard : Card

@property (nonatomic) NSInteger number;
//@property (strong, nonatomic) NSString * symbol;


enum ShadingType
{
    SOLID_SHADING = 0,
    SHADING_SHADING = 1,
    OPEN_SHADING = 2,
    MAX_SHADING_NUMBER
};

enum SetCardColor
{
    SET_CARD_COLOR_RED = 0,
    SET_CARD_COLOR_BLUE = 1,
    SET_CARD_COLOR_PURPLE = 2,
    SET_CARD_COLOR_MAX
};

enum SymbolType
{
    SET_CARD_SYMBOL_DIAMOND = 0,
    SET_CARD_SYMBOL_SQUIGGLE = 1,
    SET_CARD_SYMBOL_OVAL = 2,
    SET_CARD_SYMBOL_MAX
};

@property (nonatomic, readwrite) enum ShadingType shadingType;
@property (nonatomic, readwrite) enum  SetCardColor color;
@property (nonatomic, readwrite) enum SymbolType symbol;

//content is used to print out the number with that symbol and color
@property (strong, nonatomic) NSString * contents;

+ (NSArray *) validSymbol;
+ (NSArray *) validNumberStrings;
+ (NSUInteger) maxRank;

@end
