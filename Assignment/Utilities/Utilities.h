//
//  Utilities.h
//  Assignment
//
//  Created by NguyenDinh.Long on 6/16/17.
//  Copyright © 2017 NguyenDinh.Long. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "DownloadBook.h"

@interface Utilities : NSObject

+(UIViewController*)getViewController:(NSString*) identifier;
+(void)showAlertWithTitle:(NSString*) title
                  message:(NSString*)message
              cancelTitle:(NSString*)cancelTitle
                  okTitle:(NSString*)okTitle
                   inview:(UIViewController*)viewController;

+ (void)saveCustomObject:(NSObject*) object;
+ (NSArray*)getStateDownload;
+ (void)removeCustomObjectAtIndex:(int) index;
+ (void) removeAllDataInUserDefault;
+ (void)setStatusAppIsTerminate:(BOOL) isTerminal;
+ (BOOL)getStatusAppIsTerminate;
+ (void)updateProgressToDownloadBook:(float) progress atIndex:(int) index;
+ (void)updateListPagesOfDownloadBook:(DownloadImage*) downloadImage atIndex:(int) index;

@end
