//
//  CFCoverFlowView.h
//  CoverFlowTest
//
//  Created by Hidetoshi Mori on 12/10/30.
//  Copyright (c) 2012年 Hidetoshi Mori. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CFCoverFlowView : UITableView {
    NSMutableArray *_images;
}
@property (readonly, nonatomic) NSArray *images;

- (void)addImage:(UIImage *)image;

- (CGPoint)defaultContentOffset;

- (void)transformView;
- (void)fitCenterForCell;

@end
