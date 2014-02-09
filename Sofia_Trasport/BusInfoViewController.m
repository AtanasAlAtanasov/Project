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

#import "TFHpple.h"
#import "Tutorial.h"

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
        NSLog(@"Error getting %@, HTTP status code %li", myUrl, (long)[response statusCode]);
        textForBus.text = [NSString stringWithFormat:@"Проблем с достъпа до сървъра.\nСъжеляваме за проблема."];
        return nil;
    }
    
    self.cookieMonster = response.allHeaderFields[@"Set-Cookie"];
    
    stringForParse = [[NSString alloc] initWithData:oResponseData encoding:NSUTF8StringEncoding];
   
    parseString = [stringForParse componentsSeparatedByString:@"src=""\""];
    
    if ([parseString[1] rangeOfString:@"символите от"].location == NSNotFound) {
        [self postDataFrom:url];
        
       
    } else {
        self.textForBus.hidden=YES;
        if ([parseString[2] rangeOfString:@"/captcha"].location == NSNotFound) {
            //NSLog(@"Няма");
        } else {
            //NSLog(@"Има");
            stringForParse=[parseString[2] substringToIndex:41];
            NSString *first = [NSString stringWithFormat:@"http://m.sofiatraffic.bg"];
            myUrl = [NSString stringWithFormat:@"%@%@",first,stringForParse];
            stringCodeCheck = [stringForParse  substringFromIndex:9];
            //first = [NSString stringWithFormat:@"\""];
            NSURL *urlAdress = [NSURL URLWithString:myUrl];
            NSURLRequest *requestObj = [NSURLRequest requestWithURL:urlAdress];
            [codeWebView loadRequest:requestObj];
            
        }
       
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
        NSLog(@"Error getting %@, HTTP status code %li", myUrl, (long)[response statusCode]);
        return nil;
    }
    self.cookieMonster = response.allHeaderFields[@"Set-Cookie"];
    
    stringForParse = [[NSString alloc] initWithData:oResponseData encoding:NSUTF8StringEncoding];
    
    
    parseString = [stringForParse componentsSeparatedByString:@"src=""\""];
    
    if ([parseString[1] rangeOfString:@"символите от"].location == NSNotFound) {
       //Няма символите от
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager GET:myUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            // NSLog(@"Data: %@",operation.responseString);
            textForBus.text = operation.responseString;
            //NSLog(@"text for parse: %@",operation.responseString);
            
            
            NSString *searchedString = operation.responseString;
            NSRange   searchedRange = NSMakeRange(0, [searchedString length]);
            NSString *pattern = @"(\\<b>)(.{1,})(\\</b>)";//@"(?:www\\.)?((?!-)[a-zA-Z0-9-]{2,63}(?<!-))\\.?((?:[a-zA-Z0-9]{2,})?(?:\\.[a-zA-Z0-9]{2,})?)";
            NSError  *myError = nil;
            
            NSRegularExpression* regex = [NSRegularExpression regularExpressionWithPattern: pattern options:0 error:&myError];
            NSArray* matches = [regex matchesInString:searchedString options:0 range: searchedRange];
            for (NSTextCheckingResult* match in matches) {
                //NSString* matchText = [searchedString substringWithRange:[match range]];
                //NSLog(@"match2: %@", matchText);
                NSRange group2 = [match rangeAtIndex:2];
                //NSLog(@"group1: %@", [searchedString substringWithRange:group1]);
                NSLog(@"group2: %@", [searchedString substringWithRange:group2]);

            }
            
            NSArray *resultArray;
            resultArray = [operation.responseString componentsSeparatedByString:@" "];
            int a = 0;
            for(NSString * str in resultArray){
                //NSLog(@"Array %d: %@",a,[resultArray objectAtIndex:a]);
                a++;
                
            }
            
        }];
    } else {
        //Има символите от
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSDictionary *myRequest = @{@"q":codeOfStop,@"o":@"1",@"sc": textCodeView.text ,@"poleicngi": stringCodeCheck,@"go":@"1"};
        [manager POST:myUrl parameters:myRequest success:^(AFHTTPRequestOperation *operation, id responseObject) {
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            // NSLog(@"Data: %@", operation.responseString);
            self.textForBus.hidden = NO;
            textForBus.text = operation.responseString;
            
            
            NSLog(@"text for parse: %@",operation.responseString);
            
            
            NSData *stopsHtmlData = [operation.responseString dataUsingEncoding:NSUTF8StringEncoding];
            
            TFHpple *stopsParser = [TFHpple hppleWithHTMLData:stopsHtmlData];
            NSString *stopsXpathQueryString = @"//div[starts-with(@class,'arrivals')]//b";
            
            
            NSArray *stopsNodes = [stopsParser searchWithXPathQuery:stopsXpathQueryString];
            for (TFHppleElement *element in stopsNodes) {
                
                Tutorial *transportStop = [[Tutorial alloc] init];
                
                transportStop.title = [[element firstChild] content];
                
                stringForParse = transportStop.title;
                NSLog(@"stringgg: %@",stringForParse);
                //parseStings = [stringForParse componentsSeparatedByString:@"\""];
                
//                NSUInteger a=0;
//                a = [parseStings count];
//                
//                if(a == 9) {
//                    latitude = (NSString*) [parseStings objectAtIndex:5];
//                    longitude = (NSString*) [parseStings objectAtIndex:7];
//                    stopCode = (NSString*) [parseStings objectAtIndex:1];
//                    stopName = (NSString*) [parseStings objectAtIndex:3];
//                    [self makePin];
//                }
                
            }
            
//            NSString *searchedString = operation.responseString;
//            NSRange   searchedRange = NSMakeRange(0, [searchedString length]);
//            NSString *pattern = @"((<b>)(.{1,})(</b>))";
//            //@"(?:www\\.)?((?!-)[a-zA-Z0-9-]{2,63}(?<!-))\\.?((?:[a-zA-Z0-9]{2,})?(?:\\.[a-zA-Z0-9]{2,})?)";
//            NSError  *myError = nil;
//            NSLog(@"humm: %@",searchedString);
//            NSRegularExpression* regex = [NSRegularExpression regularExpressionWithPattern: pattern options:0 error:&myError];
//                NSArray* matches = [regex matchesInString:searchedString options:0 range: searchedRange];
//                for (NSTextCheckingResult* match in matches) {
//                    //NSString* matchText = [searchedString substringWithRange:[match range]];
//                    //NSLog(@"match1: %@", matchText);
//                    //NSRange group1 = [match rangeAtIndex:1];
//                    NSRange group2 = [match rangeAtIndex:1];
//                    //NSLog(@"group1: %@", [searchedString substringWithRange:group1]);
//                    NSLog(@"group2: %@", [searchedString substringWithRange:group2]);
//                    
//                }
            
            NSArray *resultArray;
            resultArray = [operation.responseString componentsSeparatedByString:@" "];
            int a = 0;
            for(NSString * str in resultArray){
                //NSLog(@"Array %d: %@",a,[resultArray objectAtIndex:a]);
                a++;
                
            }
            [textCodeView resignFirstResponder];
            
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
