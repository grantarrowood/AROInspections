//
//  MainViewController.h
//  ARO Inspections
//
//  Created by Grant Arrowood on 1/12/17.
//  Copyright © 2017 Piglet Products. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GTMOAuth2ViewControllerTouch.h"
#import "GTLRSheets.h"
#import <ObjectiveDropboxOfficial/ObjectiveDropboxOfficial.h>

@interface MainViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

- (IBAction)closePopoverAction:(id)sender;
- (IBAction)closePanelAction:(id)sender;
- (IBAction)closeSettingsViewAction:(id)sender;
- (IBAction)saveSettingsAction:(id)sender;
@property (nonatomic, strong) GTLRSheetsService *service;
@property (strong, nonatomic) NSMutableArray *clients;
@property (strong, nonatomic) NSMutableArray *inspections;
@property (strong, nonatomic) NSMutableArray *months;
@property (strong, nonatomic) NSMutableArray *panelInspections;
@property (weak, nonatomic) IBOutlet UIView *popOverView;
@property (weak, nonatomic) IBOutlet UIWebView *dropboxWebView;
@property (strong, nonatomic) IBOutlet UITableView *mainTableView;
@property (weak, nonatomic) IBOutlet UIView *popoverCloseView;
@property (weak, nonatomic) IBOutlet UIView *panelCloseView;
@property (weak, nonatomic) IBOutlet UIView *settingsView;
@property (weak, nonatomic) IBOutlet UIButton *closeSettingsButton;
@property (weak, nonatomic) IBOutlet UITextField *sheetsIDTextField;
@property (weak, nonatomic) IBOutlet UITextField *googleEmailTextField;
@property (weak, nonatomic) IBOutlet UITextField *googlePasswodTextField;
@property (weak, nonatomic) IBOutlet UITextField *dropBoxEmailTextField;
@property (weak, nonatomic) IBOutlet UITextField *dropBoxPasswordTextField;
@property (weak, nonatomic) IBOutlet UIButton *saveSettingsButton;
@property (strong, nonatomic) IBOutlet UITableView *panelTableView;
@end
