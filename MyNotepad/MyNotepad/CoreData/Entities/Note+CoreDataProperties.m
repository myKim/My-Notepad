//
//  Note+CoreDataProperties.m
//  MyNotepad
//
//  Created by 김명유 on 06/03/2019.
//  Copyright © 2019 김명유. All rights reserved.
//
//

#import "Note+CoreDataProperties.h"

@implementation Note (CoreDataProperties)

+ (NSFetchRequest<Note *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"Note"];
}

@dynamic editDate;
@dynamic regDate;
@dynamic text;

@end
