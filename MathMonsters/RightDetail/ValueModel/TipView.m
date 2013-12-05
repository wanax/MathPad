//
//  TipView.m
//  MathMonsters
//
//  Created by Xcode on 13-12-5.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//

#import "TipView.h"

@implementation TipView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor=[UIColor blackColor];
        self.alpha=0.5;
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetRGBStrokeColor(context,1,1,1,1.0);
    CGContextSetRGBFillColor (context,  1, 0, 0, 1.0);//设置填充颜色
    CGPoint sPoints[3];//坐标点
    sPoints[0] =CGPointMake(300, 220);//坐标1
    sPoints[1] =CGPointMake(340, 190);//坐标2
    sPoints[2] =CGPointMake(340, 250);//坐标3
    CGContextAddLines(context, sPoints, 3);//添加线
    CGContextClosePath(context);//封起来
    CGContextDrawPath(context, kCGPathFillStroke); //根据坐标绘制路径
    
    CGContextAddRect(context,CGRectMake(340, 210, 150, 20));//画方框
    CGContextDrawPath(context, kCGPathFillStroke);
    
    CGContextSetLineWidth(context,3.0);
    [@"向右滑动试试" drawInRect:CGRectMake(340, 140, 200, 40)
                    withAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Heiti SC" size:30.0],
                                     NSForegroundColorAttributeName:[UIColor amethystColor]}];

}

@end
