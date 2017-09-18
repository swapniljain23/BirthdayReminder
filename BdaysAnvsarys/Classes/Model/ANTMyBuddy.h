//
//  ANTMyBuddy.h
//  BdaysAnvsarys
//
//  Created by Swapnil Jain on 10/17/13.
//  Copyright (c) 2013 Arihant. All rights reserved.
//

#import <Foundation/Foundation.h>

enum dayType{
    eBirthDay = 0,
    eAnniversary = 1,
    eAll = 3
};

@interface ANTMyBuddy : NSObject

@property(nonatomic, strong) NSManagedObjectID *objectId;
@property(nonatomic, strong) NSString *firstName;
@property(nonatomic, strong) NSString *lastName;
@property(nonatomic, strong) NSDate *date;

@property(nonatomic,assign) enum dayType whatDay;

@end
