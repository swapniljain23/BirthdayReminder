//
//  ANTSettingsViewController.h
//  BdaysAnvsarys
//
//  Created by Swapnil Jain on 10/17/13.
//  Copyright (c) 2013 Arihant. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ANTSettingsTableViewController.h"
#import "ANTDataManager.h"

@interface ANTSettingsViewController : UIViewController

@property(nonatomic, strong) ANTSettingsTableViewController *tableViewController;

-(IBAction)dismissMe:(id)sender;
-(IBAction)saveUserSettings:(id)sender;

@end
