//
//  NoteContentViewController.h
//  MyNotepad
//
//  Created by 김명유 on 06/03/2019.
//  Copyright © 2019 김명유. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Note+CoreDataProperties.h"


@interface NoteContentViewController : UIViewController

@property (strong, nonatomic) Note *note;

@end
