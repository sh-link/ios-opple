//
//  DropMenu.m
//  opple
//
//  Created by zhen yang on 15/7/23.
//  Copyright (c) 2015年 Qiankai. All rights reserved.
//

#import "DropMenu.h"
#import "UIView+Extension.h"
#import "MessageUtil.h"
#import "PopMenuViewController.h"
@interface DropMenu()<PopMenuViewControllerDelegate>

@end

@implementation DropMenu

-(void)showFrom:(UIView *)from
{
   
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    [window addSubview:self];
    self.frame = window.bounds;
    
    CGRect newFrame = [from convertRect:from.bounds toView:window];
   
    _contentController.view.x = newFrame.origin.x;
    _contentController.view.y = newFrame.origin.y + from.frame.size.height;
    
    
    _contentController.view.width = from.width;
    _contentController.view.height = 180;
    
    
}

-(void)dismiss
{
    [self removeFromSuperview];
}


-(void)setContentController:(UIViewController *)contentController
{
    _contentController = contentController;
    PopMenuViewController *vc = (PopMenuViewController*)_contentController;
    vc.delegate = self;
    [self addSubview:_contentController.view];
}

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
       
    }
    return self;
}



+(instancetype)menu
{
    DropMenu *menu = [DropMenu new];
    return menu;
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    DLog(@"point = %@", NSStringFromCGPoint(point));
    DLog(@"view.frame = %@", NSStringFromCGRect(_contentController.view.frame));
    if (!CGRectContainsPoint(_contentController.view.frame, point)) {
        [self dismiss];
    }
}

-(void)clickItem:(int)index withData:(NSArray *)datas
{
    NSString *data= datas[index];
    [self.delegate clickItem:index withData:data];
    [self dismiss];
}
@end
