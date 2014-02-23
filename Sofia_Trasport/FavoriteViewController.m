//
//  FavoriteViewController.m
//  Sofia_Trasport
//
//  Created by Atanas Atanasov on 12/17/13.
//  Copyright (c) 2013 Atanas Atanasov. All rights reserved.
//

#import "FavoriteViewController.h"
#import "AppDelegate.h"
#import "BusClass.h"
#import "BusInfoViewController.h"

@interface FavoriteViewController ()

@property (nonatomic,strong)NSMutableArray* fetchedRecordsArray;

@end

@implementation FavoriteViewController
@synthesize managedObjectContext;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.fetchedRecordsArray = [[NSMutableArray alloc] init];
    
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
    
    // Fetching Records and saving it in "fetchedRecordsArray" object
    [self.fetchedRecordsArray addObjectsFromArray:[appDelegate getAllBusRecords]];
    //self.fetchedRecordsArray = [appDelegate getAllBusRecords];
    [self.tableView reloadData];
 
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return [self.fetchedRecordsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    BusClass * busData = [self.fetchedRecordsArray objectAtIndex:indexPath.row];
    NSLog(@"name :%@",busData.name);
    cell.textLabel.text = [NSString stringWithFormat:@"%@",busData.name];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",busData.code];
    
    return cell;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath*)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
       
                
        //AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
        
        //self.fetchedRecordsArray = [appDelegate getAllBusRecords];
        
        //BusClass *punToDelete = [self.fetchedRecordsArray objectAtIndex:indexPath.row];
//        NSLog(@"Deleting (%@)", punToDelete.name);
        
        //[punToDelete.name delete:indexPath];
        
        //[tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        //[self.fetchedRecordsArray delete:indexPath];
        
        //NSLog(@"all :%@",self.fetchedRecordsArray);
        
        
        //NSManagedObject *managedObject = [self.fetchedRecordsArray objectAtIndex:indexPath.row];
        
        //[self.fetchedRecordsArray delete:indexPath]; // deleteObject:managedObject];
        [self.tableView reloadData];
        
       //[self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {
        
        BusInfoViewController *busView = [self.storyboard instantiateViewControllerWithIdentifier:@"busViewController"];
         BusClass * busData = [self.fetchedRecordsArray objectAtIndex:indexPath.row];
        busView.nameOfStop = busData.name;
        busView.codeOfStop = busData.code;
        [self presentModalViewController:busView animated:YES];

    
    }
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

- (IBAction)backButton:(id)sender {
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
}
@end
