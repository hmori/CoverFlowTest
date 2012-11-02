//
//  CFCoverFlowView.m
//  CoverFlowTest
//
//  Created by Hidetoshi Mori on 12/10/30.
//  Copyright (c) 2012年 Hidetoshi Mori. All rights reserved.
//

#import "CFCoverFlowView.h"
#import "CFCoverFlowCell.h"

@interface CFCoverFlowView ()
- (NSArray *)sortedVisibleCellsByDistance;
- (CGFloat)distanceFromCenter:(NSIndexPath *)indexPath;
@end

@implementation CFCoverFlowView
@synthesize images = _images;

- (id)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super initWithCoder:aDecoder])) {
        _images = [NSMutableArray array];

        //左に90度回転
        CGAffineTransform t = CGAffineTransformMakeRotation(-M_PI/2.0f);
        self.transform = t;
        self.scrollsToTop = NO;
        self.bounces = NO;
    }
    return self;
}

- (void)addImage:(UIImage *)image {
    [_images addObject:image];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self transformView];
}

#pragma mark - Public methods

- (CGPoint)defaultContentOffset {
    return CGPointMake(self.contentOffset.x,
                       (self.contentSize.height - self.superview.frame.size.width + self.rowHeight)/2);
}

- (void)transformView {
    NSArray *sortedCells = [self sortedVisibleCellsByDistance];
    
    for (CFCoverFlowCell *cell in sortedCells) {
        //順番に背面から最前面に配置
        [self bringSubviewToFront:cell];
        //Cellの変形処理
        [cell transformCell];
    }
}

- (void)fitCenterForCell {
    NSArray *sortedCells = [self sortedVisibleCellsByDistance];
    if (sortedCells.count > 0) {
        CFCoverFlowCell *cell = [sortedCells lastObject];
        [self setContentOffset:CGPointMake(self.contentOffset.x, self.contentOffset.y+cell.distance) animated:YES];
    }
}

#pragma mark - Private methods

- (NSArray *)sortedVisibleCellsByDistance {
    NSMutableArray *sortedCells = [NSMutableArray array];
    
    NSArray *indexPaths = [self indexPathsForVisibleRows];
    for (NSIndexPath *indexPath in indexPaths) {
        CFCoverFlowCell *cell = (CFCoverFlowCell *)[self cellForRowAtIndexPath:indexPath];
        cell.distance = [self distanceFromCenter:indexPath];
        [sortedCells addObject:cell];
    }
    return [sortedCells sortedArrayUsingSelector:@selector(compare:)];
}

- (CGFloat)distanceFromCenter:(NSIndexPath *)indexPath {
    CGRect rect = [self rectForRowAtIndexPath:indexPath];
    CGFloat centerCellOffset = rect.origin.y+rect.size.height/2;
    CGFloat offset = self.contentOffset.y;
    CGFloat centerOffset = (self.bounds.size.height/2)+offset;
    return (centerCellOffset - centerOffset);
}

@end
