//
//  ValuModelViewController.m
//  MathMonsters
//
//  Created by Xcode on 13-9-26.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//

#import "ValuModelViewController.h"
#import "ValueModelIndicator.h"

@interface ValuModelViewController ()

@end

@implementation ValuModelViewController

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
	// Do any additional setup after loading the view.
    self.view.backgroundColor=[Utiles colorWithHexString:@"#25bfda"];
    
    [self initComponents];
    

}

-(void)initComponents{
    
    ValueModelIndicator *test=[[[ValueModelIndicator alloc] initWithFrame:CGRectMake(0,0, 924, 60)] autorelease];
    [self.view addSubview:test];
    
    self.cusTabView=[[UITableView alloc] initWithFrame:CGRectMake(0,60,924,660)];
    self.cusTabView.delegate=self;
    self.cusTabView.dataSource=self;
    [self.view addSubview:self.cusTabView];
    
}

#pragma mark -
#pragma Table DataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60.0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier=@"Cell";
    
    UITableViewCell *cell=[self.cusTabView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell==nil){
        cell=[[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }

    if (self.marketType==HK) {
        cell.textLabel.text=@"HK";
    } else if (self.marketType==NANY) {
        cell.textLabel.text=@"NANY";
    }else if (self.marketType==SZSE) {
        cell.textLabel.text=@"SZSE";
    }else if (self.marketType==SHSE) {
        cell.textLabel.text=@"SHSE";
    }
    
    cell.textLabel.font=[UIFont fontWithName:@"Heiti SC" size:17.0];

    return cell;
}


#pragma mark -
#pragma Table Delegate Methods
















- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
