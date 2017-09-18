//
//  ANTAddViewController.m
//  BdaysAnvsarys
//
//  Created by Swapnil Jain on 10/17/13.
//  Copyright (c) 2013 Arihant. All rights reserved.
//

#import "ANTAddViewController.h"

@interface ANTAddViewController (){
    enum dayType type;
}

@end

@implementation ANTAddViewController

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

    // Set current date as Maximum date of date picker.
    [self.datePicker setMaximumDate:[NSDate date]];
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

-(IBAction)saveRecord:(id)sender{

    ANTMyBuddy *buddy = [self intiateBuddyFromUserInput];

    if(buddy==nil)
        return;

    [ANTDataManager saveBuddy:buddy];
    [[NSNotificationCenter defaultCenter] postNotificationName:kBuddyNotificationIdentifier object:self];
    [self dismissViewControllerAnimated:YES completion:NULL];
}

-(IBAction)updateLabel:(id)sender{
//    [self.inputTableView reloadData];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
    UITableViewCell *cell = [self.inputTableView cellForRowAtIndexPath:indexPath];

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd-MMM-yyyy"];

    cell.textLabel.text = [formatter stringFromDate:self.datePicker.date];
    [self hideKeyboard];
}

#pragma mark - UITableView DataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if([tableView tag]==eOptionTable)
        return 1;
    else //if([tableView tag]==eInputTable)
        return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if([tableView tag]==eOptionTable)
        return 2;
    else {//if([tableView tag]==eInputTable)
        if(section==0)
            return 2;
        else
            return 1;
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = nil;

    if([tableView tag]==eInputTable){
        //cell = [tableView dequeueReusableCellWithIdentifier:@"OptionCell" forIndexPath:indexPath];
        if(indexPath.section==0){
            ANTTextFieldCell *cell = (ANTTextFieldCell*)[tableView dequeueReusableCellWithIdentifier:kTextFieldCellIdentifier forIndexPath:indexPath];
            if(indexPath.row==0)
                cell.textField.placeholder = kFNamePlaceHolder;
            else
                cell.textField.placeholder = kLNamePlaceHolder;

            // Set value, in case of edit
            if(self.buddy!=nil){
                if(indexPath.row==0)
                    cell.textField.text = [self.buddy firstName];
                else
                    cell.textField.text = [self.buddy lastName];
            }

            return cell;
        }else{

            // Set value, in case of edit
            if(self.buddy!=nil)
                [self.datePicker setDate:self.buddy.date];

            cell = [tableView dequeueReusableCellWithIdentifier:kDatePickerCellIdentifier forIndexPath:indexPath];

            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"dd-MMM-yyyy"];

            cell.textLabel.text = [formatter stringFromDate:self.datePicker.date];
        }

    }else if([tableView tag]==eOptionTable){
        cell = [tableView dequeueReusableCellWithIdentifier:kOptionCellIdentifier forIndexPath:indexPath];
        if(cell!=nil){
            switch (indexPath.row) {
                case eBirthDay:
                    cell.textLabel.text = @"Birthday";
                    break;
                case eAnniversary:
                    cell.textLabel.text = @"Anniversary";
                    break;
                default:
                    break;
            }
        }
        // Set value, in case of edit
        if(self.buddy!=nil){
            if(indexPath.row==self.buddy.whatDay){
                [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
                type = self.buddy.whatDay;
            }
        }else{
            if(indexPath.row==eBirthDay){
                [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
                type = eBirthDay;
            }
        }
    }
    return cell;
}

#pragma mark - UITableView Delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if([tableView tag]==eOptionTable){
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        [self setAccessoryTypeToNoneForTableView:tableView];
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
        type = indexPath.row;
    }else if([tableView tag]==eInputTable){
        if(indexPath.section==1){
            [self hideKeyboard];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if([tableView tag]==eInputTable)
        return 20.0f;
    else //if([tableView tag]==eOptionTable)
        return 0.0;
}

#pragma mark - Private

-(void)hideKeyboard{

    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    ANTTextFieldCell *cell = (ANTTextFieldCell*)[self.inputTableView cellForRowAtIndexPath:indexPath];
    if([cell.textField isFirstResponder])
        [cell.textField resignFirstResponder];

    indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
    cell = (ANTTextFieldCell*)[self.inputTableView cellForRowAtIndexPath:indexPath];
    if([cell.textField isFirstResponder])
        [cell.textField resignFirstResponder];
}

-(void)setAccessoryTypeToNoneForTableView:(UITableView*)tableView{

    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setAccessoryType:UITableViewCellAccessoryNone];

    indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
    cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setAccessoryType:UITableViewCellAccessoryNone];
    
}

-(ANTMyBuddy*)intiateBuddyFromUserInput{

    NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
    NSString *firstName = [[(ANTTextFieldCell*)[self.inputTableView cellForRowAtIndexPath:path] textField] text];
    path = [NSIndexPath indexPathForRow:1 inSection:0];
    NSString *lastName = [[(ANTTextFieldCell*)[self.inputTableView cellForRowAtIndexPath:path] textField] text];

    if([firstName isEqualToString:@""] || [lastName isEqualToString:@""]){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error !" message:@"First Name & Last Name field must NOT be empty" delegate:nil cancelButtonTitle:@"Got it !" otherButtonTitles:nil];
        [alertView show];
        return nil;
    }


    ANTMyBuddy *buddy = [[ANTMyBuddy alloc] init];
    [buddy setFirstName:firstName];
    [buddy setLastName:lastName];
    [buddy setDate:self.datePicker.date];
    [buddy setWhatDay:type];

    return buddy;
}

#pragma mark - Edit Page

-(void)addUpdateButton{
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(updateRecord:)];
    [self.navigationItem setRightBarButtonItem:item];
}

-(void)updateRecord:(id)sender{
    ANTMyBuddy *buddy = [self intiateBuddyFromUserInput];
    [buddy setObjectId:self.buddy.objectId];
    if(buddy==nil)
        return;
    [ANTDataManager updateBuddy:buddy];
    [[NSNotificationCenter defaultCenter] postNotificationName:kBuddyNotificationIdentifier object:self];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Touch Event

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self hideKeyboard];
}

@end
