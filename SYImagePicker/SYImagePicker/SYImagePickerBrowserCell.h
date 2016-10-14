//
//  SYImagePickerBrowserCell.h
//  ShareJobStudent
//
//  Created by Sunnyyoung on 15/11/5.
//  Copyright © 2015年 GeekBean Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@class SYImagePickerBrowserViewController;

@interface SYImagePickerBrowserCell : UICollectionViewCell

@property (nonatomic, weak) SYImagePickerBrowserViewController *browserViewController;

@property (nonatomic, strong) ALAsset *asset;

@end
