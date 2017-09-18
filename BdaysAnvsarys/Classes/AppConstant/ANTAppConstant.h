//
//  ANTAppConstant.h
//  BdaysAnvsarys
//
//  Created by Swapnil Jain on 10/31/13.
//  Copyright (c) 2013 Arihant. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ANTAppConstant : NSObject

FOUNDATION_EXPORT NSString *const kItemIdKey;
FOUNDATION_EXPORT NSString *const kFirstNameKey;
FOUNDATION_EXPORT NSString *const kLastNameKey;
FOUNDATION_EXPORT NSString *const kDateKey;
FOUNDATION_EXPORT NSString *const kDayTypeKey;

FOUNDATION_EXPORT NSString *const kEntityBuddy;

FOUNDATION_EXPORT NSString *const kFNamePlaceHolder;
FOUNDATION_EXPORT NSString *const kLNamePlaceHolder;

FOUNDATION_EXPORT NSString *const kTextFieldCellIdentifier;
FOUNDATION_EXPORT NSString *const kDatePickerCellIdentifier;
FOUNDATION_EXPORT NSString *const kOptionCellIdentifier;

FOUNDATION_EXPORT NSString *const kBuddyNotificationIdentifier;
FOUNDATION_EXPORT NSString *const kAllEventRefreshIdentifier;
FOUNDATION_EXPORT NSString *const kUpcomingEventRefreshIdentifier;

FOUNDATION_EXPORT NSString *const kAddBuddySegue;
FOUNDATION_EXPORT NSString *const kEditBuddySegue;

FOUNDATION_EXPORT NSString *const kIsReminderEnabled;
FOUNDATION_EXPORT NSString *const kTimeOfDay;
FOUNDATION_EXPORT NSString *const kDaysBefore;

FOUNDATION_EXPORT NSString *const kSettingTableIdentifier;

#define kOneDayTimeInterval 86400
#define kSearchBarHeight 30.0

@end
