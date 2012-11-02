//
//  CFCoverFlowImageView.h
//  CoverFlowTest
//
//  Created by Hidetoshi Mori on 12/10/29.
//  Copyright (c) 2012年 Hidetoshi Mori. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface CFCoverFlowImageView : UIImageView {
    CALayer *_shadowLayer;
    CALayer *_reflectionLayer;
    CALayer *_reflectionShadowLayer;
}
@property (strong, nonatomic) CALayer *shadowLayer;

@end
