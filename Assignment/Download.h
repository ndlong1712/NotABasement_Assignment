//
//  DownloadHelper.h
//  Assignment
//
//  Created by NguyenDinh.Long on 6/16/17.
//  Copyright © 2017 NguyenDinh.Long. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, Type) {
  Anime,
  Manga,
};

@interface Download : NSObject

@property (nonatomic, strong) NSString *url;
@property (nonatomic, assign) Boolean isDownloading;
@property (nonatomic, assign) float progress;

@property (nonatomic, strong) NSURLSessionDownloadTask *downloadTask;
@property (nonatomic, strong) NSData *resumeData;
@property (nonatomic, assign) Type type;

- (id)initWithURL:(NSString*) url;
 

@end
