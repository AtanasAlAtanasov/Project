//
//  BusInfoViewController.m
//  Sofia_Trasport
//
//  Created by Atanas Atanasov on 12/13/13.
//  Copyright (c) 2013 Atanas Atanasov. All rights reserved.
//

#import "BusInfoViewController.h"
#import "ViewController.h"
#import "PinClass.h"

@interface BusInfoViewController ()

@end

@implementation BusInfoViewController
@synthesize lableName,nameOfStop,lableCode,codeOfStop,stringForParse;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
   
    [super viewDidLoad];
    
    lableName.text = nameOfStop;
    lableCode.text = codeOfStop;
    NSString *url;
    NSString *first = [NSString stringWithFormat:@"http://m.sofiatraffic.bg/vt?q="];
    NSString *last = [NSString stringWithFormat:@"&o=1&go=1"];
    url = [NSString stringWithFormat:@"%@%@%@",first,codeOfStop,last];
    NSLog(@"url - %@",url);
    [self getDataFrom:url];

}

- (NSString *) getDataFrom:(NSString *)url{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    [request setHTTPMethod:@"GET"];
    [request setURL:[NSURL URLWithString:url]];
    
    NSError *error = [[NSError alloc] init];
    NSHTTPURLResponse *responseCode = nil;
    
    NSData *oResponseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&responseCode error:&error];
    
    if([responseCode statusCode] != 200){
        NSLog(@"Error getting %@, HTTP status code %i", url, [responseCode statusCode]);
        return nil;
    }
    
    NSLog(@"%@",[[NSString alloc] initWithData:oResponseData encoding:NSUTF8StringEncoding]);
    stringForParse = [[NSString alloc] initWithData:oResponseData encoding:NSUTF8StringEncoding];
    NSLog(@"string %@",stringForParse);
    return [[NSString alloc] initWithData:oResponseData encoding:NSUTF8StringEncoding];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backButton:(id)sender {
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
}
@end
