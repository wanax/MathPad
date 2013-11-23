//
//  ValueModelCell2.m
//  MathMonsters
//
//  Created by Xcode on 13-11-21.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//

#import "ValueModelCell2.h"

@implementation ValueModelCell2

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.row00=[self addLabel:CGRectMake(10, 0, 42, 12)];
        self.row10=[self addLabel:CGRectMake(10, 15, 42, 12)];
        self.row20=[self addLabel:CGRectMake(10, 30, 42, 12)];
        self.row30=[self addLabel:CGRectMake(10, 45, 42, 12)];
        
        self.row01=[self addLabel:CGRectMake(223, 0, 42, 12)];
        self.row11=[self addLabel:CGRectMake(223, 15, 42, 12)];
        self.row21=[self addLabel:CGRectMake(223, 30, 42, 12)];
        self.row31=[self addLabel:CGRectMake(223, 45, 42, 12)];
        
        self.row02=[self addLabel:CGRectMake(275, 0, 42, 12)];
        self.row12=[self addLabel:CGRectMake(275, 15, 42, 12)];
        self.row22=[self addLabel:CGRectMake(275, 30, 42, 12)];
        self.row32=[self addLabel:CGRectMake(275, 45, 42, 12)];
        
        self.row03=[self addLabel:CGRectMake(475, 0, 42, 12)];
        self.row13=[self addLabel:CGRectMake(475, 15, 42, 12)];
        self.row23=[self addLabel:CGRectMake(475, 30, 42, 12)];
        self.row33=[self addLabel:CGRectMake(475, 45, 42, 12)];
        
        self.row04=[self addLabel:CGRectMake(522, 0, 42, 12)];
        self.row14=[self addLabel:CGRectMake(522, 15, 42, 12)];
        self.row24=[self addLabel:CGRectMake(522, 30, 42, 12)];
        self.row34=[self addLabel:CGRectMake(522, 45, 42, 12)];
        
        self.row05=[self addLabel:CGRectMake(743, 0, 42, 12)];
        self.row15=[self addLabel:CGRectMake(743, 15, 42, 12)];
        self.row25=[self addLabel:CGRectMake(743, 30, 42, 12)];
        self.row35=[self addLabel:CGRectMake(743, 45, 42, 12)];
        
    }
    return self;
}

-(UILabel *)addLabel:(CGRect)frame{
    UILabel *label=[[[UILabel alloc] initWithFrame:frame] autorelease];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setFont:[UIFont fontWithName:@"Heiti SC" size:9]];
    [label setTextColor:[UIColor whiteColor]];
    [label setBackgroundColor:[UIColor clearColor]];
    [self addSubview:label];
    return label;
}

-(void)drawRect:(CGRect)rect{
    
    

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
