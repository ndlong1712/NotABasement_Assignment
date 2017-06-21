//
//  MangaDetailViewController.h
//  Assignment
//
//  Created by NguyenDinh.Long on 6/16/17.
//  Copyright © 2017 NguyenDinh.Long. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DownloadImage.h"

@interface MangaDetailViewController : UIViewController
@property (weak, nonatomic) IBOutlet UICollectionView *mangaDetailCollectionView;
@property (strong, nonatomic) NSArray *arrManga;
@end
