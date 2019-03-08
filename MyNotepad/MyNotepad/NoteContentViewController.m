//
//  NoteContentViewController.m
//  MyNotepad
//
//  Created by 김명유 on 06/03/2019.
//  Copyright © 2019 김명유. All rights reserved.
//

#import "NoteContentViewController.h"
#import "AppDelegate.h"

@interface NoteContentViewController ()

@property (strong, nonatomic) IBOutlet UITextView *textView;

@end

@implementation NoteContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.textView.text = self.note.text;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)viewWillDisappear:(BOOL)animated {
    if (_textView.text == nil || [_textView.text isEqualToString:@""]) {
        NSManagedObjectContext *context = AppDelegate.persistentContainer.viewContext;
    
        [context deleteObject:self.note];
    }
    else {
        [self updateNote];
    }
}

-(void)updateNote {
    self.note.text = self.textView.text;
    self.note.editDate = [NSDate date];
    
    [((AppDelegate *)[[UIApplication sharedApplication] delegate]) saveContext];
}

@end
