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

- (void)encodeWithCoder:(NSCoder *)encoder {
  [encoder encodeObject:self.url forKey:@"url"];
  [encoder encodeObject:self.nameBook forKey:@"nameBook"];
  [encoder encodeBool:self.isDownloading forKey:@"isDownloading"];
  [encoder encodeFloat:self.progress forKey:@"progress"];
  [encoder encodeObject:self.imgFilePath forKey:@"imgFilePath"];
  [encoder encodeInt:self.index forKey:@"index"];
  [encoder encodeObject:self.resumeData forKey:@"resumeData"];
}

- (id)initWithCoder:(NSCoder *)decoder {
  if((self = [super init])) {
    self.index = [decoder decodeIntForKey:@"index"];
    self.url = [decoder decodeObjectForKey:@"url"];
    self.nameBook = [decoder decodeObjectForKey:@"nameBook"];
    self.isDownloading = [decoder decodeBoolForKey:@"isDownloading"];
    self.progress = [decoder decodeFloatForKey:@"progress"];
    self.imgFilePath = [decoder decodeObjectForKey:@"imgFilePath"];
    self.resumeData = [decoder decodeObjectForKey:@"resumeData"];
  }
  return self;
}


@end
