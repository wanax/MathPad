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

        self.comIconView=[[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dailyBackImg"]] autorelease];
        self.comIconView.frame=CGRectMake(40,26,70,36);
        [self addSubview:self.comIconView];
        
        self.comNameLabel=[self addLabel:@"" frame:CGRectMake(200,15,200,50) size:21.0];
        self.comNameLabel.numberOfLines=0;
        self.comNameLabel.lineBreakMode=NSLineBreakByCharWrapping;
        
        self.marketPriLabel=[self addLabel:@"市场价" frame:CGRectMake(470,15,50,20) size:14.0];
        self.googuuPriLabel=[self addLabel:@"估股价" frame:CGRectMake(470,48,50,20) size:14.0];
        
        self.marketProgress = [[AMProgressView alloc] initWithFrame:CGRectMake(520, 15, 200, 18)
                                                  andGradientColors:[NSArray arrayWithObjects:[UIColor orangeColor], nil]
                                                   andOutsideBorder:NO
                                                        andVertical:NO];
        self.marketProgress.minimumValue=0;
        self.marketProgress.maximumValue=10;
        self.marketProgress.progress=8;
        self.marketProgress.emptyPartAlpha = 1.0f;
        [self addSubview:self.marketProgress];
        self.googuuProgress = [[AMProgressView alloc] initWithFrame:CGRectMake(520, 50, 200, 18)
                                                  andGradientColors:[NSArray arrayWithObjects:[UIColor orangeColor], nil]
                                                   andOutsideBorder:NO
                                                        andVertical:NO];
        self.googuuProgress.emptyPartAlpha = 1.0f;
        [self addSubview:self.googuuProgress];
        self.googuuProgress.minimumValue=0;
        self.googuuProgress.maximumValue=10;
        self.googuuProgress.progress=4;
        
        self.outLookLabel=[self addLabel:@"潜在空间" frame:CGRectMake(805,25,73,34) size:18.0];
        [self.outLookLabel setBackgroundColor:[Utiles colorWithHexString:@"#3BDE56"]];
        [self.outLookLabel setTextColor:[UIColor blackColor]];
        self.outLookLabel.layer.cornerRadius=3.0;
        self.outLookLabel.layer.borderWidth=0;
    }
    return self;
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
