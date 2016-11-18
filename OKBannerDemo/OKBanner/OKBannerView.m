//
//  LSRScrollerView.m
//  EasyScrollerView
//
//  Created by lsr on 14-4-21.
//  Copyright (c) 2014年 lsr. All rights reserved.
//

#import "OKBannerView.h"

#define Screen_W [UIScreen mainScreen].bounds.size.width
#define Screen_H [UIScreen mainScreen].bounds.size.height

@interface OKBannerView ()
{
    UILabel *noteTitle;
    UIView *noteView;
    NSInteger currentPageIndex;
    CGRect viewSize;
    NSArray *imageArray_m;
    NSTimer *loopTime;
    StyledPageControl  *pageControl;
}
@property (assign, nonatomic)CGFloat currenLoopTime;
@property (assign, nonatomic)BOOL hideDeleteButton;    //是否因此删除按钮，默认隐藏
@property (nonatomic, strong)NSTimer      *loopTime;
@property (nonatomic, assign)NSInteger    pageCount;
@property (strong, nonatomic)NSArray      *noteTitleArray;
@property (strong, nonatomic)UIScrollView *scrollView;
@property (assign, nonatomic)NSInteger    countImage;
@property (strong, nonatomic)UIButton     *deleteButton;

@property (strong, nonatomic)UIColor      *defaultPageNormColor;
@property (strong, nonatomic)UIColor      *defaultPageSelectColor;

@property (strong, nonatomic)UIColor      *defaultNodeViewColor;
@property (strong, nonatomic)UIColor      *defaultNodeTitleColor;

@property (assign, nonatomic)CGFloat      defaultPageWidth;
@property (assign, nonatomic)CGFloat      defaultPageHeight;

@property (assign, nonatomic)BOOL isAddNodeView; //是否添加Banner说明样式

@end

@implementation OKBannerView
@synthesize noteTitleArray;
@synthesize scrollView;
@synthesize pageCount;
@synthesize noteTitleColor;
@synthesize loopTime;
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame imageArray:(NSArray *)imagesArray
{
    self = [super initWithFrame:frame];
    if (self)
    {
        if (imagesArray.count <= 0) {
            return nil;
            
        }else{
            [self initWithScrollView:imagesArray frame:frame nodeArray:nil bannerLoppTime:3.6];
        }
        
    }
    return self;
}
-(instancetype)initWithFrame:(CGRect)frame imageArray:(NSArray *)imagesArray bannerLoppTime:(CGFloat)bannerLoppTime{
    
    self = [super initWithFrame:frame];
    if (self)
    {
        if (imagesArray.count <= 0) {
            return nil;
            
        }else{
            [self initWithScrollView:imagesArray frame:frame nodeArray:nil bannerLoppTime:bannerLoppTime];
        }
        
    }
    return self;
    
}

-(instancetype)initWithFrame:(CGRect)frame imageArray:(NSArray *)imagesArray nodeArray:(NSArray *)nodeArray{
    self = [super initWithFrame:frame];
    if (self)
    {
        if (imagesArray.count <= 0) {
            return nil;
        }else{
            [self initWithScrollView:imagesArray frame:frame nodeArray:nodeArray bannerLoppTime:3.6];
        }
        
    }
    return self;
    
}
-(instancetype)initWithFrame:(CGRect)frame imageArray:(NSArray *)imagesArray nodeArray:(NSArray *)nodeArray bannerLoppTime:(CGFloat)bannerLoppTime{
    self = [super initWithFrame:frame];
    if (self)
    {
        if (imagesArray.count <= 0) {
            return nil;
        }else{
            [self initWithScrollView:imagesArray frame:frame nodeArray:nodeArray bannerLoppTime:bannerLoppTime];
        }
        
    }
    return self;
}

#pragma mark - DefaultValue
-(void)setupDefaultValue{
    self.defaultPageNormColor   =  [UIColor grayColor];
    self.defaultPageSelectColor =  [UIColor blackColor];
    self.defaultNodeViewColor   = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    self.defaultNodeTitleColor  = [UIColor whiteColor];
    self.defaultPageWidth = (pageCount-2)*10.0f+44.f;
    self.defaultPageHeight  = 15;
}

- (void)setNoteViewColor:(UIColor *)color{
    [noteView setBackgroundColor:color];
    
}
- (void)setNoteTitleColor:(UIColor *)color{
     noteTitle.textColor = color;
}

- (void)setNoteTitleFont:(UIFont *)font{
    noteTitle.font = font;
}

- (void)setPageControlCoreNormalColor:(UIColor *)color{
    pageControl.coreNormalColor =  color;
}

- (void)setPageControlCoreSelectedColor:(UIColor *)color{
    pageControl.coreSelectedColor = color;
    
}

#pragma mark -  InitWith ScrollView
- (void)initWithScrollView:(NSArray *)imagesArray frame:(CGRect)frame nodeArray:(NSArray *)nodeArray bannerLoppTime:(CGFloat)bannerLoppTime {
    pageCount =[imagesArray count] + 2; // 页数
    self.currenLoopTime = bannerLoppTime;
    [self setupDefaultValue];
    
    if (nodeArray.count > 0 && nodeArray != nil) {
        noteTitleArray = [[NSArray alloc]initWithArray:nodeArray];
        self.isAddNodeView = YES;
    }else{
        self.isAddNodeView = NO;
    }
    
    self.hideDeleteButton = YES;
    
    self.countImage = imagesArray.count;
    // imageview 可以点击
    self.userInteractionEnabled = YES;
    
    NSMutableArray *tempMutableArray = [[ NSMutableArray alloc]initWithArray:imagesArray];
    [tempMutableArray insertObject:[imagesArray objectAtIndex:imagesArray.count-1] atIndex:0];
    [tempMutableArray addObject:[imagesArray objectAtIndex:0]];
    
    imageArray_m = [NSArray arrayWithArray:tempMutableArray] ;
    
    viewSize = frame; // 视图大小
    
    scrollView =[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, viewSize.size.width, viewSize.size.height)];
    
    if (self.countImage == 1){
        scrollView.pagingEnabled = NO; //是否翻页
        [scrollView setScrollEnabled:NO];
        
    }else{
        scrollView.pagingEnabled = YES; //是否翻页
    }
    
    scrollView.contentSize = CGSizeMake(viewSize.size.width * pageCount, viewSize.size.height);                                   //滚动范围的大小
    scrollView.showsHorizontalScrollIndicator = NO; //水平方向的滚动指示
    scrollView.showsVerticalScrollIndicator = NO;   //垂直方向的滚动指示
    scrollView.scrollsToTop = NO;                   //是否控制控件滚动到顶部
    scrollView.delegate = self;
    
    [self addImageViewInView:imageArray_m pageTotalCounts:pageCount];
    // Initialization code
  
    
}

#pragma mark- ScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    CGFloat pageWidth = scrollView.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    currentPageIndex=page;
    
    pageControl.currentPage=(page-1);
    int titleIndex=page-1;
    if (titleIndex==[noteTitleArray count]) {
        titleIndex=0;
    }
    if (titleIndex<0) {
        titleIndex=(int)[noteTitleArray count]-1;
    }
    [noteTitle setText:[noteTitleArray objectAtIndex:titleIndex]];
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)_scrollView
{
    if (currentPageIndex ==0 ) {
        
        [_scrollView setContentOffset:CGPointMake(([imageArray_m count]-2)*viewSize.size.width, 0)]; //是跳转到你指定内容的坐标
    }
    if (currentPageIndex==([imageArray_m count]-1)) {
        
        [_scrollView setContentOffset:CGPointMake(viewSize.size.width, 0)];
        
    }
    
}


#pragma mark- ScrollerViewLoop
-(void)startLoopAnimatedTime{
    loopTime =  [NSTimer scheduledTimerWithTimeInterval:self.currenLoopTime target:self selector:@selector(runTimePage) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop]addTimer:loopTime forMode:NSRunLoopCommonModes];
    
}

-(void)stopLoopAnimageTime
{
    self.loopTime = nil;
    [self.loopTime invalidate];
}
-(void)runTimePage
{
    NSInteger page = pageControl.currentPage; // 获取当前的page
    page++;
    page = page >= self.countImage  ? 0 : page ;
    pageControl.currentPage = page;
    [self turnPage];
}

-(void)turnPage
{
    NSInteger pagenow = pageControl.currentPage; // 获取当前的page
    [self.scrollView scrollRectToVisible:CGRectMake(Screen_W*(pagenow+1),0,Screen_W,460) animated:NO]; // 触摸pagecontroller那个点点 往后翻一页 +1
}


#pragma mark- Add NodeView and PageControl
-(void)addBannerStyle;
{
    CGFloat pageControlWidth  = self.defaultPageWidth;
    CGFloat pagecontrolHeight = self.defaultPageHeight;
    if (self.isAddNodeView == YES)
    {
 
         noteView=[[UIView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height-30,self.bounds.size.width,30)];
        [noteView setBackgroundColor:self.defaultNodeViewColor];
        
        if(self.countImage > 1){
            CGRect frame = CGRectMake((self.frame.size.width-pageControlWidth - 5),6, pageControlWidth, pagecontrolHeight);
            
            pageControl=[[StyledPageControl alloc]initWithFrame:frame];
            [pageControl setPageControlStyle:PageControlStyleDefault];
            [pageControl setNumberOfPages:(pageCount-2)];
            [pageControl setCurrentPage:0];
            
            [noteView addSubview:pageControl];
        }

        
        noteTitle=[[UILabel alloc] initWithFrame:CGRectMake(5, 6, self.frame.size.width-pageControlWidth-15, 20)];
        [noteTitle setText:[noteTitleArray objectAtIndex:0]];
         noteTitle.textColor =  self.defaultNodeTitleColor;
        [noteTitle setBackgroundColor:[UIColor clearColor]];
        [noteTitle setFont:[UIFont systemFontOfSize:13]];
        [noteView addSubview:noteTitle];
        [self addSubview:noteView];

    }else
    {
        
        if(self.countImage > 1){
            
            if(self.countImage > 1){
                
                CGRect frame;
                
                if (self.type == PageControlTypeCenter) {
                    
                    //居中
                    frame = CGRectMake((self.frame.size.width/2-pageControlWidth/2),self.frame.size.height - 20, pageControlWidth, pagecontrolHeight);
                    
                }else if (self.type == PageControlTypeLeft) {
                   
                    frame =CGRectMake(10, self.frame.size.height - 20, pageControlWidth, pagecontrolHeight);
                    
                }else{
         
                    frame =CGRectMake((self.frame.size.width - pageControlWidth + 30), self.frame.size.height - 20, pageControlWidth, pagecontrolHeight);
           
                }
                
            pageControl = [[StyledPageControl alloc] initWithFrame:frame];
            [pageControl setPageControlStyle:PageControlStyleDefault];
            pageControl.coreNormalColor =  self.defaultPageNormColor;
            pageControl.alpha = 0.7;
            pageControl.coreSelectedColor = self.defaultPageSelectColor;
            [pageControl setNumberOfPages:(pageCount-2)];
            [pageControl setCurrentPage:0];
            [self addSubview:pageControl];
          }
        }

    }


}
- (void)animationTimerDidFired:(NSTimer *)timer
{
    CGPoint newOffset = CGPointMake(self.scrollView.contentOffset.x + CGRectGetWidth(self.scrollView.frame), self.scrollView.contentOffset.y);
    [self.scrollView setContentOffset:newOffset animated:YES];
}


#pragma mark- ImageViewTapGestureRecognizer
-(void)addImageViewInView:(NSArray *)imageArray pageTotalCounts:(NSInteger)pageTotalCounts
{
    for (int i = 0; i < pageTotalCounts; i++)
    {
        NSString    *bannerImgeURL = [imageArray objectAtIndex:i];
        UIImageView *bannerImgeView    = [[UIImageView alloc] init];
        bannerImgeView.clipsToBounds = YES;
        bannerImgeView.contentMode   = UIViewContentModeScaleAspectFill;
        
        if ([bannerImgeURL hasPrefix:@"http://"] ||[bannerImgeURL hasPrefix:@"https://"]) {
            
           // [bannerImgeView sd_setImageWithRunWayURL:[NSURL URLWithString:bannerImgeURL]];
        }
        else
        {
            
            UIImage *localImage=[UIImage imageNamed:[imageArray objectAtIndex:i]];
            [bannerImgeView setImage:localImage];
        }
        
        [bannerImgeView setFrame:CGRectMake(viewSize.size.width*i, 0,viewSize.size.width, viewSize.size.height)];
        
        bannerImgeView.tag=i;
        
        //创建滑动手势
        UITapGestureRecognizer *Tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imagePressed:)] ;
        [Tap setNumberOfTapsRequired:1];     // 需要手指的个数
        [Tap setNumberOfTouchesRequired:1];  // 需要长按时间
        bannerImgeView.userInteractionEnabled=YES;  // imageview 可以点击事件
        [bannerImgeView addGestureRecognizer:Tap];  //添加手势
        [scrollView addSubview:bannerImgeView];
        
        if(!self.hideDeleteButton){
            
            [self initWithDeleteButton:bannerImgeView];
         
        }
        
        
    }
    
    [scrollView setContentOffset:CGPointMake(viewSize.size.width, 0)];
    [self addSubview:scrollView];
    [self addBannerStyle];
    [self startLoopAnimatedTime];
    
}

- (void)imagePressed:(UITapGestureRecognizer *)sender
{
    if (self.tapBannerImageViewActionBlock) {
        self.tapBannerImageViewActionBlock(sender.view.tag);
    }
    
    if (self.delegate &&[self.delegate respondsToSelector:@selector(selectBannerIndex:)]) {
        [self.delegate selectBannerIndex:sender.view.tag];
    }
}


#pragma mark - ImageViewDelete
- (void)initWithDeleteButton:(UIImageView *)imageView{
    
    self.deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.deleteButton.frame = CGRectMake(Screen_W - 38, 5,33, 33);
    [self.deleteButton setBackgroundImage:[UIImage imageNamed:@"bannerDelete"] forState:UIControlStateNormal];
    [self.deleteButton addTarget:self action:@selector(deleteButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [imageView addSubview:self.deleteButton];
}
-(void)deleteButtonAction{
    
    if (self.deleteBlocek){
        self.deleteBlocek();
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(deleteBanner)]) {
        [self.delegate deleteBanner];
    }
    
}

//假如你有5个元素需要循环：
//
//[0, 1, 2, 3, 4]
//
//那么你在将这四个元素添加到UIScrollView里面的时候，就需要多添加两个，变成这样：
//
//[ 4, 0, 1, 2, 3, 4, 0 ]

@end
