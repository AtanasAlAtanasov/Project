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
#import "BusClass.h"
#import "AppDelegate.h"

@interface ViewController () {
    NSArray *places;
    CLLocationDegrees zoomLevel;
    dispatch_queue_t queue;

}
@property (nonatomic,strong)NSMutableArray* fetchedRecordsArrayStops;
@property (nonatomic,strong) NSMutableArray * busStops;


@end

@implementation ViewController

@synthesize stringForParse,parseStings,stopsInfo,latitude,longitude,stopName,stopCode,myPinView,myCurLatitude,myCurLongitude,locationManager,managedObjectContext,fetchedRecordsArrayStops,fetchedResultsController,managedObjectModel,persistentStoreCoordinator,busStops;

- (void)viewDidLoad
{
    [super viewDidLoad];
    AppDelegate* appDelegate  = [UIApplication sharedApplication].delegate;
    self.managedObjectContext = appDelegate.managedObjectContext;
    busStops = [[NSMutableArray alloc] init];
    self.fetchedRecordsArrayStops = [[NSMutableArray alloc] init];
    [self.fetchedRecordsArrayStops addObjectsFromArray:[appDelegate getAllBusStops]];
    
    self.MapContorller.delegate=self;
    //[self loadStops];
    locationManager = [[CLLocationManager alloc] init];
    self.MapContorller.showsUserLocation = YES;
    
    
    [locationManager startMonitoringSignificantLocationChanges];
    [locationManager startUpdatingHeading];
    [locationManager startUpdatingLocation];

    NSURL *urlConnected = [NSURL URLWithString:@"https://www.google.bg/"];
    NSData *loadTest   = [NSData dataWithContentsOfURL:urlConnected];
    
    [self showUserLocation];
    
    if([self.fetchedRecordsArrayStops count] != 0){
        
        BusClass * busData = [self.fetchedRecordsArrayStops objectAtIndex:3];
        if(busData.loadName == NULL){
            [self loadStops];
        } else {
            [self makePinCoreData];
            [self filterAnnotations:busStops];


        }
    } else if (loadTest == nil) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Няма връска с интернет!" message:@"Не може да бъде установена връска с интернет."  delegate:self cancelButtonTitle:@"Добре" otherButtonTitles: @"Презареждане", nil];
        [alert show];
    } else {
         [self loadStops];
    }
    
    
}
-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 1){
        NSURL *urlConnected = [NSURL URLWithString:@"https://www.google.bg/"];
        NSData *loadTest   = [NSData dataWithContentsOfURL:urlConnected];
        
        if([self.fetchedRecordsArrayStops count] != 0){
            
            BusClass * busData = [self.fetchedRecordsArrayStops objectAtIndex:3];
            if(busData.loadName == NULL){
                [self loadStops];
            } else {
                [self makePinCoreData];
                [self filterAnnotations:busStops];

                //[self.MapContorller showAnnotations:busStops animated:NO];


            }
        } else if (loadTest == nil) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Няма връска с интернет!" message:@"Не може да бъде установена връска с интернет."  delegate:self cancelButtonTitle:@"Добре" otherButtonTitles: @"Презареждане", nil];
            [alert show];
        } else {
            [self loadStops];
        }
    }
}


-(void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated{
    if (zoomLevel!=mapView.region.span.longitudeDelta) {
        [self filterAnnotations:busStops];
        
        zoomLevel=mapView.region.span.longitudeDelta;
    }
}


-(void)filterAnnotations:(NSArray *)placesToFilter{

    float latDelta=self.MapContorller.region.span.latitudeDelta/54.0;
    float longDelta=self.MapContorller.region.span.longitudeDelta/66.0;
    NSMutableArray *stopsToShow=[[NSMutableArray alloc] initWithCapacity:0];

    for (int i=0; i<[placesToFilter count]; i++) {
        PinClass *checkingLocation=[placesToFilter objectAtIndex:i];
        CLLocationDegrees latitude2 = checkingLocation.coordinate.latitude;
        CLLocationDegrees longitude2 = checkingLocation.coordinate.longitude;
        
        bool found=FALSE;
        for (PinClass *tempPlacemark in stopsToShow) {
            if(fabs(tempPlacemark.coordinate.latitude-latitude2) < latDelta && fabs(tempPlacemark.coordinate.longitude-longitude2)<longDelta ){
                [self.MapContorller removeAnnotation:checkingLocation];
                found=TRUE;
                [tempPlacemark addPlace:checkingLocation];
                break;
            }
        }
        

        if (!found) {
            
            [stopsToShow addObject:checkingLocation];
            [self.MapContorller addAnnotation:checkingLocation];
        }

        
    }
}


- (IBAction)myLocation:(id)sender {
    [self showUserLocation];
    
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
    [self showUserLocation];
    [self.MapContorller showAnnotations:busStops animated:NO];
    
}
-(void) showUserLocation {
    MKCoordinateRegion regionUser;
    regionUser.center.latitude = myCurLatitude;
    regionUser.center.longitude = myCurLongitude;
    regionUser.span.latitudeDelta = 0.01f;
    regionUser.span.longitudeDelta = 0.01f;
    self.MapContorller.showsUserLocation = YES;
    [self.MapContorller setRegion:regionUser animated:YES];
    [self.MapContorller setUserTrackingMode:MKUserTrackingModeFollowWithHeading animated:NO];
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
                             action:@selector(self)
                   forControlEvents:UIControlEventTouchUpInside];
        
        pinView.rightCalloutAccessoryView = disclosureButton;
        
        return pinView;
    }
    
    return pinView;
    
}

-(void)makePinCoreData {
    
    BusClass * busData = [NSEntityDescription insertNewObjectForEntityForName:@"LoadStops"
                                                       inManagedObjectContext:self.managedObjectContext];
    for (int inex = 0;inex<[self.fetchedRecordsArrayStops count];inex++){
    busData = [self.fetchedRecordsArrayStops objectAtIndex:inex];
        latitude = busData.latitude;
        longitude = busData.longitude;
        stopCode = busData.loadCode;
        stopName = busData.loadName;

        double myLatitude = [latitude doubleValue];
        double myLongitude = [longitude doubleValue];
    
        [self makeAnnotation:myLatitude :myLongitude];
        
    }
    
}

-(void)makeAnnotation:(double)myLatitude :(double)myLongitude {
    MKCoordinateRegion region;
    region.center.latitude = myLatitude;
    region.center.longitude = myLongitude;
    region.span.latitudeDelta = 0.01f;
    region.span.longitudeDelta = 0.01f;
    
    PinClass *ann = [[PinClass alloc] init];
    ann.coordinate = region.center;
    ann.title = stopName;
    
    ann.subtitle =[NSString stringWithFormat:@"%@%@",[self zeros],stopCode];
    
    [busStops addObject:ann];

}

-(NSString *)zeros {
    NSString *zeros = @"";
    if(stopCode.length==1){
        zeros = @"000";
    } else if (stopCode.length == 2){
        zeros = @"00";
    } else if (stopCode.length == 3){
        zeros = @"0";
    } else if (stopCode.length == 4){
        zeros = @"";
    }
    return  zeros;
}

-(void)makePin {

    double myLatitude = [latitude doubleValue];
    double myLongitude = [longitude doubleValue];
        
    MKCoordinateRegion region;
    region.center.latitude = myLatitude;
    region.center.longitude = myLongitude;
    region.span.latitudeDelta = 0.01f;
    region.span.longitudeDelta = 0.01f;
    
    PinClass *ann = [[PinClass alloc] init];
    ann.coordinate = region.center;
    ann.title = stopName;
    
    ann.subtitle =[NSString stringWithFormat:@"%@%@",[self zeros],stopCode];
    
    BusClass * newEntry = [NSEntityDescription insertNewObjectForEntityForName:@"LoadStops"
                                                        inManagedObjectContext:self.managedObjectContext];
    
    newEntry.loadName = ann.title;
    newEntry.loadCode = ann.subtitle;
    newEntry.latitude = latitude;
    newEntry.longitude = longitude;
    NSError *error;
    
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
    
    [self.view endEditing:YES];
    [busStops addObject:ann];

}

-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    BusInfoViewController * busView = [self.storyboard instantiateViewControllerWithIdentifier:@"busViewController"];
    busView.nameOfStop = view.annotation.title;
    busView.codeOfStop = view.annotation.subtitle;
    self.MapContorller.showsUserLocation = NO;
    
    [locationManager stopMonitoringSignificantLocationChanges];
    [locationManager stopUpdatingLocation];
    
    [self presentModalViewController:busView animated:YES];
    

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
