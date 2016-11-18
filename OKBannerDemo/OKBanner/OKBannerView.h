//
//  OKBannerView.h
//  EasyScrollerView
//
//  Created by lsr on 14-4-21.
//  Copyright (c) 2014年 lsr. All rights reserved.
//

/* 1.1 版  添加定时轮播*/
/* 1.2 版  添加PageControlType 和 优化*/
/* 2.0 版  结构优化*/

#import <UIKit/UIKit.h>
#import "StyledPageControl.h"

typedef NS_ENUM(NSInteger, PageControlType)
{
    PageControlTypeCenter,
    PageControlTypeRight,
    PageControlTypeLeft,
};

@protocol OKBannerViewDelegate <NSObject>
- (void)selectBannerIndex:(NSInteger)index;
- (void)deleteBanner;
@end


@interface OKBannerView : UIView<UIScrollViewDelegate>
@property(weak, nonatomic)id<OKBannerViewDelegate>delegate;
@property (strong, nonatomic)UIColor *noteViewColor;   // 描述栏的颜色
@property (strong, nonatomic)UIColor *noteTitleColor;  // 添加文字描述字体颜色
@property (strong, nonatomic)UIFont   *noteTitleFont;
@property (assign, nonatomic)BOOL isStopLoop;



// 初始化
-(instancetype)initWithFrame:(CGRect)frame imageArray:(NSArray *)imagesArray;

-(instancetype)initWithFrame:(CGRect)frame imageArray:(NSArray *)imagesArray bannerLoppTime:(CGFloat)bannerLoppTime;

-(instancetype)initWithFrame:(CGRect)frame imageArray:(NSArray *)imagesArray nodeArray:(NSArray *)nodeArray;

-(instancetype)initWithFrame:(CGRect)frame imageArray:(NSArray *)imagesArray nodeArray:(NSArray *)nodeArray bannerLoppTime:(CGFloat)bannerLoppTime;

@property (nonatomic , copy) void (^tapBannerImageViewActionBlock)(NSInteger pageIndex);

@property (copy,nonatomic)dispatch_block_t deleteBlocek;

@property (nonatomic, assign)PageControlType type;

@property(nonatomic,strong)UIColor * pageControlCoreNormalColor;

@property(nonatomic,strong)UIColor * pageControlCoreSelectedColor;
@end
