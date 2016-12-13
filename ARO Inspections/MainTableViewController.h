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
    NSString *check[100][2];
    NSString *visits[100][2];
    NSString *file[100];
    int rowcountcheck;
    int rowcountvisits;
}


@property (nonatomic, strong) GTLRSheetsService *service;
@property (strong, nonatomic) NSMutableArray *objects;
@property (strong, nonatomic) NSMutableArray *done;
@property (strong, nonatomic) NSMutableArray *notdone;
@property (strong, nonatomic) IBOutlet UITableView *mainTableView;


@end
