//
//  DownloadHelper.m
//  Assignment
//
//  Created by NguyenDinh.Long on 6/16/17.
//  Copyright © 2017 NguyenDinh.Long. All rights reserved.
//

#import "Download.h"

@implementation Download

- (id)initWithURL:(NSString*) url {
  
  self = [super init];
  if (self) {
    self.url = url;
      self.downloadImages = [[NSMutableArray alloc] init];
    return self;
  }
  return nil;
}


@end
