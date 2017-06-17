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

@implementation ListMangaViewController (TableView)

#pragma UITableViewDelegate & datasource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [self.dataSource count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  ListMangaTableViewCell *cell = (ListMangaTableViewCell *)[tableView dequeueReusableCellWithIdentifier:ListMangaCelllName];
  StoryBook *book = self.dataSource[indexPath.row];
  cell.lbNameManga.text = book.name;
  
  return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
  return 90;
}


@end
