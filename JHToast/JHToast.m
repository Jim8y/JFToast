//
//  JHToast.m
//  JHToast
//
//  Created by 廖京辉 on 3/18/16.
//  Copyright © 2016 廖京辉. All rights reserved.
//

#import "JHToast.h"

@interface JHToast ()

- (instancetype)initWithText:(NSString *)text;
- (void)setDuration:(CGFloat)duration;

- (void)dismissToast;
- (void)toastTaped:(UIButton *)button;

- (void)showAnimation;
- (void)hideAnimation;

- (void)show;
- (void)showFromBottomOffset:(CGFloat)bottomOffset;

@end

@implementation JHToast
static JHToast *toast;

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:[UIDevice currentDevice]];
}

- (id)initWithText:(NSString *)text{
    if (self = [super init]) {
        
        _text = [text copy];
        
        UIFont *font = [UIFont boldSystemFontOfSize:14];
        CGSize textSize = [text boundingRectWithSize:CGSizeMake(280, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : font} context:nil].size;
        
        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, textSize.width + 12, textSize.height + 12)];
        textLabel.backgroundColor = [UIColor clearColor];
        textLabel.textColor = [UIColor whiteColor];
        textLabel.textAlignment = NSTextAlignmentCenter;
        textLabel.font = font;
        textLabel.text = text;
        textLabel.numberOfLines = 0;
        
        _contentView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, textLabel.frame.size.width, textLabel.frame.size.height)];
        _contentView.layer.cornerRadius = 5.0f;
        _contentView.layer.masksToBounds = YES;
        _contentView.layer.borderWidth = 1.0f;
        _contentView.layer.borderColor = [[UIColor grayColor] colorWithAlphaComponent:0.5].CGColor;
        _contentView.backgroundColor = [UIColor colorWithRed:0.0f
                                                       green:0.0f
                                                        blue:0.0f
                                                       alpha:1.0f];
        [_contentView addSubview:textLabel];
        _contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [_contentView addTarget:self
                         action:@selector(toastTaped:)
               forControlEvents:UIControlEventTouchDown];
        _contentView.alpha = 0.0f;
        
        _duration = DEFAULT_DISPLAY_DURATION;
        
        // 监听屏幕方向改变的通知
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(deviceOrientationDidChanged:)
                                                     name:UIDeviceOrientationDidChangeNotification
                                                   object:[UIDevice currentDevice]];
    }
    return self;
}

- (void)deviceOrientationDidChanged:(NSNotification *)aNotification
{
    [self hideAnimation];
}

/** 设置延迟消失的时间 */
- (void)setDuration:(CGFloat)duration
{
    _duration = duration;
}

/** 移除Toast */
- (void)dismissToast
{
    [_contentView removeFromSuperview];
}

/** 点击了Toast则移除 */
- (void)toastTaped:(UIButton *)button
{
    [self hideAnimation];
}

/** 带动画改变Toast的透明度 */
- (void)showAnimation
{
    [UIView animateWithDuration:0.3 animations:^{
        _contentView.alpha = 0.7;
    }];
}

/** 先改变透明度，再移除Toast，带动画 */
- (void)hideAnimation
{
    [UIView animateWithDuration:0.3 animations:^{
        _contentView.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self dismissToast];
    }];
}

/** 显示Toast，带动画 */
- (void)show
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    _contentView.center = window.center;
    [window addSubview:_contentView];
    [self showAnimation];
    [self performSelector:@selector(hideAnimation) withObject:nil afterDelay:_duration];
}


/** 偏离底部多少以显示Toast */
- (void)showFromBottomOffset:(CGFloat)bottomOffset
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    _contentView.center = CGPointMake(window.center.x, window.frame.size.height - (bottomOffset + _contentView.frame.size.height / 2));
    [window addSubview:_contentView];
    [self showAnimation];
    [self performSelector:@selector(hideAnimation) withObject:nil afterDelay:_duration];
}

/** Toast显示text, 偏离底部topOffset, 经duration时间后移除 */
+ (void)showWithText:(NSString *)text bottomOffset:(CGFloat)bottomOffset duration:(CGFloat)duration
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        toast = [[JHToast alloc] initWithText:text];
    });
    
    [toast setDuration:duration];
    [toast showFromBottomOffset:bottomOffset];
}

@end
