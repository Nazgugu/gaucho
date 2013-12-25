//
//  FavoriteViewController.h
//  REMenuExample
//
//  Created by Liu Zhe on 10/21/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "RootViewController.h"

@interface FavoriteViewController : UIViewController
//@property (readwrite, nonatomic) NSUInteger badge;
@property (weak, nonatomic) IBOutlet UITableView *FavoriteTable;

@end
