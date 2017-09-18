//
//  ANTDataManager.h
//  BdaysAnvsarys
//
//  Created by Swapnil Jain on 11/1/13.
//  Copyright (c) 2013 Arihant. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ANTMyBuddy.h"
#import "ANTAppDelegate.h"
#import "ANTAppConstant.h"

@interface ANTDataManager : NSObject

+(NSMutableArray*)fetchMyBuddiesForDay:(enum dayType)day isUpcomingOnly:(BOOL)upcoming;
+(void)saveBuddy:(ANTMyBuddy*)buddy;
+(void)updateBuddy:(ANTMyBuddy*)buddy;
+(void)deleteBuddy:(ANTMyBuddy*)buddy;
+(NSString*)howOldMyBuddyIs:(NSDate*)date;
+(ANTMyBuddy*)fetchBuddyWithObjectId:(NSManagedObjectID*)objectId;
+(void)scheduleNotificationsForUpcomingEvents;

@end
