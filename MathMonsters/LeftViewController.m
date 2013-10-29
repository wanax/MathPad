//
//  LeftViewController.m
//  Demo
//
//  Created by shanghui on 13-6-19.
//  Copyright (c) 2013年 shanghui. All rights reserved.
//

#import "LeftViewController.h"
#import "MMDrawerController.h"
@implementation LeftViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    UITableView *table_view = [[UITableView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.view addSubview:table_view];
    table_view.delegate = self;
    table_view.dataSource = self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:CellIdentifier] ;
     }
    cell.textLabel.text = [NSString stringWithFormat:@"%d", indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    if (indexPath.row == 0) {
        UIViewController *center = [[UIViewController alloc] init];
        [self.mm_drawerController
         setCenterViewController:center
         withCloseAnimation:YES
         completion:nil];
    }else{
        UIViewController *center = [[UIViewController alloc] init];
        [center.view setBackgroundColor:[UIColor blueColor]];
        [self.mm_drawerController
         setCenterViewController:center
         withCloseAnimation:YES
         completion:nil];
    }

}

-(MMDrawerController*)mm_drawerController{
    if([self.parentViewController isKindOfClass:[MMDrawerController class]]){
        return (MMDrawerController*)self.parentViewController;
    }
    else if([self.parentViewController isKindOfClass:[UINavigationController class]] &&
            [self.parentViewController.parentViewController isKindOfClass:[MMDrawerController class]]){
        return (MMDrawerController*)[self.parentViewController parentViewController];
    }
    else{
        return nil;
    }
}

@end
