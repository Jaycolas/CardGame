//
//  CardGameViewController.h
//  Matchismo
//
//  Created by Nan Shen on 14-9-2.
//  Copyright (c) 2014年 Nan Shen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Deck.h"
#import "CardMatchingGame.h"
#import "CardView.h"

@interface CardGameViewController : UIViewController

@property (strong, nonatomic) NSMutableArray * cardViews;

@property (strong, nonatomic) CardMatchingGame * game;

@property (nonatomic, readwrite) NSUInteger cardInitCount;

@property (nonatomic, readwrite) NSUInteger cardMaxCount;

@property (strong, nonatomic)  UIView *gameView;

- (Deck *)createDeck;

- (CardView *)createCardView: (CGRect)cardViewFrame;

- (void) tapCardView:(UITapGestureRecognizer *)sender;

- (void)cardViewSpecificMethod;


@end
