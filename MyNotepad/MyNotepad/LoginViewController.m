//
//  LoginViewController.m
//  MyNotepad
//
//  Created by 김명유 on 05/03/2019.
//  Copyright © 2019 김명유. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)onTestButtonClicked:(UIButton *)sender {
    NoteViewController *viewController = [[NoteViewController alloc] initWithNibName:@"NoteViewController" bundle:nil];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
    
    [[UIApplication sharedApplication].keyWindow setRootViewController:navigationController];
    [self presentViewController:navigationController animated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
