//
//  SYImagePickerBrowserCell.m
//  ShareJobStudent
//
//  Created by Sunnyyoung on 15/11/5.
//  Copyright © 2015年 GeekBean Technology Co., Ltd. All rights reserved.
//

#import "SYImagePickerBrowserCell.h"
#import "SYImagePickerDetectingImageView.h"
#import "SYImagePickerBrowserViewController.h"

@interface SYImagePickerBrowserCell () <UIScrollViewDelegate, SYImagePickerDetectingImageViewDelegate>

@property (nonatomic, strong) UIScrollView *zoomingScrollView;
@property (nonatomic, strong) SYImagePickerDetectingImageView *detectingImageView;

@end

@implementation SYImagePickerBrowserCell

#pragma mark - LifeCycle

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self zoomingScrollView];
        [self detectingImageView];
    }
    return self;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.detectingImageView.image = nil;
    [self.detectingImageView removeFromSuperview];
    [self.zoomingScrollView removeFromSuperview];
    self.zoomingScrollView = nil;
    self.detectingImageView = nil;
    self.browserViewController = nil;
    self.asset = nil;
}

#pragma mark - Layout

- (void)layoutSubviews {
    // Super
    [super layoutSubviews];

    // Center the image as it becomes smaller than the size of the screen
    CGSize boundsSize = self.zoomingScrollView.bounds.size;
    CGRect frameToCenter = self.detectingImageView.frame;

    // Horizontally
    if (frameToCenter.size.width < boundsSize.width) {
        frameToCenter.origin.x = floorf((boundsSize.width - frameToCenter.size.width) / 2.0);
    } else {
        frameToCenter.origin.x = 0;
    }

    // Vertically
    if (frameToCenter.size.height < boundsSize.height) {
        frameToCenter.origin.y = floorf((boundsSize.height - frameToCenter.size.height) / 2.0);
    } else {
        frameToCenter.origin.y = 0;
    }

    // Center
    if (!CGRectEqualToRect(self.detectingImageView.frame, frameToCenter))
        self.detectingImageView.frame = frameToCenter;
}

- (CGFloat)initialZoomScaleWithMinScale {
    CGFloat zoomScale = self.zoomingScrollView.minimumZoomScale;
    // Zoom image to fill if the aspect ratios are fairly similar
    CGSize boundsSize = self.zoomingScrollView.bounds.size;
    CGSize imageSize = self.detectingImageView.image.size;
    CGFloat boundsAR = boundsSize.width / boundsSize.height;
    CGFloat imageAR = imageSize.width / imageSize.height;
    CGFloat xScale = boundsSize.width / imageSize.width;    // the scale needed to perfectly fit the image width-wise
    CGFloat yScale = boundsSize.height / imageSize.height;  // the scale needed to perfectly fit the image height-wise
    // Zooms standard portrait images on a 3.5in screen but not on a 4in screen.
    if (ABS(boundsAR - imageAR) < 0.17) {
        zoomScale = MAX(xScale, yScale);
        // Ensure we don't zoom in or out too far, just in case
        zoomScale = MIN(MAX(self.zoomingScrollView.minimumZoomScale, zoomScale), self.zoomingScrollView.maximumZoomScale);
    }
    return zoomScale;
}

- (void)setMaxMinZoomScalesForCurrentBounds {
    // Reset
    self.zoomingScrollView.maximumZoomScale = 1;
    self.zoomingScrollView.minimumZoomScale = 1;
    self.zoomingScrollView.zoomScale = 1;

    // Bail if no image
    if (self.detectingImageView.image == nil) return;

    // Reset position
    self.detectingImageView.frame = CGRectMake(0, 0, self.detectingImageView.frame.size.width, self.detectingImageView.frame.size.height);

    // Sizes
    CGSize boundsSize = self.zoomingScrollView.bounds.size;
    CGSize imageSize = self.detectingImageView.image.size;

    // Calculate Min
    CGFloat xScale = boundsSize.width / imageSize.width;    // the scale needed to perfectly fit the image width-wise
    CGFloat yScale = boundsSize.height / imageSize.height;  // the scale needed to perfectly fit the image height-wise
    CGFloat minScale = MIN(xScale, yScale);                 // use minimum of these to allow the image to become fully visible

    // Calculate Max
    CGFloat maxScale = 1.5;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        // Let them go a bit bigger on a bigger screen!
        maxScale = 4;
    }

    // Image is smaller than screen so no zooming!
    if (xScale >= 1 && yScale >= 1) {
        minScale = 1.0;
    }

    // Set min/max zoom
    self.zoomingScrollView.maximumZoomScale = maxScale;
    self.zoomingScrollView.minimumZoomScale = minScale;

    // Initial zoom
    self.zoomingScrollView.zoomScale = [self initialZoomScaleWithMinScale];

    // If we're zooming to fill then centralise
    if (self.zoomingScrollView.zoomScale != minScale) {
        // Centralise
        self.zoomingScrollView.contentOffset = CGPointMake((imageSize.width * self.zoomingScrollView.zoomScale - boundsSize.width) / 2.0,
                                                           (imageSize.height * self.zoomingScrollView.zoomScale - boundsSize.height) / 2.0);
        // Disable scrolling initially until the first pinch to fix issues with swiping on an initally zoomed in photo
        self.zoomingScrollView.scrollEnabled = NO;
    }

    // Layout
    [self setNeedsLayout];
}

- (void)displayImage {
    self.zoomingScrollView.maximumZoomScale = 1;
    self.zoomingScrollView.minimumZoomScale = 1;
    self.zoomingScrollView.zoomScale = 1;
    self.zoomingScrollView.contentSize = CGSizeMake(0, 0);

    UIImage *img = [UIImage imageWithCGImage:[[self.asset defaultRepresentation] fullScreenImage]];
    self.detectingImageView.image = img;
    self.detectingImageView.hidden = NO;
    CGRect detectingImageViewFrame;
    detectingImageViewFrame.origin = CGPointZero;
    detectingImageViewFrame.size = img.size;
    self.detectingImageView.frame = detectingImageViewFrame;
    self.zoomingScrollView.contentSize = detectingImageViewFrame.size;

    // Set zoom to minimum zoom
    [self setMaxMinZoomScalesForCurrentBounds];
    [self setNeedsLayout];
}

#pragma mark - ScrollView Delegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.detectingImageView;
}

- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view {
    self.zoomingScrollView.scrollEnabled = YES; // reset
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

#pragma mark - DetectingImageView Delegate

- (void)imageView:(UIImageView *)imageView singleTapDetected:(UITouch *)touch {
    [self.browserViewController performSelector:@selector(toggleControls) withObject:nil afterDelay:0.2];
}

- (void)imageView:(UIImageView *)imageView doubleTapDetected:(UITouch *)touch {
    CGPoint touchPoint = [touch locationInView:imageView];
    // Cancel any single tap handling
    [NSObject cancelPreviousPerformRequestsWithTarget:self.browserViewController];
    // Zoom
    if (self.zoomingScrollView.zoomScale != self.zoomingScrollView.minimumZoomScale && self.zoomingScrollView.zoomScale != [self initialZoomScaleWithMinScale]) {

        // Zoom out
        [self.zoomingScrollView setZoomScale:self.zoomingScrollView.minimumZoomScale animated:YES];

    } else {

        // Zoom in to twice the size
        CGFloat newZoomScale = ((self.zoomingScrollView.maximumZoomScale + self.zoomingScrollView.minimumZoomScale) / 2);
        CGFloat xsize = self.zoomingScrollView.bounds.size.width / newZoomScale;
        CGFloat ysize = self.zoomingScrollView.bounds.size.height / newZoomScale;
        [self.zoomingScrollView zoomToRect:CGRectMake(touchPoint.x - xsize / 2, touchPoint.y - ysize / 2, xsize, ysize) animated:YES];

    }
}

#pragma mark - Property method

- (UIScrollView *)zoomingScrollView {
    if (nil == _zoomingScrollView) {
        _zoomingScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(10, 0, self.frame.size.width - 20, self.frame.size.height)];
        _zoomingScrollView.delegate = self;
        _zoomingScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleWidth;
        _zoomingScrollView.showsHorizontalScrollIndicator = NO;
        _zoomingScrollView.showsVerticalScrollIndicator = NO;
        _zoomingScrollView.decelerationRate = UIScrollViewDecelerationRateFast;
        [self addSubview:_zoomingScrollView];
    }
    return _zoomingScrollView;
}

- (SYImagePickerDetectingImageView *)detectingImageView {
    if (nil == _detectingImageView) {
        _detectingImageView = [[SYImagePickerDetectingImageView alloc] initWithFrame:CGRectZero];
        _detectingImageView.tapDelegate = self;
        _detectingImageView.contentMode = UIViewContentModeCenter;
        _detectingImageView.backgroundColor = [UIColor blackColor];
        [self.zoomingScrollView addSubview:_detectingImageView];
    }
    return _detectingImageView;
}

- (void)setAsset:(ALAsset *)asset {
    if (_asset != asset) {
        _asset = asset;
        [self displayImage];
    }
}

@end
