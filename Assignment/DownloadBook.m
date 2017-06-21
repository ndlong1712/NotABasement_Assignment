//
//  DownloadHelper.m
//  Assignment
//
//  Created by NguyenDinh.Long on 6/16/17.
//  Copyright © 2017 NguyenDinh.Long. All rights reserved.
//

#import "DownloadBook.h"

@implementation DownloadBook


- (id)initWithURL:(NSString*) url {
  
  self = [super init];
  if (self) {
    self.path = url;
    self.pages = [[NSMutableArray alloc] init];
    self.URLsSource = [[NSMutableArray alloc] init];
    return self;
  }
  return nil;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
  [encoder encodeObject:self.name forKey:@"name"];
  [encoder encodeObject:self.path forKey:@"path"];
  [encoder encodeInt:self.index forKey:@"index"];
  [encoder encodeFloat:self.progress forKey:@"progress"];
  [encoder encodeBool:self.isDownloading forKey:@"isDownloading"];
  [encoder encodeBool:self.isSelected forKey:@"isSelected"];
  [encoder encodeObject:self.URLsSource forKey:@"URLsSource"];
  [encoder encodeObject:self.pages forKey:@"pages"];
}

- (id)initWithCoder:(NSCoder *)decoder {
  if((self = [super init])) {
    self.name = [decoder decodeObjectForKey:@"name"];
    self.path = [decoder decodeObjectForKey:@"path"];
    self.index = [decoder decodeIntForKey:@"index"];
    self.progress = [decoder decodeFloatForKey:@"progress"];
    self.isDownloading = [decoder decodeBoolForKey:@"isDownloading"];
    self.isSelected = [decoder decodeBoolForKey:@"isSelected"];
    self.pages = [decoder decodeObjectForKey:@"pages"];
    self.URLsSource = [decoder decodeObjectForKey:@"URLsSource"];
  }
  return self;
}

@end
