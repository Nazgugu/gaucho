//
//  SUNSlideSwitchDemoViewController.h
//  SUNCommonComponent
//
//  Created by 麦志泉 on 13-9-4.
//  Copyright (c) 2013年 中山市新联医疗科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SUNSlideSwitchView.h"
#import "FavoriteViewController.h"
#import "SUNViewController.h"
#import "RootViewController.h"
#import "FavoriteCourseViewController.h"
#import "FavoriteEventsViewController.h"

@interface SUNSlideSwitchDemoViewController : RootViewController<SUNSlideSwitchViewDelegate>
{
    SUNSlideSwitchView *_slideSwitchView;
    FavoriteViewController *_dish;
    FavoriteCourseViewController *_course;
    FavoriteEventsViewController *_events;
}

@property (nonatomic, strong) IBOutlet SUNSlideSwitchView *slideSwitchView;

@property (nonatomic, strong) FavoriteViewController *dish;
@property (nonatomic, strong) FavoriteCourseViewController *course;
@property (nonatomic, strong) FavoriteEventsViewController *events;

@end
