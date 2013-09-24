//
//  FontSizeViewController.m
//  MathMonsters
//
//  Created by Xcode on 13-9-16.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//

#import "FontSizeViewController.h"

@interface FontSizeViewController ()

@end

@implementation FontSizeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.textView.font=self.font;
    NSInteger i=self.font.pointSize;
    self.label.text=[NSString stringWithFormat:@"%d",i];
    self.slider.value=i;
}

-(IBAction)takeInValueFrom:(id)sender{
    
    NSInteger size=((UISlider *)sender).value;
    self.font=[self.font fontWithSize:size];
    self.textView.font=self.font;
    self.label.text=[NSString stringWithFormat:@"%d",size];
    
    [self.label.text JSONString];
    
}






























- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
