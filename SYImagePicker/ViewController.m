//
//  ViewController.m
//  SYImagePicker
//
//  Created by Sunnyyoung on 2016/10/13.
//  Copyright © 2016年 Sunnyyoung. All rights reserved.
//

#import "ViewController.h"
#import "SYImagePickerViewController.h"

@interface ViewController () <SYImagePickerBrowserViewControllerDataSource, SYImagePickerViewControllerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - ImagePicker DataSource

- (NSUInteger)maximumSelectionForImagePickerViewController:(SYImagePickerViewController *)imagePickerViewController {
    return 2;
}

#pragma mark - ImagePicker Delegate

- (void)imagePickerViewController:(SYImagePickerViewController *)imagePickerViewController didFinishSelectImages:(NSArray *)images thumbs:(NSArray *)thumbs {
    [imagePickerViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerViewController:(SYImagePickerViewController *)imagePickerViewController didExceedMaximumSelection:(NSUInteger)maximumSelection {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:[NSString stringWithFormat:@"最多可以选择%@张", @(maximumSelection)]
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil, nil];
    [alertView show];
}

- (void)imagePickerViewControllerDidCancel:(SYImagePickerViewController *)imagePickerViewController {
    [imagePickerViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerViewController:(SYImagePickerViewController *)imagePickerViewController didFailToLoadAssetsGroupsWithError:(NSError *)error {
    if ([ALAssetsLibrary authorizationStatus] != ALAuthorizationStatusAuthorized) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"请打开口袋兼职的相册权限"
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil, nil];
        [alertView show];
    }
}

- (void)imagePickerViewController:(SYImagePickerViewController *)imagePickerViewController didFailToLoadAssetsWithError:(NSError *)error {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"加载图片失败"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil, nil];
    [alertView show];
}

- (IBAction)showAction:(id)sender {
    SYImagePickerViewController *picker = [[SYImagePickerViewController alloc] initWithTarget:self];
    [self presentViewController:picker animated:YES completion:nil];
}

@end
