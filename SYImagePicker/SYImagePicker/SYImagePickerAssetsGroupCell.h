//
//  SYImagePickerAlbumCell.h
//  ShareJobStudent
//
//  Created by Sunnyyoung on 15/11/5.
//  Copyright © 2015年 GeekBean Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

static NSString * const AssetsGroupCell = @"AssetsGroupCell";

@interface SYImagePickerAssetsGroupCell : UITableViewCell

@property (nonatomic) ALAssetsGroup *assetsGroup;

@end
