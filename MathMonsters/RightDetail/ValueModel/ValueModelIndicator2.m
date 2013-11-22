//
//  ValueModelIndicator2.m
//  MathMonsters
//
//  Created by Xcode on 13-11-21.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//

#import "ValueModelIndicator2.h"

@implementation ValueModelIndicator2

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setBackgroundColor:[Utiles colorWithHexString:@"#291912"]];
        [self addLabel:@"公司收入增长率" frame:CGRectMake(0,0,263,60)];
        [self addLabel:@"净利润增长率" frame:CGRectMake(263,0,258,60)];
        [self addLabel:@"毛利率" frame:CGRectMake(521,0,264,60)];
    }
    return self;
}

-(void)addLabel:(NSString *)name frame:(CGRect)frame{
    UILabel *label=[[[UILabel alloc] initWithFrame:frame] autorelease];
    [label setText:name];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setFont:[UIFont fontWithName:@"Heiti SC" size:18]];
    [label setTextColor:[Utiles colorWithHexString:@"#e6cbc0"]];
    [self addSubview:label];
}

@end
