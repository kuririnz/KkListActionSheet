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
    UIBezierPath *firstLine = [UIBezierPath bezierPath];
//    UIBezierPath *secondLine = [UIBezierPath bezierPath];
    
    // Instance BezierPoint
    CGRect myFrame = self.frame;
    CGPoint leftPoint = CGPointMake(myFrame.size.width /  2 - 50, 0);
    CGPoint centerPoint = CGPointMake(myFrame.size.width / 2, myFrame.size.height - 5);
    CGPoint rightPoint = CGPointMake(myFrame.size.width / 2 + 50, 0);

    // write stroke
    firstLine.lineWidth = 3.0f;
    firstLine.lineCapStyle = kCGLineCapRound;
    firstLine.lineJoinStyle = kCGLineJoinRound;
    [firstLine moveToPoint:leftPoint];
    [firstLine addLineToPoint:centerPoint];
    [firstLine addLineToPoint:rightPoint];
    [firstLine stroke];
    
//    secondLine.lineWidth = 3.0f;
//    secondLine.lineCapStyle = kCGLineCapRound;
//    secondLine.lineJoinStyle = kCGLineJoinRound;
}

@end
