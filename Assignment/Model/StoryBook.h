//
//  StoryBook.h
//  Assignment
//
//  Created by NguyenDinh.Long on 6/17/17.
//  Copyright © 2017 NguyenDinh.Long. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StoryBook : NSObject

@property(nonatomic, strong) NSString *path;
@property(nonatomic, strong) NSString *name;
@property(nonatomic, strong) NSArray *pages;
@property(nonatomic, assign) int index;

- (id)initWithPath:(NSString*) path;

@end
