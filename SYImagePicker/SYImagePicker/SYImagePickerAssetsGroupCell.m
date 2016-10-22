//
//  SYImagePickerAlbumCell.m
//  ShareJobStudent
//
//  Created by Sunnyyoung on 15/11/5.
//  Copyright © 2015年 GeekBean Technology Co., Ltd. All rights reserved.
//

#import "SYImagePickerAssetsGroupCell.h"

@implementation SYImagePickerAssetsGroupCell

- (instancetype)init {
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:AssetsGroupCell];
    if (self) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return self;
}

#pragma mark - Property method

- (void)setAssetsGroup:(ALAssetsGroup *)assetsGroup {
    __weak typeof(self) weakSelf = self;
    [assetsGroup enumerateAssetsAtIndexes:[NSIndexSet indexSetWithIndex:assetsGroup.numberOfAssets - 1] options:NSEnumerationConcurrent usingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
        if (result) {
            *stop = YES;
            weakSelf.imageView.image = [UIImage imageWithCGImage:result.thumbnail];
        }
    }];
    self.textLabel.text = [assetsGroup valueForProperty:ALAssetsGroupPropertyName];
    self.detailTextLabel.text = @(assetsGroup.numberOfAssets).stringValue;
}

@end
