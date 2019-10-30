//
//  JHGradualProgressView.m
//  JHKit
//
//  Created by HaoCold on 16/8/15.
//  Copyright © 2016年 HaoCold. All rights reserved.
//
//  MIT License
//
//  Copyright (c) 2017 xjh093
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

#import "JHGradualProgressView.h"

@implementation JHGradualProgressConfig

- (instancetype)init
{
    self = [super init];
    if (self) {
        _duration = 1.0;
        _backColor = [UIColor colorWithRed:240.0/255 green:240.0/255 blue:245.0/255 alpha:1];
        _borderWidth = 1/[UIScreen mainScreen].scale;
        _borderColor = [UIColor blackColor];
        _showGradualBorderColor = YES;
    }
    return self;
}

@end

@interface JHGradualProgressView()

@property (nonatomic,  strong) CALayer *borderLayer;
@property (nonatomic,  strong) CALayer *progressBackLayer;
@property (nonatomic,  strong) UIView *progressView;

@property (nonatomic,  assign) CGFloat  progressViewWidth;

@property (strong,  nonatomic) UIImage          *image;

@end

@implementation JHGradualProgressView

#pragma mark -------------------------------------视图-------------------------------------------

- (instancetype)initWithFrame:(CGRect)frame config:(JHGradualProgressConfig *)config;
{
    self = [super initWithFrame:frame];
    if (self) {
        _config = config;
        [self setupViews];
    }
    return self;
}

- (void)setupViews
{
    [self.layer addSublayer:self.borderLayer];
    [self.layer addSublayer:self.progressBackLayer];
    [self addSubview:self.progressView];
    
    if (_config.showGradualBorderColor && !_config.showAllColor) {
        [self defaultGradualBorderColor];
    }
    
    //
    CGRect frame = _progressView.frame;
    frame.size.width = 0;
    _progressView.frame = frame;
}

#pragma mark --- 默认的渐变边框颜色
- (void)defaultGradualBorderColor
{
    UIGraphicsBeginImageContextWithOptions(_progressView.bounds.size, NO, 0.0);
    [_progressView.layer renderInContext:UIGraphicsGetCurrentContext()];
    _image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
}

- (void)setProgress:(CGFloat)progress
{
    if (progress >= 0 && progress <= 1.0) {
        CGRect frame = _progressView.frame;
        frame.size.width = _progressViewWidth * progress;
        
        [UIView animateWithDuration:_config.duration animations:^{
            _progressView.frame = frame;
            if (_config.showAllColor) {
                [_progressView.layer addSublayer:[self gradientLayerInRect:_progressView.bounds]];
            }
        } completion:^(BOOL finished) {
            if (_config.showGradualBorderColor && !_config.showAllColor) {
                UIColor *color = [self colorAtPixel:CGPointMake(frame.size.width, _image.size.height*0.5)];
                _borderLayer.borderColor = [color CGColor];
            }
        }];
    }
}

- (CAGradientLayer *)gradientLayerInRect:(CGRect)rect
{
    //渐变色
    CAGradientLayer *layer = [[CAGradientLayer alloc] init];
    layer.frame = rect;
    layer.colors = ({
        // default
        NSArray *colors = @[(__bridge id)[UIColor redColor].CGColor,
                            (__bridge id)[UIColor yellowColor].CGColor,
                            (__bridge id)[UIColor greenColor].CGColor];
        
        if (_config.colors.count > 0) {
            NSMutableArray *marr = @[].mutableCopy;
            for (UIColor *color in _config.colors) {
                [marr addObject:(__bridge id)[color CGColor]];
            }
            colors = marr;
        }
        colors;
    });
    
    //从左到右渐变
    layer.startPoint = CGPointMake(0, .5);
    layer.endPoint   = CGPointMake(1, .5);
    return layer;
}

#pragma mark - 获取图片内点的颜色
- (UIColor *)colorAtPixel:(CGPoint)point {
    // Cancel if point is outside image coordinates
    if (!CGRectContainsPoint(CGRectMake(0.0f, 0.0f, _image.size.width, _image.size.height), point)) {
        return [UIColor whiteColor];
    }
    
    NSInteger pointX = trunc(point.x);
    NSInteger pointY = trunc(point.y);
    CGImageRef cgImage = _image.CGImage;
    NSUInteger width = _image.size.width;
    NSUInteger height = _image.size.height;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    int bytesPerPixel = 4;
    int bytesPerRow = bytesPerPixel * 1;
    NSUInteger bitsPerComponent = 8;
    unsigned char pixelData[4] = { 0, 0, 0, 0 };
    CGContextRef context = CGBitmapContextCreate(pixelData,
                                                 1,
                                                 1,
                                                 bitsPerComponent,
                                                 bytesPerRow,
                                                 colorSpace,
                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);
    CGContextSetBlendMode(context, kCGBlendModeCopy);
    
    // Draw the pixel we are interested in onto the bitmap context
    CGContextTranslateCTM(context, -pointX, pointY-(CGFloat)height);
    CGContextDrawImage(context, CGRectMake(0.0f, 0.0f, (CGFloat)width, (CGFloat)height), cgImage);
    CGContextRelease(context);
    
    // Convert color values [0..255] to floats [0.0..1.0]
    CGFloat red   = (CGFloat)pixelData[0] / 255.0f;
    CGFloat green = (CGFloat)pixelData[1] / 255.0f;
    CGFloat blue  = (CGFloat)pixelData[2] / 255.0f;
    CGFloat alpha = (CGFloat)pixelData[3] / 255.0f;
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

#pragma mark -------------------------------------事件-------------------------------------------

#pragma mark -------------------------------------懒加载-----------------------------------------

- (CALayer *)borderLayer{
    if (!_borderLayer) {
        CALayer *layer = [CALayer layer];
        layer.frame = self.bounds;
        layer.backgroundColor = [UIColor clearColor].CGColor;
        layer.cornerRadius = CGRectGetHeight(self.bounds)*0.5;
        _borderLayer = layer;
        
        if (_config.borderWidth > 0) {
            layer.borderWidth = _config.borderWidth;
            
            if (_config.showAllColor) {
                layer.borderColor = _config.borderColor.CGColor;
            }
            else if (_config.showGradualBorderColor) {
                if (_config.colors.count > 0) {
                    UIColor *color = _config.colors[0];
                    layer.borderColor = color.CGColor;
                }
            }
        }
    }
    return _borderLayer;
}

- (CALayer *)progressBackLayer{
    if (!_progressBackLayer) {
        CGRect frame = self.bounds;
        if (_config.borderWidth > 0) {
            CGFloat offset = 1/[UIScreen mainScreen].scale;
            CGFloat inset = _config.borderWidth+offset;
            frame = CGRectInset(self.bounds, inset, inset);
        }
        
        CALayer *layer = [CALayer layer];
        layer.frame = frame;
        layer.backgroundColor = _config.backColor.CGColor;
        layer.cornerRadius = CGRectGetHeight(layer.bounds)*0.5;
        _progressBackLayer = layer;
    }
    return _progressBackLayer;
}

- (UIView *)progressView{
    if (!_progressView) {
        
        CGRect frame = self.bounds;
        if (_config.borderWidth > 0) {
            CGFloat offset = 1/[UIScreen mainScreen].scale;
            CGFloat inset = _config.borderWidth+offset;
            frame = CGRectInset(self.bounds, inset, inset);
        }
        
        UIView *view = [[UIView alloc] init];
        view.frame = frame;
        view.layer.cornerRadius = CGRectGetHeight(view.bounds)*0.5;
        view.clipsToBounds = YES;
        _progressView = view;
        _progressViewWidth = CGRectGetWidth(view.bounds);
        
        if (_config.colors.count == 1) {
            view.backgroundColor = _config.colors[0];
        }else{
            //渐变色
            if (_config.showGradualBorderColor && !_config.showAllColor) {
                [view.layer addSublayer:[self gradientLayerInRect:view.bounds]];
            }
        }
    }
    return _progressView;
}

@end
