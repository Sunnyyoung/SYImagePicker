//
//  SYImagePickerBrowserViewController.m
//  ShareJobStudent
//
//  Created by Sunnyyoung on 15/11/5.
//  Copyright © 2015年 GeekBean Technology Co., Ltd. All rights reserved.
//

#import "SYImagePickerBrowserViewController.h"
#import "SYImagePickerBrowserCell.h"
#import "SYImagePickerSelectButton.h"

@interface SYImagePickerBrowserViewController () <UICollectionViewDelegateFlowLayout> {
    BOOL _statusBarShouldBeHidden;
}

@property (nonatomic, strong) SYImagePickerSelectButton *selectButton;
@property (nonatomic, strong) UIBarButtonItem *doneButton;

@property (nonatomic, strong) NSMutableArray *assetsArray;
@property (nonatomic, assign) NSInteger currentIndex;

@end

@implementation SYImagePickerBrowserViewController

#pragma mark - LifeCycle

- (instancetype)init {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.minimumLineSpacing = 0;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self = [super initWithCollectionViewLayout:flowLayout];
    if (self) {
        [self.collectionView setFrame:CGRectMake(-10, 0, self.view.bounds.size.width + 20, self.view.bounds.size.height + 1)];
        [self.collectionView setPagingEnabled:YES];
        [self.collectionView setShowsVerticalScrollIndicator:NO];
        [self.collectionView setShowsHorizontalScrollIndicator:NO];
        [self.collectionView registerClass:[SYImagePickerBrowserCell class] forCellWithReuseIdentifier:NSStringFromClass([SYImagePickerBrowserCell class])];
        [self setAutomaticallyAdjustsScrollViewInsets:NO];
        [self.view setClipsToBounds:YES];
        [self setup];
    }
    return self;
}

- (instancetype)initWithAssetsArray:(NSArray *)assetsArray currentIndex:(NSInteger)currentIndex {
    self = [self init];
    if (self) {
        _assetsArray = [[NSMutableArray alloc] initWithArray:assetsArray];
        _currentIndex = currentIndex;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.collectionView setContentOffset:CGPointMake(CGRectGetWidth(self.collectionView.bounds) * self.currentIndex, 0)];
    [self reloadData];
}

#pragma mark - Setup method

- (void)setup {
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:self.selectButton]];
    UIBarButtonItem *flexibleBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [self setToolbarItems:@[flexibleBarButtonItem, self.doneButton]];
}

- (void)reloadData {
    NSUInteger numberOfAssets = self.assetsArray.count;
    self.title = [NSString stringWithFormat:@"%@/%@", @(self.currentIndex + 1), @(numberOfAssets)];
    if ([self.delegate respondsToSelector:@selector(browserViewController:selectedIndexOfAsset:)]) {
        self.selectButton.selectIndex = [self.delegate browserViewController:self selectedIndexOfAsset:self.assetsArray[self.currentIndex]];
    }

    if ([self.delegate respondsToSelector:@selector(numberOfSelectedAssetsInBrowserViewController:)]) {
        NSUInteger numberOfSelectedAssets = [self.delegate numberOfSelectedAssetsInBrowserViewController:self];
        self.doneButton.enabled = numberOfSelectedAssets != 0;
    }
}

#pragma mark - ScrollView Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetX = scrollView.contentOffset.x;
    CGFloat itemWidth = CGRectGetWidth(self.collectionView.frame);
    if (offsetX >= 0) {
        NSInteger page = offsetX / itemWidth;
        self.currentIndex = page;
        [self reloadData];
    }
}

#pragma mark - CollectionView FlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(self.view.bounds.size.width + 20, self.view.bounds.size.height);
}

#pragma mark - CollectionView DataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.assetsArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SYImagePickerBrowserCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([SYImagePickerBrowserCell class]) forIndexPath:indexPath];
    cell.asset = [self.assetsArray objectAtIndex:indexPath.row];
    cell.browserViewController = self;
    return cell;
}

#pragma mark - Event Response

- (void)checkAction {
    if (self.selectButton.selectIndex != 0) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(browserViewController:deselectAsset:)]) {
            [self.delegate browserViewController:self deselectAsset:self.assetsArray[self.currentIndex]];
        }
    } else {
        if (self.delegate && [self.delegate respondsToSelector:@selector(browserViewController:selectAsset:)]) {
            [self.delegate browserViewController:self selectAsset:self.assetsArray[self.currentIndex]];
        }
    }
    [self reloadData];
}

- (void)doneAction {
    if ([self.delegate respondsToSelector:@selector(browserViewController:didFinishSelectAsset:)]) {
        [self.delegate browserViewController:self didFinishSelectAsset:self.assetsArray[self.currentIndex]];
    }
}

#pragma mark - Control method

- (void)setControlsHidden:(BOOL)hidden animated:(BOOL)animated {
    // Force visible
    if (self.assetsArray == nil || self.assetsArray.count == 0) {
        hidden = NO;
    }
    // Status bar
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        // Hide status bar
        _statusBarShouldBeHidden = hidden;
        [UIView animateWithDuration:0.25 animations:^(void) {
            [self setNeedsStatusBarAppearanceUpdate];
        }];
    }
    [self.navigationController setNavigationBarHidden:hidden animated:animated];
    [self.navigationController setToolbarHidden:hidden animated:animated];
}

- (BOOL)areControlsHidden {
    return (self.navigationController.isToolbarHidden);
}

- (void)hideControls {
    [self setControlsHidden:YES animated:YES];
}

- (void)toggleControls {
    [self setControlsHidden:![self areControlsHidden] animated:YES];
}

#pragma mark - Property method

- (BOOL)prefersStatusBarHidden {
    return _statusBarShouldBeHidden;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return UIStatusBarAnimationFade;
}

- (SYImagePickerSelectButton *)selectButton {
    if (_selectButton == nil) {
        _selectButton = [[SYImagePickerSelectButton alloc] init];
        [_selectButton addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(checkAction)]];
    }
    return _selectButton;
}

- (UIBarButtonItem *)doneButton {
    if (_doneButton == nil) {
        _doneButton = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(doneAction)];
        _doneButton.enabled = NO;
    }
    return _doneButton;
}

@end
