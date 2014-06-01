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
@property (nonatomic, strong) NSString *allStr;
@property (nonatomic) BOOL allVehicle;

@end

@implementation BusInfoViewController
@synthesize lableName,nameOfStop,lableCode,codeOfStop,stringForParse,parseString,codeWebView,textCodeView,url,stringCodeCheck,textForBus,fetchedResultsController,managedObjectContext,managedObjectModel,persistentStoreCoordinator,allStr,allVehicle;

- (void)viewDidLoad
{
    [super viewDidLoad];
    

    allStr = [NSString stringWithFormat:@""];
    allVehicle = NO;
    AppDelegate* appDelegate  = [UIApplication sharedApplication].delegate;

    self.managedObjectContext = appDelegate.managedObjectContext;
    
    lableName.text = nameOfStop;
    lableCode.text = codeOfStop;
    NSString *first = [NSString stringWithFormat:@"http://m.sofiatraffic.bg/vt?stopCode="];
    NSString *last = [NSString stringWithFormat:@"&o=0&go=0"];
    url = [NSString stringWithFormat:@"%@%@%@",first,codeOfStop,last];
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyAlways];
    [self getDataFrom:url];

}

- (NSString *) getDataFrom:(NSString *)myUrl
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    [request setHTTPMethod:@"GET"];
    [request setURL:[NSURL URLWithString:myUrl]];
//    AppDelegate* appDelegate1 = [UIApplication sharedApplication].delegate;
//    if([appDelegate1 getCookies] != NULL){
//        BusClass * busData = [[appDelegate1  getCookies] lastObject];
        //NSLog(@"coookie :%@",busData.captcha);
//        if(busData.captcha != NULL){
//            NSString * allCookies = [NSString stringWithFormat:@"%@; %@",busData.captcha,self.cookieMonster];
//            //[request setValue:allCookies forHTTPHeaderField:@"Cookie"];
//            [request setValue:allCookies forHTTPHeaderField:@"Cookie"];
//            //alpocjengi=
//            NSMutableDictionary *cookieProperties = [NSMutableDictionary dictionary];
//            [cookieProperties setObject:@"alpocjengi" forKey:NSHTTPCookieName];
//            [cookieProperties setObject:busData.captcha forKey:NSHTTPCookieValue];
//            [cookieProperties setObject:@"m.sofiatraffic.bg" forKey:NSHTTPCookieDomain];
//            //[cookieProperties setObject:@"www.example.com" forKey:NSHTTPCookieOriginURL];
//            [cookieProperties setObject:@"/" forKey:NSHTTPCookiePath];
//            //[cookieProperties setObject:@"0" forKey:NSHTTPCookieVersion];
//            
//            //[cookieProperties setObject:[[NSDate date] dateByAddingTimeInterval:2629743] forKey:NSHTTPCookieExpires];
//            
//            NSHTTPCookie *cookie = [NSHTTPCookie cookieWithProperties:cookieProperties];
//            [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
//            
//        }
    
    
//    NSArray * availableCookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:[NSURL URLWithString:myUrl]];
//    NSDictionary * headers = [NSHTTPCookie requestHeaderFieldsWithCookies:availableCookies];
//    //NSLog(@"head :%@, cookie :%@",headers,availableCookies);
//    NSLog(@"single :%@",[headers objectForKey:@"Cookie"]);
//    
//    
//    NSString *vjfmrii;
//    vjfmrii = [headers objectForKey:@"Cookie"];
//    if(vjfmrii.length > 50){
//        vjfmrii = [[headers objectForKey:@"Cookie"] substringFromIndex:53];
//    } else {
//        vjfmrii = [headers objectForKey:@"Cookie"];
//    }
//    NSLog(@"vijj :%@",vjfmrii);
//    NSMutableArray * mutableArrCookie = [[NSMutableArray alloc] init];
//    NSMutableArray * nullArr = [[NSMutableArray alloc] init];
//    AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
//    [mutableArrCookie addObjectsFromArray:[appDelegate  getCookies]];
//    if([headers objectForKey:@"Cookie"]!=NULL){
//        
//        NSLog(@"check");
//        BusClass * newEntry = [NSEntityDescription insertNewObjectForEntityForName:@"CookieMonster"
//                                                                    inManagedObjectContext:self.managedObjectContext];
//        if([mutableArrCookie isEqualToArray:nullArr]){
//            
//            NSString *alpocjengi = [[headers objectForKey:@"Cookie"] substringToIndex:51];
//            newEntry.captcha = alpocjengi;
//            NSLog(@"newwww :%@",newEntry.captcha);
//            NSError *error;
//                
//            if (![self.managedObjectContext save:&error]) {
//                NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
//            }
//        }
//        
//        
//    }
//    BusClass * busData = [[appDelegate  getCookies] lastObject];
//    if(busData.captcha != NULL){
//        NSLog(@"strange :%@, head :%@",busData.captcha,headers);
//        
//        NSMutableDictionary *newHeader = [[NSMutableDictionary alloc]init];
//        NSString * newHeaderString = [NSString stringWithFormat:@"%@; %@",busData.captcha,vjfmrii];
//        [newHeader setObject:newHeaderString forKey:@"Cookie"];
//        
//        [request setAllHTTPHeaderFields:newHeader];
//        NSLog(@"single :%@",newHeader);
//
//    }
    
    //}
    //NSLog(@"ress :%@",request.allHTTPHeaderFields);
    
//    for (NSHTTPCookie *cookie in [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies])
//    {
//        NSLog(@"name: '%@'\n",   [cookie name]);
//        NSLog(@"value: '%@'\n",  [cookie value]);
//        NSLog(@"domain: '%@'\n", [cookie domain]);
//        NSLog(@"path: '%@'\n",   [cookie path]);
//    }

    
    NSError *error = [[NSError alloc] init];
    NSHTTPURLResponse *response = nil;
    NSData *oResponseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
//    for (NSHTTPCookie *cookie in [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies])
//    {
//        NSLog(@"name: '%@'\n",   [cookie name]);
//        NSLog(@"value: '%@'\n",  [cookie value]);
//        NSLog(@"domain: '%@'\n", [cookie domain]);
//        NSLog(@"path: '%@'\n",   [cookie path]);
//    }

    
    if ([response statusCode] != 200) {
        NSLog(@"Error getting %@, HTTP status code %li", myUrl, (long)[response statusCode]);
        textForBus.text = [NSString stringWithFormat:@"Проблем с достъпа до сървъра.\nСъжеляваме за проблема."];
        return nil;
    }
    
    self.cookieMonster = response.allHeaderFields[@"Set-Cookie"];
    
    
    //NSLog(@"boom :%@",response.allHeaderFields);
    stringForParse = [[NSString alloc] initWithData:oResponseData encoding:NSUTF8StringEncoding];
    //NSLog(@"res :%@",stringForParse);

    parseString = [stringForParse componentsSeparatedByString:@"src=""\""];
    
    if ([parseString[1] rangeOfString:@"символите от"].location == NSNotFound) {

        [self postDataFrom:url:3];
        
       
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
        
//    }else {
//        [self postDataFrom:url];
//    }
    
    return [[NSString alloc] initWithData:oResponseData encoding:NSUTF8StringEncoding];
}
-(IBAction)backGroundTouch:(id)sender {
    [textCodeView resignFirstResponder];
}
- (IBAction)checkButton:(id)sender {
    [self postDataFrom:url:3];
    
}

- (NSString *) postDataFrom:(NSString *)myUrl :(int)idVehicle
{
    NSMutableURLRequest *request = [[ NSMutableURLRequest alloc] init];
    
    [request setHTTPMethod:@"POST"];
    [request setURL:[NSURL URLWithString:myUrl]];
    assert(self.cookieMonster.length);
    [request setValue:self.cookieMonster forHTTPHeaderField:@"Set-Cookie"];
//    AppDelegate* appDelegate1 = [UIApplication sharedApplication].delegate;
//    if([appDelegate1 getCookies] != NULL){
//        BusClass * busData = [[appDelegate1  getCookies] lastObject];
//        //NSLog(@"coookie :%@",busData.captcha);
//        if(busData.captcha != NULL){
//            NSString * allCookies = [NSString stringWithFormat:@"%@; %@",busData.captcha,self.cookieMonster];
//            //[request setValue:allCookies forHTTPHeaderField:@"Cookie"];
//            [request setValue:allCookies forHTTPHeaderField:@"Cookie"];
//            //alpocjengi=
//            NSMutableDictionary *cookieProperties = [NSMutableDictionary dictionary];
//            [cookieProperties setObject:@"alpocjengi" forKey:NSHTTPCookieName];
//            [cookieProperties setObject:busData.captcha forKey:NSHTTPCookieValue];
//            [cookieProperties setObject:@"m.sofiatraffic.bg" forKey:NSHTTPCookieDomain];
//            //[cookieProperties setObject:@"www.example.com" forKey:NSHTTPCookieOriginURL];
//            [cookieProperties setObject:@"/" forKey:NSHTTPCookiePath];
//            //[cookieProperties setObject:@"0" forKey:NSHTTPCookieVersion];
//            
//            //[cookieProperties setObject:[[NSDate date] dateByAddingTimeInterval:2629743] forKey:NSHTTPCookieExpires];
//            
//            NSHTTPCookie *cookie = [NSHTTPCookie cookieWithProperties:cookieProperties];
//            [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
//            
//        }
//    }
    //NSLog(@"logs :%@",request.allHTTPHeaderFields);
    NSError *error = [[NSError alloc] init];
    NSHTTPURLResponse *response = nil;

    
    NSData *oResponseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if([response statusCode] != 200){
        NSLog(@"Error getting %@, HTTP status code %li", myUrl, (long)[response statusCode]);
        return nil;
    }
    self.cookieMonster = response.allHeaderFields[@"Set-Cookie"];
    
    //NSLog(@"ress :%@",response.allHeaderFields);
    stringForParse = [[NSString alloc] initWithData:oResponseData encoding:NSUTF8StringEncoding];
    
    
    parseString = [stringForParse componentsSeparatedByString:@"src=""\""];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    if ([parseString[1] rangeOfString:@"символите от"].location == NSNotFound) {
        NSLog(@"sec go");
        
        NSDictionary *myRequest = @{@"o":@"1",@"go":@"1",@"stopCode":codeOfStop/*,@"vehicleTypeId":@"1"*/,@"sec":@"5"};
        
        if(idVehicle == 0){
            myRequest = @{@"o":@"1",@"go":@"1",@"stopCode":codeOfStop,@"vehicleTypeId":@"0",@"sec":@"5"};
        } else if (idVehicle == 1){
            myRequest = @{@"o":@"1",@"go":@"1",@"stopCode":codeOfStop,@"vehicleTypeId":@"1",@"sec":@"5"};
        } else if (idVehicle == 2){
            myRequest = @{@"o":@"1",@"go":@"1",@"stopCode":codeOfStop,@"vehicleTypeId":@"2",@"sec":@"5"};
        }
        
        [manager POST:myUrl parameters:myRequest success:^(AFHTTPRequestOperation *operation, id responseObject) {
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            if([operation.responseString rangeOfString:@"момента нямаме информация"].location == NSNotFound){
                NSData *stopsHtmlData = [operation.responseString dataUsingEncoding:NSUTF8StringEncoding];
                //NSLog(@"Hpple :%@",operation.responseString);
                
                
                TFHpple *stopsParser = [TFHpple hppleWithHTMLData:stopsHtmlData];
                
                
                [self takeInfo:operation.responseString :stopsParser];
                
                
            } else {
                textForBus.text = @"В момента нямаме информация. Моля, опитайте по-късно.";
                [textCodeView resignFirstResponder];
            }

        }];
    } else {
        NSLog(@"first go");
        NSDictionary *myRequest;
        if(stringCodeCheck != NULL){
         myRequest = @{@"stopCode":codeOfStop,@"o":@"1",@"sec":@"5",@"sc": textCodeView.text ,@"poleicngi": stringCodeCheck,@"go":@"1"/*,@"vehicleTypeId":@"1"*/};
        
        
        if(idVehicle == 0){
            myRequest = @{@"stopCode":codeOfStop,@"o":@"1",@"sec":@"5",@"sc": textCodeView.text ,@"poleicngi": stringCodeCheck,@"go":@"1",@"vehicleTypeId":@"0"};
        } else if (idVehicle == 1){
            myRequest = @{@"stopCode":codeOfStop,@"o":@"1",@"sec":@"5",@"sc": textCodeView.text ,@"poleicngi": stringCodeCheck,@"go":@"1",@"vehicleTypeId":@"1"};
        } else if (idVehicle == 2){
            myRequest = @{@"stopCode":codeOfStop,@"o":@"1",@"sec":@"5",@"sc": textCodeView.text ,@"poleicngi": stringCodeCheck,@"go":@"1",@"vehicleTypeId":@"2"};
        }
        } else {
             myRequest = @{@"stopCode":codeOfStop,@"o":@"1",@"sec":@"5",@"sc": textCodeView.text,@"go":@"1"};
            if(idVehicle == 0){
                myRequest = @{@"stopCode":codeOfStop,@"o":@"1",@"sec":@"5",@"sc": textCodeView.text ,@"go":@"1",@"vehicleTypeId":@"0"};
            } else if (idVehicle == 1){
                myRequest = @{@"stopCode":codeOfStop,@"o":@"1",@"sec":@"5",@"sc": textCodeView.text ,@"go":@"1",@"vehicleTypeId":@"1"};
            } else if (idVehicle == 2){
                myRequest = @{@"stopCode":codeOfStop,@"o":@"1",@"sec":@"5",@"sc": textCodeView.text ,@"go":@"1",@"vehicleTypeId":@"2"};
            }

        }
        [manager POST:myUrl parameters:myRequest success:^(AFHTTPRequestOperation *operation, id responseObject) {
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            self.textForBus.hidden = NO;
            
            if([operation.responseString rangeOfString:@"момента нямаме информация"].location == NSNotFound){
            NSData *stopsHtmlData = [operation.responseString dataUsingEncoding:NSUTF8StringEncoding];
                //NSLog(@"Hpple :%@",operation.responseString);
                
                TFHpple *stopsParser = [TFHpple hppleWithHTMLData:stopsHtmlData];
                
                [self takeInfo:operation.responseString :stopsParser];
                
            
            }
            else {
                textForBus.text = @"В момента нямаме информация. Моля, опитайте по-късно.";
                [textCodeView resignFirstResponder];
            }
        }];
    }
    
    
    

    return [[NSString alloc] initWithData:request.HTTPBody encoding:NSUTF8StringEncoding];
    
}
-(void)takeInfo:(NSString *)arr_info :(TFHpple *)stopsParser{
    NSString *arrInfoString;
    NSString *nameString;
    
    
    if ([arr_info rangeOfString:@"/captcha"].location != NSNotFound) {
        self.textForBus.hidden=YES;
        [self getDataFrom:url];
    }
    
    if ([arr_info rangeOfString:@"arr_info_0"].location == NSNotFound) {
        if ([arr_info rangeOfString:@"arr_info_1"].location == NSNotFound) {
            if ([arr_info rangeOfString:@"arr_info_2"].location == NSNotFound) {
                arrInfoString = [NSString stringWithFormat:@""];
            } else {
                arrInfoString = [NSString stringWithFormat:@"arr_info_2"];
                nameString = [NSString stringWithFormat:@"Тролеи"];
                if(allVehicle == NO){
                    allVehicle = YES;
                    //allStr = [NSString stringWithFormat:@"%@\n\n%@",nameString,allStr];

                    if ([arr_info rangeOfString:@"Автобуси"].location != NSNotFound) {
                        //[self postDataFrom:url:0];
                        [self postDataFrom:url:1];
                    }
                    if ([arr_info rangeOfString:@"Трамваи"].location != NSNotFound) {
                        [self postDataFrom:url:0];
                        //[self postDataFrom:url:1];
                    }
                }
            }
        } else {
            arrInfoString = [NSString stringWithFormat:@"arr_info_1"];
            nameString = [NSString stringWithFormat:@"Автобуси"];
            if(allVehicle == NO){
                allVehicle = YES;
                //allStr = [NSString stringWithFormat:@"%@\n\n%@",nameString,allStr];

                if ([arr_info rangeOfString:@"Тролеи"].location != NSNotFound) {
                    //[self postDataFrom:url:0];
                    [self postDataFrom:url:2];
                }
                if ([arr_info rangeOfString:@"Трамваи"].location != NSNotFound) {
                    [self postDataFrom:url:0];
                    //[self postDataFrom:url:1];
                }
                
                
            }

        }
    } else {
        arrInfoString = [NSString stringWithFormat:@"arr_info_0"];
        nameString = [NSString stringWithFormat:@"Трамваи"];
        if(allVehicle == NO){
            allVehicle = YES;
            //allStr = [NSString stringWithFormat:@"%@\n\n%@",nameString,allStr];

            if ([arr_info rangeOfString:@"Автобуси"].location != NSNotFound) {
                //[self postDataFrom:url:0];
                [self postDataFrom:url:1];
            }
            if ([arr_info rangeOfString:@"Тролеи"].location != NSNotFound) {
                [self postDataFrom:url:2];
                //[self postDataFrom:url:1];
            }
            
            
        }

    }
    allStr = [NSString stringWithFormat:@"%@\n%@\n\n",allStr,nameString];

    if(nameString == NULL){
        nameString = [NSString stringWithFormat:@"В момента няма информация"];
    }
    
    NSString * query = [NSString stringWithFormat:@"//div[@class='%@']",arrInfoString];
    NSString * query1 = [NSString stringWithFormat:@"//div[@class='%@']/a/b",arrInfoString];

    NSArray * elements  = [stopsParser searchWithXPathQuery:query];
    NSArray * elements1  = [stopsParser searchWithXPathQuery:query1];
    
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
    if ([allStr rangeOfString:@"(null)"].location != NSNotFound) {
        textForBus.text = [NSString stringWithFormat:@"В момента нямаме информация."];
    } else {
        textForBus.text = [NSString stringWithFormat:@"%@",allStr];
    }
    
    [self.textForBus setTextAlignment:NSTextAlignmentCenter];

    NSMutableAttributedString * string = [[NSMutableAttributedString alloc]initWithString:self.textForBus.text];
    
    NSArray *words=[self.textForBus.text componentsSeparatedByString:@"\n"];
    
    int colorChange;
    for (NSString *word in words) {
        //NSLog(@"word :%@",word);
        if ([word hasPrefix:@"Авто"]) {
            NSRange range=[self.textForBus.text rangeOfString:word];
            [string addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Arial" size:25] range:range];
            [string addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:range];
            colorChange = 0;
        } else if ([word hasPrefix:@"Троле"]) {
            NSRange range=[self.textForBus.text rangeOfString:word];
            [string addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Arial" size:25] range:range];
            [string addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:range];
            colorChange = 1;
        } else if ([word hasPrefix:@"Трам"]) {
            NSRange range=[self.textForBus.text rangeOfString:word];
            [string addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Arial" size:25] range:range];
            [string addAttribute:NSForegroundColorAttributeName value:[UIColor purpleColor] range:range];
            colorChange = 2;
        } else if (colorChange == 0) {
            NSRange range=[self.textForBus.text rangeOfString:word];
            [string addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Arial" size:18] range:range];
            [string addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:range];
        } else if (colorChange == 1) {
            NSRange range=[self.textForBus.text rangeOfString:word];
            [string addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Arial" size:18] range:range];
            [string addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:range];
        } else if (colorChange == 2) {
            NSRange range=[self.textForBus.text rangeOfString:word];
            [string addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Arial" size:18] range:range];
            [string addAttribute:NSForegroundColorAttributeName value:[UIColor purpleColor] range:range];
        }
    }
    [self.textForBus setAttributedText:string];
    
    [textCodeView resignFirstResponder];
    
}

//
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        
        NSManagedObject *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:@"BusData" inManagedObjectContext:self.managedObjectContext];
        
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
    //NSLog(@"arr :%@",busData.name);
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
