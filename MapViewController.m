//
//  MapViewController.m
//  REMenuExample
//
//  Created by Bernard Yan on 10/17/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//



#import "MapViewController.h"
#import "MLPAutoCompleteTextField.h"
#import "DEMOCustomAutoCompleteCell.h"
#import "DEMOCustomAutoCompleteObject.h"
#import <QuartzCore/QuartzCore.h>
#import <CoreLocation/CoreLocation.h>

@interface MapViewController ()<UIScrollViewDelegate, CLLocationManagerDelegate> {
    int _count;
    NAAnnotation *_lastFocused;
    NAAnnotation *_locNowFocused;
    NAAnnotation *_locLastFocused;
}
@property (nonatomic, strong) NSMutableArray *annotations;
@property (nonatomic, assign) CGSize size;
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UIImageView *pointView;
@property (strong, nonatomic) CLLocationManager *locationManager;
//@property (strong, nonatomic) NSNumber* firstNumber;
//@property (strong, nonatomic) NSNumber* secondNumber;
//@property (nonatomic) double firN;
//@property (nonatomic) double secN;


@end

@implementation MapViewController

@synthesize mapView     = _mapView;
@synthesize annotations = _annotations;
@synthesize size        = _size;

/*- (UIImageView *) pointView{
    
    if (!_pointView) {
        _pointView = [[UIImageView alloc]init];
        
        NSString *thePath = [[NSBundle mainBundle] pathForResource:@"location" ofType:@"png"];
        UIImage *image = [[UIImage alloc]initWithContentsOfFile:thePath];
        
        
        self.pointView.image = image;
        self.pointView.alpha = 0.7;
        self.pointView.frame = CGRectMake(1210, 1632, 50, 50);
        NSLog(@"image width:%f height:%f", image.size.width, image.size.height);
        //self.pointView.alpha = 0.5;
        
        
    }
    
    return _pointView;
}*/

-(void)scrollViewDidZoom:(UIScrollView *)scrollView{
    NSLog(@"it zooooms");
    CGRect oldFrame = self.pointView.frame;
    // 0.5 means the anchor is centered on the x axis. 1 means the anchor is at the bottom of the view. If you comment out this line, the pin's center will stay where it is regardless of how much you zoom. I have it so that the bottom of the pin stays fixed. This should help user RomeoF.
    //[self.pointView.layer setAnchorPoint:CGPointMake(0.5, 1)];
    //self.pointView.frame = oldFrame;
    // When you zoom in on scrollView, it gets a larger zoom scale value.
    // You transform the pin by scaling it by the inverse of this value.
    //self.pointView.transform = CGAffineTransformMakeScale(1.0/self.mapScrollView.zoomScale, 1.0/self.mapScrollView.zoomScale);
    float zoomScale = self.mapView.zoomScale;
    NSLog(@"%f", zoomScale);
    //self.pointView.frame = CGRectMake(self.firN* zoomScale, self.secN *zoomScale, 50 *zoomScale, 50*zoomScale);
    
}

/*- (void)locationManager:manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
    
    double first, second, firstDelta, secondDelta;
    NSString *locationDescription, *firstString, *secondString;
    firstString = [[NSString alloc]init];
    secondString = [[NSString alloc]init];
    locationDescription = [[NSString alloc]initWithString:[newLocation description]];
    //self.locationLabel.text = locationDescription;
    firstString = [locationDescription substringWithRange:NSMakeRange(2, 11)];
    secondString = [locationDescription substringWithRange:NSMakeRange(14, 13)];
    first = [firstString doubleValue];
    second = [secondString doubleValue];
    NSLog(@"first = %lf, second = %lf", first, second);
    firstDelta = (-(-119.839366 - second) * 144435.239)  + 2430;
    secondDelta = ((34.414933 - first) * 144435.239)+ 1600;
    NSLog(@"%lf    %lf", firstDelta, secondDelta);
    //self.pointView.frame = CGRectMake(firstDelta, secondDelta, 50, 50);
    [self AddLocPinAtindex:firstDelta withYcoordinate:secondDelta andBuildingTitle:@"Current Location"];
    [self removeLocPin];
    self.firN = firstDelta;
    self.secN = secondDelta;
    //34.413176,-119.847171 equifax 18005256285 www.equifax.com 8003473085
    //34.414933,-119.839366
}*/



-(IBAction)addPin:(id)sender{
    
    int x = (arc4random() % (int)self.size.width);
    int y = (arc4random() % (int)self.size.width);
    NSLog(@"width = %f, height = %f",self.size.width,self.size.height);
    NSLog(@"x = %d, y = %d",x,y);
    
    CGPoint point = CGPointMake(x, y);
    
    [self.mapView centreOnPoint:point animated:YES];
    
    NAAnnotation *annotation = [NAAnnotation annotationWithPoint:point];
    
    annotation.title = [NSString stringWithFormat:@"Pin %d", ++_count];
    
    annotation.color = arc4random() % 3;
    
    [self.mapView addAnnotation:annotation animated:YES];
    
    [self.annotations addObject:annotation];
    
    _lastFocused = annotation;
    
}

-(void)AddLocPinAtindex:(int)xCoordinate
     withYcoordinate:(int)yCoordinate
    andBuildingTitle:(NSString *)nameString

{
    CGPoint point = CGPointMake(xCoordinate, yCoordinate);
    //[self.mapView centreOnPoint:point animated:NO];
    NAAnnotation *annotation = [NAAnnotation annotationWithPoint:point];
    annotation.title = nameString;
    annotation.color = NAPinColorRed;
    annotation.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeContactAdd];
    [self.mapView addAnnotation:annotation animated:NO];
    [self.annotations addObject:annotation];
    
    _locLastFocused = _locNowFocused;
    _locNowFocused = annotation;
    
    NSLog(@"added");
}

-(void)removeLocPin{
    
    if([self.annotations count] <= 0 || _locLastFocused == nil) return;
    
    //[self.mapView centreOnPoint:_lastFocused.point animated:YES];
    
    [self.mapView removeAnnotation:_locLastFocused];
    
    [self.annotations removeObject:_locLastFocused];
    
    _locLastFocused = ([self.annotations count] > 0) ? [self.annotations objectAtIndex:[self.annotations count]-1] : nil;
    
    NSLog(@"removed");
}

-(void)AddPinAtindex:(int)xCoordinate
     withYcoordinate:(int)yCoordinate
    andBuildingTitle:(NSString *)nameString
{
    CGPoint point = CGPointMake(xCoordinate, yCoordinate);
    [self.mapView centreOnPoint:point animated:YES];
    NAAnnotation *annotation = [NAAnnotation annotationWithPoint:point];
    annotation.title = nameString;
    annotation.color = 0;
    annotation.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeContactAdd];
    [self.mapView addAnnotation:annotation animated:YES];
    [self.annotations addObject:annotation];
    _lastFocused = annotation;
}

-(IBAction)removePin:(id)sender{
    
    if([self.annotations count] <= 0 || _lastFocused == nil) return;
    
    [self.mapView centreOnPoint:_lastFocused.point animated:YES];
    
    [self.mapView removeAnnotation:_lastFocused];
    
    [self.annotations removeObject:_lastFocused];
    
    _lastFocused = ([self.annotations count] > 0) ? [self.annotations objectAtIndex:[self.annotations count]-1] : nil;
}

-(IBAction)selectRandom:(id)sender{
    if([self.annotations count] <= 0) return;
    
    int rand = (arc4random() % (int)[self.annotations count]);
    NAAnnotation *annotation = [self.annotations objectAtIndex:rand];
    
    [self.mapView selectAnnotation:annotation animated:YES];
    
    _lastFocused = annotation;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    _locLastFocused = nil;
    self.title = @"Map";
    // Do any additional setup after loading the view.
    self.annotations = [[NSMutableArray alloc] init];
    UIImage *image = [UIImage imageNamed:@"UCSBMAP"];
    
    self.mapView.backgroundColor = [UIColor colorWithRed:0.000f green:0.475f blue:0.761f alpha:1.000f];
    
    [self.mapView displayMap:image];
    self.mapView.minimumZoomScale = 0.15f;
    self.mapView.maximumZoomScale = 2.0f;
    
    //self.mapView.delegate = self;
    self.size = image.size;
    
    _count = 0;
    _lastFocused = nil;
    [self.mapView addSubview:self.pointView];
    //self.locationManager = [[CLLocationManager alloc]init];
    //[self.locationManager startUpdatingLocation];
    //self.locationManager.delegate = self;
    //self.firstNumber = [[NSNumber alloc]init];
    //self.secondNumber = [[NSNumber alloc]init];
    //Search Field
    //[self.autocompleteTextField setRightViewMode:UITextFieldViewModeUnlessEditing];
    //self.autocompleteTextField.rightView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"search"]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShowWithNotification:) name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHideWithNotification:) name:UIKeyboardDidHideNotification object:nil];
   
    if ([[[UIDevice currentDevice] systemVersion] compare:@"6.0" options:NSNumericSearch] != NSOrderedAscending) {
        [self.autocompleteTextField registerAutoCompleteCellClass:[DEMOCustomAutoCompleteCell class]
                                           forCellReuseIdentifier:@"CustomCellId"];
    }
    else{
        //Turn off bold effects on iOS 5.0 as they are not supported and will result in an exception
        self.autocompleteTextField.applyBoldEffectToAutoCompleteSuggestions = NO;
    }
    [self.autocompleteTextField setAutoCompleteTableAppearsAsKeyboardAccessory:NO];
}




//Search Field
- (void)keyboardDidShowWithNotification:(NSNotification *)aNotification
{
    [UIView animateWithDuration:0.15
                          delay:0
                        options:UIViewAnimationCurveEaseOut|UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         CGPoint adjust;
                         switch (self.interfaceOrientation) {
                             case UIInterfaceOrientationLandscapeLeft:
                                 adjust = CGPointMake(-110, 0);
                                 break;
                             case UIInterfaceOrientationLandscapeRight:
                                 adjust = CGPointMake(110, 0);
                                 break;
                             default:
                                 adjust = CGPointMake(0, -60);
                                 break;
                         }
                         //CGPoint newCenter = CGPointMake(self.view.center.x+adjust.x, self.view.center.y+adjust.y);
                         //[self.view setCenter:newCenter];
                     }
                     completion:nil];
}

- (void)keyboardDidHideWithNotification:(NSNotification *)aNotification
{
    [UIView animateWithDuration:0.15
                          delay:0
                        options:UIViewAnimationCurveEaseOut|UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         CGPoint adjust;
                         switch (self.interfaceOrientation) {
                             case UIInterfaceOrientationLandscapeLeft:
                                 adjust = CGPointMake(110, 0);
                                 break;
                             case UIInterfaceOrientationLandscapeRight:
                                 adjust = CGPointMake(-110, 0);
                                 break;
                             default:
                                 adjust = CGPointMake(0, 60);
                                 break;
                         }
                         //CGPoint newCenter = CGPointMake(self.view.center.x+adjust.x, self.view.center.y+adjust.y);
                         //[self.view setCenter:newCenter];
                     }
                     completion:nil];
    
    
    [self.autocompleteTextField setAutoCompleteTableViewHidden:NO];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - MLPAutoCompleteTextField DataSource


//example of asynchronous fetch:
- (void)autoCompleteTextField:(MLPAutoCompleteTextField *)textField
 possibleCompletionsForString:(NSString *)string
            completionHandler:(void (^)(NSArray *))handler
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
    dispatch_async(queue, ^{
        if(self.simulateLatency){
            CGFloat seconds = arc4random_uniform(4)+arc4random_uniform(4); //normal distribution
            NSLog(@"sleeping fetch of completions for %f", seconds);
            sleep(seconds);
        }
        
        NSArray *completions;
        if(self.testWithAutoCompleteObjectsInsteadOfStrings){
            completions = [self allCountryObjects];
        } else {
            completions = [self allCountries];
        }
        
        handler(completions);
    });
}

/*
 - (NSArray *)autoCompleteTextField:(MLPAutoCompleteTextField *)textField
 possibleCompletionsForString:(NSString *)string
 {
 
 if(self.simulateLatency){
 CGFloat seconds = arc4random_uniform(4)+arc4random_uniform(4); //normal distribution
 NSLog(@"sleeping fetch of completions for %f", seconds);
 sleep(seconds);
 }
 
 NSArray *completions;
 if(self.testWithAutoCompleteObjectsInsteadOfStrings){
 completions = [self allCountryObjects];
 } else {
 completions = [self allCountries];
 }
 
 return completions;
 }
 */

- (NSArray *)allCountryObjects
{
    if(!self.countryObjects){
        NSArray *countryNames = [self allCountries];
        NSMutableArray *mutableCountries = [NSMutableArray new];
        for(NSString *countryName in countryNames){
            DEMOCustomAutoCompleteObject *country = [[DEMOCustomAutoCompleteObject alloc] initWithCountry:countryName];
            [mutableCountries addObject:country];
        }
        
        [self setCountryObjects:[NSArray arrayWithArray:mutableCountries]];
    }
    
    return self.countryObjects;
}


- (NSArray *)allCountries
{
    NSArray *countries =
    @[
      @"300| Room 300",
      @"346| Room 346",
      @"387| Modular Classrooms",
      @"408| Room 408",
      @"434| Former Women's Center",
      @"479| Old Gym",
      @"429| Room 429",
      @"411| Room 411",
      @"477| Room 477",
      @"599| Room 599",
      @"615-MRL| Material Research Laboratory",
      @"937| Physics Trailer 2",
      @"ANCAP HALL| Anacapa Residence Hall",
      @"ARTS| Arts Building",
      @"AS| Asscociated Students",
      @"AS BIKE| Asscociated Students Bike Shop",
      @"ARBOR| Arbor",
      @"AAS| Audit & Advisory Service",
      @"BIOL2| Biological Science II",
      @"BRDA| Broida Hall",
      @"BREN| Bren Hall",
      @"BSIF| Biological Sciences Instructional Facility",
      @"BUCHN| Buchanan Hall",
      @"CAMPB HALL| Campbell Hall",
      @"CHEM| Chemistry Building",
      @"CUS| Caesar Uyesaka Stadium",
      @"CHEADLE| Cheadle Hall",
      @"CCS| College of Creative Studies",
      @"CS| Counseling&Career Service",
      @"CTC| Coral Tree Cafe",
      @"ELLSN| Ellison Hall",
      @"EMBAR HALL| Embarcadero Hall",
      @"ENGR2| Engineering Building II",
      @"ESB| Engineering Sciences Building",
      @"ELING| Elings Hall",
      @"EVENT CENTR| Event Center",
      @"GIRV| Girvetz Hall",
      @"HFH| Harold Frank Hall-previously Engineering I",
      @"HSSB| Humanities and Social Sciences Building",
      @"IV THEA| Isla Vista Theatres",
      @"ICA| Intercollegiate Athletics",
      @"KERR| Kerr Hall",
      @"KOHN| Kohn Hall",
      @"LIB| Davidson Library",
      @"LSB| Life Science Building",
      @"MANZ| Manzanita Village De Anza Center",
      @"MLAB| Marine Biology Laboratory",
      @"MUSIC| Music Building",
      @"MUSIC LLCH| Lotte Lehmann Concert Hall",
      @"MCC| Multicultural Center",
      @"NOBLE| Noble Hall",
      @"NH| North Hall",
      @"PHELP| Phelps Hall",
      @"PSB-N| Physical Sciences Building North",
      @"PSB-S| Physical Sciences Building South",
      @"PSYCH| Psychology Building",
      @"RECEN| Recreation Center",
      @"RECEN CTS| Recreation Center Tennis Courts",
      @"RGYM| Robertson Gym",
      @"SAASB| Student Affairs and Administrative Services Building",
      @"SAN MIGEL| San Miguel Residence Hall",
      @"SAN NIC| San Nicholas Residence Hall",
      @"SAN RAFEL| San Rafael Residence Hall",
      @"SANTA CRUZ| Santa Cruz Residence Hall",
      @"SANTA ROSA| Santa Rosa Residence Hall",
      @"SH| South Hall",
      @"STORKE| Storke Tower",
      @"STU HLTH| Student Health Center",
      @"SRB| Student Resources Building",
      @"TD-E| Theater/Dance East",
      @"TD-W| Theater/Dance West",
      @"UCEN| University Center",
      @"WEBB| Webb Hall-Geological Sciences",
      @"WMNS CENTR| Women’s Center",
      @"CARRILLO| Carrillo Dining Commons",
      @"DLG| De La Guerra Dining Commons",
      @"ORTEGA| Ortega Dining Commons",
      @"SSMS| Social Science and Media Studies",
      ];
    
    return countries;
}



#pragma mark - MLPAutoCompleteTextField Delegate


- (BOOL)autoCompleteTextField:(MLPAutoCompleteTextField *)textField
          shouldConfigureCell:(UITableViewCell *)cell
       withAutoCompleteString:(NSString *)autocompleteString
         withAttributedString:(NSAttributedString *)boldedString
        forAutoCompleteObject:(id<MLPAutoCompletionObject>)autocompleteObject
            forRowAtIndexPath:(NSIndexPath *)indexPath;
{
    //This is your chance to customize an autocomplete tableview cell before it appears in the autocomplete tableview
    //NSString *filename = [autocompleteString stringByAppendingString:@".png"];
    //filename = [filename stringByReplacingOccurrencesOfString:@" " withString:@"-"];
    //filename = [filename stringByReplacingOccurrencesOfString:@"&" withString:@"and"];
    //[cell.imageView setImage:[UIImage imageNamed:filename]];
    
    return YES;
}

- (void)autoCompleteTextField:(MLPAutoCompleteTextField *)textField
  didSelectAutoCompleteString:(NSString *)selectedString
       withAutoCompleteObject:(id<MLPAutoCompletionObject>)selectedObject
            forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *fileNameString = @"map";
    NSString *path = [[NSBundle mainBundle] pathForResource:fileNameString ofType:@"plist"];
    NSDictionary *coordinateDict = [[NSDictionary alloc] initWithContentsOfFile:path];
    if(selectedObject){
        NSLog(@"selected object from autocomplete menu %@ with string %@", selectedObject, [selectedObject autocompleteString]);
    } else {
        NSLog(@"selected string '%@' from autocomplete menu", selectedString);
    }
    NSString *seperator = @"|";
    NSString *keyString;
    NSString *nameString;
    NSScanner *scanner = [NSScanner scannerWithString:selectedString];
    [scanner scanUpToString:seperator intoString:&keyString];
    [scanner scanString:seperator intoString:nil];
    nameString = [selectedString substringFromIndex:scanner.scanLocation];
    NSLog(@"keystring = %@",keyString);
    NSString *xCoordinateString = [keyString stringByAppendingString:@"x"];
    NSString *yCoordinateString = [keyString stringByAppendingString:@"y"];
    NSLog(@"x = %@, y = %@",xCoordinateString,yCoordinateString);
    int xCoordinate = [[coordinateDict objectForKey:xCoordinateString] intValue];
    int yCoordinate = [[coordinateDict objectForKey:yCoordinateString] intValue];
    NSLog(@"xCoordinate = %d, yCoordinate = %d",xCoordinate,yCoordinate);
    [self AddPinAtindex:xCoordinate withYcoordinate:yCoordinate andBuildingTitle:keyString];
}

@end
