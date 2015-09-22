//
//  Deck.h
//  Matchismo
///Users/nanshen/Documents/Developer/Matchismo/Matchismo.xcodeproj
//  Created by Nan Shen on 14-9-3.
//  Copyright (c) 2014年 Nan Shen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"

@interface Deck : NSObject

- (void) addCard: (Card *) card atTop:(BOOL)atTop;
- (void) addCard:(Card *)card;

- (Card *)drawRandomCard;

@end
