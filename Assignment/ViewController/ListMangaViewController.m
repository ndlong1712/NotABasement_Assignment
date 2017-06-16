//
//  ListMangaViewController.m
//  Assignment
//
//  Created by NguyenDinh.Long on 6/16/17.
//  Copyright © 2017 NguyenDinh.Long. All rights reserved.
//

#import "ListMangaViewController.h"
#import "ListMangaTableViewCell.h"

@interface ListMangaViewController ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation ListMangaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  self.automaticallyAdjustsScrollViewInsets = NO;
  
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma UITableViewDelegate & datasource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [self.dataSource count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  ListMangaTableViewCell *cell = (ListMangaTableViewCell *)[tableView dequeueReusableCellWithIdentifier:ListMangaCelllName];
  NSString *nameFile = [self.dataSource[indexPath.row] lastPathComponent];
  cell.lbNameManga.text = nameFile;
  return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
  return 90;
}


@end
