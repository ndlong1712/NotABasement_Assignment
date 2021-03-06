//
//  ListMangaViewController.m
//  Assignment
//
//  Created by NguyenDinh.Long on 6/16/17.
//  Copyright © 2017 NguyenDinh.Long. All rights reserved.
//

#import "ListMangaViewController.h"
#import "ListMangaTableViewCell.h"
#import "FileManager.h"
#import "Define.h"
#import "DownloadBook.h"
#import "ParseJson.h"
#import "MBProgressHUD.h"
#import "Reachability.h"
#import "Utilities.h"

#define Pause @"Pause"
#define Resume @"Resume"

@interface ListMangaViewController ()<NSURLSessionDownloadDelegate> {
  NSOperationQueue *queue;
  NSMutableArray *pages;
  Reachability *reachability;
  int maxOperations;
  BOOL isDownDataSource;
  BOOL isStartDownload;
  BOOL isPause;
}

@end

@implementation ListMangaViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.automaticallyAdjustsScrollViewInsets = NO;
  
  self.listActiveDownload = [[NSMutableDictionary alloc] init];
  pages = [[NSMutableArray alloc]init];
  
  [self.btnPauseResume setEnabled:NO];
  [self.btnDelete setEnabled:NO];
  
  self.lbMaxNumber.text = @"3";
  self.sliderNumberThread.value = 3;
  maxOperations = self.sliderNumberThread.value;
  
  [self setUpReachabilityToCheckNetwork];
  [self configURLSession];
  
}

-(void)setUpReachabilityToCheckNetwork{
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(networkStateChanged:)
                                               name:kReachabilityChangedNotification object:nil];
  reachability = [Reachability reachabilityForInternetConnection];
  [reachability startNotifier];
}

//network obsever
- (void)networkStateChanged:(NSNotification *)notice {
  NetworkStatus currentNetStatus = [reachability currentReachabilityStatus];
  if (currentNetStatus == NotReachable) {
    [Utilities showAlertWithTitle:nil message:@"No network!" cancelTitle:@"Cancel" okTitle:@"Ok" inview:self];
    [self pauseAll];
    [self.btnPauseResume setEnabled:NO];
  } else {
    if (self.listActiveDownload.count > 0) {
      [self.btnPauseResume setEnabled:YES];
    }
    [self resumeAll];
  }
}

- (IBAction)deleteAll:(id)sender {
  [MBProgressHUD showHUDAddedTo:self.view animated:YES];
  [self cancelAll];
  [self.btnPauseResume setEnabled:NO];
  [self.btnAdd setEnabled:YES];
  [self.btnPauseResume setTitle:Pause];
  isPause = NO;
  double delayInSeconds = 2.5;
  dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
  dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
    [MBProgressHUD hideHUDForView:self.view animated:YES];
  });
}

- (IBAction)pauseOrResumeAll:(id)sender {
  [MBProgressHUD showHUDAddedTo:self.view animated:YES];
  if ([[self.btnPauseResume title] isEqualToString:Pause]) {
    [self.btnPauseResume setTitle:Resume];
    [self pauseAll];
    isPause = YES;
  } else {
    //check network
    if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]==NotReachable) {
      [Utilities showAlertWithTitle:nil message:@"No network!" cancelTitle:@"Cancel" okTitle:@"Ok" inview:self];
    } else {
      [self.btnPauseResume setTitle:Pause];
      [self resumeAll];
      isPause = NO;
    }
  }
  double delayInSeconds = 2.0;
  dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
  dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
    [MBProgressHUD hideHUDForView:self.view animated:YES];
  });
}

- (IBAction)addData:(id)sender {
  [self.btnPauseResume setTitle:Pause];
  isPause = NO;
  //check network
  if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]==NotReachable) {
    [Utilities showAlertWithTitle:nil message:@"No network!" cancelTitle:@"Cancel" okTitle:@"Ok" inview:self];
  } else {
    self.dataSource = [[NSMutableArray alloc]init];
    isDownDataSource = YES;
    [self.btnPauseResume setEnabled:YES];
    [self.btnDelete setEnabled:YES];
    //    [self tempFunc];
    [self downloadZipFileWithURL:SERVER_URL_DATA];
  }
}

//Pause all download task
-(void)pauseAll {
  [self.listActiveDownload enumerateKeysAndObjectsUsingBlock:^(id key, id value, BOOL* stop) {
    if ([value isKindOfClass:[DownloadImage class]]) {
      DownloadImage *download = value;
      [download.downloadTask cancel];
      download.isDownloading = false;
    }
  }];
}

//Resume all download task
-(void)resumeAll {
  [self.listActiveDownload enumerateKeysAndObjectsUsingBlock:^(id key, id value, BOOL* stop) {
    if ([value isKindOfClass:[DownloadImage class]]) {
      NSBlockOperation *currentOperation = [NSBlockOperation blockOperationWithBlock:^{
        DownloadImage *download = value;
        NSString *taskIdentifier = [key lastPathComponent];
        if (download.resumeData != nil) {
          download.downloadTask = [self.downloadsSession downloadTaskWithResumeData:download.resumeData];
        } else {
          NSURL *url = [NSURL URLWithString:download.url];
          download.downloadTask = [self.downloadsSession downloadTaskWithURL:url];
        }
        download.downloadTask.taskDescription = taskIdentifier;
        [download.downloadTask resume];
        download.isDownloading = true;
      }];
      [queue addOperation:currentOperation];
    }
  }];
}

//Cancel all downloadtask
-(void)cancelAll {
  [self.listActiveDownload enumerateKeysAndObjectsUsingBlock:^(id key, id value, BOOL* stop) {
    if ([value isKindOfClass:[DownloadImage class]]) {
      DownloadImage *download = value;
      [download.downloadTask cancel];
    }
  }];
  self.dataSource = nil;
  [self.listActiveDownload removeAllObjects];
  [self.tableView reloadData];
}

-(void)startDownloadBooks {
  queue = [[NSOperationQueue alloc] init];
  queue.maxConcurrentOperationCount = self.sliderNumberThread.value;
  
  for (DownloadBook* book in self.dataSource) {
    [[FileManager shareInstance] getDirectoryOrCreate:[NSString stringWithFormat:@"%@/%@",FOLDER_MANGA,[book.name stringByDeletingPathExtension]]];
    NSBlockOperation *currentOperation = [NSBlockOperation blockOperationWithBlock:^{
      [self startDownLoad:book];
    }];
    if ( queue.operations.count != 0 )
      [currentOperation addDependency:[queue.operations lastObject]];
    [queue addOperation:currentOperation];
  }
  
}

-(void)startDownLoad:(DownloadBook*) book {
  DownloadBook *downloadBook = [[DownloadBook alloc]initWithURL:book.path];
  downloadBook.isDownloading = true;
  downloadBook.name = book.name;
  downloadBook.index = book.index;
  
  [self.listActiveDownload setObject:downloadBook forKey:book.name];
  
  //create DownloadImage form list URLs of DownloadBook
  for (int i = 0; i < book.pages.count; i++) {
    NSString *urlString = book.pages[i];
    NSString *uniqueUrl = [NSString stringWithFormat:@"%@/%d",urlString,i];
    NSURL *url = [NSURL URLWithString:urlString];
    DownloadImage *downloadPage = [[DownloadImage alloc]initWithURL:urlString];
    downloadPage.downloadTask = [self.downloadsSession downloadTaskWithURL:url];
    downloadPage.downloadTask.taskDescription = [NSString stringWithFormat:@"%d",i];
    downloadPage.nameBook = book.name;
    [self.listActiveDownload setObject:downloadPage forKey:uniqueUrl];
    downloadPage.isDownloading = true;
    [downloadBook.pages addObject:downloadPage];
    [downloadPage.downloadTask resume];
  }
}

- (void)downloadZipFileWithURL:(NSString*) urlString {
  NSURL *dataUrl = [NSURL URLWithString:urlString];
  DownloadImage *downloadJsonData = [[DownloadImage alloc]initWithURL:urlString];
  downloadJsonData.downloadTask = [self.downloadsSession downloadTaskWithURL:dataUrl];
  [downloadJsonData.downloadTask resume];
  downloadJsonData.isDownloading = true;
  [self.listActiveDownload setObject:downloadJsonData forKey:urlString];
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
  if (self.listActiveDownload.count == 0) {
    [self.btnPauseResume setEnabled:NO];
  }
  if (isDownDataSource) {
    [self finishDownDataSource:downloadTask location:location];
    [self reloadTableView];
    isDownDataSource = NO;
    [self startDownloadBooks];
    [self removeDownloadObjectWithKey:downloadTask.originalRequest.URL.absoluteString];
  } else {
    NSString *identifierTask = downloadTask.taskDescription;
    NSString *uniqueUrl = [NSString stringWithFormat:@"%@/%@",downloadTask.originalRequest.URL.absoluteString,identifierTask];
    
    DownloadImage *dImg = [self.listActiveDownload objectForKey:uniqueUrl];
    DownloadBook *dObj = [self.listActiveDownload objectForKey:dImg.nameBook];
    NSString *mangaFolder = [[FileManager shareInstance] getOrCreateMangaDirectory];
    NSURL *desURL = [NSURL URLWithString:mangaFolder];
    NSString *sendingFileName = [downloadTask.originalRequest.URL lastPathComponent];
    dImg.imgFilePath = [NSString stringWithFormat:@"%@/%@/%@", [desURL path], [dObj.name stringByDeletingPathExtension], sendingFileName];
    dImg.isDownloading = NO;
    if (dObj.isSelected) {
      [[NSNotificationCenter defaultCenter] postNotificationName:kNotifiProgress object:dImg];
    }
    if (dObj != nil) {
      dImg.isDownloading = false;
      [self finishDownloadTask:downloadTask location:location moveDataToFolder:FOLDER_MANGA withName:[dObj.name stringByDeletingPathExtension]];
      //update progress
      dispatch_async(dispatch_get_main_queue(), ^{
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:dObj.index inSection:0];
        ListMangaTableViewCell *cell = (ListMangaTableViewCell*)[self.tableView cellForRowAtIndexPath:indexPath];
        
        dObj.progress += 1.0 / (float)dObj.pages.count;
        
        if (dObj.progress >= 0.98) {
          cell.lbStatus.text = STATUS_FINISHED;
          dObj.isDownloading = false;
        } else {
          if (![cell.lbStatus.text  isEqual: STATUS_FINISHED]) {
            cell.lbStatus.text = STATUS_DOWNLOADING;
          }
        }
        [self removeDownloadObjectWithKey:uniqueUrl];
        //        NSLog(@"Downloaded: %lu",(unsigned long)self.listActiveDownload.count);
        cell.viewProgress.progress = dObj.progress;
      });
    }
  }
}


-(void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
  if (self.listActiveDownload.count == 0) {
    [self.btnPauseResume setEnabled:NO];
  }
  if (!isDownDataSource && !isPause && [reachability currentReachabilityStatus] != NotReachable) {
    if (error.code != 0) {
      NSString *identifierTask = task.taskDescription;
      NSString *uniqueUrl = [NSString stringWithFormat:@"%@/%@",task.originalRequest.URL.absoluteString,identifierTask];
      DownloadImage *dImg = [self.listActiveDownload objectForKey:uniqueUrl];
      DownloadBook *dObj = [self.listActiveDownload objectForKey:dImg.nameBook];
      dImg.imgFilePath = @"Error";
      dImg.isDownloading = NO;
      if (dObj.isSelected) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotifiProgress object:dImg];
      }
      //update progress
      dispatch_async(dispatch_get_main_queue(), ^{
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:dObj.index inSection:0];
        ListMangaTableViewCell *cell = (ListMangaTableViewCell*)[self.tableView cellForRowAtIndexPath:indexPath];
        dObj.progress += 1.0 / (float)dObj.pages.count;
        if (dObj.progress >= 0.98) {
          cell.lbStatus.text = STATUS_FINISHED;
          dObj.isDownloading = NO;
        }
        [self removeDownloadObjectWithKey:uniqueUrl];
        cell.viewProgress.progress = dObj.progress;
      });
    }
  }
}

-(void)finishDownDataSource:(NSURLSessionDownloadTask*) downloadTask location:(NSURL*) location{
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
  [self parseJsonToDataSource];
}

//function to test with custom data
-(void)tempFunc{
  NSString *mangaFolder = [[FileManager shareInstance] getOrCreateMangaDirectory];
  NSString *pathJson = [NSString stringWithFormat:@"%@/JSON files updated/images2.json",mangaFolder];
  DownloadBook *book = [[DownloadBook alloc]initWithURL:pathJson];
  book.index = 0;
  NSArray *listPages = [ParseJson parseJsonWithPath:pathJson];
  book.pages = [listPages copy];
  NSString *nameFile = [pathJson lastPathComponent];
  book.name = nameFile;
  [self.dataSource addObject:book];
  [self reloadTableView];
  isDownDataSource = NO;
  [self startDownloadBooks];
}

-(void) parseJsonToDataSource{
  NSString *mangaFolder = [[FileManager shareInstance] getOrCreateMangaDirectory];
  NSString *pathMangaList = [mangaFolder stringByAppendingString:[NSString stringWithFormat:@"/%@",[self.dataSource lastObject]]];
  //get list file in path
  NSArray *listFiles = [[FileManager shareInstance] getListFilesInPath:pathMangaList];
  
  NSArray *dataSource = [self parseJsons:listFiles];
  self.dataSource = [dataSource copy];
}

//parse json to Book object
-(NSArray*)parseJsons:(NSArray*) listFiles {
  NSMutableArray *dataSource = [[NSMutableArray alloc]init];
  for (int i = 0; i < listFiles.count; i++) {
    NSString *pathJson = listFiles[i];
    DownloadBook *book = [[DownloadBook alloc]initWithURL:pathJson];
    book.index = i;
    NSArray *listPages = [ParseJson parseJsonWithPath:pathJson];
    book.pages = [listPages copy];
    NSString *nameFile = [pathJson lastPathComponent];
    book.name = nameFile;
    [dataSource addObject:book];
  }
  
  return dataSource;
}

-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
  NSString *identifierTask = downloadTask.taskDescription;
  NSString *uniqueUrl = [NSString stringWithFormat:@"%@/%@",downloadTask.originalRequest.URL.absoluteString,identifierTask];
  DownloadImage *dImg = [_listActiveDownload objectForKey:uniqueUrl];
  float percent = (float)totalBytesWritten / (float)totalBytesExpectedToWrite * 100;
  //  NSLog(@"Long progress : %f", percent);
  dImg.progress = percent;
  DownloadBook *dObj = [_listActiveDownload objectForKey:dImg.nameBook];
  if (dObj.isSelected) {
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotifiProgress object:dImg];
  }
  
}

-(void)finishDownloadTask:(NSURLSessionDownloadTask*) downloadTask
                 location:(NSURL*) location
         moveDataToFolder:(NSString*) folder
                 withName:(NSString*) name {
  // Get the file name and create a destination URL
  NSString *sendingFileName = [downloadTask.originalRequest.URL lastPathComponent];
  [[FileManager shareInstance] moveFileAtPath:location toFolder:[NSString stringWithFormat:@"%@/%@",folder,name] withName:sendingFileName];
  //  NSLog(@"Image Saved At: %@/%@", [desURL path],sendingFileName);
}

//reload tableview with completiom
-(void)reloadTableView {
  dispatch_async(dispatch_get_main_queue(), ^{
    [self.tableView reloadData];
    [self.btnAdd setEnabled:NO];
  });
}

-(void) removeDownloadObjectWithKey:(NSString*) key {
  if ([self.listActiveDownload objectForKey:key]) {
    [self.listActiveDownload removeObjectForKey:key];
    //    NSLog(@"Before: %lu",(unsigned long)listActiveDownload.count);
    
  } else {
    NSLog(@"No object set for key @%@",key);
  }
}


@end
