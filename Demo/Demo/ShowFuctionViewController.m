//
//  ShowFuctionViewController.m
//  Demo
//
//  Created by mac on 16/6/12.
//  Copyright © 2016年 com.medica. All rights reserved.
//

#import "ShowFuctionViewController.h"
#import <RestOnBluetooth/RestonBLEHelper.h>
#import <RestOnBluetooth/AllSleepData.h>
#import <RestOnBluetooth/RestonBleManager.h>
#import <RestOnBluetooth/RestonBleHelper+Method.h>

//屏幕大小
#define SCREEN_HEIGHT   [[UIScreen mainScreen] bounds].size.height
#define SCREEN_WIDTH   [[UIScreen mainScreen] bounds].size.width
@interface ShowFuctionViewController ()

@property (strong, nonatomic) IBOutlet UIButton *scanAndConnectedDevBtn;
@property (strong, nonatomic) IBOutlet UIButton *loginDeviceBtn;
@property (strong, nonatomic) IBOutlet UIButton *getDeviceWorkingStatusBtn;
@property (strong, nonatomic) IBOutlet UIButton *startDeviceWorkingBtn;
@property (strong, nonatomic) IBOutlet UIButton *stopDeviceWorkingBtn;
@property (strong, nonatomic) IBOutlet UIButton *getBatteryStatusBtn;
@property (strong, nonatomic) IBOutlet UIButton *getHistoryDataBtn;
@property (strong, nonatomic) IBOutlet UIButton *playRealTimeDataBtn;
@property (strong, nonatomic) IBOutlet UIButton *stopRealTimeDataBtn;
@property (strong, nonatomic) IBOutlet UIButton *disConnectedBtn;
@property (strong, nonatomic) IBOutlet UIButton *getDeviceVersionBtn;
@property (strong, nonatomic) IBOutlet UIButton *setAutoStartWorkingBtn;
@property (strong, nonatomic) IBOutlet UIButton *setAlarmInfoBtn;
@property (strong, nonatomic) IBOutlet UIButton *upgradeDevice;

@property (strong, nonatomic) IBOutlet UILabel *scanAndConnectedDevResultLaebel;
@property (strong, nonatomic) IBOutlet UILabel *loginDeviceStatusLabel;
@property (strong, nonatomic) IBOutlet UILabel *getDeviceWorkingStatusResultLabel;
@property (strong, nonatomic) IBOutlet UILabel *startDeviceWorkingResultLabel;
@property (strong, nonatomic) IBOutlet UILabel *stopDeviceWorkingResultLabel;
@property (strong, nonatomic) IBOutlet UILabel *batteryStatusResultLabel;
@property (strong, nonatomic) IBOutlet UILabel *getHistoryDataResultLabel;
@property (strong, nonatomic) IBOutlet UILabel *getDeviceVersionResultLabel;
@property (strong, nonatomic) IBOutlet UILabel *setAutoStartWorkingResultLabel;
@property (strong, nonatomic) IBOutlet UILabel *setAlarmInfoResultLabel;
@property (strong, nonatomic) IBOutlet UILabel *heartBeatRateLabel;
@property (strong, nonatomic) IBOutlet UILabel *breathRateLabel;
@property (strong, nonatomic) IBOutlet UILabel *sleepStatusLabel;
@property (strong, nonatomic) IBOutlet UILabel *asleepStatusLabel;
@property (strong, nonatomic) IBOutlet UILabel *upgrdeProgressLabel;

@property (strong, nonatomic) IBOutlet UIView *fuctionView;
@property (strong, nonatomic) IBOutlet UIScrollView *contentScrollView;



@end

@implementation ShowFuctionViewController
{
    //设备名
    NSString *deviceName_;
    
    //设备ID
    NSString *deviceId_;
    
    // 待连接的外设
    CBPeripheral *peripheralWaitForConnect_;
}

- (id)initWithDeviceName:(NSString *)deviceName andDeviceID:(NSString *)deviceID
{
    self = [super init];
    if (self) {
        deviceName_ = deviceName;
        deviceId_ = deviceID;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initUI];
    
    //设备低电量通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(betteryLowNotify) name:BETTERYLOWNOTIFIY object:nil];
    
    //系统蓝牙开启通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(systemBluetoothPowerOnNotify) name:kNotifyBluetoothPoweron object:nil];
    
    //系统蓝牙关闭通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(systemBluetoothPowerOffNotify) name:kNotifyBluetoothPoweroff object:nil];
    
    //蓝牙连接断开通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(deviceDisconnectNotify) name:kNotifyBluetoothDisconnect object:nil];
    
    //蓝牙已连接上设备
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(deviceConnectedNotify) name:kNotifyBluetoothConnected object:nil];
}

- (void)initUI
{
    CGRect scrollRect = self.contentScrollView.frame;
    scrollRect.size.height = SCREEN_HEIGHT - scrollRect.origin.y;
    self.contentScrollView.frame = scrollRect;
    self.contentScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, self.fuctionView.frame.size.height + 20);
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -NSNotify

- (void)betteryLowNotify
{
    NSLog(@"您的设备电量过低,请及时充电");
}

- (void)systemBluetoothPowerOnNotify
{
    NSLog(@"系统蓝牙已开启");
}

- (void)systemBluetoothPowerOffNotify
{
    NSLog(@"系统蓝牙已关闭");
    [self refreshUIwithUnConnected];
}

- (void)deviceDisconnectNotify
{
    NSLog(@"设备已断开连接");
    [self refreshUIwithUnConnected];
}

- (void)deviceConnectedNotify
{
    NSLog(@"设备已连接");
}




#pragma mark -UIRefresh

- (void)refreshUIwithUnConnected
{
    [self resetRealTimeView];
    self.fuctionView.alpha = 0.5;
    self.fuctionView.userInteractionEnabled = NO;
    self.scanAndConnectedDevResultLaebel.text = @"未连接";
    self.loginDeviceStatusLabel.text = @"未登录";
}

- (void)resetRealTimeView
{
    self.heartBeatRateLabel.text = @"--";
    self.breathRateLabel.text = @"--";
    self.sleepStatusLabel.text = @"--";
    self.asleepStatusLabel.text = @"--";
}

- (void)showRealTimeData:(NSDictionary *)realTimeDic
{
    //入睡标记(1为入睡,其他值无效)
    BOOL isAwake = [[realTimeDic objectForKey:@"awakeFlag"]boolValue];
    
    //清醒标记(1为清醒,其他值无效)
    BOOL isAsleep = [[realTimeDic objectForKey:@"sleepFlag"]boolValue];
    
    //心率
    NSInteger heartBeat = [[realTimeDic objectForKey:@"hr"]integerValue];
    
    //呼吸
    NSInteger breathRate = [[realTimeDic objectForKey:@"br"]integerValue];
    
    //当前状态
    NSInteger status = [[realTimeDic objectForKey:@"status"]integerValue];
    
    //与status对应,当前状态的持续时间
    NSInteger statusValue = [[realTimeDic objectForKey:@"statusValue"]integerValue];
    
    
    NSString *statusStr = @"--";
    if (status == 0)
    {
        statusStr = @"正常";
    }
    else if (status == 1)
    {
        statusStr = @"初始化";
    }
    else if (status == 2)
    {
        statusStr = @"呼吸暂停";
    }
    else if (status == 3)
    {
        statusStr = @"心跳暂停";
    }
    else if (status == 4)
    {
        statusStr = @"体动";
    }
    else if (status == 5)
    {
        statusStr = @"离床";
    }
    else if (status == 6)
    {
        statusStr = @"翻身";
    }
    
    self.heartBeatRateLabel.text = [NSString stringWithFormat:@"%d",heartBeat];
    self.breathRateLabel.text = [NSString stringWithFormat:@"%d",breathRate];
    self.sleepStatusLabel.text = [NSString stringWithFormat:@"%@ 持续时间:%d秒",statusStr,statusValue];
    self.asleepStatusLabel.text = isAsleep?@"入睡":(isAwake?@"清醒":@"--");
}

#pragma mark -ButtonAction

- (IBAction)getDeviceVersionBtnPess:(id)sender
{
    __weak typeof(self) weakSelf = self;
    [SLPRestonBleHelper getDeviceVersionWithSuccess:^(NSString *softwareVersion, NSString *hardwareVersion) {
        NSLog(@"software-->:%@,hardware-->:%@",softwareVersion,hardwareVersion);
        weakSelf.getDeviceVersionResultLabel.text = softwareVersion;;
    } failure:^{
        weakSelf.getDeviceVersionResultLabel.text = @"获取失败";
    }];
}


- (IBAction)scanAndConnectedDevBtnPress:(id)sender
{
    __weak typeof(self) weakSelf = self;
    [SLPRestonBleManager scanfPeripheralWithWithSuccess:^(NSString *ID, NSString *name, CBPeripheral *peripheral) {
        
        NSMutableString *devIDstr = [NSMutableString stringWithString:[NSString stringWithFormat:@"%@",ID]];
        if (devIDstr && devIDstr.length > 3)
        {
            [devIDstr insertString:@"-" atIndex:2];
        }
        if ([devIDstr isEqualToString:deviceName_])
        {
            //找到设备
            weakSelf.scanAndConnectedDevResultLaebel.text = @"设备已找到";
            peripheralWaitForConnect_ = peripheral;
            [SLPRestonBleManager.centerManager stopScan];
            if (SLPRestonBleManager.currentPeripheral && SLPRestonBleManager.currentPeripheral != peripheralWaitForConnect_)//断开旧蓝牙连接
            {
                [SLPRestonBleManager.centerManager cancelPeripheralConnection:SLPRestonBleManager.currentPeripheral];
            }
            //连接设备
            [SLPRestonBleManager bleConnectWithPeripheral:peripheralWaitForConnect_ success:^{
                weakSelf.scanAndConnectedDevResultLaebel.text = @"设备已连接";
    
            } failure:^(NSString *error) {
                weakSelf.scanAndConnectedDevResultLaebel.text = @"连接设备失败";
            }];
        }
    }];
}

- (IBAction)loginDeviceBtnPress:(id)sender
{
    __weak typeof(self) weakSelf = self;
    [SLPRestonBleHelper initWithPeripheral:SLPRestonBleManager.currentPeripheral readCharactertic:SLPRestonBleManager.readCharactertic];
    [SLPRestonBleHelper loginDeviceWithDeviceID:deviceId_ andUserID:0 andTimeZone:(int)[[NSTimeZone localTimeZone] secondsFromGMT] success:^(NSInteger status) {
        weakSelf.loginDeviceStatusLabel.text = @"登录成功";
        weakSelf.fuctionView.alpha = 1.0;
        weakSelf.fuctionView.userInteractionEnabled = YES;
    } failure:^{
        weakSelf.loginDeviceStatusLabel.text = @"登录失败";
    }];
}

- (IBAction)getDeviceWorkingStatusBtnPress:(id)sender
{
    __weak typeof(self) weakSelf = self;
    [[RestonBleHelper share] getDeviceSamplingWithSuccess:^(NSInteger status) {
        
        if (status == 1)//1 已经处于采集状态
        {
            weakSelf.getDeviceWorkingStatusResultLabel.text = @"设备正在采集数据";
        }
        else
        {
            weakSelf.getDeviceWorkingStatusResultLabel.text = @"设备未采集";
        }
    } failure:nil];
}

- (IBAction)startDeviceWorkingBtnPress:(id)sender
{
    __weak typeof(self) weakSelf = self;
    [SLPRestonBleHelper setDeviceSamplingWithStatus:1 success:^(NSInteger status) {
        weakSelf.startDeviceWorkingResultLabel.text = @"开启采集成功";
        weakSelf.getDeviceWorkingStatusResultLabel.text = @"设备正在采集数据";
    } failure:^{
        weakSelf.startDeviceWorkingResultLabel.text = @"开启采集失败";
    }];
}

- (IBAction)stopDeviceWorkingBtnPress:(id)sender
{
    __weak typeof(self) weakSelf = self;
    [SLPRestonBleHelper setDeviceSamplingWithStatus:0 success:^(NSInteger status) {
        weakSelf.stopDeviceWorkingResultLabel.text = @"停止采集成功";
        weakSelf.getDeviceWorkingStatusResultLabel.text = @"设备未采集";

    } failure:^{
        weakSelf.startDeviceWorkingResultLabel.text = @"停止采集失败";
    }];
}

- (IBAction)getBatteryStatusBtnPress:(id)sender
{
    __weak typeof(self) weakSelf = self;
    [SLPRestonBleHelper getDevicePowerStatusSuccess:^(NSInteger status) {
        weakSelf.batteryStatusResultLabel.text = [NSString stringWithFormat:@"电量剩余%d%%",status];
    } failure:^{
        weakSelf.batteryStatusResultLabel.text = @"获取电量失败";
    }];
}

- (IBAction)getHistoryDataBtnPress:(id)sender
{
    __weak typeof(self) weakSelf = self;
    long startTime = 0  ;
    long endTime = [[NSDate date] timeIntervalSince1970];
    __block NSInteger historySum = 0;
    __block NSInteger downLoadedDataCount = 0;
    [SLPRestonBleHelper getHistoryDataWithStartTime:startTime andEndTime:endTime sumBlock:^(NSInteger sum) {
        //返回数据总数
        historySum = sum;
        if (0 == sum)
        {
            weakSelf.getHistoryDataResultLabel.text = @"暂无历史数据";
        }
    } EachDataBlock:^(AllSleepData *sleepData) {
        //在此处处理下载的数据...
        downLoadedDataCount++;
        weakSelf.getHistoryDataResultLabel.text = [NSString stringWithFormat:@"已下载%d/%d",downLoadedDataCount,historySum];
    } completion:^{
        //数据下载完毕
        weakSelf.getHistoryDataResultLabel.text = @"下载完成";
    }];
    
}

- (IBAction)setAutoStartWorkingBtnPress:(id)sender
{
    __weak typeof(self) weakSelf = self;
    
    //设RestON 23:00开始自动监测,工作日生效
    NSMutableArray *repeatTimeArr = [NSMutableArray arrayWithObjects:@"0",@"0",@"1",@"1",@"1",@"1",@"1", nil];
    [SLPRestonBleHelper setAutoGatherTimeDataValid:1 hour:23 minutes:0 array:repeatTimeArr Success:^{
        weakSelf.setAutoStartWorkingResultLabel.text = @"设置成功";
    } failure:^{
        weakSelf.setAutoStartWorkingResultLabel.text = @"设置失败";
    }];
}

- (IBAction)setAlarmInfoBtnPress:(id)sender
{
    __weak typeof(self) weakSelf = self;
    //设置RestOn闹铃信息,闹铃时间7:20 响起时间为6:50 - 7:20,工作日生效
    NSMutableArray *repeatTimeArr = [NSMutableArray arrayWithObjects:@"0",@"0",@"1",@"1",@"1",@"1",@"1", nil];
    [SLPRestonBleHelper setAlarmInfoWithValid:1 offset:30 hour:7 minutes:20 weekArr:repeatTimeArr Success:^{
        weakSelf.setAlarmInfoResultLabel.text = @"设置成功";
    } failure:^{
        weakSelf.setAlarmInfoResultLabel.text = @"设置失败";
    }];
}

- (IBAction)playRealTimeDataBtnPress:(id)sender
{
    __weak typeof(self) weakSelf = self;
    
    //设备需要处于采集状态时才能获取到实时数据,
    [[RestonBleHelper share] getDeviceSamplingWithSuccess:^(NSInteger status) {
        
        if (status == 1)//1 已经处于采集状态
        {
            [SLPRestonBleHelper startRealValueWithSuccess:^(NSDictionary *dict) {
                [weakSelf showRealTimeData:dict];
            }];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"请先开启设备采集状态" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
    } failure:^{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"与设备通信失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }];
}

///start upgrade device
- (IBAction)startUpgradeDevice:(id)sender
{
    NSString *filepath=[[NSBundle mainBundle] pathForResource:@"Z200_20160624.1.11_Org_Beta" ofType:@"des"];
    NSData *package=[NSData dataWithContentsOfFile:filepath];
    
    long crcDes=2978179265;
    long crcBin=558318951;
    
    [SLPRestonBleHelper getDeviceVersionWithSuccess:^(NSString *softwareVersion, NSString *hardwareVersion) {
        
        [SLPRestonBleHelper upgradeDeviceWithsoftwareVersion:softwareVersion hardwareVerison:hardwareVersion crcDes:crcDes crcBin:crcBin upgradePackage:[NSMutableData dataWithData:package] Progress:^(NSInteger currentCount, NSInteger total) {
            // 显示升级进度
            self.upgrdeProgressLabel.text=[NSString stringWithFormat:@"%.2f%%",100.0*currentCount/(CGFloat)total];
        } completion:^(BOOL fishish) {
            self.upgrdeProgressLabel.text=@"Upgrade Done";
        }];
        
    } failure:^{
        self.getDeviceVersionResultLabel.text = @"获取固件版本失败";
    }];
    
}


- (IBAction)stopRealTimeDataBtnPress:(id)sender
{
    [SLPRestonBleHelper stopRealValue];
    //延迟2秒
    double delayInSeconds = 2;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self resetRealTimeView];
    });
}

- (IBAction)disConnectedBtnPress:(id)sender
{
    __weak typeof(self) weakSelf = self;
    [SLPRestonBleManager bleDisconnectPeripheralWithsuccess:^{
        [weakSelf refreshUIwithUnConnected];
    }];//断开与设备连接
}

- (IBAction)backBtnPress:(id)sender
{
    [SLPRestonBleManager bleDisconnectPeripheralWithsuccess:^{
        
    }];//断开与设备连接
    [self.navigationController popViewControllerAnimated:YES];
}


@end
