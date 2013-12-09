//
//  POPDViewController.m
//  popdowntable
//
//  Created by Alex Di Mango on 15/09/2013.
//  Copyright (c) 2013 Alex Di Mango. All rights reserved.
//

#import "POPDViewController.h"
#import "POPDCell.h"

#define TABLECOLOR [UIColor colorWithRed:62.0/255.0 green:76.0/255.0 blue:87.0/255.0 alpha:1.0]
#define CELLSELECTED [UIColor colorWithRed:52.0/255.0 green:64.0/255.0 blue:73.0/255.0 alpha:1.0]
#define SEPARATOR [UIColor colorWithRed:31.0/255.0 green:38.0/255.0 blue:43.0/255.0 alpha:1.0]
#define SEPSHADOW [UIColor colorWithRed:80.0/255.0 green:97.0/255.0 blue:110.0/255.0 alpha:1.0]
#define SHADOW [UIColor colorWithRed:69.0/255.0 green:84.0/255.0 blue:95.0/255.0 alpha:1.0]
#define TEXT [UIColor colorWithRed:223.0/255.0 green:223.0/255.0 blue:213.0/255.0 alpha:1.0]

static NSString *kheader = @"menuSectionHeader";
static NSString *ksubSection = @"menuSubSection";

@interface POPDViewController ()
@property NSArray *sections;
@property (strong, nonatomic) NSMutableArray *sectionsArray;
@property (strong, nonatomic) NSMutableArray *showingArray;
@end


@implementation POPDViewController
@synthesize delegate;

- (id)initWithMenuSections:(NSArray *) menuSections
{
    self = [super init];
    if (self) {
        self.sections = menuSections;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.backgroundColor = TABLECOLOR;
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    self.tableView.frame = self.view.frame;

    self.sectionsArray = [NSMutableArray new];
    self.showingArray = [NSMutableArray new];
   [self setMenuSections:self.sections];
    
}

- (void)setMenuSections:(NSArray *)menuSections{
    
    for (NSDictionary *sec in menuSections) {
        
        NSString *header = [sec objectForKey:kheader];
        NSArray *subSection = [sec objectForKey:ksubSection];

        NSMutableArray *section = [NSMutableArray new];
        [section addObject:header];
        
        for (NSString *sub in subSection) {
            [section addObject:sub];
        }
        [self.sectionsArray addObject:section];
        [self.showingArray addObject:[NSNumber numberWithBool:NO]];
    }
    
    [self.tableView reloadData];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{    
    return [self.sectionsArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{    
    if (![[self.showingArray objectAtIndex:section]boolValue]) {
        return 1;
    }
    else{
        return [[self.sectionsArray objectAtIndex:section]count];;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {

    if(indexPath.row ==0){
    if([[self.showingArray objectAtIndex:indexPath.section]boolValue]){
        [cell setBackgroundColor:CELLSELECTED];
    }else{
        [cell setBackgroundColor:[UIColor clearColor]];
    }
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"menuCell";
    
    POPDCell *cell = nil;
    cell = (POPDCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"POPDCell" owner:self options:nil];
    
    if (cell == nil) {
        cell = [topLevelObjects objectAtIndex:0];
    }
    
    cell.labelText.text = [[self.sectionsArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    cell.labelText.textColor = TEXT;
    cell.separator.backgroundColor = SEPARATOR;
    cell.sepShadow.backgroundColor = SEPSHADOW;
    cell.shadow.backgroundColor = SHADOW;

    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if([[self.showingArray objectAtIndex:indexPath.section] boolValue]){
        [self.showingArray setObject:[NSNumber numberWithBool:NO] atIndexedSubscript:indexPath.section];
    }else{
        [self.showingArray setObject:[NSNumber numberWithBool:YES] atIndexedSubscript:indexPath.section];
    }
    [tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];

    [self.delegate didSelectRowAtIndexPath:indexPath];
}



@end
