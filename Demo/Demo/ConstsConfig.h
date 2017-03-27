

//#import "Hdefine.h"

// 安全释放对象
#define SAFETY_RELEASE(x)   {[(x) release]; (x)=nil;}

// 文字字体HelveticaNeue-Light
#define DSFONT    @"HelveticaNeue-Light"

// 获得特定字号的字体
#define GETFONT(x) [UIFont fontWithName:DSFONT size:(x)]

//获取本地图片的路径
#define GETIMG(name)  [UIImage imageWithContentsOfFile: [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:name]]

#define  ISEQUAL(a,b) [a isEqualToString:b]

//以上是公用模块使用的宏
///////////////////////-------------------------华丽的分割线-----------------------/////////////////////////////////////////
//以下是单独模块使用的宏

#define IPADSCREEN [[UIScreen mainScreen] bounds]

#define WIDTH IPADSCREEN.size.height
#define HEIGHT IPADSCREEN.size.width

//点击返回按钮，移除页面动画持续时间(秒)
#define GOBACKANIMATEWITHDURATION 0.7
#define UserNameCurrent  @"UserNameCurrent"
#define UserIDCurrent  @"UserIDCurrent"
#define UserUserKeyCurrent  @"UserUserKeyCurrent"
#define UserMemberIDCurrent  @"UserMemberIDCurrent"
#define UserMembernicknameCurrent  @"UserMembernicknameCurrent"
#define UserMemberbrithdayCurrent  @"UserMemberbrithdayCurrent"
#define UserMemberSEXCurrent  @"UserMemberSEXCurrent"
#define UserMemberImgUrlCurrent  @"UserMemberImgUrlCurrent"
#define UserDeviceIDCurrent @"deviceID"
#define UsePassword  @"password"
#define UseDevVersionInfo  @"UseDevVersionInfo"
#define UseAppVersionInfo  @"UseAppVersionInfo"
#define IgnorVersion @"IgnorVersion"
#define UserIsAuto @"UserIsAuto"




#define D_VIEW_HEGHT self.view.frame.size.height
#define D_VIEW_WIDTH self.view.frame.size.width
#define D_VIEW_X self.view.frame.origin.x
#define D_VIEW_Y self.view.frame.origin.y

//屏幕大小
#define Screen_height   [[UIScreen mainScreen] bounds].size.height
#define Screen_width    [[UIScreen mainScreen] bounds].size.width

#define SideMenuSeletedItemCaptionColor [UIColor colorWithRed:12/255.0 green:219/255.0 blue:253/255.0 alpha:1]

#define SuppressPerformSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)

//固件版本为可同步原始数据的版本的宏开关 （正式发版时要关闭）
//#define DEGRADE_VERSION


////内测固件的宏开关 （正式发版时要关闭）
#define TEST_DEV_VERSION

// 范围
#define MixcRadius          1000

// 提示框停留的时间
#define AFTERDELAY          2.0

// 载入提示文字
#define LOADTEXT            @"载入中...."

#define FAILCOLOR   ([UIColor colorWithRed:226 / 255.0 green:231 / 255.0 blue:237.0 / 255.0 alpha:1.0])

//UIViewContentModeScaleToFill UIViewContentModeScaleAspectFill
#define UserHeadImageContentMode  UIViewContentModeScaleAspectFill//zx 13-4-26头像统一为此格式

#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]

#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f \
alpha:(a)]

//网络恢复通知
#define NetWorkRepair @"NetWorkRepair"

//检测网络
#define defHasNetWork [[WatchDog luckDog] haveNetWork]
#define defAlertNetWork { UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络异常,请检查网络！" delegate:nil cancelButtonTitle:@"确定"otherButtonTitles:nil, nil]; [alert show]; [alert release]; }

#if 0
    #define BGColor [UIColor yellowColor]
#else
    #define BGColor [UIColor clearColor]
#endif

//
#define kSystemVersionIsIOS7 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
#define kSystemVersionThanIOS8 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
#define DEVICE_IS_IPHONE5 ([[UIScreen mainScreen] bounds].size.height == 568)   
#define DEVICE_IS_IPHONE4 ([[UIScreen mainScreen] bounds].size.height == 480) 
#define iPhone6plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)

//通知
#define kUserChangedBeforeNotify @"kUserChangedBeforeNotify"//用户切换前
#define kUserChangedAfterNotify @"kUserChangedAfterNotify"//用户切换后

#define kNotifyUpdateRealtimeButtonStatus @"kNotifyUpdateRealtimeButtonStatus"
#define kNotifyDatabaseChanged @"kNotifyDatabaseChanged"
#define kNotifyDelMember @"kNotifyDelMember"

#define kNotifyAppWillResignActive @"kNotifyAppWillResignActive"//即将进入后台
#define kNotifyAppBecomeActive @"kNotifyAppBecomeActive"//从后台回来
#define kNotifyunbing @"kNotifyunbing"//解绑通知

#define kNotifyGetDeviceVersionSuccess @"kNotifyGetDeviceVersionSuccess" //获取当前固件版本信息通知
#define kNotifyrequestDeviceVersion @"kNotifyrequestDeviceVersion" //请求当前固件版本信息通知

#define kNotifyDevStartUpgrade @"kNotifyDevStartUpgrade" //固件开始升级通知
#define kNotifyDevUpgradeSuccess @"kNotifyDevUpgradeSuccess" //固件开始成功通知

#define kNotifyNotLogin @"kNotifyNotLogin" //连接服务器成功,但提示未登录时,发送此通知让AppDelegate后台登录

//月报告中点击某天
#define kShowOneDayReport @"ShowOneDayReport"


//000
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)

#define SCREEN_WIDTHx ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHTx ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTHx, SCREEN_HEIGHTx))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTHx, SCREEN_HEIGHTx))

#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)

//周数据有无更新
#define weekNew @"weekNew"

//日数据有无更新
#define dayNew @"dayNew"

//月数据有无更新
#define monthNew @"monthNew"

#define kAppNeedUpdate @"kAppNeedUpdate"
