//
//  JHGradualProgressView.h
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
//
//  渐变色进度条

#import <UIKit/UIKit.h>

@interface JHGradualProgressConfig : NSObject
/// progress animation time. default is 1.0
@property (nonatomic,  assign) CGFloat  duration;
/// default is #F0F0F5.
@property (nonatomic,  strong) UIColor *backColor;
/// default is blackColor.
@property (nonatomic,  strong) UIColor *borderColor;
/// border width. default is 1/[UIScreen mainScreen].scale;
@property (nonatomic,  assign) CGFloat  borderWidth;
/// default is NO.
@property (nonatomic,  assign) BOOL  showGradualBorderColor;
/// default is NO. if YES will use borderColor.
@property (nonatomic,  assign) BOOL  showAllColor;
/// gradual colors.
@property (nonatomic,  strong) NSArray *colors;
@end

@interface JHGradualProgressView : UIView
/// 0.0~1.0
@property (nonatomic,  assign) CGFloat  progress;
/// configs
@property (nonatomic,  strong,  readonly) JHGradualProgressConfig *config;

- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame config:(JHGradualProgressConfig *)config;

@end

