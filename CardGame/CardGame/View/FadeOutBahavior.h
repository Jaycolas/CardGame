//
//  FadeOutBahavior.h
//  CardGame
//
//  Created by Nan Shen on 15/2/20.
//  Copyright (c) 2015年 Nan Shen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FadeOutBahavior : UIDynamicBehavior

- (void) removeItem: (id<UIDynamicItem>) item;
- (void) addItem: (id<UIDynamicItem>) item;

@end
