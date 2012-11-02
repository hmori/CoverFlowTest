//
//  CFCoverFlowViewController.m
//  CoverFlowTest
//
//  Created by Hidetoshi Mori on 12/10/26.
//  Copyright (c) 2012年 Hidetoshi Mori. All rights reserved.
//

#import "CFCoverFlowViewController.h"
#import "CFCoverFlowView.h"
#import "CFCoverFlowCell.h"


@interface CFCoverFlowViewController ()
@property (weak, nonatomic) IBOutlet CFCoverFlowView *tableView;
@property (strong, nonatomic) NSMutableArray *records;
- (void)initalize;
- (void)resetCoverFlowView;
- (void)fillRecordsForView;
- (void)moveCenterOfContent:(UIScrollView *)scrollView;
@end


@implementation CFCoverFlowViewController
@synthesize records = _records;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initalize];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration {

    //デバイス回転時に中心がずれないようcontentOffsetを調整
    CGFloat screanWidth = UIInterfaceOrientationIsPortrait(interfaceOrientation)
    ? [[UIScreen mainScreen] bounds].size.height
    : [[UIScreen mainScreen] bounds].size.width;
    
    [self.tableView reloadData];
    CGPoint contentOffset = self.tableView.contentOffset;
    contentOffset.y = contentOffset.y + (screanWidth - self.tableView.bounds.size.height)/2;
    self.tableView.contentOffset = contentOffset;
    [self.tableView transformView];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self moveCenterOfContent:scrollView];
    [(CFCoverFlowView *)scrollView transformView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if(!decelerate) {
        [(CFCoverFlowView *)scrollView fitCenterForCell];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [(CFCoverFlowView *)scrollView fitCenterForCell];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _records.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    CFCoverFlowCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];

    UIImage *image = [_records objectAtIndex:indexPath.row];
    [cell.coverFlowImageView setImage:image];
    return cell;
}


#pragma mark - Private methods

- (void)initalize {
    for (int i=0; i<18; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"img%d.png", i]];
        [self.tableView addImage:image];
    }
    [self resetCoverFlowView];
}

- (void)resetCoverFlowView {
    self.records = [NSMutableArray array];
    [self.tableView reloadData];
    
    [self fillRecordsForView];
    //４倍する
    for (int i=0; i<2; i++) {
        [_records addObjectsFromArray:_records];
    }
    [self.tableView reloadData];
    self.tableView.contentOffset = [self.tableView defaultContentOffset];
}

- (void)fillRecordsForView {
    CGFloat currentOffSetY = self.tableView.contentOffset.y;
    CGFloat contentHeight = self.tableView.contentSize.height;
    CGFloat viewHieght = self.tableView.bounds.size.height;
    
    if (currentOffSetY >= contentHeight - viewHieght) {
        [_records addObjectsFromArray:self.tableView.images];
        [self.tableView reloadData];
        
        //画面サイズを超えるまで繰り返す
        [self fillRecordsForView];
    }
}

- (void)moveCenterOfContent:(UIScrollView *)scrollView {
    CGFloat currentOffsetX = scrollView.contentOffset.x;
    CGFloat currentOffSetY = scrollView.contentOffset.y;
    CGFloat contentHeight = scrollView.contentSize.height;
    if (currentOffSetY < contentHeight/8) {
        scrollView.contentOffset = CGPointMake(currentOffsetX, currentOffSetY + contentHeight/2);
    }
    if (currentOffSetY > contentHeight*6/8) {
        scrollView.contentOffset = CGPointMake(currentOffsetX, currentOffSetY - contentHeight/2);
    }
}

@end


