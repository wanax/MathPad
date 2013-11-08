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
        
        [self setBackgroundColor:[Utiles colorWithHexString:@"#291912"]];
        [self addLabel:@"上市公司" frame:CGRectMake(34,10,160,40)];
        [self addLabel:@"关注收藏" frame:CGRectMake(148,10,160,40)];
        [self addLabel:@"公司名称(代码)" frame:CGRectMake(285,10,160,40)];
        [self addLabel:@"市场价VS估股价" frame:CGRectMake(540,10,160,40)];
        [self addLabel:@"潜在空间" frame:CGRectMake(800,10,160,40)];
    }
    return self;
}

-(void)addLabel:(NSString *)name frame:(CGRect)frame{
    UILabel *label=[[[UILabel alloc] initWithFrame:frame] autorelease];
    [label setText:name];
    [label setFont:[UIFont fontWithName:@"Heiti SC" size:18]];
    [label setTextColor:[Utiles colorWithHexString:@"#e6cbc0"]];
    [self addSubview:label];
}


@end
