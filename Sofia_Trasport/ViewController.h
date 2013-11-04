//
//  ViewController.h
//  Sofia_Trasport
//
//  Created by Atanas Atanasov on 10/24/13.
//  Copyright (c) 2013 Atanas Atanasov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <MapKit/MKReverseGeocoder.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MKPinAnnotationView.h>

@interface ViewController : UIViewController<MKMapViewDelegate> {

}
@property (nonatomic, retain) CLLocationManager *locationManager;
@property double myCurLatitude;
@property double myCurLongitude;
@property (nonatomic) MKPinAnnotationView *myPinView;
@property (nonatomic) IBOutlet MKMapView *MapContorller;
- (IBAction)myLocation:(id)sender;
@property (nonatomic) NSString *stringForParse;
@property (nonatomic) NSArray *parseStings;
@property (nonatomic) NSMutableArray *stopsInfo;
@property (nonatomic) NSString *latitude;
@property (nonatomic) NSString *longitude;
@property (nonatomic) NSString *stopCode;
@property (nonatomic) NSString *stopName;


@end
