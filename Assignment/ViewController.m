//
//  ViewController.m
//  Assignment
//
//  Created by NguyenDinh.Long on 6/15/17.
//  Copyright © 2017 NguyenDinh.Long. All rights reserved.
//

#import "ViewController.h"
#import "MBProgressHUD.h"

@interface ViewController () {
  NSDictionary *activeDownload;
  NSURLSession *downloadsSession;
}

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
//  [MBProgressHUD showHUDAddedTo:self.view animated:YES];
  //1
  NSString *dataUrl = @"https://storage.googleapis.com/nabstudio/Developer/iOS/Interview/Image%20Downloader/JSON%20files%20updated.zip";
  NSURL *url = [NSURL URLWithString:dataUrl];
  
  // 2
  NSURLSessionDataTask *downloadTask = [[NSURLSession sharedSession]
                                        dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                          
                                          // Check to make sure the server didn't respond with a "Not Authorized"
                                          if (error) {
                                            NSLog(@"Fail: %@",error);
                                          }
                                          
                                          // 4: Handle response here
//                                          [self processResponseUsingData:data];
                                          NSLog(@"Data: %lu", (unsigned long)data.length);
                                          NSArray       *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                                          NSString  *documentsDirectory = [paths objectAtIndex:0];
                                          NSLog(@"%@", documentsDirectory);
                                          NSString  *filePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory,@"data.zip"];
                                          [data writeToFile:filePath atomically:YES];
                                          
                                        }];
  
  // 3
  [downloadTask setTaskDescription:@"Assignmen-Download-Zip"];
  [downloadTask resume];
}



- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}


@end
