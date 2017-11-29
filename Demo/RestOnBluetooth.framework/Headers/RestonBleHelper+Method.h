//
//  RestonBleHelper+Method.h
//  Demo
//
//  Created by San on 2017/4/17.
//  Copyright © 2017年 com.medica. All rights reserved.
//

#import "RestonBleHelper.h"

@interface RestonBleHelper (Method)

/**
 *  获取原始数据信号强度
 *
 *  @param success 成功
 *  @param failure 失败
 *  @param singalValueString 原始数据信号强度（h_b_m,h_b_m,...）
 *  @param h  心跳强度(范围0~1)
 *  @param b  呼吸强度(范围0~1)
 *  @param m  体动强度(范围0~1)
 *
 */
- (void)getOriginalSingalDataOfIntensitySuccess:(void (^)(NSString *singalValueString))success
                                        failure:(void (^)(void))failure;

/**
 *  获取未经算法分析的原始数据信号
 *
 *  @param completion 回调
 *  @param id responseObject 返回数组
 *
 */
- (void)getOriginalSingalDataWhioutParseCompletion:(void (^)(id responseObject))completion;

//停止获取原始数据信号强度
- (void)stopGetOriginalSingalDataOfIntensity;


@end
