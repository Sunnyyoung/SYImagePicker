//
//  SYImagePickerDetectingImageView.h
//  ShareJobStudent
//
//  Created by Sunnyyoung on 15/11/5.
//  Copyright © 2015年 GeekBean Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SYImagePickerDetectingImageViewDelegate;

@interface SYImagePickerDetectingImageView : UIImageView

@property (nonatomic, weak) id <SYImagePickerDetectingImageViewDelegate> tapDelegate;

@end

@protocol SYImagePickerDetectingImageViewDelegate <NSObject>

@optional

- (void)imageView:(UIImageView *)imageView singleTapDetected:(UITouch *)touch;
- (void)imageView:(UIImageView *)imageView doubleTapDetected:(UITouch *)touch;

@end
