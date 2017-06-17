//
//  DownloadImage.m
//  Assignment
//
//  Created by NguyenDinh.Long on 6/17/17.
//  Copyright © 2017 NguyenDinh.Long. All rights reserved.
//

#import "DownloadImage.h"

@implementation DownloadImage

- (id)initWithURL:(NSString*) url {
  
  self = [super init];
  if (self) {
    self.url = url;
    return self;
  }
  return nil;
}

@end
