//
//  PopListViewController.m
//  MathMonsters
//
//  Created by Xcode on 13-9-16.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//

#import "PopListViewController.h"

@interface PopListViewController ()

@end

@implementation PopListViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    NSInteger fontIndex=[self.fonts indexOfObject:self.selectedFontName];
    if(fontIndex !=NSNotFound){
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:fontIndex inSection:0];
        [self.cusTable scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.cusTable=[[UITableView alloc] initWithFrame:CGRectMake(0,0,1024, 800)];
    self.cusTable.dataSource=self;
    self.cusTable.delegate=self;
    [self.view addSubview:self.cusTable];
	
    NSArray *familyNames=[UIFont familyNames];
    NSMutableArray *fontNames=[NSMutableArray array];
    for(NSString *family in familyNames){
        [fontNames addObjectsFromArray:[UIFont fontNamesForFamilyName:family]];
    }
    self.fonts=[fontNames sortedArrayUsingSelector:@selector(compare:)];
}


#pragma mark -
#pragma Table Data Source

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.fonts count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier=@"Cell";
    
    UITableViewCell *cell=[self.cusTable dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell==nil){
        cell=[[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    NSString *fontName=[self.fonts objectAtIndex:indexPath.row];
    cell.textLabel.text=fontName;
    cell.textLabel.font=[UIFont fontWithName:fontName size:17.0];
    if([self.selectedFontName isEqual:fontName]){
        cell.accessoryType=UITableViewCellAccessoryCheckmark;
    }else{
        cell.accessoryType=UITableViewCellAccessoryNone;
    }
    return cell;
}


#pragma mark -
#pragma Table Methods Delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSInteger previousFontIndex=[self.fonts indexOfObject:self.selectedFontName];
    
    if(previousFontIndex!=indexPath.row){
        NSArray *indexPaths=nil;
        if(previousFontIndex!=NSNotFound){
            NSIndexPath *previousHighlightedIndexPath=[NSIndexPath indexPathForRow:previousFontIndex inSection:0];
            indexPaths=[NSArray arrayWithObjects:indexPaths,previousHighlightedIndexPath, nil];
        }else{
            indexPaths=[NSArray arrayWithObjects:indexPaths, nil];
        }
        
        self.selectedFontName=[self.fonts objectAtIndex:indexPath.row];
    
        [self.cusTable reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"FontListControllerDidSelect" object:self];
        
    }
    
}














- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
