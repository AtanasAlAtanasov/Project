//
//  FavoriteViewController.h
//  Sofia_Trasport
//
//  Created by Atanas Atanasov on 12/17/13.
//  Copyright (c) 2013 Atanas Atanasov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface FavoriteViewController : UITableViewController

- (IBAction)backButton:(id)sender;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;


@end
