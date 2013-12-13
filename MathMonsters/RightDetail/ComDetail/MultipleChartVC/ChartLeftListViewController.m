//
//  DiYuListViewController.m
//  IYLM
//
//  Created by Jian-Ye on 12-10-30.
//  Copyright (c) 2012年 Jian-Ye. All rights reserved.
//

#import "ChartLeftListViewController.h"
#import "Cell1.h"
#import "Cell2.h"
@interface ChartLeftListViewController()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation ChartLeftListViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    [self initComponents];
}

-(void)initComponents{

    UITableView *t=[[[UITableView alloc] initWithFrame:CGRectMake(0,0,340,610)] autorelease];
    self.expansionTableView=t;
    self.expansionTableView.dataSource=self;
    self.expansionTableView.delegate=self;
    [self.view addSubview:self.expansionTableView];
    self.expansionTableView.sectionFooterHeight = 0;
    self.expansionTableView.sectionHeaderHeight = 0;
    self.isOpen = NO;

}

#pragma mark -
#pragma ValueModelChart Methods Delegate

-(void)savedItemsHasLoaded:(NSArray *)items block:(void (^)(NSString *))block{
    self.savedRowItems=items;
    [self.expansionTableView reloadData];
    block(@"OK");
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.sectionKeys count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.isOpen) {
        if (self.selectIndex.section == section) {
            return [[self.transData objectForKey:[self.sectionKeys objectAtIndex:section]] count]+1;;
        }
    }
    return 1;
}
- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell  forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.isOpen&&self.selectIndex.section == indexPath.section&&indexPath.row!=0){
        if([self.savedRowItems containsObject:[self.transData objectForKey:[self.sectionKeys objectAtIndex:self.selectIndex.section]][indexPath.row-1][@"name"]]){
            [cell setBackgroundColor:[Utiles colorWithHexString:@"#ccd4d9"]];
        }else{
            [cell setBackgroundColor:[UIColor whiteColor]];
        }
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isOpen&&self.selectIndex.section == indexPath.section&&indexPath.row!=0) {
        static NSString *CellIdentifier = @"Cell2";
        Cell2 *cell = (Cell2*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil] objectAtIndex:0];
        }
        NSArray *list = [self.transData objectForKey:[self.sectionKeys objectAtIndex:self.selectIndex.section]];
        cell.titleLabel.text = [[list objectAtIndex:indexPath.row-1] objectForKey:@"name"];
        return cell;
    }else{
        static NSString *CellIdentifier = @"Cell1";
        Cell1 *cell = (Cell1*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil] objectAtIndex:0];
        }
        
        NSString *name = [self.sectionDic objectForKey:[self.sectionKeys objectAtIndex:indexPath.section]];
        [cell.classIcon setImage:[UIImage imageNamed:name]];
        cell.titleLabel.text = name;
        [cell changeArrowWithUp:([self.selectIndex isEqual:indexPath]?YES:NO)];
        return cell;
    }
}


#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        if ([indexPath isEqual:self.selectIndex]) {
            self.isOpen = NO;
            [self didSelectCellRowFirstDo:NO nextDo:NO];
            self.selectIndex = nil;
        }else if(indexPath.section==3){
            [self.delegate modelChanged:[NSString stringWithFormat:@"%d",DiscountRate]];
        }else{
            if (!self.selectIndex) {
                self.selectIndex = indexPath;
                [self didSelectCellRowFirstDo:YES nextDo:NO];
            }else{
                [self didSelectCellRowFirstDo:NO nextDo:YES];
            }
        }
        
    }else{
        NSArray *list = [self.transData objectForKey:[self.sectionKeys objectAtIndex:indexPath.section]];
        NSString *driverId = [[list objectAtIndex:indexPath.row-1] objectForKey:@"id"];
        [self.delegate modelChanged:driverId];
    }   
}


- (void)didSelectCellRowFirstDo:(BOOL)firstDoInsert nextDo:(BOOL)nextDoInsert
{
    self.isOpen = firstDoInsert;
    
    Cell1 *cell = (Cell1 *)[self.expansionTableView cellForRowAtIndexPath:self.selectIndex];
    [cell changeArrowWithUp:firstDoInsert];
    
    [self.expansionTableView beginUpdates];
    
    int section = self.selectIndex.section;
    int contentCount = [[self.transData objectForKey:[self.sectionKeys objectAtIndex:section]] count];
	NSMutableArray* rowToInsert = [[NSMutableArray alloc] init];
	for (NSUInteger i = 1; i < contentCount + 1; i++) {
		NSIndexPath* indexPathToInsert = [NSIndexPath indexPathForRow:i inSection:section];
		[rowToInsert addObject:indexPathToInsert];
	}
	
	if (firstDoInsert){
        [self.expansionTableView insertRowsAtIndexPaths:rowToInsert withRowAnimation:UITableViewRowAnimationTop];
    }else{
        [self.expansionTableView deleteRowsAtIndexPaths:rowToInsert withRowAnimation:UITableViewRowAnimationTop];
    }
    
	[rowToInsert release];
	
	[self.expansionTableView endUpdates];
    if (nextDoInsert) {
        self.isOpen = YES;
        self.selectIndex = [self.expansionTableView indexPathForSelectedRow];
        [self didSelectCellRowFirstDo:YES nextDo:NO];
    }
    if (self.isOpen) [self.expansionTableView scrollToNearestSelectedRowAtScrollPosition:UITableViewScrollPositionTop animated:YES];
}


@end
