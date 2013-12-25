//
//  MapViewController.h
//  REMenuExample
//
//  Created by Bernard Yan on 10/17/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import "RootViewController.h"
#import "NAMapView.h"
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "MLPAutoCompleteTextFieldDataSource.h"
#import "MLPAutoCompleteTextFieldDelegate.h"

@class MLPAutoCompleteTextField;
@interface MapViewController : RootViewController <UITextFieldDelegate, MLPAutoCompleteTextFieldDataSource,MLPAutoCompleteTextFieldDelegate>

@property (nonatomic, weak) IBOutlet NAMapView *mapView;
-(IBAction)addPin:(id)sender;
-(IBAction)removePin:(id)sender;
-(IBAction)selectRandom:(id)sender;
@property (weak) IBOutlet MLPAutoCompleteTextField *autocompleteTextField;

//AutoComplete
//Set this to true to prevent auto complete terms from returning instantly.
@property (assign) BOOL simulateLatency;
@property (strong, nonatomic) NSArray *countryObjects;
//Set this to true to return an array of autocomplete objects to the autocomplete textfield instead of strings.
//The objects returned respond to the MLPAutoCompletionObject protocol.
@property (assign) BOOL testWithAutoCompleteObjectsInsteadOfStrings;

@end