//
//  ANTSecondViewController.h
//  BdaysAnvsarys
//
//  Created by Swapnil Jain on 10/17/13.
//  Copyright (c) 2013 Arihant. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ANTMyBuddy.h"
#import "ANTCustomCell.h"
#import "ANTAppConstant.h"
#import "ANTDataManager.h"
#import "ANTAddViewController.h"

@interface ANTAllViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>

@property(nonatomic, strong) IBOutlet UITableView *tableView;
@property(nonatomic, strong) IBOutlet UISegmentedControl *segment;

@property(nonatomic, strong) NSMutableArray *buddiesArray;
@property(nonatomic, strong) NSMutableArray *buddiesFilteredArray;

@property(nonatomic, strong) UISearchBar *searchBar;

-(void)refreshData:(id)sender;

-(IBAction)valueChanged:(id)sender;

@end
