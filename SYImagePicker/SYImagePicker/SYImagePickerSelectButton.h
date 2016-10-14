//
//  SYImagePickerSelectButton.h
//  ShareJobStudent
//
//  Created by Sunnyyoung on 15/11/8.
//  Copyright © 2015年 GeekBean Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SYImagePickerSelectButton : UIButton

@property (nonatomic, assign) NSUInteger selectIndex;

- (instancetype)initWithSourceFrame:(CGRect)sourceFrame;

@end
