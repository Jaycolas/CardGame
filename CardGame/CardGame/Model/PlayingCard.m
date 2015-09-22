//
//  PlayingCard.m
//  Matchismo
//
//  Created by Nan Shen on 14-9-3.
//  Copyright (c) 2014年 Nan Shen. All rights reserved.
//

#import "PlayingCard.h"

@implementation PlayingCard

- (int)match:(NSArray *)otherCards
{
    int score =0;
    
    if ([otherCards count] == 1){
        
        NSLog(@"Now PlayingCard is doing 2 cards matching");
        
        id firstCard = [otherCards firstObject];
        
        if ([firstCard isKindOfClass:[PlayingCard class]]) {
            PlayingCard *otherCard = firstCard;
            if (otherCard.rank == self.rank) {
                score = 4;
            }
            else if ([otherCard.suit isEqualToString:self.suit  ]){
                score = 1;
            }
        }


    }
    else if ([otherCards count] == 2){
        
        NSLog(@"Now PlayingCard is doing 3 cards matching");
        
        id firstCardFromArg = [otherCards firstObject];
        id secondCardFromArg = [otherCards lastObject];
        
        if (([firstCardFromArg isKindOfClass:[PlayingCard class]]) &&
            ([secondCardFromArg isKindOfClass:[PlayingCard class]])){
            
            PlayingCard * firstCard = firstCardFromArg;
            PlayingCard * secondCard = secondCardFromArg;
            
            if ((self.rank == firstCard.rank) && (self.rank == secondCard.rank)){
                score = 20; //should give more bonus when have a 3 rank match
            }
            else if ((self.rank == firstCard.rank) || (self.rank == secondCard.rank) || (secondCard.rank == firstCard.rank)){
                score = 10;
            }
            else if (([self.suit isEqualToString:firstCard.suit]) && ([self.suit isEqualToString:secondCard.suit]))
            {
                score = 8;  //3 suits are all the same, that's not easy.
            }
            else if (([self.suit isEqualToString:firstCard.suit]) || ([self.suit isEqualToString:secondCard.suit]) || ([firstCard.suit isEqualToString:secondCard.suit])){
                score = 2;
            }
                
            
            //TODO
            
        }
            
    }
    
    return score;
}

- (NSString *)contents
{
    NSArray * rankStrings = [PlayingCard rankStrings];
    
    return [rankStrings[self.rank] stringByAppendingString:self.suit];
    
}

@synthesize suit=_suit;

+ (NSArray *)validSuits{
    return @[@"♠️",@"♣️", @"❤️", @"♦️"];
}

- (void)setSuit:(NSString *)suit
{
    if ([[PlayingCard validSuits] containsObject:suit])
    {
        _suit=suit;
    }
}

- (NSString *)suit
{
    return _suit ? _suit: @"?";
}

+ (NSUInteger) maxRank {
    return [[self rankStrings] count]-1;
}

+ (NSArray *)rankStrings
{
    return @[@"？",@"A",@"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"J", @"Q", @"K"];
}

- (NSString *)rankAsString
{
    return @[@"？",@"A",@"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"J", @"Q", @"K"][self.rank];
}

- (NSString *)cardType
{
    return @"Current played game is Playing Card\n";
}

- (PlayingCard * )copyCard: (PlayingCard *) otherCard
{
    /*
    PlayingCard * playingCard = [[PlayingCard alloc] init];
    
    NSMutableString * contentsTemp = [[NSMutableString alloc] initWithString:otherCard.contents];
    playingCard.contents = [contentsTemp copy];
    
    playingCard.chosen = otherCard.chosen;
    playingCard.matched = otherCard.matched;
    
    NSMutableString * suitTemp = [[NSMutableString alloc] initWithString:otherCard.suit];
    
    playingCard.suit = [suitTemp copy];
    playingCard.rank = otherCard.rank; */
    
    //TODO
    return nil;
    

    
}

@end
