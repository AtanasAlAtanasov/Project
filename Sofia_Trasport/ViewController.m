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


@synthesize stringForParse,parseStings,stopsInfo,latitude,longitude,stopName,stopCode,myPinView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	self.MapContorller.delegate=self;
    self.MapContorller.showsUserLocation = YES;
    [self loadStops];
    
    
}

- (IBAction)myLocation:(id)sender {
    
    latitude = [NSString stringWithFormat:@"42.672442"];
    longitude = [NSString stringWithFormat:@"23.297753"];
    double myLatitude = [latitude doubleValue];
    double myLongitude = [longitude doubleValue];
    MKCoordinateRegion regionUser;
    regionUser.center.latitude = myLatitude;
    regionUser.center.longitude = myLongitude;
    regionUser.span.latitudeDelta = 0.01f;
    regionUser.span.longitudeDelta = 0.01f;
    self.MapContorller.showsUserLocation = YES;
    [self.MapContorller setRegion:regionUser animated:YES];
    [self.MapContorller setUserTrackingMode:MKUserTrackingModeFollowWithHeading animated:YES];
}


-(void)loadStops {
    
    NSURL *stopsUrl = [NSURL URLWithString:@"https://code.google.com/p/sofia-public-transport-navigator/source/browse/res/raw/coordinates.xml?name=Version+1.2+-+fixed+map+key"];
    //NSLog(@"1 %@",stopsUrl);
    NSData *stopsHtmlData = [NSData dataWithContentsOfURL:stopsUrl];
   
    TFHpple *stopsParser = [TFHpple hppleWithHTMLData:stopsHtmlData];
    
    NSString *stopsXpathQueryString = @"//*[@id='src_table_0']/tr/td";
    //NSLog(@"2 %@",stopsXpathQueryString);
    NSArray *stopsNodes = [stopsParser searchWithXPathQuery:stopsXpathQueryString];
   
    for (TFHppleElement *element in stopsNodes) {

        Tutorial *transportStop = [[Tutorial alloc] init];
    
        transportStop.title = [[element firstChild] content];
        //NSLog(@"3 %@",transportStop.title);
        
        stringForParse = transportStop.title;
        
        parseStings = [stringForParse componentsSeparatedByString:@"\""];
        
        int a=0;
        a = [parseStings count];
        
        if(a == 9) {
            latitude = (NSString*) [parseStings objectAtIndex:5];
            longitude = (NSString*) [parseStings objectAtIndex:7];
            stopCode = (NSString*) [parseStings objectAtIndex:1];
            stopName = (NSString*) [parseStings objectAtIndex:3];
            
            //NSLog(@"code %@",stopCode);
            //NSLog(@"name %@",stopName);
            //NSLog(@"lat %@",latitude);
            //NSLog(@"long %@",longitude);
            //NSLog(@"--------------");
            [self makePin];
        }

    }
}


-(void)makePin {
    
    //latitude = [NSString stringWithFormat:@"42.707318"];
    //longitude = [NSString stringWithFormat:@"23.338418"];
    double myLatitude = [latitude doubleValue];
    double myLongitude = [longitude doubleValue];
    
    //NSLog(@"Long %f",myLongitude);
    //NSLog(@"Lat %f",myLatitude);
    
    
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

-(MKPinAnnotationView *)pinChangeColor{
    
            myPinView.pinColor = MKPinAnnotationColorRed;
            //myPinView.animatesDrop = YES;
            //myPinView.draggable = YES;
            return myPinView;
   
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    
    MKPinAnnotationView *pinView = (MKPinAnnotationView*) [mapView dequeueReusableAnnotationViewWithIdentifier:@"Pin"];
    
    if (pinView ==nil) {
        
        myPinView= [[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"Pin"];
        
            [self pinChangeColor];
            pinView = myPinView;
            return pinView;
    }
    return 0;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
