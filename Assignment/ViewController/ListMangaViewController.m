//
//  ListMangaViewController.m
//  Assignment
//
//  Created by NguyenDinh.Long on 6/16/17.
//  Copyright © 2017 NguyenDinh.Long. All rights reserved.
//

#import "ListMangaViewController.h"
#import "ListMangaTableViewCell.h"
#import "StoryBook.h"
#import "FileManager.h"
#import "Define.h"
#import "Download.h"

@interface ListMangaViewController ()<NSURLSessionDownloadDelegate> {
  NSMutableDictionary *listActiveDownload;
}

@end

@implementation ListMangaViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.automaticallyAdjustsScrollViewInsets = NO;
  listActiveDownload = [[NSMutableDictionary alloc] init];
  [self configURLSession];
  [self testt];
  
}

-(void)testt {
  NSOperationQueue *queue = [[NSOperationQueue alloc] init];
  queue.maxConcurrentOperationCount = 5;

  NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
    for (StoryBook* book in self.dataSource) {
      [[FileManager shareInstance] getDirectoryOrCreate:[NSString stringWithFormat:@"%@/%@",FOLDER_MANGA,[book.name stringByDeletingPathExtension]]];
      [self startDownLoad:book];
    }
  }];
  
  [queue addOperation:operation];

}


-(void)startDownLoad:(StoryBook*) book {
  Download *downloadBook = [[Download alloc]initWithURL:book.path];
  downloadBook.isDownloading = true;
  downloadBook.name = book.name;
  [listActiveDownload setObject:downloadBook forKey:book.name];
  for (NSString *urlStr in book.pages) {
    NSURL *url = [NSURL URLWithString:urlStr];
    DownloadImage *downloadPage = [[DownloadImage alloc]initWithURL:urlStr];
    downloadPage.downloadTask = [self.downloadsSession downloadTaskWithURL:url];
    downloadPage.nameBook = book.name;
    [downloadPage.downloadTask resume];
    downloadPage.isDownloading = true;
    [listActiveDownload setObject:downloadPage forKey:urlStr];
  }
  
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

- (void)configURLSession {
  NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
  self.downloadsSession = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:nil];
}

#pragma mark - NSURLSessionDownloadDelegate
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location{
  
  DownloadImage *dImg = [listActiveDownload objectForKey:downloadTask.originalRequest.URL.absoluteString];
  
  NSLog(@"%@ :Finish download URL: %@",dImg.nameBook,downloadTask.originalRequest.URL.absoluteString);
  Download *dObj = [listActiveDownload objectForKey:dImg.nameBook];
  
  //move to MANGA FOLDER
  NSString *mangaFolder = [[FileManager shareInstance] getOrCreateMangaDirectory];
  NSURL *desURL = [NSURL URLWithString:mangaFolder];
  // Get the file name and create a destination URL
  NSString *sendingFileName = [downloadTask.originalRequest.URL lastPathComponent];
  [[FileManager shareInstance] moveFileAtPath:location toFolder:[NSString stringWithFormat:@"%@/%@",FOLDER_MANGA,[dObj.name stringByDeletingPathExtension]] withName:sendingFileName];
  NSLog(@"Image Saved At: %@/%@", [desURL path],sendingFileName);
  
  
}


-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
  
  //  NSLog(@"%lld",bytesWritten);
  //  NSLog(@"%lld",totalBytesWritten);
  //  NSLog(@"%lld",totalBytesExpectedToWrite);
}


-(void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
  NSLog(@"Error: %@",error);
}



@end
