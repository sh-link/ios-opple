//
//  WifiClockViewController.m
//  SHLink
//
//  Created by zhen yang on 15/3/26.
//  Copyright (c) 2015年 Qiankai. All rights reserved.
//

#import "WifiClockViewController.h"
#import "TimeLineView.h"
#import "SHRectangleButton.h"
#import "SHRouter.h"
#import "SHProgressDialog.h"
#import "WifiClockSetupViewController.h"
#import "FaildView.h"
#import "DialogUtil.h"
#import "Packet.h"
#import "MBProgressHUD.h"
#import "Utils.h"
#define verticalSpace 10
#define left_right_margin 20
@interface WifiClockViewController ()

@end

@implementation WifiClockViewController
{
    id _target;
    UISwitch* toggle;
    
    UILabel *wifiStateText;
    
    //七个时间线
    TimeLineView *line1;
    TimeLineView *line2;
    TimeLineView *line3;
    TimeLineView *line4;
    TimeLineView *line5;
    TimeLineView *line6;
    TimeLineView *line7;
    //时间线数组
    NSArray* lines;
    //七个label
    UILabel *lable1;
    UILabel *lable2;
    UILabel *lable3;
    UILabel *lable4;
    UILabel *lable5;
    UILabel *lable6;
    UILabel *lable7;
    //按钮
    SHRectangleButton *modify;
    //保存文字矩形
    CGSize textSize;
    
    
    UIView *over;
    
     MBProgressHUD *hud;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    hud = [[MBProgressHUD alloc] initWithWindow:[UIApplication sharedApplication].keyWindow];
    hud.labelText = @"正在设置…";
    hud.dimBackground = YES;
    hud.minShowTime = 1.0;
    over = [[UIView alloc]init];
    over.frame = self.view.frame;
    over.backgroundColor = getColor(10, 10, 10, 40);
    [self initView];
}

-(void)initView
{
    //计算字符串"星期一"大小
    NSDictionary *attrs = @{NSFontAttributeName : [UIFont systemFontOfSize:18]};
    textSize =  [@"星期一" boundingRectWithSize:self.view.frame.size options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
    
    //导航栏设置
    self.title = @"wifi定时";
    toggle = [[UISwitch alloc]init];
    toggle.on = YES;
    [toggle addTarget:self action:@selector(wifi_toggle:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:toggle];
    
    //wifi状态提示
    wifiStateText = [[UILabel alloc]init];
    [wifiStateText setTextAlignment:NSTextAlignmentCenter];
    [wifiStateText setTextColor:getColor(0, 0, 0, 180)];
    [self.view addSubview:wifiStateText];
    //时间线
    line1 = [[TimeLineView alloc]init];
    [self.view addSubview:line1];
    NSArray* times = @[@0, @(24*60)];
    [line1 setTimes:times];
    
    line2 = [[TimeLineView alloc]init];
    [self.view addSubview:line2];
    [line2 setTimes:times];
    
    line3 = [[TimeLineView alloc]init];
    [self.view addSubview:line3];
    [line3 setTimes:times];
    
    line4 = [[TimeLineView alloc]init];
    [self.view addSubview:line4];
    [line4 setTimes:times];
    
    line5 = [[TimeLineView alloc]init];
    [self.view addSubview:line5];
    [line5 setTimes:times];
    
    line6 = [[TimeLineView alloc]init];
    [self.view addSubview:line6];
    [line6 setTimes:times];
    
    line7 = [[TimeLineView alloc]init];
    [self.view addSubview:line7];
    [line7 setTimes:times];
    
    lable1 = [[UILabel alloc]init];
    [self.view addSubview:lable1];
    lable1.text = @"星期一";
    
    lable2 = [[UILabel alloc]init];
    [self.view addSubview:lable2];
    lable2.text = @"星期二";
    
    lable3 = [[UILabel alloc]init];
    [self.view addSubview:lable3];
    lable3.text = @"星期三";
    
    lable4 = [[UILabel alloc]init];
    [self.view addSubview:lable4];
    lable4.text = @"星期四";
    
    lable5 = [[UILabel alloc]init];
    [self.view addSubview:lable5];
    lable5.text = @"星期五";
    
    lable6 = [[UILabel alloc]init];
    [self.view addSubview:lable6];
    lable6.text = @"星期六";
    
    lable7 = [[UILabel alloc]init];
    [self.view addSubview:lable7];
    lable7.text = @"星期天";
    
    //设置frame
    //wifi状态提示文本
    wifiStateText.frame = CGRectMake(0, 64 + verticalSpace, self.view.frame.size.width, 20);
    //星期一
    line1.frame = CGRectMake(textSize.width + left_right_margin, CGRectGetMaxY(wifiStateText.frame) +  verticalSpace, self.view.frame.size.width - 2*left_right_margin - textSize.width, line1.getHeight);
    lable1.frame = CGRectMake(left_right_margin, CGRectGetMaxY(line1.frame) - textSize.height - 10, textSize.width, textSize.height);

    //星期二
    line2.frame = CGRectMake(textSize.width + left_right_margin, CGRectGetMaxY(line1.frame), self.view.frame.size.width - 2*left_right_margin - textSize.width, line1.getHeight);
    lable2.frame = CGRectMake(left_right_margin, CGRectGetMaxY(line2.frame) - textSize.height - 10, textSize.width, textSize.height);
    
    //星期三
    line3.frame = CGRectMake(textSize.width + left_right_margin, CGRectGetMaxY(line2.frame), self.view.frame.size.width - 2*left_right_margin - textSize.width, line1.getHeight);
    lable3.frame = CGRectMake(left_right_margin, CGRectGetMaxY(line3.frame) - textSize.height - 10, textSize.width, textSize.height);
    
    //星期四
    line4.frame = CGRectMake(textSize.width + left_right_margin, CGRectGetMaxY(line3.frame), self.view.frame.size.width - 2*left_right_margin - textSize.width, line1.getHeight);
    lable4.frame = CGRectMake(left_right_margin, CGRectGetMaxY(line4.frame) - textSize.height - 10, textSize.width, textSize.height);
    
    //星期五
    line5.frame = CGRectMake(textSize.width + left_right_margin, CGRectGetMaxY(line4.frame), self.view.frame.size.width - 2*left_right_margin - textSize.width, line1.getHeight);
    lable5.frame = CGRectMake(left_right_margin, CGRectGetMaxY(line5.frame) - textSize.height - 10, textSize.width, textSize.height);
    
    //星期六
    line6.frame = CGRectMake(textSize.width + left_right_margin, CGRectGetMaxY(line5.frame), self.view.frame.size.width - 2*left_right_margin - textSize.width, line1.getHeight);
    lable6.frame = CGRectMake(left_right_margin, CGRectGetMaxY(line6.frame) - textSize.height - 10, textSize.width, textSize.height);
    
    //星期天
    line7.frame = CGRectMake(textSize.width + left_right_margin, CGRectGetMaxY(line6.frame), self.view.frame.size.width - 2*left_right_margin - textSize.width, line1.getHeight);
    lable7.frame = CGRectMake(left_right_margin, CGRectGetMaxY(line7.frame) - textSize.height - 10, textSize.width, textSize.height);
    
    //修改按钮
    modify = [[SHRectangleButton alloc]init];
    [modify setTitle:@"修改" forState:UIControlStateNormal];
    modify.frame = CGRectMake(left_right_margin, CGRectGetMaxY(line7.frame) + verticalSpace, self.view.frame.size.width - 2*left_right_margin, 40);
   
    [self.view addSubview:modify];
    
    
    
    lines = @[line7,line1,line2,line3,line4,line5,line6];
    
    //给时间线设置监听
    for(TimeLineView * line in lines)
    {
        [line addTarget:self action:@selector(goToModifyWifiClock:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    //设置事件监听
    [modify addTarget:self action:@selector(goToModifyWifiClock:) forControlEvents:UIControlEventTouchUpInside];
  }

-(void)viewWillAppear:(BOOL)animated
{
    
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
       NSError *error;
        [[SHRouter currentRouter] getWifiClockInfo:&error];
        //将获取的定时信息展示出来
        if(error == nil)
        {
            int i = 0;
            for(NSArray *array in [SHRouter currentRouter].wifiClocks)
            {
                int array0 = [array[0] intValue];
                int array1 = [array[1] intValue];
                int array2 = [array[2] intValue];
                int array3 = [array[3] intValue];
                int array4 = [array[4] intValue];
                
                //默认wifi处于开启状态
                if(array0 == 1)
                {
                    if(array1 == 0)
                    {
                        //全天开启
                        [lines[i] setTimes:@[@0, @(24*60)]];
                    }
                    else
                    {
                        if(array2 == 0)
                        {
                            [lines[i] setTimes:@[@0, array[1]]];
                        }
                        else
                        {
                            if(array3 == 0)
                            {
                                [lines[i] setTimes:@[@0, array[1], array[2]]];
                            }
                            else
                            {
                                if(array4 == 0)
                                {
                                    [lines[i] setTimes:@[@0, array[1], array[2], array[3]]];
                                }
                            }
                        }
                    }
                }
                else
                {
                    //初始状态是关闭
                    if(array3 == 0)
                    {
                        [lines[i] setTimes:@[array[1], array[2]]];
                    }
                    else
                    {
                        if(array4 != 0)
                        {
                            [lines[i] setTimes:@[array[1], array[2], array[3], array[4]]];
                        }
                        else
                        {
                            [lines[i] setTimes:@[array[1], array[2], array[3]]];
                        }
                    }
                }
            
                i++;
            }
            
            //获取定时开关状态，是开还是关
            int wifiClockState = [SHRouter currentRouter].wlanSchedState;
            if(wifiClockState == 0)
            {
                toggle.on = NO;
                wifiStateText.text = @"wifi定时开关功能已经关闭";
                
                [self.view addSubview:over];
                //self.view.userInteractionEnabled = false;
            }
            else
            {
                toggle.on = YES;
                wifiStateText.text = @"wifi定时开关功能已经开启";
                //self.view.userInteractionEnabled = true;
                [over removeFromSuperview];
            }
        }
        else
        {
            if(error.code == SHControlStatus_Failed)
            {
                //用户未登陆,跳到登陆界面
                [self.navigationController popToRootViewControllerAnimated:YES];
                [DialogUtil createAndShowDialogWithTitle:nil message:@"您未登陆，请先登陆"];
            }
            else
            {
                for(UIView *view in self.view.subviews)
                {
                    [view removeFromSuperview];
                }
                FaildView *failedView = [[FaildView alloc]init];
                [failedView setMessage:@"出错了,可能是网络连接故障，请返回搜索界面重新连接路由器"];
                [self.view addSubview:failedView];
            }
        }
   // });
}


-(void)wifi_toggle:(UISwitch*)paramSender
{
   
    NSMutableArray *wifiClockInfo = [SHRouter currentRouter].wifiClocks;
    NSMutableArray *wifiClockJson = [[NSMutableArray alloc]initWithCapacity:7];
    for(int i = 0; i < wifiClockInfo.count; i++)
    {
       
        NSArray *timeArray = wifiClockInfo[i];
        
        NSDictionary *tmp = @{@"INIT_STATE":timeArray[0], @"TIME1":timeArray[1], @"TIME2":timeArray[2],@"TIME3":timeArray[3],@"TIME4":timeArray[4]};
        [wifiClockJson addObject:tmp];
    }
    
    if(paramSender.isOn)
    {
        NSLog(@"switch is on");
        [SHRouter currentRouter].wlanSchedState = YES;
    }
    else
    {
        NSLog(@"switch is off");
        [SHRouter currentRouter].wlanSchedState = NO;
    }
    __block BOOL ret;
    [SHProgressDialog showDialog:@"正在设置wifi定时参数" ViewController:self];
    [hud showAnimated:YES whileExecutingBlock:^{
        ret = [[SHRouter currentRouter] setUpWifiClock:[SHRouter currentRouter].wlanSchedState ?@1 : @0 wlanSched:wifiClockJson error:nil];
    } completionBlock:^{
        [SHProgressDialog dismiss];
        if(!ret)
        {
            //[Utils showToast:@"出错了,设置失败 " viewController:self.navigationController];
            [toggle setOn:!toggle.isOn];
             [DialogUtil createAndShowDialogWithTitle:nil message:@"设置失败,出错了,请返回搜索界面重新连接路由器"];
        }
        else
        {
            [Utils showToast:@"设置成功" viewController:self.navigationController];
            if(!toggle.isOn)
            {
                wifiStateText.text = @"wifi定时开关功能已经关闭";
                [self.view addSubview:over];
            }
            else
            {
                wifiStateText.text = @"wifi定时开关功能已经开启";
               
                //self.view.userInteractionEnabled = true;
                [over removeFromSuperview];
            }
        }
    }];

}

-(void)goToModifyWifiClock:(id)target
{
    _target = target;
    [self performSegueWithIdentifier:@"wifiClockInfo2WifiClockSetup" sender:self];
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    WifiClockSetupViewController *controller = segue.destinationViewController;
    if(_target == line1)
    {
        [controller setID:1];
    }
    else if(_target == line2)
    {
        [controller setID:2];
    }
    else if(_target == line3)
    {
        [controller setID:3];
    }
    else if(_target == line4)
    {
        [controller setID:4];
    }
    else if(_target == line5)
    {
        [controller setID:5];
    }
    else if(_target == line6)
    {
        [controller setID:6];
    }
    else if(_target == line7)
    {
        [controller setID:0];
    }
    else
    {
        [controller setID:7];
    }
}
@end
