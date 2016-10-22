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
@property (nonatomic, strong) NSArray *assetsGroupArray;

@end

@implementation SYImagePickerAssetsGroupViewController

#pragma mark - LifeCycle

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupNavigationItem];
        [self setupTableView];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    __weak typeof(self) weakSelf = self;
    [self loadAssetsGroupsWithTypes:@[@(ALAssetsGroupAll)] completion:^(NSArray *assetsGroups) {
        weakSelf.assetsGroupArray = assetsGroups;
        [weakSelf.tableView reloadData];
    }];
}

#pragma mark - Setup method

- (void)setupNavigationItem {
    self.title = @"相册";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelAction)];
}

- (void)setupTableView {
    self.tableView.tableFooterView = [[UIView alloc] init];
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
    SYImagePickerViewController *imagePickerViewController = (SYImagePickerViewController *)self.navigationController;
    if ([imagePickerViewController.imagePickerDelegate respondsToSelector:@selector(imagePickerViewControllerDidCancel:)]) {
        [imagePickerViewController.imagePickerDelegate imagePickerViewControllerDidCancel:(SYImagePickerViewController *)self.navigationController];
    }
}

#pragma mark - Private method

- (void)loadAssetsGroupsWithTypes:(NSArray *)types completion:(void (^)(NSArray *assetsGroups))completion {
    __block NSMutableArray *assetsGroups = [NSMutableArray array];
    __block NSUInteger numberOfFinishedTypes = 0;
    for (NSNumber *type in types) {
        [self.assetsLibrary enumerateGroupsWithTypes:type.unsignedIntegerValue usingBlock:^(ALAssetsGroup *assetsGroup, BOOL *stop) {
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
            SYImagePickerViewController *imagePickerViewController = (SYImagePickerViewController *)self.navigationController;
            if ([imagePickerViewController.imagePickerDelegate respondsToSelector:@selector(imagePickerViewController:didFailToLoadAssetsGroupsWithError:)]) {
                [imagePickerViewController.imagePickerDelegate imagePickerViewController:imagePickerViewController didFailToLoadAssetsGroupsWithError:error];
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

@end
