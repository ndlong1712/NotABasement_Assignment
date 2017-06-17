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

#define Pause @"Pause"
#define Resume @"Resume"

@interface ListMangaViewController ()<NSURLSessionDownloadDelegate> {
  NSMutableDictionary *listActiveDownload;
  NSOperationQueue *queue;
  int maxOperations;
  UIBarButtonItem *rightButton;
}

@end

@implementation ListMangaViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.automaticallyAdjustsScrollViewInsets = NO;
  listActiveDownload = [[NSMutableDictionary alloc] init];
  [self addRightButtonOnNavigation];
  maxOperations = self.sliderNumberThread.value;
  [self configURLSession];
  [self testt];
  
}

-(void)addRightButtonOnNavigation {
  rightButton = [[UIBarButtonItem alloc]
                                 initWithTitle:Pause
                                 style:UIBarButtonItemStylePlain
                                 target:self
                                 action:@selector(didTapRightButton)];
  self.navigationItem.rightBarButtonItem = rightButton;
}

-(void)didTapRightButton {
  if ([[rightButton title] isEqualToString:Pause]) {
    [rightButton setTitle:Resume];
    for (NSBlockOperation *block in queue.operations) {
      
    }
  } else {
    [rightButton setTitle:Pause];
    [queue setMaxConcurrentOperationCount:0];
//    queue.maxConcurrentOperationCount = self.sliderNumberThread.value;
  }
}

-(void)testt {
  queue = [[NSOperationQueue alloc] init];
  queue.maxConcurrentOperationCount = self.sliderNumberThread.value;
  
  for (StoryBook* book in self.dataSource) {
    [[FileManager shareInstance] getDirectoryOrCreate:[NSString stringWithFormat:@"%@/%@",FOLDER_MANGA,[book.name stringByDeletingPathExtension]]];
    NSBlockOperation *currentOperation = [NSBlockOperation blockOperationWithBlock:^{
      [self startDownLoad:book];
    }];
    if ( queue.operations.count != 0 )
    [currentOperation addDependency:[queue.operations lastObject]];
    [queue addOperation:currentOperation];
  }
  
}


-(void)startDownLoad:(StoryBook*) book {
  Download *downloadBook = [[Download alloc]initWithURL:book.path];
  downloadBook.isDownloading = true;
  downloadBook.name = book.name;
  downloadBook.index = book.index;
  downloadBook.downloadImages = book.pages;
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

#pragma mark - Action
- (IBAction)dragSliderBar:(id)sender {
  if ((int)self.sliderNumberThread.value != maxOperations) {
    NSLog(@"Max operations:%d",(int)self.sliderNumberThread.value);
    maxOperations = (int)self.sliderNumberThread.value;
    self.lbMaxNumber.text = [NSString stringWithFormat:@"%d",(int)self.sliderNumberThread.value];
    queue.maxConcurrentOperationCount = (int)self.sliderNumberThread.value;
  }
  
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
  
  //update progress
  dispatch_async(dispatch_get_main_queue(), ^{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:dObj.index inSection:0];
    ListMangaTableViewCell *cell = (ListMangaTableViewCell*)[self.tableView cellForRowAtIndexPath:indexPath];
    NSLog(@"%f",dObj.progress);
    dObj.progress += 1.0 / (float)dObj.downloadImages.count;
    cell.viewProgress.progress = dObj.progress;
    if (cell.viewProgress.progress >= 0.95) {
      cell.lbStatus.text = STATUS_FINISHED;
    } else {
      cell.lbStatus.text = STATUS_DOWNLOADING;
    }
  });
  
}


-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
  
}


-(void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
  NSLog(@"Error: %@",error);
}



@end
