//
//  LoginViewController.m
//  MyNotepad
//
//  Created by 김명유 on 05/03/2019.
//  Copyright © 2019 김명유. All rights reserved.
//

#import "LoginViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@interface LoginViewController ()
{
    BOOL isLoggedIn;
}
@property (weak, nonatomic) IBOutlet UIButton *facebookLoginButton;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    isLoggedIn = NO;
    
    FBSDKLoginButton *loginButton = [[FBSDKLoginButton alloc] init];
//    // Optional: Place the button in the center of your view.
//    loginButton.center = self.view.center;
//    [self.view addSubview:loginButton];
}

- (IBAction)onFacebookLoginButtonClicked:(UIButton *)sender {
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    
    if(isLoggedIn) {
        [login logOut];
        [FBSDKAccessToken setCurrentAccessToken:nil];
        
        isLoggedIn = NO;
        
        [self.facebookLoginButton setTitle:@"Facebook Login" forState:UIControlStateNormal];
    }
    else {
        [login logInWithReadPermissions:@[@"email"]
                     fromViewController:self
                                handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
                                    if(error) {
                                        NSLog(@"Process error");
                                    }
                                    else if(result.isCancelled) {
                                        NSLog(@"Cancelled");
                                    }
                                    else {
                                        NSLog(@"Logged in");
                                        
                                        if([result.grantedPermissions containsObject:@"email"]) {
                                            NSLog(@"result is: %@", result);
                                            [self fetchUserInfo];
                                        }
                                    }
                                }
         ];
    }
}

-(void)fetchUserInfo {
    FBSDKGraphRequest *requestMe = [[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields":@"id, name, email"}];
    
    FBSDKGraphRequestConnection *connection = [[FBSDKGraphRequestConnection alloc] init];
    [connection addRequest:requestMe completionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
        
        if(result) {
            if([result objectForKey:@"email"]) {
                NSLog(@"Email: %@", [result objectForKey:@"email"]);
            }
            if([result objectForKey:@"name"]) {
                NSLog(@"Name: %@", [result objectForKey:@"name"]);
            }
            if([result objectForKey:@"id"]) {
                NSLog(@"User id: %@", [result objectForKey:@"id"]);
            }
        }
    }];
    
    [connection start];
    
    isLoggedIn = YES;
    
    [self.facebookLoginButton setTitle:@"Logout" forState:UIControlStateNormal];
    
    NoteViewController *viewController = [[NoteViewController alloc] initWithNibName:@"NoteViewController" bundle:nil];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
    
    [[UIApplication sharedApplication].keyWindow setRootViewController:navigationController];
    [self presentViewController:navigationController animated:YES completion:nil];
}

- (IBAction)onTestButtonClicked:(UIButton *)sender {
    NoteViewController *viewController = [[NoteViewController alloc] initWithNibName:@"NoteViewController" bundle:nil];
    UINavigationController  *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
    
    [[UIApplication sharedApplication].keyWindow setRootViewController:navigationController];
    [self presentViewController:navigationController animated:YES completion:nil];
}

@end
