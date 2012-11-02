//
//  CFCoverFlowCell.m
//  CoverFlowTest
//
//  Created by Hidetoshi Mori on 12/10/27.
//  Copyright (c) 2012年 Hidetoshi Mori. All rights reserved.
//

#import "CFCoverFlowCell.h"
#import <QuartzCore/QuartzCore.h>

@interface CFCoverFlowCell ()
- (float)rateOfDistance;
+ (float)scaleForDistanceRate:(float)rate;
+ (float)angleForDistanceRate:(float)rate;
+ (float)translateForDistanceRate:(float)rate;
+ (float)shadowOpacityForDistanceRate:(float)rate;
@end

@implementation CFCoverFlowCell
@synthesize distance = _distance;

#pragma mark - Comparator

- (NSComparisonResult)compare:(CFCoverFlowCell *)cell {
    if (fabs(self.distance) > fabs(cell.distance)) {
        return NSOrderedAscending;
    } else if (fabs(self.distance) < fabs(cell.distance)) {
        return NSOrderedDescending;
    } else {
        return NSOrderedSame;
    }  
}


#pragma mark - transform

- (void)transformCell {
    static const float zDistance = 800.0f;
    
    //CATransform3D前に毎回positionを設定し直す
    self.coverFlowImageView.layer.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);

    float rate = [self rateOfDistance];
    
    CATransform3D t = CATransform3DIdentity;
    //視点の距離
    t.m34 = 1.0f / -zDistance;
    //右に90度回転
    t = CATransform3DRotate(t,
                            M_PI/2.0f,
                            0.0f,
                            0.0f,
                            1.0f);
    //角度
    t = CATransform3DRotate(t,
                            [CFCoverFlowCell angleForDistanceRate:rate],
                            0.0f,
                            1.0f,
                            0.0f);
    //スケール
    t = CATransform3DScale(t,
                           [CFCoverFlowCell scaleForDistanceRate:rate],
                           [CFCoverFlowCell scaleForDistanceRate:rate],
                           [CFCoverFlowCell scaleForDistanceRate:rate]);
    //位置
    t = CATransform3DTranslate(t,
                               [CFCoverFlowCell translateForDistanceRate:rate],
                               0.0f,
                               0.0f);
    self.coverFlowImageView.layer.transform = t;
    
    //影の透明度
    self.coverFlowImageView.shadowLayer.opacity = [CFCoverFlowCell shadowOpacityForDistanceRate:rate];
}

#pragma mark - Private methods

- (float)rateOfDistance {
    return (float)(self.distance * 2.0f / self.frame.size.width);
}

+ (float)scaleForDistanceRate:(float)rate {
    static const float coefficient = 10.0f;
    static const float maxScale = 2.0f;
    static const float minScale = 1.0f;

    if (fabsf(rate) > 0.1f) {
        return minScale;
    }
    return - (coefficient * fabs(rate)) + maxScale;
}

+ (float)angleForDistanceRate:(float)rate {
    static const float coefficient = 4.0f;
    static const float baseAngle = - M_PI/3.0f; //60 degree
    
    if (fabsf(rate) > 0.25f) {
        return copysignf(1.0f, rate) * baseAngle;
    }
    return coefficient * rate * baseAngle;
}

+ (float)translateForDistanceRate:(float)rate {
    static const float coefficient = 200.0f;

    if (fabs(rate) < 0.25f) {
        return coefficient * rate;
    }
    return - (coefficient * rate) + (copysignf(1.0f, rate) * coefficient/2.0f);
}

+ (float)shadowOpacityForDistanceRate:(float)rate {
    static const float coefficient = 1.0f;

    if (fabs(rate) < 0.1f) {
        return 0.0f;
    }
    return coefficient * fabsf(rate) - (coefficient * 0.1f);
}

@end
