//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Nan Shen on 14-9-2.
//  Copyright (c) 2014年 Nan Shen. All rights reserved.
//

#import "CardGameViewController.h"
//#import "PlayingCard.h"
//#import "PlayingCardDeck.h"
#import "CardMatchingGame.h"
#import "Grid.h"

@interface CardGameViewController () <UIDynamicAnimatorDelegate>

@property (strong, nonatomic) UITapGestureRecognizer * tapCardGR;  //The gesture recognizer for each view
@property (strong, nonatomic) UITapGestureRecognizer * tapPiledCardsToExpand;

@property (strong, nonatomic) UIPinchGestureRecognizer * pinchAllCardsGR;

@property (strong, nonatomic) UIPanGestureRecognizer * panCardsPileGR;

@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;

@property (nonatomic) CGFloat  gridOffsetInGameView;
@property (weak, nonatomic) IBOutlet UIButton *reDealButton;

@property (strong, nonatomic) Grid * grid;

@property (strong, nonatomic) UIDynamicAnimator * animator;

@property (nonatomic, readwrite) CGPoint cardsCenter;

@property (nonatomic, readwrite) BOOL isCardsBecomeAPile;


@property (strong, nonatomic) Deck * deck;


@end

@implementation CardGameViewController

#define  X_DELTA (5)
#define  Y_DELTA (50)
#define  CARD_PART_PROPORTION  (0.8)


- (UIDynamicAnimator *)animator
{
    if (!_animator) {
        _animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.gameView];
        _animator.delegate = self;
    }
    return _animator;
}

- (UITapGestureRecognizer *)tapCardGR
{
    if (!_tapCardGR) {
        _tapCardGR = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapCardView:)];
    }
    
    return _tapCardGR;
}

- (UITapGestureRecognizer *)tapPiledCardsToExpand
{
    if (!_tapPiledCardsToExpand) {
        _tapPiledCardsToExpand = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapPiledCardsToExpandGH:)];
    }
    return _tapPiledCardsToExpand;
}

- (UIPinchGestureRecognizer *)pinchAllCardsGR
{
    if (!_pinchAllCardsGR) {
        _pinchAllCardsGR = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(pinchCardsIntoAPile:)];
    }
    
    return _pinchAllCardsGR;
}

- (UIPanGestureRecognizer *)panCardsPileGR
{
    if (!_panCardsPileGR) {
        _panCardsPileGR = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panCardsPileToSomeWhere:)];
    }
    
    return _panCardsPileGR;
}



- (Deck *)createDeck
{
    NSLog(@"createDeck is not implemented!");
    return nil;
}

- (UIView *)gameView
{
    if (!_gameView) {
        _gameView = [[UIView alloc]initWithFrame:CGRectZero];
        [_gameView setBackgroundColor:self.view.backgroundColor];
        [_gameView addGestureRecognizer:self.tapCardGR];
        [_gameView addGestureRecognizer:self.pinchAllCardsGR];
    }
    
    return _gameView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.deck = [self createDeck];
    
    /*
    CGRect gameViewZone = CGRectMake(0 + X_DELTA, 0 + Y_DELTA, self.view.bounds.size.width - 2 * X_DELTA , self.view.bounds.size.height - 2 * Y_DELTA);
    
    self.gameView = [[UIView alloc]initWithFrame:gameViewZone];
    
    [self.gameView setBackgroundColor:self.view.backgroundColor];*/
    //[self.gameView setBackgroundColor:[UIColor blueColor]];
    
    [self.view addSubview:self.gameView];
    
    /*The Tap Card recognizer*/
    //[self.gameView addGestureRecognizer:self.tapCardGR];
    
    /*The Pinch Card Recognizer*/
    //[self.gameView addGestureRecognizer:self.pinchAllCardsGR];
    
    
    /*Create the card view collections according to the Grid API*/
    [self createGridsAndFitCardViews:self.cardInitCount];
    
    /*Assign the card for each card view*/
    [self assignCard2CardView];
    
    /*We consider it as the center for all the cards, will use it when try to pinch all cards into a pile*/
    self.cardsCenter = CGPointMake(155, 140);
    
    /*Of course at the very beginning cards have not become a pile*/
    self.isCardsBecomeAPile = NO;
    
    for (CardView * cardView in self.cardViews) {
        [self.gameView addSubview:cardView];
    }
    
    
    
    [self.view bringSubviewToFront:self.reDealButton];
    [self.view bringSubviewToFront:self.scoreLabel];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(adjustGrids:) name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (Grid *)grid
{
    if (!_grid) {
        _grid = [[Grid alloc]init];
        
        /*Should be a fixed ratio for each card, magic number 0.6623993*/
        //_grid.cellAspectRatio = (self.gameView.bounds.size.width)/(self.gameView.bounds.size.height);
        _grid.cellAspectRatio = 0.662393;
    }
    return _grid;
}

- (NSUInteger)cardInitCount
{
    
    /*As requested in the assignment, first set cardInitCount to 12*/
    if (_cardInitCount != 12) {
        _cardInitCount = 12;
    }
    
    return _cardInitCount;
}

- (NSMutableArray *)cardViews
{
    if (!_cardViews) {
        _cardViews = [[NSMutableArray alloc]init];
        
        for (int i =0; i<self.cardInitCount; i++) {
            /*Firstly init every cardview with CGRectZero*/
            [_cardViews addObject:[self createCardView:CGRectZero]];
        }
        
    }
    
    return _cardViews;
}

- (void)adjustGrids: (NSNotification *) notification
{
    [self createGridsAndFitCardViews:self.cardInitCount];
}


- (void) createGridsAndFitCardViews:(NSInteger )cardCount
{
    self.grid.minimumNumberOfCells = cardCount;
    
    /*The bounds here should be different according to the orientation*/
    

    CGRect gameViewZone = CGRectMake(0 + X_DELTA, 0 + Y_DELTA, self.view.bounds.size.width - 2 * X_DELTA , self.view.bounds.size.height - 2 * Y_DELTA);
    [self.gameView setFrame:gameViewZone];
    
    CGSize tempSize = self.grid.size;
    tempSize.width = self.gameView.bounds.size.width * CARD_PART_PROPORTION;
    tempSize.height = self.gameView.bounds.size.height * CARD_PART_PROPORTION;
    self.grid.size = tempSize;
    
    NSLog(@"Print self.view's width: %f, height: %f", self.view.bounds.size.width, self.view.bounds.size.height  );

    
    NSLog(@"%@",[self.grid description]);
    
    if (!self.grid.inputsAreValid) {
        assert(0);
        
    }
    
    self.gridOffsetInGameView =  (self.gameView.bounds.size.width - self.grid.size.width)/2;

    for (int i=0; i<[self.grid rowCount]; i++) {
        for (int j = 0; j< [self.grid columnCount]; j++) {
            
            CGRect cardViewZone = [self.grid frameOfCellAtRow:i inColumn:j];
            
            //To make the whole bunch of grids stay in the middle of gameView
            cardViewZone.origin.x += self.gridOffsetInGameView;
            
            //CardView * cardView = [self createCardView:cardViewZone];
            //[[CardView alloc]initWithFrame:cardViewZone];
            int k = j+i*[self.grid columnCount];
            
            if (k>=cardCount)
                break;
            
            CardView * cardView = self.cardViews[k];
            
            [UIView animateWithDuration:1 animations:^{
                [cardView setFrame:cardViewZone];
            }];
            
            
            cardView.originalCenter = cardView.center;
            
            //[cardView setBackgroundColor:[UIColor whiteColor]];
            [cardView setBackgroundColor:self.view.backgroundColor];
            
        }
    }
    

}

- (void) assignCard2CardView
{
    for (CardView * cardView in self.cardViews) {
        
        int index = (int)[self.cardViews indexOfObject:cardView];
        cardView.card = [self.game cardAtIndex:index];
        
    }
}

- (CardView *)createCardView: (CGRect)cardViewFrame
{
    return [[CardView alloc]initWithFrame:cardViewFrame];
}

- (void) tapCardView:(UITapGestureRecognizer *)sender{
    
    //int chosenButtonIndex = 1;
    //[self.cardViews[chosenButtonIndex] setBackgroundColor:[UIColor blueColor]];
    int rowNumber = 0;
    int columnNumber = 0;
    int chosenIndex = -1;
    CGPoint touchPoint = [sender locationInView:self.gameView];
    
    if (self.isCardsBecomeAPile) {
        NSLog(@"Now Cards have become a pile, can not respond to normal Tap");
    }
    else if ((touchPoint.x < 0 + self.gridOffsetInGameView) || (touchPoint.x > self.gridOffsetInGameView + self.grid.size.width)
        || (touchPoint.y < 0) || (touchPoint.y > self.grid.size.height))
    {
        NSLog(@"Touch outside the grid");
        
    }
    else {
        
        /*Depending on the row and column number to see which one is the the card we choose*/
        columnNumber = (int)(((int)(touchPoint.x - self.gridOffsetInGameView))/((int)(self.grid.cellSize.width)));
        rowNumber = (int)(((int)(touchPoint.y)) / ((int)(self.grid.cellSize.height)));
        chosenIndex = (int)(rowNumber* (self.grid.columnCount))+ columnNumber;
        
        if (chosenIndex > self.cardInitCount - 1) {
            NSLog(@"Touch is indside the grid, but index is invalid");
        }
        else
        {
            [self.game chooseCardAtIndex:chosenIndex];
            [self cardViewSpecificMethod];
            /*Update the score in the label*/
            [self removeMatchedCardsAndAddNewOnes];
            self.scoreLabel.text = [NSString stringWithFormat:@"Score:%ld", (long)self.game.score];
        }
    }

    //[self.game chooseCard:card];
}

- (void) removeMatchedCardsAndAddNewOnes
{
    /*If this is an effecvive matching shot*/
    if (self.game.isMatchingShot && self.game.curMatchPoint > 0)
    {
        int cardCount = 0;
        
        if (self.game.gameMode == THREE_CARDS_MATHCING) {
            cardCount = 3;
        }
        else if (self.game.gameMode == TWO_CARDS_MATCHING)
        {
            cardCount = 2;
        }
        else
        {
            NSLog(@"There is no other cards mode so far, card mode = %d", self.game.gameMode);
            assert(0);
        }
        
        /*Adding animation */
        /*Adding 0.4s delay is to let user know more about matching result for a while*/
        /*The matching cards will drop from the view*/
        [UIView animateKeyframesWithDuration:0.8 delay:0.4 options:UIViewKeyframeAnimationOptionBeginFromCurrentState
        animations:^{
            CardView * cardView0 = self.cardViews[self.game.currentIndex];
            CardView * cardView1 = self.cardViews[self.game.lastChosenIndex];
            
            cardView0.center = CGPointMake(cardView0.center.x, cardView0.center.y - 500);
            cardView1.center = CGPointMake(cardView1.center.x, cardView1.center.y - 500);
            
            if (self.game.gameMode == THREE_CARDS_MATHCING) {
                CardView * cardView2 = self.cardViews[self.game.oneBeforeLastChosenIndex];
                cardView2.center = CGPointMake(cardView2.center.x, cardView2.center.y - 500);
            }
            
        }
        completion:^(BOOL finished){
            ;
                                      
        }];


    
        
        for (int i = 0; i<cardCount; i++) {
            
            int index;
            
            if (i==0) {
                index = self.game.currentIndex;
            }
            else if (i==1){
                index = self.game.lastChosenIndex;
            }
            else if (i==2){
                index = self.game.oneBeforeLastChosenIndex;
            }
            else
            {
                NSLog(@"card count can not be this value");
                assert(0);
            }
            
            CardView * cardView = [self.cardViews objectAtIndex:index];
            cardView.card = [self.game.newlyArrivedCards objectAtIndex:i];
            
            
            
        }
        
    
    /*Animation, make the dropped view come back, with the new cards set*/
    [UIView animateWithDuration:0.6 animations:^{
        CardView * cardView0 = self.cardViews[self.game.currentIndex];
        CardView * cardView1 = self.cardViews[self.game.lastChosenIndex];
        
        cardView0.center = CGPointMake(cardView0.center.x, cardView0.center.y + 500);
        [cardView0 setAlpha:1];
        cardView1.center = CGPointMake(cardView1.center.x, cardView1.center.y + 500);
        [cardView1 setAlpha:1];
        
        if (self.game.gameMode == THREE_CARDS_MATHCING) {
            CardView * cardView2 = self.cardViews[self.game.oneBeforeLastChosenIndex];
            cardView2.center = CGPointMake(cardView2.center.x, cardView2.center.y + 500);
            [cardView2 setAlpha:1];
        }
    }];
        

        
        
        
    }

}

- (void) pinchCardsIntoAPile:(UIPinchGestureRecognizer *)sender
{


    NSLog(@"Now the scale is %f", [sender scale]);

    
    
    if (sender.state == UIGestureRecognizerStateChanged) {
        
        
        [UIView animateWithDuration:0.1
                        animations:^{
            
                            for (CardView * cardView in self.cardViews) {
                
                                CGFloat x_temp = cardView.originalCenter.x + (self.cardsCenter.x - cardView.originalCenter.x)*(1-sender.scale);
                                CGFloat y_temp = cardView.originalCenter.y + (self.cardsCenter.y - cardView.originalCenter.y)*(1-sender.scale);
                
                                cardView.center = CGPointMake(x_temp, y_temp);
                
                            }
                        }
                        completion:^(BOOL finished){
                            ;
                        }
         ];

    }
    else if (sender.state == UIGestureRecognizerStateEnded)
    {
        if (sender.scale >= 0.3) {
            [UIView animateWithDuration:0.1 animations:^{
                
                /*Pinch is not enough, move them back to the original center*/
                for (CardView * cardView in self.cardViews) {
                    cardView.center = cardView.originalCenter;
                }

            } completion:^(BOOL finished) {
                
            }];
        }
        else
        {
            for (CardView * cardView in self.cardViews) {
                cardView.center = self.cardsCenter;
            }
            
            self.isCardsBecomeAPile = YES;
            
            
            /*Randomly bring the first card to the front view, only this view will respond to the PanGR*/
            [self.gameView bringSubviewToFront:[self.cardViews firstObject]];
            [[self.cardViews firstObject] addGestureRecognizer:self.panCardsPileGR];
            [[self.cardViews firstObject] addGestureRecognizer:self.tapPiledCardsToExpand];
        }
    }
}

- (void)panCardsPileToSomeWhere:(UIPanGestureRecognizer *)sender
{
    static CGPoint transBefore = {0,0};
    
    if (self.isCardsBecomeAPile) {
        
        if (sender.state == UIGestureRecognizerStateChanged) {
            
            CGPoint trans = [sender translationInView:self.gameView];
            
            CGPoint transDelta = CGPointMake(trans.x - transBefore.x, trans.y - transBefore.y);
            
            NSLog(@"Now translation according to PanGR is %f, %f, cardsCenter is %f, %f", trans.x, trans.y, self.cardsCenter.x, self.cardsCenter.y);
            
            self.cardsCenter = CGPointMake(self.cardsCenter.x + transDelta.x, self.cardsCenter.y+transDelta.y);
            
            for (CardView * cardView in self.cardViews) {
                cardView.center = self.cardsCenter;
            }
            
            transBefore = trans;
        }
        else if (sender.state == UIGestureRecognizerStateEnded)
        {
            /*When finger lifted, need to reset transBefore, for next pan gesture*/
            transBefore = CGPointMake(0, 0);
        }
    }
    else
    {
        NSLog(@"Recognized Pan, but card is not piled!");
    }

}

- (void)tapPiledCardsToExpandGH: (UITapGestureRecognizer *)sender
{
    if (self.isCardsBecomeAPile) {
        [UIView animateWithDuration:0.1 animations:^{
            for (CardView * cardView in self.cardViews) {
                cardView.center = cardView.originalCenter;
            }
        } completion:^(BOOL finished) {
            ;
        }];

        self.isCardsBecomeAPile = NO;
    }
}

- (void)cardViewSpecificMethod
{
    NSLog(@"cardViewSpecific Method, please implement it in your specific subclass");
}

- (CardMatchingGame *) game
{
    if (!_game) {
        _game = [[CardMatchingGame alloc] initWithCardCount:[self.cardViews count] usingDeck:self.deck];
    }
    
    return _game;
}

- (void)redealAnimation
{
    
    [UIView animateWithDuration:0.3
                     animations:^{
                        /*First, we need to move all the cards down by 500 pixels*/
                        for (CardView * cardView in self.cardViews) {
                            CGFloat x = cardView.center.x;
                            CGFloat y = cardView.center.y + 500;
                            cardView.center = CGPointMake(x, y);
                        }
                     }
     
                    /*At the end of the animation, start a new animation to move all the cards back to where they were*/
                     completion:^(BOOL finished) {
                         
                         if (finished) {
                             [UIView animateWithDuration:0.5 animations:^{
                                 for (CardView * cardView in self.cardViews) {
                                     CGFloat x = cardView.center.x;
                                     CGFloat y = cardView.center.y - 500;
                                     cardView.center = CGPointMake(x, y);
                                     
                                 }
                             }];
                         }
                     }
     
     ];
}

- (IBAction)resetGame:(id)sender {
    
    if (_game) {
        _game = nil;
    }
    
    /*Since the cards has been changed, need to assign the card to each cardview again*/
    [self assignCard2CardView];
    
    [self redealAnimation];
    
    [self cardViewSpecificMethod];
    
    NSLog(@"Game been reset/n");
    
    //[self resetUI];
    
}


@end
