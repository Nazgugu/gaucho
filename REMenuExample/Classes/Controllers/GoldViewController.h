//
//  GoldViewController.h
//  REMenuExample
//
//  Created by Liu Zhe on 10/17/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import "RootViewController.h"

@interface GoldViewController : RootViewController<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@property (weak, nonatomic) IBOutlet UIButton *backwardBotton;

@property (weak, nonatomic) IBOutlet UIButton *forwadBotton;


@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

- (IBAction)textFieldEndEditing:(id)sender;
- (IBAction)backWard:(id)sender;
- (IBAction)forward:(id)sender;

@end
