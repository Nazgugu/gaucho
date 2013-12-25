//
//  UIScrollView+BluredBackground.h
//  BluredTableView
//
//  Created by Jernej Fijačko on 20. 10. 13.
//  Copyright (c) 2013 Jernej Fijačko. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (BluredBackground)

- (void)setLightBluredBackground:(UIImage *)background;
- (UIImage *)lightBluredBackground;
- (void)setDarkBluredBackground:(UIImage *)background;
- (UIImage *)darkBluredBackground;

@end
