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

- (NSUInteger)maxSelectionForImagePickerViewController:(SYImagePickerViewController *)imagePickerViewController {
    return 2;
}

#pragma mark - ImagePicker Delegate

- (void)imagePickerViewController:(SYImagePickerViewController *)imagePickerViewController didFinishSelectImages:(NSArray *)images thumbs:(NSArray *)thumbs {
    [imagePickerViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerViewControllerDidCancel:(SYImagePickerViewController *)imagePickerViewController {
    [imagePickerViewController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)showAction:(id)sender {
    SYImagePickerViewController *picker = [[SYImagePickerViewController alloc] initWithTarget:self];
    [self presentViewController:picker animated:YES completion:nil];
}

@end
