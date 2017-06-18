//
//  ListMangaViewController+TableView.m
//  Assignment
//
//  Created by NguyenDinh.Long on 6/17/17.
//  Copyright © 2017 NguyenDinh.Long. All rights reserved.
//

#import "ListMangaViewController+TableView.h"
#import "ListMangaTableViewCell.h"
#import "StoryBook.h"
#import "Define.h"
#import "Download.h"
#import "MangaDetailViewController.h"
#import "Utilities.h"

static NSString *mangaDetailName = @"MangaDetailViewController";
@implementation ListMangaViewController (TableView)

#pragma UITableViewDelegate & datasource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  if (self.dataSource.count == 0 || self.dataSource == nil) {
    return 0;
  }
  return [self.dataSource count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  ListMangaTableViewCell *cell = (ListMangaTableViewCell *)[tableView dequeueReusableCellWithIdentifier:ListMangaCelllName];
  StoryBook *book = self.dataSource[indexPath.row];

  cell.lbNameManga.text = book.name;
  if (([cell.lbStatus.text  isEqual: STATUS_FINISHED] || [cell.lbStatus.text  isEqual: STATUS_DOWNLOADING])) {
    
  } else {
    cell.lbStatus.text = STATUS_QUEUING;
  }
  
  return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
  return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    StoryBook *book = self.dataSource[indexPath.row];
    Download *downloadBook = [self.listActiveDownload objectForKey:book.name];
    downloadBook.isSelected = YES;
    MangaDetailViewController *mangeDetailVC = (MangaDetailViewController*) [Utilities getViewController:mangaDetailName];
    mangeDetailVC.arrManga = downloadBook.downloadImages;
    [self.navigationController pushViewController:mangeDetailVC animated:YES];
    
    
}


@end
