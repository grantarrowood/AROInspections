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

@interface MainViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) GTLRSheetsService *service;
@property (strong, nonatomic) NSMutableArray *clients;
@property (strong, nonatomic) NSMutableArray *inspections;
@property (strong, nonatomic) NSMutableArray *months;
@property (strong, nonatomic) IBOutlet UITableView *mainTableView;
@property (strong, nonatomic) IBOutlet UITableView *panelTableView;
@end
