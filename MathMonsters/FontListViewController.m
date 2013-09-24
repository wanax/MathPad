//
//  FontListViewController.m
//  MathMonsters
//
//  Created by Xcode on 13-9-16.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//

#import "FontListViewController.h"

@interface FontListViewController ()

@end

@implementation FontListViewController


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
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
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title=@"FontList";
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
    
    UITableViewCell *cell=[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
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
 
    self.selectedFontName=[self.fonts objectAtIndex:indexPath.row];
    [self.delegate fontChanged:[UIFont fontWithName:[self.fonts objectAtIndex:indexPath.row] size:15.0]];

    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
 
}

-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotate
{
    [iConsole info:@"%s",__FUNCTION__];
    return NO;
}















- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
