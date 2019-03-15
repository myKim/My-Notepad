//
//  NoteViewController.m
//  MyNotepad
//
//  Created by 김명유 on 05/03/2019.
//  Copyright © 2019 김명유. All rights reserved.
//

#import "NoteViewController.h"
#import "NoteContentViewController.h"
#import "NoteTableViewCell.h"
#import "AppDelegate.h"
#import "LoginViewController.h"

// Frameworks
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>


@interface NoteViewController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *messageLabelItem;
@property (strong, nonatomic) UILabel *messageLabel;

@property (strong, nonatomic) NSMutableArray<Note *> *noteArray;
@property (strong, nonatomic) FBSDKProfile *fbSdkProfile;

@end


@implementation NoteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Set Layout
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    UINib *nib = [UINib nibWithNibName:@"NoteTableViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"NoteTableViewCellIdentifier"];
    
    self.tableView.estimatedRowHeight = 85.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    // Set Message Label
    self.messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 35)];
    [self.messageLabel setFont:[UIFont systemFontOfSize:12]];
    self.messageLabel.textAlignment = NSTextAlignmentCenter;
    self.messageLabelItem.customView = self.messageLabel;
    
    // Set user data.
    dispatch_async(dispatch_get_main_queue(), ^{
        [FBSDKProfile loadCurrentProfileWithCompletion:^(FBSDKProfile *profile, NSError *error) {
            
            if(profile) {
                self.fbSdkProfile = profile;
                
                // Set user's profile name.
                self.navigationItem.title = [NSString stringWithFormat:@"[%@]님의 메모장", profile.name];
                NSURL *imageUrl = [profile imageURLForPictureMode:FBSDKProfilePictureModeSquare size:CGSizeMake(35, 35)];
                
                // Set user's profile image.
                UIView *profileView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 35, 35)];
                profileView.layer.cornerRadius = profileView.frame.size.width / 2;
                profileView.clipsToBounds = YES;
                profileView.userInteractionEnabled = YES;
                UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onProfileImageTapped:)];
                [profileView addGestureRecognizer:gestureRecognizer];
                
                UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageUrl]];
                UIImageView * imageView = [[UIImageView alloc] initWithImage:image];
                [profileView addSubview:imageView];
                
                UIBarButtonItem *profileImageItem = [[UIBarButtonItem alloc] initWithCustomView:profileView];
                self.navigationItem.leftBarButtonItem = profileImageItem;
                
                // Set logout button.
                UIBarButtonItem *logoutButtonItem = [[UIBarButtonItem alloc] init];
                logoutButtonItem.title = @"Logout";
                [logoutButtonItem setTarget:self];
                [logoutButtonItem setAction:@selector(onLogoutButtonClicked:)];
                self.navigationItem.rightBarButtonItem = logoutButtonItem;
                
                // Load data from database.
                [self loadData];
            }
        }];
    });
}


#pragma mark - Event handlers
- (void)onProfileImageTapped:(id)sender {
    NSLog(@"Event: The Profile image is tapped.");
}
         
- (void)onLogoutButtonClicked:(id)sender {
    NSLog(@"Event: Logout button is clicked.");
    FBSDKLoginManager *loginManager = [[FBSDKLoginManager alloc] init];
    [loginManager logOut];
    
    // Send user back to LoginViewController.
    LoginViewController *viewController = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    [self presentViewController:viewController animated:YES completion:nil];
}


- (void)updateMemoCountMessage {
    NSInteger noteCount = self.noteArray ? self.noteArray.count : 0;
    
    NSString *message = [[@(noteCount) stringValue] stringByAppendingString:@"개의 노트"];
    
    self.messageLabel.text = message;
}

- (void)viewWillAppear:(BOOL)animated {
    if(self.fbSdkProfile) {
        [self loadData];
    }
}

- (void)loadData {
    // get context (suitable only for use on the main queue)
    NSManagedObjectContext *context = AppDelegate.persistentContainer.viewContext;
    
    // get data
    __block NSArray<Note *> * result = nil;
    [context performBlockAndWait:^{
        NSFetchRequest *request = [Note fetchRequest];
        // id check
        NSLog(@"my profile: %@", self.fbSdkProfile);
        
        request.predicate = [NSPredicate predicateWithFormat:@"facebookId = %@", self.fbSdkProfile.userID];
        NSSortDescriptor *regDateSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"regDate" ascending:YES];
        request.sortDescriptors = @[regDateSortDescriptor];
        NSError *error = nil;
        
        result = [context executeFetchRequest:request error:&error];
        if(error) {
            NSLog(@"Unresolved Error : %@", error);
        }
    }];
    
    self.noteArray = [result mutableCopy];
    [self.tableView reloadData];
    
    [self updateMemoCountMessage];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.noteArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Get note data
    Note *note = self.noteArray[indexPath.row];
    NSString *noteText = note.text;
    NSString *noteEditDate = [self convertDateToString:note.editDate];
    
    // Set note data on cell
    NoteTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NoteTableViewCellIdentifier"];
    
    cell.noteText.text = noteText;
    cell.noteEditDate.text = noteEditDate;
    
    return cell;
}

- (NSString *)convertDateToString:(NSDate *)date {
    NSString *text = @"";
    
    if(date != nil) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
        text = [dateFormatter stringFromDate:date];
    }
    return text;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    // Set section titles
    NSString *title;
    switch (section) {
        case 0:
            title = @"Notes";
            break;
        default:
            title = @"";
            break;
    }
    return title;
}

// for delete row
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if(editingStyle == UITableViewCellEditingStyleDelete) {
        Note *note = self.noteArray[indexPath.row];
        
        // Remove note item in array
        [self.noteArray removeObjectAtIndex:indexPath.row];
        
        // Remove note item in UITableView
        [tableView beginUpdates];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [tableView endUpdates];
        
        // Remove note item in core data context
        NSManagedObjectContext *context = AppDelegate.persistentContainer.viewContext;
        [context deleteObject:note];
        [((AppDelegate *)[[UIApplication sharedApplication] delegate]) saveContext];
        
        [self updateMemoCountMessage];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Deselect row
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    // Get selected note
    Note *note = self.noteArray[indexPath.row];

    // Show note content view
    NoteContentViewController *viewController = [[NoteContentViewController alloc] initWithNibName:@"NoteContentViewController" bundle:nil];
    viewController.note = note;
    [self.navigationController pushViewController:viewController animated:YES];
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return 80.0f;
//}

// Action Event Callback Methods
- (IBAction)onAddButtonClicked:(id)sender {
    NSLog(@"Add button Clicked");
    
    // Create a note object
    NSManagedObjectContext *context = AppDelegate.persistentContainer.viewContext;
    
    Note *note = [[Note alloc] initWithContext:context];
    note.text = @"";
    NSDate *currentDate = [NSDate date];
    note.regDate = currentDate;
    note.editDate = currentDate;
    note.facebookId = self.fbSdkProfile ? self.fbSdkProfile.userID : @"";
    
    // Show note content view
    NoteContentViewController *viewController = [[NoteContentViewController alloc] initWithNibName:@"NoteContentViewController" bundle:nil];
    viewController.note = note;
    [self.navigationController pushViewController:viewController animated:YES];
}

@end
