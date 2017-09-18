//
//  ANTSettingsViewController.m
//  BdaysAnvsarys
//
//  Created by Swapnil Jain on 10/17/13.
//  Copyright (c) 2013 Arihant. All rights reserved.
//

#import "ANTSettingsViewController.h"

@interface ANTSettingsViewController ()

@end

@implementation ANTSettingsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.

    self.title = @"Settings";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBAction

-(IBAction)dismissMe:(id)sender{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

-(IBAction)saveUserSettings:(id)sender{
    if(self.tableViewController!=nil)
        [self.tableViewController saveUserSettings];
    [self dismissViewControllerAnimated:YES completion:NULL];

    UIApplication *application = [UIApplication sharedApplication];
    [application cancelAllLocalNotifications];
    [ANTDataManager scheduleNotificationsForUpcomingEvents];
}

#pragma mark - Segue

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([[segue identifier] isEqualToString:kSettingTableIdentifier]){
        self.tableViewController = [segue destinationViewController];
    }
}

@end
