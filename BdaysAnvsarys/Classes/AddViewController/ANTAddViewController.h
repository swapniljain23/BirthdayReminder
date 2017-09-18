//
//  ANTAddViewController.h
//  BdaysAnvsarys
//
//  Created by Swapnil Jain on 10/17/13.
//  Copyright (c) 2013 Arihant. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ANTMyBuddy.h"
#import "ANTTextFieldCell.h"
#import "ANTDataManager.h"
#import "ANTAppConstant.h"

enum tableType{
    eInputTable = 0,
    eOptionTable = 1
};

@interface ANTAddViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *inputTableView;
@property (strong, nonatomic) IBOutlet UITableView *optionTableView;
@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;

@property (strong, nonatomic) ANTMyBuddy *buddy;

-(IBAction)dismissMe:(id)sender;
-(IBAction)saveRecord:(id)sender;
-(IBAction)updateLabel:(id)sender;

-(void)addUpdateButton;

@end
