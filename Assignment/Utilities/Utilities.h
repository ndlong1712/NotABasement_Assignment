//
//  Utilities.h
//  Assignment
//
//  Created by NguyenDinh.Long on 6/16/17.
//  Copyright © 2017 NguyenDinh.Long. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Utilities : NSObject

+(UIViewController*)getViewController:(NSString*) identifier;
+(void)showAlertWithTitle:(NSString*) title
                  message:(NSString*)message
              cancelTitle:(NSString*)cancelTitle
                  okTitle:(NSString*)okTitle
                   inview:(UIViewController*)viewController;

@end
