//
//  CardView.m
//  CardGame
//
//  Created by Nan Shen on 15/1/8.
//  Copyright (c) 2015年 Nan Shen. All rights reserved.
//

#import "CardView.h"

@implementation CardView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setCard:(Card *)card
{
    _card = card;
    [self setNeedsDisplay];
}




@end
