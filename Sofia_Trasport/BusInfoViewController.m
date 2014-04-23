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
    NSString *busId = [NSString stringWithFormat:@"&vehicleTypeId=1"];
    url = [NSString stringWithFormat:@"%@%@%@%@",first,codeOfStop,last,busId];
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
        if ([parseString[2] rangeOfString:@"/captcha"].location != NSNotFound) {
           
            stringForParse=[parseString[2] substringToIndex:41];
            NSString *first = [NSString stringWithFormat:@"http://m.sofiatraffic.bg"];
            myUrl = [NSString stringWithFormat:@"%@%@",first,stringForParse];
            stringCodeCheck = [stringForParse  substringFromIndex:9];
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
        NSLog(@"sec go");
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSDictionary *myRequest = @{@"q":codeOfStop,@"o":@"1",@"go":@"1"};
        [manager POST:myUrl parameters:myRequest success:^(AFHTTPRequestOperation *operation, id responseObject) {
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            if([operation.responseString rangeOfString:@"момента нямаме информация"].location == NSNotFound){
                NSData *stopsHtmlData = [operation.responseString dataUsingEncoding:NSUTF8StringEncoding];
                //NSLog(@"Hpple :%@",operation.responseString);
                
                TFHpple *stopsParser = [TFHpple hppleWithHTMLData:stopsHtmlData];
                
                NSArray * elements  = [stopsParser searchWithXPathQuery:@"//div[@class='arr_info_1']"];
                NSArray * elements1  = [stopsParser searchWithXPathQuery:@"//div[@class='arr_info_1']/a/b"];
                
                NSString *allStr = [NSString stringWithFormat:@""];
                for(int attr = 0;attr<elements.count;attr++){
                    TFHppleElement * element = [elements objectAtIndex:attr];
                    TFHppleElement * element1 = [elements1 objectAtIndex:attr];
                    if([element1 text] != NULL){
                        NSString* delStr = [[element1 text] stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
                        allStr = [NSString stringWithFormat:@"%@%@",allStr,delStr];
                    }
                    NSArray * elementChild = [element children];
                    for(int attr = 0;attr<elementChild.count;attr++){
                        TFHppleElement * elementCh = [elementChild objectAtIndex:attr];
                        if([elementCh content] != NULL){
                            NSString *deleteChar = [elementCh content];
                            deleteChar = [deleteChar stringByReplacingOccurrencesOfString:@" " withString:@""];
                            deleteChar = [deleteChar stringByReplacingOccurrencesOfString:@" - \n" withString:@""];
                            allStr = [NSString stringWithFormat:@"%@%@",allStr,deleteChar];
                        }
                        //                NSLog(@"a :%@",[element tagName]);                     // "a"
                        //                NSLog(@"attr :%@",[element attributes]);               // NSDictionary of href, class, id, etc.
                        //                NSLog(@"href :%@",[element objectForKey:@"href"]);      // Easy access to single attribute
                        //                NSLog(@"b :%@",[element firstChildWithTagName:@"b"]);  // The first "b" child node
                    }
                    allStr = [NSString stringWithFormat:@"%@\n\n",allStr];
                }
                NSLog(@"all :%@",allStr);
                allStr = [NSString stringWithFormat:@"Автобуси\n\n%@",allStr];
                
                textForBus.text = [NSString stringWithFormat:@"%@",allStr];
                
                NSString *stopsXpathQueryString = @"//div[starts-with(class,'arr_title_1')]";
                NSString *infoXpathQueryString = @"//div[contains(string(@class),'arr_info_1')]";
                
                NSArray *stopsNodes = [stopsParser searchWithXPathQuery:stopsXpathQueryString];
                NSArray *infoNodes = [stopsParser searchWithXPathQuery:infoXpathQueryString];
                //NSLog(@"info: %@\n titile: %@",infoNodes,stopsNodes);
                
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
                    NSString *myString = [arrForUser objectAtIndex:a];
                    textForBus.text = [NSString stringWithFormat:@"%@ %@",textForBus.text,myString];
                    a++;
                    
                }

                int b = 0;
                for(NSString * str in arrInfoForUser){
                    //NSLog(@"Array1 %d: %@",b,[arrInfoForUser objectAtIndex:b]);
                    b++;
                    
                }
                [textCodeView resignFirstResponder];
                
            } else {
                textForBus.text = @"В момента нямаме информация. Моля, опитайте по-късно.";
                [textCodeView resignFirstResponder];
            }

        }];
    } else {
        NSLog(@"first go");
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSDictionary *myRequest = @{@"q":codeOfStop,@"o":@"1",@"sc": textCodeView.text ,@"poleicngi": stringCodeCheck,@"go":@"1"};
        [manager POST:myUrl parameters:myRequest success:^(AFHTTPRequestOperation *operation, id responseObject) {
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            self.textForBus.hidden = NO;
            
            if([operation.responseString rangeOfString:@"момента нямаме информация"].location == NSNotFound){
            NSData *stopsHtmlData = [operation.responseString dataUsingEncoding:NSUTF8StringEncoding];

            TFHpple *stopsParser = [TFHpple hppleWithHTMLData:stopsHtmlData];
            
                NSArray * elements  = [stopsParser searchWithXPathQuery:@"//div[@class='arr_info_1']"];
                NSArray * elements1  = [stopsParser searchWithXPathQuery:@"//div[@class='arr_info_1']/a/b"];
                
                NSString *allStr = [NSString stringWithFormat:@""];
                for(int attr = 0;attr<elements.count;attr++){
                TFHppleElement * element = [elements objectAtIndex:attr];
                TFHppleElement * element1 = [elements1 objectAtIndex:attr];
                    if([element1 text] != NULL){
                        NSString* delStr = [[element1 text] stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
                        allStr = [NSString stringWithFormat:@"%@%@",allStr,delStr];
                    }
                NSArray * elementChild = [element children];
                    for(int attr = 0;attr<elementChild.count;attr++){
                        TFHppleElement * elementCh = [elementChild objectAtIndex:attr];
                        if([elementCh content] != NULL){
                            NSString *deleteChar = [elementCh content];
                            deleteChar = [deleteChar stringByReplacingOccurrencesOfString:@" " withString:@""];
                            deleteChar = [deleteChar stringByReplacingOccurrencesOfString:@" - \n" withString:@""];
                            allStr = [NSString stringWithFormat:@"%@%@",allStr,deleteChar];
                        }
//                NSLog(@"a :%@",[element tagName]);                     // "a"
//                NSLog(@"attr :%@",[element attributes]);               // NSDictionary of href, class, id, etc.
//                NSLog(@"href :%@",[element objectForKey:@"href"]);      // Easy access to single attribute
//                NSLog(@"b :%@",[element firstChildWithTagName:@"b"]);  // The first "b" child node
                }
                    allStr = [NSString stringWithFormat:@"%@\n\n",allStr];
                }
                NSLog(@"all :%@",allStr);
                allStr = [NSString stringWithFormat:@"Автобуси\n\n%@",allStr];
                
                textForBus.text = [NSString stringWithFormat:@"%@",allStr];
                
            NSString *stopsXpathQueryString = @"//div[starts-with(class,'arr_title_1')]";
            NSString *infoXpathQueryString = @"//div[contains(string(@class),'arr_info_1')]";

            NSArray *stopsNodes = [stopsParser searchWithXPathQuery:stopsXpathQueryString];
            NSArray *infoNodes = [stopsParser searchWithXPathQuery:infoXpathQueryString];
            //NSLog(@"info: %@\n titile: %@",infoNodes,stopsNodes);
            
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
                NSString *myString = [arrForUser objectAtIndex:a];
                textForBus.text = [NSString stringWithFormat:@"%@ %@",textForBus.text,myString];
                a++;
                
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

-(NSString*) getStringForTFHppleElement:(TFHppleElement *)element {
    
    NSMutableString *result = [NSMutableString new];
    NSLog(@"?? :%@",element);
    // Iterate recursively through all children
    for (TFHppleElement *child in [element children]) {
        [result appendString:[self getStringForTFHppleElement:child]];
        NSLog(@"shit :%@",result);
    }
    
    // Hpple creates a <text> node when it parses texts
    if ([element.tagName isEqualToString:@"text"]){
        [result appendString:element.content];
        NSLog(@"res :%@",result);
    }
    
    return result;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        
        NSManagedObject *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:@"BusData" inManagedObjectContext:self.managedObjectContext];
        
        // If appropriate, configure the new managed object.
        // Normally you should use accessor methods, but using KVC here avoids the need to add a custom class to the template.
        [newManagedObject setValue:self.lableName.text forKey:@"name"];
        [newManagedObject setValue:self.lableCode.text forKey:@"code"];

        // Save the context.
        NSError *error = nil;
        if (![self.managedObjectContext save:&error]) {
           
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
        
    }
}

- (IBAction)favButton:(id)sender {
    NSMutableArray * mutableArr = [[NSMutableArray alloc] init];
    AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
    
    // Fetching Records and saving it in "fetchedRecordsArray" object
    [mutableArr addObjectsFromArray:[appDelegate  getAllBusRecords]];
    int checkEqual=0;
    for (int a=0;a<mutableArr.count;a++){
    BusClass * busData = [mutableArr objectAtIndex:a];
    NSLog(@"arr :%@",busData.name);
        if([busData.name isEqualToString:self.lableName.text]){
            if([busData.code isEqualToString:self.lableCode.text])
            checkEqual = 1;
        }
        
    }
    if(checkEqual == 0){
    NSString *massageStr = [NSString stringWithFormat:@"Добавяне на, %@ към любими",lableName.text];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Добавяне в любими?" message:massageStr delegate:self cancelButtonTitle:@"Не" otherButtonTitles:@"Да",nil];
    [alert show];
    } else if (checkEqual == 1) {
        NSString *massageStr = [NSString stringWithFormat:@"Спирка, %@ вече е в любими",lableName.text];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:massageStr delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    }

    
}

- (IBAction)backButton:(id)sender {
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
}

@end
