//
//  BleManager.h
//  MAIDIJIA
//
//  Created by Yajie Deng on 14-8-1.
//  Copyright (c) 2014年 chenchangrong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#define SLPRestonBleManager [RestonBleManager sharedInstance]

@interface RestonBleManager : NSObject<CBCentralManagerDelegate,CBPeripheralDelegate>
@property(nonatomic,strong)CBCentralManager  *centerManager;
@property(nonatomic,strong)CBPeripheral      *currentPeripheral;
@property(nonatomic,strong)CBCharacteristic  *readCharactertic;
@property(nonatomic,strong)CBCharacteristic  *writeCharactertic;

+ (RestonBleManager*) sharedInstance;

//销毁单例
-(void)destroy;

//是否已连接设备
- (BOOL)isConnected;

//扫描设备
-(void)scanfPeripheralWithWithSuccess:(void(^)(NSString * ID, NSString *name, CBPeripheral *peripheral))success;

//连接设备
-(void)bleConnectWithPeripheral:(CBPeripheral *)peripheral
                        success:(void (^)(void))success
                        failure:(void (^)(NSString *error))failure;

//清除连接请求的block
- (void)clearConnectRequestHandle;

/**
 *  主动断开蓝牙连接,不触发重连操作
 */
-(void)bleDisconnectPeripheralWithsuccess:(void (^)(void))success;


@end
