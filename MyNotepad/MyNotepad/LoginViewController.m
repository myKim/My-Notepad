//
//  LoginViewController.m
//  MyNotepad
//
//  Created by 김명유 on 05/03/2019.
//  Copyright © 2019 김명유. All rights reserved.
//

#import "LoginViewController.h"
#import "NoteViewController.h"

// Frameworks
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>


@interface LoginViewController ()

@end


@implementation LoginViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.facebookLoginButton.delegate = self;
    self.facebookLoginButton.readPermissions = @[@"public_profile", @"email"];
}


#pragma mark - FBSDKLoginButton Delegate Methods
- (void)loginButton:(FBSDKLoginButton *)loginButton didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result
              error:(NSError *)error {
    
    if(error) {
        NSLog(@"%@", error.localizedDescription);
    }
    
    if(result.isCancelled) {
        NSLog(@"User cancelled the login.");
    }
    else if(result.declinedPermissions.count > 0) {
        NSLog(@"User has declined the permissions.");
    }
    else {
        // User logged in successfully.
        // Take user to next view. (NoteViewController)
        NoteViewController *viewController = [[NoteViewController alloc] initWithNibName:@"NoteViewController" bundle:nil];
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:viewController];
        [self presentViewController:navController animated:YES completion:nil];
    }
}

- (void)loginButtonDidLogOut:(FBSDKLoginButton *)loginButton {
    NSLog(@"User logged out.");
}

- (BOOL)loginButtonWillLogin:(FBSDKLoginButton *)loginButton {
    return YES;
}

//- (IBAction)onFacebookLoginButtonClicked:(UIButton *)sender {
//    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
//
//    if(isLoggedIn) {
//        [login logOut];
//        [FBSDKAccessToken setCurrentAccessToken:nil];
//
//        isLoggedIn = NO;
//
//        [self.facebookLoginButton setTitle:@"Facebook Login" forState:UIControlStateNormal];
//    }
//    else {
//        [login logInWithReadPermissions:@[@"email"]
//                     fromViewController:self
//                                handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
//                                    if(error) {
//                                        NSLog(@"Process error");
//                                    }
//                                    else if(result.isCancelled) {
//                                        NSLog(@"Cancelled");
//                                    }
//                                    else {
//                                        NSLog(@"Logged in");
//
//                                        if([result.grantedPermissions containsObject:@"email"]) {
//                                            NSLog(@"result is: %@", result);
//                                            [self fetchUserInfo];
//                                        }
//                                    }
//                                }
//         ];
//    }
//}

//- (void)fetchProfile {
//    NSLog(@"Fetch profile");
//
//    NSDictionary *parameters = @{@"fields":@"id, name, first_name, last_name, picture.type(large), email, gender"};
//    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:parameters];
//
//    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
//
//        if(error != nil) {
//            NSLog(@"%@", error);
//            return;
//        }
//
//        if(result != nil) {
//            if([result objectForKey:@"id"]) {
//                NSLog(@"id: %@", [result objectForKey:@"id"]);
//            }
//            if([result objectForKey:@"email"]) {
//                NSLog(@"email: %@", [result objectForKey:@"email"]);
//            }
//            if([result objectForKey:@"first_name"]) {
//                NSLog(@"first_name: %@", [result objectForKey:@"first_name"]);
//            }
//            if([result objectForKey:@"last_name"]) {
//                NSLog(@"last_name: %@", [result objectForKey:@"last_name"]);
//            }
//            if([result objectForKey:@"picture"]) {
//                NSLog(@"picture: %@", [result objectForKey:@"picture"]);
//            }
//            if([result objectForKey:@"gender"]) {
//                NSLog(@"gender: %@", [result objectForKey:@"gender"]);
//            }
//        }
//    }];
//}

//- (void)fetchUserInfo {
//    FBSDKGraphRequest *requestMe = [[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields":@"id, name, email"}];
//
//    FBSDKGraphRequestConnection *connection = [[FBSDKGraphRequestConnection alloc] init];
//    [connection addRequest:requestMe completionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
//
//        if(result) {
//            if([result objectForKey:@"email"]) {
//                NSLog(@"Email: %@", [result objectForKey:@"email"]);
//            }
//            if([result objectForKey:@"name"]) {
//                NSLog(@"Name: %@", [result objectForKey:@"name"]);
//            }
//            if([result objectForKey:@"id"]) {
//                NSLog(@"User id: %@", [result objectForKey:@"id"]);
//            }
//        }
//    }];
//
//    [connection start];
//
//    [self.facebookLoginButton setTitle:@"Logout" forState:UIControlStateNormal];
//
//    NoteViewController *viewController = [[NoteViewController alloc] initWithNibName:@"NoteViewController" bundle:nil];
//    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
//
//    [[UIApplication sharedApplication].keyWindow setRootViewController:navigationController];
//    [self presentViewController:navigationController animated:YES completion:nil];
//}

@end
