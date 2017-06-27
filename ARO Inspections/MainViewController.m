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
#import <QuartzCore/QuartzCore.h>


@interface MainViewController ()

@end

@implementation MainViewController

static NSString *const kKeychainItemName = @"Google Sheets API";
//static NSString *const kClientID = @"986274447553-tucq0mb3v3nijbqrphka57590ecompgv.apps.googleusercontent.com";
static NSString *const kClientID = @"305412303204-e4ac96jc1eofpniu5jhqoplcqdupqslk.apps.googleusercontent.com";



- (void)viewDidLoad {
    [super viewDidLoad];
    // Configure Google Sign-in.
    GIDSignIn* signIn = [GIDSignIn sharedInstance];
    signIn.delegate = self;
    signIn.uiDelegate = self;
    signIn.scopes = [NSArray arrayWithObjects:kGTLRAuthScopeSheetsSpreadsheets, nil];
    // Add the sign-in button.
    self.signInButton = [[GIDSignInButton alloc] init];
    [self.view addSubview:self.signInButton];
    // Initialize the service object.
    self.service = [[GTLRSheetsService alloc] init];
    [DBClientsManager authorizeFromController:[UIApplication sharedApplication]
                                   controller:self
                                      openURL:^(NSURL *url) {
                                          [[UIApplication sharedApplication] openURL:url];
                                      }];
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"PikeLogo"]];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"settings-icon"] style:UIBarButtonItemStylePlain target:self action:@selector(openSettingsView:)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"+" style:UIBarButtonItemStylePlain target:self action:@selector(openAddView:)];
    _settingsView.layer.cornerRadius = 5;
    _addInspectionView.layer.cornerRadius = 5;
    // Do any additional setup after loading the view.
    namePicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 200, 320, 200)];
    namePicker.dataSource = self;
    namePicker.delegate = self;
    datePicker = [[UIDatePicker alloc] init];
    datePicker.datePickerMode = UIDatePickerModeDate;
    [self.addInspectionDateTextField setInputView:datePicker];
    [self.addClientsNameTextField setInputView:namePicker];
    UIToolbar *toolBar=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    [toolBar setTintColor:[UIColor grayColor]];
    UIBarButtonItem *doneBtn=[[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(ShowSelectedDate)];
    UIBarButtonItem *space=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [toolBar setItems:[NSArray arrayWithObjects:space,doneBtn, nil]];
    [self.addInspectionDateTextField setInputAccessoryView:toolBar];
    [self.addClientsNameTextField setInputAccessoryView:toolBar];
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [self.mainTableView addSubview:self.refreshControl];
    
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    _clients = [[NSMutableArray alloc] init];
    _months = [[NSMutableArray alloc] init];
    _inspections = [[NSMutableArray alloc] init];
    _panelInspections = [[NSMutableArray alloc] init];
    
}
- (void)signIn:(GIDSignIn *)signIn
didSignInForUser:(GIDGoogleUser *)user
     withError:(NSError *)error {
    if (error != nil) {
        [self showAlert:@"Authentication Error" message:error.localizedDescription];
        self.service.authorizer = nil;
    } else {
        self.signInButton.hidden = true;
        self.service.authorizer = user.authentication.fetcherAuthorizer;
        [self getSections];
    }
}

- (void)getSections {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *spreadsheetId = [defaults valueForKey:@"SpreadsheetID"];

    NSString *range2 = @"Clients!A2:D";
    
    GTLRSheetsQuery_SpreadsheetsValuesGet *query2 =
    [GTLRSheetsQuery_SpreadsheetsValuesGet queryWithSpreadsheetId:spreadsheetId
                                                            range:range2];
    [self.service executeQuery:query2
                      delegate:self
             didFinishSelector:@selector(displayResultsWithTicket:finishedWithObject:error:)];
    
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
        NSLog(@"WORKING!!!!!!!!!!!");
        NSArray *rows = result.values;
        if (rows.count > 0) {
            NSMutableArray *reveredMonths = [[NSMutableArray alloc] init];
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
                        if (![reveredMonths containsObject:yearMonth]) {
                            [reveredMonths addObject:yearMonth];
                        }
                    }
                    
                }
                
            }
            _months = [[reveredMonths reverseObjectEnumerator] allObjects];
            [_mainTableView reloadData];
        } else {
        }
        NSLog(@"%lu", (unsigned long)_inspections.count);
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
                if(row.count < 4) {
                    
                } else {
                    [_clients addObject:@{@"Name": row[0],@"Visits": row[3]}];
                }
            }
        } else {
        }
        NSLog(@"%lu", (unsigned long)_clients.count);
    } else {
        NSMutableString *message = [[NSMutableString alloc] init];
        [message appendFormat:@"Error getting sheet data: %@\n", error.localizedDescription];
        [self showAlert:@"Error" message:message];
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
    if (tableView == self.mainTableView) {
        return _months.count;
    }
    if (tableView == self.panelTableView) {
        return 1;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.mainTableView) {
        return _clients.count;
    }
    if (tableView == self.panelTableView) {
        return _panelInspections.count;
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == self.mainTableView) {
        MainTableViewCell *cell = [self.mainTableView dequeueReusableCellWithIdentifier:@"mainCell" forIndexPath:indexPath];
        cell.clientNameLabel.text = [[_clients objectAtIndex:indexPath.row] valueForKey:@"Name"];
        cell.remainingVisitsLabel.text = [NSString stringWithFormat:@"%d out of %@", [self getVisits:[[_clients objectAtIndex:indexPath.row] valueForKey:@"Name"] inSection:indexPath.section], [[_clients objectAtIndex:indexPath.row] valueForKey:@"Visits"]];
        NSLog(@"%ld", (long)indexPath.row);
        return cell;
    }
    if (tableView == self.panelTableView) {
        MainPanelTableViewCell *cell = [self.panelTableView dequeueReusableCellWithIdentifier:@"panelCell" forIndexPath:indexPath];
        cell.jobLocationLabel.text = [[_panelInspections objectAtIndex:indexPath.row] valueForKey:@"Location"];
        cell.dateLabel.text = [[_panelInspections objectAtIndex:indexPath.row] valueForKey:@"Date"];
        cell.inspectorsNameLabel.text = [[_panelInspections objectAtIndex:indexPath.row] valueForKey:@"InspectorName"];
        return cell;
    }
    return UITableViewCellStyleDefault;

    
    
}

- (void)refresh:(id)sender{
    
    // -- DO SOMETHING AWESOME (... or just wait 3 seconds) --
    // This is where you'll make requests to an API, reload data, or process information
    _clients = [[NSMutableArray alloc] init];
    _months = [[NSMutableArray alloc] init];
    _inspections = [[NSMutableArray alloc] init];
    _panelInspections = [[NSMutableArray alloc] init];
    [self getSections];
    [_mainTableView reloadData];
    double delayInSeconds = 3.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        // When done requesting/reloading/processing invoke endRefreshing, to close the control
        [self.refreshControl endRefreshing];
    });
    // -- FINISHED SOMETHING AWESOME, WOO! --
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
    if (tableView == _mainTableView) {
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        // ignore +11 and use timezone name instead of seconds from gmt
        [dateFormat setDateFormat:@"yyyy-MM"];
        //[dateFormat setTimeZone:[NSTimeZone systemTimeZone]];
        NSDate *dte = [dateFormat dateFromString:_months[section]];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MMMM, YYYY"];
        NSString *result = [formatter stringFromDate:dte];

        return result;
    }
    return @"";

}




-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if(tableView == self.mainTableView) {
        NSString *sectionDate = _months[indexPath.section];
        for(int i = 0; i < _inspections.count;i++) {
            if ([[[_inspections objectAtIndex:i] valueForKey:@"ClientName"] isEqualToString:[[_clients objectAtIndex:indexPath.row] valueForKey:@"Name"]]) {
                NSString *inspectionsDate = [[_inspections objectAtIndex:i] valueForKey:@"Date"];
                NSString *yearMonth;
                if(inspectionsDate.length > 6) {
                    yearMonth = [inspectionsDate substringToIndex:7];
                }
                if ([yearMonth isEqualToString:sectionDate]) {
                    [_panelInspections addObject:@{@"Location": [[_inspections objectAtIndex:i] valueForKey:@"Location"], @"Date": [[_inspections objectAtIndex:i] valueForKey:@"Date"], @"InspectorName": [[_inspections objectAtIndex:i] valueForKey:@"InspectorName"], @"InspectionID": [[_inspections objectAtIndex:i] valueForKey:@"InspectionID"]}];
                }
            }
        }
        [_panelTableView reloadData];
        self.panelCloseView.hidden = NO;
        self.panelTableView.clipsToBounds = NO;
        self.panelTableView.layer.masksToBounds = NO;
        [self.panelTableView.layer setShadowColor:[[UIColor grayColor] CGColor]];
        [self.panelTableView.layer setShadowOffset:CGSizeMake(0, 0)];
        [self.panelTableView.layer setShadowRadius:5.0];
        [self.panelTableView.layer setShadowOpacity:1];
        [UIView animateWithDuration:1.0
                         animations:^{
                             if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
                             {
                                 self.panelTableView.transform = CGAffineTransformMakeTranslation(-370, 0);
                                 self.panelCloseView.transform = CGAffineTransformMakeTranslation(-370, 0);
                             } else {
                                 self.panelTableView.transform = CGAffineTransformMakeTranslation(-265, 0);
                                 self.panelCloseView.transform = CGAffineTransformMakeTranslation(-265, 0);
                             }
                         }];
    }
    
    
    
    if (tableView == self.panelTableView) {
        _popoverCloseView.hidden = NO;
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            // animate it to the identity transform (100% scale)
            _popoverCloseView.backgroundColor = [UIColor grayColor];
            _popoverCloseView.alpha = .4;
        } completion:^(BOOL finished){
            // if you want to do something once the animation finishes, put it here
        }];
        DBUserClient *client = [DBClientsManager authorizedClient];
        NSString *searchPath = @"/Apps/ProntoForms/ClientSafetyInspectionsProntoForms";
        [[client.filesRoutes listFolder:searchPath]
         setResponseBlock:^(DBFILESListFolderResult *result, DBFILESListFolderError *routeError, DBRequestError *error) {
             if (result) {
                 [self displayPhotos:result.entries atIndex:indexPath.row];
             } else {
                 NSString *title = @"";
                 NSString *message = @"";
                 if (routeError) {
                     // Route-specific request error
                     title = @"Route-specific error";
                     if ([routeError isPath]) {
                         message = [NSString stringWithFormat:@"Invalid path: %@", routeError.path];
                     }
                 } else {
                     // Generic request error
                     title = @"Generic request error";
                     if ([error isInternalServerError]) {
                         DBRequestInternalServerError *internalServerError = [error asInternalServerError];
                         message = [NSString stringWithFormat:@"%@", internalServerError];
                     } else if ([error isBadInputError]) {
                         DBRequestBadInputError *badInputError = [error asBadInputError];
                         message = [NSString stringWithFormat:@"%@", badInputError];
                     } else if ([error isAuthError]) {
                         DBRequestAuthError *authError = [error asAuthError];
                         message = [NSString stringWithFormat:@"%@", authError];
                     } else if ([error isRateLimitError]) {
                         DBRequestRateLimitError *rateLimitError = [error asRateLimitError];
                         message = [NSString stringWithFormat:@"%@", rateLimitError];
                     } else if ([error isHttpError]) {
                         DBRequestHttpError *genericHttpError = [error asHttpError];
                         message = [NSString stringWithFormat:@"%@", genericHttpError];
                     } else if ([error isClientError]) {
                         DBRequestClientError *genericLocalError = [error asClientError];
                         message = [NSString stringWithFormat:@"%@", genericLocalError];
                     }
                 }
                 
                 UIAlertController *alertController =
                 [UIAlertController alertControllerWithTitle:title
                                                     message:message
                                              preferredStyle:(UIAlertControllerStyle)UIAlertControllerStyleAlert];
                 [alertController addAction:[UIAlertAction actionWithTitle:@"OK"
                                                                     style:(UIAlertActionStyle)UIAlertActionStyleCancel
                                                                   handler:nil]];
                 [self presentViewController:alertController animated:YES completion:nil];
             }
         }];
    }
    
    

}


- (void)displayPhotos:(NSArray<DBFILESMetadata *> *)folderEntries atIndex:(NSInteger)indexPath{
    for (DBFILESMetadata *entry in folderEntries) {
        NSString *itemName = entry.name;
        NSArray *allComponents = [itemName componentsSeparatedByString:@"-"];
        NSLog(@"%@", allComponents[0]);
        NSLog(@"%@", [[_panelInspections objectAtIndex:indexPath] valueForKey:@"InspectionID"]);
        if ([allComponents[0] isEqualToString: [[_panelInspections objectAtIndex:indexPath] valueForKey:@"InspectionID"]]) {
            NSFileManager *fileManager = [NSFileManager defaultManager];
            NSURL *outputDirectory = [fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask][0];
            NSURL *outputUrl = [outputDirectory URLByAppendingPathComponent:entry.name];
            DBUserClient *client = [DBClientsManager authorizedClient];
            [[[client.filesRoutes downloadUrl:entry.pathDisplay overwrite:YES destination:outputUrl]
              setResponseBlock:^(DBFILESFileMetadata *result, DBFILESDownloadError *routeError, DBRequestError *error, NSURL *destination) {
                  if (result) {
                      //              NSLog(@"%@\n", result);
                      //              NSData *data = [[NSFileManager defaultManager] contentsAtPath:[destination path]];
                      //              self.fileWebView.image = [UIImage imageWithData:data];
                      NSURLRequest *request = [NSURLRequest requestWithURL:destination];
                      [_dropboxWebView loadRequest:request];
                      _popOverView.transform = CGAffineTransformMakeScale(0.01, 0.01);
                      _popOverView.hidden = NO;
                   //   _popoverCloseView.hidden = NO;
                      [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                          // animate it to the identity transform (100% scale)
                          _popOverView.transform = CGAffineTransformIdentity;
//                          _popoverCloseView.backgroundColor = [UIColor grayColor];
//                          _popoverCloseView.alpha = .4;
                      } completion:^(BOOL finished){
                          // if you want to do something once the animation finishes, put it here
                      }];

                  } else {
                      NSLog(@"%@\n%@\n", routeError, error);
                      [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                          // animate it to the identity transform (100% scale)
                          _popoverCloseView.backgroundColor = [UIColor clearColor];
                          _popoverCloseView.alpha = 1;
                      } completion:^(BOOL finished){
                          // if you want to do something once the animation finishes, put it here
                          _popoverCloseView.hidden = YES;
                      }];
                  }
              }] setProgressBlock:^(int64_t bytesDownloaded, int64_t totalBytesDownloaded, int64_t totalBytesExpectedToDownload) {
                  NSLog(@"%lld\n%lld\n%lld\n", bytesDownloaded, totalBytesDownloaded, totalBytesExpectedToDownload);
              }];
            
        }
    }
}





- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// The number of rows of data
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return _clients.count;
}

// The data to return for the row and component (column) that's being passed in
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [[_clients objectAtIndex:row] valueForKey:@"Name"];
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

- (BOOL)textFieldShouldReturn:(UITextField*)textField {
    [textField resignFirstResponder];
    if (textField == self.dropBoxEmailTextField) {
        self.settingsView.transform = CGAffineTransformMakeTranslation(0, 0);
    }
    if (textField == self.dropBoxPasswordTextField) {
        self.settingsView.transform = CGAffineTransformMakeTranslation(0, 0);
    }
    if (textField == self.addInspectorsNameTextField) {
        self.addInspectionView.transform = CGAffineTransformMakeTranslation(0, 0);
    }
    if (textField == self.addInspectionDateTextField) {
        self.addInspectionView.transform = CGAffineTransformMakeTranslation(0, 0);
    }
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField == self.dropBoxEmailTextField) {
        self.settingsView.transform = CGAffineTransformMakeTranslation(0, -75);
    }
    if (textField == self.dropBoxPasswordTextField) {
        self.settingsView.transform = CGAffineTransformMakeTranslation(0, -80);
    }
    if (textField == self.addInspectorsNameTextField) {
        self.addInspectionView.transform = CGAffineTransformMakeTranslation(0, -92);
    }
    if (textField == self.addInspectionDateTextField) {
        self.addInspectionView.transform = CGAffineTransformMakeTranslation(0, -80);
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
    [self textFieldShouldReturn:_dropBoxEmailTextField];
    [self textFieldShouldReturn:_dropBoxPasswordTextField];
    [self textFieldShouldReturn:_addInspectorsNameTextField];
    [self textFieldShouldReturn:_addInspectionDateTextField];


}

-(IBAction)openSettingsView:(id)sender {
    if (self.popOverView.hidden) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *spreadsheetId = [defaults valueForKey:@"SpreadsheetID"];
        self.sheetsIDTextField.text = spreadsheetId;
        NSString *googleEmail = [defaults valueForKey:@"GoogleEmail"];
        self.googleEmailTextField.text = googleEmail;
        NSString *googlePassword = [defaults valueForKey:@"GooglePassword"];
        self.googlePasswodTextField.text = googlePassword;
        NSString *dropboxEmail = [defaults valueForKey:@"DropBoxEmail"];
        self.dropBoxEmailTextField.text = dropboxEmail;
        NSString *dropboxPassword = [defaults valueForKey:@"DropBoxPassword"];
        self.dropBoxPasswordTextField.text = dropboxPassword;
        self.settingsView.transform = CGAffineTransformMakeScale(0.01, 0.01);
        self.settingsView.hidden = NO;
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            // animate it to the identity transform (100% scale)
            self.settingsView.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished){
            // if you want to do something once the animation finishes, put it here
        }];

    } else {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *spreadsheetId = [defaults valueForKey:@"SpreadsheetID"];
        self.sheetsIDTextField.text = spreadsheetId;
        NSString *googleEmail = [defaults valueForKey:@"GoogleEmail"];
        self.googleEmailTextField.text = googleEmail;
        NSString *googlePassword = [defaults valueForKey:@"GooglePassword"];
        self.googlePasswodTextField.text = googlePassword;
        NSString *dropboxEmail = [defaults valueForKey:@"DropBoxEmail"];
        self.dropBoxEmailTextField.text = dropboxEmail;
        NSString *dropboxPassword = [defaults valueForKey:@"DropBoxPassword"];
        self.dropBoxPasswordTextField.text = dropboxPassword;
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            // animate it to the identity transform (100% scale)
            _popOverView.transform = CGAffineTransformMakeScale(0.01, 0.01);
            _popoverCloseView.backgroundColor = [UIColor grayColor];
            _popoverCloseView.alpha = 0;
        } completion:^(BOOL finished){
            // if you want to do something once the animation finishes, put it here
            self.popOverView.hidden = YES;
            self.popoverCloseView.hidden = YES;
            self.settingsView.transform = CGAffineTransformMakeScale(0.01, 0.01);
            self.settingsView.hidden = NO;
            [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                // animate it to the identity transform (100% scale)
                self.settingsView.transform = CGAffineTransformIdentity;
            } completion:^(BOOL finished){
                // if you want to do something once the animation finishes, put it here
            }];
        }];
        
        NSIndexPath *selectedrow = [self.panelTableView indexPathForSelectedRow];
        [self.panelTableView deselectRowAtIndexPath:selectedrow animated:YES];
    }
}

- (IBAction)closePopoverAction:(id)sender {
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        // animate it to the identity transform (100% scale)
        _popOverView.transform = CGAffineTransformMakeScale(0.01, 0.01);
        _popoverCloseView.backgroundColor = [UIColor grayColor];
        _popoverCloseView.alpha = 0;
    } completion:^(BOOL finished){
        // if you want to do something once the animation finishes, put it here
        self.popOverView.hidden = YES;
        self.popoverCloseView.hidden = YES;
    }];
    NSIndexPath *selectedrow = [self.panelTableView indexPathForSelectedRow];
    [self.panelTableView deselectRowAtIndexPath:selectedrow animated:YES];
}

- (IBAction)closePanelAction:(id)sender {
    self.panelCloseView.hidden = YES;
    _panelInspections = [[NSMutableArray alloc] init];
    NSIndexPath *selectedrow = [self.mainTableView indexPathForSelectedRow];
    [self.mainTableView deselectRowAtIndexPath:selectedrow animated:YES];
    [UIView animateWithDuration:1.0
                     animations:^{
                         self.panelTableView.transform = CGAffineTransformMakeTranslation(0, 0);
                         self.panelCloseView.transform = CGAffineTransformMakeTranslation(0, 0);
                     } completion:^(BOOL finished){
                         // if you want to do something once the animation finishes, put it here
                         [self.panelTableView.layer setShadowRadius:0];
                     }];

}



- (IBAction)closeSettingsViewAction:(id)sender {
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        // animate it to the identity transform (100% scale)
        self.settingsView.transform = CGAffineTransformMakeScale(0.01, 0.01);
    } completion:^(BOOL finished){
        // if you want to do something once the animation finishes, put it here
        self.settingsView.hidden = YES;
    }];
}

- (IBAction)saveSettingsAction:(id)sender {
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        // animate it to the identity transform (100% scale)
        self.settingsView.transform = CGAffineTransformMakeScale(0.01, 0.01);
    } completion:^(BOOL finished){
        // if you want to do something once the animation finishes, put it here
        self.settingsView.hidden = YES;
    }];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:self.googleEmailTextField.text forKey:@"GoogleEmail"];
    [defaults setValue:self.googlePasswodTextField.text forKey:@"GooglePassword"];
    [defaults setValue:self.dropBoxEmailTextField.text forKey:@"DropBoxEmail"];
    [defaults setValue:self.dropBoxPasswordTextField.text forKey:@"DropBoxPassword"];
    [defaults setValue:self.sheetsIDTextField.text forKey:@"SpreadsheetID"];
    [defaults synchronize];
}

- (IBAction)closeAddView:(id)sender {
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        // animate it to the identity transform (100% scale)
        self.addInspectionView.transform = CGAffineTransformMakeScale(0.01, 0.01);
    } completion:^(BOOL finished){
        // if you want to do something once the animation finishes, put it here
        self.addInspectionView.hidden = YES;
    }];
}

- (IBAction)addInspectionAction:(id)sender {
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        // animate it to the identity transform (100% scale)
        self.addInspectionView.transform = CGAffineTransformMakeScale(0.01, 0.01);
    } completion:^(BOOL finished){
        // if you want to do something once the animation finishes, put it here
        self.addInspectionView.hidden = YES;
    }];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *spreadsheetId = [defaults valueForKey:@"SpreadsheetID"];
    
    GTLRSheets_ValueRange *valueRange = [[GTLRSheets_ValueRange alloc] init];
    valueRange.majorDimension = kGTLRSheetsMajorDimensionRows;
    valueRange.values = [NSArray arrayWithObjects:[NSArray arrayWithObjects:[NSString stringWithFormat:@"%d", arc4random_uniform(1000000000)], [NSString stringWithFormat:@"%@", [NSDate date]], [NSString stringWithFormat:@"%d-%d", arc4random_uniform(100000000), arc4random_uniform(100000000)], self.addClientsNameTextField.text, self.addJobLocationTextField.text, self.addInspectionDateTextField.text, self.addInspectorsNameTextField.text, nil], nil];
    
    GTLRSheetsQuery_SpreadsheetsValuesAppend *append = [GTLRSheetsQuery_SpreadsheetsValuesAppend queryWithObject:valueRange spreadsheetId:spreadsheetId range:@"Inspections!A2:G"];
    
    append.valueInputOption = kGTLRSheetsValueInputOptionUserEntered;
    append.insertDataOption = kGTLRSheetsInsertDataOptionInsertRows;
    [self.service executeQuery:append delegate:self didFinishSelector:@selector(displayWithTicket:finishedWithObject:error:)];
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        _clients = [[NSMutableArray alloc] init];
        _months = [[NSMutableArray alloc] init];
        _inspections = [[NSMutableArray alloc] init];
        _panelInspections = [[NSMutableArray alloc] init];
        [self getSections];
    });

}

-(IBAction)openAddView:(id)sender {
    self.addInspectionDateTextField.text = @"";
    self.addInspectorsNameTextField.text = @"";
    self.addJobLocationTextField.text = @"";
    self.addClientsNameTextField.text = @"";
    if(_settingsView.hidden && _popOverView.hidden) {
        self.addInspectionView.transform = CGAffineTransformMakeScale(0.01, 0.01);
        self.addInspectionView.hidden = NO;
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            // animate it to the identity transform (100% scale)
            self.addInspectionView.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished){
            // if you want to do something once the animation finishes, put it here
        }];
    } else if (_settingsView.hidden && !_popOverView.hidden) {
        [self closePopoverAction:self];
        self.addInspectionView.transform = CGAffineTransformMakeScale(0.01, 0.01);
        self.addInspectionView.hidden = NO;
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            // animate it to the identity transform (100% scale)
            self.addInspectionView.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished){
            // if you want to do something once the animation finishes, put it here
        }];
    } else {
        [self closeSettingsViewAction:self];
        self.addInspectionView.transform = CGAffineTransformMakeScale(0.01, 0.01);
        self.addInspectionView.hidden = NO;
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            // animate it to the identity transform (100% scale)
            self.addInspectionView.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished){
            // if you want to do something once the animation finishes, put it here
        }];
    }
}

-(void)ShowSelectedDate
{
    if ([self.addClientsNameTextField isEditing]) {
        
        self.addClientsNameTextField.text=[NSString stringWithFormat:@"%@",[[_clients objectAtIndex:[namePicker selectedRowInComponent:0]] valueForKey:@"Name"]];
        [self textFieldShouldReturn:_addClientsNameTextField];
    }
    if ([self.addInspectionDateTextField isEditing]) {
        NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        self.addInspectionDateTextField.text=[NSString stringWithFormat:@"%@",[formatter stringFromDate:datePicker.date]];
        [self textFieldShouldReturn:_addInspectionDateTextField];
    }

}


- (void)displayWithTicket:(GTLRServiceTicket *)ticket
              finishedWithObject:(GTLRSheets_ValueRange *)result
                           error:(NSError *)error {
    
    //NSLog(@"%@", error);
}

@end
