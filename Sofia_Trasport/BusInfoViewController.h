//
//  BusInfoViewController.h
//  Sofia_Trasport
//
//  Created by Atanas Atanasov on 12/13/13.
//  Copyright (c) 2013 Atanas Atanasov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface BusInfoViewController : UIViewController <NSFetchedResultsControllerDelegate> {
    NSString *nameOfStop;
    NSString *codeOfStop;
    NSString *stringForParse;
}

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;


- (IBAction)backButton:(id)sender;
@property (strong, nonatomic) IBOutlet UIWebView *codeWebView;
@property (strong, nonatomic) IBOutlet UITextField *textCodeView;
@property (strong, nonatomic) IBOutlet UITextView *textForBus;
-(IBAction)checkButton:(id)sender;
-(IBAction)backGroundTouch:(id)sender;
-(IBAction)favButton:(id)sender;

@property (nonatomic) NSString *url;
@property (nonatomic) NSString *stringForParse;
@property (nonatomic) NSString *stringCodeCheck;
@property (nonatomic) NSArray *parseString;
@property (nonatomic,retain) NSString *nameOfStop;
@property (nonatomic,retain) NSString *codeOfStop;
@property (nonatomic) IBOutlet UILabel *lableName;
@property (nonatomic) IBOutlet UILabel *lableCode;


@end
