//
//  SettingMenuViewController.m
//  REFrostedViewControllerExample
//
//  Created by Roman Efimov on 9/18/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import "SettingMenuViewController.h"
#import "UIViewController+REFrostedViewController.h"
#import "ClientLoginViewController.h"
#import "Cell1.h"
#import "Cell2.h"
#import "SettingCell.h"
#import "FeedBackViewController.h"
#import "DisclaimersViewController.h"
#import "AboutUsViewController.h"

@implementation SettingMenuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.sections = @[@"登录/注册",@"清除缓存",@"意见反馈",@"新版本检测",@"使用说明",@"免责声明",@"关于我们"];
    
    UITableView *teT=[[[UITableView alloc] initWithFrame:CGRectMake(0,0,200,768)] autorelease];
    self.cusTable=teT;
    self.cusTable.separatorColor = [UIColor colorWithRed:150/255.0f green:161/255.0f blue:177/255.0f alpha:1.0f];
    self.cusTable.delegate = self;
    self.cusTable.dataSource = self;
    self.cusTable.opaque = NO;
    self.cusTable.backgroundColor = [UIColor clearColor];
    self.cusTable.tableHeaderView = ({
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 184.0f)];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 40, 100, 100)];
        imageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        imageView.image = [UIImage imageNamed:@"icon"];
        imageView.layer.masksToBounds = YES;
        imageView.layer.cornerRadius = 50.0;
        imageView.layer.borderColor = [UIColor whiteColor].CGColor;
        imageView.layer.borderWidth = 3.0f;
        imageView.layer.rasterizationScale = [UIScreen mainScreen].scale;
        imageView.layer.shouldRasterize = YES;
        imageView.clipsToBounds = YES;
        
        UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(0, 150, 0, 24)] autorelease];
        label.text = @"设置";
        label.font = [UIFont fontWithName:@"HelveticaNeue" size:21];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor colorWithRed:62/255.0f green:68/255.0f blue:75/255.0f alpha:1.0f];
        [label sizeToFit];
        label.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        
        [view addSubview:imageView];
        [view addSubview:label];
        view;
    });
    self.cusTable.sectionFooterHeight = 0;
    self.cusTable.sectionHeaderHeight = 0;
    self.isOpen = NO;
    [self.view addSubview:self.cusTable];
}


#pragma mark - Table view data source

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor colorWithRed:62/255.0f green:68/255.0f blue:75/255.0f alpha:1.0f];
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:17];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.sections count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.isOpen) {
        if (self.selectIndex.section == section) {
            return 2;
        }
    }
    return 1;
}

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isOpen&&self.selectIndex.section == indexPath.section&&indexPath.row!=0) {
        
        if (indexPath.section == 3) {
            
            static NSString *CellIdentifier = @"SettingCellIdentifier";
            SettingCell *cell = (SettingCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if (!cell) {
                cell = [[[SettingCell alloc] initWithReuseIdentifier:CellIdentifier cellName:self.sections[indexPath.section]] autorelease];
            }

            return cell;
            
        } else {
            static NSString *CellIdentifier = @"Cell2";
            UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if (!cell) {
                cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
            }
            cell.textLabel.text = @"subtitle";
            return cell;
        }

    }else{
        static NSString *CellIdentifier = @"Cell1";
        UITableViewCell *cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        }

        cell.textLabel.text = self.sections[indexPath.section];

        return cell;
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UINavigationController *navigationController = (UINavigationController *)self.frostedViewController.contentViewController;
    if (indexPath.section == 0) {

        ClientLoginViewController *homeViewController = [[[ClientLoginViewController alloc] init] autorelease];
        homeViewController.sourceType=SettingMenu;
        [navigationController pushViewController:homeViewController animated:YES];
        [self.frostedViewController hideMenuViewController];
        
    } else if (indexPath.section == 1) {
        sleep(1);
        [Utiles showToastView:self.view withTitle:nil andContent:@"清除成功" duration:1.0];
    } else if (indexPath.section == 2) {
        
        FeedBackViewController *feedBack = [[[FeedBackViewController alloc] init] autorelease];
        feedBack.modalPresentationStyle = UIModalPresentationFormSheet;
        [self presentViewController:feedBack animated:YES completion:nil];
        
    } else if (indexPath.section == 3) {
        if ([indexPath isEqual:self.selectIndex]) {
            self.isOpen = NO;
            [self didSelectCellRowFirstDo:NO nextDo:NO];
            self.selectIndex = nil;
        }else{
            if (!self.selectIndex) {
                self.selectIndex = indexPath;
                [self didSelectCellRowFirstDo:YES nextDo:NO];
            }else{
                //[self didSelectCellRowFirstDo:NO nextDo:YES];
            }
        }
    } else if (indexPath.section == 4) {
        
        DisclaimersViewController *dis = [[[DisclaimersViewController alloc] init] autorelease];
        dis.modalPresentationStyle = UIModalPresentationFormSheet;
        [self presentViewController:dis animated:YES completion:nil];
        
    } else if (indexPath.section == 5) {
        
        DisclaimersViewController *dis = [[[DisclaimersViewController alloc] init] autorelease];
        dis.modalPresentationStyle = UIModalPresentationFormSheet;
        [self presentViewController:dis animated:YES completion:nil];
        
    } else if (indexPath.section == 6) {
        
        AboutUsViewController *about = [[[AboutUsViewController alloc] init] autorelease];
        about.modalPresentationStyle = UIModalPresentationFormSheet;
        [self presentViewController:about animated:YES completion:nil];
        
    }
}


- (void)didSelectCellRowFirstDo:(BOOL)firstDoInsert nextDo:(BOOL)nextDoInsert
{
    self.isOpen = firstDoInsert;
    
    [self.cusTable beginUpdates];
    
    int section = self.selectIndex.section;
    int contentCount = 1;
	NSMutableArray* rowToInsert = [[NSMutableArray alloc] init];
	for (NSUInteger i = 1; i < contentCount + 1; i++) {
		NSIndexPath* indexPathToInsert = [NSIndexPath indexPathForRow:i inSection:section];
		[rowToInsert addObject:indexPathToInsert];
	}
	
	if (firstDoInsert){
        [self.cusTable insertRowsAtIndexPaths:rowToInsert withRowAnimation:UITableViewRowAnimationTop];
    }else{
        [self.cusTable deleteRowsAtIndexPaths:rowToInsert withRowAnimation:UITableViewRowAnimationTop];
    }
    
	[rowToInsert release];
	
	[self.cusTable endUpdates];
    if (nextDoInsert) {
        self.isOpen = YES;
        self.selectIndex = [self.cusTable indexPathForSelectedRow];
        [self didSelectCellRowFirstDo:YES nextDo:NO];
    }
    if (self.isOpen) [self.cusTable scrollToNearestSelectedRowAtScrollPosition:UITableViewScrollPositionTop animated:YES];
}

@end
