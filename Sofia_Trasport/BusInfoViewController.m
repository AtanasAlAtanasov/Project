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
@synthesize lableName,nameOfStop,lableCode,codeOfStop,stringForParse,parseString,codeWebView,textCodeView,url,stringCodeCheck;

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
        return nil;
    }
    
    //NSLog(@"All Response Header Fields : %@", response.allHeaderFields);
    self.cookieMonster = response.allHeaderFields[@"Set-Cookie"];
    
    stringForParse = [[NSString alloc] initWithData:oResponseData encoding:NSUTF8StringEncoding];
    
    parseString = [stringForParse componentsSeparatedByString:@"src=""\""];
    
    if([stringForParse length]<=2530){
        stringForParse=[parseString[2] substringToIndex:41];
    }
    
    
    
    NSString *first = [NSString stringWithFormat:@"http://m.sofiatraffic.bg"];
    myUrl = [NSString stringWithFormat:@"%@%@",first,stringForParse];
    stringCodeCheck = [stringForParse  substringFromIndex:9];
    first = [NSString stringWithFormat:@"\""];
    
    //NSLog(@"url %@",myUrl);
    //NSLog(@"pic Code %@",stringCodeCheck);
    
    NSURL *urlAdress = [NSURL URLWithString:myUrl];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:urlAdress];
    [codeWebView loadRequest:requestObj];
    
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
    //NSLog(@"url: %@",myUrl);
    [request setURL:[NSURL URLWithString:myUrl]];
    assert(self.cookieMonster.length);
    [request setValue:self.cookieMonster forHTTPHeaderField:@"Set-Cookie"];
    NSLog(@"All Response Header Fields : %@", request.allHTTPHeaderFields);
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
    
    NSLog(@"string: %lu",(unsigned long)[parseString[1] length]);
    
    if([parseString[1] length]<=865){

    stringForParse=[parseString[2] substringWithRange:NSMakeRange(9, 32)];
        
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSDictionary *myRequest = @{@"q":codeOfStop,@"o":@"1",@"sc": textCodeView.text ,@"poleicngi": stringCodeCheck,@"go":@"1"};
        //NSLog(@"my request: %@",myRequest);
        [manager POST:myUrl parameters:myRequest success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"DONE!: %@",responseObject);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Failed to log in: %@", operation.responseString);
            //NSLog(@"Respons: %@", operation.response);
            
            
        }];
    } else if ([parseString[1] length]>=865) {
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSDictionary *myRequest = @{@"q":codeOfStop};
        //NSLog(@"my request: %@",myRequest);
        [manager GET:myUrl parameters:myRequest success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"DONE!: %@",responseObject);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"data: %@",operation.responseString);
        
        }];
    }
    

    //NSLog(@"pic Code Check %@",stringForParse);
    
//    NSString *first = [NSString stringWithFormat:@"value=\""];
//    NSString *sec =[NSString stringWithFormat:@"\"/>"];
//    NSString *all  = [NSString stringWithFormat:@"%@%@%@",first,stringForParse,sec];
//    first = [NSString stringWithFormat:@"value=\""];
//    sec =[NSString stringWithFormat:@"\"/>"];
//    NSString *allSecond  = [NSString stringWithFormat:@"%@%@%@",first,stringCodeCheck,sec];
//    
//    NSString *stringForBody = [[NSString alloc] initWithData:oResponseData encoding:NSUTF8StringEncoding];
//    stringForBody = [stringForBody stringByReplacingOccurrencesOfString:all withString:allSecond];
//    
//    
//    first = [NSString stringWithFormat:@"<input class=\"inp\" id=\"sc\" name=\"sc\" type=\"text\" maxlength=\"10\" value=\""];
//    sec = [NSString stringWithFormat:@"\"/>"];
//    allSecond = [NSString stringWithFormat:@"%@%@%@",first,textCodeView.text,sec];
//    
//    stringForBody = [stringForBody stringByReplacingOccurrencesOfString:@"<input class=\"inp\" id=\"sc\" name=\"sc\" type=\"text\" maxlength=\"10\"/>" withString:allSecond];
//    
//    
//    first = [NSString stringWithFormat:@"<input type=\"text\"  value=\""];
//    sec = [NSString stringWithFormat:@"\"  name=\"q\" maxlength=\"40\" class=\"inp\"/>"];
//     allSecond = [NSString stringWithFormat:@"%@%@%@",first,lableCode.text,sec];
//    stringForBody = [stringForBody stringByReplacingOccurrencesOfString:@"<input type=\"text\"  value=\"\"  name=\"q\" maxlength=\"40\" class=\"inp\"/>"  withString:allSecond];
//    
//    
//    NSMutableData *data = [NSMutableData data];
//    [data appendData:[stringForBody dataUsingEncoding:NSUTF8StringEncoding]];
//    
//    [request setHTTPBody:data];
    
    //NSLog(@"All Response Header Fields : %@", response.allHeaderFields);
    //oResponseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    //NSLog(@"response: %@",[[NSString alloc] initWithData:oResponseData encoding:NSUTF8StringEncoding]);
    //NSLog(@"return: %@",[[NSString alloc] initWithData:request.HTTPBody encoding:NSUTF8StringEncoding]);
    
    //oResponseData = [NSURLConnection sendAsynchronousRequest:request queue:self completionHandler:self];
    
//    NSDictionary *myData = @{@"":stringForBody};
//    NSLog(@"myData: %@",myData);
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    //NSDictionary *parameters = @{@"foo": @"bar"};
//    //NSURL *filePath = [NSURL fileURLWithPath:@"file://path/to/image.png"];
//    
//    [manager POST:myUrl parameters:myData constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
//        //[formData appendPartWithFileURL:filePath name:@"image" error:nil];
//    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"Success: %@", responseObject);
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"Error: %@", operation);
//    }];
    
    
    
    
//    AFHTTPRequestOperation *operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"DONE!: %@",responseObject);
//        [client enqueueHTTPRequestOperation:operation];
//        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"Failed to log in: %@", operation.responseString);
//    }];

    //AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    
    //NSLog(@"shit: %@",[[NSString alloc] initWithData:oResponseData encoding:NSUTF8StringEncoding]);
    
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
