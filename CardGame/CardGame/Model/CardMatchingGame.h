//
//  CardMatchingGame.h
//  Matchismo
//
//  Created by Nan Shen on 14-9-6.
//  Copyright (c) 2014年 Nan Shen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Deck.h"

@interface CardMatchingGame : NSObject

- (instancetype)initWithCardCount:(NSUInteger)count usingDeck:(Deck *)deck; //designated initializer

- (void)chooseCardAtIndex:(NSUInteger) index;
- (void)chooseCard: (Card * )card;
- (Card *)cardAtIndex:(NSUInteger) index;




enum CardGameMode
{
    TWO_CARDS_MATCHING,
    THREE_CARDS_MATHCING
};

@property (nonatomic, readonly) NSInteger score;
@property (nonatomic, readwrite) enum CardGameMode gameMode;
@property (nonatomic, readwrite) BOOL isMatchingShot;
@property (nonatomic, readwrite) int curMatchPoint;
@property (nonatomic, readwrite) NSInteger chosenCount;
@property (nonatomic, readwrite) NSInteger cardChosen;
//@property (nonatomic, strong) NSMutableArray * newlyArrivedCards;
@property (nonatomic, strong) NSMutableArray * newlyArrivedCards;
@property (nonatomic, readwrite) NSInteger currentIndex;
@property (nonatomic, readwrite) NSInteger lastChosenIndex;
@property (nonatomic, readwrite) NSInteger oneBeforeLastChosenIndex;

@property (strong, nonatomic) Deck * deck;

@end
