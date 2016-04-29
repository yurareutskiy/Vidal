//
//  AppDelegate.h
//  Vidal
//
//  Created by Anton Scherbakov on 26/02/16.
//  Copyright © 2016 StyleRU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "VKSdk.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "OKSDK.h"
#import <Google/CloudMessaging.h>
#import "YMMYandexMetrica.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, GGLInstanceIDDelegate, GCMReceiverDelegate>

@property (strong, nonatomic) UIWindow *window;
@property(nonatomic, readonly, strong) NSString *registrationKey;
@property(nonatomic, readonly, strong) NSString *messageKey;
@property(nonatomic, readonly, strong) NSString *gcmSenderID;
@property(nonatomic, readonly, strong) NSDictionary *registrationOptions;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;



@end

