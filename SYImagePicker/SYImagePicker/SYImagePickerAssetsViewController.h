//
//  SYImagePickerAssetsViewController.h
//  ShareJobStudent
//
//  Created by Sunnyyoung on 15/11/5.
//  Copyright © 2015年 GeekBean Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface SYImagePickerAssetsViewController : UICollectionViewController

- (instancetype)initWithTitle:(NSString *)title assetsGroupURL:(NSURL *)assetsGroupURL;

@end
