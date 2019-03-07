//
//  AppDelegate.h
//  MyNotepad
//
//  Created by 김명유 on 05/03/2019.
//  Copyright © 2019 김명유. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "LoginViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (readonly, strong) NSPersistentContainer *persistentContainer;
@property (strong, nonatomic) LoginViewController *loginViewController;

+ (NSPersistentContainer *)persistentContainer;
- (void)saveContext;

@end

