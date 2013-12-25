//
//  EventsViewController.m
//  REMenuExample
//
//  Created by Liu Zhe on 10/17/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import "EventsViewController.h"

@interface EventsViewController ()

@end

@implementation EventsViewController

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
    // Do any additional setup after loading the view from its nib.
    /*NSMutableAttributedString *eventString = [[NSMutableAttributedString alloc] initWithString:@"Events"];
    [eventString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue-UltraLight" size:15] range:NSRangeFromString(@"Events")];*/
    self.title = @"Events";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
