//
//  ANTAppDelegate.h
//  BdaysAnvsarys
//
//  Created by Swapnil Jain on 10/17/13.
//  Copyright (c) 2013 Arihant. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ANTAppConstant.h"
#import "ANTDataManager.h"

@interface ANTAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
