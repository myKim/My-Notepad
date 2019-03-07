//
//  Note+CoreDataProperties.h
//  MyNotepad
//
//  Created by 김명유 on 06/03/2019.
//  Copyright © 2019 김명유. All rights reserved.
//
//

#import "Note+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Note (CoreDataProperties)

+ (NSFetchRequest<Note *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSDate *editDate;
@property (nullable, nonatomic, copy) NSDate *regDate;
@property (nullable, nonatomic, copy) NSString *text;

@end

NS_ASSUME_NONNULL_END
