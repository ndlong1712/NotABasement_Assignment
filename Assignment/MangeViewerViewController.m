//
//  MangeViewerViewController.m
//  Assignment
//
//  Created by NguyenDinh.Long on 6/16/17.
//  Copyright © 2017 NguyenDinh.Long. All rights reserved.
//

#import "MangeViewerViewController.h"
#import "MangaViewerCollectionViewCell.h"
#import "DownloadImage.h"
#import "Define.h"
#import "MangeViewerFlowLayout.h"
#import "UIImage+PDF.h"
#import "FileManager.h"

@interface MangeViewerViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@end

@implementation MangeViewerViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.
  self.mangaViewerCollectionView.delegate = self;
  self.mangaViewerCollectionView.dataSource = self;
  self.automaticallyAdjustsScrollViewInsets = NO;
  MangeViewerFlowLayout *mangaFlowLayout = [[MangeViewerFlowLayout alloc] init];
  mangaFlowLayout.currentIdx = _currentIndex;
  [mangaFlowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
  self.mangaViewerCollectionView.collectionViewLayout = mangaFlowLayout;
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
  DownloadImage *downImg = [self.arrManga objectAtIndex:0];
  [self setTitle:[downImg.nameBook stringByDeletingPathExtension]];
  //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(progressUpdated:) name:kNotifiProgress object:nil];
  CGFloat width = [UIScreen mainScreen].bounds.size.width;
  CGFloat height = [UIScreen mainScreen].bounds.size.height;
  [self.mangaViewerCollectionView setContentSize:CGSizeMake(self.arrManga.count*width, height)];
  [self.mangaViewerCollectionView setContentOffset:CGPointMake(self.currentIndex*width, 0)];
  self.pageIndex.text = [NSString stringWithFormat:@"%ld/%lu", self.currentIndex + 1, (unsigned long)self.arrManga.count];
}

- (void)viewDidAppear:(BOOL)animated {
  
}

- (void)viewDidDisappear:(BOOL)animated {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma UICollectionViewDelegate
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {

}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
  CGFloat contentOffsetX = self.mangaViewerCollectionView.contentOffset.x;
  CGFloat width = [UIScreen mainScreen].bounds.size.width;
  NSInteger idx = contentOffsetX / width;
  self.pageIndex.text = [NSString stringWithFormat:@"%ld/%lu", idx + 1, (unsigned long)self.arrManga.count];
  
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
  return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
  return self.arrManga.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *identifier = @"ViewerCell";
  
  MangaViewerCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
  DownloadImage *downloadImg = [self.arrManga objectAtIndex:indexPath.row];
  if (downloadImg.imgFilePath != nil) {
    NSString *extension = [downloadImg.imgFilePath pathExtension];
    if ([extension isEqualToString:PDF_EXT]) {
      NSData *dataImage = [NSData dataWithContentsOfFile:downloadImg.imgFilePath];
      CGFloat width = [UIScreen mainScreen].bounds.size.width;
      CGFloat height = [UIScreen mainScreen].bounds.size.height;
      CGSize mElementSize = CGSizeMake(width, height);
      cell.imgView.image = [UIImage imageWithPDFData:dataImage atSize:mElementSize];
      
    } else if ([extension isEqualToString:ZIP_EXT]) {
      
    } else {
      cell.imgView.image = [UIImage imageWithContentsOfFile:downloadImg.imgFilePath];
    }
  } else {
    [cell.imgView setBackgroundColor:[UIColor grayColor]];
  }
  
  return cell;
}

#pragma mark - Function
- (void)progressUpdated:(NSNotification *)notification {
  dispatch_async(dispatch_get_main_queue(), ^{
    NSInteger index = [self.arrManga indexOfObject:notification.object];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    MangaViewerCollectionViewCell *cell = (MangaViewerCollectionViewCell *)[self.mangaViewerCollectionView cellForItemAtIndexPath:indexPath];
    DownloadImage *downloadImg = notification.object;
    if (downloadImg.imgFilePath != nil) {
      @try {
        NSString *extension = [downloadImg.imgFilePath pathExtension];
        if ([extension isEqualToString:PDF_EXT]) {
          NSData *dataImage = [NSData dataWithContentsOfFile:downloadImg.imgFilePath];
          CGFloat width = [UIScreen mainScreen].bounds.size.width;
          CGFloat height = [UIScreen mainScreen].bounds.size.height;
          CGSize mElementSize = CGSizeMake(width, height);
          cell.imgView.image = [UIImage imageWithPDFData:dataImage atSize:mElementSize];
          
        } else if ([extension isEqualToString:ZIP_EXT]) {
          [[FileManager shareInstance] unzipAndDeleteFile:downloadImg.imgFilePath toDestination:downloadImg.imgFilePath isDeleteOldFile:YES];
        } else {
          NSData *data = [[NSFileManager defaultManager] contentsAtPath:downloadImg.imgFilePath];
          UIImage *destImg = [UIImage imageWithData:data];
          cell.imgView.image = destImg;
        }
      } @catch (NSException *exception) {
        NSLog(@"Error");
      }
    } else {
      [cell.imgView setBackgroundColor:[UIColor grayColor]];
    }
  });
}

@end
