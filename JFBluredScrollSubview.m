//
//  JFBluredScrollSubview.m
//  BluredTableView
//
//  Created by Jernej Fijačko on 20. 10. 13.
//  Copyright (c) 2013 Jernej Fijačko. All rights reserved.
//

#import "JFBluredScrollSubview.h"
#import "UIScrollView+BluredBackground.h"

@implementation JFBluredScrollSubview {
    UIImageView *_backgroundView;
}

@synthesize scrollView = _scrollView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _backgroundView = [[UIImageView alloc] init];
        _backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self addSubview:_backgroundView];
        [self registerObserver];
        self.clipsToBounds = YES;
    }
    return self;
}

- (void)dealloc
{
    [self unregisterObserver];
}

#pragma mark - ScrollView setter

- (void)setScrollView:(UIScrollView *)scrollView
{
    [self unregisterObserver];
    _scrollView = scrollView;
    _backgroundView.image = [_scrollView lightBluredBackground];
    _backgroundView.frame = CGRectMake(0, 0, _scrollView.frame.size.width, _scrollView.frame.size.height);
    [self registerObserver];
}

#pragma mark - Layout

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self repositionBluredBackground];
}

#pragma mark - Key/value observing

- (void)registerObserver
{
    [self.scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)unregisterObserver
{
    [self.scrollView removeObserver:self forKeyPath:@"contentOffset"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (object == self.scrollView && [keyPath isEqualToString:@"contentOffset"]) {
        [self repositionBluredBackground];
    }
}

#pragma mark - Blured background

- (void)repositionBluredBackground
{
    CGRect subFrame = [self.superview convertRect:self.frame toView:_scrollView.superview];
    CGPoint newOrigin = CGPointMake(-subFrame.origin.x,
                                    -subFrame.origin.y);
    _backgroundView.frame = CGRectMake(newOrigin.x, newOrigin.y, CGRectGetWidth(_backgroundView.frame), CGRectGetHeight(_backgroundView.frame));
}

@end
