//
//  ViewController.m
//  KJAdLoopDemo
//
//  Created by Apple on 15/5/5.
//  Copyright (c) 2015年 Smiacter. All rights reserved.
//

#import "ViewController.h"
#import "KJAdLoopRollView.h"

@interface ViewController ()<KJAdLoopRollViewDelegate>
@property (nonatomic, strong) KJAdLoopRollView *adScrollView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createAdRoll];
}

/**
 *  @author Smiacter, 15-05-05 23:05:26
 *
 *  创建广告栏
 */
-(void)createAdRoll
{
    NSArray *tempArr = [NSArray arrayWithObjects:@"honey1",@"honey2",@"honey3",@"honey4", nil];
    self.adScrollView = [[KJAdLoopRollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height/3) andImageArray:tempArr];
    [self.adScrollView setPagecontrolColor:[UIColor redColor]];
    self.adScrollView.delegate = self;
    [self.view addSubview:self.adScrollView];
}
/**
 *  @author Smiacter, 15-05-05 23:05:05
 *
 *  点击广告图代理
 *
 *  @return void
 */
-(void)tapImageAtIndex:(NSInteger)index
{
    NSString *showStr = [NSString stringWithFormat:@"图片%ld被点击", (long)index];
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"消息窗口" message:showStr delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView show];
}
/**
 *  @author Smiacter, 15-05-05 23:05:28
 *
 *  在需要跳转到其他VC时，释放定时器
 *
 *  @return void
 */
-(void)viewWillDisappear:(BOOL)animated
{
    [self.adScrollView releasTimer];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
