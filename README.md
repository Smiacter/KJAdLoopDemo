# KJAdLoopDemo
IOS Ad Loop View
使用方法：

1.下载KJAdLoopRollView（.h和.m文件），并导入需要的工程

2.在需要用到得VC中#import 
```c
"KJAdLoopRollView.h"
```

3.在VC中适当位置创建广告view（KJAdLoopRollView）

 ```objective-c
 // 用frame和需要显示的广告图片初始化，tempArr即为显示数组
    self.adScrollView = [[KJAdLoopRollView alloc]initWithFrame:CGRectMake(0, 0, self.adView.frame.size.width, self.adView.frame.size.height) andImageArray:tempArr];
    // 设置pageControl当前显示颜色，不设置默认为黑色
    [self.adScrollView setPagecontrolColor:[UIColor redColor]];
    // 指定代理，实现点击广告时响应
    self.adScrollView.delegate = self;
    [self.adView addSubview:self.adScrollView];
```
4.实现点击广告图片代理
```c
//点击图片的信息，index为当前点击的图片，与PageControl的Page一致（从0开始）
-(void)tapImageAtIndex:(NSInteger)index
{
    NSLog(@"tap image%ld", (long)index);
}
```
5.在跳转到其他VC时，释放掉timer
```c
// 我是在viewWillDisappear里面释放的，当然还有其他释放的地方，可自行选择
-(void)viewWillDisappear:(BOOL)animated
{
    [self.adScrollView releasTimer];
}
```

了解更多请参考我的博客<http://smiacter.farbox.com/post/ioskai-fa/iosyan-gao-tu-pian-xun-huan-gun-dong>
