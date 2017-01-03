//
//  ViewController.m
//  ScrollViewDemo
//
//  Created by 海涛 黎 on 16/12/27.
//  Copyright © 2016年 Levi. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UINavigationBar *naviBar;
@property (strong, nonatomic) UINavigationItem *firstNavigationItem;
@property (strong, nonatomic) UINavigationItem *secondNaviItem;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake(0, 20, self.view.frame.size.width, 44)];
    [btn setBackgroundColor:[UIColor lightGrayColor]];
    [btn addTarget:self action:@selector(showFilterView:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    CGFloat viewHeight = 300;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, viewHeight)];
    view.tag = 101;
    [self.view addSubview:view];
    
    [self.naviBar setItems:@[self.firstNavigationItem]];
    [view addSubview:self.naviBar];
    
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 44, self.view.frame.size.width, view.frame.size.height - 44)];
    _scrollView.contentSize=CGSizeMake(self.view.bounds.size.width*2, _scrollView.bounds.size.height);//计算ScroollView需要的大小
    _scrollView.showsHorizontalScrollIndicator=NO;  //不显示水平滑动线
    _scrollView.showsVerticalScrollIndicator  =NO;  //不显示垂直滑动线
    _scrollView.pagingEnabled=YES;                  //scrollView不会停在页面之间，即只会显示第一页或者第二页，不会各一半显示
    _scrollView.scrollEnabled = NO;
     [view addSubview:_scrollView];
    
    
    UITableView *table1 = [[UITableView alloc] initWithFrame:CGRectMake(0,0, _scrollView.frame.size.width, _scrollView.frame.size.height)];
    table1.delegate = self;
    table1.dataSource = self;
    [_scrollView addSubview:table1];
    
    UITableView *table2 = [[UITableView alloc] initWithFrame:CGRectMake(_scrollView.frame.size.width, table1.frame.origin.y, _scrollView.frame.size.width, table1.frame.size.height)];
    table2.backgroundColor = [UIColor blueColor];
    [_scrollView addSubview:table2];
}

-(void)showFilterView:(id)sender{
    UIView *view = [self.view viewWithTag:101];
    CGFloat viewHeight = 300;
    [UIView animateWithDuration:0.2 animations:^{
        view.frame = CGRectMake(0, self.view.frame.size.height - viewHeight, self.view.frame.size.width, viewHeight);
    }];
}

-(void)hideFilter:(id)sender{
    UIView *view = [self.view viewWithTag:101];
    CGFloat viewHeight = 300;
    [UIView animateWithDuration:0.15 animations:^{
        view.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, viewHeight);
    }];
}

-(UINavigationBar *)naviBar{
    if (!_naviBar) {
        _naviBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    }
    return _naviBar;
}

-(UINavigationItem *)firstNavigationItem{
    if (!_firstNavigationItem) {
        _firstNavigationItem = [[UINavigationItem alloc] initWithTitle:@"First Title"];
//        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStylePlain target:self action:@selector(gotoNextView:)];
//        _firstNavigationItem.rightBarButtonItem = rightItem;
    }
    return _firstNavigationItem;
}

-(UINavigationItem *)secondNaviItem{
    if (!_secondNaviItem) {
        _secondNaviItem = [[UINavigationItem alloc] initWithTitle:@"Second Title"];
        UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(backToFirstView)];
        _secondNaviItem.leftBarButtonItem = leftItem;
        
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(hideFilter:)];
        _secondNaviItem.rightBarButtonItem = rightItem;
    }
    return _secondNaviItem;
}

-(void)backToFirstView{
    [_scrollView setContentOffset:CGPointMake(0, _scrollView.contentOffset.y) animated:YES];
    [self.naviBar popNavigationItemAnimated:YES];
}

-(void)gotoNextView:(id)sender{
    if (sender != nil) {
        UINavigationItem *ss = (UINavigationItem*)sender;
        [self.secondNaviItem setTitle:ss.title];
    }
    [self.naviBar pushNavigationItem:self.secondNaviItem animated:YES];
    [_scrollView setContentOffset:CGPointMake(self.view.frame.size.width, _scrollView.contentOffset.y) animated:YES];
}


-(void)scroolViewWithBtn:(UIButton*)sender{
    CGPoint point = _scrollView.contentOffset;
    if (point.x >0) {
        [_scrollView setContentOffset:CGPointMake(0, _scrollView.contentOffset.y) animated:YES];
    } else {
        [_scrollView setContentOffset:CGPointMake(self.view.frame.size.width, _scrollView.contentOffset.y) animated:YES];
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.textLabel.text = @"条件筛选";
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [self.secondNaviItem setTitle:cell.textLabel.text];
    [self gotoNextView:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
