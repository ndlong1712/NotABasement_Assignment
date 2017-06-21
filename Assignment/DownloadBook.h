//
//  DownloadHelper.h
//  Assignment
//
//  Created by NguyenDinh.Long on 6/16/17.
//  Copyright © 2017 NguyenDinh.Long. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DownloadImage.h"

typedef NS_ENUM(NSUInteger, Type) {
  Anime,
  Manga,
};

@interface DownloadBook : NSObject <NSCoding>

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *path;
@property (nonatomic, assign) BOOL isDownloading;
@property (nonatomic, assign) float progress;
@property (nonatomic, assign) int index;

@property (nonatomic, strong) NSMutableArray *URLsSource;
@property (nonatomic, strong) NSMutableArray *pages;
@property (nonatomic, assign) BOOL isSelected;

- (id)initWithURL:(NSString*) url;
 

@end
