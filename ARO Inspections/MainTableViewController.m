//
//  MainTableViewController.m
//  ARO Inspections
//
//  Created by Grant Arrowood on 12/12/16.
//  Copyright © 2016 Piglet Products. All rights reserved.
//

#import "MainTableViewController.h"
#import "MainTableViewCell.h"

@interface MainTableViewController ()

@end

@implementation MainTableViewController

static NSString *const kKeychainItemName = @"Google Sheets API";
static NSString *const kClientID = @"986274447553-tucq0mb3v3nijbqrphka57590ecompgv.apps.googleusercontent.com";


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"AROLOGO"]];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)viewDidAppear:(BOOL)animated {
    _objects = [[NSMutableArray alloc] init];
    rowcountcheck = 1;
    rowcountvisits = 1;
    if (!self.service.authorizer.canAuthorize) {
        // Not yet authorized, request authorization by pushing the login UI onto the UI stack.
        [self presentViewController:[self createAuthController] animated:YES completion:nil];

        self.service = [[GTLRSheetsService alloc] init];
        self.service.authorizer =
        [GTMOAuth2ViewControllerTouch authForGoogleFromKeychainForName:kKeychainItemName
                                                              clientID:kClientID
                                                          clientSecret:nil];
    } else {
        [self listMajors];
    }
    
}


- (void)listMajors {
    NSString *spreadsheet2Id = @"1CUaJ5V3qxoSoCulGTjyxh6r7hcT3WsM6R0R3fX1vQp8";
    NSString *range2 = @"Clients!A2:D";
    
    GTLRSheetsQuery_SpreadsheetsValuesGet *query2 =
    [GTLRSheetsQuery_SpreadsheetsValuesGet queryWithSpreadsheetId:spreadsheet2Id
                                                            range:range2];
    
    [self.service executeQuery:query2
                      delegate:self
             didFinishSelector:@selector(displayResultsWithTicket:finishedWithObject:error:)];
    
    NSString *spreadsheetId = @"1CUaJ5V3qxoSoCulGTjyxh6r7hcT3WsM6R0R3fX1vQp8";
    NSString *range = @"Inspections!A2:G";
    
    GTLRSheetsQuery_SpreadsheetsValuesGet *query =
    [GTLRSheetsQuery_SpreadsheetsValuesGet queryWithSpreadsheetId:spreadsheetId
                                                            range:range];
    [self.service executeQuery:query
                      delegate:self
             didFinishSelector:@selector(displayResultWithTicket:finishedWithObject:error:)];
}


// Process the response and display output
- (void)displayResultWithTicket:(GTLRServiceTicket *)ticket
             finishedWithObject:(GTLRSheets_ValueRange *)result
                          error:(NSError *)error {
    if (error == nil) {
        NSArray *rows = result.values;
        if (rows.count > 0) {
            //[output appendString:@"Name, Major:\n"];
            for (NSArray *row in rows) {
                // Print columns A and E, which correspond to indices 0 and 4.
                //[output appendFormat:@"%@, %@\n, %@\n", row[0], row[4], row[6]];
                for (int i = 0; i<rowcountcheck; i++) {
                    if (check[i-1][0] == row[3]) {
                        int visitnum = check[i-1][1].intValue - 1;
                        check[i-1][1] = [NSString stringWithFormat:@"%d", visitnum];
                        if (visitnum == 0) {
                            //file[_objects.count] = row[6];
                            [_objects addObject:row[3]];
                            [_mainTableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:_objects.count-1 inSection:0]] withRowAnimation: UITableViewRowAnimationAutomatic];
                        }
                    }
                }
                //[_nameTable insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:_objects.count-1 inSection:0]] withRowAnimation: UITableViewRowAnimationAutomatic];
            }
        } else {
            //[output appendString:@"No data found."];
        }
        
    } else {
        NSMutableString *message = [[NSMutableString alloc] init];
        [message appendFormat:@"Error getting sheet data: %@\n", error.localizedDescription];
        [self showAlert:@"Error" message:message];
    }
}

- (void)displayResultsWithTicket:(GTLRServiceTicket *)ticket
              finishedWithObject:(GTLRSheets_ValueRange *)result
                           error:(NSError *)error {
    if (error == nil) {
        NSArray *rows = result.values;
        if (rows.count > 0) {
            //[output appendString:@"Name, Major:\n"];
            for (NSArray *row in rows) {
                // Print columns A and E, which correspond to indices 0 and 4.
                //[output appendFormat:@"%@, %@\n, %@\n", row[0], row[4], row[6]];
                
                check[rowcountcheck-1][0] = row[0];
                check[rowcountcheck-1][1] = row[3];
                rowcountcheck += 1;
                //[_nameTable insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:_objects.count-1 inSection:0]] withRowAnimation: UITableViewRowAnimationAutomatic];
            }
            //            for (int i = 0; i<rowcount; i++) {
            //                if (check[rowcount-1][0]) {
            //
            //                }
            //            }
        } else {
            //[output appendString:@"No data found."];
        }
        
    } else {
        NSMutableString *message = [[NSMutableString alloc] init];
        [message appendFormat:@"Error getting sheet data: %@\n", error.localizedDescription];
        [self showAlert:@"Error" message:message];
    }
}
- (GTMOAuth2ViewControllerTouch *)createAuthController {
    GTMOAuth2ViewControllerTouch *authController;
    // If modifying these scopes, delete your previously saved credentials by
    // resetting the iOS simulator or uninstall the app.
    NSArray *scopes = [NSArray arrayWithObjects:kGTLRAuthScopeSheetsSpreadsheetsReadonly, nil];
    authController = [[GTMOAuth2ViewControllerTouch alloc]
                      initWithScope:[scopes componentsJoinedByString:@" "]
                      clientID:kClientID
                      clientSecret:nil
                      keychainItemName:kKeychainItemName
                      delegate:self
                      finishedSelector:@selector(viewController:finishedWithAuth:error:)];
    return authController;
}

// Handle completion of the authorization process, and update the Google Sheets API
// with the new credentials.
- (void)viewController:(GTMOAuth2ViewControllerTouch *)viewController
      finishedWithAuth:(GTMOAuth2Authentication *)authResult
                 error:(NSError *)error {
    if (error != nil) {
        [self showAlert:@"Authentication Error" message:error.localizedDescription];
        self.service.authorizer = nil;
    }
    else {
        self.service.authorizer = authResult;
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

// Helper for showing an alert
- (void)showAlert:(NSString *)title message:(NSString *)message {
    UIAlertController *alert =
    [UIAlertController alertControllerWithTitle:title
                                        message:message
                                 preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok =
    [UIAlertAction actionWithTitle:@"OK"
                             style:UIAlertActionStyleDefault
                           handler:^(UIAlertAction * action)
     {
         [alert dismissViewControllerAnimated:YES completion:nil];
     }];
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_objects count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MainTableViewCell *cell = [self.mainTableView dequeueReusableCellWithIdentifier:@"mainCell" forIndexPath:indexPath];
    cell.clientNameLabel.text = _objects[indexPath.row];
    cell.remainingVisitsLabel.text = @"5 Visits Remaining";
    // Configure the cell...
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
