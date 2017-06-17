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
#import "Utilities.h"
#import "ListMangaViewController.h"
#import "StoryBook.h"
#import "ParseJson.h"

@implementation HomeViewController (TableView)


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  return 4;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
  return 80;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  HomeTableViewCell *cell = (HomeTableViewCell *)[tableView dequeueReusableCellWithIdentifier:HomeCellName];
  cell.lbNameManga.text = self.dataSource[indexPath.row];
  return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
  NSString *mangaFolder = [[FileManager shareInstance] getOrCreateMangaDirectory];
  NSString *pathMangaList = [mangaFolder stringByAppendingString:[NSString stringWithFormat:@"/%@",[self.dataSource lastObject]]];
  //get list file in path
  NSArray *listFiles = [[FileManager shareInstance] getListFilesInPath:pathMangaList];
  
  NSArray *dataSource = [self parseJsons:listFiles];
  ListMangaViewController *viewController = (ListMangaViewController*) [Utilities getViewController:ListMangaViewControllerName];
  viewController.dataSource = dataSource;
  
  [self.navigationController pushViewController:viewController animated:YES];
  
}

//parse json to Book object
-(NSArray*)parseJsons:(NSArray*) listFiles {
  NSMutableArray *dataSource = [[NSMutableArray alloc]init];
  for (int i = 0; i < listFiles.count; i++) {
    NSString *pathJson = listFiles[i];
    StoryBook *book = [[StoryBook alloc]initWithPath:pathJson];
    book.index = i;
    NSArray *listPages = [ParseJson parseJsonWithPath:pathJson];
    book.pages = listPages;
    NSString *nameFile = [pathJson lastPathComponent];
    book.name = nameFile;
    [dataSource addObject:book];
  }
 
  return dataSource;
}

@end
