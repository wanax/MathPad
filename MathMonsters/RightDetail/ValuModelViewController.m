//
//  ValuModelViewController.m
//  MathMonsters
//
//  Created by Xcode on 13-9-26.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//

#import "ValuModelViewController.h"
#import "ValueModelIndicator.h"
#import "ValueModelCell.h"
#import "AMProgressView.h"
#import <SDWebImage/UIImageView+WebCache.h>

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
    [self addCompanyInfo];

}

-(void)initComponents{
    
    ValueModelIndicator *indicator=[[[ValueModelIndicator alloc] initWithFrame:CGRectMake(0,0, 924, 60)] autorelease];
    [self.view addSubview:indicator];
    
    self.cusTabView=[[UITableView alloc] initWithFrame:CGRectMake(0,60,924,610)];
    self.cusTabView.delegate=self;
    self.cusTabView.dataSource=self;
    self.cusTabView.backgroundColor=[Utiles colorWithHexString:@"#472A20"];
    self.cusTabView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.cusTabView];
}
#pragma mark -
#pragma mark Net Get JSON Data

-(void)addCompanyInfo{

    [MBProgressHUD showHUDAddedTo:self.cusTabView animated:YES];
    NSDictionary *params=[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:self.marketType],@"market",self.updateTime,@"updatetime", nil];
    [Utiles getNetInfoWithPath:@"QueryAllCompany" andParams:params besidesBlock:^(id resObj){
        NSMutableArray *temp=[[[NSMutableArray alloc] init] autorelease];
        for(id obj in self.comList){
            [temp addObject:obj];
        }
        for (id data in resObj) {
            [temp addObject:data];
        }
        self.comList=temp;
        [self.cusTabView reloadData];
        self.updateTime=[[self.comList lastObject] objectForKey:@"updatetime"];
        [MBProgressHUD hideHUDForView:self.cusTabView animated:YES];
    } failure:^(AFHTTPRequestOperation *operation,NSError *error){
        [Utiles showToastView:self.view withTitle:nil andContent:@"网络异常" duration:1.5];
    }];
    
}

#pragma mark -
#pragma Table DataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.comList count];
}

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60.0;
}

- (void)tableView: (UITableView*)tableView willDisplayCell: (UITableViewCell*)cell forRowAtIndexPath: (NSIndexPath*)indexPath{
    ValueModelCell *c=(ValueModelCell *)cell;
    if (indexPath.row%2==0) {
        [c.backImg setImage:[UIImage imageNamed:@"valueModelCellBack"]];
    } else {
        [c.backImg setImage:[UIImage imageNamed:@"valueModelCellBack3"]];
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *ValueModelCellIdentifier = @"ValueModelCellIdentifier";
    ValueModelCell *cell = (ValueModelCell*)[tableView dequeueReusableCellWithIdentifier:ValueModelCellIdentifier];
    if (cell == nil) {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"ValueModelCell" owner:self options:nil];
        cell = [array objectAtIndex:0];
    }
    
    if(self.comList){
        id comInfo=[self.comList objectAtIndex:indexPath.row];
        cell.comTitleLabel.text=[comInfo objectForKey:@"companyname"]==nil?@"":[NSString stringWithFormat:@"%@\n(%@%@)",[comInfo objectForKey:@"companyname"],[comInfo objectForKey:@"stockcode"],[comInfo objectForKey:@"market"]];
        [cell.comIconImg setImageWithURL:[NSURL URLWithString:[comInfo objectForKey:@"comanylogourl"]] placeholderImage:[UIImage imageNamed:@"defaultIcon"]];
        [cell.saveImg setImage:[UIImage imageNamed:@"unsavemodel"]];
        [cell.concernImg setImage:[UIImage imageNamed:@"unconcernmodel"]];
        
        NSNumber *gPriceStr=[comInfo objectForKey:@"googuuprice"];
        float g=[gPriceStr floatValue];
        NSNumber *priceStr=[comInfo objectForKey:@"marketprice"];
        float p = [priceStr floatValue];
        float outLook=(g-p)/p;
        cell.outLookLabel.text=[NSString stringWithFormat:@"%.2f%%",outLook*100];
        if (outLook>=0) {
            [cell.outLookLabel setBackgroundColor:[Utiles colorWithHexString:@"#BA0020"]];
            [cell.outLookImg setImage:[UIImage imageNamed:@"riseup"]];
        } else {
            [cell.outLookLabel setBackgroundColor:[Utiles colorWithHexString:@"#36871A"]];
            [cell.outLookImg setImage:[UIImage imageNamed:@"down"]];
        }
        
        AMProgressView *am=[[[AMProgressView alloc] initWithFrame:CGRectMake(517, 8, 180, 18)
                            andGradientColors:[NSArray arrayWithObjects:[UIColor orangeColor], nil]
                             andOutsideBorder:NO
                                  andVertical:NO] autorelease];
        AMProgressView *am2=[[[AMProgressView alloc] initWithFrame:CGRectMake(517, 34, 180, 18)
                            andGradientColors:[NSArray arrayWithObjects:[UIColor purpleColor], nil]
                                andOutsideBorder:NO
                                     andVertical:NO] autorelease];
        [cell.contentView addSubview:am];
        [cell.contentView addSubview:am2];
        
        am.emptyPartAlpha = 1.0f;
        am.minimumValue=0;
        am.maximumValue=g+p;
        am.progress=p;
        cell.markPriLabel.text=[NSString stringWithFormat:@"%.2f",p];
        
        am2.emptyPartAlpha = 1.0f;
        am2.minimumValue=0;
        am2.maximumValue=g+p;
        am2.progress=g;
        cell.googuuPriLabel.text=[NSString stringWithFormat:@"%.2f",g];

    }

    return cell;
}


#pragma mark -
#pragma Table Delegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}














- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
