//
//  SetCard.m
//  Matchismo
//
//  Created by Nan Shen on 14/10/19.
//  Copyright (c) 2014年 Nan Shen. All rights reserved.
//

#import "SetCard.h"

@implementation SetCard

- (NSString *)contents
{
    NSString * number = [SetCard validNumberStrings][self.number];
    NSString * symbol = [SetCard validSymbol][self.symbol];
    NSString * color  = [SetCard validColor][self.color];
    NSString * shading = [SetCard validShade][self.shadingType];
    
    NSString * returnContents = [[NSString alloc]initWithString:number];

    
    return [[[returnContents stringByAppendingString:symbol]stringByAppendingString:color]stringByAppendingString:shading];
    
    
}


+ (NSArray *) validSymbol
{
    return @[@"diamond ", @"oval ", @"square "];
}

+ (NSArray *) validColor
{
    return @[@"red ", @"blue ", @"purple "];
}

+ (NSArray *) validShade
{
    return @[@"solid ", @"shading ", @"open "];
}


+ (NSArray *) validNumberStrings
{
    return @[@"?", @"1 ", @"2 ", @"3 "];
}


+ (NSUInteger) maxRank {
    return [[self validNumberStrings] count]-1;
}

- (NSString *)cardType
{
    return @"Current played game is Set Card\n";
}


- (int)match:(NSArray *)otherCards
{
    //One Set has to be 3 cards
    if ([otherCards count] == 2) {
        //TODO
        SetCard * firstCard = [otherCards firstObject];
        SetCard * secondCard = [otherCards lastObject];
        
        BOOL isNumberFit = NO;
        BOOL isShadingFit = NO;
        BOOL isColorFit = NO;
        BOOL isSymbolFit = NO;
        
        if (((self.number == firstCard.number)&& (self.number == secondCard.number)) ||
            ((self.number != firstCard.number) && (self.number != secondCard.number) && (firstCard.number != secondCard.number)))
        {
            NSLog(@"Number fit");
            isNumberFit = YES;
        }
        else
        {
            NSLog(@"Number does not fit");
            return 0; //As long as one condition does not meet, we won't call it a Set.
        }
        
        if (((self.symbol == firstCard.symbol)&& (self.symbol == secondCard.symbol)) ||
            ((self.symbol != firstCard.symbol) && (self.symbol != secondCard.symbol) && (firstCard.symbol != secondCard.symbol)))
        {
            NSLog(@"Symbol fit");
            isSymbolFit = YES;
        }
        else
        {
            NSLog(@"Symbol does not fit");
            return 0;
        }
        
        if (((self.shadingType == firstCard.shadingType)&& (self.shadingType == secondCard.shadingType)) ||
            ((self.shadingType != firstCard.shadingType) && (self.shadingType != secondCard.shadingType) && (firstCard.shadingType != secondCard.shadingType)))
        {
            NSLog(@"Shading fit");
            isShadingFit = YES;
        }
        else
        {
            NSLog(@"Shading does not fit");
            return 0;
            
        }
        
        
        if (((self.color == firstCard.color)&& (self.color == secondCard.color)) ||
            ((self.color != firstCard.color) && (self.color != secondCard.color) && (firstCard.color != secondCard.color)))
        {
            NSLog(@"Color fit");
            isColorFit = YES;
        }
        else
        {
            NSLog(@"Color does not fit");
            return 0;
            
        }
        
        return 1;
        
        
    }
    else
    {
        NSLog(@"Error! Set game has to play with 3 card matching");
        return 0;
    }
    
    
}

@end
