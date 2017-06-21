//
//  MangaDetailViewController.m
//  Assignment
//
//  Created by Kahn on 6/18/17.
//  Copyright © 2017 NguyenDinh.Long. All rights reserved.
//

#import "MangaDetailViewController.h"
#import "MangaCollectionViewCell.h"
#import "Define.h"
#import "MangaDetailFlowLayout.h"

@interface MangaDetailViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@end

@implementation MangaDetailViewController {
    MangaDetailFlowLayout *mangaFlowLayout;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _mangaDetailCollectionView.delegate = self;
    _mangaDetailCollectionView.dataSource = self;
    self.automaticallyAdjustsScrollViewInsets = NO;
//    mangaFlowLayout = [[MangaDetailFlowLayout alloc] init];
    //_mangaDetailCollectionView.collectionViewLayout = mangaFlowLayout;
}

- (void)viewWillAppear:(BOOL)animated {
    DownloadImage *downImg = [_arrManga objectAtIndex:0];
    [self setTitle:[downImg.nameBook stringByDeletingPathExtension]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(progressUpdated:) name:kNotifiProgress object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - UICollectionViewDelegate

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _arrManga.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"cell";
    
    MangaCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    DownloadImage *downloadImg = [_arrManga objectAtIndex:indexPath.row];
    if (downloadImg.imgFilePath != nil) {
      dispatch_async(dispatch_get_main_queue(), ^{
        cell.imgManga.image = [UIImage imageWithContentsOfFile:downloadImg.imgFilePath];
      });
    } else {
        [cell.imgManga setBackgroundColor:[UIColor grayColor]];
    }
    
    if (downloadImg.isDownloading) {
        cell.progress.text = [NSString stringWithFormat:@"Downloading %d", (int)downloadImg.progress];
    } else {
        cell.progress.text = @"";
    }
    
    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (void)progressUpdated:(NSNotification *)notification {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSInteger index = [_arrManga indexOfObject:notification.object];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
        MangaCollectionViewCell *cell = (MangaCollectionViewCell *)[_mangaDetailCollectionView cellForItemAtIndexPath:indexPath];
        DownloadImage *downloadImg = notification.object;
        if (downloadImg.imgFilePath != nil) {
            @try {
                NSData *data = [[NSFileManager defaultManager] contentsAtPath:downloadImg.imgFilePath];
                UIImage *destImg = [UIImage imageWithData:data];
                cell.imgManga.image = destImg;
            } @catch (NSException *exception) {
                NSLog(@"Error");
            }
        } else {
            [cell.imgManga setBackgroundColor:[UIColor grayColor]];
        }
        
        if (downloadImg.isDownloading) {
            cell.progress.text = [NSString stringWithFormat:@"Downloading %d", (int)downloadImg.progress];
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
