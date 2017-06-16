//
//  Utilities.m
//  Assignment
//
//  Created by NguyenDinh.Long on 6/16/17.
//  Copyright © 2017 NguyenDinh.Long. All rights reserved.
//

#import "Utilities.h"

@implementation Utilities

+(UIViewController*)getViewController:(NSString *)identifier{
  UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
  UIViewController *controller = [storyboard instantiateViewControllerWithIdentifier:identifier];
  return controller;
}

@end
