//
//  ListMangaViewController.h
//  Assignment
//
//  Created by NguyenDinh.Long on 6/16/17.
//  Copyright © 2017 NguyenDinh.Long. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *ListMangaViewControllerName = @"ListMangaViewController";

@interface ListMangaViewController : UIViewController

@property(nonatomic, strong) NSURLSession *downloadsSession;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic)NSArray *dataSource;
@property (weak, nonatomic) IBOutlet UISlider *sliderNumberThread;
@property (weak, nonatomic) IBOutlet UILabel *lbMinNumber;
@property (weak, nonatomic) IBOutlet UILabel *lbMaxNumber;
@property (strong, nonatomic) NSMutableDictionary *listActiveDownload;

@end
