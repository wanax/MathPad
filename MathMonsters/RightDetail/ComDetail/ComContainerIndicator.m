//
//  ComContainerIndicator.m
//  MathMonsters
//
//  Created by Xcode on 13-11-8.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//

#import "ComContainerIndicator.h"
#import "UIImageView+WebCache.h"

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
    [self addLabel:[NSString stringWithFormat:@"%@(%@%@)",[self.comInfo objectForKey:@"companyname"],[self.comInfo objectForKey:@"stockcode"],[self.comInfo objectForKey:@"marketname"]] frame:CGRectMake(150,10,300,40)];
    [self addLabel:[NSString stringWithFormat:@"市场价:%@",[self.comInfo objectForKey:@"marketprice"]] frame:CGRectMake(470,10,160,40)];
    [self addLabel:[NSString stringWithFormat:@"估股价:%@",[self.comInfo objectForKey:@"googuuprice"]] frame:CGRectMake(650,10,160,40)];
    
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
    [iconView setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"icon"]];
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
