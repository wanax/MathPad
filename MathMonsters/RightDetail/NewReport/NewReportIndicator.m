//
//  NewReportIndicator.m
//  MathMonsters
//
//  Created by Xcode on 13-10-29.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//

#import "NewReportIndicator.h"

@implementation NewReportIndicator

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addLabel:@"业绩图文简析" frame:CGRectMake(230,15,150,30) size:20.0];
        [self addLabel:@"最新公司" frame:CGRectMake(700,15,80,30) size:20.0];
    }
    return self;
}

-(UILabel *)addLabel:(NSString *)name frame:(CGRect)frame size:(float)size{
    UILabel *label=[[[UILabel alloc] initWithFrame:frame] autorelease];
    [label setText:name];
    [label setFont:[UIFont fontWithName:@"Heiti SC" size:size]];
    label.font = [UIFont boldSystemFontOfSize:20];
    [label setTextColor:[Utiles colorWithHexString:@"#fef2eb"]];
    [label setTextAlignment:NSTextAlignmentCenter];
    [self addSubview:label];
    return  label;
}

@end
