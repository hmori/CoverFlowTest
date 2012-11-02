//
//  CFCoverFlowCell.h
//  CoverFlowTest
//
//  Created by Hidetoshi Mori on 12/10/27.
//  Copyright (c) 2012年 Hidetoshi Mori. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CFCoverFlowImageView.h"

@interface CFCoverFlowCell : UITableViewCell {
    CGFloat _distance;
}
@property (weak, nonatomic) IBOutlet CFCoverFlowImageView *coverFlowImageView;
@property (nonatomic) CGFloat distance;

- (void)transformCell;

@end
