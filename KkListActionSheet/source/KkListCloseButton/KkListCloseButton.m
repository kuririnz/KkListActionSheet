//
//  KkListCloseButton.m
//  KkListActionSheetSample
//
//  Created by keisuke kuribayashi on 2015/10/03.
//  Copyright © 2015年 keisuke kuribayashi. All rights reserved.
//

#import "KkListCloseButton.h"

@implementation KkListCloseButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization Code
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    // Instance BezierPath
    UIBezierPath *bezierLine = [UIBezierPath bezierPath];
    
    // Instance BezierPoint
    CGRect myFrame = self.frame;
    CGSize display = [[UIScreen mainScreen] bounds].size;
    CGFloat correctionY = .0f;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        correctionY = display.width > display.height ? display.width * 0.04 : display.height * 0.06;
    } else {
        correctionY = display.width > display.height ? display.width * 0.01 : display.height * 0.04;
    }
    CGPoint leftPoint = CGPointMake(myFrame.size.width /  2 - 15, 15);
    CGPoint centerPoint = CGPointMake(myFrame.size.width / 2, myFrame.size.height - correctionY);
    CGPoint rightPoint = CGPointMake(myFrame.size.width / 2 + 15, 15);

    // write stroke
    [[UIColor lightGrayColor] setStroke];
    
    bezierLine.lineWidth = 6.0f;
    bezierLine.lineCapStyle = kCGLineCapRound;
    bezierLine.lineJoinStyle = kCGLineJoinRound;
    [bezierLine moveToPoint:leftPoint];
    [bezierLine addLineToPoint:centerPoint];
    [bezierLine addLineToPoint:rightPoint];
    [bezierLine stroke];
    
}
@end
