//
//  GoldViewController.m
//  REMenuExample
//
//  Created by Liu Zhe on 10/17/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import "GoldViewController.h"

@interface GoldViewController ()
//@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation GoldViewController

@synthesize webView;
@synthesize textField;
@synthesize backwardBotton;
@synthesize forwadBotton;
@synthesize activityIndicator;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.webView.scalesPageToFit = YES;
	// Do any additional setup after loading the view, typically from a nib.
    NSString *defaultURL=@"https://my.sa.ucsb.edu/public/curriculum/coursesearch.aspx";
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:defaultURL] ]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)textFieldEndEditing:(id)sender {
    NSString *userString = textField.text;
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:userString] ]];
}
- (IBAction)backWard:(id)sender{
    [webView goBack];
}

- (IBAction)forward:(id)sender {
    [webView goForward];
}
- (void)webViewDidStartLoad:(UIWebView *)webView{
    [activityIndicator startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [activityIndicator stopAnimating];
}

@end
