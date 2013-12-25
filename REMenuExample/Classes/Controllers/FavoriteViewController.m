//
//  FavoriteViewController.m
//  REMenuExample
//
//  Created by Liu Zhe on 10/21/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import "FavoriteViewController.h"
//#import "DiningViewController.h"
#import "FavoriteList.h"
#import "SWTableViewCell.h"
#import "TPDataModel.h"
#import "SUNSlideSwitchDemoViewController.h"


@interface FavoriteViewController () <UITableViewDataSource, UITableViewDelegate,SWTableViewCellDelegate>
//@property (strong, nonatomic) DiningViewController *Dining;
@property (nonatomic,strong) NSMutableArray *tableData;
//@property (strong, nonatomic) FavoriteList *dishFavoriteList;
@property (strong, nonatomic) SUNSlideSwitchView *switchView;
@end

@implementation FavoriteViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //self.title = @"My Favorites";
    if (!self.tableData)
        self.tableData = [[NSMutableArray alloc]init];
    for (FavoriteList *favoriteDish in [FavoriteList allFavoriteResults])
     {
         TPDataModel *item = [[TPDataModel alloc]init];
         item.title = favoriteDish.DishTitle;
         item.detail = favoriteDish.Description;
         item.dishDate = favoriteDish.dishDate;
         item.isExpand = NO;
         [self.tableData addObject:item];
     }
    //NSLog(@"Hello World");
    self.FavoriteTable.frame = CGRectMake(0, self.switchView.frame.origin.y + self.switchView.frame.size.height, self.FavoriteTable.frame.size.width, self.view.bounds.size.height - self.switchView.frame.size.height);
    self.FavoriteTable.rowHeight = 90;
    self.FavoriteTable.allowsSelection = NO;
    self.FavoriteTable.delegate = self;
    self.FavoriteTable.dataSource = self;
    self.FavoriteTable.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.FavoriteTable.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    //self.FavoriteTable.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.FavoriteTable.separatorColor = [UIColor lightGrayColor];
    self.FavoriteTable.backgroundColor = [UIColor whiteColor/*white*/];
    [self.view addSubview:self.FavoriteTable];
}


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
        NSMutableArray *rightUtilityButtons = [NSMutableArray new];
        [rightUtilityButtons addUtilityButtonWithColor:
         [UIColor colorWithRed:1.0f green:0.231f blue:0.188 alpha:1.0f]
                                                 title:@"Delete"];
        cell = [[SWTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:reuseIdentifier
                                  containingTableView:self.FavoriteTable // Used for row height and selection
                                   leftUtilityButtons:nil/*leftUtilityButtons*/
                                  rightUtilityButtons:rightUtilityButtons];
        cell.delegate = self;
    }
    TPDataModel *item = [[TPDataModel alloc]init];
    item = [self.tableData objectAtIndex:indexPath.row];
    cell.textLabel.text = item.title;
    cell.detailTextLabel.text = item.detail;
    cell.textLabel.textColor = [UIColor blackColor];
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:18];
    cell.detailTextLabel.textColor = [UIColor blackColor];
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

- (void)swippableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
    switch (index) {
        case 0:
        {
            // Delete button was pressed
            NSIndexPath *cellIndexPath = [self.FavoriteTable indexPathForCell:cell];
            [self.tableData removeObjectAtIndex:cellIndexPath.row];
            [FavoriteList removeDishWithTitle:[cell.textLabel.text description]];
            [self.FavoriteTable deleteRowsAtIndexPaths:@[cellIndexPath] withRowAnimation:UITableViewRowAnimationLeft];
            break;
        }
        default:
            break;
    }
}

- (id)init
{
    self = [super init];
    return self;
}

- (void)viewDidUnload {
    [self setFavoriteTable:nil];
    //[self setDayPicker:nil];
    [super viewDidUnload];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
