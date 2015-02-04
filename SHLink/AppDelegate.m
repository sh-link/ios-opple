//
//  AppDelegate.m
//  SHLink
//
//  Created by 钱凯 on 15/1/20.
//  Copyright (c) 2015年 Qiankai. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [[UINavigationBar appearance] setBackgroundImage:[self genBarBackgroundImage] forBarMetrics:UIBarMetricsDefault];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor],NSFontAttributeName: [UIFont fontWithName:@"Helvetica-Bold" size:20.0]}];
    
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
    [[UITabBar appearance] setTintColor:[UIColor colorWithRed:96.0/255 green:189.0/255 blue:179.0/255 alpha:1.0f]];
    
    
//    [[UITabBar appearance] setTintColor:[UIColor whiteColor]];

    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (UIImage *)genBarBackgroundImage {
    
    static dispatch_once_t onceToken;
    static UIImage *image;
    dispatch_once(&onceToken,^{
        
        CGFloat imageWidth = [UIScreen mainScreen].bounds.size.width;
        CGFloat imageHeight = 100;
        size_t bytesPerRow = 4 * imageWidth;
        
        CGContextRef ctx = NULL;
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        
        ctx = CGBitmapContextCreate(NULL, imageWidth, imageHeight, 8, bytesPerRow, colorSpace, (CGBitmapInfo)kCGImageAlphaPremultipliedLast);
        
        size_t gradLocationsNum = 2;
        CGFloat gradLocations[2] = {0.0f, 1.0f};
        CGFloat gradColors[8] = {64.0/255.0f,168.0/255.0f,155.0/255.0f,1.0f,
            36.0/255.0f,89.0/255.0f,116.0/255.0f,1.0f};
        
        CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, gradColors, gradLocations, gradLocationsNum);
        
        CGContextDrawLinearGradient(ctx, gradient, CGPointMake(0, imageHeight/2.0), CGPointMake(imageWidth, imageHeight/2.0), kCGGradientDrawsAfterEndLocation);
        
        CGImageRef cgImage = CGBitmapContextCreateImage(ctx);
        image = [UIImage imageWithCGImage:cgImage];
        
        CGColorSpaceRelease(colorSpace);
        CGContextRelease(ctx);
        CGImageRelease(cgImage);
        
    });
    
    return image;
    
}

@end
