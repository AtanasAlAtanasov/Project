//
//  LoadViewController.m
//  Sofia Transport
//
//  Created by Atanas Atanasov on 1/12/14.
//  Copyright (c) 2014 Atanas Atanasov. All rights reserved.
//

#import "LoadViewController.h"
#import "ViewController.h"

@implementation LoadViewController
@synthesize loadLabel;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self startScreen];
}

-(void) startScreen {
    [UIView animateWithDuration:2.0 animations:^{
        self.loadLabel.alpha = 1.0;
    } completion:^(BOOL finished) {
        ViewController *startController = [self.storyboard instantiateViewControllerWithIdentifier:@"myViewController"];
        [self.navigationController pushViewController:startController animated:YES];
    }];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
