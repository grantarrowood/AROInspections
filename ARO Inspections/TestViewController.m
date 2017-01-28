//
//  TestViewController.m
//  ARO Inspections
//
//  Created by Grant Arrowood on 1/28/17.
//  Copyright © 2017 Piglet Products. All rights reserved.
//

#import "TestViewController.h"

@interface TestViewController ()

@end

@implementation TestViewController

static NSString *const kKeychainItemName = @"Google Sheets API";
static NSString *const kClientID = @"305412303204-e4ac96jc1eofpniu5jhqoplcqdupqslk.apps.googleusercontent.com";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.service = [[GTLRSheetsService alloc] init];
    self.service.authorizer =
    [GTMOAuth2ViewControllerTouch authForGoogleFromKeychainForName:kKeychainItemName
                                                          clientID:kClientID
                                                      clientSecret:nil];
    self.service.APIKey = @"AIzaSyCivDyonDkOvbRz8xSrVDI-Kko3_lwcaxc";
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self presentViewController:[self createAuthController] animated:YES completion:nil];

    if (!self.service.authorizer.canAuthorize) {
        // Not yet authorized, request authorization by pushing the login UI onto the UI stack.
    } else {
        [self addAction:self];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)addAction:(id)sender {
    GTLRSheets_ValueRange *valueRange = [[GTLRSheets_ValueRange alloc] init];
    //valueRange.range = @"Class Data!A2:G";
    valueRange.majorDimension = kGTLRSheetsMajorDimensionRows;
    valueRange.values = [NSArray arrayWithObjects:[NSArray arrayWithObjects:@"Hello", @"Bye", nil], nil];
    GTLRSheetsQuery_SpreadsheetsValuesAppend *append = [GTLRSheetsQuery_SpreadsheetsValuesAppend queryWithObject:valueRange spreadsheetId:@"1PxiCW2IEM0PYWO7tCSKFj1yqBsyhWCMR8y79xxtkyP4" range:@"Class Data!A2:G"];
    append.valueInputOption = kGTLRSheetsValueInputOptionUserEntered;
    append.insertDataOption = kGTLRSheetsInsertDataOptionInsertRows;
    [self.service executeQuery:append delegate:self didFinishSelector:@selector(displayResultWithTicket:finishedWithObject:error:)];
}
- (void)displayResultWithTicket:(GTLRServiceTicket *)ticket
             finishedWithObject:(GTLRSheets_ValueRange *)result
                          error:(NSError *)error {
    //NSLog(@"%@", result.values);
    NSLog(@"Error getting sheet data: %@\n", error.localizedDescription);
    
}

// Creates the auth controller for authorizing access to Google Sheets API.
- (GTMOAuth2ViewControllerTouch *)createAuthController {
    GTMOAuth2ViewControllerTouch *authController;
    // If modifying these scopes, delete your previously saved credentials by
    // resetting the iOS simulator or uninstall the app.
    NSArray *scopes = [NSArray arrayWithObjects:kGTLRAuthScopeSheetsSpreadsheets, nil];
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
        //[self showAlert:@"Authentication Error" message:error.localizedDescription];
        self.service.authorizer = nil;
    }
    else {
        self.service.authorizer = authResult;
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
