//
//  SYImagePickerSelectButton.m
//  ShareJobStudent
//
//  Created by Sunnyyoung on 15/11/8.
//  Copyright © 2015年 GeekBean Technology Co., Ltd. All rights reserved.
//

#import "SYImagePickerSelectButton.h"

static const CGFloat SYImagePickerSelectButtonSize = 30.0;

@implementation SYImagePickerSelectButton

#pragma mark - LifeCycle

- (instancetype)init {
    self = [super initWithFrame:CGRectMake(0, 0, SYImagePickerSelectButtonSize, SYImagePickerSelectButtonSize)];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithSourceFrame:(CGRect)sourceFrame {
    self = [super initWithFrame:CGRectMake(CGRectGetWidth(sourceFrame) - SYImagePickerSelectButtonSize - 4, 4,
                                           SYImagePickerSelectButtonSize, SYImagePickerSelectButtonSize)];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = CGRectGetWidth(self.frame)/2.0;
    self.layer.borderWidth = 1.2;
    self.layer.borderColor = [UIColor whiteColor].CGColor;
    self.layer.shouldRasterize = YES;
    self.layer.rasterizationScale = [UIScreen mainScreen].scale;
    self.titleLabel.font = [UIFont systemFontOfSize:14.0];
    self.selectIndex = 0;
}

#pragma mark- Property method

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    if (selected) {
        self.backgroundColor = [UIColor colorWithRed:0.0/255.0 green:122.0/255.0 blue:255.0/255.0 alpha:1.0];
    } else {
        self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.2];
    }
}

- (void)setSelectIndex:(NSUInteger)selectIndex {
    _selectIndex = selectIndex;
    if (selectIndex == 0) {
        self.selected = NO;
        [self setTitle:nil forState:UIControlStateNormal];
        [self setTitle:nil forState:UIControlStateHighlighted];
    } else {
        self.selected = YES;
        [self setTitle:@(selectIndex).stringValue forState:UIControlStateNormal];
        [self setTitle:@(selectIndex).stringValue forState:UIControlStateHighlighted];
    }
}

@end
