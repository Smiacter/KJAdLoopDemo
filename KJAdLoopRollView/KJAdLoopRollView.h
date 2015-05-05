//
//  KJAdLoopRoll.h
//  Fragrance
//
//  Created by Apple on 15/4/29.
//  Copyright (c) 2015年 Apple. All rights reserved.
//

/*
 *  --广告条循环滚动视图
 */

#import <UIKit/UIKit.h>

//代理
@class KJAdLoopRollView;
@protocol KJAdLoopRollViewDelegate <NSObject>
//点击指定的图片响应
-(void)tapImageAtIndex:(NSInteger)index;
@end

@interface KJAdLoopRollView : UIView<UIScrollViewDelegate, UIGestureRecognizerDelegate>
@property (nonatomic, weak) id<KJAdLoopRollViewDelegate>delegate;
// frame和需要显示的图片集合初始化函数
-(id)initWithFrame:(CGRect)frame andImageArray:(NSArray *)imageArr;
// 设置pagecontrol的当前显示显色
-(void)setPagecontrolColor:(UIColor *)color;
-(void)releasTimer;
@end
