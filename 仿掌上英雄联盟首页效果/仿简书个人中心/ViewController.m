//
//  ViewController.m
//  仿简书个人中心
//
//  Created by 265g on 16/12/21.
//  Copyright © 2016年 Company. All rights reserved.
//

#import "ViewController.h"
#import "DetailTableViewController.h"
/**
 *  屏幕尺寸
 */
#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height
#define YXColor(r, g, b ,alp) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:alp]

@interface ViewController ()<UIScrollViewDelegate,UITableViewDelegate>

@property(nonatomic, strong)UIScrollView *tableScrollView;

@property (nonatomic, strong)DetailTableViewController *firstTableView;
@property (nonatomic, strong)DetailTableViewController *secondTableView;
@property (nonatomic, strong)DetailTableViewController *thirdTableView;

@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, assign) CGFloat headerCenterY;
//-------------
/** 标签栏底部的指示器 */
@property (nonatomic, strong) UIView *indicatorView;
/** 当前选中的按钮 */
@property (nonatomic, strong) UIButton *selectedButton;
/** 顶部的所有标签 */
@property (nonatomic, strong) UIView *titlesView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //创建底部scrollerView
    [self creatTableScrollView];
    
    [self createHeaderView];
}

#pragma mark - 创建底部scrollerView
- (void)creatTableScrollView
{
    //创建底部的滚动视图
    UIScrollView *tableScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    tableScrollView.contentSize = CGSizeMake(SCREEN_WIDTH * 3, 0);
    tableScrollView.pagingEnabled = YES;
    tableScrollView.delegate = self;
    tableScrollView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    NSArray *colorArr = @[[UIColor redColor], [UIColor yellowColor], [UIColor blueColor]];
    

    //---
    self.firstTableView = [[DetailTableViewController alloc] initWithStyle:UITableViewStylePlain];
    self.firstTableView.tableView.frame = CGRectMake(0  * SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    self.firstTableView.tableView.tag = 100;
    self.firstTableView.tableView.delegate = self;
    self.firstTableView.tableView.backgroundColor = colorArr[0];
    [self createTableHeadView:self.firstTableView.tableView];
    [tableScrollView addSubview:self.firstTableView.tableView];
    
    //---
    self.secondTableView = [[DetailTableViewController alloc] initWithStyle:UITableViewStylePlain];
    self.secondTableView.tableView.frame = CGRectMake(1  * SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    self.secondTableView.tableView.tag = 101;
    self.secondTableView.tableView.delegate = self;
    self.secondTableView.tableView.backgroundColor = colorArr[1];
    [self createTableHeadView:self.secondTableView.tableView];
    [tableScrollView addSubview:self.secondTableView.tableView];
    
    //---
    self.thirdTableView = [[DetailTableViewController alloc] initWithStyle:UITableViewStylePlain];
    self.thirdTableView.tableView.frame = CGRectMake(2  * SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    self.thirdTableView.tableView.tag = 102;
    self.thirdTableView.tableView.delegate = self;
    self.thirdTableView.tableView.backgroundColor = colorArr[2];
    [self createTableHeadView:self.thirdTableView.tableView];
    [tableScrollView addSubview:self.thirdTableView.tableView];
 
    
    
    self.tableScrollView = tableScrollView;
    [self.view addSubview:self.tableScrollView];
}

-(void)createTableHeadView:(UITableView *)tableView{
    
    UIView *tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 246)];
    tableHeaderView.backgroundColor = [UIColor clearColor];
    tableView.showsVerticalScrollIndicator = NO;
    tableView.tableHeaderView = tableHeaderView;
}

#pragma mark 创建上方头视图
-(void)createHeaderView{
    
    self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 246)];
    self.headerView.backgroundColor = YXColor(252, 252, 252, 1);
    self.headerCenterY = self.headerView.center.y;
    [self.view addSubview:self.headerView];
    
    self.titlesView = [[UIView alloc] initWithFrame:CGRectMake(0, 200, SCREEN_WIDTH, 46)];
    self.titlesView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.headerView addSubview:self.titlesView];
    
    //红色指示器
    self.indicatorView = [[UIView alloc] init];
    self.indicatorView.backgroundColor = [UIColor redColor];
    
    //内部的子标签
    NSArray *titles = @[@"最新", @"娱乐" ,@"官方"];
    CGFloat width = SCREEN_WIDTH / titles.count;
    CGFloat height = 46;
    
    for (NSInteger i = 0; i < titles.count; i++) {
        
        UIButton *button = [[UIButton alloc] init];
        button.backgroundColor = [UIColor clearColor];
        button.tag = i;
        button.frame = CGRectMake(i * width, 0, width, height);
        [button setTitle:titles[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor redColor] forState:UIControlStateDisabled];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        [button addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.titlesView addSubview:button];
        
        
        // 默认点击了第一个按钮
        if (i == 0) {
            button.enabled = NO;
            self.selectedButton = button;
            
            
            // 让按钮内部的label根据文字内容来计算尺寸
            [button.titleLabel sizeToFit];
            CGFloat indicatorViewW = button.titleLabel.frame.size.width;
            CGFloat indicatorViewCenterX = button.center.x;

            self.indicatorView.frame = CGRectMake(indicatorViewCenterX - indicatorViewW / 2, 44, indicatorViewW, 1);
            
        }
        
    }
    [self.titlesView addSubview:self.indicatorView];
    
}

- (void)titleClick:(UIButton *)button
{
    // 修改按钮状态
    self.selectedButton.enabled = YES;
    button.enabled = NO;
    self.selectedButton = button;
    
    // 动画
    [UIView animateWithDuration:0.25 animations:^{
        CGFloat indicatorViewW = button.titleLabel.frame.size.width;
        CGFloat indicatorViewCenterX = button.center.x;
        
        self.indicatorView.frame = CGRectMake(indicatorViewCenterX - indicatorViewW / 2, 44, indicatorViewW, 1);
    }];
    
    // 滚动
    CGPoint offset = self.tableScrollView.contentOffset;
    offset.x = button.tag * self.tableScrollView.frame.size.width;
    [self.tableScrollView setContentOffset:offset animated:YES];
}

#pragma mark scrollView
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{

    if ([scrollView isEqual:_tableScrollView]) {

        return;
    }
    
    CGFloat offsetY = scrollView.contentOffset.y;
    NSLog(@"************* %f",offsetY);

    if (scrollView.contentOffset.y > 200) {
        self.headerView.center = CGPointMake(_headerView.center.x,  self.headerCenterY - 200);
        return;
    }
    CGFloat h = self.headerCenterY - offsetY;
    self.headerView.center = CGPointMake(self.headerView.center.x, h);
    
    //解决结束刷新时候，其他tableView同步偏移
    if (scrollView.contentOffset.y == 0) {
        [self scrollViewDidEndDecelerating:scrollView];
    }
    
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSLog(@"-------%s",__func__);
    
    if ([scrollView isEqual:_tableScrollView]) {

        NSInteger index = scrollView.contentOffset.x / SCREEN_WIDTH;
        [self titleClick:self.titlesView.subviews[index]];
        
        return;
    }
    
    [self setTableViewContentOffsetWithTag:scrollView.tag contentOffset:scrollView.contentOffset.y];
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    NSLog(@"-------%s",__func__);
    
    if ([scrollView isEqual:_tableScrollView]) {
        return;
    }
    [self setTableViewContentOffsetWithTag:scrollView.tag contentOffset:scrollView.contentOffset.y];
}

//设置tableView的偏移量
-(void)setTableViewContentOffsetWithTag:(NSInteger)tag contentOffset:(CGFloat)offset{
    
    CGFloat tableViewOffset = offset;
    if(offset > 200){
        
        tableViewOffset = 200;
    }
    
    if (tag == 100) {

        [self.secondTableView.tableView setContentOffset:CGPointMake(0, tableViewOffset) animated:NO];
        [self.thirdTableView.tableView setContentOffset:CGPointMake(0, tableViewOffset) animated:NO];
        
    }else if(tag == 101){
        
        [self.firstTableView.tableView setContentOffset:CGPointMake(0, tableViewOffset) animated:NO];
        [self.thirdTableView.tableView setContentOffset:CGPointMake(0, tableViewOffset) animated:NO];
        
    }else{
        
        [self.firstTableView.tableView setContentOffset:CGPointMake(0, tableViewOffset) animated:NO];
        [self.secondTableView.tableView setContentOffset:CGPointMake(0, tableViewOffset) animated:NO];
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
