//
//  FavoriteCourseViewController.m
//  GauchoLife
//
//  Created by Liu Zhe on 10/23/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import "FavoriteCourseViewController.h"
#import "FavoriteList.h"
#import "SWTableViewCell.h"
#import "TPDataModel.h"

@interface FavoriteCourseViewController ()<UITableViewDataSource, UITableViewDelegate,SWTableViewCellDelegate>
@property (nonatomic,strong) NSMutableArray *tableData;
@property (strong, nonatomic) FavoriteList *dishFavoriteList;

@end

@implementation FavoriteCourseViewController

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
    [super viewDidLoad];
    //self.title = @"My Favorites";
    self.tableData = [[NSMutableArray alloc]init];
    for (FavoriteList *favoriteDish in [FavoriteList allFavoriteClassResults])
    {
        TPDataModel *item = [[TPDataModel alloc]init];
        item.title = favoriteDish.DishTitle;
        item.detail = favoriteDish.Description;
        item.isExpand = NO;
        [self.tableData addObject:item];
    }
    //NSLog(@"Hello World");
    //self.CouseTable.frame = self.view.frame;
    self.CouseTable.rowHeight = 90;
    self.CouseTable.allowsSelection = NO;
    self.CouseTable.delegate = self;
    self.CouseTable.dataSource = self;
    self.CouseTable.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.CouseTable.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    //self.FavoriteTable.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.CouseTable.separatorColor = [UIColor lightGrayColor];
    self.CouseTable.backgroundColor = [UIColor whiteColor/*white*/];
    [self.view addSubview:self.CouseTable];
    // Do any additional setup after loading the view from its nib.
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
                                  containingTableView:self.CouseTable // Used for row height and selection
                                   leftUtilityButtons:nil/*leftUtilityButtons*/
                                  rightUtilityButtons:rightUtilityButtons];
        cell.delegate = self;
    }
    TPDataModel *item = [[TPDataModel alloc]init];
    item = [self.tableData objectAtIndex:indexPath.row];
    cell.textLabel.text = item.title;
    cell.detailTextLabel.text = item.detail;
    cell.textLabel.textColor = [UIColor blackColor];
    cell.textLabel.font =[UIFont fontWithName:@"HelveticaNeue-Thin" size:18];
    cell.detailTextLabel.textColor = [UIColor blackColor];
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

- (void)swippableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
    switch (index) {
        case 0:
        {
            // Delete button was pressed
            NSIndexPath *cellIndexPath = [self.CouseTable indexPathForCell:cell];
            [self.tableData removeObjectAtIndex:cellIndexPath.row];
            [FavoriteList removeDishWithTitle:[cell.textLabel.text description]];
            [self.CouseTable deleteRowsAtIndexPaths:@[cellIndexPath] withRowAnimation:UITableViewRowAnimationLeft];
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
    [self setCouseTable:nil];
    //[self setDayPicker:nil];
    [super viewDidUnload];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
