//
//  SetCardGameViewController.m
//  Matchismo
//
//  Created by Nan Shen on 14/10/19.
//  Copyright (c) 2014年 Nan Shen. All rights reserved.
//

#import "SetCardGameViewController.h"
#import "SetCardDeck.h"
#import "SetCardView.h"

@interface SetCardGameViewController ()

@property (strong, nonatomic) NSMutableAttributedString * historyText;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;


@end

@implementation SetCardGameViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    //By default, game mode is set to 3 cards matching.
    
    self.game.gameMode = THREE_CARDS_MATHCING;

    // Do any additional setup after loading the view.
}

- (void)cardViewSpecificMethod
{
    /*i is the index for newly added card view*/
    int i = 0;
    
    for (SetCardView * setCardView in self.cardViews) {
        
        /*Set the alpha value if the */
        if (setCardView.card.isChosen) {
            [setCardView setAlpha:0.5];
            if (setCardView.card.isMatched) {
                setCardView.card = [self.game.newlyArrivedCards objectAtIndex:i];
                i++;
            }
        }
        else
        {
            [setCardView setAlpha:1.0];
        }
    }
    
    self.game.gameMode = THREE_CARDS_MATHCING;
}




- (SetCardDeck *)createDeck
{
    return [[SetCardDeck alloc] init];
}


- (SetCardView *)createCardView: (CGRect)cardViewFrame
{
    return [[SetCardView alloc]initWithFrame:cardViewFrame];
}




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
