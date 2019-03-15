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

- (void)viewWillDisappear:(BOOL)animated {
    if (self.textView.text == nil || [self.textView.text isEqualToString:@""]) {
        NSManagedObjectContext *context = AppDelegate.persistentContainer.viewContext;
    
        [context deleteObject:self.note];
    }
    else {
        [self updateNote];
    }
}


#pragma mark - Methods

-(void)updateNote {
    self.note.text = self.textView.text;
    self.note.editDate = [NSDate date];
    
    [((AppDelegate *)[[UIApplication sharedApplication] delegate]) saveContext];
}

@end
