//
//  MangaDetailFlowLayout.m
//  Assignment
//
//  Created by NguyenDinh.Long on 6/17/17.
//  Copyright © 2017 NguyenDinh.Long. All rights reserved.
//

#import "MangaDetailFlowLayout.h"

@implementation MangaDetailFlowLayout

- (NSArray *) layoutAttributesForElementsInRect:(CGRect)rect {
  NSArray *answer = [super layoutAttributesForElementsInRect:rect];
  
  for(int i = 1; i < [answer count]; ++i) {
    UICollectionViewLayoutAttributes *currentLayoutAttributes = answer[i];
    UICollectionViewLayoutAttributes *prevLayoutAttributes = answer[i - 1];
    NSInteger maximumSpacing = 5;
    NSInteger origin = CGRectGetMaxX(prevLayoutAttributes.frame);
    
    if(origin + maximumSpacing + currentLayoutAttributes.frame.size.width <= self.collectionViewContentSize.width) {
      CGRect frame = currentLayoutAttributes.frame;
      frame.origin.x = origin + maximumSpacing;
      currentLayoutAttributes.frame = frame;
    }
  }
  return answer;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
  UICollectionViewLayoutAttributes* attributes = [[super layoutAttributesForItemAtIndexPath:indexPath] copy];
  return attributes;
}

- (CGSize)itemSize {
  CGFloat width = [UIScreen mainScreen].bounds.size.width;
  
  CGSize mElementSize = CGSizeMake(width/4 - 5, width/4 - 5);
  return mElementSize;
}

- (CGFloat)minimumLineSpacing {
  return 5;
}

- (CGFloat)minimumInteritemSpacing {
  return 0;
}

@end
