//
//  SYImagePickerViewController.m
//  ShareJobStudent
//
//  Created by Sunnyyoung on 15/11/5.
//  Copyright © 2015年 GeekBean Technology Co., Ltd. All rights reserved.
//

#import "SYImagePickerViewController.h"
#import "SYImagePickerAssetsGroupViewController.h"
#import "SYImagePickerAssetsViewController.h"
#import "SYImagePickerBrowserViewController.h"

@interface SYImagePickerViewController () <UINavigationControllerDelegate>

@end

@implementation SYImagePickerViewController

#pragma mark - LifeCycle

- (instancetype)init {
    SYImagePickerAssetsGroupViewController *rootViewController = [[SYImagePickerAssetsGroupViewController alloc] init];
    self = [[SYImagePickerViewController alloc] initWithRootViewController:rootViewController];
    if (self) {
        self.delegate = self;
        self.navigationBar.translucent = YES;
        self.toolbar.translucent = YES;
    }
    return self;
}

- (instancetype)initWithTarget:(id)target {
    self = [self init];
    if (self) {
        self.imagePickerDataSource = target;
        self.imagePickerDelegate = target;
    }
    return self;
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if ([viewController isKindOfClass:[SYImagePickerAssetsGroupViewController class]]) {
        viewController.navigationController.toolbarHidden = YES;
    } else {
        viewController.navigationController.toolbarHidden = NO;
    }
}

@end
