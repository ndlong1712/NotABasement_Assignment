//
//  MangeViewerViewController.h
//  Assignment
//
//  Created by NguyenDinh.Long on 6/16/17.
//  Copyright © 2017 NguyenDinh.Long. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MangeViewerViewController : UIViewController
@property (weak, nonatomic) IBOutlet UICollectionView *mangaViewerCollectionView;
@property (strong, nonatomic) NSArray *arrManga;
@property (assign, nonatomic) NSInteger currentIndex;
@property (weak, nonatomic) IBOutlet UILabel *pageIndex;

@end
