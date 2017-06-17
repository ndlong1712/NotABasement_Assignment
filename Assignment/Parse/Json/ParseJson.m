//
//  ParseJson.m
//  Assignment
//
//  Created by NguyenDinh.Long on 6/17/17.
//  Copyright © 2017 NguyenDinh.Long. All rights reserved.
//

#import "ParseJson.h"
#import "Define.h"

@implementation ParseJson

+(NSArray *)parseJsonWithPath:(NSString *)path{
  NSString *extenson = [path pathExtension];
  NSMutableArray *result;
  if ([extenson isEqualToString:JSON_EXT]) {
    NSString *myJSON = [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:NULL];
    NSError *error =  nil;
    result = [NSJSONSerialization JSONObjectWithData:[myJSON dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:&error];
    return [result copy];
  } else {
    NSLog(@"File isn't json.");
  }
  
  return @[];
}

@end
