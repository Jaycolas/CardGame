//
//  SetCardView.m
//  CardGame
//
//  Created by Nan Shen on 15/1/7.
//  Copyright (c) 2015年 Nan Shen. All rights reserved.
//

#import "SetCardView.h"

@interface SetCardView()

@property (weak, nonatomic) SetCard * card;


@end

@implementation SetCardView

#define HEIGHT_PORTION (0.166667)
#define WIDTH_PORTION  (0.8)
#define SHADING_ALPHA  (0.2)

#pragma mark - Drawing

#define CORNER_FONT_STANDARD_HEIGHT 180.0
#define CORNER_RADIUS 12.0

- (CGFloat)cornerScaleFactor { return self.bounds.size.height / CORNER_FONT_STANDARD_HEIGHT; }
- (CGFloat)cornerRadius { return CORNER_RADIUS * [self cornerScaleFactor]; }
- (CGFloat)cornerOffset { return [self cornerRadius] / 3.0; }

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    
    // Drawing code
    
    UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:[self cornerRadius]];
    
    [roundedRect addClip];
    
    [[UIColor whiteColor] setFill];
    UIRectFill(self.bounds);
    
    [[UIColor blackColor] setStroke];
    [roundedRect stroke];
    
    CGFloat rectWidth = self.bounds.size.width * WIDTH_PORTION;
    CGFloat rectHeight = self.bounds.size.height * HEIGHT_PORTION;
    CGFloat rectOriginX = self.bounds.size.width * (1-WIDTH_PORTION)/2;
    CGFloat rectOriginY = -rectHeight * 0.5;
    
    for (int i = 0; i<self.card.number; i++) {
        rectOriginY += (self.bounds.size.height/(self.card.number+1));
        CGRect baseShape = CGRectMake(rectOriginX, rectOriginY, rectWidth, rectHeight);
        [self drawOneShot:baseShape];
    }
    


    
    
}

- (void)drawOneShot:(CGRect)baseShape
{
    UIBezierPath * outline = [[UIBezierPath alloc]init];
    
    switch (self.card.symbol) {
        case SET_CARD_SYMBOL_DIAMOND:
            outline = [self drawDiamondInView:baseShape];
            break;
            
        case SET_CARD_SYMBOL_OVAL:
            outline = [self drawOvalInView:baseShape];
            break;
            
        case SET_CARD_SYMBOL_SQUIGGLE:
            outline = [self drawSquiggleInView:baseShape];
            break;
            
        default:
            NSLog(@"Invalid symbol!");
            assert(0);
            break;
    }
    
    [self fillInColor:outline];
}

- (UIBezierPath *)drawDiamondInView:(CGRect)basedRect
{
    CGPoint diamondStart = {basedRect.origin.x, basedRect.origin.y + basedRect.size.height/2};
    CGPoint diamond2nd   = {basedRect.origin.x + basedRect.size.width/2, basedRect.origin.y};
    CGPoint diamond3rd   = {basedRect.origin.x + basedRect.size.width, basedRect.origin.y + basedRect.size.height/2};
    CGPoint diamondEnd   = {basedRect.origin.x + basedRect.size.width/2, basedRect.origin.y + basedRect.size.height};
    
    UIBezierPath * diamondBezierPath = [[UIBezierPath alloc]init];
    
    [diamondBezierPath moveToPoint:diamondStart];
    [diamondBezierPath addLineToPoint:diamond2nd];
    [diamondBezierPath addLineToPoint:diamond3rd];
    [diamondBezierPath addLineToPoint:diamondEnd];
    [diamondBezierPath closePath];
    
    diamondBezierPath.lineWidth = 1;
    
    return diamondBezierPath;
    
}

- (UIBezierPath *)drawOvalInView:(CGRect)basedRect
{
    
    UIBezierPath * ovalBezierPath = [UIBezierPath bezierPathWithOvalInRect:basedRect];
    return ovalBezierPath;

}

- (UIBezierPath *)drawSquiggleInView:(CGRect)baseRect
{
    //TODO: do not know how to draw this damn thing, let's use a rect first
    
    UIBezierPath * squiggleBezierPath = [UIBezierPath bezierPathWithRect:baseRect];
    
    return squiggleBezierPath;
}

- (void)fillInColor: (UIBezierPath *)shapeBaseRect
{
    UIColor * fillStrokeColor = [[UIColor alloc]init];
    
    switch (self.card.color) {
            
        case SET_CARD_COLOR_PURPLE:
            fillStrokeColor = [UIColor purpleColor];
            break;
            
        case SET_CARD_COLOR_BLUE:
            fillStrokeColor = [UIColor blueColor];
            break;
            
        case SET_CARD_COLOR_RED:
            fillStrokeColor = [UIColor redColor];
            break;
            
        default:
            
            NSLog(@"Color is invalid!");
            assert(0);
            break;
    }
    
    switch (self.card.shadingType) {
            
        case SOLID_SHADING:
        {
            [fillStrokeColor setFill];
            [shapeBaseRect fill];
        }
        break;
            
        case OPEN_SHADING:
        {
            [fillStrokeColor setStroke];
            [shapeBaseRect stroke];
        }
        break;
            
        case SHADING_SHADING:
        {
            [fillStrokeColor setFill];
            [shapeBaseRect fillWithBlendMode:kCGBlendModeNormal alpha:SHADING_ALPHA];
        }
        
        break;
            
        default:
            NSLog(@"Invalid shaping");
            assert(0);
            break;
    }
    
}





@end
