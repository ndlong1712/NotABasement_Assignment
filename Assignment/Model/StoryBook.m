//
//  StoryBook.m
//  Assignment
//
//  Created by NguyenDinh.Long on 6/17/17.
//  Copyright © 2017 NguyenDinh.Long. All rights reserved.
//

#import "StoryBook.h"

@implementation StoryBook

- (id)initWithPath:(NSString*) path{
  
  self = [super init];
  if (self) {
    self.path = path;
    return self;
  }
  return nil;
}

@end
