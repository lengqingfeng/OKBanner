//
//  ViewController.m
//  OKBannerDemo
//
//  Created by lengshengren on 16/11/17.
//  Copyright © 2016年 Lengshengren. All rights reserved.
//

#import "ViewController.h"
#import "OKBannerView.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //一般加载网络图片 打开 -(void)addImageViewInView:(NSArray *)imageArray pageTotalCounts:(NSInteger)pageTotalCounts 里面的注释
    
    NSArray *imageArray = @[@"1.jpg",@"2.jpg",@"3.jpg",@"4.jpg",@"5.jpg",@"6.jpg"];
    OKBannerView *banner = [[OKBannerView alloc]initWithFrame:CGRectMake(0, 50, self.view.frame.size.width, 200) imageArray:imageArray nodeArray:@[@"哈哈哈呀",@"美女呀",@"真好看呀",@"想什么呢",@"不是我媳妇",@"是模特哈哈啊"]];
   // banner.nodeViewColor = [UIColor yellowColor];
    //banner.nodeTitleColor = [UIColor redColor];
    banner.tapBannerImageViewActionBlock = ^(NSInteger pageIndex){
        NSLog(@"点击了第%ld个",(long)pageIndex);
    };
    banner.noteTitleFont = [UIFont systemFontOfSize:14];
    //banner.pageControlCoreNormalColor = [UIColor yellowColor];
    [self.view addSubview:banner];
    
    
    NSArray *imageArray2 = @[@"1.jpg",@"2.jpg",@"3.jpg",@"4.jpg",@"5.jpg",@"6.jpg"];
    OKBannerView *banner2 = [[OKBannerView alloc]initWithFrame:CGRectMake(0, 300, self.view.frame.size.width, 200) imageArray:imageArray2];
    // banner.nodeViewColor = [UIColor yellowColor];
    //banner.nodeTitleColor = [UIColor redColor];
    banner2.pageControlCoreNormalColor = [UIColor whiteColor];
    [self.view addSubview:banner2];
    // Do any additional setup a2fter loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
