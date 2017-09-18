//
//  ANTDataManager.m
//  BdaysAnvsarys
//
//  Created by Swapnil Jain on 11/1/13.
//  Copyright (c) 2013 Arihant. All rights reserved.
//

#import "ANTDataManager.h"

@implementation ANTDataManager

#pragma mark - Class Method

+(NSMutableArray*)fetchMyBuddiesForDay:(enum dayType)day isUpcomingOnly:(BOOL)upcoming{

    NSMutableArray *buddiesArray = [[NSMutableArray alloc] init];

    ANTAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:kEntityBuddy inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];

    if(day!=eAll){
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"(type = %d)",day];
        [request setPredicate:pred];
    }

    NSError *error;
    NSArray *objects = [context executeFetchRequest:request error:&error];
    if ([objects count] != 0){
        for (NSManagedObject *match in objects) {
            ANTMyBuddy *buddy = [[ANTMyBuddy alloc] init];
            [buddy setObjectId:[match objectID]];
            [buddy setFirstName:[match valueForKey:kFirstNameKey]];
            [buddy setLastName:[match valueForKey:kLastNameKey]];
            [buddy setDate:[match valueForKey:kDateKey]];
            [buddy setWhatDay:[[match valueForKey:kDayTypeKey] intValue]];

            if(upcoming && ![self isUpcomingEvent:buddy])
                continue;
            [buddiesArray addObject:buddy];
        }
    }

    [buddiesArray sortUsingComparator:^NSComparisonResult(ANTMyBuddy *b1, ANTMyBuddy *b2){
        NSDate *d1 = [b1 date];
        NSDate *d2 = [b2 date];

        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"dd/MMM"];

        NSString *dateStr1 = [formatter stringFromDate:d1];
        NSString *dateStr2 = [formatter stringFromDate:d2];

        return [[formatter dateFromString:dateStr1] compare:[formatter dateFromString:dateStr2]];
        //return [d1 compare:d2];
    }];

    return buddiesArray;
}

+(void)saveBuddy:(ANTMyBuddy*)buddy{

    // Save new record
    ANTAppDelegate *appDelegate = (ANTAppDelegate*)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSError *error;

    NSManagedObject *newAccount = [NSEntityDescription insertNewObjectForEntityForName:kEntityBuddy inManagedObjectContext:context];
    [newAccount setValue:buddy.firstName forKey:kFirstNameKey];
    [newAccount setValue:buddy.lastName forKey:kLastNameKey];
    [newAccount setValue:buddy.date forKey:kDateKey];
    [newAccount setValue:[NSNumber numberWithInt:buddy.whatDay] forKey:kDayTypeKey];

    [buddy setObjectId:newAccount.objectID];
    [context save:&error];

    // Schedule notification
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if([defaults boolForKey:kIsReminderEnabled] && [self isUpcomingEvent:buddy])
        [self scheduleNotificationForBuddy:buddy];
}

+(void)updateBuddy:(ANTMyBuddy*)buddy{

    ANTAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];

    NSError *error;
    NSManagedObject *object = [context existingObjectWithID:[buddy objectId] error:&error];
    if(nil != object){
        [object setValue:buddy.firstName forKey:kFirstNameKey];
        [object setValue:buddy.lastName forKey:kLastNameKey];
        [object setValue:buddy.date forKey:kDateKey];
        [object setValue:[NSNumber numberWithInt:buddy.whatDay] forKey:kDayTypeKey];
        [context save:&error];
    }

    // Update Notification
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if([defaults boolForKey:kIsReminderEnabled]){
        UIApplication *application = [UIApplication sharedApplication];
        NSArray *notifications = [application scheduledLocalNotifications];
        for (UILocalNotification *notify in notifications) {
            NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] init];
            NSManagedObjectID *objectId = [coordinator managedObjectIDForURIRepresentation:[notify.userInfo objectForKey:kItemIdKey]];
//            if([notify.userInfo objectForKey:kItemIdKey]==[buddy objectId]){
            if(objectId==[buddy objectId]){
                [application cancelLocalNotification:notify];
                if([self isUpcomingEvent:buddy])
                    [self scheduleNotificationForBuddy:buddy];
                break;
            }
        }
    }

}

+(NSString*)howOldMyBuddyIs:(NSDate*)iDate{

    int years = 0;
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];

    NSDateComponents *componentsNow = [calendar components:NSYearCalendarUnit| NSMonthCalendarUnit|NSDayCalendarUnit fromDate:now];
    NSDateComponents *componentsEve = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:iDate];

    if(componentsNow.month<componentsEve.month || (componentsNow.month==componentsEve.month && componentsNow.day<componentsEve.day))
        years = componentsNow.year-componentsEve.year-1;
    else
        years = componentsNow.year-componentsEve.year;

    return [NSString stringWithFormat:@"%d Years Old",years];
}

+(void)deleteBuddy:(ANTMyBuddy*)buddy{
    ANTAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];

    NSError *error;
    NSManagedObject *object = [context existingObjectWithID:[buddy objectId] error:&error];
    if(nil != object){
        [context deleteObject:object];
        [context save:&error];

        // Delete notification
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        if([defaults boolForKey:kIsReminderEnabled]){
            UIApplication *application = [UIApplication sharedApplication];
            NSArray *notifications = [application scheduledLocalNotifications];
            for (UILocalNotification *notify in notifications) {
                NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] init];
                NSManagedObjectID *objectId = [coordinator managedObjectIDForURIRepresentation:[notify.userInfo objectForKey:kItemIdKey]];
//                if([notify.userInfo objectForKey:kItemIdKey]==[buddy objectId]){
                if(objectId==[buddy objectId]){
                    [application cancelLocalNotification:notify];
                    break;
                }
            }
        }

    }
}

+(void)scheduleNotificationsForUpcomingEvents{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if(![defaults boolForKey:kIsReminderEnabled])
        return;
    NSMutableArray *buddiesArray = [self fetchMyBuddiesForDay:eAll isUpcomingOnly:YES];
    for (ANTMyBuddy *buddy in buddiesArray) {
        [self scheduleNotificationForBuddy:buddy];
    }
}

+(ANTMyBuddy*)fetchBuddyWithObjectId:(NSManagedObjectID*)objectId{
    ANTAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];

    NSError *error;
    NSManagedObject *object = [context existingObjectWithID:objectId error:&error];

    ANTMyBuddy *buddy = [[ANTMyBuddy alloc] init];
    [buddy setObjectId:[object objectID]];
    [buddy setFirstName:[object valueForKey:kFirstNameKey]];
    [buddy setLastName:[object valueForKey:kLastNameKey]];
    [buddy setDate:[object valueForKey:kDateKey]];
    [buddy setWhatDay:[[object valueForKey:kDayTypeKey] intValue]];

    return buddy;
}

#pragma mark - Private

+(BOOL)isUpcomingEvent:(ANTMyBuddy*)buddy{
    NSDate *now = [NSDate date];

    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];

    NSDateComponents *componentsNow = [calendar components:NSMonthCalendarUnit|NSDayCalendarUnit fromDate:now];
    NSDateComponents *componentsEve = [calendar components:NSMonthCalendarUnit|NSDayCalendarUnit fromDate:buddy.date];

    if (componentsNow.month==componentsEve.month) {
        if(componentsNow.day<=componentsEve.day)
            return YES;
        else
            return NO;
    }else if (componentsNow.month+1==componentsEve.month)
        return YES;
    else
        return NO;
}

+(void)scheduleNotificationForBuddy:(ANTMyBuddy*)buddy{

    UILocalNotification *aNotification = [[UILocalNotification alloc] init];
    aNotification.timeZone = [NSTimeZone systemTimeZone];

    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];

    NSDate *today = [NSDate date];
    NSDateComponents *todayComponent = [calendar components:NSYearCalendarUnit|NSHourCalendarUnit fromDate:today];
    todayComponent.timeZone = [NSTimeZone systemTimeZone];
    NSInteger currentYear = [todayComponent year];
    NSInteger currentHour = [todayComponent hour];

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSInteger daysBefore = [defaults integerForKey:kDaysBefore];
    NSInteger timeOfDay = [defaults integerForKey:kTimeOfDay];

    if(currentHour>=timeOfDay)
        return;

    NSDate *eventDate = [buddy date];
    NSDate *notificationDate = [eventDate dateByAddingTimeInterval:-daysBefore*24*60*60];
    NSDateComponents *componentsNow = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit fromDate:notificationDate];
    [componentsNow setTimeZone:[NSTimeZone systemTimeZone]];
    [componentsNow setYear:currentYear];
    [componentsNow setHour:timeOfDay];
    [componentsNow setMinute:0];

    aNotification.fireDate = [calendar dateFromComponents:componentsNow];

//    NSLog(@"DATE :- %@",aNotification.fireDate);

    NSString *eventTypeString;
    if([buddy whatDay]==eBirthDay)
        eventTypeString = @"birthday";
    else
        eventTypeString = @"anniversary";
    aNotification.alertBody = [NSString stringWithFormat:@"%@ %@'s %@ today. Don't forget to call :)",buddy.firstName,buddy.lastName,eventTypeString];
    aNotification.alertAction = @"Details";
    aNotification.soundName = UILocalNotificationDefaultSoundName;

    /* if you wish to pass additional parameters and arguments, you can fill an info dictionary and set it as userInfo property */
    //fill it with a reference to an istance of NSDictionary;
    NSDictionary *infoDict = [NSDictionary dictionaryWithObject:[[buddy.objectId URIRepresentation] absoluteString] forKey:kItemIdKey];
    aNotification.userInfo = infoDict;
    [aNotification setApplicationIconBadgeNumber:1];

    [[UIApplication sharedApplication] scheduleLocalNotification:aNotification];
}

@end
