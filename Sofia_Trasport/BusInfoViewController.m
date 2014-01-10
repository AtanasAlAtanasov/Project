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

#import "AFHTTPRequestOperation.h"
#import "AFHTTPRequestOperationManager.h"
#import "AFURLConnectionOperation.h"
#import "AFURLSessionManager.h"
#import "AFHTTPSessionManager.h"


@interface BusInfoViewController ()

@property (nonatomic, strong) NSString *cookieMonster;
@property (nonatomic, strong) NSString *bodyCheck;

@end

@implementation BusInfoViewController
@synthesize lableName,nameOfStop,lableCode,codeOfStop,stringForParse,parseString,codeWebView,textCodeView,url,stringCodeCheck,textForBus;

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

- (NSString *) getDataFrom:(NSString *)myUrl
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    [request setHTTPMethod:@"GET"];
    [request setURL:[NSURL URLWithString:myUrl]];
    
    NSError *error = [[NSError alloc] init];
    NSHTTPURLResponse *response = nil;
    
    NSData *oResponseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    if ([response statusCode] != 200) {
        NSLog(@"Error getting %@, HTTP status code %i", myUrl, [response statusCode]);
        textForBus.text = [NSString stringWithFormat:@"Проблем с достъпа до сървъра.\nСъжеляваме за проблема."];
        return nil;
    }
    
    self.cookieMonster = response.allHeaderFields[@"Set-Cookie"];
    
    stringForParse = [[NSString alloc] initWithData:oResponseData encoding:NSUTF8StringEncoding];
    
    parseString = [stringForParse componentsSeparatedByString:@"src=""\""];
    
    if([stringForParse length]<=2530 && [stringForParse length]>=2350){
        self.textForBus.hidden=YES;
        stringForParse=[parseString[2] substringToIndex:41];
        NSString *first = [NSString stringWithFormat:@"http://m.sofiatraffic.bg"];
        myUrl = [NSString stringWithFormat:@"%@%@",first,stringForParse];
        stringCodeCheck = [stringForParse  substringFromIndex:9];
        first = [NSString stringWithFormat:@"\""];
        
        NSURL *urlAdress = [NSURL URLWithString:myUrl];
        NSURLRequest *requestObj = [NSURLRequest requestWithURL:urlAdress];
        [codeWebView loadRequest:requestObj];
       
    } else if ([stringForParse length]>=2530 || [stringForParse length]<=2350){
        [self postDataFrom:url];
    }
    
    
    
    
    return [[NSString alloc] initWithData:oResponseData encoding:NSUTF8StringEncoding];
}
-(IBAction)backGroundTouch:(id)sender {
    [textCodeView resignFirstResponder];
}
- (IBAction)checkButton:(id)sender {
    [self postDataFrom:url];
    //NSLog(@"code %@",textCodeView.text);
}

- (NSString *) postDataFrom:(NSString *)myUrl
{
    NSMutableURLRequest *request = [[ NSMutableURLRequest alloc] init];
    
    [request setHTTPMethod:@"POST"];
    [request setURL:[NSURL URLWithString:myUrl]];
    assert(self.cookieMonster.length);
    [request setValue:self.cookieMonster forHTTPHeaderField:@"Set-Cookie"];
    NSError *error = [[NSError alloc] init];
    NSHTTPURLResponse *response = nil;
    
    NSData *oResponseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    if([response statusCode] != 200){
        NSLog(@"Error getting %@, HTTP status code %i", myUrl, [response statusCode]);
        return nil;
    }
    self.cookieMonster = response.allHeaderFields[@"Set-Cookie"];
    
    stringForParse = [[NSString alloc] initWithData:oResponseData encoding:NSUTF8StringEncoding];
    parseString = [stringForParse componentsSeparatedByString:@"src=""\""];
    
    
    
    
    if([parseString[1] length]<=865){

    stringForParse=[parseString[2] substringWithRange:NSMakeRange(9, 32)];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSDictionary *myRequest = @{@"q":codeOfStop,@"o":@"1",@"sc": textCodeView.text ,@"poleicngi": stringCodeCheck,@"go":@"1"};
        [manager POST:myUrl parameters:myRequest success:^(AFHTTPRequestOperation *operation, id responseObject) {
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
           // NSLog(@"Data: %@", operation.responseString);
            self.textForBus.hidden = NO;
            textForBus.text = operation.responseString;
            
            NSArray *resultArray;
            resultArray = [operation.responseString componentsSeparatedByString:@" "];
            int a = 0;
            for(NSString * str in resultArray){
                NSLog(@"Array %d: %@",a,[resultArray objectAtIndex:a]);
                a++;
                
            }
            [textCodeView resignFirstResponder];

        }];
    } else if ([parseString[1] length]>=865) {
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            [manager GET:myUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
           // NSLog(@"Data: %@",operation.responseString);
            textForBus.text = operation.responseString;
            
            NSArray *resultArray;
            resultArray = [operation.responseString componentsSeparatedByString:@" "];
            int a = 0;
            for(NSString * str in resultArray){
                NSLog(@"Array %d: %@",a,[resultArray objectAtIndex:a]);
                a++;
                
            }
            
        }];
    }
    
   
    return [[NSString alloc] initWithData:request.HTTPBody encoding:NSUTF8StringEncoding];
    
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
