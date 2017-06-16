//
//  FileManager.m
//  Assignment
//
//  Created by NguyenDinh.Long on 6/16/17.
//  Copyright © 2017 NguyenDinh.Long. All rights reserved.
//

#import "FileManager.h"
#import "Define.h"
#import "SSZipArchive.h"

@interface FileManager ()
{
  NSString *_documentPath;
}

@end


// FOLDER STRUCTURE INSIDE DOCUMENT FOLDER:
//  Documents --| Manga1     |- Thumb
//                           |- Drv
//                           |- Video
//
//              | Manga2     |- Thumb
//                           |- Drv
//                           |- Video
//


static FileManager *instance = nil;

@implementation FileManager

+ (FileManager *)shareInstance {
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    instance = [[FileManager alloc] init];
  });
  return instance;
}

- (instancetype)init {
  if (self = [super init]) {
    _documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
  }
  return self;
}

- (BOOL)createFolderAtPath: (NSString *)pathFromDocument {
  NSString *folderPath = [_documentPath stringByAppendingPathComponent:pathFromDocument];
  NSFileManager *fm = [NSFileManager defaultManager];
  BOOL isDirectory;
  BOOL isExisting = [fm fileExistsAtPath:folderPath isDirectory:&isDirectory];
  
  if (isExisting) {
    NSLog(@"File existing, is directory? %@", isDirectory ? @"YES" : @"NO");
    return isDirectory;
  }
  
  NSError *error;
  [fm createDirectoryAtPath:folderPath withIntermediateDirectories:NO attributes:nil error:&error];
  if (error) {
    NSLog(@"Create file with Error: %@", error);
    return NO;
  }
  return YES;
}

- (void)deleteData:(NSString *)url{
  NSString *path = [_documentPath stringByAppendingPathComponent:url];
  NSFileManager *fm = [NSFileManager defaultManager];
  NSError *error;
  [fm removeItemAtPath:path error:&error];
  NSLog(@"Delete data, error: %@", error);
}


- (NSString *)getOrCreateMangaDirectory: (NSString *)title {
  return [self getDirectoryOrCreate:[title stringByAppendingPathComponent:FOLDER_HOT_MANGA]];
}

- (NSString *)getOrCreateZIPDirectory {
  return [self getDirectoryOrCreate:FOLDER_ZIP];
}

- (NSString *)getOrCreatePDFDirectory {
  return [self getDirectoryOrCreate:FOLDER_PDF];
}

- (NSString *)getOrCreateJSONDirectory {
  return [self getDirectoryOrCreate:FOLDER_JSON];
}

- (NSString *)getOrCreateMangaDirectory {
  return [self getDirectoryOrCreate:FOLDER_MANGA];
}

- (NSArray*)getListFilesInPath: (NSString*) path{
  NSArray* dirs = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path
                                                                      error:NULL];
  NSMutableArray *mangaFiles = [[NSMutableArray alloc] init];
  [dirs enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
    NSString *filename = (NSString *)obj;
    NSString *extension = [filename pathExtension];
    if ([extension isEqualToString:@"json"]) {
      [mangaFiles addObject:[path stringByAppendingPathComponent:filename]];
    }
  }];
  return mangaFiles;
}

- (BOOL) removeFileAtPath: (NSString *)path {
  NSFileManager *fileManager = [NSFileManager defaultManager];
  NSError *error;
  BOOL success = [fileManager removeItemAtPath:path error:&error];
  return success;
}

-(BOOL)moveFileAtPath:(NSURL *)path toFolder:(NSString *)desFolder withName:(NSString *)name {
  // Create a NSFileManager instance
  NSFileManager *fileManager = [NSFileManager defaultManager];
  
  // Get the documents directory URL
  NSArray *documentURLs = [fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
  NSURL *documentsDirectory = [documentURLs firstObject];
  NSURL *destinationUrl = [documentsDirectory URLByAppendingPathComponent:[NSString stringWithFormat:@"%@/%@",desFolder, name]];

  // Hold this file as an NSData and write it to the new location
  NSData *fileData = [NSData dataWithContentsOfURL:path];
  return [fileData writeToURL:destinationUrl atomically:NO];
}

- (NSString *)getDirectoryOrCreate: (NSString *)dirName {
  NSString *path = [_documentPath stringByAppendingPathComponent:dirName];
  NSFileManager *fm = [NSFileManager defaultManager];
  if (![fm fileExistsAtPath:path]) {
    NSError *error;
    [fm createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
    if (error) {
      NSLog(@"%s %@", __PRETTY_FUNCTION__, error);
    }
  }
  return path;
}


- (long)getSizeForUploadWithFolder: (NSString *)folder extension: (NSString *)ext {
  long totalSize = 0;
  
  NSFileManager *fm = [NSFileManager defaultManager];
  NSArray *listFiles = [fm contentsOfDirectoryAtURL:[NSURL URLWithString:folder]
                         includingPropertiesForKeys:[NSArray array]
                                            options:NSDirectoryEnumerationSkipsHiddenFiles
                                              error:nil];
  for (NSURL *url in listFiles) {
    NSString *path = [url path];
    if (![[path pathExtension] isEqualToString:ext]) {
      [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
    } else {
      NSError* error;
      NSDictionary *fileDictionary = [[NSFileManager defaultManager] attributesOfItemAtPath:path error: &error];
      NSNumber *size = [fileDictionary objectForKey:NSFileSize];
      totalSize += [size longValue];
    }
  }
  return totalSize;
}



#pragma mark - compressFile

+ (NSString *)compressFileWithName:(NSString *)nameFileZip fileToZip:(NSString *)url {
  NSString *documentsDirectory = [[FileManager shareInstance] getOrCreateZIPDirectory];
  NSString *zipPath = [documentsDirectory stringByAppendingPathComponent:nameFileZip];
  NSString *zipPathName = [zipPath stringByAppendingPathExtension:ZIP_EXT];
  // Create
  
  if ([SSZipArchive createZipFileAtPath: url withContentsOfDirectory: nameFileZip]) {
    NSLog(@"zip %@ sucess!",nameFileZip);
    return zipPathName;
  }else{
    NSLog(@"zip fail!");
  }
  return nil;
}

+ (NSString *)unzipFileWithName:(NSString *)nameFileZip fileToZip:(NSString *)url {
  NSString *documentsDirectory = [[FileManager shareInstance] getOrCreateZIPDirectory];
  NSString *zipPath = [documentsDirectory stringByAppendingPathComponent:nameFileZip];
  NSString *zipPathName = [zipPath stringByAppendingPathExtension:ZIP_EXT];
  // Create
  
  if ([SSZipArchive createZipFileAtPath: url withContentsOfDirectory: nameFileZip]) {
    NSLog(@"zip %@ sucess!",nameFileZip);
    return zipPathName;
  }else{
    NSLog(@"zip fail!");
  }
  return nil;
}

- (BOOL)unzipAndDeleteFile:(NSString *)path toDestination: (NSString*) desPath isDeleteOldFile:(BOOL) isDelete{
  BOOL result = [SSZipArchive unzipFileAtPath:path toDestination:desPath overwrite:YES password:nil error:nil];
  if (isDelete) {
    [self removeFileAtPath:path];
  }
  return result;
}


@end


