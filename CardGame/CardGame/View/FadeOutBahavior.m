//
//  FadeOutBahavior.m
//  CardGame
//
//  Created by Nan Shen on 15/2/20.
//  Copyright (c) 2015年 Nan Shen. All rights reserved.
//

#import "FadeOutBahavior.h"

@interface FadeOutBahavior()

@property (strong, nonatomic) UIGravityBehavior * allCardsMoveBehavior;
@property (strong, nonatomic) UICollisionBehavior * allCardsCollisionBehavior;
@property (strong, nonatomic) UIDynamicItemBehavior * itemBehavior;


@end

@implementation FadeOutBahavior


- (UIGravityBehavior *)allCardsMoveBehavior
{
    if (!_allCardsMoveBehavior) {
        _allCardsMoveBehavior = [[UIGravityBehavior alloc]init];
        _allCardsMoveBehavior.magnitude = 1.0;
    }
    
    return _allCardsMoveBehavior;
}

- (UICollisionBehavior *)allCardsCollisionBehavior
{
    if (!_allCardsCollisionBehavior) {
        _allCardsCollisionBehavior = [[UICollisionBehavior alloc]init];
        _allCardsCollisionBehavior.translatesReferenceBoundsIntoBoundary = YES;
    }
    
    return _allCardsCollisionBehavior;
}

- (UIDynamicItemBehavior *)itemBehavior
{
    if (!_itemBehavior) {
        _itemBehavior = [[UIDynamicItemBehavior alloc]init];
    }
    
    /*Place all the properties of itemBehavior here*/
    /**/
    
    return _itemBehavior;
}

- (void) addItem: (id<UIDynamicItem>) item;
{
    [self.allCardsMoveBehavior addItem:item];
    [self.allCardsCollisionBehavior addItem:item];
    [self.itemBehavior addItem:item];
    
}

- (void) removeItem: (id<UIDynamicItem>) item;
{
    [self.allCardsCollisionBehavior removeItem:item];
    [self.allCardsMoveBehavior removeItem:item];
    [self.itemBehavior removeItem:item];
}



@end
