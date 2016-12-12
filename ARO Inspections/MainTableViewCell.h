//
//  MainTableViewCell.h
//  ARO Inspections
//
//  Created by Grant Arrowood on 12/12/16.
//  Copyright © 2016 Piglet Products. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *clientNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *remainingVisitsLabel;

@end
