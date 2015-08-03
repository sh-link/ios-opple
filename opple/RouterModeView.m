//
//  RouterModeView.m
//  opple
//
//  Created by zhen yang on 15/7/16.
//  Copyright (c) 2015年 Qiankai. All rights reserved.
//

#import "RouterModeView.h"
#import "UIView+Extension.h"
#import "TextUtil.h"
#import "ScreenUtil.h"
#import "StringUtil.h"
#define routerModeViewPaddingTop 15
#define routerModeViewPaddingLeft 15
#define lineHeight 0.5
#define padding 10
@implementation RouterModeView
{
    UILabel *currentWorkMode;
    UILabel *baseSSID;
    UILabel *channel;
    UILabel *encryptState;
    UILabel *password;
    
    UILabel *ssid1;
    UILabel *encryptState1;
    UILabel *password1;
    
    UILabel *ssid2;
    UILabel *encryptState2;
    UILabel *password2;
    
    UILabel *ssid3;
    UILabel *encryptState3;
    UILabel *password3;
    
    UIView *baseLine;
    UIView *ssid1Line;
    UIView *ssid2Line;
    UIView *ssid3Line;
    
    int ssidSize;
    
    CGFloat _maxHeight;
    
}

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        [self setUp];
    }
    return self;
}

-(void)setUp
{
    ssidSize = 1;
    self.layer.cornerRadius = 5;
    self.layer.masksToBounds = true;
    self.backgroundColor = [UIColor whiteColor];
    self.layer.borderWidth = 1;
    self.layer.borderColor = getColor(200, 200, 200, 200).CGColor;
    
    currentWorkMode = [[UILabel alloc]init];
    baseSSID = [UILabel new];
    channel = [UILabel new];
    encryptState = [UILabel new];
    password = [UILabel new];
    
    ssid1 = [UILabel new];
    encryptState1 = [UILabel new];
    password1 = [UILabel new];
    
    ssid2 = [UILabel new];
    encryptState2 = [UILabel new];
    password2 = [UILabel new];
    
    ssid3 = [UILabel new];
    encryptState3 = [UILabel new];
    password3 = [UILabel new];
    
    baseLine = [UIView new];
    ssid1Line = [UIView new];
    ssid2Line = [UIView new];
    ssid3Line = [UIView new];
    
    [self addSubview:currentWorkMode];
    
    [self addSubview:baseSSID];
    [self addSubview:channel];
    [self addSubview:encryptState];
    [self addSubview:password];
    
    [self addSubview:ssid1];
    [self addSubview:encryptState1];
    [self addSubview:password1];
    
    [self addSubview:ssid2];
    [self addSubview:encryptState2];
    [self addSubview:password2];
    
    [self addSubview:ssid3];
    [self addSubview:encryptState3];
    [self addSubview:password3];
    
    [self addSubview:baseLine];
    [self addSubview:ssid1Line];
    [self addSubview:ssid2Line];
    [self addSubview:ssid3Line];
    //#55808080
    baseLine.backgroundColor = ssid1Line.backgroundColor = ssid2Line.backgroundColor = ssid3Line.backgroundColor = getColor(0x55, 0x80, 0x80, 0x80);
    currentWorkMode.textColor = baseSSID.textColor = encryptState.textColor = channel.textColor = password.textColor = ssid1.textColor = encryptState1.textColor = password1.textColor = ssid2.textColor = encryptState2.textColor = password2.textColor = ssid3.textColor = encryptState3.textColor = password3.textColor = getColor(0x57, 0x57, 0x57, 255);
    currentWorkMode.text = @"test";
    
   
    
}

-(void)layoutSubviews
{
    [self refreshFrame];
}

-(void)setData:(NSDictionary *)dic
{
    NSDictionary *infoDic;
    //获取工作模式
    int mode = [dic[@"WLAN_MODE"] intValue];
    DLog(@"mode = %d", mode);
    if(mode == 0)
    {
        DLog(@"当前工作模式: router");
        currentWorkMode.text = @"当前工作模式: router模式";
        DLog(@"currentMode.text = %@", currentWorkMode.text);
        infoDic = dic[@"WLAN_ROUTER"];
    }
    else if(mode == 1)
    {
        currentWorkMode.text = @"当前工作模式: ap模式";
        infoDic = dic[@"WLAN_AP"];
    }
    else
    {
        //不可能是repeater模式
//        currentWorkMode.text = @"当前工作模式: repeater模式";
//        infoDic = dic[@"WLAN_REPEATER"];
    }
    
    //获取对应模式的具体参数信息
    if(mode == 0 || mode == 1)
    {
        int channelInt = [infoDic[@"WLAN_CHANNEL"] intValue];
        if(channelInt == 0)
        {
            channel.text = @"通信信道: 自动";
        }
        else
        {
            channel.text = [NSString stringWithFormat:@"通信信道: %d", channelInt];
        }
        //获取ssid列表
        NSArray *ssids = infoDic[@"SSID_LIST"];
        ssidSize = (int)ssids.count;
        if(ssidSize > 0)
        {
            //填充basessid
            DLog(@"填充basessid");
            NSDictionary *ssidDic = ssids[0];
            baseSSID.text = [NSString stringWithFormat:@"基本ssid: %@", ssidDic[@"SSID"]];
            int encryptStateInt = [ssidDic[@"WLAN_SECURITY"] intValue];
            if(encryptStateInt == 0)
            {
                encryptState.text =@"加密状态: 未加密";
            }
            else
            {
                encryptState.text = @"加密状态: 已加密";
            }
            NSString *key = ssidDic[@"KEY"];
            password.text = [NSString stringWithFormat:@"连接密码: %@", key];
            [StringUtil trim:key];
            if(encryptStateInt == 0)
            {
                password.text = @"无密码";
            }
        }
        if(ssidSize > 1)
        {
            //填充ssid1
            DLog(@"填充ssid1");
            NSDictionary *ssidDic = ssids[1];
            ssid1.text = [NSString stringWithFormat:@"ssid1名称: %@", ssidDic[@"SSID"]];
            int encryptStateInt = [ssidDic[@"WLAN_SECURITY"] intValue];
            if(encryptStateInt == 0)
            {
                encryptState1.text = @"加密状态: 未加密";
            }
            else
            {
                encryptState1.text = @"加密状态: 已加密";
            }
            NSString *key = ssidDic[@"KEY"];
            password1.text = [NSString stringWithFormat:@"连接密码: %@", key];
            [StringUtil trim:key];
            if(encryptStateInt == 0)
            {
                password1.text = @"连接密码: 无密码";
            }
        }
        if(ssidSize > 2)
        {
            //填充ssid2
            DLog(@"填充ssid2");
            NSDictionary *ssidDic = ssids[2];
            ssid2.text = [NSString stringWithFormat:@"ssid2名称: %@", ssidDic[@"SSID"]];
            int encryptStateInt = [ssidDic[@"WLAN_SECURITY"] intValue];
            if(encryptStateInt == 0)
            {
                encryptState2.text = @"加密状态: 未加密";
            }
            else
            {
                encryptState2.text = @"加密状态: 已加密";
            }
            NSString *key = ssidDic[@"KEY"];
            password2.text = [NSString stringWithFormat:@"连接密码: %@", key];
            [StringUtil trim:key];
            if(encryptStateInt == 0)
            {
                password2.text = @"连接密码: 无密码";
            }
        }
        if(ssidSize > 3)
        {
            //填充ssid3
            DLog(@"填充ssid3");
            NSDictionary *ssidDic = ssids[3];
            ssid3.text = [NSString stringWithFormat:@"ssid3名称: %@", ssidDic[@"SSID"]];
            int encryptStateInt = [ssidDic[@"WLAN_SECURITY"] intValue];
            if(encryptStateInt == 0)
            {
                encryptState3.text = @"加密状态: 未加密";
            }
            else
            {
                encryptState3.text = @"加密状态: 已加密";
            }
            NSString *key = ssidDic[@"KEY"];
            password3.text = [NSString stringWithFormat:@"连接密码: %@", ssidDic[@"KEY"]];
            [StringUtil trim:key];
            if(encryptStateInt == 0)
            {
                password3.text = @"连接密码: 无密码";
            }
        }
    }
    else
    {
        //不可能走到这里
    }
    [self refreshFrame];
    DLog(@"i ame here ======================");
}

+(RouterModeView*)RouterModeViewWithMaxHeight:(CGFloat)maxHeight
{
    RouterModeView *view = [RouterModeView new];
    [view setMaxHeight:maxHeight];
    return view;
}

-(void)setMaxHeight:(CGFloat)maxHeight
{
    _maxHeight = maxHeight;
}

-(void)refreshFrame
{
    DLog(@"layoutSubviews====================== size = %d", ssidSize);
    [super layoutSubviews];
    
    float height = [TextUtil getSize:currentWorkMode].height;
    float width = self.width - 2 * routerModeViewPaddingLeft;
    DLog(@"width = %f height = %f", width, height);
    currentWorkMode.frame = CGRectMake(routerModeViewPaddingLeft, routerModeViewPaddingTop, width, height);
    DLog(@"current.text = %@", currentWorkMode.text);
    baseLine.frame = CGRectMake(0, CGRectGetMaxY(currentWorkMode.frame) + routerModeViewPaddingTop, self.width, lineHeight);
    
    baseSSID.frame = CGRectMake(routerModeViewPaddingLeft, CGRectGetMaxY(baseLine.frame) + routerModeViewPaddingTop, width, height);
    channel.frame = CGRectMake(routerModeViewPaddingLeft, CGRectGetMaxY(baseSSID.frame) + routerModeViewPaddingTop, width, height);
    encryptState.frame = CGRectMake(routerModeViewPaddingLeft, CGRectGetMaxY(channel.frame) + routerModeViewPaddingTop, width, height);
    password.frame = CGRectMake(routerModeViewPaddingLeft, CGRectGetMaxY(encryptState.frame) + routerModeViewPaddingTop, width, height);
    DLog(@"paddword.frame = %@", NSStringFromCGRect(password.frame));
    if(ssidSize < 2)
    {
        DLog(@"不显示ssid1");
        ssid1Line.frame = CGRectMake(0, CGRectGetMaxY(password.frame), 0, 0);
        ssid1.frame = CGRectMake(routerModeViewPaddingLeft, CGRectGetMaxY(ssid1Line.frame), 0, 0);
        encryptState1.frame = CGRectMake(routerModeViewPaddingLeft, CGRectGetMaxY(ssid1.frame), 0, 0);
        password1.frame = CGRectMake(routerModeViewPaddingLeft, CGRectGetMaxY(encryptState1.frame), 0, 0);
    }
    else
    {
        DLog(@"显示ssid1");
        ssid1Line.frame = CGRectMake(0, CGRectGetMaxY(password.frame) + routerModeViewPaddingTop, self.width, lineHeight);
        ssid1.frame = CGRectMake(routerModeViewPaddingLeft, CGRectGetMaxY(ssid1Line.frame) + routerModeViewPaddingTop, width, height);
        encryptState1.frame = CGRectMake(routerModeViewPaddingLeft, CGRectGetMaxY(ssid1.frame) + routerModeViewPaddingTop, width, height);
        password1.frame = CGRectMake(routerModeViewPaddingLeft, CGRectGetMaxY(encryptState1.frame) + routerModeViewPaddingTop, width, height);
        DLog(@"paddword1.frame = %@", NSStringFromCGRect(password1.frame));
    }
    
    if(ssidSize < 3)
    {
        DLog(@"不显示ssid2");
        ssid2Line.frame = CGRectMake(0, CGRectGetMaxY(password1.frame), 0, 0);
        ssid2.frame = CGRectMake(routerModeViewPaddingLeft, CGRectGetMaxY(ssid2Line.frame), 0, 0);
        encryptState2.frame = CGRectMake(routerModeViewPaddingLeft, CGRectGetMaxY(ssid2.frame), 0, 0);
        password2.frame = CGRectMake(routerModeViewPaddingLeft, CGRectGetMaxY(encryptState2.frame), 0, 0);
    }
    else
    {
        DLog(@"显示ssid2");
        ssid2Line.frame = CGRectMake(0, CGRectGetMaxY(password1.frame) + routerModeViewPaddingTop, self.width, lineHeight);
        ssid2.frame = CGRectMake(routerModeViewPaddingLeft, CGRectGetMaxY(ssid2Line.frame) + routerModeViewPaddingTop, width, height);
        encryptState2.frame = CGRectMake(routerModeViewPaddingLeft, CGRectGetMaxY(ssid2.frame) + routerModeViewPaddingTop, width, height);
        password2.frame = CGRectMake(routerModeViewPaddingLeft, CGRectGetMaxY(encryptState2.frame) + routerModeViewPaddingTop, width, height);
        DLog(@"paddword2.frame = %@", NSStringFromCGRect(password2.frame));
    }
    
    if(ssidSize < 4)
    {
        DLog(@"不显示ssid3");
        ssid3Line.frame = CGRectMake(0, CGRectGetMaxY(password2.frame), 0, 0);
        ssid3.frame = CGRectMake(routerModeViewPaddingLeft, CGRectGetMaxY(ssid3Line.frame), 0, 0);
        encryptState3.frame = CGRectMake(routerModeViewPaddingLeft, CGRectGetMaxY(ssid3.frame), 0, 0);
        password3.frame = CGRectMake(routerModeViewPaddingLeft, CGRectGetMaxY(encryptState3.frame), 0, 0);
    }
    else
    {
        DLog(@"显示ssid3");
        ssid3Line.frame = CGRectMake(0, CGRectGetMaxY(password2.frame) + routerModeViewPaddingTop, self.width, lineHeight);
        ssid3.frame = CGRectMake(routerModeViewPaddingLeft, CGRectGetMaxY(ssid3Line.frame) + routerModeViewPaddingTop, width, height);
        encryptState3.frame = CGRectMake(routerModeViewPaddingLeft, CGRectGetMaxY(ssid3.frame) + routerModeViewPaddingTop, width, height);
        password3.frame = CGRectMake(routerModeViewPaddingLeft, CGRectGetMaxY(encryptState3.frame) + routerModeViewPaddingTop, width, height);
    }
    
    self.contentSize = CGSizeMake(0, CGRectGetMaxY(password3.frame) + routerModeViewPaddingTop);
    if(self.contentSize.height > _maxHeight)
    {
        self.height = _maxHeight;
    }
    else
    {
        self.height = self.contentSize.height;
    }
    DLog(@"self.contentSize = %f", self.contentSize.height);
}
@end
