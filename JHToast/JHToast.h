//
//  JHToast.h
//  JHToast
//
//  Created by 廖京辉 on 3/18/16.
//  Copyright © 2016 廖京辉. All rights reserved.
//

#import <UIKit/UIKit.h>

#define DEFAULT_DISPLAY_DURATION 2.0f

@interface JHToast : UIView {
    NSString *_text;
    UIButton *_contentView;
    CGFloat _duration;
}
+ (void)showWithText:(NSString *)text bottomOffset:(CGFloat)bottomOffset duration:(CGFloat)duration;

@end
