//
//  CardView.h
//  CardGame
//
//  Created by Nan Shen on 15/1/8.
//  Copyright (c) 2015年 Nan Shen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Card.h"

@interface CardView : UIView

@property (strong, nonatomic) Card * card;

@property (nonatomic) CGPoint originalCenter;



@end
