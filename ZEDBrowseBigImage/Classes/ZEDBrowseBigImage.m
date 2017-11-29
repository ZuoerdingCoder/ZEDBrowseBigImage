//
//  ZEDBrowseBigImage.m
//  FBSnapshotTestCase
//
//  Created by 超李 on 2017/11/29.
//

#import "ZEDBrowseBigImage.h"
#import <SDWebImage/UIImageView+WebCache.h>

#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

@interface ZEDBrowseBigImage ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIImageView *originImageView;

@property (nonatomic, strong) UIWindow *window;

@property (nonatomic, strong) UIScrollView *backgroundView;
@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation ZEDBrowseBigImage

+ (instancetype)shareBrowseImageHelper {
    static ZEDBrowseBigImage *helper = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        helper = [[self alloc] init];
    });
    return helper;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statusBarOrientationDidChange:)
                                                     name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
    NSLog(@"ZEDBrowseBigImage dealloc");
}



- (void)browseImageWithImageView:(UIImageView *)currentImageView portrait:(NSString *)portrait {
    
    //1.当前imageview的图片与原始的尺寸
    self.originImageView = currentImageView;
    CGRect oldFrame = [self.originImageView convertRect:self.originImageView.bounds toView:self.window];
    
    //2.配置动画前基础数据
    self.backgroundView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    self.backgroundView.backgroundColor = [UIColor blackColor];
    [self.backgroundView setAlpha:0];
    self.imageView.frame = oldFrame;
    [self.imageView setImage:currentImageView.image];
    if (portrait) {
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:portrait] placeholderImage:currentImageView.image];
    }
    [self.backgroundView addSubview:self.imageView];
    [self.window addSubview:self.backgroundView];
    
    //3.添加单击手势回到初始大小
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideImageView:)];
    [self.backgroundView addGestureRecognizer:tapGestureRecognizer];
    
    //4.计算图片宽高
    CGFloat width,height;
    
    if (ScreenHeight > ScreenWidth) {
        //宽度为屏幕宽度
        width = ScreenWidth;
        //高度 根据图片宽高比设置
        height = self.originImageView.frame.size.height * [UIScreen mainScreen].bounds.size.width / self.originImageView.frame.size.width;
    } else {
        width = ScreenHeight;
        height = self.originImageView.frame.size.width * [UIScreen mainScreen].bounds.size.height / self.originImageView.frame.size.height;
    }
    
    //5.执行动画
    [UIView animateWithDuration:0.4 animations:^{
        CGRect frame = self.imageView.frame;
        frame.size = CGSizeMake(width, height);
        self.imageView.frame = frame;
        self.imageView.center = self.backgroundView.center;
        [self.backgroundView setAlpha:1];
    } completion:^(BOOL finished) {
        
    }];
}

- (void)hideImageView:(UITapGestureRecognizer *)tap{
    
    //先缩放到正常状态
    self.backgroundView.zoomScale = 1;
    self.imageView.center = self.backgroundView.center;
    
    //执行缩放动画
    CGRect oldFrame = [self.originImageView convertRect:self.originImageView.bounds toView:self.window];
    [UIView animateWithDuration:0.4 animations:^{
        [self.imageView setFrame:oldFrame];
        [self.backgroundView setAlpha:1];
    } completion:^(BOOL finished) {
        //动画完成后将背景视图删掉
        [self.backgroundView removeFromSuperview];
        [self.imageView removeFromSuperview];
        self.backgroundView = nil;
        self.imageView = nil;
    }];
}

- (void)subviewsLayout {
    self.backgroundView.zoomScale = 1;
    self.backgroundView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    self.imageView.center = self.backgroundView.center;
}

#pragma mark - UIScrollViewDelegate
- (nullable UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

#pragma mark - StatusBarOrientation
- (void)statusBarOrientationDidChange:(NSNotification *)sender {
    [self subviewsLayout];
}

#pragma mark - Getter
- (UIWindow *)window {
    if (!_window) {
        _window = [UIApplication sharedApplication].keyWindow;
    }
    return _window;
}

- (UIScrollView *)backgroundView {
    if (!_backgroundView) {
        _backgroundView = [[UIScrollView alloc] init];
        _backgroundView.bounces = YES;
        _backgroundView.maximumZoomScale = 2.5;
        _backgroundView.minimumZoomScale = 1;
        _backgroundView.scrollEnabled = YES;
        _backgroundView.delegate = self;
        _backgroundView.backgroundColor = [UIColor blackColor];
    }
    return _backgroundView;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
    }
    return _imageView;
}

@end
