//
//  BusInfoViewController.h
//  Sofia_Trasport
//
//  Created by Atanas Atanasov on 12/13/13.
//  Copyright (c) 2013 Atanas Atanasov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BusInfoViewController : UIViewController {
    NSString *nameOfStop;
    NSString *codeOfStop;
    NSString *stringForParse;
}
- (IBAction)backButton:(id)sender;
@property (strong, nonatomic) IBOutlet UIWebView *codeWebView;

@property (nonatomic) NSString *stringForParse;
@property (nonatomic) NSArray *parseString;
@property (nonatomic,retain) NSString *nameOfStop;
@property (nonatomic,retain) NSString *codeOfStop;
@property (nonatomic) IBOutlet UILabel *lableName;
@property (nonatomic) IBOutlet UILabel *lableCode;


@end
