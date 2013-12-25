//
//  DiningViewController.h
//  REMenuExample
//
//  Created by Liu Zhe on 10/17/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import "RootViewController.h"
#import "MZDayPicker.h"
#import "TPGestureTableViewCell.h"
//#import "JSAnimatedImagesView.h"

//#import "DRDynamicSlideShow.h"

@interface DiningViewController : RootViewController <UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet MZDayPicker *dayPicker;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
//@property (readonly,nonatomic) NSUInteger badgeCount;

//-(NSUInteger)getBadge;
//@property (strong, nonatomic) DRDynamicSlideShow * slideShow;

//@property (strong, nonatomic) NSArray * viewsForPages;

@end
