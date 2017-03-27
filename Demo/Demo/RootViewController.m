//
//  RootViewController.m
//  Demo
//
//  Created by mac on 16/6/12.
//  Copyright © 2016年 com.medica. All rights reserved.
//

#import "RootViewController.h"
#import <RestOnBluetooth/RestonBLEHelper.h>
#import <RestOnBluetooth/AllSleepData.h>
#import <RestOnBluetooth/RestonBleManager.h>

//#import "BLEHelper.h"
//#import "AllSleepData.h"
//#import "BleManager.h"


#import "ShowFuctionViewController.h"

@interface RootViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *devListTableView;

@property (strong, nonatomic) IBOutlet UILabel *devIdLabel;

@property (strong, nonatomic) IBOutlet UILabel *devNameLabel;

@property (strong, nonatomic) IBOutlet UIButton *searchDevBtn;

@property (strong, nonatomic) IBOutlet UIButton *showFunctionBtn;

@property (strong, nonatomic) IBOutlet UIView *selectedDeviceSuccessView;
@end

@implementation RootViewController
{
    //扫描出的设备名称列表
    NSMutableArray *deviceArr;
    
    //选择的设备的ID
    __block NSString *selectedDeviceID;
    
    //选择的设备的名称
    NSMutableString *selectedDeviceName;
    
    /// 待连接的外设
    CBPeripheral *peripheralWaitForConnect_;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.devListTableView.dataSource = self;
    self.devListTableView.delegate = self;
    
    [RestonBleManager sharedInstance];
    [RestonBleHelper share];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showDeviceId
{
    self.devIdLabel.text = selectedDeviceID;
    self.devNameLabel.text = selectedDeviceName;
    self.selectedDeviceSuccessView.hidden = NO;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    if (deviceArr)
    {
        [deviceArr removeAllObjects];
        [self.devListTableView reloadData];
    }
}

#pragma mark -buttonPress

- (IBAction)searchDevBtnPress:(id)sender
{
    if (!deviceArr)
    {
        deviceArr = [NSMutableArray array];
    }
    else
    {
        [deviceArr removeAllObjects];
        [self.devListTableView reloadData];
    }
    
    [SLPRestonBleManager scanfPeripheralWithWithSuccess:^(NSString *ID, NSString *name, CBPeripheral *peripheral) {
        for (NSDictionary *dict in deviceArr)
        {
            NSString *tempID = [dict objectForKey:@"ID"];
            if (ID && [ID isEqualToString:tempID])
            {
                return;
            }
        }
        
        if (ID && ID.length)
        {
            NSDictionary *peripheralDict = [NSDictionary dictionaryWithObjectsAndKeys:ID,@"ID",name,@"name",peripheral,@"peripheral", nil];
            [deviceArr addObject:peripheralDict];
            [self.devListTableView reloadData];
        }
    }];
}

- (IBAction)showFunctionBtnPress:(id)sender
{
    if (!selectedDeviceID || !selectedDeviceName)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"请先选择您的设备,成功获取设备ID后才能进行此操作" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    self.selectedDeviceSuccessView.hidden = YES;
    [SLPRestonBleManager bleDisconnectPeripheralWithsuccess:nil];//此处断开蓝牙,为了完整演示连接-登录设备过程
    ShowFuctionViewController *showFuctionVC = [[ShowFuctionViewController alloc]initWithDeviceName:selectedDeviceName andDeviceID:selectedDeviceID];
    [self.navigationController pushViewController:showFuctionVC animated:YES];
}

- (IBAction)reSelectedDeviceBtnPress:(id)sender
{
    [SLPRestonBleManager bleDisconnectPeripheralWithsuccess:nil];
    self.selectedDeviceSuccessView.hidden = YES;
    [self searchDevBtnPress:nil];
}


#pragma mark -UITableViewDelegate & UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  30;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count;
    count = deviceArr.count;
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellWithIdentifier = @"deviceName";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellWithIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellWithIdentifier];
    }
    
    NSUInteger row = [indexPath row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@",[deviceArr[row] objectForKey:@"name"]?[deviceArr[row] objectForKey:@"name"]:@"",[deviceArr[row] objectForKey:@"ID"]];
    cell.textLabel.textColor = [UIColor blackColor];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.font = [UIFont systemFontOfSize:13];
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    cell.contentView.backgroundColor = [UIColor clearColor];
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [SLPRestonBleManager.centerManager stopScan];//停止扫描设备
    if (deviceArr && indexPath.row < deviceArr.count)
    {
        selectedDeviceName = [NSMutableString stringWithFormat:@"%@",[deviceArr[indexPath.row] objectForKey:@"ID"]];
        [selectedDeviceName insertString:@"-" atIndex:2];//设备名称
        peripheralWaitForConnect_ = [deviceArr[indexPath.row] objectForKey:@"peripheral"];
        
        __weak typeof(self) weakSelf = self;
        [SLPRestonBleManager bleConnectWithPeripheral:peripheralWaitForConnect_ success:^{
            [weakSelf getDevInfoWithCBPeripheral:peripheralWaitForConnect_ andDeviceName:selectedDeviceName];
            
        } failure:^(NSString *error) {
           UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"连接失败,请重试" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }];
    }
}



#pragma mark -BlueAction

- (void)getDevInfoWithCBPeripheral:(CBPeripheral *)peripheral andDeviceName:(NSString *)deviceName
{
    
    __weak typeof(self) weakSelf = self;
    [SLPRestonBleHelper initWithPeripheral:peripheral readCharactertic:SLPRestonBleManager.readCharactertic];
    
    [SLPRestonBleHelper getRestonIDwithDeviceName:selectedDeviceName Success:^(NSString *deviceID) {
        selectedDeviceID = deviceID;
        [weakSelf showDeviceId];
    } failure:^{
        NSLog(@"fail>>>>");
    }];

}


@end
