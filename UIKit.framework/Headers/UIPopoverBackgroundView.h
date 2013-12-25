//
//  UIPopoverBackgroundView.h
//  UIKit
//
//  Copyright (c) 2011-2013, Apple Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIView.h>
#import <UIKit/UIGeometry.h>
#import <UIKit/UIPopoverController.h>

/* The methods defined below are all to be treated as abstract; in order to subclass `UIPopoverBackgroundView`, you must supply implementations of each of the methods below. For `readwrite` properties, you must supply implementations of both of the accessors.
 */

NS_CLASS_AVAILABLE_IOS(5_0)
@interface UIPopoverBackgroundView : UIView {}

/* The arrow offset represents how far from the center of the view the center of the arrow should appear. For `UIPopoverArrowDirectionUp` and `UIPopoverArrowDirectionDown`, this is a left-to-right offset; negative is to the left. For `UIPopoverArrowDirectionLeft` and `UIPopoverArrowDirectionRight`, this is a top-to-bottom offset; negative to toward the top.
 
 This method is called inside an animation block managed by the `UIPopoverController`.
 */
@property (nonatomic, readwrite) CGFloat arrowOffset;

/* `arrowDirection` manages which direction the popover arrow is pointing. You may be required to change the direction of the arrow while the popover is still visible on-screen.
 */
@property (nonatomic, readwrite) UIPopoverArrowDirection arrowDirection;

/* These methods must be overridden and the values they return may not be changed during use of the `UIPopoverBackgroundView`. `arrowHeight` represents the height of the arrow in points from its base to its tip. `arrowBase` represents the the length of the base of the arrow's triangle in points. `contentViewInset` describes the distance between each edge of the background view and the corresponding edge of its content view (i.e. if it were strictly a rectangle). `arrowHeight` and `arrowBase` are also used for the drawing of the standard popover shadow.
 */
+ (CGFloat)arrowHeight;
+ (CGFloat)arrowBase;
+ (UIEdgeInsets)contentViewInsets;        

/* This method may be overridden to prevent the drawing of the content inset and drop shadow inside the popover. The default implementation of this method returns YES.
 */
+ (BOOL)wantsDefaultContentAppearance NS_AVAILABLE_IOS(6_0);

@end