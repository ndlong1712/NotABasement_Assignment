//
//  MangeViewerFlowLayout.m
//  Assignment
//
//  Created by Kahn on 6/21/17.
//  Copyright © 2017 NguyenDinh.Long. All rights reserved.
//

#import "MangeViewerFlowLayout.h"

@interface MangeViewerFlowLayout() {
    BOOL onceTime;
}

@end

@implementation MangeViewerFlowLayout

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (NSArray *) layoutAttributesForElementsInRect:(CGRect)rect {
    NSArray *answer = [super layoutAttributesForElementsInRect:rect];
    
    for(int i = 1; i < [answer count]; ++i) {
        UICollectionViewLayoutAttributes *currentLayoutAttributes = answer[i];
        UICollectionViewLayoutAttributes *prevLayoutAttributes = answer[i - 1];
        NSInteger maximumSpacing = 0;
        NSInteger origin = CGRectGetMaxX(prevLayoutAttributes.frame);
        
//        if(origin + maximumSpacing + currentLayoutAttributes.frame.size.width <= self.collectionViewContentSize.width) {
            CGRect frame = currentLayoutAttributes.frame;
            frame.origin.x = origin + maximumSpacing;
            frame.origin.y = 0;
            currentLayoutAttributes.frame = frame;
        //}
    }
    return answer;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes* attributes = [[super layoutAttributesForItemAtIndexPath:indexPath] copy];
    return attributes;
}

- (CGSize)itemSize {
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    
    CGSize mElementSize = CGSizeMake(width, height);
    return mElementSize;
}

- (CGFloat)minimumLineSpacing {
    return 0;
}

- (CGFloat)minimumInteritemSpacing {
    return 0;
}

@end
