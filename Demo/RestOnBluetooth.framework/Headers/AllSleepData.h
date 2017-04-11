
#import <Foundation/Foundation.h>


// 睡眠等级
typedef enum {
    SLEEP_STATUS_OK = 0x00,	//一切正常
    SLEEP_STATUS_INIT,		//初始化状态，约10秒时间
    SLEEP_STATUS_B_STOP,		//呼吸暂停
    SLEEP_STATUS_H_STOP,		//心跳暂停
    SLEEP_STATUS_BODYMOVE,		//体动
    SLEEP_STATUS_LEAVE,		//离床
    SLEEP_STATUS_TURN_OVER,	//翻身
} S_SLEEP_STATUS;

@interface AllSleepData : NSObject

//呼吸数据(一分钟一个数据)
@property(nonatomic,strong)NSMutableArray *breathRateArray;

//心率数据(一分钟一个数据)
@property(nonatomic,strong)NSMutableArray *heartRateArray;

/*sleepStateArray 睡眠等级数据，说明：
 0	清醒
 1	浅睡
 2	中睡
 3	深睡
 */
@property(nonatomic,strong)NSMutableArray *sleepStateArray;//睡眠等级数据：

/*statusArray 睡眠状态字段，说明：
 0	一切正常
 1	初始化状态
 2	呼吸暂停
 3	心跳暂停
 4	体动
 5	离床
 6	翻身
 */
/*注意
 **假如字段值是 value
 *状态值就是   value & 0x07
 */
@property(nonatomic,strong)NSMutableArray *statusArray;

/*statusValueArray 睡眠状态值，说明：
 statusValueArray的值与statusArray相对应，例如statusArray[3]=6,statusValueArray[3]=5,表示第3分钟的睡眠状态为6，即翻身。第三分钟的翻身次数为5次。
 */
@property(nonatomic,strong)NSMutableArray *statusValueArray;//睡眠状态值

//睡眠分数
@property(nonatomic,assign)NSInteger sleepScore;

//开始睡觉的日期
@property(nonatomic,strong)NSString  *date;

//开始睡的Unix时间戳(timeIntervalSince1970)
@property(nonatomic,strong)NSNumber  *startTime;

//时区([NSTimeZone systemTimeZone] secondsFromGMT])
@property(nonatomic,strong)NSNumber  *timezone;

//睡眠总时长(分钟)
@property(nonatomic,strong)NSNumber  *duration;

//时间步(60)用户暂时用不到
@property(nonatomic,strong)NSNumber  *timeStep;

//总记录数(分钟)
@property(nonatomic,strong)NSNumber  *recordCount;

/*结束方式
 *   0: 正常结束
 *   1: 自动结束
 *   2: 强制结束(如:关机)
 *   3: 错误结束(如:供电不足、系统异常)
 */
@property(nonatomic,strong)NSNumber  *stopMode;

//深睡眠占总睡眠百分比(整数)
@property(nonatomic,strong)NSNumber *MdDeepSleepPerc;

//中睡百分比
@property(nonatomic,strong)NSNumber *MdRemSleepPerc;

//浅睡百分比
@property(nonatomic,strong)NSNumber *MdLightSleepPerc;

//清醒百分比
@property(nonatomic,strong)NSNumber *MdWakeSleepPerc;

//平均心率
@property (nonatomic,strong)NSNumber *MdAverHeartRate;

//平均呼吸率
@property (nonatomic,strong)NSNumber *MdAverBreathRate;

//清醒-入睡所花时间
@property (nonatomic,strong)NSNumber *MdFallasleepTime;

//起床前的那段清醒时间
@property (nonatomic,strong)NSNumber *MdWakeUpTime;

//离床次数
@property (nonatomic,strong)NSNumber *MdLeaveBedCnt;

//翻身次数
@property (nonatomic,strong)NSNumber *MdTurnOverCnt;

//体动次数
@property (nonatomic,strong)NSNumber *MdBodyMoveCnt;

//心脏骤停次数
@property (nonatomic,strong)NSNumber *MdHeartStopCnt;

//呼吸暂停次数
@property (nonatomic,strong)NSNumber *MdBreathStopCnt;

//清醒总时间
@property (nonatomic,strong)NSNumber *MdWakeAllTime;

//浅睡眠总时间
@property (nonatomic,strong)NSNumber *MdLightAllTime;

//中睡眠总时间
@property (nonatomic,strong)NSNumber *MdRemAllTime;

//深睡眠总时间
@property (nonatomic,strong)NSNumber *MdDeepAllTime;

//清醒总次数（包含离床）
@property (nonatomic,strong)NSNumber *MdWakeAllTimes;

//呼吸暂停总时长(单位S)
@property (nonatomic,strong)NSNumber *MdBreathStopAllTime;

//心跳暂停总时长(单位S)
@property (nonatomic,strong)NSNumber *MdHeartStopAllTime;

//离床时间总时长(单位S)
@property (nonatomic,strong)NSNumber *MdLeaveBedAllTime;

//最高心率
@property (nonatomic,strong)NSNumber *MdHeartRateMax;

//最高呼吸率
@property (nonatomic,strong)NSNumber *MdBreathRateMax;

//最低心率
@property (nonatomic,strong)NSNumber *MdHeartRateMin;

//最低呼吸率
@property (nonatomic,strong)NSNumber *MdBreathRateMin;

//心率过速时长
@property (nonatomic,strong)NSNumber *MdHeartRateHigthAllTime;

//心率过缓时长
@property (nonatomic,strong)NSNumber *MdHeartRateLowAllTime;

//呼吸率过速时长
@property (nonatomic,strong)NSNumber *MdBreathRateHigthAllTime;

//呼吸率过缓时长
@property (nonatomic,strong)NSNumber *MdBreathRateLowAllTime;

//数据来源,-1:手机监测 1:RestOnZ1 3:枕头 9:RestOnZ2
@property (nonatomic,strong)NSNumber *source;

//算法版本号
@property (nonatomic,strong)NSString *arithmeticVer;


//扣分项(用于生成建议,无须存数据库)

//心跳过速扣分
@property (nonatomic,strong)NSString *md_heart_high_decrease_scale;

//心跳过缓扣分
@property (nonatomic,strong)NSString *md_heart_low_decrease_scale;

//呼吸过速扣分
@property (nonatomic,strong)NSString *md_breath_high_decrease_scale;

//呼吸过缓扣分
@property (nonatomic,strong)NSString *md_breath_low_decrease_scale;

//心跳暂停扣分
@property (nonatomic,strong)NSString *md_heart_stop_decrease_scale;

//呼吸暂停扣分
@property (nonatomic,strong)NSString *md_breath_stop_decrease_scale;

//睡眠时间过长扣分
@property (nonatomic,strong)NSString *md_sleep_time_decrease_scale_long;

//睡眠时间过短扣分
@property (nonatomic,strong)NSString *md_sleep_time_decrease_scale_short;

//离床次数扣分
@property (nonatomic,strong)NSString *md_leave_bed_decrease_scale;

//清醒次数扣分
@property (nonatomic,strong)NSString *md_wake_cnt_decrease_scale;

//体动扣分,也叫躁动不安扣分
@property (nonatomic,strong)NSString *md_body_move_decrease_scale;

//深睡眠扣分
@property (nonatomic,strong)NSString *md_perc_deep_decrease_scale;

//难以入睡扣分
@property (nonatomic,strong)NSString *md_fall_asleep_time_decrease_scale;

//睡觉时间扣分(太晚睡)
@property (nonatomic,strong)NSString *md_start_time_decrease_scale;

//良性睡眠比例扣分
@property (nonatomic,strong)NSString *md_perc_effective_sleep_decrease_scale;

//良性睡眠扣分,(中睡/深睡 占入睡后时间百分比)
@property (nonatomic,strong)NSString *benignSleepLow;

//睡眠效率扣分
@property (nonatomic,strong)NSString *sleepaceEfficientLow;

//体动过少扣分,与躁动不安对应
@property (nonatomic,strong)NSString *bodyMoveLow;

//睡眠状态曲线(float, 0 - 3)
@property(nonatomic,strong)NSMutableArray *SleepCurveArray;

//睡眠曲线中的各类状态(离床&心率呼吸异常等标记)用于配合SleepCurveStr在日报告中画睡眠曲线图,
@property(nonatomic,strong)NSMutableArray *sleepCureStatusArray;

@end
