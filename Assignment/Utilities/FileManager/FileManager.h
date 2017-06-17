//
//  FileManager.h
//  Assignment
//
//  Created by NguyenDinh.Long on 6/16/17.
//  Copyright © 2017 NguyenDinh.Long. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileManager : NSObject

+ (FileManager *)shareInstance;
- (BOOL)createFolderAtPath: (NSString *)pathFromDocument;
- (void)deleteData: (NSString *)url;

- (NSString *)getOrCreateMangaDirectory: (NSString *)title;
- (NSString *)getOrCreatePDFDirectory;
- (NSString *)getOrCreateZIPDirectory;
- (NSString *)getOrCreateJSONDirectory;
- (NSString *)getOrCreateMangaDirectory;
- (NSArray*)getListFilesInPath: (NSString*) path;
- (NSString *)getDirectoryOrCreate: (NSString *)dirName;
- (BOOL) removeFileAtPath: (NSString *)path;
- (BOOL)unzipAndDeleteFile:(NSString *)path toDestination: (NSString*) desPath isDeleteOldFile:(BOOL) isDelete;
- (BOOL) moveFileAtPath: (NSURL*) path toFolder:(NSString *)desFolder withName: (NSString*) name;

#pragma mark - CompressFile
+(NSString*)compressFileWithName:(NSString*)nameFileZip fileToZip:(NSString*)url;


@end
