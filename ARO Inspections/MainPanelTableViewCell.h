//
//  MainPanelTableViewCell.h
//  ARO Inspections
//
//  Created by Grant Arrowood on 1/12/17.
//  Copyright © 2017 Piglet Products. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainPanelTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *jobLocationLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *inspectorsNameLabel;

@end
