//
//  ANTCustomCell.h
//  BdaysAnvsarys
//
//  Created by Swapnil Jain on 10/18/13.
//  Copyright (c) 2013 Arihant. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ANTCustomCell : UITableViewCell

@property(nonatomic, strong) IBOutlet UILabel *titleText;
@property(nonatomic, strong) IBOutlet UILabel *detailText;
@property(nonatomic, strong) IBOutlet UILabel *dayText;
@property(nonatomic, strong) IBOutlet UILabel *monthText;
@property(nonatomic, strong) IBOutlet UILabel *yearText;

@end
