//
//  MyGooGuuIndicator.m
//  MathMonsters
//
//  Created by Xcode on 13-11-25.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//

#import "MyGooGuuIndicator.h"

@implementation MyGooGuuIndicator

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setBackgroundColor:[Utiles colorWithHexString:@"#291912"]];
        [self addLabel:@"上市公司" frame:CGRectMake(0,0,135,60)];
        [self addLabel:@"关注收藏" frame:CGRectMake(135,0,100,60)];
        [self addLabel:@"公司名称(代码)" frame:CGRectMake(235,0,230,60)];
        [self addLabel:@"市场价VS估股价" frame:CGRectMake(465,0,300,60)];
        [self addLabel:@"潜在空间" frame:CGRectMake(765,0,155,60)];
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
