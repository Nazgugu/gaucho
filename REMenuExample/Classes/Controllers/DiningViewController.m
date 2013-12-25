//
//  DiningViewController.m
//  REMenuExample
//
//  Created by Liu Zhe on 10/17/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import "DiningViewController.h"
#import "TPGestureTableViewCell.h"
#import "TPDataModel.h"
#import "SWTableViewCell.h"
//#import "SIAlertView.h"
#import "UIScrollView+BluredBackground.h"
#import "JFBluredScrollSubview.h"
#import "UIImage+ImageEffects.h"
#import <QuartzCore/QuartzCore.h>
#import "CXAlertView.h"
#import "CSNotificationView.h"
#import "UIColor+RGBA.h"
#import "FavoriteViewController.h"
#import "FavoriteList.h"
#import "NSDate+dateRanges.h"

#import "NSDate+MTDates.h"
//#import "NRSimplePlist.h"
//#import "TabBarViewController.h"
//#import "PXAlertView.h"

#define TEST_UIAPPEARANCE 0
//#define LOGS_ENABLED NO
//#import "DTAlertView.h"
//#import "UIViewController+CWPopup.h"
//#import "PopUpViewController.h"

@interface DiningViewController () <MZDayPickerDelegate, MZDayPickerDataSource, UITableViewDataSource, UITableViewDelegate,TPGestureTableViewCellDelegate, SWTableViewCellDelegate>//, DTAlertViewDelegate>
@property (nonatomic,strong) NSMutableArray *tableData;
@property (nonatomic,strong) NSDateFormatter *dateFormatter;
@property (nonatomic,retain) TPGestureTableViewCell *currentCell;
@property (readwrite,nonatomic) int badgeCount;
@property  (strong, nonatomic)FavoriteViewController *favorite;
@property (strong, nonatomic) FavoriteList *dishFavoriteList;
@property (nonatomic) NSUInteger todayDate;
@property (nonatomic) NSUInteger willDate;
@property (nonatomic) NSUInteger startDate;
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UIImage *darkImage;
@property (strong, nonatomic) UIImage *lightImage;
@property (nonatomic) NSUInteger endOfMonthDate;
//@property (strong, nonatomic) JSAnimatedImagesView *animatedImagesView;
@end

@implementation DiningViewController
//@synthesize tableView, pageScroll;

- (FavoriteList *)dishFavoriteList
{
    if (!_dishFavoriteList)
        _dishFavoriteList = [[FavoriteList alloc] init];
    return _dishFavoriteList;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Dining";
    self.badgeCount = [[[NSUserDefaults standardUserDefaults] objectForKey:@"Score"] intValue];
    self.dayPicker.delegate = self;
    self.dayPicker.dataSource = self;
    self.dayPicker.dayNameLabelFontSize = 12.0f;
    self.dayPicker.dayLabelFontSize = 18.0f;
    
    
    //DayPicker
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateFormat:@"EE"];
        //NSCalendar get monday
    
    NSDate *today = [NSDate mt_startOfToday];
    NSLog(@"today is %@",today);
    NSDate *startWeekDate = [today mt_startOfCurrentWeek];
    //NSLog(@"end of this week is = %@",[today mt_endOfCurrentWeek]);
    //NSLog(@"start of this week is = %@",startWeekDate);
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    gregorian.firstWeekday = 2; // Sunday = 1, Saturday = 7
    NSDate *mondaysDate = nil;
    [gregorian rangeOfUnit:NSWeekCalendarUnit startDate:&mondaysDate interval:NULL forDate:today];
    
    NSLog(@"monday = %@", mondaysDate);
    
    //NSCalendar get sunday
    
    NSDate *sundayDate = [today mt_startOfNextWeek];
    NSString *strr = [sundayDate descriptionWithLocale:[NSLocale currentLocale]];
    NSLog(@"end is %@",strr);
    //
    NSString *str = [today descriptionWithLocale:[NSLocale currentLocale]];
    NSLog(@"System time is %@",str);
    if ([today mt_isWithinSameDay:startWeekDate])
    {
        NSLog(@"yes they are same !");
        sundayDate = startWeekDate;
    }
    NSDateComponents *startComponents = [gregorian components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:mondaysDate];
    NSDateComponents *endComponents = [gregorian components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:sundayDate];
    NSDateComponents *todayComponents = [gregorian components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:today];
    self.startDate = [startComponents day];
    NSUInteger endDayOfTheWeek = [endComponents day];
    NSUInteger ytoday = [todayComponents day];
    NSLog(@"this week start:%d, end %d, today %d", self.startDate, endDayOfTheWeek, ytoday);
    NSDate *endOfMonthDate = [today mt_endOfCurrentMonth];
    NSDateComponents *endMonthComponents =[gregorian components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:endOfMonthDate];
    self.endOfMonthDate = [endMonthComponents day];
    
    
    if (ytoday >= self.startDate)
    {
        
        self.todayDate = ytoday - self.startDate;
    }
    else
    {   endOfMonthDate = [mondaysDate mt_endOfCurrentMonth];
        NSDateComponents *endMonthComponents =[gregorian components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:endOfMonthDate];
        self.endOfMonthDate = [endMonthComponents day];
        NSLog(@"end of month %d",self.endOfMonthDate);
        self.todayDate = self.endOfMonthDate - self.startDate + ytoday;
    }
    self.willDate = self.todayDate;
    NSLog(@"in creation, self.todayDate = %d",self.todayDate);
    [self loadDataOfToday:self.todayDate];
    
    if (endDayOfTheWeek < self.startDate)
    {
        [self.dayPicker setStartDate:[NSDate dateFromDay:[startComponents day] month:[startComponents month] year:[startComponents year]] endDate:[NSDate dateFromDay:[endComponents day] month:[endComponents month] year:[endComponents year]]];
        
        [self.dayPicker setCurrentDate:[NSDate dateFromDay:[todayComponents day] month:[todayComponents month] year:[todayComponents year]] animated:NO];
    }
    else
    {
        [self.dayPicker setStartDate:[today startOfThisMonth] endDate:[today endOfNextMonth]];
        [self.dayPicker setActiveDaysFrom:self.startDate toDay:endDayOfTheWeek];
    }
    [self.dayPicker setCurrentDate:today];
    
    
    
    //Table View
    self.tableView.frame = CGRectMake(0, self.dayPicker.frame.origin.y + self.dayPicker.frame.size.height, self.tableView.frame.size.width, self.view.bounds.size.height-self.dayPicker.frame.size.height);
    //[self setUpTableBackgroundOfToay:today];
    NSString *nameString = [NSString stringWithFormat:@"%d",self.todayDate];
    UIImage *darkImage = [[UIImage imageNamed:nameString] applyDarkEffect];
    UIImage *lightImage = [[UIImage imageNamed:nameString] applyLightEffect];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:darkImage];
    //[self.tableView addSubview:self.animatedImagesView];
    self.tableView.backgroundView = imageView;
    [self.tableView setDarkBluredBackground:darkImage];//backgroundImage
    [self.tableView setLightBluredBackground:lightImage];
    self.tableView.backgroundColor = [UIColor clearColor/*white*/];
    self.tableView.rowHeight = 90;
    self.tableView.allowsSelection = NO;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.tableView.separatorColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    
    //Tab Bar
    
    //AlertView
#if TEST_UIAPPEARANCE
    [[SIAlertView appearance] setMessageFont:[UIFont fontWithName:@"HelveticaNeue-Thin" size:13]];
    [[SIAlertView appearance] setTitleColor:[UIColor greenColor]];
    [[SIAlertView appearance] setMessageColor:[UIColor purpleColor]];
    [[SIAlertView appearance] setCornerRadius:12];
    [[SIAlertView appearance] setShadowRadius:20];
    [[SIAlertView appearance] setViewBackgroundColor:[UIColor colorWithRed:0.891 green:0.936 blue:0.978 alpha:1.000]];
#endif
}


- (void)setUpTableBackgroundOfToay:(NSUInteger)today
{
    CATransition *animation = [CATransition animation];
    [animation setDelegate:self];
    animation.type = kCATransitionFade;
    [animation setDuration:1.0];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    //[self.tableView.backgroundView.layer addAnimation:animation forKey:@"transitionViewAnimation"];
    [self.tableView.layer addAnimation:animation forKey:@"transitionViewAnimation"];
    self.tableView.backgroundView = self.imageView;
    [self.tableView setDarkBluredBackground:self.darkImage];//backgroundImage
    [self.tableView setLightBluredBackground:self.lightImage];
}

- (void)loadDataOfToday:(NSUInteger)today
{
    NSString *fileNameString = [NSString stringWithFormat:@"%d",today];
    //NSLog(@"file name string = %@",fileNameString);
    NSString *path=[[NSBundle mainBundle] pathForResource:fileNameString ofType:@"plist"];
    if (!self.tableData)
        {
        self.tableData = [[NSMutableArray alloc]init];
        NSArray *sourceArray = [[NSArray alloc] initWithContentsOfFile:path];
        //self.favorite.badge = self.badgeCount;
        for(int i=0;i<[sourceArray count];i++){
            NSDictionary *dict = [sourceArray objectAtIndex:i];
            TPDataModel *item = [[TPDataModel alloc]init];
            item.title = [dict objectForKey:@"Title"];
            item.detail = [dict objectForKey:@"Detail"];
            item.dishDate = [dict objectForKey:@"Date"];
            item.isExpand=NO;
            [self.tableData addObject:item];
            }
        }
    else
    {
        [self.tableData removeAllObjects];
        NSArray *sourceArray = [[NSArray alloc] initWithContentsOfFile:path];
        //self.favorite.badge = self.badgeCount;
        for(int i=0;i<[sourceArray count];i++){
            NSDictionary *dict = [sourceArray objectAtIndex:i];
            TPDataModel *item = [[TPDataModel alloc]init];
            item.title = [dict objectForKey:@"Title"];
            item.detail = [dict objectForKey:@"Detail"];
            item.dishDate = [dict objectForKey:@"Date"];
            item.isExpand=NO;
            [self.tableData addObject:item];
        }
    }

}

//Daypicker
- (NSString *)dayPicker:(MZDayPicker *)dayPicker titleForCellDayNameLabelInDay:(MZDay *)day
{
    return [self.dateFormatter stringFromDate:day.date];
}


- (void)dayPicker:(MZDayPicker *)dayPicker didSelectDay:(MZDay *)day
{
    NSLog(@"self.willDayDate = %d",self.willDate);
    NSLog(@"MZDay = %d",[day.day intValue]);
    if (self.todayDate != self.willDate)
    {
        [self setUpTableBackgroundOfToay:self.willDate];
        [self loadDataOfToday:self.willDate];
        [self.tableView reloadData];
    }
    if ([day.day intValue] < self.startDate)
    {
        self.todayDate = self.endOfMonthDate - self.startDate + [day.day intValue];
    }
    else
    {
        self.todayDate = [day.day intValue] - self.startDate;
    }
       //[self.tableData addObject:day];
    //[self.tableView reloadData];
}

- (void)dayPicker:(MZDayPicker *)dayPicker willSelectDay:(MZDay *)day
{
    NSLog(@"//startDate = %d",self.startDate);
    NSLog(@"//MZDay = %d",[day.day intValue]);
    NSLog(@"//end of Month = %d",self.endOfMonthDate);
    if ([day.day intValue] < self.startDate)
    {
        self.willDate = self.endOfMonthDate - self.startDate + [day.day intValue];
    }
    else
    {
        self.willDate = [day.day intValue] - self.startDate;
    }
    NSLog(@"In will select day self.willDate = %d",self.willDate);
    NSString *nameString = [NSString stringWithFormat:@"%d",self.willDate];
    self.darkImage = [[UIImage imageNamed:nameString] applyDarkEffect];
    self.lightImage = [[UIImage imageNamed:nameString] applyLightEffect];
    self.imageView = [[UIImageView alloc] initWithImage:self.darkImage];
    //self.willDate = [day.date mt_weekdayOfWeek] - 1;
    //NSLog(@"will day is %d",[day.date mt_weekdayOfWeek] - 1);
    
}

//Table View
#pragma mark - UITableViewDataSource

/*- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    TPDataModel *item=(TPDataModel*)[self.tableData objectAtIndex:indexPath.row];
    if(item.isExpand==NO){
        return 60;
    }
    return 100;
}*/

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tableData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* reuseIdentifier = @"Cell";
    
    SWTableViewCell *cell = (SWTableViewCell *)[tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    
    if (!cell) {
        /*NSMutableArray *leftUtilityButtons = [NSMutableArray new];
        NSMutableArray *rightUtilityButtons = [NSMutableArray new];
        [rightUtilityButtons addUtilityButtonWithColor: [UIColor clearColor]
         //[UIColor colorWithRed:0.78f green:0.78f blue:0.8f alpha:1.0]
                                                 title:@"More"];
        [rightUtilityButtons addUtilityButtonWithColor: [UIColor clearColor]
         //[UIColor colorWithRed:1.0f green:0.231f blue:0.188 alpha:1.0f]
                                                 title:@"Delete"];*/
        
        cell = [[SWTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:reuseIdentifier
                                  containingTableView:tableView // Used for row height and selection
                                   leftUtilityButtons:nil/*leftUtilityButtons*/
                                  rightUtilityButtons:nil/*rightUtilityButtons*/];
        cell.delegate = self;
    }
    /*TPDataModel *item = (TPDataModel *)[self.tableData objectAtIndex:indexPath.row];
    MZDay *day = self.tableData[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@",day.day];
    cell.detailTextLabel.text = day.name;
    cell.itemData = item;*/
    //NSDate *dateObject = self.tableData[indexPath.row];
    TPDataModel *item = [[TPDataModel alloc]init];
    item = [self.tableData objectAtIndex:indexPath.row];
    cell.textLabel.text = item.title;
    cell.detailTextLabel.text = item.detail;
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:20];
    cell.detailTextLabel.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:17];
    cell.detailTextLabel.textColor = [UIColor whiteColor];
    return cell;
}

//This function is where all the magic happens
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    // Set background color of cell here if you don't want white
    JFBluredScrollSubview *subView = [[JFBluredScrollSubview alloc] initWithFrame:cell.bounds];
    subView.scrollView = self.tableView;
    cell.selectedBackgroundView = subView;
    cell.backgroundColor = [UIColor clearColor];
    //1. Setup the CATransform3D structure
    CATransform3D rotation;
    rotation = CATransform3DMakeRotation( (90.0*M_PI)/180, 0.0, 0.7, 0.4);
    rotation.m34 = 1.0/ -600;
    
    
    //2. Define the initial state (Before the animation)
    cell.layer.shadowColor = [[UIColor blackColor]CGColor];
    cell.layer.shadowOffset = CGSizeMake(10, 10);
    cell.alpha = 0;
    
    cell.layer.transform = rotation;
    cell.layer.anchorPoint = CGPointMake(0, 0.5);
    
    //!!!FIX for issue #1 Cell position wrong------------
    if(cell.layer.position.x != 0){
        cell.layer.position = CGPointMake(0, cell.layer.position.y);
    }
    
    //4. Define the final state (After the animation) and commit the animation
    [UIView beginAnimations:@"rotation" context:NULL];
    [UIView setAnimationDuration:0.40];//animationDuration:0.5
    cell.layer.transform = CATransform3DIdentity;
    cell.alpha = 1;
    cell.layer.shadowOffset = CGSizeMake(0, 0);
    [UIView commitAnimations];
}

#pragma mark - SWTableViewDelegate

- (void)swippableTableViewCell:(SWTableViewCell *)cell didTriggerLeftUtilityButtonWithIndex:(NSInteger)index{
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    /*TPGestureTableViewCell *cell = (TPGestureTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
    if(cell.revealing==YES){
        cell.revealing=NO;
        return;
    }
    TPDataModel *item=(TPDataModel*)[self.tableData objectAtIndex:indexPath.row];
    item.isExpand=!item.isExpand;
    cell.itemData=item;
    [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];*/
    
    //AlertView with count down
    
    /*SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:@"Title1" andMessage:@"Count down"];
    [alertView addButtonWithTitle:@"Button1"
                             type:SIAlertViewButtonTypeDefault
                          handler:^(SIAlertView *alertView) {
                              NSLog(@"Button1 Clicked");
                          }];
    [alertView addButtonWithTitle:@"Button2"
                             type:SIAlertViewButtonTypeDefault
                          handler:^(SIAlertView *alertView) {
                              NSLog(@"Button2 Clicked");
                          }];
    [alertView addButtonWithTitle:@"Button3"
                             type:SIAlertViewButtonTypeDestructive
                          handler:^(SIAlertView *alertView) {
                              NSLog(@"Button3 Clicked");
                          }];
    
    alertView.willShowHandler = ^(SIAlertView *alertView) {
        NSLog(@"%@, willShowHandler", alertView);
    };
    alertView.didShowHandler = ^(SIAlertView *alertView) {
        NSLog(@"%@, didShowHandler", alertView);
    };
    alertView.willDismissHandler = ^(SIAlertView *alertView) {
        NSLog(@"%@, willDismissHandler", alertView);
    };
    alertView.didDismissHandler = ^(SIAlertView *alertView) {
        NSLog(@"%@, didDismissHandler", alertView);
    };
    
    //    alertView.cornerRadius = 4;
    //    alertView.buttonFont = [UIFont boldSystemFontOfSize:12];
    [alertView show];
    
    alertView.title = @"3";
    double delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        alertView.title = @"2";
        alertView.titleColor = [UIColor yellowColor];
        alertView.titleFont = [UIFont boldSystemFontOfSize:30];
    });
    delayInSeconds = 2.0;
    popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        alertView.title = @"1";
        alertView.titleColor = [UIColor greenColor];
        alertView.titleFont = [UIFont boldSystemFontOfSize:40];
    });
    delayInSeconds = 3.0;
    popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        NSLog(@"1=====");
        [alertView dismissAnimated:YES];
        NSLog(@"2=====");
    });
    [(SWTableViewCell*)[tableView cellForRowAtIndexPath:indexPath] hideUtilityButtonsAnimated:YES];*/
    /*[PXAlertView showAlertWithTitle:@"The Matrix"
                            message:@"Pick the Red pill, or the blue pill"
                        cancelTitle:@"Blue"
                         otherTitle:@"Red"
                         completion:^(BOOL cancelled) {
                             if (cancelled) {
                                 NSLog(@"Cancel (Blue) button pressed");
                             } else {
                                 NSLog(@"Other (Red) button pressed");
                             }
                         }];*/
    NSString *alertString = [NSString stringWithFormat:@"Do you want to add %@\nto your favorite dish?",[tableView cellForRowAtIndexPath:indexPath].textLabel.text];
    CXAlertView *alertView = [[CXAlertView alloc] initWithTitle:alertString message:nil cancelButtonTitle:nil];
    [alertView addButtonWithTitle:@"Yes"
                             type:CXAlertViewButtonTypeCustom
                          handler:^(CXAlertView *alertView, CXAlertButtonItem *button) {
                              alertView.showBlurBackground = YES;
                              [alertView dismiss];
                              self.badgeCount = self.badgeCount + 1;
                              [[NSUserDefaults standardUserDefaults] setObject:@(self.badgeCount) forKey:@"Score"];
                              [[NSUserDefaults standardUserDefaults] synchronize];
                              //NSLog(@"added at index %d",self.badgeCount);
                              self.dishFavoriteList.DishTitle = [tableView cellForRowAtIndexPath:indexPath].textLabel.text;
                              self.dishFavoriteList.Description = [tableView cellForRowAtIndexPath:indexPath].detailTextLabel.text;
                              TPDataModel *data = [self.tableData objectAtIndex:indexPath.row];
                              self.dishFavoriteList.dishDate = data.dishDate;                              //NSLog(@"NSNumber is %@",@(self.badgeCount));
                              //NSLog(@"edited number %@",[NRSimplePlist valuePlist:@"badgePlist" withKey:@"badgeNumber"]);
                              //self.favorite.badge = self.badgeCount;
                              //NSLog(@"badge count = %d",self.badgeCount);
                              [CSNotificationView showInViewController:self
                                                                 style:CSNotificationViewStyleSuccess
                                                               message:@"Added Successfully"];
                              //[NRSimplePlist editNumberPlist:@"favoritePlist" withKey:@"badgeNumber" andNumber:@(self.badgeCount)];
                             //NSLog(@"%d",[[NRSimplePlist valuePlist:@"favoritePlist" withKey:@"badgeNumber"] intValue]);
                          }];
    [alertView addButtonWithTitle:@"Cancel"
                             type:CXAlertViewButtonTypeCancel
                          handler:^(CXAlertView *alertView, CXAlertButtonItem *button) {
                              [alertView dismiss];
                              [CSNotificationView showInViewController:self
                                                                 style:CSNotificationViewStyleError
                                                               message:@"Dish not saved."];
                          }];
    [alertView show];
    NSLog(@"cell selected at index path %d", indexPath.row);
//
}

/*- (void)swippableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
    switch (index) {
        case 0:
        {
            NSLog(@"More button was pressed"); //count down button
            DTAlertView *alertTest = [DTAlertView alertViewWithTitle:@"Demo" message:@"This is normal alert view." delegate:self cancelButtonTitle:@"Cancel" positiveButtonTitle:@"OK"];*/
            //[alertTest show];
            /*PopUpViewController *samplePopUpViewController = [[PopUpViewController alloc] initWithNibName:@"PopUpViewController" bundle:nil];
            [self presentPopupViewController:samplePopUpViewController animated:YES completion:^(void) {
                NSLog(@"popup view presented");
            }];
            SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:@"Title1" andMessage:@"Count down"];
            [alertView addButtonWithTitle:@"Button1"
                                     type:SIAlertViewButtonTypeDefault
                                  handler:^(SIAlertView *alertView) {
                                      NSLog(@"Button1 Clicked");
                                  }];
            [alertView addButtonWithTitle:@"Button2"
                                     type:SIAlertViewButtonTypeDefault
                                  handler:^(SIAlertView *alertView) {
                                      NSLog(@"Button2 Clicked");
                                  }];
            [alertView addButtonWithTitle:@"Button3"
                                     type:SIAlertViewButtonTypeDestructive
                                  handler:^(SIAlertView *alertView) {
                                      NSLog(@"Button3 Clicked");
                                  }];
            
            alertView.willShowHandler = ^(SIAlertView *alertView) {
                NSLog(@"%@, willShowHandler", alertView);
            };
            alertView.didShowHandler = ^(SIAlertView *alertView) {
                NSLog(@"%@, didShowHandler", alertView);
            };
            alertView.willDismissHandler = ^(SIAlertView *alertView) {
                NSLog(@"%@, willDismissHandler", alertView);
            };
            alertView.didDismissHandler = ^(SIAlertView *alertView) {
                NSLog(@"%@, didDismissHandler", alertView);
            };
            
            //    alertView.cornerRadius = 4;
            //    alertView.buttonFont = [UIFont boldSystemFontOfSize:12];
            [alertView show];
            
            alertView.title = @"3";
            double delayInSeconds = 1.0;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                alertView.title = @"2";
                alertView.titleColor = [UIColor yellowColor];
                alertView.titleFont = [UIFont boldSystemFontOfSize:30];
            });
            delayInSeconds = 2.0;
            popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                alertView.title = @"1";
                alertView.titleColor = [UIColor greenColor];
                alertView.titleFont = [UIFont boldSystemFontOfSize:40];
            });
            delayInSeconds = 3.0;
            popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                NSLog(@"1=====");
                [alertView dismissAnimated:YES];
                NSLog(@"2=====");
            });
            [cell hideUtilityButtonsAnimated:YES];
            break;
        }
        case 1:
        {
            // Delete button was pressed
            NSIndexPath *cellIndexPath = [self.tableView indexPathForCell:cell];
            
            [self.tableData removeObjectAtIndex:cellIndexPath.row];
            [self.tableView deleteRowsAtIndexPaths:@[cellIndexPath] withRowAnimation:UITableViewRowAnimationLeft];
            break;
        }
        default:
            break;
    }
}*/

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}


- (void)cellDidBeginPan:(TPGestureTableViewCell *)cell{
    
}

- (void)cellDidReveal:(TPGestureTableViewCell *)cell{
    if(self.currentCell!=cell){
        self.currentCell.revealing=NO;
        self.currentCell=cell;
    }
    
}

#pragma mark - Popup Functions

/*- (void)dismissPopup {
    if (self.popupViewController != nil) {
        [self dismissPopupViewControllerAnimated:YES completion:^{
            NSLog(@"popup view dismissed");
        }];
    }
}*/

#pragma mark - DTAlertView Delegate Methods

/*- (void)alertView:(DTAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"You click button title : %@", alertView.clickedButtonTitle);
    
    if (alertView.textField != nil) {
        NSLog(@"Inputed Text : %@", alertView.textField.text);
    }
}*/


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    return touch.view == self.view;
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setTableView:nil];
    [self setDayPicker:nil];
    [super viewDidUnload];

}




@end
