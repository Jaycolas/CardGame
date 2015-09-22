//
//  CardMatchingGame.m
//  Matchismo
//
//  Created by Nan Shen on 14-9-6.
//  Copyright (c) 2014年 Nan Shen. All rights reserved.
//

#import "CardMatchingGame.h"

@interface CardMatchingGame()

@property (nonatomic, readwrite) NSInteger score;
@property (nonatomic, strong) NSMutableArray * cards;

@property (nonatomic, readwrite) Card * firstCard;
@property (nonatomic, readwrite) Card * secondCard;





@end

@implementation CardMatchingGame



- (NSMutableArray *) cards
{
    if (!_cards) {
        _cards = [[NSMutableArray alloc] init];
    }
    
    return _cards;
}

- (instancetype) initWithCardCount:(NSUInteger)count usingDeck:(Deck *)deck
{
    self = [super init]; // super's designated initializer
    
    if (self) {
        for (int i=0; i<count; i++) {
            Card * card = [deck drawRandomCard];
            if (card) {
                [self.cards addObject:card];
                NSLog(@"Creating Card NO.%d, %@", i, card.contents);
            } else {
                self = nil;
                break;
            }
        }
        
        self.chosenCount = 0;
        self.cardChosen = 0;
        self.isMatchingShot = NO;
        self.currentIndex = -1;
        self.lastChosenIndex = -1;
        self.oneBeforeLastChosenIndex = -1;
        self.deck = deck;
        
    }
    
    return self;
}

- (Card *) cardAtIndex:(NSUInteger)index
{
    return (index < [self.cards count])? self.cards[index] :nil;
}

static const int MISMATCH_PENALTY = 2;
static const int MATCH_BONUS = 4;
static const int COST_TO_CHOOSE = 1;




- (void)chooseCard: (Card * )card
{
    
    self.chosenCount++;
    NSLog(@"Now chosenCount is %ld", (long)self.chosenCount);
    
    self.score -= COST_TO_CHOOSE;
    NSLog(@"Lost %d points due to choose", COST_TO_CHOOSE);
    
    
    if (!card.isMatched) {
        if (card.isChosen) {
            card.chosen = NO;
        } else {
            //match against other chosen cards
            
            switch (self.gameMode) {
                    
                case THREE_CARDS_MATHCING:
                {
                    
                    if (self.chosenCount == 1) {
                        NSLog(@"1 card has been chosen");
                        self.firstCard = card;
                        self.isMatchingShot = NO;
                        self.cardChosen = 1;
                        
                    }
                    else if (self.chosenCount ==2){
                        NSLog(@"2 cards have been chosen");
                        self.secondCard = card;
                        self.isMatchingShot = NO;
                        self.cardChosen = 2;
                    }
                    else if (self.chosenCount == 3){
                        
                        NSLog(@"3 cards have been chosen");
                        self.isMatchingShot = YES;
                        self.cardChosen = 3;
                        
                        NSArray * otherCards;
                        
                        if ((self.firstCard) && (self.secondCard)){
                            otherCards = @[self.firstCard, self.secondCard];
                            
                        }
                        else{
                            NSLog(@"1st Card and 2nd Card are all invalid");
                        }
                        
                        int matchScore = [card match:otherCards];
                        
                        if (matchScore) {
                            self.score += matchScore * MATCH_BONUS;
                            NSLog(@"Got %d points", matchScore * MATCH_BONUS);
                            self.firstCard.matched = YES;
                            self.secondCard.matched = YES;
                            card.matched = YES;
                            self.chosenCount -= 3;
                            
                            /*If these cards match, need to remove them from current played cards*/
                            /*New random cards will be picked up to add to the current game*/
                            [self removeMatchedCardsAddNewCards:self.gameMode];
                            
                            
                            
                            
                        } else {
                            self.score -= MISMATCH_PENALTY;
                            NSLog(@"Lost %d points", MISMATCH_PENALTY);
                            self.firstCard.chosen = NO;
                            self.secondCard.chosen = NO;
                            self.chosenCount -= 2;
                            self.firstCard = card;
                        }
                        
                    }
                    else {
                        
                        NSLog(@"Not able to handle this");
                        assert(0);
                        
                        
                    }
                }
                    break;
                    
                case TWO_CARDS_MATCHING:
                {
                    NSLog(@"Game is in 2 card matching mode");
                    
                    if (self.chosenCount == 1) {
                        NSLog(@"1 card has been chosen");
                        self.firstCard = card;
                        self.isMatchingShot = NO;
                        self.cardChosen = 1;
                    }
                    else if (self.chosenCount ==2){
                        
                        NSLog(@"2 cards have been chosen");
                        self.cardChosen = 2;
                        
                        self.isMatchingShot = YES;
                        int matchScore = [card match:@[self.firstCard]];
                        
                        if (matchScore) {
                            self.score += matchScore * MATCH_BONUS;
                            NSLog(@"Got %d points", matchScore * MATCH_BONUS);
                            self.firstCard.matched = YES;
                            card.matched = YES;
                            self.chosenCount -=2;
                            
                            self.curMatchPoint = matchScore;
                            
                            /*If these cards match, need to remove them from current played cards*/
                            /*New random cards will be picked up to add to the current game*/
                            [self removeMatchedCardsAddNewCards:self.gameMode];
                            
                        } else {
                            self.score -= MISMATCH_PENALTY;
                            NSLog(@"Lost %d points", MISMATCH_PENALTY);
                            self.firstCard.chosen = NO;
                            self.chosenCount -=1;
                            self.firstCard = card;
                            
                            self.curMatchPoint = (-1)*MISMATCH_PENALTY;
                        }
                        
                        
                        
                    }
                    else{
                        
                        NSLog(@"Not able to handle this");
                        assert(0);
                    }
                }
                default:
                    break;
            }
            
            
            card.chosen = YES;
            NSLog(@"Card is chosen, %@", card.contents);
            
        }
    }
}

- (NSMutableArray *)newlyArrivedCards
{
    if (!_newlyArrivedCards) {
        _newlyArrivedCards = [[NSMutableArray alloc]init];
    }
    
    return _newlyArrivedCards;
}

- (void)removeMatchedCardsAddNewCards:(enum CardGameMode) gameMode
{
    int count = 0;
    
    //There is no need to remove cards, simply replace them
    /*
    [self.cards removeObject:card];
    NSLog(@"Card %@ has been removed",card.contents);
    
    [self.cards removeObject:self.firstCard];
    NSLog(@"Card %@ has been removed",self.firstCard.contents);*/
    
    switch (gameMode) {
        case TWO_CARDS_MATCHING:
            count = 2;
            break;
        case THREE_CARDS_MATHCING:
            //[self.cards removeObject:self.secondCard];
            //NSLog(@"Card %@ has been removed", self.secondCard.contents);
            count = 3;
            break;
            
        default:
            break;
    }
    
    for (int i = 0; i<count; i++) {
        
        Card * drawedCard = [self.deck drawRandomCard];
        
        if (drawedCard) {
            
            if (i==0) {
                [self.cards setObject:drawedCard atIndexedSubscript:self.currentIndex];
            }
            else if (i==1)
            {
                [self.cards setObject:drawedCard atIndexedSubscript:self.lastChosenIndex];
            }
            else if (i==2)
            {
                [self.cards setObject:drawedCard atIndexedSubscript:self.oneBeforeLastChosenIndex];
            }
            else
            {
                NSLog(@"Invalid card count!");
                assert(0);
            }
            
            [self.newlyArrivedCards addObject:drawedCard];
            
            
            NSLog(@"Adding Card NO.%d, %@", i, drawedCard.contents);
    
            
        } else {
            NSLog(@"No cards left, please redeal");
            break;
        }
    }
    
    
    
}

- (void)chooseCardAtIndex:(NSUInteger)index
{
    
    if (index == self.lastChosenIndex) {
        NSLog(@"You clicked the same card for twice,please avoid doing that");
        return;
    }
    
    /* Last chosen index and the one before last chosen index has been set at the end of last choosing*/
    /*Now all the stuff has been done, so set the lastChosenIndex to this shot's index*/
    self.oneBeforeLastChosenIndex = self.lastChosenIndex;
    self.lastChosenIndex = self.currentIndex;
    self.currentIndex = index;
    

    Card * card = [self cardAtIndex:index];
    
    self.chosenCount++;
    NSLog(@"Now chosenCount is %ld", (long)self.chosenCount);
    
    self.score -= COST_TO_CHOOSE;
    NSLog(@"Lost %d points due to choose", COST_TO_CHOOSE);
    

    if (!card.isMatched) {
        if (card.isChosen) {
            card.chosen = NO;
        } else {
            //match against other chosen cards
            
            switch (self.gameMode) {
                    
                case THREE_CARDS_MATHCING:
                {
                    
                    if (self.chosenCount == 1) {
                        NSLog(@"1 card has been chosen");
                        self.firstCard = card;
                        self.isMatchingShot = NO;
                        self.cardChosen = 1;

                    }
                    else if (self.chosenCount ==2){
                        NSLog(@"2 cards have been chosen");
                        self.secondCard = card;
                        self.isMatchingShot = NO;
                        self.cardChosen = 2;
                    }
                    else if (self.chosenCount == 3){
                        
                        NSLog(@"3 cards have been chosen");
                        self.isMatchingShot = YES;
                        self.cardChosen = 3;
                        
                        NSArray * otherCards;
                        
                        if ((self.firstCard) && (self.secondCard)){
                            otherCards = @[self.firstCard, self.secondCard];
                            
                        }
                        else{
                            NSLog(@"1st Card and 2nd Card are all invalid");
                        }
                        
                        int matchScore = [card match:otherCards];
                        
                        if (matchScore) {
                            self.score += matchScore * MATCH_BONUS;
                            NSLog(@"Got %d points", matchScore * MATCH_BONUS);
                            self.firstCard.matched = YES;
                            self.secondCard.matched = YES;
                            card.matched = YES;
                            self.chosenCount -= 3;
                            
                            /*If these cards match, need to remove them from current played cards*/
                            /*New random cards will be picked up to add to the current game*/
                            /*It is not recommended to removed them from the Model, we can just try not showing them*/
                            [self removeMatchedCardsAddNewCards:self.gameMode];
                            
                        } else {
                            self.score -= MISMATCH_PENALTY;
                            NSLog(@"Lost %d points", MISMATCH_PENALTY);
                            self.firstCard.chosen = NO;
                            self.secondCard.chosen = NO;
                            self.chosenCount -= 2;
                            self.firstCard = card;
                        }
                        
                    }
                    else {
                        
                        NSLog(@"Not able to handle this");
                        assert(0);
                        
                       
                    }
                }
                break;
                    
                case TWO_CARDS_MATCHING:
                {
                    NSLog(@"Game is in 2 card matching mode");

                    if (self.chosenCount == 1) {
                        NSLog(@"1 card has been chosen");
                        self.firstCard = card;
                        self.isMatchingShot = NO;
                        self.cardChosen = 1;
                    }
                    else if (self.chosenCount ==2){
                        
                        NSLog(@"2 cards have been chosen");
                        self.cardChosen = 2;

                        self.isMatchingShot = YES;
                        int matchScore = [card match:@[self.firstCard]];
                        
                        if (matchScore) {
                            self.score += matchScore * MATCH_BONUS;
                            NSLog(@"Got %d points", matchScore * MATCH_BONUS);
                            self.firstCard.matched = YES;
                            card.matched = YES;
                            self.chosenCount -=2;
                            
                            self.curMatchPoint = matchScore;
                            
                            /*If these cards match, need to remove them from current played cards*/
                            /*New random cards will be picked up to add to the current game*/
                            //Do not remove it in a two cards matching game.
                            [self removeMatchedCardsAddNewCards:self.gameMode];
                            
                        } else {
                            self.score -= MISMATCH_PENALTY;
                            NSLog(@"Lost %d points", MISMATCH_PENALTY);
                            self.firstCard.chosen = NO;
                            self.chosenCount -=1;
                            self.firstCard = card;
                            
                            self.curMatchPoint = (-1)*MISMATCH_PENALTY;
                        }
                        
                        

                    }
                    else{
                        
                        NSLog(@"Not able to handle this");
                        assert(0);
                    }
                }
                default:
                    break;
            }
            

        card.chosen = YES;
        NSLog(@"Card is chosen, %@", card.contents);

        }
    }
    

}

@end
