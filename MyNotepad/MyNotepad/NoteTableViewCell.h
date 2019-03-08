//
//  NoteTableViewCell.h
//  MyNotepad
//
//  Created by 김명유 on 08/03/2019.
//  Copyright © 2019 김명유. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NoteTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *noteText;
@property (weak, nonatomic) IBOutlet UILabel *noteEditDate;
@end

NS_ASSUME_NONNULL_END
