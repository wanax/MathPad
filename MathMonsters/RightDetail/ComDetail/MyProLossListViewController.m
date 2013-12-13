//
//  MyProLossListViewController.m
//  MathMonsters
//
//  Created by Xcode on 13-11-19.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//

#import "MyProLossListViewController.h"
#import "MyProLossCell.h"

@interface MyProLossListViewController ()

@end

@implementation MyProLossListViewController

- (id)initWithClassArr:(NSArray *)classArr andRangDic:(NSDictionary *)rangeDic
{
    self = [super init];
    if (self) {
        
        self.rangeDic=rangeDic;
        self.proLossArr=classArr;
        
        //初始化损益表年份指示牌
        NSNumberFormatter *formatter=[[[NSNumberFormatter alloc] init] autorelease];
        [formatter setPositiveFormat:@"00"];
        NSMutableArray *temp=[[[NSMutableArray alloc] init] autorelease];
        
        for(int i=[rangeDic[@"begin"] integerValue];i<=[rangeDic[@"end"] integerValue];i++){
            [temp addObject:[formatter stringFromNumber:[NSNumber numberWithFloat:(i)]]];
        }
        self.yearArr=temp;
        
        //初始化价格年份字典数组
        /*
         建立一个字典数组，针对每一个种类如“营业收入”，“毛利”等建立年份-值字典。
         即从classArr取对应的种类的array，将此array里的y-v形成键值对，
         一个种类的数组构造一个字典,遍历所有的种类创建年份-值的种类字典数组.
         
         此步后，我们有了yearArr的06-22的年份指示牌，有了06-22每个种类的年份-值字典，
         并通过上级的初始化得到每个具体table页面应该显示的范围rangeDic。
         
         在下面的table cell的信息填充中，通过indexPath.row得到相应的种类字典，
         然后再通过rangeDic的begin与count取出该table所应显示的范围填写至cell中。
         
         ps:这是一个很屎的数据结构，由它长长的注释就可以发现，希望以后可以不用再碰到它了。
         pps:2013-12-13 我又回到了此处...
         */
        NSMutableArray *arr=[[[NSMutableArray alloc] init] autorelease];
        for(id obj in classArr){
            if([obj[@"unit"] isEqualToString:@"1000.0"]){
                [formatter setPositiveFormat:@"#,###"];
            }else if([obj[@"unit"] isEqualToString:@"%"]){
                [formatter setPositiveFormat:@"0.00%;0.00%;-0.00%"];
            }else if([obj[@"unit"] isEqualToString:@"1.0"]){
                [formatter setPositiveFormat:@"##0.0"];
            } else if ([obj[@"unit"] isEqualToString:@"1000000.0"]){
                [formatter setPositiveFormat:@"#,###',000'"];
            }
            NSMutableDictionary *dic=[[[NSMutableDictionary alloc] init] autorelease];
            for(id valueData in obj[@"array"]){
                [dic setValue:[formatter stringFromNumber:valueData[@"v"]] forKey:valueData[@"y"]];
            }
            [arr addObject:dic];
        }
        self.yearToValueDicArr=arr;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self initComponents];
}

-(void)initComponents{
    
    UITableView *temp=[[[UITableView alloc] initWithFrame:CGRectMake(0,0,1024,610)] autorelease];
    temp.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.proLossTable=temp;
    self.proLossTable.dataSource=self;
    self.proLossTable.delegate=self;
    [self.view addSubview:self.proLossTable];
    
}

#pragma mark -
#pragma Scroller Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.delegate theTableIsScroll:scrollView.contentOffset];
}

#pragma mark -
#pragma mark Table Data Source

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.proLossArr count]+1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (void)tableView: (UITableView*)tableView willDisplayCell: (UITableViewCell*)cell forRowAtIndexPath: (NSIndexPath*)indexPath{
    MyProLossCell *c=(MyProLossCell *)cell;
    if (indexPath.row%2==0) {
        c.backgroundColor=[Utiles colorWithHexString:@"#d3e9ff"];
    } else {
        c.backgroundColor=[UIColor whiteColor];
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *MyProLossCellIdentifier = @"MyProLossCellIdentifier";
    MyProLossCell *cell = (MyProLossCell*)[tableView dequeueReusableCellWithIdentifier:MyProLossCellIdentifier];//复用cell
    
    if (cell == nil) {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"MyProLossCell" owner:self options:nil];//加载自定义cell的xib文件
        cell = [array objectAtIndex:0];
    }
    if (indexPath.row==0) {
        cell.label0.text=@"种类(单位:1000)";
        
        NSArray *labels = @[cell.label1,cell.label2,cell.label3,cell.label4,cell.label5,cell.label6];
        for (int n = 0;n < [self.yearArr count]; n++) {
            ((UILabel *)labels[n]).text = self.yearArr[n];
        }
        
    } else {
        
        cell.label0.text=[self.proLossArr objectAtIndex:(indexPath.row-1)][@"name"];
        cell.label0.lineBreakMode=NSLineBreakByCharWrapping;
        cell.label0.numberOfLines=2;
        
        NSNumberFormatter *formatter=[[[NSNumberFormatter alloc] init] autorelease];
        [formatter setPositiveFormat:@"00"];
        id valueDic=[self.yearToValueDicArr objectAtIndex:(indexPath.row-1)];
        NSArray *labels = @[cell.label1,cell.label2,cell.label3,cell.label4,cell.label5,cell.label6];
        if ([valueDic count] > 1) {
            
            for (int n = 0;n < [self.yearArr count]; n++) {
                ((UILabel *)labels[n]).text = valueDic[[formatter stringFromNumber:[NSNumber numberWithFloat:([self.rangeDic[@"begin"] floatValue]+n)]]];
            }
            
        } else {
            id key = [valueDic allKeys][0];
            cell.label1.text = valueDic[key];
            for (int i = 1;i < [labels count]; i++) {
                ((UILabel *)labels[i]).text = @"";
            }
        }
    }

    return cell;
    
}

#pragma mark -
#pragma mark Table Delegate Methods







- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
