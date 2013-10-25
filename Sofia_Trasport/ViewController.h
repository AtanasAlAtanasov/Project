//
//  ViewController.h
//  Sofia_Trasport
//
//  Created by Atanas Atanasov on 10/24/13.
//  Copyright (c) 2013 Atanas Atanasov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreGraphics/CoreGraphics.h>
#import <MapKit/MKPinAnnotationView.h>

@interface ViewController : UIViewController {
    
    MKMapView *mapView;
}

@property (weak, nonatomic) IBOutlet MKMapView *MapContorller;
@property (nonatomic) NSString *stringForParse;
@property (nonatomic) NSArray *parseStings;
@property (nonatomic) NSMutableArray *stopsInfo;

@end
