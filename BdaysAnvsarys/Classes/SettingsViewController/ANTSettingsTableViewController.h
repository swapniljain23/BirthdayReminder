//
//  ANTSettingsTableViewController.h
//  BdaysAnvsarys
//
//  Created by Swapnil Jain on 11/8/13.
//  Copyright (c) 2013 Arihant. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ANTAppConstant.h"

@interface ANTSettingsTableViewController : UITableViewController

@property (strong, nonatomic) IBOutlet UISwitch *reminderSwitch;
@property (strong, nonatomic) IBOutlet UISlider *timeOfDaySlider;
@property (strong, nonatomic) IBOutlet UISlider *daysBeforeSlider;

@property (strong, nonatomic) IBOutlet UILabel *timeOfDayLabel;
@property (strong, nonatomic) IBOutlet UILabel *daysBeforeLabel;

- (IBAction)reminderValueChanged:(id)sender;
- (IBAction)timeOfDayChanged:(id)sender;
- (IBAction)reminderDaysBeforeChanged:(id)sender;

-(void)saveUserSettings;

@end
