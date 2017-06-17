//
//  HomeViewController.m
//  Assignment
//
//  Created by NguyenDinh.Long on 6/16/17.
//  Copyright © 2017 NguyenDinh.Long. All rights reserved.
//

#import "HomeViewController.h"
#import "Download.h"
#import "FileManager.h"
#import "Define.h"
#import "SSZipArchive.h"


@interface HomeViewController ()<NSURLSessionDownloadDelegate> {
  NSDictionary *activeDownload;
}

@end

@implementation HomeViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.automaticallyAdjustsScrollViewInsets = NO;
  [self configURLSession];
  [self downloadZipFileWithURL:SERVER_URL_DATA];
  
  //dummy
  self.dataSource = [[NSMutableArray alloc]initWithArray:@[@"Hot", @"Popular", @"Legendary", @"Love"]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 url: The url that including json to download data source
 */
- (void)downloadZipFileWithURL:(NSString*) urlString {
  NSURL *dataUrl = [NSURL URLWithString:urlString];
  Download *downloadJsonData = [[Download alloc]initWithURL:urlString];
  downloadJsonData.downloadTask = [self.downloadsSession downloadTaskWithURL:dataUrl];
  [downloadJsonData.downloadTask resume];
  downloadJsonData.isDownloading = true;
  downloadJsonData.type = Anime;
}

- (void)configURLSession {
  NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
  self.downloadsSession = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:nil];
}

#pragma mark - NSURLSessionDownloadDelegate
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location{
  NSLog(@"Finish download URL: %@",downloadTask.originalRequest.URL.absoluteString);
  
  //move to MANGA FOLDER
  NSString *mangaFolder = [[FileManager shareInstance] getOrCreateMangaDirectory];
  NSURL *desURL = [NSURL URLWithString:mangaFolder];
  // Get the file name and create a destination URL
  NSString *sendingFileName = [downloadTask.originalRequest.URL lastPathComponent];
  [self.dataSource addObject:[sendingFileName stringByDeletingPathExtension]];
  [[FileManager shareInstance] moveFileAtPath:location toFolder:FOLDER_MANGA withName:sendingFileName];
  NSLog(@"Saved At: %@/%@", [desURL path],sendingFileName);
  
  //upzip and delete old file
  NSString *pathZip = [NSString stringWithFormat:@"%@/%@",[desURL path],sendingFileName];
  [[FileManager shareInstance] unzipAndDeleteFile:pathZip toDestination:[desURL path] isDeleteOldFile:YES];
}


-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
  NSLog(@"%lld",bytesWritten);
  NSLog(@"%lld",totalBytesWritten);
  NSLog(@"%lld",totalBytesExpectedToWrite);
}


-(void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
  NSLog(@"Error: %@",error);
}

@end
