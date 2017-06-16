//
//  AppDelegate.m
//  LastModified
//
//  Created by caifeng on 2017/6/12.
//  Copyright © 2017年 facaishu. All rights reserved.
//

#import "AppDelegate.h"
#import "UIImageView+WebCache.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    
    [self updateImageWithSameURLConfig];
    
    return YES;
}

/**
 更新同意URL的图片
 */
- (void)updateImageWithSameURLConfig {

    SDWebImageDownloader *loader = [SDWebImageManager sharedManager].imageDownloader;
    loader.headersFilter = ^SDHTTPHeadersDictionary * _Nullable(NSURL * _Nullable url, SDHTTPHeadersDictionary * _Nullable headers) {
        
        NSFileManager *fm = [NSFileManager defaultManager];
        NSString *imgkey = [[SDWebImageManager sharedManager] cacheKeyForURL:url];
        NSString *imagePath = [SDWebImageManager.sharedManager.imageCache defaultCachePathForKey:imgkey];
        NSDictionary *fileAttri = [fm attributesOfItemAtPath:imagePath error:nil];
        
        NSMutableDictionary *mutableHeaders = [headers mutableCopy];
        NSDate *lastModifiedDate = nil;
        
        if (fileAttri.count > 0) {
            lastModifiedDate = (NSDate *)fileAttri[NSFileModificationDate];
        }
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.timeZone = [NSTimeZone timeZoneWithName:@"GMT"];
        formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
        formatter.dateFormat = @"EEE, dd MMM yyyy HH:mm:ss z";
        
        NSString *lastModifiedStr = [formatter stringFromDate:lastModifiedDate];
        lastModifiedStr = lastModifiedStr.length > 0 ? lastModifiedStr : @"";
        [mutableHeaders setValue:lastModifiedStr forKey:@"If-Modified-Since"];
        
        return mutableHeaders;
    };
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
