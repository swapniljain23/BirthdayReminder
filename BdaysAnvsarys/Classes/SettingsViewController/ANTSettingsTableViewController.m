//
//  ANTSettingsTableViewController.m
//  BdaysAnvsarys
//
//  Created by Swapnil Jain on 11/8/13.
//  Copyright (c) 2013 Arihant. All rights reserved.
//

#import "ANTSettingsTableViewController.h"

@interface ANTSettingsTableViewController ()

@end

@implementation ANTSettingsTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;

    // Load page with User Defaults Value
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [self.reminderSwitch setOn:[defaults boolForKey:kIsReminderEnabled]];
    [self.timeOfDaySlider setValue:[defaults integerForKey:kTimeOfDay]];
    [self.daysBeforeSlider setValue:[defaults integerForKey:kDaysBefore]];

    [self timeOfDayChanged:self.timeOfDaySlider];
    [self reminderDaysBeforeChanged:self.daysBeforeSlider];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Save Settings

-(void)saveUserSettings{

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:[self.reminderSwitch isOn] forKey:kIsReminderEnabled];
    [defaults setInteger:self.daysBeforeSlider.value forKey:kDaysBefore];
    [defaults setInteger:self.timeOfDaySlider.value forKey:kTimeOfDay];
    [defaults synchronize];
}

#pragma mark - Table view data source

/*
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

#pragma mark - IBAction

- (IBAction)reminderValueChanged:(id)sender {

}

- (IBAction)timeOfDayChanged:(id)sender {
    int value = round([(UISlider*)sender value]);
    self.timeOfDayLabel.text = [self convert24to12Hrs:value];
    [(UISlider*)sender setValue:value];
}

- (IBAction)reminderDaysBeforeChanged:(id)sender {
    int value = round([(UISlider*)sender value]);
    if(value==0)
        self.daysBeforeLabel.text = @"Same Day";
    else if(value==1)
        self.daysBeforeLabel.text = [NSString stringWithFormat:@"%d Day",value];
    else
        self.daysBeforeLabel.text = [NSString stringWithFormat:@"%d Days",value];

    [(UISlider*)sender setValue:value];
}

#pragma mark - Private

-(NSString*)convert24to12Hrs:(int)time{
    if(time==0)
        return @"12 AM";
    else if(time<12)
        return [NSString stringWithFormat:@"%d AM",time];
    else if(time==12)
        return @"12 PM";
    else
        return [NSString stringWithFormat:@"%d PM",time-12];
}

@end
