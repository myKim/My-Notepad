//
//  NoteViewController.m
//  MyNotepad
//
//  Created by 김명유 on 05/03/2019.
//  Copyright © 2019 김명유. All rights reserved.
//

#import "NoteViewController.h"
#import "NoteContentViewController.h"
#import "AppDelegate.h"

@interface NoteViewController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray<Note *> *noteArray;

@end

@implementation NoteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

- (void)viewWillAppear:(BOOL)animated {
    NSLog(@"viewWillApppear");
    
    [self loadData];
}

- (void)loadData {
    // get persistentContainer
    //    NSPersistentContainer *container = ((AppDelegate *)[[UIApplication sharedApplication] delegate]).persistentContainer;
    NSPersistentContainer *container = [AppDelegate persistentContainer];
    
    // get context (suitable only for use on the main queue)
    NSManagedObjectContext *context = container.viewContext;
    
    // get Data
    __block NSArray<Note *> * result = nil;
    [context performBlockAndWait:^{
        NSFetchRequest *request = [Note fetchRequest];
        NSSortDescriptor *regDateSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"regDate" ascending:YES];
        request.sortDescriptors = @[regDateSortDescriptor];
        NSError *error = nil;
        
        result = [context executeFetchRequest:request error:&error];
        if(error) {
            NSLog(@"Unresolved Error : %@", error);
        }
    }];
    self.noteArray = result;
    
    [self.tableView reloadData];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _noteArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cellIdentifier";
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    NSString *text;
    text = _noteArray[indexPath.row].text;
    
    NSDate *date = _noteArray[indexPath.row].editDate;
//    if(date != nil) {
//        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//        [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
//        text = [dateFormatter stringFromDate:date];
//    }
    cell.textLabel.text = text;
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // deselect row
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    /////////////////////
    Note *note = _noteArray[indexPath.row];

    NoteContentViewController *viewController = [[NoteContentViewController alloc] initWithNibName:@"NoteContentViewController" bundle:nil];

    viewController.note = note;

    [self.navigationController pushViewController:viewController animated:YES];
    /////////////////////
    
//    NSManagedObjectContext *context = AppDelegate.persistentContainer.viewContext;
//
//    [context deleteObject:note];
//    [self loadData];
    
}

- (IBAction)onAddButtonClicked:(UIBarButtonItem *)sender {
    NSLog(@"Add button Clicked");
    
    NSManagedObjectContext *context = AppDelegate.persistentContainer.viewContext;
    
    Note *note = [[Note alloc] initWithContext:context];
    note.text = @"";
    note.regDate = [NSDate date];
    note.editDate = [NSDate date];
    
    
    
//    _noteArray = [_noteArray arrayByAddingObject:note];
//    [_noteArray addObject:note];
    
////    _noteArray = [_noteArray arrayByAddingObject:note];
//
    NoteContentViewController *viewController = [[NoteContentViewController alloc] initWithNibName:@"NoteContentViewController" bundle:nil];

    viewController.note = note;

    [self.navigationController pushViewController:viewController animated:YES];
}

@end
