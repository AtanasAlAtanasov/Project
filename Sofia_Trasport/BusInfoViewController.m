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
@synthesize lableName,nameOfStop,lableCode,codeOfStop,stringForParse,parseString,codeWebView,textCodeView,url,stringCodeCheck;

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
    NSString *first = [NSString stringWithFormat:@"http://m.sofiatraffic.bg/vt?q="];
    NSString *last = [NSString stringWithFormat:@"&o=1&go=1"];
    url = [NSString stringWithFormat:@"%@%@%@",first,codeOfStop,last];
    [self getDataFrom:url];

}

- (NSString *) getDataFrom:(NSString *)myUrl{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    [request setHTTPMethod:@"GET"];
    [request setURL:[NSURL URLWithString:myUrl]];
    
    NSError *error = [[NSError alloc] init];
    NSHTTPURLResponse *responseCode = nil;
    
    NSData *oResponseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&responseCode error:&error];
    
    if([responseCode statusCode] != 200){
        NSLog(@"Error getting %@, HTTP status code %i", myUrl, [responseCode statusCode]);
        return nil;
    }
    
    stringForParse = [[NSString alloc] initWithData:oResponseData encoding:NSUTF8StringEncoding];
    parseString = [stringForParse componentsSeparatedByString:@"src=""\""];
    

    stringForParse=[parseString[2] substringToIndex:41];
    
    
    NSString *first = [NSString stringWithFormat:@"http://m.sofiatraffic.bg"];
    myUrl = [NSString stringWithFormat:@"%@%@",first,stringForParse];
    stringCodeCheck = [stringForParse  substringFromIndex:9];
    first = [NSString stringWithFormat:@"\""];
    
    NSLog(@"url %@",myUrl);
    NSLog(@"pic Code %@",stringCodeCheck);
    
    NSURL *urlAdress = [NSURL URLWithString:myUrl];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:urlAdress];
    [codeWebView loadRequest:requestObj];
    
    return [[NSString alloc] initWithData:oResponseData encoding:NSUTF8StringEncoding];
}

- (IBAction)checkButton:(id)sender {
    [self postDataFrom:url];
    NSLog(@"code %@",textCodeView.text);
}

- (NSString *) postDataFrom:(NSString *)myUrl{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    [request setHTTPMethod:@"POST"];
    [request setURL:[NSURL URLWithString:myUrl]];
    
    NSError *error = [[NSError alloc] init];
    NSHTTPURLResponse *responseCode = nil;
    
    NSData *oResponseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&responseCode error:&error];
    
    if([responseCode statusCode] != 200){
        NSLog(@"Error getting %@, HTTP status code %i", myUrl, [responseCode statusCode]);
        return nil;
    }
    
    stringForParse = [[NSString alloc] initWithData:oResponseData encoding:NSUTF8StringEncoding];
    parseString = [stringForParse componentsSeparatedByString:@"src=""\""];
    
    
    stringForParse=[parseString[2] substringWithRange:NSMakeRange(9, 32)];

    NSLog(@"pic Code Check %@",stringForParse);
    
    NSLog(@"%@",[[NSString alloc] initWithData:oResponseData encoding:NSUTF8StringEncoding]);
    
    
    [request addValue:textCodeView.text forHTTPHeaderField:@"Content-Type"];
    
    [request setValue:stringForParse forHTTPHeaderField:stringCodeCheck];
    NSLog(@"%@",[[NSString alloc] initWithData:oResponseData encoding:NSUTF8StringEncoding]);

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
