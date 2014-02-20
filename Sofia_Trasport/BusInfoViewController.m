//
//  BusInfoViewController.m
//  Sofia_Trasport
//
//  Created by Atanas Atanasov on 12/13/13.
//  Copyright (c) 2013 Atanas Atanasov. All rights reserved.
//

#import "BusInfoViewController.h"
#import "BusClass.h"
#import "ViewController.h"
#import "PinClass.h"
#import "AppDelegate.h"

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
@synthesize lableName,nameOfStop,lableCode,codeOfStop,stringForParse,parseString,codeWebView,textCodeView,url,stringCodeCheck,textForBus,fetchedResultsController,managedObjectContext,managedObjectModel,persistentStoreCoordinator;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    AppDelegate* appDelegate  = [UIApplication sharedApplication].delegate;
    self.managedObjectContext = appDelegate.managedObjectContext;
    
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
            //textForBus.text = operation.responseString;
            //NSLog(@"text for parse: %@",operation.responseString);
            if([operation.responseString rangeOfString:@"момента нямаме информация"].location == NSNotFound){
            NSData *stopsHtmlData = [operation.responseString dataUsingEncoding:NSUTF8StringEncoding];
            
            TFHpple *stopsParser = [TFHpple hppleWithHTMLData:stopsHtmlData];
            NSString *stopsXpathQueryString = @"//div[starts-with(@class,'arrivals')]//b";
            
            
            NSArray *stopsNodes = [stopsParser searchWithXPathQuery:stopsXpathQueryString];
            NSMutableArray *arrForUser = nil;
            arrForUser = [[NSMutableArray alloc] init];
            for (TFHppleElement *element in stopsNodes) {
                
                Tutorial *transportStop = [[Tutorial alloc] init];
                
                transportStop.title = [[element firstChild] content];
                
                stringForParse = transportStop.title;
                
                [arrForUser addObject:stringForParse];
                
            }

            int a = 0;
            for(NSString * str in arrForUser){
                NSLog(@"Array %d: %@",a,[arrForUser objectAtIndex:a]);
                NSString *myString = [arrForUser objectAtIndex:a];
                textForBus.text = [NSString stringWithFormat:@"%@ %@",textForBus.text,myString];
                a++;
                
            }
            [textCodeView resignFirstResponder];
            }
            else {
                textForBus.text = @"В момента нямаме информация. Моля, опитайте по-късно.";
                [textCodeView resignFirstResponder];

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
            //textForBus.text = operation.responseString;
            
            
            //NSLog(@"text for parse: %@",operation.responseString);
            
            if([operation.responseString rangeOfString:@"момента нямаме информация"].location == NSNotFound){
            NSData *stopsHtmlData = [operation.responseString dataUsingEncoding:NSUTF8StringEncoding];
            
            TFHpple *stopsParser = [TFHpple hppleWithHTMLData:stopsHtmlData];
            NSString *stopsXpathQueryString = @"//div[starts-with(@class,'arrivals')]//b";
            NSString *infoXpathQueryString = @"//div[starts-with(@class,'arr_info_1')]";

            NSArray *stopsNodes = [stopsParser searchWithXPathQuery:stopsXpathQueryString];
            NSArray *infoNodes = [stopsParser searchWithXPathQuery:infoXpathQueryString];
            //NSLog(@"huuuuum: %@",infoNodes);
            NSMutableArray *arrForUser = nil;
            arrForUser = [[NSMutableArray alloc] init];
            NSMutableArray *arrInfoForUser = nil;
            arrInfoForUser = [[NSMutableArray alloc] init];
            for (TFHppleElement *element in stopsNodes) {
                
                Tutorial *transportStop = [[Tutorial alloc] init];
                
                transportStop.title = [[element firstChild] content];
                
                stringForParse = transportStop.title;
                
                [arrForUser addObject:stringForParse];
                
            }
            for (TFHppleElement *element in infoNodes) {
                
                Tutorial *transportStop = [[Tutorial alloc] init];
                
                transportStop.title = [[element firstChild] content];
                
                stringForParse = transportStop.title;
                
                [arrInfoForUser addObject:stringForParse];
                
            }
            int a = 0;
            for(NSString * str in arrForUser){
                NSLog(@"Array %d: %@",a,[arrForUser objectAtIndex:a]);
                //NSLog(@"Array %d: %@",a,[arrInfoForUser objectAtIndex:a]);
                NSString *myString = [arrForUser objectAtIndex:a];
                textForBus.text = [NSString stringWithFormat:@"%@ %@",textForBus.text,myString];
                a++;
                
            }
            int b = 0;
            for(NSString * str in arrInfoForUser){
                NSLog(@"Array1 %d: %@",b,[arrInfoForUser objectAtIndex:b]);
                b++;
                
            }
            [textCodeView resignFirstResponder];
         
            } else {
                textForBus.text = @"В момента нямаме информация. Моля, опитайте по-късно.";
                [textCodeView resignFirstResponder];
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

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        BusClass * newEntry = [NSEntityDescription insertNewObjectForEntityForName:@"BusData"
                                                            inManagedObjectContext:self.managedObjectContext];
        newEntry.name = self.lableName.text;
        newEntry.code = self.lableCode.text;
        
        NSError *error;
        if (![self.managedObjectContext save:&error]) {
            NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
        }
        
        [self.view endEditing:YES];
    }
}

- (IBAction)favButton:(id)sender {
    
    NSString *massageStr = [NSString stringWithFormat:@"Do you really want to add %@",lableName.text];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Add Bus Stop?" message:massageStr delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes",nil];
    [alert show];

    
}

- (IBAction)backButton:(id)sender {
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
}

@end
