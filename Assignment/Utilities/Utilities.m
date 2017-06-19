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

+(void)showAlertWithTitle:(NSString*) title
                  message:(NSString*)message
              cancelTitle:(NSString*)cancelTitle
                  okTitle:(NSString*)okTitle
                   inview:(UIViewController*)viewController {
  UIAlertController* alert = [UIAlertController alertControllerWithTitle:title
                                                                 message:message
                                                          preferredStyle:UIAlertControllerStyleAlert];
  
  UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:okTitle style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction * action) {}];
  
  [alert addAction:defaultAction];
  [viewController presentViewController:alert animated:YES completion:nil];
  
}

@end
