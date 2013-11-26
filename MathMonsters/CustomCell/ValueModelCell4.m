//
//  ValueModelCell4.m
//  MathMonsters
//
//  Created by Xcode on 13-11-21.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//

#import "ValueModelCell4.h"

@implementation ValueModelCell4

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        UIImageView *back=[[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"valueModelCellBack"]] autorelease];
        [self.contentView insertSubview:back atIndex:1];
        self.backImg=back;
        
        self.row00=[self addLabel:CGRectMake(10, 0, 42, 12)];
        self.row10=[self addLabel:CGRectMake(10, 15, 42, 12)];
        self.row20=[self addLabel:CGRectMake(10, 30, 42, 12)];
        self.row30=[self addLabel:CGRectMake(10, 45, 42, 12)];
        
        self.row01=[self addLabel:CGRectMake(223, 0, 42, 12)];
        self.row11=[self addLabel:CGRectMake(223, 15, 42, 12)];
        self.row21=[self addLabel:CGRectMake(223, 30, 42, 12)];
        self.row31=[self addLabel:CGRectMake(223, 45, 42, 12)];
        
        UILabel *label=[[[UILabel alloc] initWithFrame:CGRectMake(300,10,80, 40)] autorelease];
        [label setTextAlignment:NSTextAlignmentCenter];
        [label setFont:[UIFont fontWithName:@"Heiti SC" size:18]];
        [label setTextColor:[UIColor whiteColor]];
        [label setBackgroundColor:[UIColor orangeColor]];
        [self addSubview:label];
        self.discountRateLabel=label;
        
    }
    return self;
}

-(UILabel *)addLabel:(CGRect)frame{
    UILabel *label=[[[UILabel alloc] initWithFrame:frame] autorelease];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setFont:[UIFont fontWithName:@"Heiti SC" size:11]];
    [label setTextColor:[UIColor whiteColor]];
    [label setBackgroundColor:[UIColor clearColor]];
    [self addSubview:label];
    return label;
}

@end
