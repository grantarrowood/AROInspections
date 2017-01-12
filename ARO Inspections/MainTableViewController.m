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
static NSString *const kClientID = @"305412303204-e4ac96jc1eofpniu5jhqoplcqdupqslk.apps.googleusercontent.com";


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"PikeLogo"]];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)viewDidAppear:(BOOL)animated {
    sectionTitle = @"";
//    _objects = [[NSMutableArray alloc] init];
    _clients = [[NSMutableArray alloc] init];
    _months = [[NSMutableArray alloc] init];
    _inspections = [[NSMutableArray alloc] init];
    
    
    
//    _clientSection = [[NSMutableArray alloc] init];
//    sections = 1;
//    rowcountcheck = 0;
//    first = 0;
//    rowcountvisits = 1;
    if (!self.service.authorizer.canAuthorize) {
        // Not yet authorized, request authorization by pushing the login UI onto the UI stack.
        [self presentViewController:[self createAuthController] animated:YES completion:nil];

        self.service = [[GTLRSheetsService alloc] init];
        self.service.authorizer =
        [GTMOAuth2ViewControllerTouch authForGoogleFromKeychainForName:kKeychainItemName
                                                              clientID:kClientID
                                                          clientSecret:nil];
    } else {
        [self getSections];
    }
    
}



-(void)buildClients {
    
}


- (void)getSections {
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
            int prevYear = 0;
            int prevMonth = 0;
            
            
            
            for (NSArray *row in rows) {
                NSString *thisYear = [row[1] substringToIndex:4];
                if(prevYear < thisYear.intValue) {
                    sections += 1;
//                    int i = 0;
//                    while (i<rowcountcheck) {
//                        if (_clients[i] == row[3]) {
//                            NSMutableArray *client = [[NSMutableArray alloc] initWithObjects:row[3], sections-1, nil];
//                            [_clientSection addObject:client];
//                            //                            clientCount[i][1] += 1;
//                            //                            clientCount[rowcountcheck-1][2] = sections-1;
//                        }
//                        i++;
//                    }
                    sectionTitle = [NSString stringWithFormat:@"%@%@",[row[1] substringToIndex:10], sectionTitle];
                    [self.mainTableView insertSections:[NSIndexSet indexSetWithIndex:sections-1]
                                 withRowAnimation:UITableViewRowAnimationTop];
//                    sectionNum[sections][0] = row[5];
//                    sectionNum[sections][1] = [NSString stringWithFormat:@"%d", sections];
//                    for (int i =0; i<rowcountcheck; i++) {
//                        if ([_clients[i] isEqualToString: row[3]]) {
//                            NSArray *client = [[NSArray alloc] initWithObjects:row[3], [NSNumber numberWithInt:sections-1], nil];
//                            [_clientSection addObject:client];
//                            //                            clientCount[i][1] += 1;
//                            //                            clientCount[rowcountcheck-1][2] = sections-1;
//                        }
//                    }
                    prevYear = thisYear.intValue;
                } else {
                    NSString *thisMonth = [row[1] substringWithRange:NSMakeRange(5, 2)];;
                    if(prevMonth < thisMonth.intValue) {
                        sections += 1;
                        sectionTitle = [NSString stringWithFormat:@"%@%@",[row[1] substringToIndex:10], sectionTitle];
                        [self.mainTableView insertSections:[NSIndexSet indexSetWithIndex:sections-1]
                                          withRowAnimation:UITableViewRowAnimationTop];
//                        sectionNum[sections][0] = row[5];
//                        sectionNum[sections][1] = [NSString stringWithFormat:@"%d", sections];
//                        for (int i =0; i<rowcountcheck; i++) {
//                            if ([_clients[i] isEqualToString: row[3]]) {
//                                NSArray *client = [[NSArray alloc] initWithObjects:row[3], [NSNumber numberWithInt:sections-1], nil];
//                                [_clientSection addObject:client];
//                                //          clientCount[i][1] += 1;
//                                //          clientCount[rowcountcheck-1][2] = sections-1;
//                            }
//                        }
                        prevMonth = thisMonth.intValue;
                    }
                }
            }
            
            
            
            
            
            for (NSArray *row in rows) {
                NSString *thisYear = [row[1] substringToIndex:4];
                if(prevYear < thisYear.intValue) {
                    prevYear = thisYear.intValue;
                    for (int i = 0; i<rowcountcheck; i++) {
                        check[i][1] = @"0";
                    }
                } else {
                    NSString *thisMonth = [row[1] substringWithRange:NSMakeRange(5, 2)];;
                    if(prevMonth < thisMonth.intValue) {
                        for (int i = 0; i<rowcountcheck; i++) {
                            check[i][1] = @"0";
                        }
                        prevMonth = thisMonth.intValue;
                    } else {
                        for (int i = 0; i<rowcountcheck; i++) {
                            if (check[i][0] == row[3]) {
                                int x = check[i][1].intValue;
                                x++;
                                check[i][1] = [NSString stringWithFormat:@"%d", x];
                                [self addToTable];
                            }
                        }
                    }
                }
            }

//            int x = 0;
//            Boolean y = true;
//            int row = 0;
//            for(int i =0; i < _clientSection.count;i++){
//                for (int j = 0; j<rowcountcheck; j++) {
//                    if (_clientSection[i][0] == _clients[j]) {
//                        x +=1;
//                        y = false;
//                        row = j;
//                    } else {
//                        y = true;
//                    }
//                }
//                if (y) {
//                    visitsRemaining = [NSString stringWithFormat:@"%d visits this month", x];
//                    int section = 0;
//                    for (int i =0; i<sections; i++) {
//                        if ([sectionNum[i][0] isEqualToString:_clientSection[1]]) {
//                            section = [sectionNum[i][1] intValue];
//                        }
//                    }
//                    [_mainTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:row inSection:section]] withRowAnimation:UITableViewRowAnimationNone];
//                    x =0;
//                    row = 0;
//                }
//
//            }
            
            
            
//            for (int i =0; i>sections; i++) {
//                for (int j = 0; j<rowcountcheck; j++) {
//                     
//                    visitsRemaining = [NSString stringWithFormat:@"%d visits this month", clientCount[j][1]];
//                    [_mainTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:j inSection:i]] withRowAnimation:UITableViewRowAnimationNone];
//                }
//            }
            
            
            
//            for (NSArray *row in rows) {
//                // Print columns A and E, which correspond to indices 0 and 4.
//                //[output appendFormat:@"%@, %@\n, %@\n", row[0], row[4], row[6]];
//
//                first = 0;
//                for (int i = 0; i<rowcountcheck; i++) {
//                    if ([check[i][0] isEqualToString: row[3]]) {
//                        int visitnum = check[i][1].intValue - 1;
//                        check[i][1] = [NSString stringWithFormat:@"%d", visitnum];
//                        
//                        //                        if (first == 0) {
//                        //                            //file[_objects.count] = row[6];
//                        //                            [_objects addObject:row[3]];
//                        //                            visitsRemaining = [NSString stringWithFormat:@"%d visits remaining", visitnum];
//                        //                            [_mainTableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:_objects.count-1 inSection:0]] withRowAnimation: UITableViewRowAnimationAutomatic];
//                        //                        } else {
//                        //                            visitsRemaining = [NSString stringWithFormat:@"%d visits remaining", visitnum];
//                        //                            [_mainTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:_objects.count-1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
//                        //                        }
//                    }
//                }
                //[_nameTable insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:_objects.count-1 inSection:0]] withRowAnimation: UITableViewRowAnimationAutomatic];
           // }
        } else {
            //[output appendString:@"No data found."];
        }
        
    } else {
        NSMutableString *message = [[NSMutableString alloc] init];
        [message appendFormat:@"Error getting sheet data: %@\n", error.localizedDescription];
        [self showAlert:@"Error" message:message];
    }
}

-(void)addToTable {
    
    
    
    
    
    
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
//                check[rowcountcheck][0] = row[0];
//                clientCount[rowcountcheck][0] = rowcountcheck;
//                rowcountcheck += 1;
                [_clients addObject:@{@"Name": row[0],@"Visits": row[3]}];
//                [_mainTableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:_clients.count-1 inSection:0]] withRowAnimation: UITableViewRowAnimationAutomatic];
            }
            
            NSLog(@"Hello World");
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
    return sections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_clients count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MainTableViewCell *cell = [self.mainTableView dequeueReusableCellWithIdentifier:@"mainCell" forIndexPath:indexPath];
    cell.clientNameLabel.text = _clients[indexPath.row];
    cell.remainingVisitsLabel.text = visitsRemaining;
    first = 1;
    
    return cell;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (sectionTitle.length >section*10) {
        NSString *secTitle = [sectionTitle substringWithRange:NSMakeRange(section*10, 10)];
        
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    // ignore +11 and use timezone name instead of seconds from gmt
    [dateFormat setDateFormat:@"YYYY-MM-dd"];
    [dateFormat setTimeZone:[NSTimeZone systemTimeZone]];
    NSDate *dte = [dateFormat dateFromString:secTitle];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMMM, YYYY"];
    NSString *result = [formatter stringFromDate:dte];
        return result;
        
    }
    return @"";
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
