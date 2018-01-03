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

@interface JHGradualProgressView()

@property (strong,  nonatomic) UIView           *outView;
@property (strong,  nonatomic) UIView           *inView;
@property (assign,  nonatomic) CGFloat           width;
@property (strong,  nonatomic) UIImage          *image;

@end

@implementation JHGradualProgressView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self jhSetupViews:frame];
    }
    return self;
}

- (void)jhSetupViews:(CGRect)frame
{
    //外框
    UIView *outView = [[UIView alloc] init];
    outView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    outView.layer.cornerRadius = frame.size.height*0.5;
    outView.layer.borderWidth = 0.5;
    outView.layer.borderColor = [[UIColor redColor] CGColor];
    [self addSubview:outView];
    _outView = outView;
    
    //进度条
    CGFloat iX = 1;
    CGFloat iY = 1;
    CGFloat iW = frame.size.width - 2*iX;
    CGFloat iH = frame.size.height - 2*iY;
    CGRect iframe = CGRectMake(iX, iY, 0, iH);
    _width = iW;
    
    //灰色底
    UIView *grayView = [[UIView alloc] init];
    grayView.frame = CGRectMake(iX, iY, iW, iH);
    grayView.layer.cornerRadius = iH*0.5;
    grayView.backgroundColor = [UIColor colorWithRed:240.0/255 green:240.0/255 blue:245.0/255 alpha:1];
    [self addSubview:grayView];
    
    UIView *inView = [[UIView alloc] init];
    inView.frame = iframe;
    inView.layer.cornerRadius = iH*0.5;
    [self addSubview:inView];
    _inView = inView;
    
    //渐变色
    CAGradientLayer *layer = [[CAGradientLayer alloc] init];
    layer.frame = CGRectMake(0, 0, iW, iH);
    layer.colors = @[(__bridge id)[UIColor redColor].CGColor,
                     (__bridge id)[UIColor yellowColor].CGColor,
                     (__bridge id)[UIColor greenColor].CGColor];
    //从左到右渐变
    layer.startPoint = CGPointMake(0, .5);
    layer.endPoint   = CGPointMake(1, .5);
    [inView.layer addSublayer:layer];

    // 1.开启上下文
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(iW, iH), NO, 0.0);
    // 2.将view的layer渲染到上下文
    [inView.layer renderInContext:UIGraphicsGetCurrentContext()];
    // 3.取出图片
    _image = UIGraphicsGetImageFromCurrentImageContext();
    // 4.结束上下文
    UIGraphicsEndImageContext();
    
    //最后设置此属性，不然 _image画不出来！！！
    inView.clipsToBounds = YES;
}

- (void)setProgress:(CGFloat)progress
{
    if (progress >= 0 && progress <= 1.0) {
        CGRect frame = _inView.frame;
        frame.size.width = _width * progress;
        UIColor *color = [self colorAtPixel:CGPointMake(frame.size.width, _image.size.height*0.5)];
        [UIView animateWithDuration:1 animations:^{
            _inView.frame = frame;
        } completion:^(BOOL finished) {
            _outView.layer.borderColor = [color CGColor];
        }];
    }
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

@end
