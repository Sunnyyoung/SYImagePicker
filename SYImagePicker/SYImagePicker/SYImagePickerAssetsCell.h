//
//  SYImagePickerAssetsCell.h
//  ShareJobStudent
//
//  Created by Sunnyyoung on 15/11/5.
//  Copyright © 2015年 GeekBean Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@class SYImagePickerAssetsCell;

static NSString * const AssetsCell = @"AssetsCell";

@protocol SYImagePickerAssetsCellDelegate <NSObject>

- (void)didSelectAssetsCell:(SYImagePickerAssetsCell *)assetsCell;
- (void)didDeselectAssetsCell:(SYImagePickerAssetsCell *)assetsCell;

@end

@interface SYImagePickerAssetsCell : UICollectionViewCell

@property (nonatomic) ALAsset *asset;
@property (nonatomic) NSUInteger selectedIndex;
@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, weak) id <SYImagePickerAssetsCellDelegate> delegate;

@end
