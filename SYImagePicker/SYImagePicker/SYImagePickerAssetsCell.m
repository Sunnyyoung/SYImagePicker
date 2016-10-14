//
//  SYImagePickerAssetsCell.m
//  ShareJobStudent
//
//  Created by Sunnyyoung on 15/11/5.
//  Copyright © 2015年 GeekBean Technology Co., Ltd. All rights reserved.
//

#import "SYImagePickerAssetsCell.h"
#import "SYImagePickerSelectButton.h"

@interface SYImagePickerAssetsCell ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) SYImagePickerSelectButton *selectButton;

@end

@implementation SYImagePickerAssetsCell

#pragma mark - LifeCycle

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.imageView];
        [self addSubview:self.selectButton];
    }
    return self;
}

#pragma mark - Event Response

- (void)selectAction {
    if (self.selectButton.selectIndex != 0 && [self.delegate respondsToSelector:@selector(didDeselectAssetsCell:)]) {
        [self.delegate didDeselectAssetsCell:self];
    } else if (self.selectButton.selectIndex == 0 && [self.delegate respondsToSelector:@selector(didSelectAssetsCell:)]) {
        [self.delegate didSelectAssetsCell:self];
    }
}

#pragma mark - Property method

- (SYImagePickerSelectButton *)selectButton {
    if (_selectButton == nil) {
        _selectButton = [[SYImagePickerSelectButton alloc] initWithSourceFrame:self.frame];
        [_selectButton addTarget:self action:@selector(selectAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _selectButton;
}

- (UIImageView *)imageView {
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
    }
    return _imageView;
}

- (NSUInteger)selectedIndex {
    return self.selectButton.selectIndex;
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex {
    self.selectButton.selectIndex = selectedIndex;
}

- (void)setAsset:(ALAsset *)asset {
    CGImageRef thumbnailImageRef = [asset thumbnail];
    if (thumbnailImageRef) {
        self.imageView.image = [UIImage imageWithCGImage:thumbnailImageRef];
    }
}

@end
