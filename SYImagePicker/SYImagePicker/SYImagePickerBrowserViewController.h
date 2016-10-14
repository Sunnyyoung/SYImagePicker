//
//  SYImagePickerBrowserViewController.h
//  ShareJobStudent
//
//  Created by Sunnyyoung on 15/11/5.
//  Copyright © 2015年 GeekBean Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@class SYImagePickerBrowserViewController;

@protocol SYImagePickerBrowserViewControllerDelegate <NSObject>

@required
- (NSUInteger)numberOfSelectedAssetsInBrowserViewController:(SYImagePickerBrowserViewController *)browserViewController;
- (NSUInteger)browserViewController:(SYImagePickerBrowserViewController *)browserViewController selectedIndexOfAsset:(ALAsset *)asset;
- (void)browserViewController:(SYImagePickerBrowserViewController *)browserViewController selectAsset:(ALAsset *)asset;
- (void)browserViewController:(SYImagePickerBrowserViewController *)browserViewController deselectAsset:(ALAsset *)asset;
- (void)browserViewController:(SYImagePickerBrowserViewController *)browserViewController didFinishSelectAsset:(ALAsset *)asset;

@end

@interface SYImagePickerBrowserViewController : UICollectionViewController

@property (nonatomic, weak) id <SYImagePickerBrowserViewControllerDelegate> delegate;

- (instancetype)initWithAssetsArray:(NSArray *)assetsArray currentIndex:(NSInteger)currentIndex;

- (void)hideControls;
- (void)toggleControls;

@end
