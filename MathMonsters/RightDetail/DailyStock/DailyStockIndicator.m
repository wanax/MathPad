//
//  DailyStockIndicator.m
//  MathMonsters
//
//  Created by Xcode on 13-10-28.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//

#import "DailyStockIndicator.h"
#import "AMProgressView.h"

@implementation DailyStockIndicator

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        UIImageView *image=[[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dailyBackImg"]] autorelease];
        self.comIconView=image;
        self.comIconView.frame=CGRectMake(17,8,150,75);
        [self addSubview:self.comIconView];
        
        self.comNameButton=[self addButton:@"" frame:CGRectMake(200,15,200,50)];
        
        self.marketLabel=[self addLabel:@"市场价" frame:CGRectMake(470,15,50,20) size:14.0];
        self.googuuLabel=[self addLabel:@"估股价" frame:CGRectMake(470,48,50,20) size:14.0];
        
        self.googuuPriLabel=[self addLabel:@"" frame:CGRectMake(730,48,50,20) size:14.0];
        self.marketPriLabel=[self addLabel:@"" frame:CGRectMake(730,15,50,20) size:14.0];
        
        AMProgressView *a1=[[[AMProgressView alloc] initWithFrame:CGRectMake(520, 15, 200, 18)
                                                andGradientColors:[NSArray arrayWithObjects:[UIColor peterRiverColor], nil]
                                                 andOutsideBorder:NO
                                                      andVertical:NO] autorelease];
        self.marketProgress = a1;
        self.marketProgress.minimumValue=0;
        self.marketProgress.maximumValue=10;
        self.marketProgress.progress=8;
        self.marketProgress.emptyPartAlpha = 1.0f;
        [self addSubview:self.marketProgress];
        
        AMProgressView *a2=[[[AMProgressView alloc] initWithFrame:CGRectMake(520, 50, 200, 18)
                                                andGradientColors:[NSArray arrayWithObjects:[UIColor orangeColor], nil]
                                                 andOutsideBorder:NO
                                                      andVertical:NO] autorelease];
        self.googuuProgress = a2;
        self.googuuProgress.emptyPartAlpha = 1.0f;
        [self addSubview:self.googuuProgress];
        self.googuuProgress.minimumValue=0;
        self.googuuProgress.maximumValue=10;
        self.googuuProgress.progress=4;
        
        [self addLabel:@"潜在空间" frame:CGRectMake(805,5,73,20) size:18.0];
        self.outLookLabel=[self addLabel:@"潜在空间" frame:CGRectMake(805,35,73,34) size:18.0];
        [self.outLookLabel setBackgroundColor:[Utiles colorWithHexString:@"#3BDE56"]];
        [self.outLookLabel setTextColor:[UIColor whiteColor]];
        self.outLookLabel.layer.cornerRadius=3.0;
        self.outLookLabel.layer.borderWidth=0;
    }
    return self;
}

-(UIButton *)addButton:(NSString *)name frame:(CGRect)rect{
    UIButton *bt=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    bt.frame=rect;
    [bt setTitle:name forState:UIControlStateNormal];
    bt.titleLabel.font=[UIFont fontWithName:@"Heiti SC" size:21.0];
    [bt setTintColor:[Utiles colorWithHexString:@"#e6cbc0"]];
    bt.titleLabel.textAlignment=NSTextAlignmentCenter;
    bt.titleLabel.numberOfLines=0;
    bt.titleLabel.lineBreakMode=NSLineBreakByCharWrapping;
    [self addSubview:bt];
    return bt;
}

-(UILabel *)addLabel:(NSString *)name frame:(CGRect)frame size:(float)size{
    UILabel *label=[[[UILabel alloc] initWithFrame:frame] autorelease];
    [label setText:name];
    [label setFont:[UIFont fontWithName:@"Heiti SC" size:size]];
    [label setTextColor:[Utiles colorWithHexString:@"#e6cbc0"]];
    [label setTextAlignment:NSTextAlignmentCenter];
    [self addSubview:label];
    return  label;
}

@end
