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
        [self setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
    return self;
}

#pragma mark - Property method

- (void)setAssetsGroup:(ALAssetsGroup *)assetsGroup {
    __weak UITableViewCell *blockSelf = self;
    [assetsGroup enumerateAssetsAtIndexes:[NSIndexSet indexSetWithIndex:assetsGroup.numberOfAssets - 1] options:NSEnumerationConcurrent usingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
        if (result) {
            *stop = YES;
            blockSelf.imageView.image = [UIImage imageWithCGImage:result.thumbnail];
        }
    }];
    [self.textLabel setText:[assetsGroup valueForProperty:ALAssetsGroupPropertyName]];
    [self.detailTextLabel setText:@(assetsGroup.numberOfAssets).stringValue];
}

@end
