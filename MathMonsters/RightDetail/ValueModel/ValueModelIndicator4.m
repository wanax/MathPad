//
//  ValueModelIndicator4.m
//  MathMonsters
//
//  Created by Xcode on 13-11-25.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//

#import "ValueModelIndicator4.h"

@implementation ValueModelIndicator4

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[Utiles colorWithHexString:@"#291912"]];
        [self addLabel:@"流动比率" frame:CGRectMake(0,0,263,60)];
        [self addLabel:@"建议折现率" frame:CGRectMake(263,0,150,60)];
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
