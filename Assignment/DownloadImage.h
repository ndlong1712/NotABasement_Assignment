//
//  DownloadImage.h
//  Assignment
//
//  Created by NguyenDinh.Long on 6/17/17.
//  Copyright © 2017 NguyenDinh.Long. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DownloadBook.h"

@interface DownloadImage : NSObject<NSCoding>

@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *nameBook;
@property (nonatomic, assign) BOOL isDownloading;
@property (nonatomic, assign) float progress;
@property (nonatomic, assign) int index;
@property (nonatomic, strong) NSString *imgFilePath;

@property (nonatomic, strong) NSURLSessionDownloadTask *downloadTask;
@property (nonatomic, strong) NSData *resumeData;

- (id)initWithURL:(NSString*) url;

@end
