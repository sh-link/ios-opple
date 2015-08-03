//
//  SHTextField.h
//  SHLink
//
//  Created by 钱凯 on 15/1/29.
//  Copyright (c) 2015年 Qiankai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SHTextField : UITextField

@property (nonatomic) UIImage *shLeftImage;

/**
 *  Shake text failed with pop up error info.
 *
 *  @param text pop up error info, just shake if pass nil.
 */
- (void)shakeWithText:(NSString *)text;


@end
