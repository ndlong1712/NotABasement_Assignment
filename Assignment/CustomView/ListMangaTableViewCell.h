//
//  ListMangaTableViewCell.h
//  Assignment
//
//  Created by NguyenDinh.Long on 6/16/17.
//  Copyright © 2017 NguyenDinh.Long. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *ListMangaCelllName = @"ListMangaTableViewCell";

@interface ListMangaTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lbNameManga;
@property (weak, nonatomic) IBOutlet UILabel *lbStatus;
@property (weak, nonatomic) IBOutlet UIProgressView *viewProgress;

@end
