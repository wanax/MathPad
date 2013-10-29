//
//  ValueModelIndicator.m
//  MathMonsters
//
//  Created by Xcode on 13-10-8.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//

#import "ValueModelIndicator.h"

@implementation ValueModelIndicator

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setBackgroundColor:[Utiles colorWithHexString:@"#25bfda"]];
        [self addLabel:@"上市公司" frame:CGRectMake(50,10,160,40)];
        [self addLabel:@"营收增长率" frame:CGRectMake(260,10,160,40)];
        [self addLabel:@"净利润增长率" frame:CGRectMake(495,10,160,40)];
        [self addLabel:@"毛利率" frame:CGRectMake(755,10,160,40)];
        
    }
    return self;
}

-(void)addLabel:(NSString *)name frame:(CGRect)frame{
    UILabel *label=[[[UILabel alloc] initWithFrame:frame] autorelease];
    [label setText:name];
    [label setFont:[UIFont fontWithName:@"Heiti SC" size:18]];
    [label setTextColor:[UIColor blackColor]];
    [self addSubview:label];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
