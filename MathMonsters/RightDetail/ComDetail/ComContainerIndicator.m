//
//  ComContainerIndicator.m
//  MathMonsters
//
//  Created by Xcode on 13-11-8.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//

#import "ComContainerIndicator.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation ComContainerIndicator

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        
    }
    return self;
}

-(void)drawRect:(CGRect)rect{
    [self setBackgroundColor:[Utiles colorWithHexString:@"#291912"]];
    [self addImgView:[self.comInfo objectForKey:@"comanylogourl"] frame:CGRectMake(30,13,70,38)];
    [self addLabel:[NSString stringWithFormat:@"%@(%@.%@)",[self.comInfo objectForKey:@"companyname"],[self.comInfo objectForKey:@"stockcode"],[self.comInfo objectForKey:@"market"]] frame:CGRectMake(150,10,300,40)];
    [self addLabel:[NSString stringWithFormat:@"市场价:%.2f",[[self.comInfo objectForKey:@"marketprice"] floatValue]] frame:CGRectMake(470,10,160,40)];
    [self addLabel:[NSString stringWithFormat:@"估股价:%.2f",[[self.comInfo objectForKey:@"googuuprice"] floatValue]] frame:CGRectMake(650,10,160,40)];
    
    NSNumber *gPriceStr=[self.comInfo objectForKey:@"googuuprice"];
    float g=[gPriceStr floatValue];
    NSNumber *priceStr=[self.comInfo objectForKey:@"marketprice"];
    float p = [priceStr floatValue];
    float outLook=(g-p)/p;
    UILabel *outLookLabel=[self addLabel:[NSString stringWithFormat:@"%.2f%%",outLook*100] frame:CGRectMake(870,10,80,40)];
    if (outLook>=0) {
        [outLookLabel setBackgroundColor:[Utiles colorWithHexString:@"#BA0020"]];
    } else {
        [outLookLabel setBackgroundColor:[Utiles colorWithHexString:@"#36871A"]];
    }
}

-(void)addImgView:(NSString *)url frame:(CGRect)rect{
    
    UIImageView *iconView=[[[UIImageView alloc] initWithFrame:rect] autorelease];

    if ([Utiles isBlankString:url]) {
        UILabel *substitute = [[[UILabel alloc] initWithFrame:CGRectMake(30,13,70,38)] autorelease];
        [substitute setBackgroundColor:[UIColor whiteColor]];
        [substitute setText:self.comInfo[@"companyname"]];
        substitute.layer.cornerRadius=3.0;
        [self addSubview:substitute];
    } else {
        [iconView setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"icon"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
            if (!image){
                UILabel *substitute = [[[UILabel alloc] initWithFrame:CGRectMake(30,13,70,38)] autorelease];
                [substitute setBackgroundColor:[UIColor whiteColor]];
                [substitute setText:self.comInfo[@"companyname"]];
                substitute.layer.cornerRadius=3.0;
            }
        }];
    }

    [self addSubview:iconView];
    
}

-(UILabel *)addLabel:(NSString *)name frame:(CGRect)frame{
    UILabel *label=[[[UILabel alloc] initWithFrame:frame] autorelease];
    [label setText:name];
    [label setFont:[UIFont fontWithName:@"Heiti SC" size:20.0]];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setTextColor:[Utiles colorWithHexString:@"#e6cbc0"]];
    [self addSubview:label];
    return label;
}















@end
