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

@interface ViewController ()

@end

@implementation ViewController

@synthesize stringForParse,parseStings,stopsInfo,latitude,longitude,stopName,stopCode,myPinView,myCurLatitude,myCurLongitude,locationManager;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	self.MapContorller.delegate=self;
    //self.MapContorller.showsUserLocation = YES;
    [self loadStops];
    locationManager = [[CLLocationManager alloc] init];
    [locationManager startUpdatingLocation];
    
    
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
        
        int a=0;
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


-(void)makePin {
    
    double myLatitude = [latitude doubleValue];
    double myLongitude = [longitude doubleValue];
    
    MKCoordinateRegion region;
    region.center.latitude = myLatitude;
    region.center.longitude = myLongitude;
    region.span.latitudeDelta = 0.01f;
    region.span.longitudeDelta = 0.01f;
    [self.MapContorller setRegion:region animated:YES];
    
    PinClass *ann = [[PinClass alloc] init];
    ann.coordinate = region.center;
    ann.title = stopName;

    ann.subtitle = stopCode;
    [self.MapContorller addAnnotation:ann];
    
}

//-(MKAnnotationView  *)pinChangeColor:(MKAnnotationView  *) pin{
//    
//    
//        //pin.image = [UIImage imageNamed:@"favicon.ico"];
//        return pin;
//   
//}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    MKAnnotationView  *pinView = (MKAnnotationView *) [mapView dequeueReusableAnnotationViewWithIdentifier:@"Pin"];
    
    if (pinView ==nil) {
        
        pinView= [[MKAnnotationView  alloc]initWithAnnotation:annotation reuseIdentifier:@"Pin"];
        //[self pinChangeColor:pinView];
        pinView.canShowCallout = YES;
        
        pinView.image = [UIImage imageNamed:@"favicon.ico"];

        return pinView;
    }
    //pinView.canShowCallout = YES;
    
    return pinView;
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
