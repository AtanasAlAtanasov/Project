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

- (void)viewDidLoad
{
    [super viewDidLoad];
    MKCoordinateRegion region;
    //region.center.latitude = _latitude;
    //region.center.longitude = _longitude;
    region.span.latitudeDelta = 0.01f;
    region.span.longitudeDelta = 0.01f;
    [mapView setRegion:region animated:YES];
    
    PinClass *ann = [[PinClass alloc] init];
    ann.coordinate = region.center;
    [mapView addAnnotation:ann];
	
    mapView.showsUserLocation = YES;
    [self loadStops];
}

-(void)loadStops {
    
    NSURL *stopsUrl = [NSURL URLWithString:@"https://code.google.com/p/sofia-public-transport-navigator/source/browse/res/raw/coordinates.xml?name=Version+1.2+-+fixed+map+key"];
    NSLog(@"1 %@",stopsUrl);
    NSData *stopsHtmlData = [NSData dataWithContentsOfURL:stopsUrl];
   
    // 2
    TFHpple *stopsParser = [TFHpple hppleWithHTMLData:stopsHtmlData];
    

    // 3
    NSString *stopsXpathQueryString = @"//*[@id='src_table_0']/tr/td";
    NSLog(@"2 %@",stopsXpathQueryString);
    NSArray *stopsNodes = [stopsParser searchWithXPathQuery:stopsXpathQueryString];
    //NSLog(@"5 %@",stopsNodes);

    
    // 4
    //NSMutableArray *newStops = [[NSMutableArray alloc] initWithCapacity:0];
   
    for (TFHppleElement *element in stopsNodes) {
        // 5
        Tutorial *transportStop = [[Tutorial alloc] init];
        //[newStops addObject:transportStop];
        
        // 6
        
        transportStop.title = [[element firstChild] content];
        NSLog(@"3 %@",transportStop.title);
        
        // 7
        //transportStop.url = [[element attributes] objectForKey:@"atv"];
        //NSLog(@"4 %@",transportStop.url);
        

    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
