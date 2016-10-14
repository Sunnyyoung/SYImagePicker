//
//  SYImagePickerAssetsGroupViewController.m
//  ShareJobStudent
//
//  Created by Sunnyyoung on 15/11/5.
//  Copyright © 2015年 GeekBean Technology Co., Ltd. All rights reserved.
//

#import "SYImagePickerAssetsGroupViewController.h"
#import "SYImagePickerViewController.h"
#import "SYImagePickerAssetsViewController.h"
#import "SYImagePickerAssetsGroupCell.h"

@interface SYImagePickerAssetsGroupViewController ()

@property (nonatomic, strong) ALAssetsLibrary *assetsLibrary;
@property (nonatomic, copy) NSArray *assetsGroupArray;

@end

@implementation SYImagePickerAssetsGroupViewController

#pragma mark - LifeCycle

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)setup {
    [self setTitle:@"相册"];
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelAction)]];
    [self.tableView setTableFooterView:[[UIView alloc] init]];
    [self.tableView registerClass:[SYImagePickerAssetsGroupCell class] forCellReuseIdentifier:AssetsGroupCell];
}

#pragma mark - TableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.assetsGroupArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 64.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SYImagePickerAssetsGroupCell *cell = [tableView dequeueReusableCellWithIdentifier:AssetsGroupCell forIndexPath:indexPath];
    ALAssetsGroup *assetsGroup = self.assetsGroupArray[indexPath.row];
    cell.assetsGroup = assetsGroup;
    return cell;
}

#pragma mark - TableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ALAssetsGroup *assetsGroup = self.assetsGroupArray[indexPath.row];
    NSString *title = [assetsGroup valueForProperty:ALAssetsGroupPropertyName];
    NSURL *url = [assetsGroup valueForProperty:ALAssetsGroupPropertyURL];
    SYImagePickerAssetsViewController *assetsViewController = [[SYImagePickerAssetsViewController alloc] initWithTitle:title assetsGroupURL:url];
    [self.navigationController pushViewController:assetsViewController animated:YES];
}

#pragma mark - Event Response

- (void)cancelAction {
    if ([((SYImagePickerViewController *)self.navigationController).imagePickerDelegate respondsToSelector:@selector(imagePickerViewControllerDidCancel:)]) {
        [((SYImagePickerViewController *)self.navigationController).imagePickerDelegate imagePickerViewControllerDidCancel:(SYImagePickerViewController *)self.navigationController];
    }
}

#pragma mark - Private method

- (void)loadAssetsGroupsWithTypes:(NSArray *)types completion:(void (^)(NSArray *assetsGroups))completion {
    __block NSMutableArray *assetsGroups = [NSMutableArray array];
    __block NSUInteger numberOfFinishedTypes = 0;
    for (NSNumber *type in types) {
        [self.assetsLibrary enumerateGroupsWithTypes:[type unsignedIntegerValue] usingBlock:^(ALAssetsGroup *assetsGroup, BOOL *stop) {
            if (assetsGroup) {
                // Filter the assets group
                [assetsGroup setAssetsFilter:[ALAssetsFilter allPhotos]];
                // Add assets group
                if (assetsGroup.numberOfAssets > 0) {
                    // Add assets group
                    [assetsGroups addObject:assetsGroup];
                }
            } else {
                numberOfFinishedTypes++;
            }

            // Check if the loading finished
            if (numberOfFinishedTypes == types.count) {
                //sort
                NSArray *sortedAssetsGroups = [assetsGroups sortedArrayUsingComparator:^NSComparisonResult (id obj1, id obj2) {

                    ALAssetsGroup *a = obj1;
                    ALAssetsGroup *b = obj2;

                    NSNumber *apropertyType = [a valueForProperty:ALAssetsGroupPropertyType];
                    NSNumber *bpropertyType = [b valueForProperty:ALAssetsGroupPropertyType];
                    if ([apropertyType compare:bpropertyType] == NSOrderedAscending) {
                        return NSOrderedDescending;
                    }
                    return NSOrderedSame;
                }];
                // Call completion block
                if (completion) {
                    completion(sortedAssetsGroups);
                }
            }
        } failureBlock:^(NSError *error) {
            if ([ALAssetsLibrary authorizationStatus] != ALAuthorizationStatusAuthorized) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                    message:@"请打开口袋兼职的相册权限"
                                                                   delegate:nil
                                                          cancelButtonTitle:@"确定"
                                                          otherButtonTitles:nil, nil];
                [alertView show];
            }
        }];
    }
}

#pragma mark - Property method

- (ALAssetsLibrary *)assetsLibrary {
    if (_assetsLibrary == nil) {
        _assetsLibrary = [[ALAssetsLibrary alloc] init];
    }
    return _assetsLibrary;
}

- (NSArray *)assetsGroupArray {
    if (_assetsGroupArray == nil) {
        __weak typeof(self) weakSelf = self;
        [self loadAssetsGroupsWithTypes:@[@(ALAssetsGroupAll)] completion:^(NSArray *assetsGroups) {
            _assetsGroupArray = assetsGroups;
            [weakSelf.tableView reloadData];
        }];
    }
    return _assetsGroupArray;
}

@end
