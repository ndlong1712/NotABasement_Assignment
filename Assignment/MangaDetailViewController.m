//
//  MangaDetailViewController.m
//  Assignment
//
//  Created by NguyenDinh.Long on 6/16/17.
//  Copyright © 2017 NguyenDinh.Long. All rights reserved.
//

#import "MangaDetailViewController.h"
#import "MangaCollectionViewCell.h"
#import "Define.h"
#import "MangaDetailFlowLayout.h"
#import "MangeViewerViewController.h"
#import "Utilities.h"
#import "UIImage+PDF.h"
#import "FileManager.h"

@interface MangaDetailViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@end

@implementation MangaDetailViewController {
  MangaDetailFlowLayout *mangaFlowLayout;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.
  self.mangaDetailCollectionView.delegate = self;
  self.mangaDetailCollectionView.dataSource = self;
  self.automaticallyAdjustsScrollViewInsets = NO;
  DownloadImage *downImg = [_arrManga objectAtIndex:0];
  [self setTitle:[downImg.nameBook stringByDeletingPathExtension]];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(progressUpdated:) name:kNotifiProgress object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
  
}

- (void)viewWillDisappear:(BOOL)animated {
  //  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}



#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
  MangeViewerViewController *mangeViewerVC = (MangeViewerViewController*) [Utilities getViewController:Manga_Viewer_Name];
  mangeViewerVC.arrManga = self.arrManga;
  mangeViewerVC.currentIndex = indexPath.row;
  [self.navigationController pushViewController:mangeViewerVC animated:YES];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
  return _arrManga.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *identifier = @"cell";
  
  MangaCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
  DownloadImage *downloadImg = [_arrManga objectAtIndex:indexPath.row];
  if (downloadImg.imgFilePath != nil) {
    [cell.imgManga setBackgroundColor:[UIColor clearColor]];
    dispatch_async(dispatch_get_main_queue(), ^{
      NSString *extension = [downloadImg.imgFilePath pathExtension];
      if ([extension isEqualToString:PDF_EXT]) {
        NSData *dataImage = [NSData dataWithContentsOfFile:downloadImg.imgFilePath];
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        CGSize mElementSize = CGSizeMake(width/4 - 5, width/4 - 5);
        cell.imgManga.image = [UIImage imageWithPDFData:dataImage atSize:mElementSize];
        
      } else if ([extension isEqualToString:ZIP_EXT]) {
        cell.progress.text = @"Unzipping...";
        [[FileManager shareInstance] unzipAndDeleteFile:downloadImg.imgFilePath toDestination:[downloadImg.imgFilePath stringByDeletingLastPathComponent] isDeleteOldFile:YES];
        NSString *fileName = [[downloadImg.imgFilePath stringByDeletingPathExtension] stringByAppendingPathExtension:JPG_EXT];
        UIImage *image = [UIImage imageWithContentsOfFile:fileName];
        downloadImg.imgFilePath = fileName;
        if (image != nil) {
          cell.imgManga.image = image;
          cell.progress.text = @"";
        } else {
          cell.progress.text = @"ERROR!";
        }
      } else {
        UIImage *image = [UIImage imageWithContentsOfFile:downloadImg.imgFilePath];
        if (image != nil) {
          cell.imgManga.image = image;
        } else {
          cell.progress.text = @"ERROR!";
        }
      }
    });
  } else {
    [cell.imgManga setBackgroundColor:[UIColor grayColor]];
  }
  
  if (downloadImg.isDownloading) {
    cell.progress.text = [NSString stringWithFormat:@"%.2f%@", downloadImg.progress,@"%"];
  } else {
    cell.progress.text = @"";
  }
  
  return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
  return 1;
}

- (void)progressUpdated:(NSNotification *)notification {
  NSInteger index = [_arrManga indexOfObject:notification.object];
  NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
  dispatch_async(dispatch_get_main_queue(), ^{
    MangaCollectionViewCell *cell = (MangaCollectionViewCell *)[_mangaDetailCollectionView cellForItemAtIndexPath:indexPath];
    DownloadImage *downloadImg = notification.object;
    if (downloadImg.imgFilePath != nil) {
      [cell.imgManga setBackgroundColor:[UIColor clearColor]];
      NSString *extension = [downloadImg.imgFilePath pathExtension];
      if ([extension isEqualToString:PDF_EXT]) {
        NSData *dataImage = [NSData dataWithContentsOfFile:downloadImg.imgFilePath];
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        CGSize mElementSize = CGSizeMake(width/4 - 5, width/4 - 5);
        cell.imgManga.image = [UIImage imageWithPDFData:dataImage atSize:mElementSize];
        
      } else if ([extension isEqualToString:ZIP_EXT]) {
        cell.progress.text = @"Unzipping...";
        [[FileManager shareInstance] unzipAndDeleteFile:downloadImg.imgFilePath toDestination:[downloadImg.imgFilePath stringByDeletingLastPathComponent] isDeleteOldFile:YES];
        NSString *fileName = [[downloadImg.imgFilePath stringByDeletingPathExtension] stringByAppendingPathExtension:JPG_EXT];
        UIImage *image = [UIImage imageWithContentsOfFile:fileName];
        downloadImg.imgFilePath = fileName;
        if (image != nil) {
          cell.imgManga.image = image;
          cell.progress.text = @"";
        } else {
          cell.progress.text = @"ERROR!";
        }
      } else {
        NSData *data = [[NSFileManager defaultManager] contentsAtPath:downloadImg.imgFilePath];
        UIImage *destImg = [UIImage imageWithData:data];
        if (destImg != nil) {
          cell.imgManga.image = destImg;
        } else {
          cell.progress.text = @"ERROR!";
        }
      }
    } else {
      [cell.imgManga setBackgroundColor:[UIColor grayColor]];
    }
    
    if (downloadImg.isDownloading) {
      cell.progress.text = [NSString stringWithFormat:@"%.2f%@", downloadImg.progress,@"%"];
    } else {
      cell.progress.text = @"";
    }
  });
}

- (UIImage *)imageWithImage:(UIImage *)image convertToSize:(CGSize)size {
  UIGraphicsBeginImageContext(size);
  [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
  UIImage *destImage = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  return destImage;
}


@end
