//
//  MainViewController.m
//  ARO Inspections
//
//  Created by Grant Arrowood on 1/12/17.
//  Copyright © 2017 Piglet Products. All rights reserved.
//

#import "MainViewController.h"
#import "MainTableViewCell.h"
#import "MainPanelTableViewCell.h"


@interface MainViewController ()

@end

@implementation MainViewController

static NSString *const kKeychainItemName = @"Google Sheets API";
static NSString *const kClientID = @"305412303204-e4ac96jc1eofpniu5jhqoplcqdupqslk.apps.googleusercontent.com";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"PikeLogo"]];
    // Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated {
    //sectionTitle = @"";
    _clients = [[NSMutableArray alloc] init];
    _months = [[NSMutableArray alloc] init];
    _inspections = [[NSMutableArray alloc] init];
    
    
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
            for (NSArray *row in rows) {
                //build _inspections and _months
                if (row.count > 5) {
                    if (row.count > 6) {
                        if (row[0] != nil) {
                            if (row[3] != nil) {
                                if (row[4] != nil) {
                                    if (row[5] != nil) {
                                        [_inspections addObject:@{@"ClientName": row[3],@"Location": row[4] ,@"Date": row[5],@"InspectorName": row[6],@"InspectionID": row[0]}];
                                    }
                                }
                            }
                        }
                    } else {
                        if (row[0] != nil) {
                            if (row[3] != nil) {
                                if (row[4] != nil) {
                                    if (row[5] != nil) {
                                        [_inspections addObject:@{@"ClientName": row[3],@"Location": row[4] ,@"Date": row[5],@"InspectorName": @"Unknown",@"InspectionID": row[0]}];
                                    }
                                }
                            }
                        }
                        
                    }
                    
                    NSString *row5 = [NSString stringWithFormat:@"%@",row[5]];
                    NSString *yearMonth;
                    if(row5.length > 6) {
                        yearMonth = [row5 substringToIndex:7];
                        if (![_months containsObject:yearMonth]) {
                            [_months addObject:yearMonth];
                        }
                    }
                    
                }
                
            }
            [_mainTableView reloadData];
        } else {
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
            for (NSArray *row in rows) {
                [_clients addObject:@{@"Name": row[0],@"Visits": row[3]}];
            }
            
            NSLog(@"Hello World");
        } else {
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
    return _months.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_clients count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MainTableViewCell *cell = [self.mainTableView dequeueReusableCellWithIdentifier:@"mainCell" forIndexPath:indexPath];
    cell.clientNameLabel.text = [[_clients objectAtIndex:indexPath.row] valueForKey:@"Name"];
    cell.remainingVisitsLabel.text = [NSString stringWithFormat:@"%d out of %@", [self getVisits:[[_clients objectAtIndex:indexPath.row] valueForKey:@"Name"] inSection:indexPath.section], [[_clients objectAtIndex:indexPath.row] valueForKey:@"Visits"]];
    
    return cell;
}


-(int)getVisits:(NSString *)clientName inSection:(NSInteger)sectionNumber{
    NSString *sectionDate = _months[sectionNumber];
    int visitsInMonth = 0;
    for(int i = 0; i < _inspections.count;i++) {
        if ([[[_inspections objectAtIndex:i] valueForKey:@"ClientName"] isEqualToString:clientName]) {
            NSString *inspectionsDate = [[_inspections objectAtIndex:i] valueForKey:@"Date"];
            NSString *yearMonth;
            if(inspectionsDate.length > 6) {
                yearMonth = [inspectionsDate substringToIndex:7];
            }
            if ([yearMonth isEqualToString:sectionDate]) {
                visitsInMonth++;
            }
        }
    }
    return visitsInMonth;
    
}



- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    //    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    //    // ignore +11 and use timezone name instead of seconds from gmt
    //    [dateFormat setDateFormat:@"YYYY-MM"];
    //    //[dateFormat setTimeZone:[NSTimeZone systemTimeZone]];
    //    NSDate *dte = [dateFormat dateFromString:_months[section]];
    //
    //    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    //    [formatter setDateFormat:@"MMMM, YYYY"];
    //    NSString *result = [formatter stringFromDate:dte];
    //
    return _months[section];
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
