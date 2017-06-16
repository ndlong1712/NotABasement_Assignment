//
//  HomeViewController+TableView.m
//  Assignment
//
//  Created by NguyenDinh.Long on 6/16/17.
//  Copyright © 2017 NguyenDinh.Long. All rights reserved.
//

#import "HomeViewController+TableView.h"
#import "HomeTableViewCell.h"
#import "FileManager.h"

@implementation HomeViewController (TableView)


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  return 4;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  HomeTableViewCell *cell = (HomeTableViewCell *)[tableView dequeueReusableCellWithIdentifier:HomeCellName];
  cell.lbNameManga.text = self.dataSource[indexPath.row];
  return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
  NSString *mangaFolder = [[FileManager shareInstance] getOrCreateMangaDirectory];
  NSString *pathMangaList = [mangaFolder stringByAppendingString:[NSString stringWithFormat:@"/%@",[self.dataSource lastObject]]];
  NSArray *listFiles = [[FileManager shareInstance] getListFilesInPath:pathMangaList];
}

@end
