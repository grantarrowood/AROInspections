//
//  MainTableViewController.h
//  ARO Inspections
//
//  Created by Grant Arrowood on 12/12/16.
//  Copyright © 2016 Piglet Products. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GTMOAuth2ViewControllerTouch.h"
#import "GTLRSheets.h"


@interface MainTableViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource> {
}


@property (nonatomic, strong) GTLRSheetsService *service;
@property (strong, nonatomic) NSMutableArray *clients;
@property (strong, nonatomic) NSMutableArray *inspections;
@property (strong, nonatomic) NSMutableArray *months;
@property (strong, nonatomic) IBOutlet UITableView *mainTableView;


@end
