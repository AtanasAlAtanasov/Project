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
   
	
    mapView.showsUserLocation = YES;
    
    //[self loadStops];
    [self makePin];
}

-(void)loadStops {
    
    NSURL *stopsUrl = [NSURL URLWithString:@"https://code.google.com/p/sofia-public-transport-navigator/source/browse/res/raw/coordinates.xml?name=Version+1.2+-+fixed+map+key"];
    NSLog(@"1 %@",stopsUrl);
    NSData *stopsHtmlData = [NSData dataWithContentsOfURL:stopsUrl];
   
    TFHpple *stopsParser = [TFHpple hppleWithHTMLData:stopsHtmlData];
    
    NSString *stopsXpathQueryString = @"//*[@id='src_table_0']/tr/td";
    NSLog(@"2 %@",stopsXpathQueryString);
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
            
            NSLog(@"code %@",stopCode);
            NSLog(@"name %@",stopName);
            NSLog(@"lat %@",latitude);
            NSLog(@"long %@",longitude);
            NSLog(@"--------------");
            
        }

    }
}

-(void)makePin {
    
    latitude = [NSString stringWithFormat:@"42.707318"];
    longitude = [NSString stringWithFormat:@"23.338418"];
    double myLatitude = [latitude doubleValue];
    double myLongitude = [longitude doubleValue];
    
    NSLog(@"Long %f",myLongitude);
    NSLog(@"Lat %f",myLatitude);
    
    
    MKCoordinateRegion region;
    region.center.latitude = myLatitude;
    region.center.longitude = myLongitude;
    region.span.latitudeDelta = 0.01f;
    region.span.longitudeDelta = 0.01f;
    [mapView setRegion:region animated:YES];
    
    
    PinClass *ann = [[PinClass alloc] init];
    ann.coordinate = region.center;
    //ann.subtitle =
    [mapView addAnnotation:ann];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
