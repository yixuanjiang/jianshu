# 仿英雄联盟首页效果（简书个人中心）
#####最近一个项目 需要用到多个tableView展现效果，顶部一个banner。和掌上英雄联盟首页，个人中心效果是一样的。完成项目，故花时间写了一个这样的demo，希望初学者能学到点东西，也能做出这样的效果。
- 话不都说，首先看一下效果图。

![效果.gif](http://upload-images.jianshu.io/upload_images/3044645-4828e1b321c3ca21.gif?imageMogr2/auto-orient/strip)
-  实现原理 底部的scrollView，上面三个tableview，结构如下：
  - scrollView
    - tableView
    - tableView
    - tableView（每个tableView顶部有一个tableheaderView，高度和最上层的headerview高度相同）
图层如下：
![C434F3C8-5491-4F6B-913C-B5DB0AE20494.png](http://upload-images.jianshu.io/upload_images/3044645-ff67aea809ffb5f0.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
- 集体实现如下：
~~~
//创建底部scrollerView
UIScrollView *tableScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    tableScrollView.contentSize = CGSizeMake(SCREEN_WIDTH * 3, 0);
    tableScrollView.pagingEnabled = YES;
    tableScrollView.delegate = self;
    tableScrollView.backgroundColor = [UIColor groupTableViewBackgroundColor];
~~~
- 创建tableView，只写了一个，另外的相同。
~~~  
NSArray *colorArr = @[[UIColor redColor], [UIColor yellowColor], [UIColor blueColor]];
    self.firstTableView = [[DetailTableViewController alloc] initWithStyle:UITableViewStylePlain];
    self.firstTableView.tableView.frame = CGRectMake(0  * SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    self.firstTableView.tableView.tag = 100;
    self.firstTableView.tableView.delegate = self;
    self.firstTableView.tableView.backgroundColor = colorArr[0];
    [self createTableHeadView:self.firstTableView.tableView];
    [tableScrollView addSubview:self.firstTableView.tableView];
~~~
- 每个tableview都创建一个tableHeaderView，背景颜色要设置为透明色，这个是实现的关键。
~~~
UIView *tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 246)];
    tableHeaderView.backgroundColor = [UIColor clearColor];
    tableView.showsVerticalScrollIndicator = NO;
    tableView.tableHeaderView = tableHeaderView;
~~~
- 然后添加顶层的view，可以是轮播图等，可以根据自己的需求修改.
- 设置顶层的view，跟随tableview一起的滚动，在scrollview代理方法中实现
~~~
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{    
if ([scrollView isEqual:_tableScrollView]) {
       return;
    }
//获取tableview的偏移量
CGFloat offsetY = scrollView.contentOffset.y;
    if (scrollView.contentOffset.y > 200) {
        self.headerView.center = CGPointMake(_headerView.center.x,  self.headerCenterY - 200);
        return;
    }
    CGFloat h = self.headerCenterY - offsetY;
//改变顶层view的位置让其根据偏移量上下移动
    self.headerView.center = CGPointMake(self.headerView.center.x, h); 
}
~~~
- scrollview结束减速的代理方法,结束拖拽的方法中同样的处理方法
~~~
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{ 
  if ([scrollView isEqual:_tableScrollView]) {
        NSInteger index = scrollView.contentOffset.x / SCREEN_WIDTH;
        [self titleClick:self.titlesView.subviews[index]];
         return;
    }
//此方法改变其他tableview偏移量的方法
[self setTableViewContentOffsetWithTag:scrollView.tag contentOffset:scrollView.contentOffset.y];
}
~~~

~~~
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
~~~
- 界面的完成，有问题可以留言给我的,需要demo的也可以联系我。
