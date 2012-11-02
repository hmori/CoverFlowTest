//
//  CFCoverFlowImageView.m
//  CoverFlowTest
//
//  Created by Hidetoshi Mori on 12/10/29.
//  Copyright (c) 2012年 Hidetoshi Mori. All rights reserved.
//

#import "CFCoverFlowImageView.h"

@interface CFCoverFlowImageView ()
@property (strong, nonatomic) CALayer *reflectionLayer;
@property (strong, nonatomic) CALayer *reflectionShadowLayer;
- (void)addLayer;
@end

@implementation CFCoverFlowImageView
@synthesize shadowLayer = _shadowLayer;
@synthesize reflectionLayer = _reflectionLayer;
@synthesize reflectionShadowLayer = _reflectionShadowLayer;

- (id)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super initWithCoder:aDecoder])) {
        [self addLayer];
    }
    return self;
}

- (void)addLayer {
    static float const reflectionShadowOpacity = 0.7f;
    
    _shadowLayer = [CALayer layer];
    _shadowLayer.backgroundColor = [[UIColor blackColor] CGColor];
	_shadowLayer.masksToBounds = YES;
    _shadowLayer.opacity = 1.0f;

    _reflectionLayer = [CALayer layer];
	_reflectionLayer.masksToBounds = YES;
    _reflectionLayer.opacity = 1.0f;

    _reflectionLayer.transform = CATransform3DMakeScale(1.0f, -1.0f, 1.0f);
    _reflectionLayer.contentsGravity = kCAGravityResize;
    _reflectionLayer.sublayerTransform = _reflectionLayer.transform;
    
    _reflectionShadowLayer = [CALayer layer];
    _reflectionShadowLayer.backgroundColor = [[UIColor blackColor] CGColor];
	_reflectionShadowLayer.masksToBounds = YES;
    _reflectionShadowLayer.opacity = reflectionShadowOpacity;
    
    [_reflectionLayer addSublayer:_reflectionShadowLayer];
    [self.layer addSublayer:_reflectionLayer];
    [self.layer addSublayer:_shadowLayer];
}

#pragma mark - Overwride methods

- (void)layoutSublayersOfLayer:(CALayer *)layer {
    static float const space = 3.0f;
    
    CGRect shadowRect = layer.bounds;
    shadowRect.size.height = (layer.bounds.size.height * 2) + space;
    _shadowLayer.frame = shadowRect;
    
    CGRect reflectionRect = layer.bounds;
    reflectionRect.origin.y = layer.bounds.size.height + space;
    _reflectionLayer.frame = reflectionRect;
    
    _reflectionShadowLayer.frame = layer.bounds;

    [super layoutSublayersOfLayer:layer];
}

- (void)setImage:(UIImage *)image {
    [super setImage:image];
    _reflectionLayer.contents = self.layer.contents;
}


@end
