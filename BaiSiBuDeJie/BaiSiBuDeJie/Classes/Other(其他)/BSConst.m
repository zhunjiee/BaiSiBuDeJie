#import <UIKit/UIKit.h>

/** 请求路径 */
NSString * const BSBaseURL = @"http://api.budejie.com/api/api_open.php";

/** 公共间距 */
CGFloat const BSMargin = 10;

/** 首个cell的Y值 */
CGFloat const BSFirstCellTopY = 35;

/** 导航栏最大Y值 */
CGFloat const BSNavMaxY = 64;

/** TabBar高度 */
CGFloat const BSTabBarH = 49;

/** titleView的高度 */
CGFloat const BSTitleViewH = 40;

/** 重复点击TabBar按钮的通知 */
NSString * const BSTabBarButtonDidRepeatClickNotification = @"BSTabBarButtonDidRepeatClickNotification";

/** 重复点击titleView按钮的通知 */
NSString * const BSTitleButtonDidRepeatClickNotification = @"BSTitleButtonDidRepeatClickNotification";