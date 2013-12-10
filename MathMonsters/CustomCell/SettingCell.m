//
//  SettingCell.m
//  MathMonsters
//
//  Created by Xcode on 13-12-10.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//

#import "SettingCell.h"

@implementation SettingCell

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier cellName:(NSString *)name
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        
        UISwitch *ts = [[[UISwitch alloc] initWithFrame:CGRectMake(75,6,51,31)] autorelease];
        ts.on = [GetConfigure(@"userconfigure", name, YES) boolValue];
        [ts addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
        [self addSubview:ts];
        self.s = ts;
        self.name = name;
    }
    return self;
}

-(void)valueChanged:(UISwitch *)s {

    NSString *tag = [NSString stringWithFormat:@"%d",s.on];
    SetConfigure(@"userconfigure", self.name, tag);
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
