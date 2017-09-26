//
//  JHGradualProgressView.h
//  JHKit
//
//  Created by HaoCold on 16/8/15.
//  Copyright © 2016年 HaoCold. All rights reserved.
//  渐变色进度条

#import <UIKit/UIKit.h>

@interface JHGradualProgressView : UIView

@property (assign,  nonatomic) CGFloat   progress;  /**< value:0.0~1.0 */

- (instancetype)initWithFrame:(CGRect)frame;

@end
