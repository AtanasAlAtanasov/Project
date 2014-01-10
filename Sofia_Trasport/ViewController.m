//
//  ViewController.m
//  Sofia_Trasport
//
//  Created by Atanas Atanasov on 10/24/13.
//  Copyright (c) 2013 Atanas Atanasov. All rights reserved.
//

#import "ViewController.h"
#import "TFHpple.h"
#import "Tutorial.h"
#import "Contributor.h"
#import "PinClass.h"
#import "BusInfoViewController.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize stringForParse,parseStings,stopsInfo,latitude,longitude,stopName,stopCode,myPinView,myCurLatitude,myCurLongitude,locationManager;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.MapContorller.delegate=self;
    //[self loadStops];
    locationManager = [[CLLocationManager alloc] init];
    [locationManager startUpdatingLocation];
    
    NSURL *urlConnected = [NSURL URLWithString:@"https://www.google.bg/"];
    NSData *loadTest   = [NSData dataWithContentsOfURL:urlConnected];
    
    if (loadTest == nil) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Network Connection!" message:@"Cannot establish internet connection."  delegate:self cancelButtonTitle:@"OK" otherButtonTitles: @"Refresh", nil];
        [alert show];
    } else {
        [self loadStops];
    }
}
-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 1){
        NSURL *urlConnected = [NSURL URLWithString:@"https://www.google.bg/"];
        NSData *loadTest   = [NSData dataWithContentsOfURL:urlConnected];
        
        if (loadTest == nil) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Network Connection!" message:@"Cannot establish internet connection."  delegate:self cancelButtonTitle:@"OK" otherButtonTitles: @"Refresh", nil];
            [alert show];
        } else {
            [self loadStops];
        }
    }
}

- (IBAction)myLocation:(id)sender {
    
    MKCoordinateRegion regionUser;
    regionUser.center.latitude = myCurLatitude;
    regionUser.center.longitude = myCurLongitude;
    regionUser.span.latitudeDelta = 0.01f;
    regionUser.span.longitudeDelta = 0.01f;
    self.MapContorller.showsUserLocation = YES;
    [self.MapContorller setRegion:regionUser animated:NO];
    [self.MapContorller setUserTrackingMode:MKUserTrackingModeFollowWithHeading animated:YES];
    
}


-(void)loadStops {
    
    NSURL *stopsUrl = [NSURL URLWithString:@"https://code.google.com/p/sofia-public-transport-navigator/source/browse/res/raw/coordinates.xml?name=Version+1.2+-+fixed+map+key"];
    NSData *stopsHtmlData = [NSData dataWithContentsOfURL:stopsUrl];
   
    TFHpple *stopsParser = [TFHpple hppleWithHTMLData:stopsHtmlData];
    
    NSString *stopsXpathQueryString = @"//*[@id='src_table_0']/tr/td";

    NSArray *stopsNodes = [stopsParser searchWithXPathQuery:stopsXpathQueryString];
    for (TFHppleElement *element in stopsNodes) {
        
        Tutorial *transportStop = [[Tutorial alloc] init];
        
        transportStop.title = [[element firstChild] content];
        
        stringForParse = transportStop.title;
        
        parseStings = [stringForParse componentsSeparatedByString:@"\""];
        
        NSUInteger a=0;
        a = [parseStings count];
        
        if(a == 9) {
            latitude = (NSString*) [parseStings objectAtIndex:5];
            longitude = (NSString*) [parseStings objectAtIndex:7];
            stopCode = (NSString*) [parseStings objectAtIndex:1];
            stopName = (NSString*) [parseStings objectAtIndex:3];
            [self makePin];
        }

    }
}


-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    MKAnnotationView  *pinView = (MKAnnotationView *) [mapView dequeueReusableAnnotationViewWithIdentifier:@"Pin"];
    
    if (annotation == mapView.userLocation) return nil;
    else if (pinView == nil) {
        pinView= [[MKAnnotationView  alloc]initWithAnnotation:annotation reuseIdentifier:@"Pin"];
        pinView.canShowCallout = YES;
        pinView.image = [UIImage imageNamed:@"icon1.png"];
        UIButton * disclosureButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        
        [disclosureButton addTarget:self
                             action:@selector(presentMoreInfo)
                   forControlEvents:UIControlEventTouchUpInside];
        
        pinView.rightCalloutAccessoryView = disclosureButton;
        
        return pinView;
    }
    
    return pinView;
    
}

-(void)makePin {
    
    double myLatitude = [latitude doubleValue];
    double myLongitude = [longitude doubleValue];
    myCurLatitude = myLatitude;
    myCurLongitude = myLongitude;
    
    MKCoordinateRegion region;
    region.center.latitude = myLatitude;
    region.center.longitude = myLongitude;
    region.span.latitudeDelta = 0.01f;
    region.span.longitudeDelta = 0.01f;
    [self.MapContorller setRegion:region animated:YES];
    
    PinClass *ann = [[PinClass alloc] init];
    ann.coordinate = region.center;
    ann.title = stopName;
    NSString * zeros = @"00000";
    ann.subtitle =[NSString stringWithFormat:@"%@%@",zeros ,stopCode];
    [self.MapContorller addAnnotation:ann];
    
}

-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    BusInfoViewController * busView = [self.storyboard instantiateViewControllerWithIdentifier:@"busViewController"];
    busView.nameOfStop = view.annotation.title;
    busView.codeOfStop = view.annotation.subtitle;
    [self presentModalViewController:busView animated:YES];
    
}

-(void)presentMoreInfo
 {
    
     //BusInfoViewController *tagEditor = [self.storyboard instantiateViewControllerWithIdentifier:@"busViewController"];
     //[self presentModalViewController:tagEditor animated:YES];
    
}


- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
{
    
    myCurLatitude = newLocation.coordinate.latitude;
    myCurLongitude = newLocation.coordinate.longitude;

}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
