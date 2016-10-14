//
//  SYImagePickerViewController.h
//  ShareJobStudent
//
//  Created by Sunnyyoung on 15/11/5.
//  Copyright © 2015年 GeekBean Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SYImagePickerViewController;

@protocol SYImagePickerBrowserViewControllerDataSource <NSObject>

@optional
- (NSUInteger)maxSelectionForImagePickerViewController:(SYImagePickerViewController *)imagePickerViewController;

@end

@protocol SYImagePickerViewControllerDelegate <NSObject>

@required
- (void)imagePickerViewController:(SYImagePickerViewController *)imagePickerViewController didFinishSelectImages:(NSArray *)images thumbs:(NSArray *)thumbs;
- (void)imagePickerViewControllerDidCancel:(SYImagePickerViewController *)imagePickerViewController;

@end

@interface SYImagePickerViewController : UINavigationController

@property (nonatomic, weak) id <SYImagePickerBrowserViewControllerDataSource> imagePickerDataSource;
@property (nonatomic, weak) id <SYImagePickerViewControllerDelegate> imagePickerDelegate;

- (instancetype)initWithTarget:(id)target;

@end
