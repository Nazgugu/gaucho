//
//  UIScrollView+BluredBackground.m
//  BluredTableView
//
//  Created by Jernej Fijačko on 20. 10. 13.
//  Copyright (c) 2013 Jernej Fijačko. All rights reserved.
//

#import "UIScrollView+BluredBackground.h"
#import <objc/runtime.h>

static void const *kLightBackgroundKey = &kLightBackgroundKey;
static void const *kDarkBackgroundKey = &kDarkBackgroundKey;

@implementation UIScrollView (BluredBackground)

- (void)setLightBluredBackground:(UIImage *)background {
    objc_setAssociatedObject(self, kLightBackgroundKey, background, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIImage *)lightBluredBackground {
    return objc_getAssociatedObject(self, kLightBackgroundKey);
}

- (void)setDarkBluredBackground:(UIImage *)background {
    objc_setAssociatedObject(self, kDarkBackgroundKey, background, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIImage *)darkBluredBackground {
    return objc_getAssociatedObject(self, kDarkBackgroundKey);
}

@end
