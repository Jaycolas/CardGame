//
//  PlayingCardGameViewController.m
//  Matchismo
//
//  Created by Nan Shen on 14-9-22.
//  Copyright (c) 2014年 Nan Shen. All rights reserved.
//

#import "PlayingCardGameViewController.h"
#import "PlayingCardDeck.h"
#import "PlayingCardView.h"

@interface PlayingCardGameViewController ()

@end

@implementation PlayingCardGameViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.game.gameMode = TWO_CARDS_MATCHING;
}

- (PlayingCardDeck *)createDeck
{
    return [[PlayingCardDeck alloc] init];
}


- (CardView *)createCardView: (CGRect)cardViewFrame
{
    return [[PlayingCardView alloc]initWithFrame:cardViewFrame];
}

- (void)cardViewSpecificMethod
{
    for (PlayingCardView * playingCardView in self.cardViews) {
        
        /*Polling all the playing card, if it is chosen, then set faceUp to YES*/
        if (playingCardView.card.isChosen) {
            
            if (playingCardView.faceUp == NO) {
                /*Card is not shown yet, let's make an animation*/
                /*
                [UIView transitionFromView:playingCardView toView:playingCardView duration:1 options:UIViewAnimationOptionTransitionFlipFromRight completion:^(BOOL finished){playingCardView.faceUp = YES;}];*/
                
                [UIView transitionWithView:playingCardView duration:0.3 options:UIViewAnimationOptionTransitionFlipFromRight
                    animations:^{playingCardView.faceUp = YES;}
                    completion:^(BOOL finished){/*playingCardView.faceUp = YES;*/}];

            }

        } else {
            playingCardView.faceUp = NO;
        }
        
        /*set i as index of matched cards*/
        //int i = 0;
        
        /*Set the alpha value if the */
        if (playingCardView.card.isChosen && playingCardView.card.isMatched) {
            
            /*The card has been a matched one so we need to reset the card of the view*/
            //playingCardView.card = [self.game.newlyArrivedCards objectAtIndex:i];
            //i++;
            playingCardView.faceUp = YES;
            [playingCardView setAlpha:0.5];
        }
        else
        {
            [playingCardView setAlpha:1.0];
        }
    }
    
    self.game.gameMode = TWO_CARDS_MATCHING;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
