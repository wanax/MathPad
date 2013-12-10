//
//  SettingCell.h
//  MathMonsters
//
//  Created by Xcode on 13-12-10.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingCell : UITableViewCell

@property (nonatomic,retain) NSString *name;

@property (nonatomic,retain) UISwitch *s;

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier cellName:(NSString *)name;

@end
