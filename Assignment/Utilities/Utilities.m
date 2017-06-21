//
//  Utilities.m
//  Assignment
//
//  Created by NguyenDinh.Long on 6/16/17.
//  Copyright © 2017 NguyenDinh.Long. All rights reserved.
//

#import "Utilities.h"
#import "Define.h"

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

+ (void)setStatusAppIsTerminate:(BOOL) isTerminal{
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  [defaults setBool:isTerminal forKey:STATE_IS_TERMINATE];
}

+ (BOOL)getStatusAppIsTerminate {
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  BOOL isTerminate = [defaults boolForKey:STATE_IS_TERMINATE];
  return isTerminate;
}

+ (void)updateProgressToDownloadBook:(float) progress atIndex:(int) index{
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  NSMutableArray *arrDownloadBooks = [[NSMutableArray alloc]init];
  if ([defaults objectForKey:STATE_DOWNLOAD]) {
    NSData *data = [defaults objectForKey:STATE_DOWNLOAD];
    NSArray *downloadBooks = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    arrDownloadBooks = [downloadBooks mutableCopy];
    DownloadBook *book = [arrDownloadBooks objectAtIndex:index];
    book.progress = progress;
    [arrDownloadBooks replaceObjectAtIndex:index withObject:book];
    NSData *dataNew = [NSKeyedArchiver archivedDataWithRootObject:arrDownloadBooks];
    [defaults setObject:dataNew forKey:STATE_DOWNLOAD];
    [defaults synchronize];
  }
}

+ (void)updateListPagesOfDownloadBook:(DownloadImage*) downloadImage atIndex:(int) index{
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  NSMutableArray *arrDownloadBooks = [[NSMutableArray alloc]init];
  if ([defaults objectForKey:STATE_DOWNLOAD]) {
    NSData *data = [defaults objectForKey:STATE_DOWNLOAD];
    NSArray *downloadBooks = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    arrDownloadBooks = [downloadBooks mutableCopy];
    DownloadBook *book = [arrDownloadBooks objectAtIndex:index];
    [book.pages addObject:downloadImage];
    [arrDownloadBooks replaceObjectAtIndex:index withObject:book];
    NSData *dataNew = [NSKeyedArchiver archivedDataWithRootObject:arrDownloadBooks];
    [defaults setObject:dataNew forKey:STATE_DOWNLOAD];
    [defaults synchronize];
  }
}

+ (void)saveCustomObject:(NSObject*) object {
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  NSMutableArray *arrDownloadBooks = [[NSMutableArray alloc]init];
  //check nil array in userdefault
  if ([defaults objectForKey:STATE_DOWNLOAD]) {
    NSData *data = [defaults objectForKey:STATE_DOWNLOAD];
    NSArray *downloadBooks = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    arrDownloadBooks = [downloadBooks mutableCopy];
  }
  if (![arrDownloadBooks containsObject:object]) {
    [arrDownloadBooks addObject:object];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:arrDownloadBooks];
    [defaults setObject:data forKey:STATE_DOWNLOAD];
    [defaults synchronize];
  } else {
    NSLog(@"Object is exist...!!!!!!");
  }
}

+ (void)removeCustomObjectAtIndex:(int) index {
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  NSMutableArray *arrDownloadBooks = [[NSMutableArray alloc]init];
  //check nil array in userdefault
  if ([defaults objectForKey:STATE_DOWNLOAD]) {
    NSData *data = [defaults objectForKey:STATE_DOWNLOAD];
    NSArray *downloadBooks = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    arrDownloadBooks = [downloadBooks mutableCopy];
    [arrDownloadBooks removeObjectAtIndex:index];
    NSData *updatedData = [NSKeyedArchiver archivedDataWithRootObject:arrDownloadBooks];
    [defaults setObject:updatedData forKey:STATE_DOWNLOAD];
    [defaults synchronize];
  }
}

+ (NSArray*)getStateDownload {
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  NSData *encodedObject = [defaults objectForKey:STATE_DOWNLOAD];
  NSArray *objectDownloads = [NSKeyedUnarchiver unarchiveObjectWithData:encodedObject];
  return objectDownloads;
}

+ (void) removeAllDataInUserDefault {
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  NSMutableArray *arrDownloadBooks = [[NSMutableArray alloc]init];
  NSData *updatedData = [NSKeyedArchiver archivedDataWithRootObject:arrDownloadBooks];
  [defaults setObject:updatedData forKey:STATE_DOWNLOAD];
  [defaults synchronize];
  [self setStatusAppIsTerminate:NO];
}

@end
