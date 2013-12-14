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
}
- (IBAction)backButton:(id)sender;

@property (nonatomic,retain) NSString *nameOfStop;
@property (weak, nonatomic) IBOutlet UITextView *lableName;


@end
