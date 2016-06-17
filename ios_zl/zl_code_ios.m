[锁的类型]

[__attribute__]
 __attribute__((cleanup(...)))，用于修饰一个变量，在它的作用域结束时可以自动执行一个指定的方法，如：

// 指定一个cleanup方法，注意入参是所修饰变量的地址，类型要一样
// 对于指向objc对象的指针(id *)，如果不强制声明__strong默认是__autoreleasing，造成类型不匹配
static void stringCleanUp(__strong NSString **string) {
    NSLog(@"%@", *string);
}
// 在某个方法中：
{
    __strong NSString *string __attribute__((cleanup(stringCleanUp))) = @"sunnyxx";
} // 当运行到这个作用域结束时，自动调用stringCleanUp

所谓作用域结束，包括大括号结束、return、goto、break、exception等各种情况。
当然，可以修饰的变量不止NSString，自定义Class或基本类型都是可以的：

// 自定义的Class
static void sarkCleanUp(__strong Sark **sark) {
    NSLog(@"%@", *sark);
}
__strong Sark *sark __attribute__((cleanup(sarkCleanUp))) = [Sark new];
// 基本类型
static void intCleanUp(NSInteger *integer) {
    NSLog(@"%d", *integer);
}
NSInteger integer __attribute__((cleanup(intCleanUp))) = 1;

假如一个作用域内有若干个cleanup的变量，他们的调用顺序是先入后出的栈式顺序；
而且，cleanup是先于这个对象的dealloc调用的。
进阶用法

既然__attribute__((cleanup(...)))可以用来修饰变量，block当然也是其中之一，写一个block的cleanup函数非常有趣：

// void(^block)(void)的指针是void(^*block)(void)
static void blockCleanUp(__strong void(^*block)(void)) {
    (*block)();
}

于是在一个作用域里声明一个block：
{
   // 加了个`unused`的attribute用来消除`unused variable`的warning
    __strong void(^block)(void) __attribute__((cleanup(blockCleanUp), unused)) = ^{
        NSLog(@"I'm dying...");
    };
} // 这里输出"I'm dying..."

这里不得不提万能的Reactive Cocoa中神奇的@onExit方法，其实正是上面的写法，简单定义个宏：

#define onExit\
    __strong void(^block)(void) __attribute__((cleanup(blockCleanUp), unused)) = ^
用这个宏就能将一段写在前面的代码最后执行：
{
    onExit {
        NSLog(@"yo");
    };
} // Log "yo"

这样的写法可以将成对出现的代码写在一起，比如说一个lock：

NSRecursiveLock *aLock = [[NSRecursiveLock alloc] init];
[aLock lock];
//...
[aLock unlock]; // 看到这儿的时候早忘了和哪个lock对应着了

用了onExit之后，代码更集中了：

NSRecursiveLock *aLock = [[NSRecursiveLock alloc] init];
[aLock lock];
onExit {
    [aLock unlock]; // 妈妈再也不用担心我忘写后半段了
};

模拟器截取750*1334的图：模拟器放大到100%，cmd+s

注意事项：
1. 不要fix issue
2. 证书改变后不要轻易的git push

xcodebuild 命令行 貌似不支持一个工程多个target的情况。这个需要后续再看看

---------
pod库添加新版本
git commit -am "添加UserDefault测试通过"
git log
git commit --amend  -m "添加UserDefault测试通过"
git log
git push
git add .
git commit -am "提升版本号到0.1.1"
git tag 0.1.1
pod lib lint
git push --all
git push --tag
pod repo push baidao-ios-ytx-pod-specs YTXRestfulModel.podspec --allow-warnings --verbose
--------

-------
github添加私有仓库：
git remote add origin fsafdsafds.git
git push
git tag 0.1.1
git repo lint
git push --tags
git repo add zl-specs fdsafsdafsd.git
git repo push zl-specs zl.podspec --verbose
-------

修改app构建版本
agvtool new-marketing-version 8.4.3

[延展边界的问题]
@property(nonatomic,assign) UIRectEdge edgesForExtendedLayout NS_AVAILABLE_IOS(7_0); // Defaults to UIRectEdgeAll
@property(nonatomic,assign) BOOL extendedLayoutIncludesOpaqueBars NS_AVAILABLE_IOS(7_0); // Defaults to NO, but bars are translucent by default on 7_0.  
@property(nonatomic,assign) BOOL automaticallyAdjustsScrollViewInsets NS_AVAILABLE_IOS(7_0); // Defaults to YES

Starting in iOS7, the view controllers use full-screen layout by default. At the same time, you have more control over how it lays out its views, and that's done with those properties:
1. edgesForExtendedLayout (default UIRectEdgeAll) extends its layout to fill the whole screen. 这个属性可以有(top, left, bottom, right)四个方向。
但存在navigationbar时，使用。默认情况下，view会延伸到navigationbar底部（即整个屏幕），设置成UIRectEdgeNone 后，就不会被navigationbar遮挡了。
2. automaticallyAdjustsScrollViewInsets 
This property is used when your view is a UIScrollView or similar, like a UITableView. You want your table to start where the navigation bar ends, because you wont see the whole content if not, but at the same time you want your table to cover the whole screen when scrolling. In that case, setting edgesForExtendedLayout to None won't work because your table will start scrolling where the navigation bar ends and it wont go behind it.
Here is where this property comes in handy, if you let the view controller automatically adjust the insets (setting this property to YES, also the default value) it will add inset to the top of the table, so the table will start where the navigation bar ends, but the scroll will cover the whole screen.
3. extendedLayoutIncludesOpaqueBars
This value is just an addition to the previous ones. If the status bar is opaque, the views won't be extended to include the status bar too, unless this parameter is YES.
So, if you extend your view to cover the navigation bar (edgesForExtendedLayout to UIRectEdgeAll) and the parameter is NO (default) it wont cover the status bar if it's opaque.






[Peckham]
在任意位置都可以引入头文件
Command + Ctrl + p 来激活命令

[manager beginWithAcctount:@"16318732" withPassWord:@"333333"];

接口测试，去掉todo
rac 
RACSignal 冷信号。当存在接收者时，会将所有的消息一次传送给接受者。（subscribeNext:）信号会被多次触发。存在多个订阅者时，会分别完整的发送所有消息。
RACMulticastConnection 广播，不会缓存消息。
[RACSignal publish]、- [RACMulticastConnection connect]、- [RACMulticastConnection signal]这几个操作生成了一个热信号。


1.    热信号是主动的，即使你没有订阅事件，它仍然会时刻推送。如第二个例子，信号在50秒被创建，51秒的时候1这个值就推送出来了，但是当时还没有订阅者。而冷信号是被动的，只有当你订阅的时候，它才会发送消息。如第一个例子。
2.    热信号可以有多个订阅者，是一对多，信号可以与订阅者共享信息。如第二个例子，订阅者1和订阅者2是共享的，他们都能在同一时间接收到3这个值。而冷信号只能一对一，当有不同的订阅者，消息会从新完整发送。如第一个例子，我们可以观察到两个订阅者没有联系，都是基于各自的订阅时间开始接收消息的。

任何的信号转换即是对原有的信号进行订阅从而产生新的信号。map flattenMap reduce ...


RACSubject *subject = [RACSubject subject];
    RACSubject *replaySubject = [RACReplaySubject subject];

    [[RACScheduler mainThreadScheduler] afterDelay:0.1 schedule:^{
        // Subscriber 1
        [subject subscribeNext:^(id x) {
            NSLog(@"Subscriber 1 get a next value: %@ from subject", x);
        }];
        [replaySubject subscribeNext:^(id x) {
            NSLog(@"Subscriber 1 get a next value: %@ from replay subject", x);
        }];

        // Subscriber 2
        [subject subscribeNext:^(id x) {
            NSLog(@"Subscriber 2 get a next value: %@ from subject", x);
        }];
        [replaySubject subscribeNext:^(id x) {
            NSLog(@"Subscriber 2 get a next value: %@ from replay subject", x);
        }];
    }];

    [[RACScheduler mainThreadScheduler] afterDelay:1 schedule:^{
        [subject sendNext:@"send package 1"];
        [replaySubject sendNext:@"send package 1"];
    }];

    [[RACScheduler mainThreadScheduler] afterDelay:1.1 schedule:^{
        // Subscriber 3
        [subject subscribeNext:^(id x) {
            NSLog(@"Subscriber 3 get a next value: %@ from subject", x);
        }];
        [replaySubject subscribeNext:^(id x) {
            NSLog(@"Subscriber 3 get a next value: %@ from replay subject", x);
        }];

        // Subscriber 4
        [subject subscribeNext:^(id x) {
            NSLog(@"Subscriber 4 get a next value: %@ from subject", x);
        }];
        [replaySubject subscribeNext:^(id x) {
            NSLog(@"Subscriber 4 get a next value: %@ from replay subject", x);
        }];
    }];

    [[RACScheduler mainThreadScheduler] afterDelay:2 schedule:^{
        [subject sendNext:@"send package 2"];
        [replaySubject sendNext:@"send package 2"];
    }];

RACSubject : 发送即时消息，已经订阅的接收者可以收到消息。如果接收者在消息发出后才订阅了消息，则收不到之前发送的消息。
RACReplaySubject : 发送即时消息，同时保留所有消息副本，当有新的订阅者加入时，将先前发送的消息和当前发送的消息一起发送给该接收者。

// 创建普通信号
RACSignal *networkRequest = [RACSignal createSignal:^(id<RACSubscriber> subscriber) {
    AFHTTPRequestOperation *operation = [client
        HTTPRequestOperationWithRequest:request
        success:^(AFHTTPRequestOperation *operation, id response) {
            [subscriber sendNext:response];
            [subscriber sendCompleted];
        }
        failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [subscriber sendError:error];
        }];

    [client enqueueHTTPRequestOperation:operation];
    return [RACDisposable disposableWithBlock:^{
        [operation cancel];
    }];
}];

// 将普通信号转化为RCMulticastConnection.signal，实际上就是RACReplaySubject .
RCMulticastConnection *connection = [networkRequest multicast:[RACReplaySubject subject]];
[connection connect];

[connection.signal subscribeNext:^(id response) {
    NSLog(@"subscriber one: %@", response);
}];

[RACReplaySubject and RACMulticastConnection]







[storyboard 中 AutoLayout 与 UIScrollView 结合所遇到的问题]
由于 UITableView/UIWebView都是继承自UIScrollView，所以他们都会遇到同样的关于设置contentSize的问题。
正确的做法：
-1，给scrollView设置四个边界。
-2，scorllView中的所有视图全部放在一个UIView上。由UIView作为整体设置边界约束。上下左右，以及将设置View的宽或者高，作为scrollView的contentSize边界。如果不需要滑动，则设置该View的宽高为controller.view的宽高即可。
-3，加入需要上下滑动，则不设置UIView的高，即UIView的高由其subViews确定。


fittingSize.height += 1.0 / [UIScreen mainScreen].scale;// 获取屏幕缩放比

TMBSFrameWorkControls.framework

[Chisel] facebook开源的lldb插件，方便调试
-安装
brew install chisel
echo 'command script import /usr/local/opt/chisel/libexec/fblldb.py' > ~/.lldbinit
reset xcode is success
-命令
-[pviews self.view]递归打印出所有的view，并标出层级。
-[pvc ]打印出所有的viewController，并标出层级，还可以看到controller是否viewDidLoad。
-[pvc self]
-[visualize self.customizedQuoteCollectionView]将view预览成一个png格式的截图，可以保存，用来定位某一个view的具体内容。
-[fv collectionView]查找当前名字中包含有collectionView的view。支持正则
-[fvc Home]打印出当前名字中包含有Home的controller。支持正则
-[show & hide]显示或隐藏指定的UIView。
-[mask / unmask , border / unborder]用来标识一个view或layer的位置时用，mask用来在view上覆盖一个半透明的红色蒙版， border可以给view添加红色边框。
-[caflush]重绘界面；当你想在调试界面颜色、坐标之类的时候，可以直接在控制台修改属性，然后caflush就可以看到效果。
(lldb) p view
(long) $122 = 140718754142192
(lldb) e (void)[$122 setBackgroundColor:[UIColor greenColor]]
(lldb) caflush
-[bmessage]这个命令就是用来打断点用的了，虽然大家断点可能都喜欢在图形界面里面打，但是考虑一种情况：我们想在 [MyViewController viewWillAppear:] 里面打断点，但是 MyViewController并没有实现 viewWillAppear: 方法， 以往的作法可能就是在子类中实现下viewWillAppear:，然后打断点，然后rebuild。
那么幸好有了 bmessage命令。我们可以不用这样就可以打这个效果的断点： (lldb) bmessage -[MyViewController viewWillAppear:] 上面命令会在其父类的 viewWillAppear: 方法中打断点，并添加上了条件：[self isKindOfClass:[MyViewController class]]

[lldb]LLDB 是一个有着 REPL 的特性和 C++ ,Python 插件的开源调试器。LLDB 绑定在 Xcode 内部，存在于主窗口底部的控制台中。调试器允许你在程序运行的特定时暂停它，你可以查看变量的值，执行自定的指令，并且按照你所认为合适的步骤来操作程序的进展。
-[p arr]print arr, p 就是 expression -- 的缩写
-[e ]expression
-[po ]打印对象，即对象的 description 方法的结果。是e -o -- 的别名
-[p/x 16]可以给print指定不同的打印格式。十六进制
-[p/t 14]二进制，打印32位的int。
-[p/t (char)14]打印8位的字符，数字太大超出8位就会出现截断。
-[p/c 2]打印十六进制的字符，8位
(lldb) p/c 2
(int) $314 = \x02\0\0\0
(lldb) p/c 1234
(int) $315 = \xd2\x04\0\0

(lldb) p/t 'c'
(char) $324 = 0b01100011
(lldb) p/c 'c'
(char) $326 = 'c'

(lldb) p (char)[[$array objectAtIndex:$a] characterAtIndex:0]
'M'
(lldb) p/d (char)[[$array objectAtIndex:$a] characterAtIndex:0]
77

-[声明变量]
(lldb) p int $a = 2
(lldb) p $a + 3
(int) $319 = 5

(lldb) e int $b = 3
(lldb) p $b + 2
(int) $320 = 5
----[流程控制]
xcode控制台左上方有四个按钮，分别是：continue，step over，step into，step out。
-[c] continue，继续执行，直到下个断点。
-[n] step over，以黑盒的方式执行一行代码。如果所在这行代码是一个函数调用，那么就不会跳进这个函数，而是会执行这个函数，然后跳到当前的下一行继续。
-[s] step into，跳入函数调用。
-[finish]运行完这个方法，直到return。
-[frame info]打印当前断点的行数和文件名。
-[thread return ]它有一个可选参数，在执行时它会把可选参数加载进返回寄存器里，然后立刻执行返回命令，跳出当前栈帧。这意味这函数剩余的部分不会被执行。这会给 ARC 的引用计数造成一些问题，或者会使函数内的清理部分失效。但是在函数的开头执行这个命令，是个非常好的隔离这个函数，伪造返回值的方式 。
(lldb) thread return NO
---[断点操作]
-[br li]breakpoint list，打印当前的有效断点。
-[br enable 1]将断点1设为有效。br e
-[br disable 1]将断点1设为无效。br di , br dis
-[br delete 2]删除断点2，br de


(lldb) p/t (char)4097
(char) $331 = 0b00000001
(lldb) p 00000001
(int) $332 = 1
(lldb) p 00000001 & 00000010
(int) $333 = 0
(lldb) p 00000001 & 00000011
(int) $334 = 1
(lldb) p 00000001 & 100000000001
(long long) $335 = 1
(lldb) p 00000001 & 100000000000
(long long) $336 = 0
(lldb) p 1 && 0
(bool) $337 = false
(lldb) p 1 && 1
(bool) $338 = true
(lldb) p/t 1 && 1
(bool) $339 = 0b00000001
(lldb) p/d 1 && 1
(bool) $340 = 1
(lldb) p/d 1 && 0
(bool) $341 = 0
(lldb) 

<command> [<subcommand> [<subcommand>...]] <action> [-options [option-value]] [argument [argumentekpoint]]
set --file test.c --line 12..

[lldb error]
注：LLDB调试时，很多需要调用方法的变量无法直接在控制台输出；(p/po)；然后这样解决：
(lldb) p UIScreen.mainScreen.bounds
error: property 'bounds' not found on objc of type 'id'
error: 1 errors parsing expression
(lldb) expr @import UIKit
(lldb) p UIScreen.mainScreen.bounds
(CGRect) $0 = (origin = (x = 0, y = 0), size = (width = 100, height = 50))


[实例变量与属性]
It’s best practice to use a property on an object any time you need to keep track of a value or another object.
最佳实践是，只有需要将一个value定义给外部对象使用时，才将改value定义为属性。
If you do need to define your own instance variables without declaring a property, you can add them inside braces at the top of the class interface or implementation, like this:
只是自己使用时，使用实例变量。如下三种情况中，外部对象都不能调用。内部变量。
@interface SomeClass : NSObject {
    NSString *_myNonPropertyInstanceVariable;
}
@interface SomeClass () {
    NSString *_myNonPropertyInstanceVariable;
}
@implementation SomeClass {
    NSString *_anotherCustomInstanceVariable;
}
这种情况下使用_myNonPropertyInstanceVariable读写该变量，不能使用self.调用。

pow(10,2) // 求x的y次方， 100

// ----
解决mac键盘无法映射模拟器键盘的问题
Hardware -> Keyboard has three options:

-iOS uses same layout as OS X : This option disables the MAC keyboard

-Connect Hardware Keyboard : This option enables MAC keyboard but the keyboard will not show up.

-Toggle Software keybaord : This option will allow you type using your MAC keypad and will show the iOS on screen keyboard as well.
// ----


[UIPageViewController] //  UIKit
#import <UIKit/UIViewController.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, UIPageViewControllerNavigationOrientation) {
    UIPageViewControllerNavigationOrientationHorizontal = 0,
    UIPageViewControllerNavigationOrientationVertical = 1
};

typedef NS_ENUM(NSInteger, UIPageViewControllerSpineLocation) {
    UIPageViewControllerSpineLocationNone = 0, // Returned if 'spineLocation' is queried when 'transitionStyle' is not 'UIPageViewControllerTransitionStylePageCurl'.
    UIPageViewControllerSpineLocationMin = 1,  // Requires one view controller.
    UIPageViewControllerSpineLocationMid = 2,  // Requires two view controllers.
    UIPageViewControllerSpineLocationMax = 3   // Requires one view controller.
};   // Only pertains to 'UIPageViewControllerTransitionStylePageCurl'.

typedef NS_ENUM(NSInteger, UIPageViewControllerNavigationDirection) {
    UIPageViewControllerNavigationDirectionForward,
    UIPageViewControllerNavigationDirectionReverse
};  // For 'UIPageViewControllerNavigationOrientationHorizontal', 'forward' is right-to-left, like pages in a book. For 'UIPageViewControllerNavigationOrientationVertical', bottom-to-top, like pages in a wall calendar.

typedef NS_ENUM(NSInteger, UIPageViewControllerTransitionStyle) {
    UIPageViewControllerTransitionStylePageCurl = 0, // Navigate between views via a page curl transition.
    UIPageViewControllerTransitionStyleScroll = 1 // Navigate between views by scrolling.
};

// Key for specifying spine location in options dictionary argument to initWithTransitionStyle:navigationOrientation:options:.
// Value should be a 'UIPageViewControllerSpineLocation' wrapped in an NSNumber.
// Only valid for use with page view controllers with transition style 'UIPageViewControllerTransitionStylePageCurl'.
UIKIT_EXTERN NSString * const UIPageViewControllerOptionSpineLocationKey;

// Key for specifying spacing between pages in options dictionary argument to initWithTransitionStyle:navigationOrientation:options:.
// Value should be a CGFloat wrapped in an NSNumber. Default is '0'.
// Only valid for use with page view controllers with transition style 'UIPageViewControllerTransitionStyleScroll'.
UIKIT_EXTERN NSString * const UIPageViewControllerOptionInterPageSpacingKey NS_AVAILABLE_IOS(6_0);

@protocol UIPageViewControllerDelegate, UIPageViewControllerDataSource;

NS_CLASS_AVAILABLE_IOS(5_0) @interface UIPageViewController : UIViewController {
}

- (instancetype)initWithTransitionStyle:(UIPageViewControllerTransitionStyle)style navigationOrientation:(UIPageViewControllerNavigationOrientation)navigationOrientation options:(nullable NSDictionary<NSString *, id> *)options NS_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder *)coder NS_DESIGNATED_INITIALIZER;

@property (nullable, nonatomic, weak) id <UIPageViewControllerDelegate> delegate;
@property (nullable, nonatomic, weak) id <UIPageViewControllerDataSource> dataSource; // If nil, user gesture-driven navigation will be disabled.
@property (nonatomic, readonly) UIPageViewControllerTransitionStyle transitionStyle;
@property (nonatomic, readonly) UIPageViewControllerNavigationOrientation navigationOrientation;
@property (nonatomic, readonly) UIPageViewControllerSpineLocation spineLocation; // If transition style is 'UIPageViewControllerTransitionStylePageCurl', default is 'UIPageViewControllerSpineLocationMin', otherwise 'UIPageViewControllerSpineLocationNone'.

// Whether client content appears on both sides of each page. If 'NO', content on page front will partially show through back.
// If 'UIPageViewControllerSpineLocationMid' is set, 'doubleSided' is set to 'YES'. Setting 'NO' when spine location is mid results in an exception.
@property (nonatomic, getter=isDoubleSided) BOOL doubleSided; // Default is 'NO'.

// An array of UIGestureRecognizers pre-configured to handle user interaction. Initially attached to a view in the UIPageViewController's hierarchy, they can be placed on an arbitrary view to change the region in which the page view controller will respond to user gestures.
// Only populated if transition style is 'UIPageViewControllerTransitionStylePageCurl'.

@property(nonatomic, readonly) NSArray<__kindof UIGestureRecognizer *> *gestureRecognizers;
@property (nullable, nonatomic, readonly) NSArray<__kindof UIViewController *> *viewControllers;

// Set visible view controllers, optionally with animation. Array should only include view controllers that will be visible after the animation has completed.
// For transition style 'UIPageViewControllerTransitionStylePageCurl', if 'doubleSided' is 'YES' and the spine location is not 'UIPageViewControllerSpineLocationMid', two view controllers must be included, as the latter view controller is used as the back.
- (void)setViewControllers:(nullable NSArray<UIViewController *> *)viewControllers direction:(UIPageViewControllerNavigationDirection)direction animated:(BOOL)animated completion:(void (^ __nullable)(BOOL finished))completion;

@end

@protocol UIPageViewControllerDelegate <NSObject>

@optional

// Sent when a gesture-initiated transition begins.
- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray<UIViewController *> *)pendingViewControllers NS_AVAILABLE_IOS(6_0);

// Sent when a gesture-initiated transition ends. The 'finished' parameter indicates whether the animation finished, while the 'completed' parameter indicates whether the transition completed or bailed out (if the user let go early).
- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed;

// Delegate may specify a different spine location for after the interface orientation change. Only sent for transition style 'UIPageViewControllerTransitionStylePageCurl'.
// Delegate may set new view controllers or update double-sided state within this method's implementation as well.
- (UIPageViewControllerSpineLocation)pageViewController:(UIPageViewController *)pageViewController spineLocationForInterfaceOrientation:(UIInterfaceOrientation)orientation;

- (UIInterfaceOrientationMask)pageViewControllerSupportedInterfaceOrientations:(UIPageViewController *)pageViewController NS_AVAILABLE_IOS(7_0);
- (UIInterfaceOrientation)pageViewControllerPreferredInterfaceOrientationForPresentation:(UIPageViewController *)pageViewController NS_AVAILABLE_IOS(7_0);

@end

@protocol UIPageViewControllerDataSource <NSObject>

@required

// In terms of navigation direction. For example, for 'UIPageViewControllerNavigationOrientationHorizontal', view controllers coming 'before' would be to the left of the argument view controller, those coming 'after' would be to the right.
// Return 'nil' to indicate that no more progress can be made in the given direction.
// For gesture-initiated transitions, the page view controller obtains view controllers via these methods, so use of setViewControllers:direction:animated:completion: is not required.
- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController;
- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController;

@optional

// A page indicator will be visible if both methods are implemented, transition style is 'UIPageViewControllerTransitionStyleScroll', and navigation orientation is 'UIPageViewControllerNavigationOrientationHorizontal'.
// Both methods are called in response to a 'setViewControllers:...' call, but the presentation index is updated automatically in the case of gesture-driven navigation.
- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController NS_AVAILABLE_IOS(6_0); // The number of items reflected in the page indicator.
- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController NS_AVAILABLE_IOS(6_0); // The selected item reflected in the page indicator.

@end

NS_ASSUME_NONNULL_END


// -----------

NSArray *windows = [[UIApplication sharedApplication] windows];

1. 弹出 UIAlertViewController 时。
<__NSArrayM 0x174c9520>(   // 包含两个UIWindow
-1. <UIWindow: 0x1215b830; frame = (0 0; 320 480); gestureRecognizers = <NSArray: 0x1215c070>; layer = <UIWindowLayer: 0x12420750>>,
-2. <UITextEffectsWindow: 0x1ef1d070; frame = (0 0; 320 480); opaque = NO; autoresize = W+H; layer = <UIWindowLayer: 0x1ef1d4a0>>
)

win1.windowLevel = 0

win2.windowLevel = 10

















// ---iOS布局格式语言（Visual Format Language）
[self.subView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[_chartView]|" options:0 metrics:nil views:views]];
[self.subView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_chartView]|" options:0 metrics:nil views:views]];
    
// 常见符号:
H:      水平布局（默认）
V:      垂直布局
|       superView的边界,水平布局模式下,放在左边是左边界，放在右边是右边界；处置布局模式下，则相应的为上边界和下边界
-　     标准间隔距离
-N-     长度为N像素点的间隔距离
[view]  被约束的view
==，>=，<=      用于限制view的长宽
@N      约束生效的优先级，最高是1000，等级高的优先考虑

// --代码一
[NSLayoutConstraint constraintsWithVisualFormat:@"|-50-[redView(==100)]-30-[blueView(==100)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(redView,blueView)];

其中，@"|-50-[redView(==100)]-30-[blueView(==100)]"的意思理解为：redView宽度为100，距离superView的左边界为50，与blueView的间距始终保持30，blueView 的宽度为100
// --代码二
NSDictionary * views = @{@"labelA":_labelA,@"labelB":_labelB};
NSDictionary * metrics = @{@"top":@20,@"left":@20,@"bottom":@20,@"right":@20,@"width":@200,@"height":@50,@"vPadding":@30,@"hPadding":@30};
NSString * vLayoutString = @"V:|-top-[labelA(==height)]-vPadding-[labelB(>=height)]";
NSArray * vLayoutArray = [NSLayoutConstraint constraintsWithVisualFormat:vLayoutString options:0 metrics:metrics views:views];
[self.view addConstraints:vLayoutArray];

// 注意：
a、代码一中和代码二中，constraintsWithVisualFormat: options:metrics:views:方法，传入的参数略有差异，尤其需要注意的是views参数，代码一传入的views参数为options:metrics:views:NSDictionaryOfVariableBindings(redView,blueView)]，这样会自动生成类似@{@"redView":redView,@"blueView":blueView}的字典，即字典的key和value的值，表面上看起来是“一样的”，如@“redView”：redView，而代码二中直接传入了一个自定义的字典，这样key和value不用保持“一致”

b、关于layoutString，如 @"V:|-top-[labelA(==height)]-vPadding-[labelB(>=height)]"，其中的labelA和labelB就是views参数中的key
// ---
+ (NSArray<__kindof NSLayoutConstraint *> * _Nonnull)constraintsWithVisualFormat:(NSString * _Nonnull)format options:(NSLayoutFormatOptions)opts metrics:(NSDictionary<NSString *,id> * _Nullable)metrics views:(NSDictionary<NSString *,id> * _Nonnull)views
// Description 
Creates constraints described by an ASCII art-like visual format string.
The format specification for the constraints.
// Parameters  
-format  
The format specification for the constraints. For more information, see Visual Format Language in Auto Layout Guide.
-opts    
Options describing the attribute and the direction of layout for all objects in the visual format string.
-metrics 
A dictionary of constants that appear in the visual format string. The dictionary’s keys must be the string values used in the visual format string. Their values must be NSNumber objects.
-views   
A dictionary of views that appear in the visual format string. The keys must be the string values used in the visual format string, and the values must be the view objects.
// Returns An array of constraints that, combined, express the constraints between the provided views and their parent view as described by the visual format string.
// ---

beginUpdates和endUpdates-实现UITableView的动画块
我们在做UITableView的修改，删除，选择时，需要对UITableView进行一系列的动作操作。
这样，我们就会用到

 [tableView beginUpdates];

        if (newCount<=0) {

            [tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section]withRowAnimation:UITableViewRowAnimationLeft];

        }
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]withRowAnimation:UITableViewRowAnimationLeft];

        [tableView endUpdates];

向上面一段代码，就是动态删除UITableView 的UITableViewCell的操作。
因为，如果我们的UITableView是分组的时候，我们如果删除某个分组的最后一条记录时，相应的分组也将被删除。所以，必须保证UITableView的分组，和cell同时被删除。
所以，就需要使用beginUpdates方法和endUpdates方法，将要做的删除操作“包”起来！

beginUpdates方法和endUpdates方法是什么呢？

这两个方法，是配合起来使用的，标记了一个tableView的动画块。

分别代表动画的开始开始和结束。

两者成对出现，可以嵌套使用。

一般，在添加，删除，选择 tableView中使用，并实现动画效果。

在动画块内，不建议使用reloadData方法，如果使用，会影响动画。

一般什么时候使用这么一个动画块呢？

一般在UITableView执行：删除行，插入行，删除分组，插入分组时，使用！用来协调UITableView的动画效果。

插入指定的行，

在执行该方法时，会对数据源进行访问（分组数据和行数据），并更新可见行。所以，在调用该方法前，应该先更新数据源

- (void)insertRowsAtIndexPaths:(NSArray *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation

插入分组到制定位置

- (void)insertSections:(NSIndexSet *)sections withRowAnimation:(UITableViewRowAnimation)animation

插入一个特定的分组。如果，指定的位置上已经存在了分组，那么原来的分组向后移动一个位置。

删除制定位置的分组

- (void)deleteSections:(NSIndexSet *)sections withRowAnimation:(UITableViewRowAnimation)animation

删除一个制定位置的分组，其后面的分组向前移动一个位置。

移动分组

- (void)moveSection:(NSInteger)section toSection:(NSInteger)newSection

移动原来的分组从一个位置移动到一个新的位置。如果，新位置上若存在某个分组，那这某个分组将会向上（下）移动到临近一个位置。该方法，没有动画参数。会直接移动。并且一次只能移动一个分组。

在如上方法中，建议使用该动画块进行操作！
// ----

[self.view endEditing:YES];// 关闭键盘

[iOS 中使用闭包()]
self.countLabel.attributedText = ({
    NSMutableAttributedString *countStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"成交量%@手", count]];
    [countStr addAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]
        } range:NSMakeRange(3, [count description].length)
    ];
    countStr;
});


[cell被重用如何提前知道?] 重写cell的prepareForReuse官方头文件中有说明.当前已经被分配的cell如果被重用了(通常是滚动出屏幕外了),会调用cell的prepareForReuse通知cell.注意这里重写方法的时候,注意一定要调用父类方法[super prepareForReuse] .这个在使用cell作为网络访问的代理容器时尤其要注意,需要在这里通知取消掉前一次网络请求.不要再给这个cell发数据了.

// if the cell is reusable (has a reuse identifier), this is called just before the cell is returned from the table view method dequeueReusableCellWithIdentifier:.  If you override, you MUST call super.

- (void)prepareForReuse
{
    [super prepareForReuse];
}

自定义UITableViewCell的方法有很多 发现一些人都会遇到自己定义的cell里面图片错乱的问题 这个问题往往是因为没有实现prepareForReuse这个方法导致的.

UITableViewCell在向下滚动时复用, 得用的cell就是滑出去的那些, 而滑出去的cell里显示的信息就在这里出现了 解决的方法就是在UITableViewCell的子类里实现perpareForReuse方法, 把内容清空掉

// -----------

使用 Concurrent Dispatch Queue 和 dispatch_barrier_async 可实现高效率的数据库访问和文件访问。

dispatch_barrier_async 并行队列中的单行线
//-----------
dispatch_queue_t concurrentQueue = dispatch_queue_create("my.concurrent.queue", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(concurrentQueue, ^(){
        NSLog(@"dispatch-1");
    });
    dispatch_async(concurrentQueue, ^(){
        NSLog(@"dispatch-2");
    });
    dispatch_barrier_async(concurrentQueue, ^(){
        NSLog(@"dispatch-barrier"); 
    });
    dispatch_async(concurrentQueue, ^(){
        NSLog(@"dispatch-3");
    });
    dispatch_async(concurrentQueue, ^(){
        NSLog(@"dispatch-4");
    });
// ---
dispatch_barrier_async 作用是在并行队列中，等待前面两个操作并行操作完成，这里是并行输出
dispatch-1，dispatch-2
然后执行
dispatch_barrier_async中的操作，(现在就只会执行这一个操作)执行完成后，即输出
"dispatch-barrier，
最后该并行队列恢复原有执行状态，继续并行执行
dispatch-3,dispatch-4
// -----

[va_start and va_end]

void CJLog(NSString *fmt,...)
{
    va_list args;
    va_start(args, fmt);
    NSString * message = [[NSString alloc] initWithFormat:fmt arguments:args];
    va_end(args);
}

C中传递函数的参数时的用法和原理：

1. 在C中，当我们无法列出传递函数的所有实参的类型和数目时,可以用省略号指定参数表
void foo(...);
void foo(parm_list,...);
这种方式和我们以前认识的不大一样，但我们要记住这是C中一种传参的形式，在后面我们就会用到它。

2.函数参数的传递原理

函数参数是以数据结构:栈的形式存取,从右至左入栈。
首先是参数的内存存放格式：参数存放在内存的堆栈段中，在执行函数的时候，从最后一个开始入栈。因此栈底高地址，栈顶低地址，举个例子如下：
void func(int x, float y, char z);
那么，调用函数的时候，实参 char z 先进栈，然后是 float y，最后是 int x，因此在内存中变量的存放次序是 x->y->z，因此，从理论上说，我们只要探测到任意一个变量的地址，并且知道其他变量的类型，通过指针移位运算，则总可以顺藤摸瓜找到其他的输入变量。
下面是 <stdarg.h> 里面重要的几个宏定义如下：
typedef char* va_list;
void va_start ( va_list ap, prev_param ); /* ANSI version */
type va_arg ( va_list ap, type );
void va_end ( va_list ap );
va_list 是一个字符指针，可以理解为指向当前参数的一个指针，取参必须通过这个指针进行。
<Step 1> 在调用参数表之前，定义一个 va_list 类型的变量，(假设va_list 类型变量被定义为ap)；
<Step 2> 然后应该对ap 进行初始化，让它指向可变参数表里面的第一个参数，这是通过 va_start 来实现的，第一个参数是 ap 本身，第二个参数是在变参表前面紧挨着的一个变量,即“...”之前的那个参数；
<Step 3> 然后是获取参数，调用va_arg，它的第一个参数是ap，第二个参数是要获取的参数的指定类型，然后返回这个指定类型的值，并且把 ap 的位置指向变参表的下一个变量位置；
<Step 4> 获取所有的参数之后，我们有必要将这个 ap 指针关掉，以免发生危险，方法是调用 va_end，他是输入的参数 ap 置为 NULL，应该养成获取完参数表之后关闭指针的习惯。说白了，就是让我们的程序具有健壮性。通常va_start和va_end是成对出现。
例如 int max(int n, ...); 其函数内部应该如此实现：
nclude <iostream.h>
void fun(int a, ...)
{
　　int *temp = &a;
　　temp++;

　　for (int i = 0; i < a; ++i)
　　{
　　　　cout << *temp << endl;
　　　　temp++;
　　}
}
int main()
{
　　int a = 1;
　　int b = 2;
　　int c = 3;
　　int d = 4;
　　fun(4, a, b, c, d);
　　system("pause");
　　return 0;
}

Output::
1
2
3
4

// -------
#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>

int demo(char*, ...);
/**
* @brief The entry of this program
*
* @param argc counts of argument
* @param argv argument variables stored in
*
* @return EXIT_SUCCESS
*/
int main (int argc, char **argv)
{
demo("Demo","This","is","a","demo!","");
return EXIT_SUCCESS;
} //end of function main



int demo (char* msg, ...)
{
va_list argp;
int argno = 0;
char* para;

va_start(argp,msg);
printf("parameters ### is : %s\n", msg);
while(1)
{
para = va_arg(argp, char*);
if(strcmp(para, "")==0)
break;
printf("parameter #%d is : %s\n", argno, para);
argno++;
}
va_end(argp);
return 0;
} //end of function demo
// -----


--Block
Lnline Declaration

- (void)touchThemAll:(id)things {
    [things each:^(id obj) {
        NSLog(@"Touching %@",obj);
    }];
}
// ---
int count = 5;
[obj accept:^]


typedef BOOL (*TruthFunction)(int a, int b);

typedef BOOL (^TruthBlock)(int a, int b);
//  return type | Type name| Parameters

TruthBlock block;
block = ^BOOL(int a, int b) {
    return (a == b);
}

BOOL truth = block(23, 47);

[string enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
    NSLog


--Closure // 闭包

--Lambda // 匿名函数

--Anonymous Function // 匿名函数

typealias WeatherCompletionHandler = (Weather?, Error?) -> Void

NS_OPTIONS 被定义为按位掩码，用简单的OR (|)和AND (&)数学运算即可实现对一个整型值的编码。每一个值不是自动被赋予从0开始依次累加1的值，而是手动被赋予一个带有一个bit偏移量的值：类似1 << 0、 1 << 1、 1 << 2等。如果你能够心算出每个数字的二进制表示法，例如：10110 代表 22，每一位都可以被认为是一个单独的布尔值。例如在UIKit中， UIViewAutoresizing 就是一个可以表示任何flexible top、bottom、 left 或 right margins、width、height组合的位掩码。
语法和 NS_ENUM 完全相同，但这个宏提示编译器值是如何通过位掩码 | 组合在一起的。同样的，注意值的区间不要超过所使用类型的最大容纳范围。

/:(\\w+) -------匹配 /:后接一个或多个字母

直接调用方法时候，一定要在头文件中声明该方法的使用，也要将头文件import进来。而使用performSelector时候， 可以不用import头文件包含方法的对象，直接用performSelector调用即可。

xcode slicing
runtime实现AOP，去除所有的返回箭头的提示名称
#import "UIViewController+Swizzle.h"

Mantle 实现json数据转模型
#import "ActivityInfo.h"
NSArray *models = [MTLJSONAdapter modelsOfClass:[TradeLimitOrder class] fromJSONArray:list error:NULL];
TradeLimitOrder *model = [MTLJSONAdapter modelOfClass:[TradeLimitOrder class] fromJSONDictionary:limit error:NULL];


//add markup
    <meta name="twitter:app:name:iphone" content="myAppName">
    <meta name="twitter:app:id:iphone" content="myAppID">
    <meta name="twitter:app:url:iphone" content="myURL">


//修改Info.plist中的项目，不确定key的全名时，使用defaults read读取plist文件的全部内容即可
<key>NSAppTransportSecurity</key>
<dict>
      <key>NSAllowsArbitraryLoads</key>
      <false/>
       <key>NSExceptionDomains</key>
       <dict>
            <key>yourdomain.com</key>
            <dict>
                <key>NSIncludesSubdomains</key>
                <true/>
                <key>NSTemporaryExceptionAllowsInsecureHTTPLoads</key>
                <true/>
                <key>NSTemporaryExceptionMinimumTLSVersion</key>
                <string>TLSv1.1</string>
            </dict>
       </dict>
</dict>
//一种不合适的方法是添加如下字段，这样的话就会对所有的请求都会使用http
<key>NSAppTransportSecurity</key>  
    <dict>  
        <key>NSAllowsArbitraryLoads</key><true/>  
    </dict>

//修改Info.plist中的项目，不确定key的全名时，使用defaults read读取plist文件的全部内容即可
defaults write /Users/zhanglu/ytxmobile-iphone/YtxMobile/p4/Supporting\ Files/Info.plist CFBundleDisplayName 银天下深海石油
Command + option + esc）按下之后打开强制结束应用程序的面板，我们可以在其中选择自己要关闭的程序。
高坤朋
QQ:632204910
gaokunpeng@1000phone.com

《刷新布局》
- (void)setNeedsLayout; 标记为需要重新布局，异步调用layoutIfNeeded刷新布局，不立即刷新，但layoutSubviews一定会被调用
- (void)layoutIfNeeded;  如果有需要刷新的标记，立即调用layoutSubviews进行布局（如果没有标记，不会调用layoutSubviews）
- (void)layoutSubviews;    重新布局

layoutSubviews在以下情况下会被调用：
init初始化不会触发layoutSubviews ,  但 initWithFrame 进行初始化时，当rect的值不为CGRectZero时,也会触发.
addSubview会触发layoutSubviews.
设置view的Frame会触发layoutSubviews，当然前提是frame的值设置前后发生了变化.
滚动一个UIScrollView会触发layoutSubviews.
旋转Screen会触发父UIView上的layoutSubviews事件.
改变一个UIView大小的时候也会触发父UIView上的layoutSubviews事件.
layoutSubviews对subviews重新布局
layoutSubviews方法调用先于drawRect
setNeedsLayout在receiver标上一个需要被重新布局的标记，在系统runloop的下一个周期自动调用layoutSubviews
layoutIfNeeded方法如其名，UIKit会判断该receiver是否需要layout
layoutIfNeeded遍历的不是superview链，应该是subviews链

注意：但页面再次调用layoutIfNeeded时是不会立刻执行layoutSubview的（但之前加上setNeedsLayout就会立刻执行

《重绘》
-drawRect:(CGRect)rect方法：重写此方法，执行重绘
-setNeedsDisplay方法：标记为需要重绘，异步调用drawRect
-setNeedsDisplayInRect:(CGRect)invalidRect方法：标记为需要局部重绘

drawRect是对receiver的重绘
setNeedDisplay在receiver标上一个需要被重新绘图的标记，在下一个draw周期自动重绘，iphone device的刷新频率是60hz，也就是1/60秒后重绘
---------------------------------------
		 |-UIAcceleration
		 |-UIAccelerometer
		 |-UIAccessibilityElement |-UIBarButtonItem
		 |-UIBarItem--------------|
		 |-UIBezierPath			  |-UITabBarItem
		 |-UIColor
		 |-UIDevice
		 |-UIDocumentInteractionController
		 |-UIEvent
		 |-UIFont					   |-UILongPressGestureRecognizer
		 |-UIGestureRecognizer---------|-UIPanGestureRecognizer
		 |-UIImage					   |-UIPinchGestureRecognizer
		 |-UILocalizedIndexedCollation |-UIRotationGestureRecognizer
		 |-UILocalNotification		   |-UISwipeGestureRecognizer
	   	 |-UIMenuController			   |-UITapGestureRecognizer
NSObject-|-UIMenultem
		 |-UINavigationItem
		 |-UINib
		 |-UIPasteboard
		 |-UIPopoverController			|-UISimpleTextPrintFormatter
		 |-UIPrintFormatter-------------|-UIMarkupTextPrintFormatter
		 |-UIPrintInfo					|-UIViewPrintFormatter
		 |-UIPrintInteractionController
		 |-UIPrintPageRenderer
		 |-UIPrintPaper	 |-UIApplication
		 |-UIResponder---|-UIView-----------------------||
		 |-UIScreen		 |-UIViewController--|-UISplitViewController
		 |-UIScreenMode					 	 |-UITabBarController
		 |-UISearchDisplayController		 |-UITableViewController	 
		 |-UITextChecker					 |-UINavigationController
		 |-UITextInputStringTokenizer 			 |-UIImagePickerController
		 |-UITextPosition					 	 |-UIVideoEditorController
		 |-UITextRange
		 |-UITouch
---------------------------------------||
UIView--|-UIVindow
		|-UILabel
		|-UIPickerView
		|-UIProgressView
		|-UIActivityIndicatorView
		|-UIImageView
		|-UITabBar
		|-UIToolBar
		|-UINavigationBar
		|-UITableViewCell
		|-UIActionSheet
		|-UIAlertView	   |-UITableView
		|-UIScrollView-----|-UITextView
		|-UISearchBar
		|-UIWebView
		|-UIControl-----|-UIButton
						|-UIDatePicker
						|-UIPageControl
						|-UISegmentedControl
						|-UITextField
						|-UISlider
						|-UISwitch
---------------------------------------
[视图和窗口]手机上能看得着的都是视图。
UIView类型的对象。addSubView
iPhone iPhone3G iPhone3GS 320*480
iPhone4 iPhone4S 320*480
iPhone5 iPhone5S 320*568
iPhone6			 375*667
iPhone6 plus	 414*736

iPod touch1/2/3/4  320*480
iPod touch5		   320*568

iOS程序的默认启动画面
Default.png //3.5英寸的4S使用的一般图片
Default@2x.png  //3.5英寸使用的高清图片
Default-568h@2x.png  //4英寸的5、5S使用的图片，6和6 plus也可以拿来用

(2)模拟器快捷键
	CMD+SHIFT+H	Home键
	CMD+左/右	旋转模拟器
	CMD+S		截图
	CMD+1/2/3	根据不同比例显示模拟器
	CMD+H		隐藏模拟器
/*
 解决应用程序出现的问题解决方式
 1.cmd + shift + k 清理工程垃圾
 2.模拟器上的应用删除
 3.退出模拟器
 4.还原模拟器的配置
*/
Mac OS X常用快捷键：

[视图与控制器]
视图将回答这些问题的权力委托给其他对象（实现委托的对象返回数据）
协议是一种同另一对象通信的盲方式。这就是视图通过控制器从模型获取数据的方式。这是一种盲的结构化方式。
数据在模型里。
数据源其实是一种委托，一类用于获取数据的特殊委托。
控制器的工作是为视图解释并格式化提供模型数据。
[模型与控制器]
通知和键值观察 简称KVO ，模型中任何东西发生变化，我们都会通过我的电台进行广播，然后控制器会接受来自电台的信息。当发现模型内的数据发生变化时，控制器会向模型获取变化的数据。

KVC(键值编码)是一种间接访问对象实例变量的机制，该机制可以不通过存取方法就可以访问对象的实例变量。
KVO(键值观察)是一种能使得对象获取到其他对象属性变化的通知机制。
关系：实现KVO键值观察模式，被观察的对象必须使用KVC键值编码来修改它的实例变量，这样才能被观察者观察到，因此，KVC是KVO的基础或者说KVO得实现是建立在KVC的基础之上的。

1. 建议在读取实例变量的时候采用直接访问的形式，而在设置实例变量的时候通过属性来做。
直接访问和存取方法的区别：
① 由于不经过OC的“方法派发”（method dispatch）步骤。所以直接访问实例变量的速度当然比较快。
这种情况下，编译器所生成的代码会直接访问保存对象实例变量的那块内存。
② 直接访问实例变量时，不会调用其“设置方法”；
③ 直接访问实例变量时，不会触发“键值观测”（key-Value Observing，KVO）通知。
④ 通过属性来访问有助于排查与之相关的错误，因为可以给获取器和设置器中新增断点，监控该属性的调用者及其访问时机。
2. 在初始化方法(或dealloc)中，总是直接访问实例变量。因为子类可能会“覆写”（override）设置方法。
3. 惰性初始化（lazy initialization）
这种情况侠必须通过获取器来访问属性，否则实例变量就永远不会初始化。
- （id）brain {
     if(!_brain){
          _brain = [Brain new];
     }
     return _brain;
} 
注意：在OC中，init方法是非常不安全的；没人能保证init只被调用一次，也没人保证在初始化方法后调用以后实例的各个变量都完成初始化，甚至如果在初始化里使用属性进行设置时，还可能造成各种问题，Apple也明确说明不应该在init中使用属性来进行初始化。
使用实例变量不会触发set方法，也不会触发KVO
使用属性来初始化（点语法）: 1. 会触发set方法，而set方法有可能被子类重写，而导致不能对原来的值进行有效地初始化。 2. 会触发KVO，从而引起其他未知的连锁反应。

OC中的所有对象都存放在堆中，使用指针指向它们。对象没有分配在栈上这一说法。堆就是分配闲置内存的地方。
指针属性可以是强的和弱的。

[ARC automatic reference counting，自动引用计数]启动了ARC之后，只管像平常那样按>需分配并使用对象，编译器会帮你插入retain和release语句，无需自己动手。 
注：ARC只对可保留对象指针(ROPs)有效：代码块指针、OC对象指针、通过__attribute__((NSObject))类型定义的指针。所有其他的指针类型，包括char*等C类型和CF对象都不支持ARC特性。
注：要在代码中使用ARC，必须满足三个条件：能够确定那些对象需要进行内存管理；能够>表明如何去管理对象；有可行的办法传递对象的所有权。 
[强引用与弱引用]当用指针指向某个对象时，你可以管理(retain/release)它的内存也可以不管理。如果管理了，就拥有了对这个对象的强引用；如果没有管理，就是弱引用。比如，属性使用了assign特性，便创建了一个弱引用。 
strong means:
“keep the object that this property points to in memory until I set this property to nil (zero) (and it will stay in memory until everyone who has a strong pointer to it sets their property to nil too)”
weak would mean:
“if no one else has a strong pointer to this object, then you can throw it out of memory and set this property to nil (this can happen at any time)”
strong强指针：OC会追踪每一个指向堆中对象的强指针，只要有一个强指针存在，它就会把其留在堆中。只有不存在任何强指针时，该对象才会被释放，立刻释放。
weak弱指针：弱指针会告诉OC，我有一个指针指向堆中的这个对象，只要还有强指针指向它，就将它留在内存中，只要不再有强指针指向它，内存就会释放，然后这个弱指针会被设置为nil。表示该弱指针不指向任何地方。（弱的时候，不仅会释放一个强指针指向的地址，还会把弱指针设为nil）
_unsafe_unretained与weak功能一致，区别在于当指向的对象销毁后，weak会将变量置为nil，防止野指针。
[归零弱引用]
有两种方法可以声明归零弱引用，声明变量时使用__week关键字或对属性使用weak特性。 
__weak NSString *myString;
@property (weak) NSString *myString;
使用ARC时，有两种命名规则需要注意：属性名称不能以new开头，比如@property NSString *newString;是不被允许的。 属性不能只有一个readonly而没有内存管理特性。
强引用也有自己的__strong关键字和strong特性。内存管理的关键字和特性不能同时使用。两者互斥。

[volatile]
例如：
int packetsReceived = 0;
while (packetsRecieved < 10){
    //Wait for more packets
}
processPackets();
// 上面的代码，编译器会认为 条件永远成立，经过优化后的代码会线性执行，而不会每次都判断条件是否成立。
当我们使用 volatile 关键字时，volatile int packetsRecieved;
就是告诉编译器，这个变量在任何时候都有可能改变，所以每次都会进行判断，安装我们预期的工作方式运行。

编译器优化策略：会将简单的计算直接替换为数字，而避免运行时计算的发生。会将恒成立的条件替换为true，从而不会进行判断。

[关键字]
01. atomic             //default
02. nonatomic
03. strong=retain      //default
04. weak= unsafe_unretained
05. retain
06. assign             //default
07. unsafe_unretained
08. copy
09. readonly
10. readwrite              //default

atomic 和 nonatomic 的区别在于，系统自动生成的 getter/setter 方法不一样。如果你自己写 getter/setter，那 atomic/nonatomic/retain/assign/copy 这些关键字只起提示作用，写不写都一样。
对于atomic的属性，系统生成的 getter/setter 会保证 get、set 操作的完整性，不受其他线程影响，原子操作。比如，线程 A 的 getter 方法运行到一半，线程 B 调用了 setter：那么线程 A 的 getter 还是能得到一个完好无损的对象。而nonatomic就没有这个保证了。所以，nonatomic的速度要比atomic快。

假设有一个 atomic 的属性 "name"，如果线程 A 调[self setName:@"A"]，线程 B 调[self setName:@"B"]，线程 C 调[self name]，那么所有这些不同线程上的操作都将依次顺序执行——也就是说，如果一个线程正在执行 getter/setter，其他线程就得等待。因此，属性 name 是读/写安全的。
但是，如果有另一个线程 D 同时在调[name release]，那可能就会crash，因为 release 不受 getter/setter 操作的限制。也就是说，这个属性只能说是读/写安全的，但并不是"线程安全的"，因为别的线程还能进行读写之外的其他操作。线程安全需要开发者自己来保证。
如果 name 属性是 nonatomic 的，那么上面例子里的所有线程 A、B、C、D 都可以同时执行，可能导致无法预料的结果。如果是 atomic 的，那么 A、B、C 会串行，而 D 还是并行的。
atomic: Which means an object is read/write safe (ATOMIC) but not thread safe as another threads can simultaneously send any type of messages to the object. Developer should ensure thread safety for such objects.





[重载]相同的方法具有不同的参数。
- (NSMutableArray *)cards
{
    if (!_cards) _cards = [[NSMutableArray alloc] init];
    return _cards;
}//惰性实例化，获取一个可变数组，在init中做更有意义的事，惯例
unsigned index = arc4random() % [self.cards count]; //rc4random() returns a random integer.
- (NSString *)suit
{
    return _suit ? _suit : @"?";
}//保证当suit不存在时，使用？代替。
类方法（+），用于创建事物，用于工具方法（通用的）。
@synthesize name=_name;在类的内部，我们总是使用下划线属性名。当在代码中自己实现setter和getter方法时，需加上这句话。
Because if you implement BOTH the setter and the getter for a property, then you have to create the instance variable for the property yourself.
If you implement only the setter OR the getter (or neither), the compiler adds this @synthesize for you.
@synthesize <prop name> = _<prop name> (only if you implement both setter and getter)
-(instancetype)init //返回实例类型，即返回一个对象，具有相同类类型，同这条消息要发送到的对象一致。tells the compiler that this method returns an object which will be the same type as the object that this message was sent to.
cardA.contents = @[cardB.contents,cardC.contents][[cardB match:@[cardC]] ? 1 : 0]; //This line has a setter, getters, method invocation, array creation and array accessing all in one. And lots of square brackets.
UIButton’s 
+ (id)buttonWithType:(UIButtonType)buttonType;
[Dynamic Binding]动态绑定
Figuring out the code to execute when a message is sent at runtime is called “dynamic binding.”
introspection(内省法)
if ([obj isKindOfClass:[NSString class]]) {
    NSString *s = [(NSString *)obj stringByAppendingString:@”xyzzy”];
}
//使用数组中的每一个元素调用该选择器方法,Using makeObjectsPerformSelector: methods in NSArray
[array makeObjectsPerformSelector:shootSelector]; 
[array makeObjectsPerformSelector:shootAtSelector withObject:target];
//可将遍历数组执行某一方法的代码缩减成一行
//使用选择器来设置目标动作。什么消息发送到什么对象，什么是目标，什么是动作,In UIButton, - (void)addTarget:(id)anObject action:(SEL)action ...; 
[button addTarget:self action:@selector(digitPressed:) ...];
Object wrapper around primitive types like int, float, double, BOOL, enums, etc.
 NSNumber *match = @([card match:@[otherCard]]); // expression that returns a primitive type
NSDate 时间日期类
Used to find out the time right now or to store past or future times/dates.
See also NSCalendar, NSDateFormatter, NSDateComponents.
If you are going to display a date in your UI, make sure you study this in detail (localization).
#pragma mark - 解析时间字符串
//"lastactivity":"1408688378"->距离 1970年过了的秒数
- (NSString *)paserDateString:(NSString *)timeStr{
    //转化为浮点数
    double t = [timeStr doubleValue];
    //转化为NSDate
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:t];
    //格式化的
    NSDateFormatter *fm = [[NSDateFormatter alloc] init];
    fm.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    return [fm stringFromDate:date];
}
[NSSet/NSMutableSet]对象的无序集合，一般意义上的集合，其中元素都是唯一的。
[NSOrderedSet / NSMutableOrderedSet]有序集合，哈希列表，相对数组更加高效。
NSDictionary
Immutable collection of objects looked up by a key (simple hash table). All keys and values are held onto strongly by an NSDictionary.
Can create with this syntax: @{ key1 : value1, key2 : value2, key3 : value3 }
NSDictionary *colors = @{ @“green” : [UIColor greenColor],
                          @“blue” : [UIColor blueColor],
                          @“red” : [UIColor redColor] };
Lookup using “array like” notation ...
NSString *colorString = ...;
UIColor *colorObject = colors[colorString]; // works the same as objectForKey: below
[属性列表]NSUserDefaults
Lightweight storage of Property Lists.
It’s basically an NSDictionary that persists between launches of your application.
Not a full-on database, so only store small things like user preferences.
Read and write via a shared instance obtained via class method standardUserDefaults ... [[NSUserDefaults standardUserDefaults] setArray:rvArray forKey:@“RecentlyViewed”]; Sample methods:
- (void)setDouble:(double)aDouble forKey:(NSString *)key;
- (NSInteger)integerForKey:(NSString *)key; // NSInteger is a typedef to 32 or 64 bit int - (void)setObject:(id)obj forKey:(NSString *)key; // obj must be a Property List
- (NSArray *)arrayForKey:(NSString *)key; // will return nil if value for key is not NSArray Always remember to write the defaults out after each batch of changes!
[[NSUserDefaults standardUserDefaults] synchronize];
[UIColor]颜色
An object representing a color.
Initializers for creating a color based on RGB, HSB(色调、饱和度、亮度) and even a pattern (UIImage).
Colors can also have alpha(透明度，1表示完全不透明，0表示完全透明) (UIColor *color = [otherColor colorWithAlphaComponent:0.3]).
A handful of “standard” colors have class methods (e.g. [UIColor greenColor]). A few “system” colors also have class methods (e.g. [UIColor lightTextColor]).

[UIFont]字体Fonts in iOS 7 are very important to get right.
It is best to get a UIFont by asking for the preferred font for a given text style ... 
UIFont *font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
Some other styles (see UIFontDescriptor documentation for even more styles) ... UIFontTextStyleHeadline, UIFontTextStyleCaption1, UIFontTextStyleFootnote, etc.
There are also “system” fonts.
They are used in places like button titles.
+ (UIFont *)systemFontOfSize:(CGFloat)pointSize;
+ (UIFont *)boldSystemFontOfSize:(CGFloat)pointSize; You should never uses these for your user’s content.
Use preferredFontForTextStyle: for that.
+ (UIFont *)italicSystemFontOfSize:(CGFloat)fontSize;//设置label的内容的字体大小的同时，使字体倾斜
//需要注意的时，加粗和倾斜两个属性只能同时设置一个，如果需要同时存在，则需要更换字体
NSArray *fontArray=[UIFont familyNames];//获取 系统中自带的字体库 各种样式的字体
NSString *fontName=label.font.fontName;//查看当前标签内容的字体，并以字符串的形式返回字体名
float fontSize=label.font.pointSize;//查看当前标签内容的字体的大小
UIFont *font=[UIFont fontWithName:@"Arial"size:10];//根据字体名称以及字体大小创建一个UIFont的对象
[UIFontDescriptor]它会尝试将类别施加在未分类化的字体上。
A UIFontDescriptor attempts to categorize a font anyway.
It does so by family, face, size, and other attributes.
You can then ask for fonts that have those attributes and get a “best match.”
Understand that a best match for a “bold” font may not be bold if there’s no such designed face.
[NSAttributedString]字体的属性，独立于具体字体。
The attributes are things like the font, the color, underlining or not, etc., of the character.
- (NSDictionary *)attributesAtIndex:(NSUInteger)index
                     effectiveRange:(NSRangePointer)range;//返回该范围内的字体的所有属性字典。The range is returned and it lets you know for how many characters the attributes are identical. There are also methods to ask just about a certain attribute you might be interested in.
NSAttributedString is not an NSString
It does not inherit from NSString, so you cannot use NSString methods on it.
If you need to operate on the characters, there is this great method in NSAttributedString ... - (NSString *)string;
For example, to find a substring in an NSAttributedString, you could do this ... NSAttributedString *attributedString = ...;
NSString *substring = ...;
NSRange r = [[attributedString string] rangeOfString:substring];
The method string is guaranteed to be high performance but is volatile. If you want to keep it around, make a copy of it.
[NSMutableAttributedString]
Unlike NSString, we almost always use mutable attributed strings.
Adding or setting attributes on the characters
You can add an attribute to a range of characters ...
- (void)addAttributes:(NSDictionary *)attributes range:(NSRange)range;
... which will change the values of attributes in attributes and not touch other attributes. Or you can set the attributes in a range ...
- (void)setAttributes:(NSDictionary *)attributes range:(NSRange)range;
... which will remove all other attributes in that range in favor of the passed attributes. You can also remove a specific attribute from a range ...
- (void)removeAttribute:(NSString *)attributeName range:(NSRange)range;
So what kind of attributes are there?
The attributes is a dictionary;
The key for the font is NSFontAttributeName
NSString *const  NSFontAttributeName ;字体
NSString *const  NSParagraphStyleAttributeName ;
NSString *const  NSForegroundColorAttributeName ;颜色
NSString *const  NSBackgroundColorAttributeName ;
NSString *const  NSLigatureAttributeName ;
NSString *const  NSKernAttributeName ;
NSString *const  NSStrikethroughStyleAttributeName ;
NSString *const  NSUnderlineStyleAttributeName ;
NSString *const  NSStrokeColorAttributeName ;
NSString *const  NSStrokeWidthAttributeName ;
NSString *const  NSShadowAttributeName ;
NSString *const  NSTextEffectAttributeName ;
NSString *const  NSAttachmentAttributeName ;
NSString *const  NSLinkAttributeName ;
NSString *const  NSBaselineOffsetAttributeName ;
NSString *const  NSUnderlineColorAttributeName ;
NSString *const  NSStrikethroughColorAttributeName ;
NSString *const  NSObliquenessAttributeName ;
NSString *const  NSExpansionAttributeName ;
NSString *const  NSWritingDirectionAttributeName ;
NSString *const  NSVerticalGlyphFormAttributeName;
So what kind of attributes are there?
属性字典：
@{ NSFontAttributeName :[UIFont preferredFontWithTextStyle:UIFontTextStyleHeadline]字体
  NSForegroundColorAttributeName : [UIColor greenColor]字体颜色
NSStrokeWidthAttributeName:@-5,描边宽度属性，负NSNumber意味着填充字形并描边，正的只描边，中间是透明的
NSStrokeColorAttributeName : [UIColor redColor],描边颜色
NSUnderlineStyleAttributeName : @(NSUnderlineStyleNone),
   NSBackgroundColorAttributeName : transparentYellow,背景为透明度为30%的黄色}
Where do attributed strings get used?
UIButton’s - (void)setAttributedTitle:(NSAttributedString *)title forState:...; 
UILabel’s @property (nonatomic, strong) NSAttributedString *attributedText; 
UITextView’s @property (nonatomic, readonly) NSTextStorage *textStorage;
[UILabel:UIView]
Note that this attributed string is not mutable
So, to modify what is in a UILabel, you must make a mutableCopy, modify it, then set it back. 
NSMutableAttributedString *labelText = [myLabel.attributedText mutableCopy];
[labelText setAttributes:...];
myLabel.attributedText = labelText;
设置行数
label.numberOfLines = 0;//无限行 有几行就显示几行，行数最大为label设定的容量大小。
默认以单词作为截断换行,省略结尾
设置换行模式/省略模式
label.lineBreakMode = NSLineBreakByTruncatingTail;
/*
NSLineBreakByWordWrapping = 0,默认的换行模式
NSLineBreakByCharWrapping,
NSLineBreakByClipping,
NSLineBreakByTruncatingHead,
NSLineBreakByTruncatingTail,
NSLineBreakByTruncatingMiddle
*/

[UITextView:UIScrollView]Like UILabel, but multi-line, selectable/editable, scrollable, etc.在UILabel中想要显示多行，需要提前声明。
textView.editable = YES;//设置是否可以编辑
textView.text = @"文本视图";//设置文本视图的内容
textView.textColor  = [UIColor brownColor];//设置文本视图的内容的字体颜色
textView.font = [UIFont systemFontOfSize:30];//设置文本视图的内容的字体大小
textView.scrollEnabled = NO;//设置文本视图是否可以滚动，因为文本视图继承自UIScrollView，所以可以进行滚动
textView.delegate = self;//将当前视图控制器设置为文本视图的代理
注意：UITextView键盘中的return按钮表示换行
Set its text and attributes via its NSMutableAttributedString
@property (nonatomic, readonly) NSTextStorage *textStorage;
NSTextStorage is a subclass of NSMutableAttributedString.
You can simply modify it and the UITextView will automatically update. New in iOS 7.
Setting the font
Fonts can, of course, vary from character to character in UITextView.
But there is also a property that applies a font to the entire UITextView ... @property (nonatomic, strong) UIFont *font;
Advanced layout in UITextView with TextKit
This property defines “where text can be” in the UITextView ... @property (readonly) NSTextContainer *textContainer;
This object will read characters from textStorage and lays down glyphs into textContainer ... @property (readonly) NSLayoutManager *layoutManager;
These objects are quite powerful.
For example, textContainer can have “exclusion zones” specified in it (flowing around images). 
[Check them out if you’re interested in typography.]
[View Controller Lifecycle视图控制器生命周期]sent to UIViewController when things happen,your controller is a subclass of UIViewController.
The start of the lifecycle ...
Creation.
MVCs are most often instantiated out of a storyboard (as you’ve seen).
After instantiation and outlet-setting, viewDidLoad is called This is an exceptionally good place to put a lot of setup code.
- (void)viewDidLoad//only gets caled once before you go on screen,不要在这里添加视图的显示类信息
{
	[super viewDidLoad]; // always let super have a chance in lifecycle methods
	// do some setup of my MVC
}
But be careful because the geometry of your view (its bounds) is not set yet!
At this point, you can’t be sure you’re on an iPhone 5-sized screen or an iPad or ???. So do not initialize things that are geometry-dependent here.
Just before the view appears on screen, you get notified
- (void)viewWillAppear:(BOOL)animated;
Your view will only get “loaded” once, but it might appear and disappear a lot.not putting in viewWillAppear is one-time initialization.
Do something here if things you display are changing while your MVC is off-screen.eg:Something changed in your model,your view controller was off screen,so it wasn't really listening for changes in the model.And then coming back on screen,you better sync up with the model.
And you get notified when you will disappear off screen too This is where you put “remember what’s going on” and cleanup code.
- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated]; // call super in all the viewWill/Did... methods 
// let’s be nice to the user and remember the scroll position they were at ...
	[self rememberScrollPosition]; // we’ll have to implement this, of course 
// do some other clean up now that we’ve been removed from the screen
	[self saveDataToPermanentStore]; // maybe do in did instead?
// but be careful not to do anything time-consuming here, or app will be sluggish
// maybe even kick off a thread to do what needs doing here (again, we’ll cover threads later)
}
There are “did” versions of both of the appearance methods 
	- (void)viewDidAppear:(BOOL)animated;
	- (void)viewDidDisappear:(BOOL)animated;
[自动布局]
- (void)view{Will,Did}LayoutSubviews;
Called any time a view’s frame changed and its subviews were thus re-layed out.
For example, autorotation.
You can reset the frames of your subviews here or set other geometry-affecting properties. Between “will” and “did”, autolayout will happen.
[屏幕旋转过后的视图调整]
When the device is rotated, the top level view controller will have its bounds reoriented iff ... 
The automatic change to the new geometry only happens if these conditions are true.
The view controller returns YES from shouldAutorotate方法.this is default.
The view controller returns the new orientation in supportedInterfaceOrientations.return an enum,with landscape(横屏) and portrait(竖屏),portrait upside down(倒立竖屏) in there,default it supports all rotations.
The application allows rotation to that orientation (defined in Info.plist file).
Generally it is a good idea to try to support rotation in MVCs.
In low-memory situations, didReceiveMemoryWarning gets called ...
This rarely happens, but well-designed code with big-ticket memory uses might anticipate it. Examples: images and sounds.
Anything “big” that can be recreated should probably be released (i.e. set strong pointer to nil).
is to try and free up memory,That means in the heap,And that means setting strong pointers you have to nil.
-(void)setup{}; //dosomethingwhichcan’twaituntilviewDidLoad
- (void)awakeFromNib { [self setup]; }
// UIViewController’s designated initializer is initWithNibName:bundle: (ugh!)
- (instancetype)initWithNibName:(NSString *)name bundle:(NSBundle *)bundle
{
    self = [super initWithNibName:name bundle:bundle];
    [self setup];
    return self;
}
Summary
Instantiated (from storyboard - many ways for this to happen which we’ll cover later)
awakeFromNib
outlets get set
viewDidLoad
(when geometry is determined)
viewWillLayoutSubviews and viewDidLayoutSubviews
(next group can happen repeatedly as your MVC appears and disappears from the screen ...) viewWillAppear: and viewDidAppear:
(whenever geometry changes again while visible, e.g. device rotation) viewWillLayoutSubviews and viewDidLayoutSubviews
(if it is autorotation, then you also get will/didRotateTo/From messages--rare to use these)
viewWillDisappear: and viewDidDisappear: (possibly if memory gets low ...)
  didReceiveMemoryWarning
(there is no “unload” anymore, so that’s all there is)
[radio station 广播站机制，对象间的通信是以一种盲结构进行的]
The “radio station” from the MVC slides.
So the way of communicating between objects in a blind structured way.which we refer to as this radio station thing from MVC.MVC的广播站机制。is called "Notifications通知" in iOS 7.
NSNotificationCenter
Get the default “notification center” via [NSNotificationCenter defaultCenter] Then send it the following message if you want to “listen to a radio station”:
- (void)addObserver:(id)observer //the object that wants to listen to the radio station.So in your controller,because controllers are the most common radio station listeners,this would probably just be self.
selector:(SEL)methodToInvokeIfSomethingHappens//Selector is the method inside of the observer.that you want to be called when something appears on the radio station.
name:(NSString *)name // name of station (a constant somewhere)
object:(id)sender; // whose changes you’re interested in (nil is anyone’s) 
You will then be notified when there are broadcasts
- (void)methodToInvokeIfSomethingHappens:(NSNotification *)notification
{
notification.name // the name passed above
notification.object // the object sending you the notification notification.userInfo // notification-specific information about what happened
}
Be sure to “tune out” when done listening
[center removeObserver:self];
or
[center removeObserver:self name:UIContentSizeCategoryDidChangeNotification object:nil];
Failure to remove yourself can sometimes result in crashers.
This is because the NSNotificationCenter keeps an “unsafe retained(不安全保留类型)” pointer to you.
A good place to remove yourself is when your MVC’s View goes off screen. 
Or you can remove yourself in a method called dealloc (called when you leave the heap). 
- (void)dealloc
{
// be careful in this method! can’t access properties! you are almost gone from heap!
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

Watching for changes in the size of preferred fonts (user can change this in Settings) ...
NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
[center addObserver:self
           selector:@selector(preferredFontsSizeChanged:)
               name:UIContentSizeCategoryDidChangeNotification
object:nil]; // this station’s broadcasts aren’t object-specific
- (void)preferredFontsSizeChanged:(NSNotification *)notification
{
// re-set the fonts of objects using preferred fonts
}
[发送消息方]
//第一个参数:通知的名字,跟注册时的名字要一样
//第二个参数:发送通知的对象
//第三个参数:通知里面的一些参数


// UIView *view = [[UIView alloc] init];
//通知中心可以一对多
//在一个地方发送，可以在多个地方接收
// [[NSNotificationCenter defaultCenter] postNotificationName:@"changColor" object:self userInfo:@{@"myColor":[UIColor redColor]}];

//创建一个通知类型的对象
NSNotification *notification = [NSNotification notificationWithName:@"changColor" object:self userInfo:@{@"myColor":[UIColor redColor]}];

[[NSNotificationCenter defaultCenter] postNotification:notification];
[接受消息方]
//注册通知
//第一个参数:发送通知时调用这个对象的方法
//第二个参数:发送通知时调用对应对象的这个方法
//第三个参数:通知的名字
//第四个参数:发送通知的对象(只有这个对象发送过来的通知才会处理,如果传nil，所有的通知都会处理)
[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeColor:) name:@"changColor" object:nil];
//参数是NSNotification类型的对象
- (void)changeColor:(NSNotification *)notification
{
    //取到传递的参数值
    //定义一个key值@"myColor"
    NSDictionary *userInfo = notification.userInfo;
    
    UIColor *color = userInfo[@"myColor"];
    self.view.backgroundColor = color;
    
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
[UIView]
//视图的父子关系
//视图可以添加在任意视图上面，子视图的frame是相对于父视图的坐标系统。
//一个视图的父视图只能有一个，但子视图可以有多个。
//取得视图的父视图 UIView *superViewOfView1=view1.superview;
//取得视图的子视图 先设置子视图的tag, view2.tag=50; 然后取子视图的tag.
UIView *subView2OfTag=[View1 viewWithTag:50]; 这样 subView2OfTag==view2。
注：取子视图的tag是递归查找，如果子视图中没有tag这个子视图存在，会继续查找子视图的子视图。
//取得view的所有子视图， NSArray *subViewsOfView=[view subviews];
    /**
     *  调整视图大小
     @property(nonatomic) BOOL  autoresizesSubviews; // default is YES. if set, subviews are adjusted according to their autoresizingMask if self.bounds changes
     @property(nonatomic) UIViewAutoresizing autoresizingMask;    // simple resize. default is UIViewAutoresizingNone
     * autoresizingMask为枚举类型。
     typedef NS_OPTIONS(NSUInteger, UIViewAutoresizing) {
     UIViewAutoresizingNone                 = 0,
     UIViewAutoresizingFlexibleLeftMargin   = 1 << 0,
     UIViewAutoresizingFlexibleWidth        = 1 << 1,
     UIViewAutoresizingFlexibleRightMargin  = 1 << 2,
     UIViewAutoresizingFlexibleTopMargin    = 1 << 3,
     UIViewAutoresizingFlexibleHeight       = 1 << 4,
     UIViewAutoresizingFlexibleBottomMargin = 1 << 5
     };
     */
    //设置父视图的属性，使得其子视图可以自适应父视图调整大小
    view.autoresizesSubviews=YES;
    //取得视图的父视图
    UIView *superViewOfView=view.superview;
    //取得视图的子视图
    UIView *subViewOfTag= [super.view viewWithTag:100];
    //根据父视图的大小，调整视图的大小。
    view1.autoresizingMask= UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    CGPoint center=view.center;//取得视图的中心点
    view.bounds=CGRectMake(30, 30, 100, 100);
    //改变bounds的时候，是保持视图的中心点不变，然后修改宽和高。即修改后的视图会以原来的中心点变化。
    /**
     - (void)removeFromSuperview;
     - (void)insertSubview:(UIView *)view atIndex:(NSInteger)index;//在视图的子视图数组的一个位置添加视图,子视图索引从0开始；如果指定的索引超出了父视图对应的索引值，那么就会把这个子视图插在最上层，索引0 对应的就是最底层
     - (void)exchangeSubviewAtIndex:(NSInteger)index1 withSubviewAtIndex:(NSInteger)index2;
     
     - (void)addSubview:(UIView *)view;
     - (void)insertSubview:(UIView *)view belowSubview:(UIView *)siblingSubview;在指定的某个子视图下方插入一个新的子视图
     - (void)insertSubview:(UIView *)view aboveSubview:(UIView *)siblingSubview;在指定的某个子视图上方插入一个新的子视图
     */
    [self.view insertSubview:view4 atIndex:5];
    [self.view exchangeSubviewAtIndex:2 withSubviewAtIndex:3];//交换两个子视图的位置。
    /**
     - (void)bringSubviewToFront:(UIView *)view;
     - (void)sendSubviewToBack:(UIView *)view;
     */
[self.view bringSubviewToFront:view4];//将子视图显示在最前面
[self.view sendSubviewToBack:view7];//将子视图放到最后面
设置隐藏
redView.hidden = YES;//父视图隐藏子视图也会隐藏
3.如果子视图超出父视图范围是否裁剪子视图，默认是NO
redView.clipsToBounds = YES;
4.是否可以和用户进行交互,默认为YES，(UIImageView得这个属性默认是NO，用到时需设为YES)
redView.userInteractionEnabled = YES;//UIView 默认 YES
/*
如果可一个用户交互那么这个视图 可以接收点击，子视图也可以接收点击事件
谁在在上方谁想接受点击 最上方的会拦截
     如果设置为NO 子视图和父视图都不能接受点击事件，那么这个点击就会向下层传递知道能被接受事件的控件接收 如果最后没有控件接受这个事件 事件将会被抛弃
		UILabel UIIImageView userInteractionEnabled默认是NO，不可以和用户进行交互
        如果button 粘贴到UILabel 和UIIImageView上 button是不能被点击
        如果想要能点击button 就要把UILabel 和 UIIImageView 的userInteractionEnabled改为YES
     */
判断一个视图是否是另外一个视图的子视图
	[button isDescendantOfView:redView];

[数据存储方式]
数据存储的五种方式：
1.普通文件
2.plist文件
3.归档文件
4.NSUserDefaults
5.数据库sqlite
[数据存储方式之文件操作]
文件操作分为两个部分
1.对文件本身进行的操作，不需要打开文件，此时需要用到NSFileManager类
2.对文件中的内容进行的操作，需要打开文件，此时需要用到NSFileHandle类
//————————————————第一点——————————————————————
//————————————NSFileManager——————————————————
//创建一个文件管理器
NSFileManager * fm =[NSFileManager defaultManager];
//这是一个单例的应用，说明NSFileManager类是一个单例类
//—————查看一个目录下有哪些文件和文件夹———————————
NSError * error11=nil;
NSArray * array11=[fm contentsOfDirectoryAtPath:PATH error:&error11];
//浅度遍历目录,只会遍历一层目录，将PATH路径下的所有文件以及文件夹的名字存入数组，数组中存储的是相对于当前目录的相对路径,要注意的是路径包含目录名，当路径错误或者不是文件夹的时候会返回null,说明错误了。
NSArray * array12=[fm subpathsOfDirectoryAtPath:PATH error:&error11];
//深度遍历目录，将当前路径下所有文件，文件夹以及每个文件夹中的文件夹和文件都遍历到数组中
//———————————新建一个目录或者文件—————————————
[fm createDirectoryAtPath:[NSString stringWithFormat:@"%@/dir1",PATH] withIntermediateDirectories:YES attributes:nil error:&error11];
//该方法的功能是创建一个新的目录
//第一个参数表示：在某个目录下创建新目录(在PATH路径下，创建dir1目录)，
//第二个参数表示：在创建新目录时，是否创建缺少的中间路径目录，如果你需要创建新目录(@"%@/middle/dir1")，但是你得真实文件路径中缺少/middle部分，并且该参数选择NO的时候，就会报错，所以，当创建新目录是，路径中间缺少了一部分，就需要将该参数选择为YES，那么该方法就会将缺少的中间路径补充完整。
//第三个参数：属性
//第四个参数;错误信息
[name hasPrefix:@".lrc"]等价[strName isEqualToString[name pathExtension]]
--
//创建一个新的文件，如果文件已存在，会创建一个新文件来覆盖原来的文件。
- (BOOL)createFileAtPath:(NSString *)path contents:(NSData *)data attributes:(NSDictionary *)attr;
NSString *newPath=[NSString stringWithFormat:@"%@/wodemaya.txt",Path];
NSString *content=@"九阴白骨爪";
NSData *data=[content dataUsingEncoding:NSUTF8StringEncoding];
[fm createFileAtPath:newPath contents:data attributes:nil];
//第一个参数表示：在某个路径目录PATH/dir1下创建新的文件file(如，PATH/dir1",PATH);
//第二个参数表示：向文件中写入的NSData类型的数据，[@"hello",dataUsingEncoding:NSUTF8StringEncoding]表示将字符串转化为NSData，如果不向文件中写入内容的话，该参数可以写nil。
//第三个参数表示：文件的属性，nil表示选择系统默认的属性
//————————————————删除文件(目录)，直接删除，不会删除到废纸篓—————————
[fm removeItemAtPath:[NSString stringWithFormat:@"%@/dir1",PATH] error:&error11];
//删除该路径PATH下的dir文件夹
//————————————————复制文件——
[fm copyItemAtPath:[NSString stringWithFormat:@"%@/dir1",PATH] toPath:[NSString stringWithFormat:@"%@/dir2",PATH] error:&error11];
//将当前路径下的目录或者文件复制到指定路径，形成新的目录或文件
//————————————————移动(重命名)文件(目录)———
[fm moveItemAtPath:[NSString stringWithFormat:@"%@/dir1",PATH] toPath:[NSString stringWithFormat:@"%@/dir2/dir1",PATH] error:&error11];
//将当前路径下得目录或者文件移动到指定路径，形成新的目录或者文件
//拷贝目录是深度拷贝，会把目录下的所有东西都拷贝过来。
文件替换
//替换 指定文件中出现him 的地方全部替换为xiaohuang
[ZEStextHandle replaceStringInTextFile:FILEPATH withOldString:@"him" toNewString:@"xiaohuang"];     
//替换指定目录下所有的txt中出现的me 字符串
[ZEStextHandle replaceStringInDirectory:DPATH withOldString:@"me" toNewString:@"xiaozi" fileType:@"txt"];
BOOL isDir=NO;
BOOL rec=[manager fileExistsAtPath:(NSString *) isDirectory:(BOOL *)]//判断是否为目录。
BOOL ret1=[fm fileExistsAtPath:PATH];
//检测PATH路径文件是否存在
NSDictionary * dict11=[fm attributesOfItemAtPath:PATH error:&error11];
//获取PATH路径文件/目录信息（属性和权限）
unsigned long long len=[dict11 fileSize];
//从文件信息字典中，获取文件的长度
//————————————————第二点————————————————
//—————————————NSFileHandle—————————————
//————————————————文件句柄——————————————
//对句柄做操作，就是对文件做操作。
//读---将磁盘上的内容转移到内存
//写---将内存中的内容转移到磁盘
//————————————————只读方式————————————————————
fileHandleForUpdatingAtPath   即能读又能写
fileHandleForWritingAtPath  只能写，不能读
fileHandleForReadingAtPath  只能读不能写
NSFileHandle * fh=[NSFileHandle fileHandleForReadingAtPath:PATH];
//以只读的方式，打开指定路径下得文件，并生成文件句柄fh，这个文件句柄就是文件的代表，可以通过该文件句柄，将文件中的内容读出来
//句柄fh为空，表示文件不存在。
句柄会自动记录当前读取的位置。使用之后会停留在读取位置，下次接着句柄记录的位置继续读取。
NSData *data21=[fh readDataOfLength:3];
//从读指针位置（文件的开头）开始读取3个字节的数据内容
NSString *str21=[[NSString alloc]initWithData:data21 encoding:NSUTF8StringEncoding];
//将data21中的数据转化为NSString类型的字符串
NSData *data22=[fh readDataOfLength:5];
//从读指针位置（上次读取文件的末尾位置）开始读取5个字节的数据内容
NSString *str22=[[NSString alloc]initWithData:data22 encoding:NSUTF8StringEncoding];
//将data21中的数据转化为NSString类型的字符串
NSData *data23=[fh readDataToEndOfFile];
//如果文件的内容不是特别多得话，可以使用这种方法，直接从句柄（读指针）位置开始一直读取到文件末尾。
//————————————————只写方式————————————————————
//写入文件，从句柄开始写入。
fh=[NSFileHandle fileHandleForWritingAtPath:PATH];
//以只写的方式，打开指定路径下的文件，并生成文件句柄fh，可以通过该文件句柄，将数据写入到文件中去
[fh writeData:data];
[fh writeData:[@"hello world" dataUsingEncoding:NSUTF8StringEncoding]];
//向文件中，从句柄位置开始写入一个NSData类型的数据，当打开的文件中已经有内容时，那么新传入的内容将替代原来的内容
---
写一次文件，文件偏移量会后移 写文件是从文件首写入，一般要先把文件偏移量定位到文件尾部再写入
[fh seekToEndOfFile];
[fh writeData:data];
---
[fh synchronizeFile];要立即同步到磁盘
[fh truncateFileAtOffset:0];//将文件内容截断至0字节(相当于原来的内容只保留0字节)，也就相当于清空原文件中已经存在的内容
[fh seekToEndOfFile];
//将文件句柄fh所指向的文件的读写指针移动到文件的末尾位置
[fh seekToFileOffset:10];
//将文件句柄fh所指向的文件的读写指针移动到开始的10字节的地方
[fh1 seekToFileOffset:0];//把当前偏移量定位到文件首
//————————————————读写方式————————————————————
fh=[NSFileHandle fileHandleForUpdatingAtPath:PATH];
//以读写方式打开已经存在的文件，读写指针都定位到文件的起始位置
———————————————————————————————————————————
————————————————plist——————————————————————
———————————————————————————————————————————
//文件内容中所能存放的数据类型有NSString，NSNumber，NSDate，NSData，NSArray，NSDictionary
//不能是其他类型的对象，比如我们自定义的对象
//plist文件的作用:对一些登陆注册信息或者程序的配置信息（小数据）进行持久化存储
//plist创建
//plist文件的创建，除了使用Xcode的功能以外，还可以通过代码来进行
//想要将我们需要保存的数据存放到plist文件中，那么我们必须要将这些数据存放到一个数组或者字典中
NSString *name11 = @"xiaohong";
NSNumber *num11 = @123;
NSDate *date11 = [NSDate date];
NSArray *array11 = @[@"OC",@"UI"];
NSArray *array12 = @[name11,num11,date11,array11];
BOOL ret11 = [array12 writeToFile:@"/Users/qianfeng/Desktop/new1.plist" atomically:YES];
//用数组的写文件函数进行写入，那么写到plist文件中最外层就是是一个数组（最外层是一个[]），这个方法只能写plist格式的文件，当调用该方法时，plist文件会自动创建，当存在同名文件时，会发生覆盖。当不指定plist文件名时，会自动生成随机的plist文件名。
NSDictionary *dict11 = @{@"name": name11,@"number":num11,@"date":date11,@"array":array11};
BOOL ret12 = [dict11  writeToFile:@"/Users/qianfeng/Desktop/new2.plist" atomically:YES];
//用字典的写文件函数进行写入，那么写到plist文件中最外层就是是一个字典（最外层是一个{}），这个方法只能写plist格式的文件，当调用该方法时，plist文件会自动创建
//plist读取
//当我们需要读取一个plist文件时,我们首先需要知道所需要读取的plist文件的最外层是数组还是字典,如果是字典，那么就需要用字典的读文件,如果是数组，那么就用数组的读文件
NSArray *array13 = [[NSArray alloc] initWithContentsOfFile:@"/Users/qianfeng/Desktop/new1.plist"];
NSDictionary *dict12 = [[NSDictionary alloc] initWithContentsOfFile:@"/Users/qianfeng/Desktop/new2.plist"];
//不论是数组的，还是字典的该方法，都只能读取plist文件中的内容
//———————————————————————————————————————————
//————————————————归  档——————————————————————
//———————————————————————————————————————————
1.归档(也称对象序列化)就是通过某种格式把对象保存的本地文件，以便以后读回该对象的内容
2.解档(也称解归档/读档)就是把归档的对象文件读成原来的对象的过程。
3.归档和解档分为两类：系统类的归档和解档，自定义类的归档和解档
//————————————————系统类———————————
//1.系统类中都遵守了<NSCoding>协议，实现了协议中的方法，所以系统类可以直接进行归档和解档
//2.不仅仅归档的对象需要遵守<NSCoding>协议，包括这个对象中的所有属性，它们所属类的都必须要遵守NSCoding协议，该对象才能成功的进行归档和解档
NSArray *array21 = @[@"OC",@"UI",@"iOS"];
BOOL ret21 = [NSKeyedArchiver archiveRootObject:array21 toFile:@"/Users/qianfeng/Desktop/array.archiver"];
//把数组进行归档，因为数组的元素都遵守了<NSCoding>协议,归档会对文件进行加密
NSArray *newArray21 = [NSKeyedUnarchiver unarchiveObjectWithFile:@"/Users/qianfeng/Desktop/array.archiver"];
//归档的最外层是数组,所以解档的时候要用数组类进行接收
//————————————————自定义————
1.如果自定义的类对象要进行归档那么这个对象的属性所属的类也必须要遵守归档协议NSCoding
2.自定义的类型，如果想要进行归档和解档，必须遵守<NSCoding>协议
3.因为不管是自定义的类，还是系统类，进行归档和解档的时候，所调用的方法都是相同的,所以我们需要对<NSCoding>协议中所需要实现的两个方法进行重写
//遵守<NSCoding>协议，必须实现以下两个方法:
//- (void)encodeWithCoder:(NSCoder *)aCoder归档的时候调用的方法
//- (id)initWithCoder:(NSCoder *)aDecoder解归档的时候要调用的函数
/*
归档的时候要调用的方法
- (void)encodeWithCoder:(NSCoder *)aCoder{
//归档和读档的时候key要保持一致，这里的key是给<NSCoding>协议的制定者来使用的，所以我们只需要保持归档和读档的时候的key一致就行，而不需要我们通过这些key来获取数据
    [aCoder encodeInt:self.weight forKey:@"weight"];
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.engine forKey:@"engine"];
}
读档的会调用的方法
- (id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
//在进行读档的时候，用setter方法进行赋值不要直接用成员变量,因为这样我们能够获取数据的绝对绝对拥有权，不至于在<NSCoding>协议的制定者被自动释放池释放的时候，使我们丢失该对象的对象空间
    self.name = [aDecoder decodeObjectForKey:NAME];
    self.weight = [aDecoder decodeIntForKey:WEIGHT];
    self.engine = [aDecoder decodeObjectForKey:ENGINE];
}
[NSUserDefaults]
NSUserDefaults类提供了一个与默认系统进行交互的编程接口。NSUserDefaults对象是用来保存，恢复应用程序相关的偏好设置，配置数据等等。默认系统允许应用程序自定义它的行为去迎合用户的喜好。你可以在程序运行的时候从用户默认的数据库中读取程序的设置。同时NSUserDefaults的缓存避免了在每次读取数据时候都打开用户默认数据库的操作。可以通过调用synchronize方法来使内存中的缓存与用户默认系统进行同步。
 NSUserDefaults类提供了非常方便的方法来获取常用的类型，例如floats,doubles,intergers,Booleans,URLs。所以一个NSUserDefaults的对象必须是属性表，这也就是说我们可以存储NSData,NSString,NSNUmber,NSDate,NSArray,NSDictionary这些实例。如果你想存储其他类型的对象，你要将其归档并创建一个NSData来实现存储。
 从NSUserDefaults返回的值是不可改变的，即便是你在存储的时候使用的是可变的值。例如你使用mutable string做为“MyStringDefault”的值，当你做使用stringForKey:方法获取的值，这个值仍然是不可变的。
 NSUserDefaults是单例，同时也是线程安全的
 如果想单独看某个key的设置，例如:
 NSArray *array = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppleKeyboards"];
 */
//NSUserDefaults用来操作程序的一个特定目录下的一个plist文件。
//一般用来存储比较小的数据，比如用户名、密码等等。
//怎样取到NSUserDefaults中的值
NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];//也是单例
//根据Key来取值,如果根据这个Key值存储过，就取到对应的值，否则返回空
NSString *hasLaunch = [ud objectForKey:@"isFirstLaunched"];
//判断是否第一次启动
if (hasLaunch) {
    NSLog(@"不是第一次启动");
}else{
    NSLog(@"第一次启动");
}
//存储方法
//NSUserDefaults可以存储NSString/NSData/NSDate/NSURL/NSArry/NSDictionary/NSNumber这些基本对象类型,用setObject:forKey:方法存储。
//取到单例对象
NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
[ud setObject:@"hasLaunched" forKey:@"isFirstLaunched"];//存储
NSLog(@"save:%@ ---> %@",@"isFirstLaunched",[ud objectForKey:@"isFirstLaunched"]);
[ud synchronize];//同步

[UIImage:NSObject] UIImage继承自NSObject，没有frame属性，所以无法直接显示在Window当中，如果想要显示，则需要一个载体，UIImageView就是UIimage的最好的载体    
navC.tabBarItem.image = [[UIImage imageNamed:titles[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];//设置图片对象总是保持原始状态，不失真
//iOS7中，设置导航条上UIBarButtonItem图片按钮时候，图片默认显示蓝色，这样的话，图片就会失真，所以需要使图片总是保持原始状态，从而不失真
navC.tabBarItem.selectedImage  = [[UIImage imageNamed:[titles[i] stringByAppendingString:@"_selected"]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//获取文件路径
//第一个参数传入文件名，第二个参数传入扩展名
NSString *path=[[NSBundle mainBundle] pathForResource:@"map" ofType:@"png"];//获取工程的整体目录信息
取巧：NSString * path=[[NSBundle mainBundle]pathForResource:@"headImage.png" ofType:nil];
//从一个文件中读取一张图片，参数为文件在工程中的路径。UIImage : NSObject
//每次都从文件中读取，适用于我们在程序中只使用一次的图片。不会存储缓存。适用于比较大的图片。
//UIImage能够读取png/jpg/jpeg等图片类型。
//对png支持最好。如清晰度等效果是最好的。
UIImage *myImage=[UIImage imageWithContentsOfFile:path];
NSLog(@"%f,%f",myImage.size.width,myImage.size.height);
//UIView *myView=[[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];   //获取当前屏幕大小。 
[[UIScreen mainScreen] applicationFrame];bounds就是屏幕的全部区域，applicationFrame就是app显示的区域，在现在的iOS中这两个的大小是一样的。

[UIImageView : UIView]
UIImageView *imageView=[[UIImageView alloc] initWithImage:myImage];
imageView.frame=CGRectMake(0, 0, 375, myImage.size.height);
NSString *path2=[[NSBundle mainBundle] pathForResource:@"player1" ofType:@"png"];
//第二种方式：不会存储缓存，从网络上下载下来的二进制数据显示。
NSData *data=[NSData dataWithContentsOfFile:path2];
//第一个参数是图片文件的二进制数据。第二个参数表示要显示的图片大小，1表示既不缩小也不放大，2表示缩小一倍。
UIImage *image=[UIImage imageWithData:data scale:1];
NSLog(@"%f,%f",image.size.width,image.size.height);
//第三种方式：使用最多的一种方法，传入图片的名称，能够存储缓存。适用于使用次数多得图片和较小的图片。但对于大的图片最好不要用这种方式。
//这个方法能够自动的适配图片。palyer10.png  player10@2x.png player10@3x.png
UIImage *image3=[UIImage imageNamed:@"player10.png"];    
    //用UIImageView显示一张图片
    //UIImageView:UIView
    //UIImage:NSObject
    NSString *path=[[NSBundle mainBundle] pathForResource:@"map" ofType:@"png"];
    UIImage *image=[UIImage imageWithContentsOfFile:path];
    UIImageView *imageView=[[UIImageView alloc] initWithImage:image];
 imageView.frame=CGRectMake(20, 50, image.size.width, image.size.height);
    //创建一个图片视图，添加到imageView上
    NSString *path2=[[NSBundle mainBundle] pathForResource:@"q" ofType:@"jpg"];
    NSData *data=[NSData dataWithContentsOfFile:path2];
    UIImage *image2=[UIImage imageWithData:data];
    UIImageView *imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 280, 240)];
    imageView2.image=image2;//设置图片
    [imageView addSubview:imageView2];
    
    //用UIImageView显示多张图片
    //创建一个数组，存储多个UIImage对象
    NSMutableArray *imageArray=[NSMutableArray array];
    //添加UIImage对象。
    for (int i=1; i<13; i++) {
        NSString *imageName=[NSString stringWithFormat:@"player%d.png",i];
        UIImage *image=[UIImage imageNamed:imageName];//存储缓存，并根据分辨率自动匹配对应图片
        [imageArray addObject:image];
    }
    //创建一个UIImageView类型对象
    UIImageView *playerImageView=[[UIImageView alloc] initWithFrame:CGRectMake(100, 300, 40, 40)];
通过UIImageView 播放一个图片数组
    playerImageView.animationImages = imageArray;//设置动画数组，数组中存储有要连续显示的图片集
    playerImageView.animationDuration = 1; //设置播放数组的周期(多长时间轮一次)，,单位是秒
设置重复播放数组的次数
_imageView.animationRepeatCount = 0;//0表示无限次
设置默认图片
_imageView.image = _images[17];
    [imageView addSubview:playerImageView];
    [playerImageView startAnimating];//执行动画
    //添加手势
    //UIGestureRecognizer
    //UITapGestureRecognizer:UIGestureRecognizer 表示点击的手势
    //第一个参数表示点击手势发生后会调用这个对象的方法
    //第二个参数表示点击手势发生后会调用这个方法
    //选择器调用的方法的参数就是tagGersture对象
    UITapGestureRecognizer *tagGersture=[[UITapGestureRecognizer alloc]
                                         initWithTarget:self
                                         action:@selector(tapAction:)];
    [imageView addGestureRecognizer:tagGersture];//将手势添加到视图上
    imageView.userInteractionEnabled = YES;//开启用户的交互。UIImageView默认关闭了用户的交互，需要我们手动开启。
    playerImageView.tag=111;
}
- (void)tapAction:(UITapGestureRecognizer *)g{//手势，实现上面的点击操作
    NSLog(@"%s",__func__);
    UIImageView *imageView=(UIImageView *)g.view;
    //取到
    //- (UIView *)viewWithTag:(NSInteger)tag;     // recursive search. includes self
    UIImageView *playerImageView=(UIImageView *)[imageView viewWithTag:111];
    //如果在执行动画，就停止；如果停止了就重新开始动画。
    /**
     - (void)startAnimating;
     - (void)stopAnimating;
     - (BOOL)isAnimating;
     */
    if ([playerImageView isAnimating]) {
        [playerImageView stopAnimating];
    }else{
        [playerImageView startAnimating];
    }
}
imageView.contentMode=UIViewContentModeCenter;
//如果image的大小小于imageView的大小的话，那么系统会默认将图片进行拉伸，使整个image完全充满整个imageView;如果image的大小大于imageView的大小的话，那么系统会对image进行压缩，这样的话，图片就会失真，失去图片原有的宽高比例,如果想要使图片按照我们所想要达到的效果来显示，那么就需要设置imageView的内容模式
下面三种会改变图片的大小。
UIViewContentModeScaleToFill,
UIViewContentModeScaleAspectFit,      // contents scaled to fit with fixed aspect. remainder is transparent
UIViewContentModeScaleAspectFill,     // contents scaled to fill with fixed aspect. some portion of content may be clipped.

UIViewContentModeRedraw,              // redraw on bounds change (calls -setNeedsDisplay)
下边的多种方式，都会显示图片的实际大小，但是会改变图片在imageView中的位置
UIViewContentModeCenter,              // contents remain same size. positioned adjusted.
UIViewContentModeTop,
UIViewContentModeBottom,
UIViewContentModeLeft,
UIViewContentModeRight,
UIViewContentModeTopLeft,
UIViewContentModeTopRight,
UIViewContentModeBottomLeft,
UIViewContentModeBottomRight,
 NSString*path=[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/headImage.png"];//将图片保存到手机沙盒目录Documents文件夹里边去
//NSData *UIImagePNGRepresentation(UIImage *image); // return image as PNG. May return nil if image has no CGImageRef or invalid bitmap format
//NSData *UIImageJPEGRepresentation(UIImage *image, CGFloat compressionQuality);  // return image as JPEG. May return nil if image has no CGImageRef or invalid bitmap format. compression is 0(most)..1(least)
NSData * data=UIImagePNGRepresentation(image);
//将png格式的图片无损的压缩转换为二进制数据类型
[data writeToFile:path atomically:YES];
//将该图片的二进制数据写入到指定的路径
[沙盒中的文件和目录]
一般情况下每个沙盒含有4个文件：一个应用程序工程包，三个文件夹Documents, Library 和 tmp.
1.app(应用程序)包,存储一些程序资源和二进制程序，工程包中的资源文件一般只允许读，不允许写，如果需要对某些文件进行写操作，则需要将该文件从工程包中拷贝到其他文件.
2.Documents,存放一些自己的文件，保留存储一些重要信息，程序中浏览到的文件数据保存在该目录下。
3.Library，保存重要文件，如下载的图片，放入cache文件夹中，此目录下文件不会在应用退出删除。
4.tmp，一些临时文件放到这个目录中，当手机重启时会丢弃所有的tmp文件。
--
导入文件时，弹出的对话框下面的第二个选项中的第一个选项Create groups...那么运行程序之后会把这些资源直接放在沙盒的包得当前目录下。。如果选中的时Create folder...那么导入成功之后运行程序 会在沙盒的包目录下创建一个文件夹
--
1.获取沙盒路径
NSString *path = NSHomeDirectory();
2.获取Documents 路径
NSString *docPath = [path stringByAppendingString:@"/Documents"];
3.从沙盒的工程包中获取文件路径
 NSString *path = [[NSBundle mainBundle] pathForResource:@“文件名字” ofType:@“文件扩展名”];
4.上面的获取资源的方式只能获取应用程序包当前目录下的资源，如果包内有文件夹 ，那么不能获取文件夹内的资源路径。如果想获取包内文件夹中得资源那么我们需要换一个方法。
 NSArray *arr = [[NSBundle mainBundle] pathsForResourcesOfType:@“文件类型” inDirectory:@“文件夹名”];


//CALayer（Core Animation Layer）
//UIView都有一个layer属性，是CALayer类型
UIView *view=[[UIView alloc] init];
[self.view addSubview:view];
view.layer.frame=CGRectMake(30, 100, 100, 50);
view.layer.backgroundColor=[UIColor redColor].CGColor; //与view的backgroundColor类型不同，@property CGColorRef backgroundColor;

view.layer.cornerRadius = 5;//设置圆角

view.layer.borderColor = [UIColor blueColor].CGColor;//设置边框
view.layer.borderWidth = 3;
//设置bounds
view.layer.bounds=CGRectMake(0, 0, 200, 100);
view.layer.position=CGPointMake(0,0 );//位置.类似view的center， 都是中心点

//创建一个CALayer //图层，层次
CALayer *layer = [CALayer layer];
layer.frame=CGRectMake(20, 30, 100, 30);
layer.backgroundColor=[UIColor blueColor].CGColor;
//添加到self.views上。
[self.view.layer addSublayer:layer];

    //创建按钮，点击后用UIView来实现动画
- (void)animateAction1:(id)sender{
    //第一个参数表示动画的时间，单位是秒
    //第二个参数block，实现动画操作
    //第三个参数表示动画结束之后的操作
    [UIView animateWithDuration:0.1 animations:^{
        [self changeTwoView];
    } completion:^(BOOL finished) {
        
    }];
}
    //创建按钮，另一种方式实现动画
- (void)animateAction2:(id)sender{
    //@"animation2"动画的名字
    [UIView beginAnimations:@"animation2" context:nil];
    UIView *view1=[self.view viewWithTag:100];
    //UIViewAnimationTransitionCurlDown 动画的方式，
    //对view1使用动画
    //不缓存
    [UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:view1 cache:NO];
    
    //表示动画的方式
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    //设置时间
    [UIView setAnimationDuration:1];
    //设置重复次数
    [UIView setAnimationRepeatCount:3];
    
    //动画的操作
    [self changeTwoView];
    
    //提交动画
    [UIView commitAnimations];
}
    //创建按钮，点击后用CATransition实现动画
- (void)animateAction3:(id)sender{
    CATransition *transition = [CATransition animation];
    //设置动画类型
    //transition.type = kCATransitionReveal;
    transition.type = @"cameraIrisHollowOpen";
    //设置动画子类型
    transition.subtype = kCATransitionFromLeft;
    //设置shijian
    transition.duration = 1.0;
    [self changeTwoView];
    [self.view.layer addAnimation:transition forKey:nil];
}
    //创建按钮，点击后用CABasicAnimation实现动画
- (void)animateAction4:(id)sender{
    //frame
    //transform
    CABasicAnimation *basicAnimation = [CABasicAnimation animationWithKeyPath:@"position"];//表示这个动画是修改对象的position属性
    //取到view1
    UIView *view=[self.view viewWithTag:100];
    //获取view1的位置
    CGPoint oldPos = view.layer.position;
    //设置position初始值
    basicAnimation.fromValue = [NSValue valueWithCGPoint:oldPos];
    //设置动画的position结束值
    basicAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(20,500)];
    //设置时间
    basicAnimation.duration = 1;
    //添加动画
    [view.layer addAnimation:basicAnimation forKey:nil];
    
    view.layer.position = CGPointMake(100, 600);
}
1.动画的type值
1）@"cube"             立方体效果
2）@"suckEffect"       收缩效果，如一块布被抽走
3）@"oglFlip"          上下翻转效果
4）@"rippleEffect"     滴水效果
5）@"pageCurl"         向上翻一页
6）@"pageUnCurl"       向下翻一页
7）@"rotate"           旋转效果
8）@"cameraIrisHollowOpen"   相机镜头打开效果(不支持过渡方向)
9）@"cameraIrisHollowClose"  相机镜头关上效果(不支持过渡方向)

2.当type为@"rotate"(旋转)的时候,它也有几个对应的subtype,分别为:
1）90cw    逆时针旋转90°
2）90ccw   顺时针旋转90°
3）180cw   逆时针旋转180°
4）180ccw  顺时针旋转180°



[UIButton]
//self.view 背景颜色默认为白色
//创建一个UIButton类型的对象 UIButton:UIControl
//UIControl有相应的事件类型
UIButton *btn=[[UIButton alloc] initWithFrame:CGRectMake(50, 60, 100, 30)];
btn.backgroundColor=[UIColor blueColor];
[self.view addSubview:btn];
    //设置文字
    //第一个参数传显示的文字，第二个参数是一个UIControllerState枚举类型,表示按钮的状态。
    /*typedef NS_OPTIONS(NSUInteger, UIControlState) {
        UIControlStateNormal       = 0,
        UIControlStateHighlighted  = 1 << 0,                  // used when UIControl isHighlighted is set
        UIControlStateDisabled     = 1 << 1,禁用状态
设置 button是否可用 要想禁用button 必须要把这个属性设置为NO，然后禁用状态下的标题才有效; button.enabled = NO;
        UIControlStateSelected     = 1 << 2,                  // flag usable by app (see below)
        UIControlStateApplication  = 0x00FF0000,              // additional flags available for application use
        UIControlStateReserved     = 0xFF000000               // flags reserved for internal framework use
    };*/
    [btn setTitle:@"快乐键" forState:UIControlStateNormal];
    [btn setTitle:@"嘎嘎" forState:UIControlStateSelected];
    //设置颜色
    //第一个参数表示颜色 第二个参数同理
    [btn setTitle:@"高亮" forState:UIControlStateHighlighted];
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
    //修改字体
    btn.titleLabel.font=[UIFont systemFontOfSize:30];
设置button的四个角的圆角,我们可以通过视图的layer层修改视图
button.layer.cornerRadius = 8;
是否一同修改子视图，里面的子图层默认不会存储父图层的边界显示，也就意味着子图层默认可以超出父图层的范围，将这个属性设为YES，会将子图层超出的部分切除。与UIView的clipsToBounds的意思相同
button.layer.masksToBounds = YES;
//设置点击发亮效果
btn2.showsTouchWhenHighlighted=YES;
3.设置文字和图片显示
UIButton *btn3=[UIButton buttonWithType:UIButtonTypeCustom];
//设置button的背景图片
不管原来的图片实际有多大都会充满整个button
[btn3 setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
//设置button的内容图片
UIImage *image3=[UIImage imageNamed:@"logo.png"];
如果图片的实际大小 大于 button的frame 那么这个时候图片会压缩充满整个图片
如果图片的实际大小 小于 button的frame 那么这个时候图片会显示实际大小
[btn3 setImage:image3 forState:UIControlStateNormal];
[btn3 setTitle:@"go go go!" forState:UIControlStateNormal];
    //4.给按钮添加事件
    UIButton *btn4=[UIButton buttonWithType:UIButtonTypeSystem];
    btn4.frame=CGRectMake(50, 260, 100, 50);
    [btn4 setTitle:@"别碰我" forState:UIControlStateNormal];
    [btn4 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];//设置文字颜色
    [self.view addSubview:btn4];
    //添加时间
    //第三个参数是UIControlEvents枚举类型，用来表示用户的点击事件类型，注意别和UIControlerState混淆
    /*typedef NS_OPTIONS(NSUInteger, UIControlEvents) {
        UIControlEventTouchDown           = 1 <<  0,      // on all touch downs
        UIControlEventTouchDownRepeat     = 1 <<  1,      // on multiple touchdowns (tap count > 1)
        UIControlEventTouchDragInside     = 1 <<  2,
        UIControlEventTouchDragOutside    = 1 <<  3,
        UIControlEventTouchDragEnter      = 1 <<  4,
        UIControlEventTouchDragExit       = 1 <<  5,
UIControlEventTouchUpInside = 1 << 6,点击按钮 在一定范围内 抬起的时候触发
UIControlEventTouchUpOutside = 1 << 7,点击按钮 在一定范围外 抬起的时候触发
当button 被点击 在一定范围内抬起的时候 能触发事件
        UIControlEventTouchCancel         = 1 <<  8,
        
        UIControlEventValueChanged        = 1 << 12,     // sliders, etc.
        
        UIControlEventEditingDidBegin     = 1 << 16,     // UITextField
        UIControlEventEditingChanged      = 1 << 17,
        UIControlEventEditingDidEnd       = 1 << 18,
        UIControlEventEditingDidEndOnExit = 1 << 19,     // 'return key' ending editing
        
        UIControlEventAllTouchEvents      = 0x00000FFF,  // for touch events
        UIControlEventAllEditingEvents    = 0x000F0000,  // for UITextField
        UIControlEventApplicationReserved = 0x0F000000,  // range available for application use
        UIControlEventSystemReserved      = 0xF0000000,  // range reserved for internal framework use
        UIControlEventAllEvents           = 0xFFFFFFFF
    };*/
//第一个参数表示用户实现了相应地点击事件之后会去调用这个对象相应的方法。
//第二个参数为被调用对象的方法。
//target-action机制
[btn4 addTarget:self action:@selector(clickButton) forControlEvents:UIControlEventTouchUpInside];
//删除button上的事件
[button removeTarget:(id) action:(SEL) forControlEvents:(UIControlEvents)];

    //5.设置按钮上文字和图片的位置
    UIButton *btn5=[UIButton buttonWithType:UIButtonTypeCustom];
    btn5.frame=CGRectMake(50, 320, 100, 100);
    [btn5 setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [btn5 setTitle:@"花火山" forState:UIControlStateNormal];
    [btn5 setImage:[UIImage imageNamed:@"logo.png"] forState:UIControlStateNormal];
    [self.view addSubview:btn5];
    //图片的位置，距离上下左右边界的距离
    /**
     *  UIKIT_STATIC_INLINE UIEdgeInsets UIEdgeInsetsMake(CGFloat top, CGFloat left, CGFloat bottom, CGFloat right) {
     UIEdgeInsets insets = {top, left, bottom, right};
     return insets;
     }
     */
    btn5.imageEdgeInsets=UIEdgeInsetsMake(30, 30, 0, 30);
    btn5.titleEdgeInsets=UIEdgeInsetsMake(0, -30, 30, 0);
    //设置圆角
    btn5.layer.cornerRadius=50;
    btn5.layer.masksToBounds=YES;//给加有背景图片的button设置圆角
    //创建三个按钮
    UIButton *beginButton=[UIButton buttonWithType:UIButtonTypeSystem];
    beginButton.frame=CGRectMake(50, 40, 100, 40);
    [beginButton setTitle:@"开始" forState:UIControlStateNormal];
    beginButton.backgroundColor=[UIColor blueColor];
    [self.view addSubview:beginButton];
    beginButton.showsTouchWhenHighlighted=YES;
    [beginButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [beginButton addTarget:self action:@selector(beginAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *pauseButton=[UIButton buttonWithType:UIButtonTypeSystem];
    pauseButton.frame=CGRectMake(50, 100, 100, 40);
    [pauseButton setTitle:@"暂停" forState:UIControlStateNormal];
    pauseButton.backgroundColor=[UIColor blueColor];
    [self.view addSubview:pauseButton];
    pauseButton.showsTouchWhenHighlighted=YES;
    [pauseButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [pauseButton addTarget:self action:@selector(pauseButton) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *restoreButton=[UIButton buttonWithType:UIButtonTypeSystem];
    restoreButton.frame=CGRectMake(50, 150, 100, 40);
    [restoreButton setTitle:@"恢复" forState:UIControlStateNormal];
    restoreButton.backgroundColor=[UIColor blueColor];
    [self.view addSubview:restoreButton];
    restoreButton.showsTouchWhenHighlighted=YES;
    [restoreButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [restoreButton addTarget:self action:@selector(restoreButton:) forControlEvents:UIControlEventTouchUpInside];
    
    //得到当天的日期
    NSDate *date=[NSDate date];
    
    NSDateFormatter *df=[[NSDateFormatter alloc]init];
    //设置一个格式
    [df setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    
    NSString *dataString=[df stringFromDate:date];
    NSLog(@"%@",dataString);
    NSDate *today=[df dateFromString:dataString];
}
-(void)beginAction:(UIButton*)btn{
    [_timer invalidate];//取消原来的_timer
[定时器的创建]
    //第一个参数:定时器的间隔，单位是秒
    //第二个参数:表示定时器每个间隔的时间回调用某个对象的某个方法
    //第三个参数:被调用的方法,参数是NSTimer类型
    //第四个参数:传用户的信息
    //第五个参数:表示是否重复
    //+ (NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)ti target:(id)aTarget selector:(SEL)aSelector userInfo:(id)userInfo repeats:(BOOL)yesOrNo;一旦定时器这样创建 定时器就会立即启动线程 开始执行
    _timer=[NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(createView:) userInfo:nil repeats:YES];
}
-(void)pauseButton{
//计时器停止
    _timer.fireDate=[NSDate distantFuture];//永远到不了的时间. setFireDate:
}
-(void)restoreButton:(id)sender{
//计时器启动
    _timer.fireDate=[NSDate distantPast];//很久以前的时间。
}
-(void)createView:(NSTimer*)timer{
    UIView *view=[[UIView alloc] init];
    view.backgroundColor=[UIColor colorWithRed:arc4random()%256/255.0f green:arc4random()%256/255.0f blue:arc4random()%256/255.0f alpha:1];
    view.frame=CGRectMake(arc4random()%100, 200+arc4random()%200, arc4random()%200, arc4random()%100);
    [self.view addSubview:view];
}
//定时器的销毁
if(_timer.isValid){
    [_timer invalidate];
}
[UIImage]
//创建UIImage类型的对象
//获取文件路径
//第一个参数传入文件名，第二个参数传入扩展名
NSString *path=[[NSBundle mainBundle] pathForResource:@"map" ofType:@"png"];//获取工程的整体目录信息
//从一个文件中读取一张图片，参数为文件在工程中的路径。UIImage : NSObject
//每次都从文件中读取，适用于我们在程序中只使用一次的图片。不会存储缓存。适用于比较大的图片。
//UIImage能够读取png/jpg/jpeg等图片类型。
//对png支持最好。如清晰度等效果是最好的。
UIImage *myImage=[UIImage imageWithContentsOfFile:path];
NSLog(@"%f,%f",myImage.size.width,myImage.size.height);//输出图片的原始大小。
//UIView *myView=[[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

//根据图片创建一个图片视图。UIImageView : UIView
UIImageView *imageView=[[UIImageView alloc] initWithImage:myImage];
imageView.frame=CGRectMake(0, 0, 375, myImage.size.height);
//- (void)addSubview:(UIView *)view;
[self.view addSubview:imageView];
NSString *path2=[[NSBundle mainBundle] pathForResource:@"player1" ofType:@"png"];
//第二种方式：不会存储缓存，从网络上下载下来的二进制数据显示。
//UIImage *image=[UIImage imageWithData:<#(NSData *)#>]旧方式
NSData *data=[NSData dataWithContentsOfFile:path2];
//第一个参数是图片文件的二进制数据。第二个参数表示要显示的图片大小，1表示既不缩小也不放大，2表示缩小一倍。
UIImage *image=[UIImage imageWithData:data scale:1];
NSLog(@"%f,%f",image.size.width,image.size.height);
//第三种方式：使用最多的一种方法，传入图片的名称，能够存储缓存。适用于使用次数多得图片和较小的图片。但对于大的图片最好不要用这种方式。
//这个方法能够自动的适配图片。palyer10.png  player10@2x.png player10@3x.png
UIImage *image3=[UIImage imageNamed:@"player10.png"];

self.view.hidden=YES;//设置将视图隐藏

[UIController的生命周期]
/**
 *  这个方法用来创建self.view这个属性值。调用self.view必须在这个方法之后才有作用。这个方法不需要手动调用。
    通常不需要重写这个方法，会自动调用父类的loadView方法
    如果需要重写，首先调用[super loadView]; 然后再写其他代码
 */
- (void)loadView{
    [super loadView];
    NSLog(@"%s",__func__);
}
//将自己的视图控制器加到默认的窗口上。在AppDelegate.m文件中添加。
CompanyViewController *rootCtrl = [[CompanyViewController alloc] init];
self.window.rootViewController = rootCtrl;//将CompanyViewController的实例和window相关联。启动时将首先显示CompanyViewController控制器下的视图。

[界面切换]
切换界面的三种方式：
第一种：//切换界面
//第一个参数：传入将要跳转的视图控制器
//第二个参数：YES 有动画； NO 无动画。
//第三个参数：界面切换之后需要做的操作放在这个block中。
//这是使用模态方式来实现切换界面
//将self.view从窗口上移除，再将subCtrl.view添加到窗口;presentViewController:subCtrl animated:YES completion:^{
    NSLog(@"切换结束");
}];
-------
//第一个参数：YES有动画；NO无动画。
    //第二个参数：block,界面返回之后会进行的操作。
    [self dismissViewControllerAnimated:YES completion:nil];//必须和presentViewController对应
 /*
 The next two methods are replacements for presentModalViewController:animated and
 dismissModalViewControllerAnimated: The completion handler, if provided, will be invoked after the presented
 controllers viewDidAppear: callback is invoked.
 */
/**
- (void)presentViewController:(UIViewController *)viewControllerToPresent animated: (BOOL)flag completion:(void (^)(void))completion NS_AVAILABLE_IOS(5_0);
// The completion handler, if provided, will be invoked after the dismissed controller's viewDidDisappear: callback is invoked.
- (void)dismissViewControllerAnimated: (BOOL)flag completion: (void (^)(void))completion NS_AVAILABLE_IOS(5_0);
 */
第二种：
/**
 The methods in the UIContainerViewControllerProtectedMethods and the UIContainerViewControllerCallbacks
 categories typically should only be called by subclasses which are implementing new container view
 controllers. They may be overridden but must call super.
@interface UIViewController (UIContainerViewControllerProtectedMethods)

// An array of children view controllers. This array does not include any presented view controllers.
 
@property(nonatomic,readonly) NSArray *childViewControllers NS_AVAILABLE_IOS(5_0);

 If the child controller has a different parent controller, it will first be removed from its current parent by calling removeFromParentViewController. If this method is overridden then the super implementation must be called.

 - (void)addChildViewController:(UIViewController *)childController NS_AVAILABLE_IOS(5_0);

 Removes the the receiver from its parent's children controllers array. If this method is overridden then the super implementation must be called.

 - (void) removeFromParentViewController NS_AVAILABLE_IOS(5_0);

 This method can be used to transition between sibling child view controllers. The receiver of this method is their common parent view controller. (Use [UIViewController addChildViewController:] to create the parent/child relationship.) This method will add the toViewController's view to the superview of the fromViewController's view and the fromViewController's view will be removed from its superview after the transition completes. It is important to allow this method to add and remove the views. The arguments to this method are the same as those defined by UIView's block animation API. This method will fail with an NSInvalidArgumentException if the parent view controllers are not the same as the receiver, or if the receiver explicitly forwards its appearance and rotation callbacks to its children. Finally, the receiver
 should not be a subclass of an iOS container view controller. Note also that it is possible to use the
 UIView APIs directly. If they are used it is important to ensure that the toViewController's view is added
 to the visible view  while the fromViehierarchywController's view is removed.

 - (void)transitionFromViewController:(UIViewController *)fromViewController toViewController:(UIViewController *)toViewController duration:(NSTimeInterval)duration options:(UIViewAnimationOptions)options animations:(void (^)(void))animations completion:(void (^)(BOOL finished))completion NS_AVAILABLE_IOS(5_0);

// If a custom container controller manually forwards its appearance callbacks, then rather than calling
// viewWillAppear:, viewDidAppear: viewWillDisappear:, or viewDidDisappear: on the children these methods
// should be used instead. This will ensure that descendent child controllers appearance methods will be
// invoked. It also enables more complex custom transitions to be implemented since the appearance callbacks are
// now tied to the final matching invocation of endAppearanceTransition.

 - (void)beginAppearanceTransition:(BOOL)isAppearing animated:(BOOL)animated __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_5_0);
- (void)endAppearanceTransition __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_5_0);

// Override to return a child view controller or nil. If non-nil, that view controller's status bar appearance attributes will be used. If nil, self is used. Whenever the return values from these methods change, -setNeedsUpdatedStatusBarAttributes should be called.
- (UIViewController *)childViewControllerForStatusBarStyle NS_AVAILABLE_IOS(7_0);
- (UIViewController *)childViewControllerForStatusBarHidden NS_AVAILABLE_IOS(7_0);

// Call to modify the trait collection for child view controllers.
- (void)setOverrideTraitCollection:(UITraitCollection *)collection forChildViewController:(UIViewController *)childViewController NS_AVAILABLE_IOS(8_0);
- (UITraitCollection *)overrideTraitCollectionForChildViewController:(UIViewController *)childViewController NS_AVAILABLE_IOS(8_0);

@end
*/
@interface UIViewController (UIContainerViewControllerCallbacks)

--
 This method is consulted to determine if a view controller manually forwards its containment callbacks to
 any children view controllers. Subclasses of UIViewController that implement containment logic may override
 this method. The default implementation returns YES. If it is overridden and returns NO, then the subclass is
 responsible for forwarding the following methods as appropriate - viewWillAppear: viewDidAppear: viewWillDisappear:
 viewDidDisappear: willRotateToInterfaceOrientation:duration:
 willAnimateRotationToInterfaceOrientation:duration: didRotateFromInterfaceOrientation:
--
- (BOOL)automaticallyForwardAppearanceAndRotationMethodsToChildViewControllers NS_DEPRECATED_IOS(5_0,6_0);
- (BOOL)shouldAutomaticallyForwardRotationMethods NS_DEPRECATED_IOS(6_0,8_0, "Manually forward viewWillTransitionToSize:withTransitionCoordinator: if necessary");

- (BOOL)shouldAutomaticallyForwardAppearanceMethods NS_AVAILABLE_IOS(6_0);


--
 These two methods are public for container subclasses to call when transitioning between child
 controllers. If they are overridden, the overrides should ensure to call the super. The parent argument in
 both of these methods is nil when a child is being removed from its parent; otherwise it is equal to the new
 parent view controller.
 
 addChildViewController: will call [child willMoveToParentViewController:self] before adding the
 child. However, it will not call didMoveToParentViewController:. It is expected that a container view
 controller subclass will make this call after a transition to the new child has completed or, in the
 case of no transition, immediately after the call to addChildViewController:. Similarly
 removeFromParentViewController: does not call [self willMoveToParentViewController:nil] before removing the
 child. This is also the responsibilty of the container subclass. Container subclasses will typically define
 a method that transitions to a new child by first calling addChildViewController:, then executing a
 transition which will add the new child's view into the view hierarchy of its parent, and finally will call
 didMoveToParentViewController:. Similarly, subclasses will typically define a method that removes a child in
 the reverse manner by first calling [child willMoveToParentViewController:nil].
--
- (void)willMoveToParentViewController:(UIViewController *)parent NS_AVAILABLE_IOS(5_0);
- (void)didMoveToParentViewController:(UIViewController *)parent NS_AVAILABLE_IOS(5_0);

@end
------
[手机状态栏的隐藏]
iPhone或者iPad开发中，尤其是开发游戏时，经常需要隐藏statusBarStyle，
[UIApplication sharedApplication].statusBarHidden=YES即可实现隐藏，可是状态条所占空间依然无法为程序所用，将UIView的frame的y值设置为-20也有点不合理。解决办法如下：
工程.plist文件中添加一项：“Status bar is initially hidden”即可
或者将View controller-based status bar appearance 设置为NO
注：从iOS7开始，手机状态栏是交给当独的控制器去管理(每个控制器都有自己的状态栏)，不再交给Application来管理
/*
 状态栏的管理：
 1> iOS7之前：UIApplication
 2> iOS7开始：交给对应的控制器去管理
 放在根控制器中可控制所有的视图控制器。
  */
- (UIStatusBarStyle)preferredStatusBarHidden;
- (UIStatusBarStyle)preferredStatusBarStyle
{
    // 白色样式
	return UIStatusBarStyleLightContent;
}
common+F --搜索快捷键
-----
 */
//获取子视图控制器
//数组形式，保存有所有的子视图控制器
NSArray *childVCs = self.childViewControllers;

//获取SubCtrl这个对象
SubViewController *subCtrl=[childVCs firstObject];
[self.view addSubview:subCtrl.view];
---
[self.view removeFromSuperview];
第三种：
添加为某一视图的子视图以切换到子视图，然后从父视图删除子视图，以回到原来的视图。
[界面间的传值]
1、正向传值
在后一个视图中建一个属性，然后在这个视图中创建其对象，即可将值传到后一个视图。
2、反向传值
第一种，使用系统的单例类来传值。
 /**
     *  + (UIApplication *)sharedApplication NS_EXTENSION_UNAVAILABLE_IOS("Use view controller based solutions where appropriate instead.");
     
     @property(nonatomic,assign) id<UIApplicationDelegate> delegate;
*/
//设置代理
//textField.delegate = self;//这一步不是通过单例传值，而是设置键盘收回
NSString *text=textField.text;//取值
//通过系统的单例类来传值。
//取得应用的对象
UIApplication *app = [UIApplication sharedApplication];
//取得AppDelegate类型的对象
AppDelegate *appDelegate = app.delegate;
//把text的值传递给appDelegate的textString属性
appDelegate.textString = text;

//修改label上的文字
UIApplication *app=[UIApplication sharedApplication];//静态方法sharedApplication 来获取应用程序的句柄。
AppDelegate *appDelegate=app.delegate;
NSString *text=appDelegate.textString;//取到传过来的值
//取到label
UILabel *label=(UILabel*)[self.view viewWithTag:100];
label.text=text;
[代理传值模式]
//代理设计模式概念:
代理设计模式指：两个对象之间的一个对象（被动方）接受另外一个对象（主动方）的指挥，代替另外一个对象（主动方）去处理相应的事件。
在两个对象之间进行数据交互的时候，往往会出现这种情形：
1.两个对象之间的一个对象（主动方）能够监听到特定事件何时发生，但是在事件发生的时候，该对象（主动方）却不知道该进行何种处理
2.两个对象之间的另一个对象（被动方）知道在产生该特定事件的时候，应该进行何种处理，但却不知道该事件会在何时发生
当出现上述这种情形的时候，我们就可以使用代理设计模式来进行处理，通过主动方，来对特定事件进行监听，当主动方监听到该特定事件发生的时候，则通知被动方，来对该特定事件进行处理
#pragma mark - 代理设计模式的三种模型（协议_代理&Block&Target_Action）
//协议_代理，Block，Target_Action都是代理设计模式，只不过在表达方式上有所不同罢了
[代理设计模式之使用Block变量传值]
Block模型作为代理设计模式的一种，我们同样也需要考虑这三个问题：
1.Block变量定义在哪里：Block变量定义在主动方，通过使用typedef定义一个特定类型的Block变量
2.谁来写Block代码块，或者说是谁来对Block变量赋值：在被动方中创建主动方的时候，需要在被动方中，对Block变量进行赋值，并将赋值之后的Block变量，传递给主动方中的Block成员变量，之后，主动方会在适当的时刻对该Block变量进行调用
3.谁来调用Block变量：主动方在监听到特定事件发生的时候，对Block变量进行调用
--
主动方需要承担两个事情：
//1.声明一个特定类型的Block变量，并使用@property定义一个该类型的Block成员变量，在使用@property的时候，注意应该使用copy来对Block变量进行强引用，而不是retain
//2.在适当的时候，调用执行该Block变量
[.h]typedef void (^ChangeLabel)(NSString *);
//将void(^)(NSString*)类型的Block重定义为ChangeLabel类型的Block
@property (nonatomic,copy) ChangeLabel change;
//使用@property定义一个ChangeLabel类型的Block成员变量，
[.m]self.change(@"werwer");
//调用Block变量，来修改被动方界面的Label的值，达到反向传值的目的
被动方需要承担一个事情
//当前界面（被动方）在适当的时候，创建主动方，并对主动方中的Block成员变量进行赋值，在从当前界面（被动方）跳转到主动方界面之后，主动方会在适当的时候调用该Block来修改当前界面（被动方）的Label的值
YYBBlock * block=[[YYBBlock alloc]init];
//创建YYBBlockView类型的对象（主动方），在该对象（主动方）中修改当前界面（被动方）的Label的值
block.change=^(NSString *str){
//该Block变量会在新界面（主动方）的UISwitch控件被点击的时候进行调用
        label.text = str;
};
[代理设计模式之Tatget_Action传值]
Target_Action模型作为代理设计模式的一种形式，同样也需要考虑这三个问题：
1.Target（id）变量定义在哪里，Action（SEL）变量定义在哪里：Target变量需要在主动方中定义一个id类型的对象来接受，Action变量需要在主动方中定义一个SEL类型的对象来接受，因为这两个变量相当于协议_代理模型中的delegate成员变量，所以需要使用弱引用，以避免造成循环引用
2.什么时候为Target（id）变量赋值，什么时候为Action（SEL）变量赋值：在被动方中创建主动方的时候，调用主动方的Target_Action方法，同时对主动方中的Target（id）变量和Action（SEL）变量赋值
3.在什么时候让Target（id）变量调用Action（SEL）变量：在主动方监听到特定事件发生的时候，主动方会通过Target（id）变量来调用Action（SEL）变量，通过传入适当的参数，来执行Action（SEL）变量所对应的方法
--
主动方需要承担两个事情
1.定义一个id类型的Target变量，用来接受伪代理对象;定义一个SEL类型的Action变量，用来接受为代理对象中的指定的方法
2.当主动方监听到特定事件的发生的时候，会通过Target（id）变量，调用Action（SEL）变量所对应的方法,从而来处理主动方所监听到的特定事件
[.h]
@property (nonatomic,assign) id target;
//定义一个id类型的Target变量，用来接受伪代理对象
@property (nonatomic,assign) SEL action;
//定义一个SEL类型的Action变量，用来接受为代理对象中的指定的方法
- (void)addTarget:(id)target action:(SEL)action;
//封装，并对外提供一个Target_Action方法，使被动方能够将Target（id）变量和Action（SEL）变量传入主动方
[.m]
[self.target performSelector:self.action withObject:@"mySwitch"];
//当前界面的UISwitch监听到点击事件的时候，通过Target（id）变量，调用Action（SEL）变量所对应的方法，来处理其监听到的点击事件,从而，修改被动方界面的Label的值
被动方需要承担一个事情
当前界面（被动方）在适当的时候，创建主动方，并对调用主动方中的Target_Action方法,同时对主动方中的Target（id）变量和Action（SEL）变量赋值,在从当前界面（被动方）跳转到主动方界面之后，主动方会在适当的时候调用该Block来修改当前界面（被动方）的Label的值
[.m]
YYBTarget_Action * target_Action=[[YYBTarget_Action alloc]init];
//创建新界面的对象（主动方）
[target_Action addTarget:self action:@selector(changeLabel:)];
//调用主动方的Target_Action方法，同时对主动方中的Target（id）变量和Action（SEL）变量赋值,这里，需要将被动方设置为主动方的Target（id）变量,同时，需要将被动方中的changeLabel:方法，通过@selector关键字，设置为主动方的Action（SEL）变量
- (void)changeLabel:(NSString *)mySwitch{
    UILabel * label=(UILabel *)[self.view viewWithTag:101];
    //通过tag值来获取当前界面（被动方）的Label
	label.text = mySwitch;
}
[代理设计模式之通过协议传值]
协议_代理模型作为代理设计模式的一种形式，我们同样也需要考虑这三个问题：
1.协议在哪里制定:协议制定在主动方
2.谁来实现协议中的方法:遵守了主动方协议的被动方，将会实现协议中的方法
3.谁来调用协议中的方法:在主动方监听到特定事件的时候，会通过代理成员变量，来调用协议中的方法,而只有遵守了主动方所制定的协议的对象，才能被设置为主动方的代理
---
主动方需要承担两个事情：
1.制定协议，并定义一个遵守了该协议的代理成员变量
2.在当前界面监听到特定事件发生的时候，通过代理来调用协议中的方法，对特定事件进行处理
[.h]
@protocol SubViewControllerDelegate;//协议的前置声明，告诉编译器这是一个协议
@property (nonatomic,weak)id<SubViewControllerDelegate> delegate;//定义一个遵守了协议的代理成员变量
@protocol ZLProtocol_Delegate <NSObject>//制定一个协议
- (void)transforValue:(NSString *)value;//声明协议方法
@end
[.m]
[self.delegate transforValue:textField.text];    //通过代理调用代理中实现的协议方法，来修改被动方Label的值
被动方需要承担一个事情：
实现主动方的协议中的方法，并且在适当的时候，创建新界面（主动方），并将自己（被动方）设置为主动方的代理,在从当前界面（被动方）跳转到主动方界面之后，主动方会在适当的时候通过代理来调用协议中的方法,从而处理主动方所监听到的特定事件
[.h]
@interface ZLRootViewController : UIViewController<ZLProtocol_Delegate>//遵守协议
[.m]
SubViewController * protocol_Delegate=[[SubViewController alloc]init];
//创建新界面对象（主动方）
protocol_Delegate.delegate=self;//将当前界面（被动方）设置为主动方的代理
#pragma mark - 实现协议方法
- (void)transforValue:(NSString *)value{
    //修改label上的文字
    UILabel *label=(UILabel*)[self.view viewWithTag:100];
    label.text=value;
}
第三种：使用通知中心进行传值
NSNotificationCenter 较之于 Delegate 可以实现更大的跨度的通信机制，可以为两个无引用关系的两个对象进行通信。NSNotificationCenter 的通信原理使用了观察者模式：
1. NSNotificationCenter 注册观察者对某个事件(以字符串命名)感兴趣，及该事件触发时该执行的 Selector 或 Block
2. NSNotificationCenter 在某个时机激发事件(以字符串命名)，即向该观察者发送消息。
3. 观察者在收到感兴趣的事件时，执行相应的 Selector 或 Block，事件到来时检测if(notification.object && [notification.object isKindOfClass:[Test class]]){}
[收听消息方]
//向通知中心添加一个观察者，当有对象向该指定的观察者发送消息时，就可取得消息内容。
//[NSNotificationCenter defaultCenter]  取得通知中心的单例对象
NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
//添加观察者
//这个方法会创建一个NSNotification类型的对象，添加到通知中心里面。
//第一个参数：在注册通知以后，如果通知中心发送了这个通知，就会调用这个对象的对应方法。
//第二个参数：被调用的方法
//第三个参数：通知的名称，也就是通知的唯一标示,自己起的名字
//第四个参数：发送通知时，传递过来的参数
[nc addObserver:self selector:@selector(changeValue:) name:@"transferValue" object:nil];
- (void)changeValue:(NSNotification*)notification{
   UITextView *text = (UITextView*)[self.view viewWithTag:50];
   NSLog(@"receive%@",notification.object);
   text.text = nil;
   text.text = notification.object;
}
/**
 ****************	Notification Center	****************
@interface NSNotificationCenter : NSObject {
    @package
    void * __strong _impl;
    void * __strong _callback;
    void *_pad[11];
}
+ (NSNotificationCenter *)defaultCenter;

- (void)addObserver:(id)observer selector:(SEL)aSelector name:(NSString *)aName object:(id)anObject;

- (void)postNotification:(NSNotification *)notification;
- (void)postNotificationName:(NSString *)aName object:(id)anObject;
- (void)postNotificationName:(NSString *)aName object:(id)anObject userInfo:(NSDictionary *)aUserInfo;

- (void)removeObserver:(id)observer;
- (void)removeObserver:(id)observer name:(NSString *)aName object:(id)anObject;

- (id <NSObject>)addObserverForName:(NSString *)name object:(id)obj queue:(NSOperationQueue *)queue usingBlock:(void (^)(NSNotification *note))block NS_AVAILABLE(10_6, 4_0);
// The return value is retained by the system, and should be held onto by the caller in
// order to remove the observer with removeObserver: later, to stop observation.
@end
 */
/**
 @interface NSNotification (NSNotificationCreation)
 + (instancetype)notificationWithName:(NSString *)aName object:(id)anObject;
 + (instancetype)notificationWithName:(NSString *)aName object:(id)anObject userInfo:(NSDictionary *)aUserInfo;
 - (instancetype)init  *NS_UNAVAILABLE*;	* do not invoke; not a valid initializer for this class *
@end
 */
[发送消息方]
textField.delegate=self;//首先设置UITextField代理，才能使用UITextFieldDelegate协议中的方法取得textField中的信息。
//取到传递的值
    NSString *textString = textField.text;
//取得通知中心
//第一个参数表示观察者的名字，表示向哪个观察者发送消息
//第二参数传递的参数
[[NSNotificationCenter defaultCenter] postNotificationName:@"transferValue" object:textString];
也可以使用明确的notification。
NSNotification *notification = [NSNotification notificationWithName:@"transferValue" object:textString];
[[NSNotificationCenter defaultCenter] postNotification:notification];
最后，你的观察者如果对一些事件没兴趣了，应该从 NotificationCenter 中移除掉：
[[NSNotificationCenter defaultCenter] removeObserver:self name:@"NOTIFICATION_NAME"
object:test];//object 与注册时相同
//或[[NSNotificationCenter defaultCenter] removeObserver:self];

五、使用协议和代理的步骤
1.创建一个协议(SubViewControllerDelegate)
2.在协议里面创建需要的方法的声明
3.在被代理对象的类型(SubViewController)里面
	添加一个代理的属性
@property (nonatomic,weak)id<SubViewControllerDelegate>delegate;
4.在代理对象的类型(ViewController)里面遵守协议
	同时实现协议里面的方法

5.将代理对象(ViewController ====self)设置为被代理对象(subCtrl)的代理
6.使用协议和代理
在被代理对象的类型(SubViewController)里面调用self.delegate的方法
这个方法必须是我们的协议里面的方法


六、通知中心
NSNotificationCenter

1.向通知中心添加一个观察者
2.通知中心可以发送通知，所有添加过观察者的对象都能够收到这个通知
/**
 //
 // UITextInputTraits
 //
 // Controls features of text widgets (or other custom objects that might wish
 // to respond to keyboard input).
 //
 @protocol UITextInputTraits <NSObject>
 
 @optional
 
 @property(nonatomic) UITextAutocapitalizationType autocapitalizationType; // default is UITextAutocapitalizationTypeSentences
 @property(nonatomic) UITextAutocorrectionType autocorrectionType;         // default is UITextAutocorrectionTypeDefault
 @property(nonatomic) UITextSpellCheckingType spellCheckingType NS_AVAILABLE_IOS(5_0); // default is UITextSpellCheckingTypeDefault;
 @property(nonatomic) UIKeyboardType keyboardType;                         // default is UIKeyboardTypeDefault
 @property(nonatomic) UIKeyboardAppearance keyboardAppearance;             // default is UIKeyboardAppearanceDefault
 @property(nonatomic) UIReturnKeyType returnKeyType;                       // default is UIReturnKeyDefault (See note under UIReturnKeyType enum)
 @property(nonatomic) BOOL enablesReturnKeyAutomatically;                  // default is NO (when YES, will automatically disable return key when text widget has zero-length contents, and will automatically enable when text widget has non-zero-length contents)
 @property(nonatomic,getter=isSecureTextEntry) BOOL secureTextEntry;       // default is NO   默认密码明文显示
@end
 */

代理delegate与通知Notification/block的使用区别
：delegate与block一般是用于两个对象一对一之间的通信交互，delegate需要定义协议方法，代理对象实现协议方法，并且需要建立代理关系才可以实现通信。block更加简洁，不需要定义繁琐的协议方法，如果通信事件比较多的话，建议使用delegate。Notification主要用于一对多情况下地通信，而且，通信对象之间不需要建立关系，使用通知会导致代码可读性差。

[UITextField]

[UITextField:UIControl]文本输入框,显示文字，编辑文字

UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(50, 100, 260, 40)];
[self.view addSubview:textField];
设置文本输入框的样式 风格
UITextBorderStyleNone,//无边框
UITextBorderStyleLine,//有边框
UITextBorderStyleBezel,//带阴影
UITextBorderStyleRoundedRect//圆角
textField.borderStyle = UITextBorderStyleBezel;//设置边框样式，默认UITextBorderStyleNone
设置文本输入框边框角度
textField.layer.cornerRadius = 8;
是否一同修改子视图(未验证)
textField.layer.masksToBounds = YES;
textField.placeholder = @"请输入文字";//设置提示文字,输入内容后，该提示信息消失
textField.text=@"康熙来了";//设置文字
textField.textColor = [UIColor redColor];//设置文字颜色
textField.textAlignment = NSTextAlignmentCenter;//设置水平对齐方式
textField.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;//设置属性对齐方式。设置貌似不起作用
textField.contentVerticalAlignment = UIControlContentVerticalAlignmentBottom;//设置垂直对齐方式。
textField.font = [UIFont systemFontOfSize:30];//字体
textField.keyboardType = UIKeyboardTypeNumberPad;//设置键盘类型，默认UIKeyboardTypeDefault
设置密文(密码)
field1.secureTextEntry = YES;
//textfield只有一行内容没有换行
设置宽度自适应(达到滚动的效果)
field1.adjustsFontSizeToFitWidth = YES;
设置滚动效果的字体最小值(要先设置宽度)
field1.minimumFontSize = 20;
设置首字母大写形式
UITextAutocapitalizationTypeNone,首字母不自动大写
UITextAutocapitalizationTypeNone,首字母不自动大写
UITextAutocapitalizationTypeWords,单词首字母大写
UITextAutocapitalizationTypeSentences,句子首字母大写
UITextAutocapitalizationTypeAllCharacters,全部字母大写
*/
field1.autocapitalizationType = UITextAutocapitalizationTypeSentences;
设置是否自动检错
field1.autocorrectionType = UITextAutocorrectionTypeDefault;
设置左右视图
UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(100, 20, 40, 40)];
imageView.image = [UIImage imageNamed:@"4.png"];
设置左视图,只有大小对左视图有影响,必须要先设置左视图模式
field1.leftViewMode = UITextFieldViewModeAlways;
field1.leftView = imageView;
设置右视图,必须要先设置右视图模式，但左右视图模式用同一张图片可能会出问题
field1.rightViewMode = UITextFieldViewModeAlways;
field1.rightView = imageView;

textField.clearButtonMode = UITextFieldViewModeWhileEditing;//设置清除按钮
UITextFieldViewModeNever,从不显示
UITextFieldViewModeWhileEditing,编辑的时候显示
UITextFieldViewModeUnlessEditing,不编辑的时候
UITextFieldViewModeAlways总是显示

再次编辑时是否清空编辑内容
field1.clearsOnBeginEditing = YES;

textField.background = [UIImage imageNamed:@"back.png"];//设置背景图片，这个和textField.borderStyle = UITextBorderStyleRoundedRect;冲突。
键盘显示风格
field1.keyboardAppearance = UIKeyboardAppearanceAlert;
UIKeyboardAppearanceDefault,
UIKeyboardAppearanceDark ,
UIKeyboardAppearanceLight ,
UIKeyboardAppearanceAlert = UIKeyboardAppearanceDark,
[UIKeyboardType]键盘样式
field1.keyboardType = UIKeyboardTypeDefault;
//Requests that a particular keyboard type be displayed when a text widget
 // becomes first responder.
 // Note: Some keyboard/input methods types may not support every variant.
 // In such cases, the input method will make a best effort to find a close
 // match to the requested type (e.g. displaying UIKeyboardTypeNumbersAndPunctuation
 // type if UIKeyboardTypeNumberPad is not supported).
 //
 typedef NS_ENUM(NSInteger, UIKeyboardType) {
UIKeyboardTypeDefault, // Default type for the current input method.
UIKeyboardTypeASCIICapable,  // Displays a keyboard which can enter ASCII characters, non-ASCII keyboards remain active
UIKeyboardTypeNumbersAndPunctuation,  // Numbers and assorted punctuation.
UIKeyboardTypeURL,                    // A type optimized for URL entry (shows . / .com prominently).
UIKeyboardTypeNumberPad,              // A number pad (0-9). Suitable for PIN entry.
UIKeyboardTypePhonePad,               // A phone pad (1-9, *, 0, #, with letters under the numbers).
UIKeyboardTypeNamePhonePad,           // A type optimized for entering a person's name or phone number.
UIKeyboardTypeEmailAddress,           // A type optimized for multiple email address entry (shows space @ . prominently).
 UIKeyboardTypeDecimalPad NS_ENUM_AVAILABLE_IOS(4_1),   // A number pad with a decimal point.
 UIKeyboardTypeTwitter NS_ENUM_AVAILABLE_IOS(5_0),      // A type optimized for twitter text entry (easy access to @ #)
 UIKeyboardTypeWebSearch NS_ENUM_AVAILABLE_IOS(7_0),    // A default keyboard type with URL-oriented addition (shows space . prominently).
 
 UIKeyboardTypeAlphabet = UIKeyboardTypeASCIICapable, // Deprecated
 
 };
 */
textField.returnKeyType = UIReturnKeyJoin;//设置return按键的类型。即改变输入键盘上右下角按键的作用
[UIReturnKeyType]设置 return 键的样式
field1.returnKeyType = UIReturnKeyDefault;
 //
 // Controls the display of the return key.
 //
 // Note: This enum is under discussion and may be replaced with a
 // different implementation.
 //
 typedef NS_ENUM(NSInteger, UIReturnKeyType) {
 UIReturnKeyDefault,
 UIReturnKeyGo,
 UIReturnKeyGoogle,
 UIReturnKeyJoin,
 UIReturnKeyNext,
 UIReturnKeyRoute,
 UIReturnKeySearch,
 UIReturnKeySend,
 UIReturnKeyYahoo,
 UIReturnKeyDone,
 UIReturnKeyEmergencyCall,
 };
 */
/**
 *  // You can supply custom views which are displayed at the left or right
 // sides of the text field. Uses for such views could be to show an icon or
 // a button to operate on the text in the field in an application-defined
 // manner.
 //
 // A very common use is to display a clear button on the right side of the
 // text field, and a standard clear button is provided. Note: if the clear
 // button overlaps one of the other views, the clear button will be given
 // precedence.
 
 @property(nonatomic)        UITextFieldViewMode  clearButtonMode; // sets when the clear button shows up. default is UITextFieldViewModeNever
 
 @property(nonatomic,retain) UIView              *leftView;        // e.g. magnifying glass
 @property(nonatomic)        UITextFieldViewMode  leftViewMode;    // sets when the left view shows up. default is UITextFieldViewModeNever
 
 @property(nonatomic,retain) UIView              *rightView;       // e.g. bookmarks button
 @property(nonatomic)        UITextFieldViewMode  rightViewMode;   // sets when the right view shows up. default is UITextFieldViewModeNever
 */

textField.delegate = self;

//成为第一响应者。光标默认在第一响应者上。
[textField becomeFirstResponder];
/**
 - (UIResponder*)nextResponder;
 
 - (BOOL)canBecomeFirstResponder;    // default is NO
 - (BOOL)becomeFirstResponder;
 
 - (BOOL)canResignFirstResponder;    // default is YES
 - (BOOL)resignFirstResponder;
 
 - (BOOL)isFirstResponder;
 */
/**
 @protocol UITextFieldDelegate <NSObject>
 
 @optional
将要进入编辑模式 
 - (BOOL)textFieldShouldBeginEditing:(UITextField *)textField;        // return NO to disallow editing.
已经进入编辑模式
 - (void)textFieldDidBeginEditing:(UITextField *)textField;           // became first responder//开始编辑时触发，文本字段将成为first responder
将要结束编辑模式
 - (BOOL)textFieldShouldEndEditing:(UITextField *)textField;          // return YES to allow editing to stop and to resign first responder status. NO to disallow the editing session to end//返回BOOL值，指定是否允许文本字段结束编辑，当编辑结束，文本字段会让出first responder
 //要想在用户结束编辑时阻止文本字段消失，可以返回NO
 //这对一些文本字段必须始终保持活跃状态的程序很有用，比如即时消息
已经结束编辑模式
 - (void)textFieldDidEndEditing:(UITextField *)textField;             // may be called if forced even if shouldEndEditing returns NO (e.g. view removed from window) or endEditing:YES called
是否把键盘输入的内容接入textField
range:记录的当前的光标的位置 length为0
 - (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
   // return NO to not change text当用户使用自动更正功能，把输入的文字修改为推荐的文字时，就会调用这个方法。
	if (textField.tag == TEXTFIELD_TAG+2) {
        //限制密码位数 不能多于6位
        if (textField.text.length + string.length > 6) {
            //将要输入的字符串长度和已经输入的字符串长度不能>6
            return NO;
        }
    }
}
 //这对于想要加入撤销选项的应用程序特别有用
 //可以跟踪字段内所做的最后一次修改，也可以对所有编辑做日志记录,用作审计用途。
 //要防止文字被改变可以返回NO
 //这个方法的参数中有一个NSRange对象，指明了被改变文字的位置，建议修改的文本也在其中
//是否可以点击清除按钮
 - (BOOL)textFieldShouldClear:(UITextField *)textField;// called when clear button pressed. return NO to ignore (no notifications)//返回一个BOOL值指明是否允许根据用户请求清除内容,可以设置在特定条件下才允许清除内容
 
 - (BOOL)textFieldShouldReturn:(UITextField *)textField;              // called when 'return' key pressed. return NO to ignore.
 
 @end
 */
////返回一个BOOL值，指明是否允许在按下回车键时结束编辑
//如果允许要调用resignFirstResponder 方法，这回导致结束编辑，而键盘会被收起
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];//收起键盘，放弃第一响应者
    
    NSLog(@"%s",__func__);
    return NO;//返回YES和NO 貌似没什么区别。
}
//用户开始编辑文字时调用
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    NSLog(@"%s",__func__);
}
//用户结束编辑时调用，也就是键盘收起时调用
- (void)textFieldDidEndEditing:(UITextField *)textField{
    NSLog(@"%s",__func__);
    
    UILabel *label = (UILabel*)[self.view viewWithTag:100];
    label.text = textField.text;    
}





NS_CLASS_AVAILABLE_IOS(2_0) @interface UITextField : UIControl <UITextInput, NSCoding> 

@property(nonatomic,copy)   NSString               *text;                 // default is nil
@property(nonatomic,copy)   NSAttributedString     *attributedText NS_AVAILABLE_IOS(6_0); // default is nil
@property(nonatomic,retain) UIColor                *textColor;            // default is nil. use opaque black
@property(nonatomic,retain) UIFont                 *font;                 // default is nil. use system font 12 pt
@property(nonatomic)        NSTextAlignment         textAlignment;        // default is NSLeftTextAlignment
@property(nonatomic)        UITextBorderStyle       borderStyle;          // default is UITextBorderStyleNone. If set to UITextBorderStyleRoundedRect, custom background images are ignored.
@property(nonatomic,copy)   NSDictionary           *defaultTextAttributes NS_AVAILABLE_IOS(7_0); // applies attributes to the full range of text. Unset attributes act like default values.

@property(nonatomic,copy)   NSString               *placeholder;          // default is nil. string is drawn 70% gray
@property(nonatomic,copy)   NSAttributedString     *attributedPlaceholder NS_AVAILABLE_IOS(6_0); // default is nil
@property(nonatomic)        BOOL                    clearsOnBeginEditing; // default is NO which moves cursor to location clicked. if YES, all text cleared
@property(nonatomic) BOOL adjustsFontSizeToFitWidth; // default is NO. if YES, text will shrink to minFontSize along baseline宽度自适应
@property(nonatomic)        CGFloat                 minimumFontSize;      // default is 0.0. actual min may be pinned to something readable. used if adjustsFontSizeToFitWidth is YES
@property(nonatomic,assign) id<UITextFieldDelegate> delegate;             // default is nil. weak reference
@property(nonatomic,retain) UIImage                *background;           // default is nil. draw in border rect. image should be stretchable
@property(nonatomic,retain) UIImage                *disabledBackground;   // default is nil. ignored if background not set. image should be stretchable

@property(nonatomic,readonly,getter=isEditing) BOOL editing;
@property(nonatomic) BOOL allowsEditingTextAttributes NS_AVAILABLE_IOS(6_0); // default is NO. allows editing text attributes with style operations and pasting rich text
@property(nonatomic,copy) NSDictionary *typingAttributes NS_AVAILABLE_IOS(6_0); // automatically resets when the selection changes

// You can supply custom views which are displayed at the left or right
// sides of the text field. Uses for such views could be to show an icon or
// a button to operate on the text in the field in an application-defined
// manner.
// 
// A very common use is to display a clear button on the right side of the
// text field, and a standard clear button is provided. Note: if the clear
// button overlaps one of the other views, the clear button will be given
// precedence.

@property(nonatomic)        UITextFieldViewMode  clearButtonMode; // sets when the clear button shows up. default is UITextFieldViewModeNever

@property(nonatomic,retain) UIView              *leftView;        // e.g. magnifying glass
@property(nonatomic)        UITextFieldViewMode  leftViewMode;    // sets when the left view shows up. default is UITextFieldViewModeNever

@property(nonatomic,retain) UIView              *rightView;       // e.g. bookmarks button
@property(nonatomic)        UITextFieldViewMode  rightViewMode;   // sets when the right view shows up. default is UITextFieldViewModeNever

// drawing and positioning overrides

- (CGRect)borderRectForBounds:(CGRect)bounds;
- (CGRect)textRectForBounds:(CGRect)bounds;
- (CGRect)placeholderRectForBounds:(CGRect)bounds;
- (CGRect)editingRectForBounds:(CGRect)bounds;
- (CGRect)clearButtonRectForBounds:(CGRect)bounds;
- (CGRect)leftViewRectForBounds:(CGRect)bounds;
- (CGRect)rightViewRectForBounds:(CGRect)bounds;

- (void)drawTextInRect:(CGRect)rect;
- (void)drawPlaceholderInRect:(CGRect)rect;

// Presented when object becomes first responder.  If set to nil, reverts to following responder chain.  If
// set while first responder, will not take effect until reloadInputViews is called.
@property (readwrite, retain) UIView *inputView;             
@property (readwrite, retain) UIView *inputAccessoryView;

@property(nonatomic) BOOL clearsOnInsertion NS_AVAILABLE_IOS(6_0); // defaults to NO. if YES, the selection UI is hidden, and inserting text will replace the contents of the field. changing the selection will automatically set this to NO.

@end
[UINavigationController:UIViewController]导航控制器,是一个架构级的控件，是用来管理多个子视图控制器的一个控件。导航控制器由导航条，工具栏、子视图控制器三部分组成。
导航控制器管理子视图控制器采用的是栈数据结构原理：导航控制器的根视图控制器始终处于栈底,每当有一个子视图控制器通过push被压入导航控制器的栈中，都会存放在栈顶,每当导航控制器的一个子视图控制器通过pop出栈，该子视图控制器就会从数据栈中移除，离开屏幕，并销毁。
[注意]：子视图控制器视图背景颜色默认是clearColor，在iOS7中，如果通过导航控制器进行子视图跳转会发生卡壳的现象，这个时候需要给子视图控制器加背景颜色，卡壳现象就会消失
在对导航控制器的子视图控制的视图进行布局的时候，需要考虑导航条的影响，竖屏模式下，手机状态栏的大小为320*20，导航条的大小为320*44
---
self.navigationController.navigationBar.translucent = YES;
//设置导航条的半透明属性，默认为YES，表示导航条半透明，NO，表示导航条不透明
如果导航条的半透明属性设置为半透明，子试图控制器的视图从UIWindow的（0，0）坐标开始布局
如果导航条的半透明属性设置为不透明，子视图控制器的视图从UIWindow的（0，64）坐标开始布局
当给导航条(self.navigationController.navigationBar)添加背景图片后，会强制将导航条的半透明属性设置为不透明。从而使得子视图控制器的视图从(0,64)坐标开始布局。所以这种情况下，子视图的frame需从(0,0,,)开始。
---
self.navigationController.navigationBar.backgroundColor = [UIColor redColor];
//设置导航条的背景颜色，
在导航条不透明时，设置导航条的背景颜色无效
在导航条半透明时，设置导航条的背景颜色，并且导航条的背景图片没有完全覆盖导航条时，才能看到导航条的背景颜色
self.navigationController.navigationBar.barTintColor=[UIColor redColor];
//设置导航条的颜色，可以通过该属性来设置，该属性在iOS7才有效
//self.navigationController.navigationBar.barColor=[UIColor redColor];
//该属性同样可以设置导航条的颜色，不过该属性在iOS6中才有效
注意：----这个不清楚；设置导航条的背景颜色与设置导航条的颜色是两个不同的概念，请大家理解清楚
注意：
设置导航条的标题，导航条的标题属于导航控制器中的对应的子视图控制器，而不属于导航控制器的导航条，在设置导航条的标题时，导航条的标题会影响第二个子视图控制器的导航条的返回按钮的标题.在设置导航条的标题或者标题视图的时候，都是在导航条320*44内部居中显示的.
self.title=@"第一页";//设置导航控制器的导航条标题，需要注意的是,
//如果同时存在导航控制器（navigationBar）和标签控制器（tabBar），该属性会同时影响导航条和标签条的标题
self.navigationItem.title=@"第一页";//设置导航控制器的导航条在当前子视图控制器中的导航条标题
//创建导航控制器
//首先创建一个视图控制器
FirstViewController *firstCtrl = [[FirstViewController alloc] init];
//将这个视图控制器对象作为导航控制器的根视图控制器，来创建一个导航控制器
UINavigationController *navCtrl = [[UINavigationController alloc] initWithRootViewController:firstCtrl];
self.window.rootViewController = navCtrl;//将这个导航控制器设置为窗口的根视图控制器
[self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationBar64"] forBarMetrics:UIBarMetricsDefault];
设置导航条的背景图片
第一个参数表示：导航栏的背景图片，图片的大小有严格要求
             竖屏模式导航条大小320*44，横屏模式导航条大小480*32，
             高清竖屏导航条大小640*88，高清横屏导航条大小960*64，
             在竖屏模式下，如果背景图片的高度为64，则会波及状态，同时修改状态栏的背景图片
第二个参数表示：横竖屏模式设置
             UIBarMetricsDefault设置竖屏模式（人像模式）
             UIBarMetricsLandscapePhone设置横屏模式（风景模式）

[导航控制器-切换界面]
//导航控制器是通过压栈的方式切换界面.push  pop
SecendViewController *secondCtrl = [[SecendViewController alloc] init];
//切换到第二个视图控制器
//取到当前视图所属的导航控制器(前提是，当前控制器添加到了导航控制器里面)
//第一个参数，传入将要跳转到的导航控制器。
//第二个参数，YES表示有动画，NO表示没动画。
[self.navigationController pushViewController:secondCtrl animated:YES];
@property(nonatomic) BOOL hidesBottomBarWhenPushed; // If YES, then when this view controller is pushed into a controller hierarchy with a bottom bar (like a tab bar), the bottom bar will slide out. Default is NO.设为YES时，当push进一个视图控制器后，隐藏BottomBar.
//iOS8,新增
//第一个参数，传入将要跳转到的导航控制器。
//第二个参数，表示跳转的这个事件是谁触发的
[self.navigationController showViewController:secondCtrl sender:nil];
[self.navigationController popViewControllerAnimated:YES];//回到上一个视图
[self.navigationController popToRootViewControllerAnimated:YES];//回到第一个视图
//回到任意视图
NSArray *arr=[self.navigationController viewControllers];
[self.navigationController popToViewController:arr[1] animated:YES];

NS_CLASS_AVAILABLE_IOS(2_0) @interface UINavigationController : UIViewController
/* Use this initializer to make the navigation controller use your custom bar class. 
   Passing nil for navigationBarClass will get you UINavigationBar, nil for toolbarClass gets UIToolbar.
   The arguments must otherwise be subclasses of the respective UIKit classes.
 */
- (instancetype)initWithNavigationBarClass:(Class)navigationBarClass toolbarClass:(Class)toolbarClass NS_AVAILABLE_IOS(5_0);

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController; // Convenience method pushes the root view controller without animation.

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated; // Uses a horizontal slide transition. Has no effect if the view controller is already in the stack.

- (UIViewController *)popViewControllerAnimated:(BOOL)animated; // Returns the popped controller.
- (NSArray *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated; // Pops view controllers until the one specified is on top. Returns the popped controllers.
- (NSArray *)popToRootViewControllerAnimated:(BOOL)animated; // Pops until there's only a single view controller left on the stack. Returns the popped controllers.

@property(nonatomic,readonly,retain) UIViewController *topViewController; // The top view controller on the stack.
@property(nonatomic,readonly,retain) UIViewController *visibleViewController; // Return modal view controller if it exists. Otherwise the top view controller.

@property(nonatomic,copy) NSArray *viewControllers; // The current view controller stack.
- (void)setViewControllers:(NSArray *)viewControllers animated:(BOOL)animated NS_AVAILABLE_IOS(3_0); // If animated is YES, then simulate a push or pop depending on whether the new top view controller was previously in the stack.

@property(nonatomic,getter=isNavigationBarHidden) BOOL navigationBarHidden;
- (void)setNavigationBarHidden:(BOOL)hidden animated:(BOOL)animated; // Hide or show the navigation bar. If animated, it will transition vertically using UINavigationControllerHideShowBarDuration.
[self.navigationController setNavigationBarHidden:NO animated:YES];
设置导航条的隐藏属性（YES表示隐藏，NO表示不隐藏）.如果导航栏的子视图控制器中，一部分需要显示导航条，一部分不需要显示导航条,可以在生命周期函数中，设置导航条的隐藏属性，来控制导航条的隐藏或者显示

@property(nonatomic,readonly) UINavigationBar *navigationBar; // The navigation bar managed by the controller. Pushing, popping or setting navigation items on a managed navigation bar is not supported.
@property(nonatomic,getter=isToolbarHidden) BOOL toolbarHidden NS_AVAILABLE_IOS(3_0); // Defaults to YES, i.e. hidden.
- (void)setToolbarHidden:(BOOL)hidden animated:(BOOL)animated NS_AVAILABLE_IOS(3_0); // Hide or show the toolbar at the bottom of the screen. If animated, it will transition vertically using UINavigationControllerHideShowBarDuration.
@property(nonatomic,readonly) UIToolbar *toolbar NS_AVAILABLE_IOS(3_0); // For use when presenting an action sheet.
@property(nonatomic, assign) id<UINavigationControllerDelegate> delegate;
@property(nonatomic, readonly) UIGestureRecognizer *interactivePopGestureRecognizer NS_AVAILABLE_IOS(7_0);
- (void)showViewController:(UIViewController *)vc sender:(id)sender NS_AVAILABLE_IOS(8_0); // Interpreted as pushViewController:animated:
/// When the keyboard appears, the navigation controller's navigationBar toolbar will be hidden. The bars will remain hidden when the keyboard dismisses, but a tap in the content area will show them.
@property (nonatomic, readwrite, assign) BOOL hidesBarsWhenKeyboardAppears NS_AVAILABLE_IOS(8_0);
/// When the user swipes, the navigation controller's navigationBar & toolbar will be hidden (on a swipe up) or shown (on a swipe down). The toolbar only participates if it has items.
@property (nonatomic, readwrite, assign) BOOL hidesBarsOnSwipe NS_AVAILABLE_IOS(8_0);
/// The gesture recognizer that triggers if the bars will hide or show due to a swipe. Do not change the delegate or attempt to replace this gesture by overriding this method.
@property (nonatomic, readonly, retain) UIPanGestureRecognizer *barHideOnSwipeGestureRecognizer NS_AVAILABLE_IOS(8_0);
/// When the UINavigationController's vertical size class is compact, hide the UINavigationBar and UIToolbar. Unhandled taps in the regions that would normally be occupied by these bars will reveal the bars.
@property (nonatomic, readwrite, assign) BOOL hidesBarsWhenVerticallyCompact NS_AVAILABLE_IOS(8_0);
/// When the user taps, the navigation controller's navigationBar & toolbar will be hidden or shown, depending on the hidden state of the navigationBar. The toolbar will only be shown if it has items to display.
@property (nonatomic, readwrite, assign) BOOL hidesBarsOnTap NS_AVAILABLE_IOS(8_0);
/// The gesture recognizer used to recognize if the bars will hide or show due to a tap in content. Do not change the delegate or attempt to replace this gesture by overriding this method.
@property (nonatomic, readonly, assign) UITapGestureRecognizer *barHideOnTapGestureRecognizer NS_AVAILABLE_IOS(8_0);
@end
//导航条
//一个导航控制器只有一个导航条
//所有它管理的视图控制器共用这一个导航条
//获取导航条
//self.navigationController.navigationBar;
//1.设置导航条的风格样式
//    typedef NS_ENUM(NSInteger, UIBarStyle) {
//        UIBarStyleDefault          = 0,
//        UIBarStyleBlack            = 1,
//        
//        UIBarStyleBlackOpaque      = 1, // Deprecated. Use UIBarStyleBlack
//        UIBarStyleBlackTranslucent = 2, // Deprecated. Use UIBarStyleBlack and set the translucent property to YES
第一种风格，导航栏背景颜色显示为白色，并且在屏幕64高度处，有一条导航分割线，其他三种风格效果完全相同，
下面三种风格，在导航条不透明状态下显示为黑色，在导航条半透明状态下，会加深子视图控制器的背景颜色
并且，这三种风格，会取消导航栏在屏幕64高度处的那条导航栏分割线

//    };
self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
//2.设置背景颜色
self.navigationController.navigationBar.backgroundColor = [UIColor grayColor];
//3.设置barTintColor
self.navigationController.navigationBar.barTintColor = [UIColor grayColor];
//4.设置背景图片
//竖屏时，导航栏的高度是44，（375*44 ip6 ; 320*44 ip5）
//第一个参数，背景图片对象
//第二个参数，（UIBarMetrics枚举类型）
UIImage *image = [[UIImage imageNamed:@"navigationbar.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:5];//设置图片拉伸
[self.navigationController.navigationBar setBackgroundImage:image
                                              forBarMetrics:UIBarMetricsDefault];
//设置竖屏的导航背景图片
//横屏时，导航栏的高度是32， （667*32 ip6  ; 568*32 ip5）
UIImage *image1 = [[UIImage imageNamed:@"nav-32.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:5];
[self.navigationController.navigationBar setBackgroundImage:image1 forBarMetrics:UIBarMetricsCompact];
/**
 @interface UIImage(UIImageDeprecated)
 - (UIImage *)stretchableImageWithLeftCapWidth:(NSInteger)leftCapWidth topCapHeight:(NSInteger)topCapHeight;
 @property(nonatomic,readonly) NSInteger leftCapWidth;   // default is 0. if non-zero, horiz. stretchable. right cap is calculated as width - leftCapWidth - 1
 @property(nonatomic,readonly) NSInteger topCapHeight;   // default is 0. if non-zero, vert. stretchable. bottom cap is calculated as height - topCapWidth - 1
 @end
 */
//添加视图后，IOS7之后，y值最少从64
UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(100, 44, 200, 100)];
//隐藏导航条
//self.navigationController.navigationBarHidden = YES;
//self.navigationController.navigationBar.hidden = YES;
//UINavigationItem:NSObject的使用
//导航控制器里面的每一个视图都有一个navigationItem属性
//    self.navigationItem.title = @"首页";//设置标题
//设置一个视图
UIView *redView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
redView.backgroundColor = [UIColor redColor];
self.navigationItem.titleView = redView;//将该子视图设置为导航控制器的导航条在当前子视图控制器中的导航条标题视图
//设置左边按钮,必须是UIBarButtonItem类型
//1.按钮上显示的文字
//2.按钮的样式
//3.点击按钮会调用这个对象的某个方法。4.
UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithTitle:@"设置" style:UIBarButtonItemStyleDone target:self action:@selector(clickLeft:)];
self.navigationItem.leftBarButtonItem = leftItem;//设置navigationItem左边的按钮，添加一个按钮
标题选项按钮的风格：
UIBarButtonItemStylePlain     //扁平化风格
UIBarButtonItemStyleDone      //颜色有点设置右边按钮，另一种方法
//1.按钮样式
//2.同左
UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(clickRight:)];
//self.navigationItem.rightBarButtonItem = rightItem;//添加一个
//创建另外一个右边的按钮
UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
btn.frame = CGRectMake(0, 0, 100, 40);
[btn setTitle:@"添加" forState:UIControlStateNormal];
[btn addTarget:self action:@selector(clickRight2:) forControlEvents:UIControlEventTouchUpInside];
UIBarButtonItem *rightItem2 = [[UIBarButtonItem alloc] initWithCustomView:btn];

self.navigationItem.rightBarButtonItems = @[rightItem,rightItem2];//添加多个按钮

self.navigationController.navigationBar.tintColor = [UIColor redColor];//字体颜色
//UIToolBar
//默认隐藏了toolBar属性
self.navigationController.toolbarHidden = NO;
//创建一个UIBarButtonItem类型的对象
UIBarButtonItem *oneItem = [[UIBarButtonItem alloc] initWithTitle:@"新闻" style:UIBarButtonItemStylePlain target:self action:@selector(clickOne:)];
//添加一个间隔
UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];//创建系统自带的选项按钮，设置按钮类型为宽度自动改变的空格
//创建另外一个UIBarButtonItem类型的对象
UIBarButtonItem *anotherItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks target:self action:@selector(clickAnother:)];
//创建系统自带的选项按钮，设置按钮类型为电子书类型
self.toolbarItems = @[oneItem,space,anotherItem];
 //------在输入法上面加一行工具栏
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 375, 30)];
    toolBar.barStyle = UIBarStyleBlack;
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneAction:)];
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithTitle:@"主题" style:UIBarButtonItemStylePlain target:self action:@selector(sd)];
    //将按钮放到toolBar上面
    [toolBar setItems:@[left,spaceItem,rightItem]];
    //将toolBar放到textView上面
    [textView setInputAccessoryView:toolBar];
系统自带的选项按钮
UIBarButtonSystemItemDone,
UIBarButtonSystemItemCancel,
UIBarButtonSystemItemEdit,  
UIBarButtonSystemItemSave,  
UIBarButtonSystemItemAdd,
UIBarButtonSystemItemFlexibleSpace,表示宽度可以自动改变的空格，但是不能被点击
UIBarButtonSystemItemFixedSpace,表示固定宽度的空格，需要设置其宽度，例如：itemThree.width = 50;
UIBarButtonSystemItemCompose,
UIBarButtonSystemItemReply,
UIBarButtonSystemItemAction,
UIBarButtonSystemItemOrganize,
UIBarButtonSystemItemBookmarks,
UIBarButtonSystemItemSearch,
UIBarButtonSystemItemRefresh,
UIBarButtonSystemItemStop,
UIBarButtonSystemItemCamera,
UIBarButtonSystemItemTrash,
UIBarButtonSystemItemPlay,
UIBarButtonSystemItemPause,
UIBarButtonSystemItemRewind,
UIBarButtonSystemItemFastForward,
//实际项目中不会使用toolBar功能

//直接用UIView+UIButton实现
//添加导航背景图片
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 20, self.view.bounds.size.width, 44)];
    bgImageView.image = [UIImage imageNamed:@"header_bg.png"];
    [self.view addSubview:bgImageView];


[UITabBarController:UIViewController]标签栏控制器
标签栏的显示效果是在手机屏幕底部有一个标签栏，标签栏上又多个选项按钮    
注：标签栏是属于标签栏控制器的，而标签栏上的选项按钮则是属于标签栏控制器的子视图控制器
我们在为标签栏控制器的标签栏添加选项按钮的时候，一般不会超过五个，如果标签栏上的选项按钮的个数超过了五个，那个标签栏会自动创建more标签，并创建一个导航控制器，然后把超出部分的选项按钮添加到导航控制器中，由导航控制器来进行管理；more标签的索引没有在标签栏控制器的子视图控制器数组中
UITabBarItem *thirdVCItem = [[UITabBarItem alloc]
        initWithTitle:@"third"
                image:[UIImage imageNamed:@"btnShop.png"]
        selectedImage:[[UIImage imageNamed:@"btnShop_on.png"]
 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ]];
thirdVC.tabBarItem.badgeValue=@"2";//右上角的数字
//设置标签栏的背景：
self.tabBar.backgroundImage=[UIImage imageNamed:@"tabBar.png"];
//设置标签栏的背景图片
self.tabBar.barTintColor = [UIColor redColor];
//设置标签栏的背景颜色
self.tabBar.selectedImageTintColor = [UIColor redColor];
//设置标签栏上的选项按钮被选中时候的颜色，可以设置选项按钮在被选中时的标题颜色
self.tabBar.selectionIndicatorImage = [UIImage imageNamed:@"indicator"];
//设置标签栏上的选项按钮被选中时候的指示图
//设置标签栏上的选项按钮的默认选中的两种方式
self.selectedViewController = self.viewControllers[0];
//通过标签栏控制器的子视图数组，设置标签栏上的选项按钮的默认选中
self.selectedIndex =0;
//通过标签栏的选项按钮的索引值，设置标签栏上的选项按钮的默认选中
//循环创建视图控制器
- (void)createNavController
{
    NSArray *titleArray = @[@"专题",@"热榜"];
    NSArray *imageArray = @[@"tabbar_subject",@"tabbar_rank"];
    NSArray *selectImageArray = @[@"tabbar_subject_press",@"tabbar_rank_press"];
    NSArray *ctrlArray = @[@"SubjectViewController",@"RankViewController"];
    NSMutableArray *arr = [NSMutableArray array];
    for (int i=0; i<5; i++) {
        Class rc = NSClassFromString(ctrlArray[i]);//从字符串创建类
        UIViewController *viewCtrl = [[rc alloc] init];
        viewCtrl.tabBarItem.title = titleArray[0];
        viewCtrl.tabBarItem.image = [UIImage imageNamed:imageArray[i]];
        viewCtrl.tabBarItem.selectedImage = [UIImage imageNamed:selectImageArray[i]];
        UINavigationController *navCtrl = [[UINavigationController alloc] initWithRootViewController:viewCtrl];
        [arr addObject:navCtrl];
    }
    self.viewControllers = arr;
}

    NS_CLASS_AVAILABLE_IOS(2_0) @interface UITabBarController : UIViewController <UITabBarDelegate, NSCoding>
    
    @property(nonatomic,copy) NSArray *viewControllers;
    // If the number of view controllers is greater than the number displayable by a tab bar, a "More" navigation controller will automatically be shown.
    // The "More" navigation controller will not be returned by -viewControllers, but it may be returned by -selectedViewController.
    - (void)setViewControllers:(NSArray *)viewControllers animated:(BOOL)animated;
    
    @property(nonatomic,assign) UIViewController *selectedViewController; // This may return the "More" navigation controller if it exists.
    @property(nonatomic) NSUInteger selectedIndex;
    
    @property(nonatomic,readonly) UINavigationController *moreNavigationController; // Returns the "More" navigation controller, creating it if it does not already exist.
    @property(nonatomic,copy) NSArray *customizableViewControllers; // If non-nil, then the "More" view will include an "Edit" button that displays customization UI for the specified controllers. By default, all view controllers are customizable.
    
    @property(nonatomic,readonly) UITabBar *tabBar NS_AVAILABLE_IOS(3_0); // Provided for -[UIActionSheet showFromTabBar:]. Attempting to modify the contents of the tab bar directly will throw an exception.
    
    @property(nonatomic,assign) id<UITabBarControllerDelegate> delegate;
    
    @end

|------[快捷方式]|-----------------------
FOUNDATION_EXPORT NSString *NSStringFromSelector(SEL aSelector);
FOUNDATION_EXPORT SEL NSSelectorFromString(NSString *aSelectorName);
FOUNDATION_EXPORT NSString *NSStringFromClass(Class aClass);
FOUNDATION_EXPORT Class NSClassFromString(NSString *aClassName);
FOUNDATION_EXPORT NSString *NSStringFromProtocol(Protocol *proto);
FOUNDATION_EXPORT Protocol *NSProtocolFromString(NSString *namestr);
|-----------------------------------------

//UISlider:UIControl 滑块,继承与UIControl，也能处理事件
UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake(50, 100, 200, 50)];
slider.minimumValue = 10;//设置最小值
slider.maximumValue = 200;
slider.value = 30;//当前值
[self.view addSubview:slider];
[slider addTarget:self action:@selector(clickSlider:) forControlEvents:UIControlEventValueChanged];
slider.continuous = NO;//是否实时响应事件，默认YES，滑动时响应。设为NO，则滑动停止时响应。

//UISegmentedControl:UIControl
NSArray *arr = @[@"正向传值",@"单例传值",@"代理传值",@"通知中心传值"];
//初始化参数是一个数组，数组里面可以是字符串或者UIImage类型的对象。
UISegmentedControl *mySegmentCtrl = [[UISegmentedControl alloc] initWithItems:arr];
mySegmentCtrl.frame = CGRectMake(50, 200, 300, 50);
//    mySegmentCtrl.segmentedControlStyle;//IOS7可用， iOS8已弃用
[self.view addSubview:mySegmentCtrl];
mySegmentCtrl.selectedSegmentIndex = 0;//设置当前选择值
[mySegmentCtrl addTarget:self action:@selector(clickSegmentCtrl:) forControlEvents:UIControlEventValueChanged];
mySegmentCtrl.apportionsSegmentWidthsByContent = YES;// setting this property to YES attempts to adjust segment widths based on their content widths. Default is NO.根据内容大小调整宽度
NSString *title = [mySegmentCtrl titleForSegmentAtIndex:mySegmentCtrl.selectedSegmentIndex];//取到当前选中项的标题。
NSLog(@"%s\%@",__func__,title);
[mySegmentCtrl insertSegmentWithTitle:title atIndex:[mySegmentCtrl numberOfSegments] animated:YES];
[mySegmentCtrl removeSegmentAtIndex:mySegmentCtrl.selectedSegmentIndex animated:YES];
self.navigationItem.titleView = mySegmentCtrl;

[UISwitch:UIControl 开关]宽度和高度都无法改变
UISwitch *mySwitch = [[UISwitch alloc] initWithFrame:CGRectMake(50, 100, 100, 50)];//宽高是默认值，高度无影响
mySwitch.on = YES;//设置开关状态
mySwitch.isOn? @"YES":@"NO"//判断是否为打开状态
[self.view addSubview:mySwitch];
mySwitch.tintColor = [UIColor redColor];
//参数是mySwitch
[mySwitch addTarget:self action:@selector(clickMySwitch:) forControlEvents:UIControlEventValueChanged];

[UIActivityIndicatorView:UIView运行指示器,活动指示器]
一般用在等待下载数据，或者加载图片的时候，也就是我们在下载东西的时候，我们经常见到的一个会旋转的图标
//活动指示器显示样式
 typedef NS_ENUM(NSInteger, UIActivityIndicatorViewStyle) {
 UIActivityIndicatorViewStyleWhiteLarge,//大图标
 UIActivityIndicatorViewStyleWhite,//小图标
 UIActivityIndicatorViewStyleGray,
 };
UIActivityIndicatorView *myAvtivityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
myAvtivityView.frame = CGRectMake(100, 200, 50, 50);
activityIndicatorView.transform=CGAffineTransformMakeScale(8, 8);
//通过transform属性，将活动指示器的大小设置为原来的八倍
activityIndicatorView.color=[UIColor redColor];
[myAvtivityView startAnimating];//开始运行
myAvtivityView.hidesWhenStopped = NO;// default is YES. calls -setHidden when animating gets set to NO
myAvtivityView.color = [UIColor greenColor];
view.isAnimating? @"YES":@"NO"//判断是否在运行
//UIWebView : UIView
UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.bounds];

NSURL *url = [NSURL URLWithString:@"http://www.baidu.com"];//创建一个NSURL类型的对象
//NSURLRequest : NSObject
NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
[webView loadRequest:request];
// webView loadHTMLString:<#(NSString *)#> baseURL:<#(NSURL *)#>
[self.view addSubview:webView];
+ (void)ReleaseWebView:(UIWebView *)webView{
    [webView stopLoading];
    [webView setDelegate:nil];
     webView = nil;
}
--执行网页跳转-----
NSString *js = [NSString stringWithFormat:@"window.location.href = '#%@';",_html.ID];
[webView stringByEvaluatingJavaScriptFromString:js];
---------
[UIStepper:UIControl]   一个加号一个减号
UIStepper *myStepper = [[UIStepper alloc] initWithFrame:CGRectMake(50, 100, 100, 50)];
myStepper.maximumValue = 300;
myStepper.minimumValue = 0;//设置最小值
myStepper.stepValue = 2;//设置步长。
[self.view addSubview:myStepper];
[myStepper addTarget:self action:@selector(clickStepper:) forControlEvents:UIControlEventValueChanged];
myStepper.autorepeat = NO;// if YES, press & hold repeatedly alters value. default = YES,每次按下只改变一次，不论按下的时间的长短。
[UIProgressView:UIView] 一条直线形式的进度条
UIProgressView *myProgress = [[UIProgressView alloc] initWithFrame:CGRectMake(30, 200, 300, 30)];
myProgress.progress = 0;//设置当前位置，0-1之间的数。
[self.view addSubview:myProgress];
myProgress.tag = 200;

progressView.progressTintColor=[UIColor greenColor];
//设置progressView的已完成进度的颜色
progressView.progressImage=[UIImage imageNamed:@""];
//设置progressView的已完成进度的背景图片
progressView.trackTintColor=[UIColor grayColor];
//设置progressView的未完成进度的颜色
progressView.trackImage=[UIImage imageNamed:@""];
//设置progressView的已完成进度的背景图片
[progressView setProgress:1.0 animated:YES];
//将progressView的进度值设置为1.0，并产生动画

- (void)clickStepper:(UIStepper*)myStepper{
UIProgressView *view = (UIProgressView*)[self.view viewWithTag:200];
view.progress = myStepper.value/myStepper.maximumValue;//进度百分数
NSLog(@"%lf",myStepper.stepValue);
}
[UIActionSheet]创建UIActionSheet弹出按钮
当弹出操作表单以后，对操作表单中的操作按钮进行点击,操作表单就能监听到具体是哪个按钮被点击，并通过调用代理中实现的UIActionSheetDelegate协议中的方法，对操作表单监听到的特定事件进行处理

[<UIAlertViewDelegate,UIActionSheetDelegate>]

initWithTitle:@"操作表单"
//设置操作表单UIActionSheet的标题
delegate:self
//将当前界面设置为操作表单UIActionSheet的代理
cancelButtonTitle:@"取消操作按钮"
//设置操作表单UIActionSheet最底部操作按钮的标题
//一般设置为取消操作
destructiveButtonTitle:@"关键操作按钮"
//这个操作按钮的标题显示为红色，一般用于某些关键操作
//比如要删除某些东西，可以把这个操作设置为destructiveButton
otherButtonTitles:@"普通操作按钮一",
@"普通操作按钮二",
@"普通操作按钮三",
@"普通操作按钮四", nil];
//设置其他操作按钮的标题

    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"分享" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"FaceBook" otherButtonTitles:@"微博",@"QQ", nil];
    [actionSheet showInView:self.view];//将sctionSheet添加到self.view显示
}
[loginSheet showInView:[UIApplication sharedApplication].keyWindow]//将loginSheet添加到UIWindow显示
#pragma mark - UIActionSheetDelegate协议方法
//点击操作表单UIActionSheet上面的操作按钮之后，触发这个函数
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSLog(@"当前操作按钮的索引值：%ld",buttonIndex);
    //打印操作表单中被点击的操作按钮的索引值
    //操作表单的操作按钮索引值，按照从上向下（包括最上方的关键操作按钮以及最下方的取消操作按钮）,索引值从0开始递增，分别为0，1，2，3，4，5
    NSLog(@"当前操作按钮的标题：%@",[actionSheet buttonTitleAtIndex:buttonIndex]); //打印操作表单中被点击的操作按钮的标题
}
//操作表单即将显示的时候，调用当前方法
- (void)willPresentActionSheet:(UIActionSheet *)actionSheet{
    NSLog(@"操作表单即将显示");
}
//操作表单已经显示的时候，调用当前方法
- (void)didPresentActionSheet:(UIActionSheet *)actionSheet{
    NSLog(@"操作表单已经显示");
}
- (void)actionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex{
    NSLog(@"当前被点击操作按钮的标题：%@",[actionSheet buttonTitleAtIndex:buttonIndex]); //打印操作表单中被点击的操作按钮的标题
    NSLog(@"操作表单即将消失");
}
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    NSLog(@"当前被点击操作按钮的标题：%@",[actionSheet buttonTitleAtIndex:buttonIndex]); //打印操作表单中被点击的操作按钮的标题
    NSLog(@"操作表单已经消失");
}

注：UITabbar和UIActionSheet冲突
使用了UITabBar的时候，UIActionSheet最后一个按钮会很难响应。解决方法如下：
1、替换[sheet showInView:self.view];为[sheet showInView:[UIApplication sharedApplication].keyWindow];
2、替换[sheet showInView:self.view];为[sheet showFromTabBar:self.tabBarController.tabBar];

[UIAlertView]弹框；
设置AlertView的风格：
UIAlertViewStyleDefault
默认的风格，有AlertView的标题，提示信息，以及取消按钮和其他按钮
UIAlertViewStylePlainTextInput
当前风格，除了默认风格拥有的信息以外，还包好一个文本输入框
UIAlertViewStyleSecureTextInput
当前风格，除了默认风格拥有的信息以外，还包含一个密码输入框
UIAlertViewStyleLoginAndPasswordInput
当前风格，除了默认风格拥有的信息以外，还包含了一个文本输入框和密码输入框

- (void)clickAlertView:(id)sender{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"请输入用户名" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",@"选择", nil];
	alertView.alertViewStyle = UIAlertViewStyleDefault;//设置AlertView为默认风格
    [alertView show];// shows popup alert animated.将alertView添加到当前界面的视图上，该方法会对alertView对象强引用
}
#pragma mask -UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSLog(@"%ld",buttonIndex);//列出选择的是哪个Button
}
//alertView即将显示的时候，调用该方法
- (void)willPresentAlertView:(UIAlertView *)alertView;
//alertView已经显示的时候，调用该方法
- (void)didPresentAlertView:(UIAlertView *)alertView;
//alertView即将消失的时候，调用该方法
- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex;
//alertView已经消失的时候，调用该方法
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex;
@property CGFloat contentScaleFactor; // returns pixels per point on the screen this view is on.获取每个点占几个像素。
@property CGRect bounds;是在自己的坐标系中绘制自己时的矩形。宽高除以2来取得视图原点
@property CGPoint center;在父视图中的位置，左上角的点坐标
@property CGRect frame;在父视图中包含自己的一个矩形。
You might think frame.size is always equal to bounds.size, but you’d be wrong.Because views can be rotated
绘制自定义的视图create a UIView subclass & override 1 method - (void)drawRect:(CGRect)aRect;NEVER call drawRect:!drawRect是由系统调用的
- (void)setNeedsDisplay;重绘视图
- (void)setNeedsDisplayInRect:(CGRect)aRect;
Core Graphics Concepts绘图流程
Get a context to draw into (iOS will prepare one each time your drawRect: is called) 
Create paths (out of lines, arcs, etc.)
Set colors, fonts, textures, linewidths, linecaps, etc.
Stroke or fill the above-created paths
[UIBezierPath]封装了全部的上述绘图流程
CGContextRef context = UIGraphicsGetCurrentContext();获取当前的上下文，只有调用drawRect时才有效
1.创建UIBezierPath
define a Path:   UIBezierPath *path = [[UIBezierPath alloc] init];
[path moveToPoint:CGPointMake(75, 10)];将起始点移动到（75，10）
[path addLineToPoint:CGPointMake(160, 150)];绘制直线
[path addLineToPoint:CGPointMake(10, 150]);
[path closePath];Close the path (connects the last point back to the first)
Now that the path has been created, we can stroke/fill it Actually, nothing has been drawn yet, we’ve just created the UIBezierPath.以上只是创建了UIBezierPath。
2.设置填充和描边颜色
[[UIColor greenColor] setFill];
[[UIColor redColor] setStroke];
3.发送绘图和描边消息，这时才真正进行绘制
[path fill]; [path s，troke];
------
UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:(CGRect)bounds cornerRadius:(CGFloat)radius];
UIBezierPath *oval = [UIBezierPath bezierPathWithOvalInRect:(CGRect)bounds]; [roundedRect stroke];
[oval fill];
[roundedRect addClip]; // this would clip all drawing to be inside the roundedRect裁剪图形
将UIView的属性opaque设置为NO，表示这个视图不是不透明的，来关闭不透明属性alpha，表示不需要背景色，即时将background设置为nil，背景也依旧不会是透明的，系统也不会对视图背景进行填充。如果想让视图变为透明的，就要把opaque设置为NO，并将背景色设为nil，避免填充背景色。
myView.hidden = YES 和 myView.alpha = 0 结果一样，都是隐藏视图，使之不能进行绘制，也无法获取事件，但它还在视图列表中，hidden=YES比alpha=0要好。
保存当前图形上下文
- (void)drawGreenCircle:(CGContextRef)ctxt {
    CGContextSaveGState(ctxt);//保存
    [[UIColor greenColor] setFill];
// draw my circle
    CGContextRestoreGState(ctxt);//恢复
}
[绘制文本Drawing Text]一般在UILabel中绘制
NSAttributedString *text = ...;
[text drawAtPoint:(CGPoint)p];
CGSize textSize = [text size];
[绘制图像Drawing Images]
获取图像
UIImage *image = [UIImage imageNamed:@“foo.jpg”];
UIImage *image = [[UIImage alloc] initWithContentsOfFile:(NSString *)fullPath];
UIImage *image = [[UIImage alloc] initWithData:(NSData *)imageData];
---
UIGraphicsBeginImageContext(CGSize);
// draw with CGContext functions
UIImage *myImage = UIGraphicsGetImageFromCurrentContext();
UIGraphicsEndImageContext();
---
开始绘制
[image drawAtPoint:(CGPoint)p];
[image drawInRect:(CGRect)r];会缩放图像，以适应所指定的矩形大小
[image drawAsPatternInRect:(CGRect)patRect;会平铺图像，以填满指定的矩形
Aside: You can get a PNG or JPG data representation of UIImage 
NSData *jpgData = UIImageJPEGRepresentation((UIImage *)myImage, (CGFloat)quality);
￼NSData *pngData = UIImagePNGRepresentation((UIImage *)myImage);

@property (nonatomic) UIViewContentMode contentMode;当视图变化时，调用DrawRect重绘整个视图。
UIViewContentMode{Left,Right,Top,Right,BottomLeft,BottomRight,TopLeft,TopRight}
UIViewContentModeScale{ToFill,AspectFill,AspectFit} // bit stretching/shrinking
UIViewContentModeRedraw // it is quite often that this is what you want
UIViewContentModeScaleToFill是默认的，绘制内容会被拉伸
[UIGestureRecognizer]手势识别 
Usually #1 is done by a Controller
Though occasionally a UIView will do it to itself if it just doesn’t make sense without that gesture.
Usually #2 is provided by the UIView itself
But it would not be unreasonable for the Controller to do it.
Or for the Controller to decide it wants to handle a gesture differently than the view does.

- (void)setPannableView:(UIView *)pannableView // maybe this is a setter in a Controller
{
    _pannableView = pannableView;
    UIPanGestureRecognizer *pangr =[[UIPanGestureRecognizer alloc] initWithTarget:pannableView action:@selector(pan:)];初始化手势识别器，target表示手势发生时，由谁来处理
    [pannableView addGestureRecognizer:pangr];将手势识别器添加到视图，
}
Only UIView instances can recognize a gesture (because UIViews handle all touch input).
UIPanGestureRecognizer provides 3 methods来表示手势
- (CGPoint)translationInView:(UIView *)aView;代表从上次重置后的触摸移动距离
- (CGPoint)velocityInView:(UIView *)aView;代表移动速度
- (void)setTranslation:(CGPoint)translation inView:(UIView *)aView;对移动距离进行重置
CGPoint pt = [gesture translationInView:view];获取偏移距离
view.center = CGPointMake(view.center.x + pt.x, view.center.y + pt.y);移动
CGPoint a=[gesture velocityInView:view];获取移动速度
NSLog(@"%f\n%f",a.x,a.y);
[gesture setTranslation:CGPointZero inView:view];//偏移量清零
UIPanGestureRecognizer : UIGestureRecognizer拖动，移动
Also, the base class, UIGestureRecognizer provides this @property: 
@property (readonly) UIGestureRecognizerState state;状态，枚举类型
UIGestureRecognizerStateBegan,表示是一个连续运动的手势，比如拖动或捏合。刚刚开始。
UIGestureRecognizerStateChanged,表示是一个连续运动手势，并且它变化了，即手指移动了。
UIGestureRecognizerStateEnded, 连续手势，手指离开了屏幕
UIGestureRecognizerStateRecognized = UIGestureRecognizerStateEnded 出现于不连续手势的情况，比如点击或滑动。这时不会得到Began/Changed/Ended状态，因为识别出了滑动，识别出了点击。所以连续手势是不会出现Recognied状态
UIGestureRecognizerStateCancelled,UIGestureRecognizerStateFailed,取消状态，例如有电话打进来了，这时手势就断了。
当识别出手势时，后续方法的实现
- (void)pan:(UIPanGestureRecognizer *)recognizer
{
    if ((recognizer.state == UIGestureRecognizerStateChanged) ||
        (recognizer.state == UIGestureRecognizerStateEnded)) {
        CGPoint translation = [recognizer translationInView:self];
// move something in myself (I’m a UIView) by translation.x and translation.y
// for example, if I were a graph and my origin was set by an @property called origin 
		self.origin = CGPointMake(self.origin.x+translation.x, self.origin.y+translation.y); 
		[recognizer setTranslation:CGPointZero inView:self];
	} 
}
//长按手势
UILongPressGestureRecognizer *langGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longAction:)];
[self.view addGestureRecognizer:langGesture];
longPress.minimumPressDuration = 2.0;//设置长按手势最短长按时间，也就是说只有在长按2秒之后，才会触发当前函数
//在长按手势监听到长按事件的时候，会调用当前方法
- (void)LongPress:(UILongPressGestureRecognizer *)longPress{
    //长按手势会触发两次，长按开始触发一次，长按结束触发一次，可根据longPress.state判断
    if (longPress.state == UIGestureRecognizerStateBegan) {
        _imageView.transform = CGAffineTransformScale
                            (_imageView.transform, 0.5, 0.5);
    }
    if (longPress.state == UIGestureRecognizerStateEnded) {
        _imageView.transform = CGAffineTransformScale
                            (_imageView.transform, 2, 2);
    }
}

UIPinchGestureRecognizer捏合
@property CGFloat scale; // note that this is not readonly (can reset each movement) 比例
@property (readonly) CGFloat velocity; // note that this is readonly; scale factor per second速度，比例系数的变化速度，只读
view.transform = CGAffineTransformScale(view.transform, gesture.scale, gesture.scale);//比例变换
gesture.scale = 1;//变换后需将比例系数置1
UIRotationGestureRecognizer旋转手势识别，两指手势，类似捏合，但会旋转手指。会通过弧度告诉旋转的信息
@property CGFloat rotation; // not readonly; in radians弧度
@property (readonly) CGFloat velocity; // readonly; radians per second速度
//第一个参数是原来的transform值
//第二个参数是变化的角度
view.transform = CGAffineTransformRotate(view.transform, gesture.rotation);根据弧度旋转视图。
gesture.rotation = 0;旋转完成后将弧度置0；
UISwipeGestureRecognizer滑动手势，不连续手势之一
This one you “set up” (w/the following) to find certain swipe types, then look for Recognized state 
@property UISwipeGestureRecognizerDirection direction; // what direction swipes you want方向 
@property NSUInteger numberOfTouchesRequired; // two finger swipes? or just one finger? more?所需触控数量，意识是这个滑动手势需要两根手指还是一根手指来完成
#pragma mark - 创建滑动手势
- (void)creatSwipeGesture{
    int num[4] = {  UISwipeGestureRecognizerDirectionRight,
                    UISwipeGestureRecognizerDirectionLeft,
                    UISwipeGestureRecognizerDirectionUp,
                    UISwipeGestureRecognizerDirectionDown  };
    //滑动手势的滑动方向只能设置一个方向，如果想要给图片视图同时设置四个方向上的滑动手势，就需要创建四个滑动手势，并为每一个滑动手势设置一个不同的滑动方向，最后将这四个滑动手势同时添加到同一个图片视图上
    for (int i = 0; i < 4; i++) {
        UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipe:)];
        swipe.direction = num[i];
        [_imageView addGestureRecognizer:swipe];
    }
}
- (void)swipe:(UISwipeGestureRecognizer *)swipe{
    //根据滑动手势的滑动方向的不同，对不同的滑动事件进行处理
    switch (swipe.direction) {
        case UISwipeGestureRecognizerDirectionLeft:
            _imageView.center = CGPointMake(_imageView.center.x-50,_imageView.center.y );
            break;
        case UISwipeGestureRecognizerDirectionRight:
            _imageView.center = CGPointMake(_imageView.center.x+50,_imageView.center.y );
            break;
        case UISwipeGestureRecognizerDirectionUp:
            _imageView.center = CGPointMake(_imageView.center.x,_imageView.center.y-50 );
            break;
        case UISwipeGestureRecognizerDirectionDown:
            _imageView.center = CGPointMake(_imageView.center.x,_imageView.center.y+50 );
            break;
        default:
            break;
    }
}

UITapGestureRecognizer点击手势，不连续手势
Set up (w/the following) then look for Recognized state
@property NSUInteger numberOfTapsRequired; // single tap or double tap or triple tap, etc. 
@property NSUInteger numberOfTouchesRequired; // e.g., require two finger tap?
tapGesture.numberOfTapsRequired = 2;//需要的点击次数，默认单击，1
tapGesture.numberOfTouchesRequired = 2;//two finger
[view addGestureRecognizer:tapGesture];添加手势
注：滑动手势只能识别上下左右四个方向，斜滑动为拖动捏合手势
<UIGestureRecognizerDelegate>//pinch.delegate = self;//将当前界面设置为捏合手势的代理（当需要两个手势，同时存在图片视图的时候，需要设置代理）
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    //如果gestureReconiger手势关联的视图和otherGestureReconizer关联的视图是同一个视图，让这两个手势都能同时响应。
    if ([gestureRecognizer.view isEqual:otherGestureRecognizer.view]) {
        return YES;
    }
    return NO;注意：实际中考虑下不做判断，只返回YES，是否可行。感觉可以
}

[单击和双击 同时 产生,]
//self.gestureRecognizers 获取当前对象所有手势
for (UIGestureRecognizer *gesT in self.gestureRecognizers) {
    if ([gesT isKindOfClass:[UITapGestureRecognizer class]]) {
        //判断单击手势
        if (((UITapGestureRecognizer *)gesT).numberOfTapsRequired == 1){
    	    //当tap手势 失败的时候 gesT 才有效
        	//增加这个函数之后 单击会延迟执行
	        [gesT requireGestureRecognizerToFail:tap];
	        //只有双击失败了单击才有效
	        //如果这里不设置,那么,在双击的时候 单击手势也会生效        
	        break;
		}
    }
}

//当调用这段代码时，字典会重复执行这个代码块。直到stop变为YES；或者遍历结束。注意：块中使用的外部变量是只读的，在局部变量前加上__block前缀可使，变量在块内可修改；static也可达到与__block同样的效果
[aDictionary enumerateKeysAndObjectsUsingBlock:^(id key, id value, BOOL *stop) {
    NSLog(@“value for key %@ is %@”, key, value);
    if ([@“ENOUGH” isEqualToString:key]) {
*stop = YES; }
}];//This NSLog()s every key and value in aDictionary (but stops if the key is “ENOUGH”).

/**
 [UIView Animation]可在视图中随时调用这三个方法实现动画。
 frame
 transform (translation, rotation and scale)
 alpha (opacity)
 
 The class method takes animation parameters and an animation block as arguments.
 The animation block contains the code that makes the changes to the UIView(s).
 Most also have a “completion block” to be executed when the animation is done.
 The changes inside the block are made immediately (even though they will appear “over time”).
 
 @interface UIView(UIViewAnimationWithBlocks)
 *
 + (void)animateWithDuration:(NSTimeInterval)duration//代表这个动画会持续多少时间来执行。
                       delay:(NSTimeInterval)delay//表示等待多长时间再开始执行
                     options:(UIViewAnimationOptions)options
                  animations:(void (^)(void))animations
                  completion:(void (^)(BOOL finished))completion;//动画完成时被调用
 例如：-- 淡出我的视图，如果成功淡出就从顶层视图中移除。
 [UIView animateWithDuration:3.0
                       delay:0.0
                     options:UIViewAnimationOptionBeginFromCurrentState
                  animations:^{ myView.alpha = 0.0; }
                  completion:^(BOOL fin) { if (fin) [myView removeFromSuperview]; }];//如果动画完成，就移除自己。
 例：动画开始时，NSLog()会立即执行，并显示alpha id 0。而不是等到5秒后才执行
 
 if (myView.alpha == 1.0) {
 [UIView animateWithDuration:3.0
 delay:2.0
 options:UIViewAnimationOptionBeginFromCurrentState
 animations:^{ myView.alpha = 0.0; }
 completion:nil];
 NSLog(@“alpha is %f.”, myView.alpha);
 }

typedef NS_OPTIONS(NSUInteger, UIViewAnimationOptions) {
    UIViewAnimationOptionLayoutSubviews            = 1 <<  0,
    UIViewAnimationOptionAllowUserInteraction      = 1 <<  1, // turn on user interaction while animating
    UIViewAnimationOptionBeginFromCurrentState     = 1 <<  2, // start all views from current value, not initial value,如果还有一个正在执行的动画，动画的对象与我想要的是同一个。那么执行我的动画时，从它们的当前状态开始。用于拦截动画。通常是开启的。
    UIViewAnimationOptionRepeat                    = 1 <<  3, // repeat animation indefinitely
    UIViewAnimationOptionAutoreverse               = 1 <<  4, // if repeat, run animation back and forth
    UIViewAnimationOptionOverrideInheritedDuration = 1 <<  5, // ignore nested duration
    UIViewAnimationOptionOverrideInheritedCurve    = 1 <<  6, // ignore nested curve
  //  UIViewAnimationOptionAllowAnimatedContent      = 1 <<  7, // animate contents (applies to transitions only)
    UIViewAnimationOptionShowHideTransitionViews   = 1 <<  8, // flip to/from hidden state instead of adding/removing 使用hidden属性
    UIViewAnimationOptionOverrideInheritedOptions  = 1 <<  9, // do not inherit any options or animation type
    
    UIViewAnimationOptionCurveEaseInOut            = 0 << 16, // default
    UIViewAnimationOptionCurveEaseIn               = 1 << 16,//使得移动更平缓，平移动画
    UIViewAnimationOptionCurveEaseOut              = 2 << 16,
    UIViewAnimationOptionCurveLinear               = 3 << 16,
    
    UIViewAnimationOptionTransitionNone            = 0 << 20, // default//翻转动画
    UIViewAnimationOptionTransitionFlipFromLeft    = 1 << 20,
    UIViewAnimationOptionTransitionFlipFromRight   = 2 << 20,
    UIViewAnimationOptionTransitionCurlUp          = 3 << 20,
    UIViewAnimationOptionTransitionCurlDown        = 4 << 20,
    UIViewAnimationOptionTransitionCrossDissolve   = 5 << 20,
    UIViewAnimationOptionTransitionFlipFromTop     = 6 << 20,
    UIViewAnimationOptionTransitionFlipFromBottom  = 7 << 20,
} NS_ENUM_AVAILABLE_IOS(4_0);

 + (void)animateWithDuration:(NSTimeInterval)duration
                  animations:(void (^)(void))animations
                  completion:(void (^)(BOOL finished))completion NS_AVAILABLE_IOS(4_0); // delay = 0.0, options = 0
 
 + (void)animateWithDuration:(NSTimeInterval)duration
                  animations:(void (^)(void))animations NS_AVAILABLE_IOS(4_0); // delay = 0.0, options = 0, completion = NULL
 
 * Performs `animations` using a timing curve described by the motion of a spring. When `dampingRatio` is 1, the animation will smoothly decelerate to its final model values without oscillating. Damping ratios less than 1 will oscillate more and more before coming to a complete stop. You can use the initial spring velocity to specify how fast the object at the end of the simulated spring was moving before it was attached. It's a unit coordinate system, where 1 is defined as travelling the total animation distance in a second. So if you're changing an object's position by 200pt in this animation, and you want the animation to behave as if the object was moving at 100pt/s before the animation started, you'd pass 0.5. You'll typically want to pass 0 for the velocity. *

+ (void)animateWithDuration:(NSTimeInterval)duration
                      delay:(NSTimeInterval)delay
     usingSpringWithDamping:(CGFloat)dampingRatio
      initialSpringVelocity:(CGFloat)velocity
                    options:(UIViewAnimationOptions)options
                 animations:(void (^)(void))animations
                 completion:(void (^)(BOOL finished))completion NS_AVAILABLE_IOS(7_0);
//翻转等状态切换
+ (void)transitionWithView:(UIView *)view//目标视图
                  duration:(NSTimeInterval)duration//
                   options:(UIViewAnimationOptions)options
                animations:(void (^)(void))animations
                completion:(void (^)(BOOL finished))completion NS_AVAILABLE_IOS(4_0);
//从一个视图转换成另一个视图。
+ (void)transitionFromView:(UIView *)fromView
                    toView:(UIView *)toView
                  duration:(NSTimeInterval)duration
                   options:(UIViewAnimationOptions)options
                completion:(void (^)(BOOL finished))completion NS_AVAILABLE_IOS(4_0); // toView added to fromView.superview, fromView removed from its superview

* Performs the requested system-provided animation on one or more views. Specify addtional animations in the parallelAnimations block. These additional animations will run alongside the system animation with the same timing and duration that the system animation defines/inherits. Additional animations should not modify properties of the view on which the system animation is being performed. Not all system animations honor all available options.
 *
+ (void)performSystemAnimation:(UISystemAnimation)animation onViews:(NSArray *)views options:(UIViewAnimationOptions)options animations:(void (^)(void))parallelAnimations completion:(void (^)(BOOL finished))completion NS_AVAILABLE_IOS(7_0);

@end
 
 //用UIImageView显示多张图片
 //创建一个数组，存储多个UIImage对象
 NSMutableArray *imageArray=[NSMutableArray array];
 //添加UIImage对象。
 for (int i=1; i<13; i++) {
 NSString *imageName=[NSString stringWithFormat:@"player%d.png",i];
 UIImage *image=[UIImage imageNamed:imageName];//存储缓存，并根据分辨率自
 动匹配对应图片
 [imageArray addObject:image];
 }
 //创建一个UIImageView类型对象
 UIImageView *playerImageView=[[UIImageView alloc] initWithFrame:CGRectMake(100, 300, 40, 40)];
 playerImageView.animationImages = imageArray;//设置动画数组，数组中存储有要>连续显示的图片集
 playerImageView.animationDuration = 1; //设置动画时间,单位是秒
 [imageView addSubview:playerImageView];
 [playerImageView startAnimating];//执行动画
 //添加手势
 //UIGestureRecognizer
 //UITapGestureRecognizer:UIGestureRecognizer 表示点击的手势
 //第一个参数表示点击手势发生后会调用这个对象的方法
 //第二个参数表示点击手势发生后会调用这个方法
 //选择器调用的方法的参数就是tagGersture对象
 UITapGestureRecognizer *tagGersture=[[UITapGestureRecognizer alloc]
 initWithTarget:self
 action:@selector(tapAction:)];
 [imageView addGestureRecognizer:tagGersture];//将手势添加到视图上
 imageView.userInteractionEnabled = YES;//开启用户的交互。UIImageView默认关闭
 了用户的交互，需要我们手动开启。
 playerImageView.tag=111;
 }
 - (void)tapAction:(UITapGestureRecognizer *)g{//手势，实现上面的点击操作
 NSLog(@"%s",__func__);
 UIImageView *imageView=(UIImageView *)g.view;
 //取到
 //- (UIView *)viewWithTag:(NSInteger)tag;     // recursive search. includes self
 UIImageView *playerImageView=(UIImageView *)[imageView viewWithTag:111];
 //如果在执行动画，就停止；如果停止了就重新开始动画。
 **
 - (void)startAnimating;
 - (void)stopAnimating;
 - (BOOL)isAnimating;
 *
if ([playerImageView isAnimating]) {
    [playerImageView stopAnimating];
}else{
    [playerImageView startAnimating];
}
}
//CALayer（Core Animation Layer）
//UIView都有一个layer属性，是CALayer类型
UIView *view=[[UIView alloc] init];
[self.view addSubview:view];
view.layer.frame=CGRectMake(30, 100, 100, 50);
view.layer.backgroundColor=[UIColor redColor].CGColor; //与view的backgroundColor类型不同，@property CGColorRef backgroundColor;

view.layer.cornerRadius = 5;//设置圆角
 view.layer.borderColor = [UIColor blueColor].CGColor;//设置边框
 view.layer.borderWidth = 3;
 //设置bounds
 view.layer.bounds=CGRectMake(0, 0, 200, 100);
 view.layer.position=CGPointMake(0,0 );//位置.类似view的center， 都是中心点
 
 //创建一个CALayer //图层，层次
 CALayer *layer = [CALayer layer];
 layer.frame=CGRectMake(20, 30, 100, 30);
 layer.backgroundColor=[UIColor blueColor].CGColor;
 //添加到self.views上。
 [self.view.layer addSublayer:layer];
 
 //创建按钮，点击后用UIView来实现动画
 - (void)animateAction1:(id)sender{
 //第一个参数表示动画的时间，单位是秒
 //第二个参数block，实现动画操作
 //第三个参数表示动画结束之后的操作
 [UIView animateWithDuration:0.1 animations:^{
 [self changeTwoView];
 } completion:^(BOOL finished) {
 
 }];
 }
 //创建按钮，另一种方式实现动画
 - (void)animateAction2:(id)sender{
 //@"animation2"动画的名字
 [UIView beginAnimations:@"animation2" context:nil];
 UIView *view1=[self.view viewWithTag:100];
 //UIViewAnimationTransitionCurlDown 动画的方式，
 //对view1使用动画
 //不缓存
 [UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:view1 cache:NO];
 
 //表示动画的方式
 [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
 //设置时间
 [UIView setAnimationDuration:1];
 //设置重复次数
 [UIView setAnimationRepeatCount:3];
 
 //动画的操作
 [self changeTwoView];
 
 //提交动画
 [UIView commitAnimations];
 }
 //创建按钮，点击后用CATransition实现动画
 - (void)animateAction3:(id)sender{
 CATransition *transition = [CATransition animation];
 //设置切换动画类型
 //transition.type = kCATransitionReveal;
 transition.type = @"cameraIrisHollowOpen";
 //设置动画子类型
 transition.subtype = kCATransitionFromLeft;
 //设置shijian
 transition.duration = 1.0;
 [self changeTwoView];
 [self.view.layer addAnimation:transition forKey:nil];
 }
animation.type = @"cube"; //设置转场动画的类型：
 全局变量的形式
 kCATransitionFade    交叉淡化过渡
 kCATransitionMoveIn  新视图移到旧视图上面
 kCATransitionPush    新视图把旧视图推出去
 kCATransitionReveal  将旧视图移开,显示下面的新视图
 字符串形式
 @"fade"            交叉淡化过渡
 @"moveIn"          新视图移到旧视图上面
 @"push"            新视图把旧视图推出去
 @"reveal"          将旧视图移开,显示下面的新视图
 @"pageCurl"        向上翻一页
 @"pageUnCurl"      向下翻一页
 @"rippleEffect"    滴水效果
 @"suckEffect"      收缩效果，如一块布被抽走
 @"cube"            立方体效果
 @"oglFlip"         翻转效果
animation.subtype = @"fromRight";//设置动画的方向，其动画方向有四种：
全局变量形式
kCATransitionFromRight
kCATransitionFromLeft
kCATransitionFromTop
kCATransitionFromBottom
字符串形式
@"fromLeft"
@"fromRight"
@"fromTop"
@"fromBottom"
animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
设置动画的播放节奏：
kCAMediaTimingFunctionLinear          匀速播放
kCAMediaTimingFunctionEaseIn          先慢后快
kCAMediaTimingFunctionEaseOut         先快后慢
kCAMediaTimingFunctionEaseInEaseOut   先慢中间快后慢
kCAMediaTimingFunctionDefault         默认
animation.duration = 3; //设置动画的播放时间

[self.navigationController.view.layer addAnimation:animation forKey:nil];
//把转场动画的对象加到导航控制器的视图的layer层,在完成转场动画之后，转场动画的对象会自动删除
[self.navigationController pushViewController:subNavigation animated:YES];
//导航控制器的push动画和转场动画不是同一个动画

//创建按钮，点击后用CABasicAnimation实现动画
 - (void)animateAction4:(id)sender{
 //frame
 //transform
 CABasicAnimation *basicAnimation = [CABasicAnimation animationWithKeyPath:@"position"];//表示这个动画是修改对象的position属性
 //取到view1
 UIView *view=[self.view viewWithTag:100];
 //获取view1的位置
 CGPoint oldPos = view.layer.position;
 //设置position初始值
 basicAnimation.fromValue = [NSValue valueWithCGPoint:oldPos];
 //设置动画的position结束值
 basicAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(20,500)];
 //设置时间
 basicAnimation.duration = 1;
 //添加动画
 [view.layer addAnimation:basicAnimation forKey:nil];
 
 view.layer.position = CGPointMake(100, 600);
 }
 1.动画的type值
 1）@"cube"             立方体效果
 2）@"suckEffect"       收缩效果，如一块布被抽走
 3）@"oglFlip"          上下翻转效果
 4）@"rippleEffect"     滴水效果
 5）@"pageCurl"         向上翻一页
 6）@"pageUnCurl"       向下翻一页
 7）@"rotate"           旋转效果
 8）@"cameraIrisHollowOpen"   相机镜头打开效果(不支持过渡方向)
 9）@"cameraIrisHollowClose"  相机镜头关上效果(不支持过渡方向)
 
 2.当type为@"rotate"(旋转)的时候,它也有几个对应的subtype,分别为:
 1）90cw    逆时针旋转90°
 2）90ccw   顺时针旋转90°
 3）180cw   逆时针旋转180°
 4）180ccw  顺时针旋转180°
 
 
 [dynamic animation] 动力动画；定义一些物理效果，如重力、碰撞、作用力等。动画会一直运行，直到力量平衡
 
 Create a UIDynamicAnimator创建一个动力动画
 UIDynamicAnimator *animator = [[UIDynamicAnimator alloc] initWithReferenceView:aView];//如果动画作用的是视图，需要指定它的顶级视图
 Create and add UIDynamicBehaviors给这个动力动画增加行为
 e.g., UIGravityBehavior *gravity = [[UIGravityBehavior alloc] init];//重力
        [animator addBehavior:gravity];
 e.g., UICollisionBehavior *collider = [[UICollisionBehavior alloc] init]; //碰撞
        [animator addBehavior:collider];
 Add UIDynamicItems to a UIDynamicBehavior然后将动力项添加到动力行为中
 id <UIDynamicItem> item1 = ...; 动力项是一个id，实现了UIDynamicItem协议
 id <UIDynamicItem> item2 = ...; 
 [gravity addItem:item1]; 
 [collider addItem:item1]; 
 [gravity addItem:item2];
 The items have to implement the UIDynamicItem protocol ...UIDynamicItem协议中的内容
 @protocol UIDynamicItem
 @property (readonly) CGRect bounds;
 @property (readwrite) CGPoint center;
 @property (readwrite) CGAffineTransform transform; @end
 UIView implements this @protocol.
 If you change center or transform while animator is running, you must call UIDynamicAnimator’s - (void)updateItemUsingCurrentState:(id <UIDynamicItem>)item;//例如移动过程中加上旋转时，要调用这个方法更新属性值。
 [Behavior]动力行为
 UIGravityBehavior重力
 @property CGFloat angle;//重力方向默认是向下的，可以设置为不同方向
 @property CGFloat magnitude; // 1.0 is 1000 points/s/s（这里的1000 相当于9.8m/s^2）重力加速度大小
 UICollisionBehavior碰撞
 @property UICollisionBehaviorMode collisionMode; // Items, Boundaries, Everything (default)动力项，是互相碰撞弹开，还是只从边界碰撞弹开。
 - (void)addBoundaryWithIdentifier:(NSString *)identifier forPath:(UIBezierPath *)path; 
 @property BOOL translatesReferenceBoundsIntoBoundary;//设为YES，将参考视图的边界设置为有弹性的边界。
 UIAttachmentBehavior吸附行为，可以将一个动力项，吸附到一个固定描点或另一个动力项上。要注意的是，将一个动力项吸附到一个描点上，并不意味着这个动力项就不会移动了。因为吸附xingw只是将两个对象连接起来，描点和动力项并没有吸附到背景上。
 - (instancetype)initWithItem:(id <UIDynamicItem>)item attachedToAnchor:(CGPoint)anchor;
 - (instancetype)initWithItem:(id <UIDynamicItem>)i1 attachedToItem:(id <UIDynamicItem>)i2; 
 - (instancetype)initWithItem:(id <UIDynamicItem>)item offsetFromCenter:(CGPoint)offset ... 
 @property (readwrite) CGFloat length; // distance between attached things (settable!)两个动力项之间的长度是可写的。例如捏合缩放会改变他们之间的距离。注：这个连接就像是弹簧，移动一个时，另一个会弹起来，可以设置它的阻尼大小和振荡频率。
 Can also control damping and frequency of oscillations.
 @property (readwrite) CGPoint anchorPoint; // can be reset at any time描点也可以随时重新设置。
 UISnapBehavior速甩行为，将一个动力项甩到一个位置，不只是让它飞过去，到达目标位置后，可以想象成动力项四角有四个弹簧，动力项到达目标位置时会来回振动，可以指定振动的大小，目的是给用户一个反馈。
 - (instancetype)initWithItem:(id <UIDynamicItem>)item snapToPoint:(CGPoint)point;
 Imagine four springs at four corners around the item in the new spot.
 You can control the damping of these “four springs” with @property CGFloat damping;.
 UIPushBehavior推动行为
 @property UIPushBehaviorMode mode; // Continuous or Instantaneous
 @property CGVector pushDirection;
 @property CGFloat magnitude/angle; // magnitude 1.0 moves a 100x100 view at 100 pts/s/s指定推力大小和角度等。
 
 UIDynamicItemBehavior动力项行为。动力项自身的属性。与行为无关，
 Controls the behavior of items as they are affected by other behaviors. Any item added to this behavior (with addItem:) will be affected. 
 @property BOOL allowsRotation;旋转
 @property BOOL friction;摩擦力
 @property BOOL elasticity;弹力
 @property CGFloat density;密度
 Can also get information about items by UIDynamicItemBehavior.
 - (CGPoint)linearVelocityForItem:(id <UIDynamicItem>)item;返回动力项在不同方向上的速度。在接管动画时很好用。
 - (CGFloat)angularVelocityForItem:(id <UIDynamicItem>)item;同上，，，角速度
 If you have multiple UIDynamicItemBehaviors, you will have to know what you are doing.
 
 UIDynamicBehavior动力行为，是重力行为，碰撞行为等得基类，可以创建子类
 Superclass of behaviors.
 You can create your own subclass which is a combination of other behaviors. Usually you override init method(s) and addItem(s): and removeItem(s): to do ... - 
 (void)addChildBehavior:(UIDynamicBehavior *)behavior;添加子行为。
 This is a good way to encapsulate a physics behavior that is a composite of other behaviors. You might also have some API which helps your subclass configure its children.
 All behaviors know the UIDynamicAnimator they are part of They can only be part of one at a time.所有的动力行为都知道自己所在的动力动画者是什么。
 @property UIDynamicAnimator *dynamicAnimator;返回它们所在的动力动画者的信息。
 And the behavior will be sent this message when its animator changes ...
 - (void)willMoveToAnimator:(UIDynamicAnimator *)animator;当行为移动到动画者中，或者从动画者中移除时，会调用这个方法，类似于视图视图控制器生命周期
 
 UIDynamicBehavior’s action property
 Every time the behavior is applied, the block set with this UIDynamicBehavior property is called ... 
 @property (copy) void (^action)(void);//每次动力行为执行时，都会调用这个block，例如重力行为发生时，即使每次移动一秒也会调用。注：不要在action中执行资源消耗多大的操作。
 ￼(i.e. it’s called action, it takes no arguments and returns nothing) You can set this to do anything you want.
 But it will be called a lot, so make it very efficient.
 If the action refers to properties in the behavior itself, watch out for memory cycles.
 */
//将字符串转成选择器方法名。
UIButton *btn = [lTool createButtonTitle:arr[i] image:nil backgroundImage:nil target:self action:(NSSelectorFromString([NSString stringWithFormat:@"clickAction%d:",i])) frame:CGRectMake(150, 80+i*60, 100, 50)];
//从给定的大图中切出指定矩形区域的小图
- (UIImage *)clipImage:(UIImage *)bigImage inRect:(CGRect)rect{
    CGImageRef imageRef = CGImageCreateWithImageInRect(bigImage.CGImage, rect);
    UIImage *image = [UIImage imageWithCGImage:imageRef];
    return image;
}

//下面的方法 是取消 一个perform 的 的执行
//取消 self.target self.action 的perform,一旦取消之后就不再执行
[NSObject cancelPreviousPerformRequestsWithTarget:self.target selector:self.action object:self];

[UITouch]
//UITouch对象描述手指在手机屏幕上各种不同类型的Touch事件。
//UITouch对象的属性：访问发生UITouch的视图或窗口，及获取Touch事件所在的视图或窗口的Touch事件的坐标/Touch事件发生的时间、Touch事件的点击次数、手Touch事件过程当中指是否滑动以及滑动方向
//Touch事件的阶段（是否开始，是否移动，是否结束，是否取消）
//一个UITouch对象是整个多点触摸序列的持续性，处理事件时不能retain一个UITouch对象；如果你需要记录Touch事件从一个阶段到另一个阶段的信息，应当使用copy来记录UItTouch对象的信息。
[注意：]
//1.视图对触摸事件是否需要作出回应可以通过设置视图的userInteractionEnabled属性来进行控制，如果设置为NO，可以阻止视图接收和分发触摸事件；如果设置为YES，则表示打开视图接受和分发触摸时间
//2.当视图被隐藏（hidden=YES）或者透明（alpha=0),那么视图也不会接受Touch事件
//3.如果要让视图接收多点触摸，需要设置它的multipleTouchEnabled属性为YES,默认状态下这个属性值为NO，即视图默认不接收多点触摸
typedef NS_ENUM(NSInteger, UITouchPhase) {Touch事件开始
    UITouchPhaseBegan,        // whenever a finger touches the surface.
    UITouchPhaseMoved,        // moves on the surface.
    UITouchPhaseStationary,   // whenever a finger is touching the surface but hasn't moved since the previous event.
    UITouchPhaseEnded,         // whenever a finger leaves the surface.
    UITouchPhaseCancelled,     // whenever a touch doesn't end but we need to stop tracking (e.g. putting device to face)例如来电话了。
};
UIWindow * window=touch.window;//获取Touch事件发生时所处的window
UIView * view=touch.view;    //获取Touch事件发生时所处的视图
NSUInteger tapCount=touch.tapCount;    //获取Touch事件的点击次数
NSTimeInterval timeInterval=touch.timestamp;    //获取Touch事件的时间戳，这样可以计算一些点击的频率等，单位是：秒
NSArray * gestureArray=touch.gestureRecognizers;    //获取Touch事件的手势集合，并返回一个手势数组
#pragma mark - 与UITouch相关的UIResponder方法
//以下四个方法是UIResponder的方法，因为UITouch的对象是视图，而视图类UIView继承自UIRespnder类，所以如果要对Touch事件作出处理，就需要重写UIResponder类中定义的事件处理方法,根据不同种类的Touch触摸事件，对应的视图会调用相应的处理函数。
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{    
    UITouch *touch = [touches anyObject];//获取Touch事件的UITouch对象
    CGPoint touchPoint = [touch locationInView:self.view];
    //获取Touch事件，在某个视图中的发生位置
    if (CGRectContainsPoint(_imageView.frame, touchPoint)) {
        //如果当前Touch事件的发生位置在图片视图内部，
        _isImageViewPoint = YES;
    }
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    if (_isImageViewPoint) {
        UITouch *touch = [touches anyObject];
        CGPoint touchPoint = [touch locationInView:self.view];
        //获取Touch事件移动后，当前点的坐标
        CGPoint prePoint = [touch previousLocationInView:self.view];
        //获取Touch事件移动后，前一个点的坐标
        CGFloat offsetX = touchPoint.x-prePoint.x;
        CGFloat offsetY = touchPoint.y-prePoint.y;
        //根据Touch事件移动前后两点的坐标，求出Touch事件的移动偏移量
        CGPoint center = _imageView.center;
        //获取图片视图中心点的坐标
        _imageView.center = CGPointMake(center.x+offsetX, center.y+offsetY);
        //使图片视图的偏移量与Touch事件的偏移量保持一致，从而产生图片视图随着Touch事件的移动而移动的效果
    }
}
//手指离开屏幕的时候，会调用这个方法
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    //在Touch事件结束的时候，使用UIView的类方法，产生一个0.3秒的移动动画，
    [UIView animateWithDuration:0.3 animations:^{
        _imageView.center = CGPointMake(160, 240);
        //注意：这里的移动过程仅仅是动画效果，不是真正的图片视图缓慢移动的过程，而真正的图片视图已经早早的移动到了Touch事件的发生位置
        _isImageViewPoint=NO;
        //在Touch事件结束的时候，将该BOOL参数重新置为NO；
    } completion:nil];
}
//取消Touch事件的时候，会调用这个方法
//Touch事件的取消，一般由系统调用，例如：电话来了，点击手机的HOME键，手机锁屏
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
}

NSString *path = [[NSBundle mainBundle] pathForResource:@"3" ofType:@"png"];
//    UIImage *image = [UIImage imageWithContentsOfFile:path];
UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:path]];
[UIScrollView : UIView]滚动视图
//将UIScrollView对象放在导航控制器中，iOS7之后，会自动调整滚动视图的边界，所以要取消这个设置。
self.automaticallyAdjustsScrollViewInsets = NO;//所有UIScrollView的子类都需设置该属性
_scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(30, 80, 300, 300)];
_scrollView.backgroundColor = [UIColor redColor];
[_scrollView addSubview:imageView];
[self.view addSubview: _scrollView];
[imageView sizeToFit];
//设置滚动范围，代表滚动视图要滚动的区域，contentSize的大小比滚动视图本身的frame的大小要大，否则没有滚动效果
//scrollView.contentSize = CGSizeMake(image.size.width, image.size.height);
_scrollView.contentSize = imageView.bounds.size;
[scrollView scrollRectToVisible:CGRectMake(500, 0, 300, 300) animated:YES];//程序方法，重新设置
_scrollView.indicatorStyle = UIScrollViewIndicatorStyleBlack;
//设置滚动视图的滚动条的风格
_scrollView.showsHorizontalScrollIndicator = NO;//取消左右滚动条
注意：当未取消显示滚动条时，缩放操作会失败
_scrollView.showsVerticalScrollIndicator = NO;//取消上下滚动条
scrollView.bounces = NO;//禁止回弹效果
//设置滚动视图是否可以在所有方向上回弹，优先级比下边两个优先级高
_scrollView.alwaysBounceHorizontal = YES;
//设置滚动视图是否可以在水平方向上回弹，
_scrollView.alwaysBounceVertical = YES;
//设置滚动视图是否可以在垂直方向上回弹，
//    scrollView.contentScaleFactor = YES;
scrollView.contentOffset = CGPointMake(50, 50);//设置开始时的偏移量
//设置缩放倍数
_scrollView.minimumZoomScale = 0.2;
_scrollView.maximumZoomScale = 6;
_scrollView.delegate = self;//遵守协议，缩放
#pragma mark - UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return [scrollView.subviews lastObject];
}
//分页显示
_scrollView.pagingEnabled = YES;
UIButton *btn3 = [self createBtnFrame:CGRectMake(260, 250, 100, 50) title:@"去去" target:self action:@selector(clickAction:)];
[self.view addSubview:btn3];

/**
 @property (nonatomic) float zoomScale; !
 - (void)setZoomScale:(float)scale animated:(BOOL)animated; ! - (void)zoomToRect:(CGRect)zoomRect animated:(BOOL)animated;
 */

#pragma mark - 滚动视图协议方法
//将要开始拖拽的时候调用(手指开始拖拽屏幕的时候)(开始滚动的时候)
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView;
//滚动视图在滚动的过程当中，一直在调用当前方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
//将要停止拖拽的时候调用
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset;
//已经停止拖拽的时候（手指离开滚动视图的时候），调用该协议方法
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;
//在停止拖拽滚动视图的时候，滚动视图会有一段减速的过程，
//将要开始减速的时候（手指离开屏幕），调用该协议方法
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView;
//减速停止的时候的时候，调用该协议方法
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView;
//设置滚动视图的子视图是否可以进行缩放
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return scrollView.subviews[0];
    //通过视图的子视图数组得到_imageView，设置该子视图可以缩放
}
//滚动视图即将开始缩放的时候，调用该协议方法
- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view;
//滚动视图在缩放的过程当中，调用该协议方法
- (void)scrollViewDidZoom:(UIScrollView *)scrollView;
//滚动视图缩放结束的时候，调用该协议方法
- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale;
//如果滚动视图的scrollsToTop属性设置为YES，那么在点击状态栏，滚动视图将要开始滚动到顶部的时候，调用该协议方法;如果该方法返回值为YES，则可以滚动到顶部，如果返回值为NO，则不可以滚动到顶部
//如果滚动视图的scrollsToTop属性设置为NO，该方法将会失效
- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView{
    return YES;
}
//点击手机状态栏，并且在滚动视图滚动到顶部的时候，调用该协议方法
- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView;

滚动视图UIScrollView的应用
1.循环相册（照片循环滚动）
思路：将要显示的最后一个图片在第一个图片之前增加一个，在最后一个图片后面增加一个第一张图片，在contentOffSize改变到相应的照片的时候，瞬间移动contentOffSize
2.照片墙（照片九宫格排列）
3.分页滚动+分页控制器

//UIPageControl : UIControl
_pageCtrl = [[UIPageControl alloc] initWithFrame:CGRectMake(30, 80 + kScrollViewHeigth - 30, kScrollViewWidth, 30)];
[self.view addSubview:_pageCtrl];
_pageCtrl.backgroundColor = [UIColor clearColor];
//设置一共多少页
_pageCtrl.numberOfPages = 3;
//设置当前页
_pageCtrl.currentPage = 0;
// _pageCtrl.userInteractionEnabled = NO;//设置pagecontroller不响应点击操作
[_pageCtrl addTarget:self action:@selector(pageAction:) forControlEvents:UIControlEventValueChanged];
[_scrollView setContentOffset:CGPointMake(kScrollViewWidth*_curIndex, 0) animated:YES];

我们建议采纳的安全模式是这样的：从主线程中提取出要使用到的数据，并利用一个操作队列在后台处理相关的数据，最后回到主队列中来发送你在后台队列中得到的结果。使用这种方式，你不需要自己做任何锁操作，这也就大大减少了犯错误的几率。

Apple 使用了最多三个加/解锁序列，还有一部分原因是他们也添加了异常开解(exception unwinding)机制。相比于更快的自旋锁方式，这种实现要慢得多。由于设置某个属性一般来说会相当快，因此自旋锁更适合用来完成这项工作。@synchonized(self) 更适合使用在你 需要确保在发生错误时代码不会死锁，而是抛出异常的时候。

[Multithreading]多线程
[GCD /Grand Central Dispatch]是一套底层API，提供了一种新的方式来进行并发程序开发。从基本功能上讲，GCD有点像NSOperationQueue，他们都允许程序将任务切分成多个单一任务然后提交到工作队列来并发或串行的执行。GCD比之NSOperationQueue更底层更高效，它并不是Cocoa框架的一部分。
--[Main Queue]在主队列中处理多点触控以及所有UI操作等。原因有两点，1.绝不能让他阻塞(One is that we never want to block it)，不会将执行很长时间的任务放在主队列上。2.将其用于同步(use it for synchronization)，所有UI相关内容的同步；UIKit中的大部分方法，只能在主线程中调用他们，and in fact, if you call them on some other, some block that came off from some other queue probably wouldn't work. Now there's a few, like UIImage, UIFont, UIColor a couple of those things, they'll work off the main queue, but anything that is going to cause the screen to have to change or synchronize or anything like that, or that might cause that, that all needs to happen on the main queue. so we use that main queue, both to have something that's constantly responsive to the user and for synchronization, to keep everything in sync of what's going on in the UI side. Everything else wo could do in other queues.
 
Executing a block on another queue!
dispatch_queue_t queue = ...;声明一个队列
dispatch_async(queue, ^{ });基本的C函数，表示将这个block以异步的方法放入这个队列中。
系统会缺省为每个应用提供一个串行队列和四个并发队列。其中 main dispatch queue（主派发队列）是全局可用的串行队列，在应用的主线程中执行任务。这个队列被用来更新 App 的 UI，执行所有与更新 UIViews 相关的任务。该队列中同一时刻只执行一个任务，这就是为什么当你在主队列中运行一个繁重的任务时UI会被阻塞的原因。

除主队列之外，系统还提供了4个"并发"队列。我们管它们叫 Global Dispatch queues（全局派发队列）。这些队列对整个应用来说是全局可用的，彼此只有优先级高低的区别。要使用其中一个全局并发队列的话，你得使用 dispatch_get_global_queue 函数获得一个你想要的队列的引用，该函数的第一个参数取如下值：

    DISPATCH_QUEUE_PRIORITY_HIGH
    DISPATCH_QUEUE_PRIORITY_DEFAULT
    DISPATCH_QUEUE_PRIORITY_LOW
    DISPATCH_QUEUE_PRIORITY_BACKGROUND

这些队列类型代表着执行优先级。带有 HIGH 的队列有最高优先级，BACKGROUND 则是最低的优先级。这样你就能基于任务的优先级来决定要用哪一个队列。还要注意这些队列也被 Apple 的 API 所使用，所以这些队列中并不只有你自己的任务。

最后，你可以创建任何数量的串行或并发队列。使用并发队列的情况下，即使你可以自己创建，我还是强烈建议你使用上面那四个全局队列。
 
Getting the main queue!
dispatch_queue_t mainQ = dispatch_get_main_queue();返回主队列
NSOperationQueue *mainQ = [NSOperationQueue mainQueue]; // for object-oriented APIs
 
Creating a queue (not the main queue)!
dispatch_queue_t otherQ = dispatch_queue_create(“name”, NULL); //name 是队列名称，notice that's not an NSString, name a const char *! And then the second argument is whether it's a serial串行队列 queue (NULL), or a concurrent并发队列 queue.

1. 主线程所在的串行队列
dispatch_queue_t main_queue = dispatch_get_main_queue();
2. 全局队列，并行执行；是并发队列，并由整个线程共享。进程中存在四个全局队列：高、中(默认)、低三个优先级队列。
#define DISPATCH_QUEUE_PRIORITY_HIGH 2
#define DISPATCH_QUEUE_PRIORITY_DEFAULT 0
#define DISPATCH_QUEUE_PRIORITY_LOW (-2)
#define DISPATCH_QUEUE_PRIORITY_BACKGROUND INT16_MIN
参数：1.队列的优先级； 2.第二个参数是苹果保留的，以后可能会使用的参数
dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
3. 用户自定义的队列
1）串行队列 Serial ( 系统 let mainQueue = dispach_get_main_queue() )
参数：1. 队列的标识符(C的字符串)； 2.用来确定是串行还是并发
dispatch_queue_t serialQueue = dispatch_queue_create("serialQieie", DISPATCH_QUEUE_SERIAL);
2）并发队列 Concurrent ( 系统 let queue = dispatch_get_global_quque(DISPATCH_QUEUE_PRIORITY_HIGH, 0) )
dispatch_queue_t concurrent = dispatch_queue_create("concurrent", DISPATCH_QUEUE_CONCURRENT);

提交任务 Submitting tasks to queues
dispatch_async(queue) { () -> Void in
    // your task goes here
}
--------
将block以同步的方式提交到并行队列；前面的线程执行结束，才开始执行后面的线程
dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
dispatch_sync(queue, ^{
    for (int i=0; i<10; i++) {
        NSLog(@"线程一: %d",i);
    }
});
dispatch_sync(queue, ^{
    for (int i=0; i<10; i++) {
        NSLog(@"线程二: %d",i);
    }
});
----
//将block代码块以异步的方式提交给串行队列。
//前面的线程执行结束，才开始执行后面的线程，顺序执行
dispatch_queue_t queue = dispatch_queue_create("serialOne", DISPATCH_QUEUE_SERIAL);
dispatch_async(queue, ^{
    for (int i=0; i<10; i++) {
        NSLog(@"线程一: %d",i);
    }
});
dispatch_async(queue, ^{
    for (int i=0; i<10; i++) {
        NSLog(@"线程二: %d",i);
    }
});
----
//将block代码块以异步的方式提交给并行（异步）队列。多个线程同时执行
//我们这里使用系统的全局并行队列
dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
dispatch_async(queue, ^{
    for (int i=0; i<10; i++) {
        NSLog(@"线程一: %d",i);
    }
});
dispatch_async(queue, ^{
    for (int i=0; i<10; i++) {
        NSLog(@"线程二->: %d",i);
    }
});
---------
//创建一个组
dispatch_group_t group = dispatch_group_create();
dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
dispatch_group_async(group, queue, ^{
    for (int i=0; i<10; i++) {
    NSLog(@"线程一：%d",i);
    }
});
    
dispatch_group_async(group, queue, ^{
    for (int i=0; i<10; i++) {
        NSLog(@"线程二：%d",i);
    }
});
//所有线程执行完成后执行这个方法
dispatch_group_notify(group, queue, ^{
    NSLog(@"group 结束");
});

//3.在一段时间之后执行
//时间间隔
dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 2*NSEC_PER_SEC);
//全局的并行队列
dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
NSLog(@"准备执行");
dispatch_after(time, queue, ^{//经过时间time后才执行
    NSLog(@"执行了");
});

//2.只执行一次的代码。 单例
static dispatch_once_t onceToken;
dispatch_once(&onceToken, ^{
    NSLog(@"YES");
});

//1. 多次执行一段代码块
参数：1.代码块执行的次数；2.代码块执行的队列；3.代码块，size_t：当前执行的是第几次
dispatch_apply(5, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(size_t time) {
    for (int i=0; i<10; i++) {
        NSLog(@"第%ld次-- %d",time,i);
    }
});
-----------
Easy mode ... invoking a method on the main queue! 
NSObject method ...!
 - (void)performSelectorOnMainThread:(SEL)aMethod	--方法
                          withObject:(id)obj		--参数
                       waitUntilDone:(BOOL)waitUntilDone;
--waitUntilDone可以使nil，是允许的。
--the waitUntilDone is whether you're gonna wait until this thing gets pulled off the main queue and run on the main queue and then finishes before this thread, that's calling this, goes or not. usually waitUntilDone you would say no, we don't need to wait. like saying dispatch async onto the main queue.
最后一个参数表示是否要等待调用它的这个线程执行之后，再将它从主队列调出，并在主队列上运行。通常为NO，不需要等待--工作线程是否等待UI主线程执行完成。
dispatch_async(dispatch_get_main_queue(), ^{ * call aMethod *});

@interface NSObject (NSThreadPerformAdditions)

- (void)performSelectorOnMainThread:(SEL)aSelector withObject:(id)arg waitUntilDone:(BOOL)wait modes:(NSArray *)array;
- (void)performSelectorOnMainThread:(SEL)aSelector withObject:(id)arg waitUntilDone:(BOOL)wait;
	// equivalent to the first method with kCFRunLoopCommonModes
--让某个线程去执行aSelector函数
- (void)performSelector:(SEL)aSelector onThread:(NSThread *)thr withObject:(id)arg waitUntilDone:(BOOL)wait modes:(NSArray *)array;
- (void)performSelector:(SEL)aSelector onThread:(NSThread *)thr withObject:(id)arg waitUntilDone:(BOOL)wait;
	// equivalent to the first method with kCFRunLoopCommonModes
- (void)performSelectorInBackground:(SEL)aSelector withObject:(id)arg;
@end
------------------------
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.destinationViewController isKindOfClass:[ImageViewController class]]) {
        ImageViewController *ivc = (ImageViewController *)segue.destinationViewController;
        ivc.imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://pic1.ooopic.cn/uploadfilepic/sheying/2008-08-25/%@",segue.identifier]];
        ivc.title = segue.identifier;
    }
}
---------
NSURLRequest *request = [NSURLRequest requestWithURL:self.imageURL];
NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration ephemeralSessionConfiguration];
+ (NSURLSessionConfiguration *)defaultSessionConfiguration;--返回标准配置，这实际上与NSURLConnection的网络协议栈是一样的，具有相同的共享NSHTTPCookieStorage，共享NSURLCache和共享NSURLCredentialStorage。
+ (NSURLSessionConfiguration *)ephemeralSessionConfiguration;--临时会话配置
+ (NSURLSessionConfiguration *)backgroundSessionConfigurationWithIdentifier:(NSString *)identifier;后台会话配置，表示开始下载文件后，即使用户切换到其他应用或应用停止，也会继续下载，下载完成后再向我发送消息。如果需要，再启动应用来处理。
NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request completionHandler:^(NSURL *localfile, NSURLResponse *response, NSError *error) {
    if (!error) {
        if ([request.URL isEqual:self.imageURL]) {//判断请求的是否是我现在需要的内容，同一个页面有可能发送多个请求。
            UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:localfile]];//根据URL请求图片
            //UIImage是UIKit中少数几个允许不在主线程上操作的类之一，这里不需要任何屏幕操作。
            //第一种方法，GCD方式提交
            dispatch_async(dispatch_get_main_queue(), ^{
                self.image = image; //这里会调用setImage进行赋值
            });
            //第二种方法
            //[self performSelectorOnMainThread:@selector(setImage:) withObject:image waitUntilDone:NO];
			//第三种方法，NSOperation方式提交
			NSInvocationOperation *updateUI = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(setImage:) object:image];
			[[NSOperationQueue mainQueue] addOperation:updateUI];
        }
    }
}];
[task resume];//没有这个的话，task从一开始就会挂起，等待恢复
------------------------
Example of an iOS API that uses multithreading!从网络上下载某个URL对应的内容。
NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL urlWithString:@“http://...”]];创建一个URL请求
NSURLConfiguration *configuration = ...;配置
NSURLSession *session = ...;创建URLsession会话，URLsession是一个对象，用来管理一个会话的时间。
NSURLSessionDownloadTask *task;
//block的参数，第一个参数是用于存放网络URL内容的本地文件URL。即从网络上下载网络URL的内容，保存在本地文件中，再返回本地文件的URL。file:文件URL。
//第二个第三个参数为，响应参数和错误处理。
task = [session downloadTaskWithRequest:request //本地文件URL，
 completionHandler:^(NSURL *localfile, NSURLResponse *response, NSError *error) {
        ￼* want to do UI things here, can I? * 
}];
[task resume];
downloadTaskWithRequest:completionHandler: will do its work (downloading that URL)! NOT in the main thread (i.e. it will not block the UI while it waits on the network).!
!
The completionHandler block above might execute on the main thread (or not)! depending on how you create the NSURLSession.!
Let’s look at the two options (on or off the main queue) ...
 
 NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration]; // no delegateQueue
 NSURLSessionDownloadTask *task;
 task = [session downloadTaskWithRequest:request
 completionHandler:^(NSURL *localfile, NSURLResponse *response, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{ * do UI things * });
        or [self performSelectorOnMainThread:@selector(doUIthings) withObject:nil waitUntilDone:NO];
 }];
[task resume];//别忘了这个，任务恢复
In this case, you can’t do any UI stuff because the completionHandler is not on the main queue.! To do UI stuff, you have to post a block (or call a method) back on the main queue (as shown).
注：dispatch_async 是线程安全的，你可以通过他用于线程同步，是原子调用

NSThread: 1. 线程、进程、程序
程序就是一个可运行的文件。程序是一个静态的概念
进程就是正在运行的程序。
线程是进程实现功能的一个单位。一个进程至少有一个线程，可以有多个线程。iOS程序默认会创建一个主线程，其他的线程需要我们自己去创建和管理。
		  2. 为什么使用多线程
如果不用多线程，所有工作都在主线程中执行的话，程序会出现假死的情况，用户体验非常不好。
我们需要使用多线程来完成一些与UI显示无关的操作，执行完成之后，如果需要修改UI，可以回到主线程进行修改。
		  3. 创建线程
NSThread创建线程的方式
--方式一：创建一个线程，系统会自动再空闲时间运行线程的执行体
参数：1.表示线程的执行体 2.表示线程的执行体对应的对象 3.线程执行方法的参数。   线程创建后就会自动运行
[NSThread detachNewThreadSelector:@selector(thread1:) toTarget:self withObject:n];
--方式二：
//创建一个线程，系统不能自动运行这个线程的执行体，需要我们手动去启动线程
//参数：1.表示线程的执行体对应的对象  2.表示线程的执行体 3.线程执行方法的参数。
if (_t2) return;
_t2 = [[NSThread alloc] initWithTarget:self selector:@selector(thread2:) object:n];

4. 怎么监听线程的结束;线程结束的情况.1.线程执行体执行完成；2.线程在执行体运行时遇到错误；3.手动调用exit
//监听线程结束
[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(threadExit:) name:NSThreadWillExitNotification object:nil];

NSString * const NSWillBecomeMultiThreadedNotification;//这个通知只会被NSThread触发一次,条件是当第一个进程在调用了start或者detachNewThreadSelector:toTarget:withObject:方法.这个通知的接收者的一些处理方法都是在主线程上进行的;这是因为这个通知是在系统生产新的子线程之前进行的,所以在监听这个通知的时候,调用监听者的通知方法都会在主线程进行.
NSString * const NSDidBecomeSingleThreadedNotification;
NSString * const NSThreadWillExitNotification;//通过监听这个通知来处理一下进程即将结束之前的一些事情

		  5. 怎样在程序中取消一个线程
//修改线程二的状态
[_t2 cancel];--表示取消线程，此时的这个线程仍在内存中，只是处于暂停状态。还可以再次启动
if ([_t2 isCancelled]) {
	[NSThread exit];//必须调用该方法才能结束线程， cancle只是将线程设置为取消状态
}
--“干净”地解决掉线程
--最好的方式是在到达程序主入口的终点时，自然结束掉线程。另外，我们还有方法来立即结束线程，除非不得以，不应使用那些方法。在线程“自然死”之前，强制结束它会影响线程的清理工作。如果线程申请了内存，打开过文件，或是请求过其他类型的资源，你的代码将无法回收那些资源，从而导致内存泄露或其他隐含的问题。

@property (readonly, getter=isExecuting) BOOL executing;//如果进程正在执行,这个方法返回YES,否则返回NO;
@property (readonly, getter=isFinished) BOOL finished;//如果进程执行结束,返回YES,否则返回NO;
@property (readonly, getter=isCancelled) BOOL cancelled;//如果进程被取消,返回YES,否则返回NO;

线程的优先级。priority, 优先级的值在0-1之间， 默认值为0.5
优先级越高的线程在同一个时间片中执行的次数越多
_t1.threadPriority = 0;-- 修改线程优先级

		  6. 线程锁
//实现同步的第一种方式
@synchronized(self){}

--[实现同步的第二种方式： 加锁/解锁。
//首先定义一个同步锁对象
NSLock *_myLock;
_myLock = [[NSLock alloc] init];//初始化同步锁对象
[_myLock lock];//加锁
//进行事件处理操作{}
[_myLock unlock];//解锁--]
		  7. 在进度条上模拟显示进度条
//回到主线程，修改Progress的进度
[self performSelectorOnMainThread:@selector(updateUI:) withObject:[NSNumber numberWithInt:i] waitUntilDone:YES];
- (void)updateUI:(NSNumber *)n
{
	_progressView.progress = n.intValue / 100.0f;
}
--[NSOperation实现多线程方式
//自己创建一个队列，然后创建NSOperation子类类型的对象，最后添加到队列中即可执行
NSOperationQueue myQueue  = [[NSOperationQueue alloc] init];//创建线程池、线程队列
//同时执行的最大线程数
myQueue.maxConcurrentOperationCount = 2;
//有三种方式创建NSOperation子类类型的对象。
//第一种方式
NSInvocationOperation *operation1 = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(thread1:) object:nil];
//添加到队列后，子线程就开始执行。(即等待系统空闲时进行调用)
[myQueue addOperation:operation1];
//第二种方式
NSBlockOperation *operation2 = [NSBlockOperation blockOperationWithBlock:^{
    for (int i=0; i<100; i++) {
        NSLog(@"thread2:--%d",i);
    }
}];
[myQueue addOperation:operation2];
//定义线程结束后要执行的操作
[operation1 setCompletionBlock:^{
    NSLog(@"thread1结束了");
}];
[operation2 setCompletionBlock:^{
    NSLog(@"thread2结束了");
}];
--]
--[自定义Operation实现多线程，继承NSOperation实现自己的类，需要重写main方法
//定义线程执行体
//线程的执行体
- (void)main
{
    NSURL *url = [NSURL URLWithString:_urlString];
    NSData *data = [NSData dataWithContentsOfURL:url];   
    UIImage *image = [UIImage imageWithData:data];
    [self performSelectorOnMainThread:@selector(updateUI:) withObject:image waitUntilDone:YES];
}
- (void)updateUI:(UIImage *)image
{
    _imageView.image = image;
}
--]
OOP (Object Oriented Programming)面向对象程序设计
AOP (Aspect Oriented Programming)面向切面编程
NSString *(^block5) (NSString *, NSString *) = ^(NSString *a, NSString *b){
        return [NSString stringWithFormat:@"%@%@",a,b];
};
NSLog(@"%@",block5(@"wew",@"www"));

@interface NSOperationQueue : NSObject {
@private
    id _private;
    void *_reserved;
}
- (void)addOperation:(NSOperation *)op;
- (void)addOperations:(NSArray *)ops waitUntilFinished:(BOOL)wait;
- (void)addOperationWithBlock:(void (^)(void))block;

@property (readonly, copy) NSArray *operations;
@property (readonly) NSUInteger operationCount;

@property NSInteger maxConcurrentOperationCount;

enum {
    NSOperationQueueDefaultMaxConcurrentOperationCount = -1
};

@property (getter=isSuspended) BOOL suspended;

@property (copy) NSString *name;

@property NSQualityOfService qualityOfService;

@property (assign /* actually retain */) dispatch_queue_t underlyingQueue;

- (void)cancelAllOperations;

- (void)waitUntilAllOperationsAreFinished;

+ (NSOperationQueue *)currentQueue;
+ (NSOperationQueue *)mainQueue;
@end

//UITableView : UIScrollView <NSCoding>表格视图
1.表格视图控制器是一个视图控制器，是UIViewController的子类，因此，UIViewController的方法都可调用
2.内含一个tableView，用self.tableView进行对表格视图控制器内容的tableView操作
3.表格视图控制器自动遵守了UITableViewDelegate,UITableViewDataSource协议并同时将表格视图控制器设置为其内部的表格视图的代理
4.属性：clearsSelectionOnViewWillAppear，设置视图将要出现的时候将所有的选中项设置为非选中状态。refreshControl，通过该属性来创建刷新对象
//取消导航条对滚动视图的影响，两种方式选择一种即可，很多情况下这两种方式中的某一个不起作用
self.automaticallyAdjustsScrollViewInsets=NO;
self.edgesForExtendedLayout=UIRectEdgeNone;//设置不扩展。
//第二个参数表示表格的样式。
//    UITableViewStylePlain,  // regular table view普通样式
//    UITableViewStyleGrouped    // preferences style table view分组样式
UITableView *tbView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height - 64) style:UITableViewStylePlain];
//设置代理
//遵守<UITableViewDelegate>，用来显示表格视图的UI显示。
tbView.delegate = self;
//遵守<UITableViewDataSource>，用来设置表格视图显示的数据
tbView.dataSource = self;
//设置数据源，通常是数组或字典。
//tableView单元格之间分割线的样式
tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLineEtched;
//UITableViewCellSeparatorStyleNone             没有分割线
//UITableViewCellSeparatorStyleSingleLine       单条分割线
//UITableViewCellSeparatorStyleSingleLineEtched
_tableView.separatorColor=[UIColor blackColor];//设置表格视图的单元格之间的分割线颜色 
//控制该表格滚动到指定indexPath对应的cell的顶端 中间 或者下方
[_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:3] atScrollPosition:UITableViewScrollPositionTop animated:YES]; //使表格视图的初始状态滚动到指定分区，指定行
//控制该表格选中指定indexPath对应的表格行,最后一个参数控制是否滚动到被选中行的顶端 中间 和底部
- ( void )selectRowAtIndexPath:( NSIndexPath *)indexPath animated:( BOOL )animated scrollPosition:( UITableViewScrollPosition )scrollPosition;
//获取选中cell对应的indexPath
- ( NSIndexPath *)indexPathForSelectedRow
//获取所有被选中的cell对应的indexPath组成的数组
- ( NSArray *)indexPathsForSelectedRows
_tableView.contentOffset=CGPointMake(0, 0); //设置表格视图的偏移量
self.navigationItem.leftBarButtonItem=self.editButtonItem;
//为当前视图控制器的导航条添加一个UIViewController自带的编辑按钮
_tableView.allowsSelection = YES;
//设置在非编辑模式下，表格视图的单元格是否支持单选
_tableView.allowsMultipleSelection = YES;
//设置在非编辑模式下，表格视图的单元格是否支持多选
_tableView.allowsSelectionDuringEditing = NO;
//设置在编辑模式下，表格视图的单元格是否支持单选
_tableView.allowsMultipleSelectionDuringEditing = NO;
//设置在编辑模式下，表格视图的单元格是否支持多选
#pragma mark - 表格视图协议
//返回每一行显示的内容；每一行都是一个UITableViewCell类型的对象，UITableViewCell本质上是一个视图
//indexPath -> NSIndexPath类型。section：表示当前在第几组；row：表示当前在这一组的第几行
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//创建一个UITableViewCell类型的对象
    //第一个参数，表示UITableViewCell对象的样式。UITableViewCellStyleSubtitle 表示显示主标题和副标题
    /*UITableViewCellStyleDefault,	// Simple cell with text label and optional image view (behavior of UITableViewCell in iPhoneOS 2.x)
    UITableViewCellStyleValue1,		// Left aligned label on left and right aligned label on right with blue text (Used in Settings)
    UITableViewCellStyleValue2,		// Right aligned label on left with blue text and left aligned label on right (Used in Phone/Contacts)
    UITableViewCellStyleSubtitle	// Left aligned label on top and left aligned label on bottom with gray text (Used in iPod).*/
	//定义重用标识
	static NSString *cellId = @"cellId";
    //先去重用队列中取
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    //如果取不到，创建一个。
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleGray;//设置选择样式
    //右边提示符的样式
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    //设置标题
    NSString *title = _dataArray[indexPath.row];
    cell.textLabel.text = title;//标题
    cell.detailTextLabel.text = @"副标题";//副标题
    cell.imageView.image = [UIImage imageNamed:@"2.png"];//图片
    return cell;
}
//返回表格视图有多少组
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataArray.count;
}
//设置表格视图对应分区的行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	NSArray *subArray = _dataArray[section];
	return subArray.count;
}
//设置每个单元格的高度，默认高度 44.
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
//设置每组的头的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}
//选中指定行时（从非选中到选中），调用该协议方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"选择行数： %ld --->  %ld", indexPath.section, indexPath.row);
   // [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
//取消选中的时（从选中到非选中），调用该协议方法
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"上次选择行数为 %ld --->  %ld", indexPath.section, indexPath.row);
}
//每一组上面的标题
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"第一组标题";
}
//每一组下面的脚标
- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
    return @"ddddd";
}

//设置指定分区的头视图高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}
//设置指定分区的头视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * blackView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 20)];
    blackView.backgroundColor=[UIColor blackColor];
    return blackView;
}
//设置指定分区的脚视图高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 20;
}
//设置指定分区的脚视图
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView * whiteView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 20)];
    whiteView.backgroundColor=[UIColor whiteColor];
    return whiteView;
}
//设置单元格cell的内容缩进
- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath{
    return indexPath.row; //需要注意的时候，该返回值并不代表像素
}
#pragma mark - 单元格删除/插入/多选
//指定行是否可用进行编辑(返回YES表示可以进行编辑；返回NO表示不能进行编辑)
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
//设置指定分区指定行的编辑类型,默认是删除状态
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{   //UITableViewCellEditingStyleNone      不编辑 0
    //UITableViewCellEditingStyleDelete    删除 1
    //UITableViewCellEditingStyleInsert    插入 2
    //UITableViewCellEditingStyleInsert | UITableViewCellEditingStyleDelete
    //删除编辑和插入编辑相或表示多选

    return UITableViewCellEditingStyleInsert;
}

//提交对单元格的编辑
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSMutableArray *subArray = _dataArray[indexPath.section];
        [subArray removeObjectAtIndex:indexPath.row];
        [_tbView reloadData];
    }else if(editingStyle == UITableViewCellEditingStyleInsert){
        //添加一条数据
        NSMutableArray *subArray = _dataArray[indexPath.section];
        //创建一个学生对象
        StudentModel *newModel = [[StudentModel alloc] init];
        newModel.name = @"我是新来的";
        newModel.age = 25;
        [subArray insertObject:newModel atIndex:indexPath.row];
        [_tbView reloadData];//刷新
    }
}
---
switch ((int)editingStyle) {//判断行编辑的类型
    case UITableViewCellEditingStyleDelete:{
    //如果编辑类型为删除编辑
    }
    break;
    case UITableViewCellEditingStyleInsert:{
    //如果编辑类型为插入编辑
    }
    break;
    case UITableViewCellEditingStyleDelete|UITableViewCellEditingStyleInsert:{
    //如果编辑类型为多选编辑
    }
    default:
    break;
}
---
//更改删除编辑类型中得字体内容 默认显示delete
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}
#pragma mark - 单元格移动
//设置指定的分区的指定行是否可以进行移动
- (BOOL) tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
//将指定分区指定行从起始位置移动到目标位置
//一旦实现这个方法，单元格cell处于编辑状态时，右侧会出现一个移动的按钮
//该方法在单元格移动结束的时候调用，可以用来修改数据源数组中对应的数据
-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    /*在不同组之间移动数据
    NSMutableArray *sourceArray = _dataArray[sourceIndexPath.section];
    StudentModel *sourceModel = sourceArray[sourceIndexPath.row];
    [sourceArray removeObject:sourceModel];
    [_dataArray[destinationIndexPath.section] insertObject:sourceModel atIndex:destinationIndexPath.row];
    */
    
    //在同组间改变数据的位置
    NSMutableArray *array = _dataArray[sourceIndexPath.section];
    [array exchangeObjectAtIndex:sourceIndexPath.row withObjectAtIndex:destinationIndexPath.row];
}
//设置是否允许指定分区的指定行从起始位置移动到目标位置
//参数sourceIndexPath表示起始位置
//参数proposedDestinationIndexPath表示目标位置
- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath
{
    if (sourceIndexPath.section != proposedDestinationIndexPath.section) {
        return sourceIndexPath;//如果在不同的section中，不允许移动
    }
    return proposedDestinationIndexPath;
}
#pragma mark - 创建表格视图右侧快速标题索引
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    NSMutableArray *indexArray = [NSMutableArray array];
    [indexArray addObject:UITableViewIndexSearch];//在索引中添加搜索框链接。 
    for (int i = 'A'; i <= 'Z'; i++) {
        [indexArray addObject:[NSString stringWithFormat:@"%c",i]];
    }
    return indexArray;
}
//修改每个索引对应的序号,设置完成之后点击右侧标题索引就可以使tableView定位到指定的分区
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    if (index == 0) {
        _tableView.contentOffset = CGPointMake(0, 0);
        return -1;
    }else
    return index - 1;//return  -1没有作用，tableView不做任何操作;
}

#pragma mark - 编辑按钮
self.navigationItem.leftBarButtonItem=self.editButtonItem;
//该编辑按钮是视图控制器自带的编辑按钮，所有的视图控制器的子类都拥有
//点击当前视图控制器在导航条上的编辑按钮时，调用该方法
- (void)setEditing:(BOOL)editing animated:(BOOL)animated{
    [super setEditing:editing animated:animated];
    //调用父类的方法，自动设置编辑按钮被点击之后的标题
    [_tableView setEditing:editing animated:YES];
    //使用编辑按钮的值，来设置表格视图的编辑状态   
	UIButton *button = (UIButton *)[self.view viewWithTag:101];
    [self.view bringSubviewToFront:button];
    //编辑时要显示删除按钮
    button.hidden = !editing;
    //设置隐藏和显示
}
<----------界面刷新方式----------->
更改数据源中指定数据之后的界面进行刷新
刷新界面方式一：
[tableView reloadData];
刷新整个TableView，相当于使用修改之后的数据源来重新创建一遍TableView；
刷新界面方式二：
[tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section]
              withRowAnimation:UITableViewRowAnimationFade];
根据被点击行的索引信息indexPath，刷新被点击行所在的整个分区
刷新界面方式三：（删除和添加时，该方式不可用）
[tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                withRowAnimation:UITableViewRowAnimationFade];
根据被点击行的索引信息indexPath，刷新被点击的行
刷新界面方式四：
[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                 withRowAnimation:UITableViewRowAnimationFade];
根据被点击行的索引信息indexPath，以删除方式，刷新指定行
刷新界面方式五：（删除时，该方式不可用）
[tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section]
              withRowAnimation:UITableViewRowAnimationFade];
根据被点击行的索引信息indexPath，以删除方式，刷新指定分区
刷新界面方式六：
[tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
根据被点击行的索引信息indexPath，以插入方式，刷新指定行
刷新界面方式七：（添加时，当前方式不可用）
[tableView insertSections:[NSIndexSet indexSetWithIndex:indexPath.section]
          withRowAnimation:UITableViewRowAnimationFade];
根据被点击行的索引信息indexPath，以插入方式，刷新指定分区
注意：
1.我们在选择刷新界面的方式的时候，一般原则是在保证能够刷新到所有被修改的行的同时，刷新最少的行，这样可以优化程序的执行效率，减少程序对手机资源的消耗
2.方式三不能用在删除编辑当中，因为删除编辑会删除掉指定行，所以无法再对指定行的信息进行刷新

#pragma mark - 搜索框
- (void)createSearchBar
{
    //iOS7   现已弃用
    //UISearchDisplayController
    //iOS8;创建一个搜索视图控制器
    _searchCtl = [[UISearchController alloc] initWithSearchResultsController:nil];
    _searchCtl.delegate = self;//设置代理
    _searchCtl.searchResultsUpdater = self;//设置搜索数据代理
    //搜索视图控制器默认有一个搜索框视图
    //搜索框视图是一个UISearchBar类型对象
    _searchCtl.dimsBackgroundDuringPresentation = NO;//去掉搜索结果默认的灰色背景。
    [_searchCtl.searchBar sizeToFit];//设置搜索框大小
//将搜索框作为表格视图的表格头,对于表格头视图和尾视图，只有高度可以设置
    _tableView.tableHeaderView = _searchCtl.searchBar;
    //_tableView.tableFooterView    //表格尾
}
#pragma mark - UISearchResultsUpdating
//搜索时，更新搜索结果数据源
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    [_resultArray removeAllObjects]; //搜索前记得先清空搜索结果数组
    NSString *filterString = searchController.searchBar.text;//取到搜索框中的文字
    //遍历原始的数据源数组，查找是否有跟搜索框中文字匹配的内容。匹配成功，将搜索结果加到结果的数据源数组中。
    for (NSArray *subArray in _dataArray){
        //遍历子数组
        for (NSString *str in subArray){
            //检查是否匹配
            NSRange range = [str rangeOfString:filterString options:NSCaseInsensitiveSearch];//大小写不敏感
            if (range.location != NSNotFound) {
                //如果匹配
                [_resultArray addObject:str];
            }
        }
    }
    [_tableView reloadData];
}

#pragma mark - UISearchControllerDelegate
//将要显示搜索视图控制器
- (void)willPresentSearchController:(UISearchController *)searchController
{
    _isSearch = YES;
    [_tableView reloadData];
}
//结束搜索状态时调用，
- (void)didDismissSearchController:(UISearchController *)searchController
{
    _isSearch = NO;   
    [_tableView reloadData];
}
[单元格Cell样式设计]
self.backgroundColor = [UIColor grayColor];//设置单元格cell的背景颜色
self.backgroundView = cyanView; //设置单元格cell的背景视图
self.selectionStyle = UITableViewCellSelectionStyleDefault;
//设置单元格cell的选中风格
//默认的选中风格，没有选中效果
//UITableViewCellSelectionStyleNone,
//下面三个风格，选中之后单元格都是灰的
//UITableViewCellSelectionStyleBlue,
//UITableViewCellSelectionStyleGray,
//UITableViewCellSelectionStyleDefault
self.selectedBackgroundView = orangeView;//设置单元格cell的选中背景视图
self.accessoryType=UITableViewCellAccessoryNone;//设置单元格cell的右侧附件
//UITableViewCellAccessoryNone                     没有附件
//UITableViewCellAccessoryDisclosureIndicator      右尖括号（可点击）
//UITableViewCellAccessoryDetailDisclosureButton   信息按钮和右尖括号（可点击）
//UITableViewCellAccessoryCheckmark                对号
//UITableViewCellAccessoryDetailButton             信息按钮

[收集]
NSString * version = [[UIDevice currentDevice] systemVersion]; //获取当前手机操作系统的版本信息，并返回一个字符串
self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"fengjing.jpg"]]; //以该方法设置的颜色，会根据图片的具体内容进行配置，而不在局限于单一的一种颜色.如果图片的大小大于其载体，载体会从图片的左上角的位置开始取材，取与载体相同大小的图片，而不是将图片进行压缩;如果图片的大小小于其载体，载体会从对图片进行复用，而不是将图片进行拉伸

iOS客户端和服务器之间是通过HTTP协议来传递数据。
每台机器都有唯一的ip; 端口号
TCP协议
UDP协议
HTTP协议，传输文本、图片、音频等。
http://api.chengmi.com 域名
//shindex 发送的一个request
? 后面是参数，参数是键值对的方式：key = value，不同参数之间用&符号隔开
//GET: 参数都直接放在url后面
//Post: 参数是用请求头的方式。 请求头，请求体  
同步：所有操作都放在一个线程里，按顺序执行。
异步：所有的操作都放在自己独立的线程中，同时进行，不分先后。    
[网络请求之一NSString的类方法请求数据] 同步下载的方式，会阻塞主线程UI的显示，实际项目中不使用这种方式来请求数据
//1. 创建一个URL对象
NSURL *url = [NSURL URLWithString:@"http://api.chengmi.com/shindex?passdate=20150108&curlng=121.5093155189223&curlat=31.27483773025054"];
//2. 请求数据
//第一个参数，传递请求的URL对象
//第二个参数，编码方式
//第三个参数，error
NSString *dataString = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
//3.转化为二进制数据
NSData *data = [dataString dataUsingEncoding:NSUTF8StringEncoding];
//4.JSON解析:{}包括的内容是字典,""包括的内容是字符串,[]包括的内容是数组
/* A class for converting JSON to Foundation objects and converting Foundation objects to JSON. 
An object that may be converted to JSON must have the following properties:
 - Top level object is an NSArray or NSDictionary
 - All objects are NSString, NSNumber, NSArray, NSDictionary, or NSNull
 - All dictionary keys are NSStrings
 - NSNumbers are not NaN or infinity
 */
/**
 NSJSONReadingMutableContainers = (1UL << 0),解析出来的对象是一个可变的容器(就是数组和字典结构)一般都用这个枚举常量
 NSJSONReadingMutableLeaves = (1UL << 1),解析出来的是一个可变的字符串(但必须要满足相应的JSON数据格式)
 NSJSONReadingAllowFragments = (1UL << 2)其他格式内容
 */
//第一个参数：二进制文件
//第二个参数:json转化的类型
//NSJSONReadingMutableContainers:解析字典和数组的时候使用
//第三个参数：错误信息
id result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
if ([result isKindOfClass:[NSDictionary class]]) {
    NSDictionary *dic = (NSDictionary *)result;
    NSLog(@"%@",dic);
}else if ([result isKindOfClass:[NSArray class]]){
    NSArray *arr = (NSArray *)result;
    NSLog(@"%@",arr);
}

[网络请求之二NSURLConnection]异步下载，需要遵守两个协议<NSURLConnectionDelegate,NSURLConnectionDataDelegate>
@interface RootViewController ()<NSURLConnectionDelegate,NSURLConnectionDataDelegate>
{
    NSURLConnection *_myConnection;//发送请求的对象
    NSMutableData *_receiveData;//存储二进制数据
    NSMutableArray *_dataArray;//数据源数组
}
//GET:参数直接放在url里面
//1、创建一个NSURL对象
//如果网址中有中文 那么下面的操作就是来处理包含中文的网址
urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
NSURL *url = [NSURL URLWithString:@"http://api.chengmi.com/shindex?passdate=20150108&curlng=121.5093155189223&curlat=31.27483773025054"];
//2、创建一个请求对象
NSURLRequest *request = [NSURLRequest requestWithURL:url];
//3、用NSURLConnection对象将请求对象发送给服务器
//第一个参数：请求对象
//第二个参数：代理
_myConnection = [NSURLConnection connectionWithRequest:request delegate:self];
_receiveData = [NSMutableData data];//网络请求回来的都是二进制数据

#pragma mark - NSURLConnection代理
//请求响应之后调用的方法
//响应头、响应体
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    //新建http请求
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    NSDictionary *dict = httpResponse.allHeaderFields;//响应头
    NSLog(@"%ld",httpResponse.statusCode);//状态码,200:返回正确的数据,404:找不到服务器
    [_receiveData setLength:0];//清空一下二进制数据
}
//返回数据
//如果数据量比较大，会多次调用这个方法
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_receiveData appendData:data];//拼接到 可变二进制数据中
}
//此次下载完成的时候调用
//这个方法会自动的转换到主线程进行相应地操作
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    //解析数据
    id result = [NSJSONSerialization JSONObjectWithData:_receiveData options:NSJSONReadingMutableContainers error:nil];
    if ([result isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dict = (NSDictionary *)result;
        //处理数据
        //sectioninfo
        NSArray *infoArray = dict[@"sectioninfo"];
        for (NSDictionary *subDict in infoArray) {
            //根据subDict字典创建一个DataModel类型的对象
            DataModel *model = [[DataModel alloc] init];
            model.distance = [subDict[@"distance"] doubleValue];
            model.pic = subDict[@"pic"];
            model.shortAddr = subDict[@"short_addr"];
            model.shortname = subDict[@"shortname"];
            model.sid = [subDict[@"sid"] integerValue];
            [_dataArray addObject:model];
        }
        [self.tableView reloadData];
    }
}
[URLConnection之Post请求]遵守协议<NSURLConnectionDataDelegate,NSURLConnectionDelegate>
/*!
@method requestWithURL:cachePolicy:timeoutInterval:
@abstract Allocates and initializes a NSURLRequest with the given URL and cache policy.
@param URL The URL for the request. 
@param cachePolicy The cache policy for the request.缓存的参数
@param timeoutInterval The timeout interval for the request. See the commentary for the <tt>timeoutInterval</tt> for more information on timeout intervals.设置超时间
@result A newly-created and autoreleased NSURLRequest instance.
*/
+ (instancetype)requestWithURL:(NSURL *)URL cachePolicy:(NSURLRequestCachePolicy)cachePolicy timeoutInterval:(NSTimeInterval)timeoutInterval;
//1.创建URL
NSURL *url = [NSURL URLWithString:@"http://api.m.koudai.com/listCommodityKind_v3.do"];
//2.创建一个NSMutableURLRequest对象
NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
//设置post请求方式
[request setHTTPMethod:@"Post"];
//设置请求体
[request setHTTPBody:bodyData];
//设置请求数据的大小
[request setValue:[NSString stringWithFormat:@"%ld",bodyData.length] forHTTPHeaderField:@"Content-Length"];
//设置请求数据的类型
[request setValue:@"application/x-www-urlencoded" forHTTPHeaderField:@"Content-Type"];
//发送请求
_conn = [NSURLConnection connectionWithRequest:request delegate:self];
使用第三方开源库（SDwebImage） 进行异步下载图片#import "UIImageView+WebCache.h"
一般不会同步下载 否则会造成页面卡死
setImageWithURL 会自动起一个线程专门来下载图片 和ui主线程 是同时进行的
这个异步下载图片还做了缓存，下载到本地之后 会做缓存 第二次加载图片直接缓存中加载
//用SDWebImage异步下载图片
[_leftImageView sd_setImageWithURL:[NSURL URLWithString:model.pic]];//这个函数还有可以带一个提示图片的参数，如果没有下载完显示提示的图片
---
/**
 * Set the imageView `image` with an `url`, placeholder and custom options.
 *
 * The download is asynchronous and cached.
 *
 * @param url          The url for the image.
 * @param placeholder    The image to be set initially, until the image request finishes.
 * @param options        The options to use when downloading the image. @see SDWebImageOptions for the possible values.
 * @param progressBlock  A block called while image is downloading
 * @param completedBlock A block called when operation has been completed. This block has no return value
 *                       and takes the requested UIImage as first parameter. In case of error the image parameter
 *                       is nil and the second parameter may contain an NSError. The third parameter is a Boolean
 *                       indicating if the image was retrived from the local cache or from the network.
 *                       The fourth parameter is the original image url.
 */
- (void)sd_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options progress:(SDWebImageDownloaderProgressBlock)progressBlock completed:(SDWebImageCompletionBlock)completedBlock;
---
typedef NS_OPTIONS(NSUInteger, SDWebImageOptions) {
/**
* By default, when a URL fail to be downloaded, the URL is blacklisted so the library won't keep trying.
* This flag disable this blacklisting.
*/
SDWebImageRetryFailed = 1 << 0,

/**
 * By default, image downloads are started during UI interactions, this flags disable this feature,
 * leading to delayed download on UIScrollView deceleration for instance.
 */
SDWebImageLowPriority = 1 << 1,

/**
 * This flag disables on-disk caching
 */
SDWebImageCacheMemoryOnly = 1 << 2,

/**
 * This flag enables progressive download, the image is displayed progressively during download as a browser would do.
 * By default, the image is only displayed once completely downloaded.
 */
SDWebImageProgressiveDownload = 1 << 3,

/**
 * Even if the image is cached, respect the HTTP response cache control, and refresh the image from remote location if needed.
 * The disk caching will be handled by NSURLCache instead of SDWebImage leading to slight performance degradation.
 * This option helps deal with images changing behind the same request URL, e.g. Facebook graph api profile pics.
 * If a cached image is refreshed, the completion block is called once with the cached image and again with the final image.
 *
 * Use this flag only if you can't make your URLs static with embeded cache busting parameter.
 */
SDWebImageRefreshCached = 1 << 4,

/**
 * In iOS 4+, continue the download of the image if the app goes to background. This is achieved by asking the system for
 * extra time in background to let the request finish. If the background task expires the operation will be cancelled.
 */
SDWebImageContinueInBackground = 1 << 5,

/**
 * Handles cookies stored in NSHTTPCookieStore by setting
 * NSMutableURLRequest.HTTPShouldHandleCookies = YES;
 */
SDWebImageHandleCookies = 1 << 6,

/**
 * Enable to allow untrusted SSL ceriticates.
 * Useful for testing purposes. Use with caution in production.
 */
SDWebImageAllowInvalidSSLCertificates = 1 << 7,

/**
 * By default, image are loaded in the order they were queued. This flag move them to
 * the front of the queue and is loaded immediately instead of waiting for the current queue to be loaded (which
 * could take a while).
 */
SDWebImageHighPriority = 1 << 8,

/**
 * By default, placeholder images are loaded while the image is loading. This flag will delay the loading
 * of the placeholder image until after the image has finished loading.
 */
SDWebImageDelayPlaceholder = 1 << 9,

/**
 * We usually don't call transformDownloadedImage delegate method on animated images,
 * as most transformation code would mangle it.
 * Use this flag to transform them anyway.
 */
SDWebImageTransformAnimatedImage = 1 << 10,
*/
---
[网络请求之三ASIHTTPRequest]ASI，继承于NSOperation，基于CFNetwork.framework封装了下载的功能，可实现get/post请求，也可实现多任务下载，还可以实现断点下载的功能，能够实现跟踪下载进度。
使用步骤：
1. 将ASIHTTPRequest包导入工程目录
2. ASI不支持ARC，在每个ASI文件的编译命令加上：-fno-objc-arc
3. 添加需要的库：CFNetwork.framework / MobileCoreServices.framework / SystemConfiguration.framework / libz.1.1.3.dylib
4.[GET请求] 导入头文件：ASIHTTPRequest.h
5. 创建ASIHttpRequest对象，进行下载。
NSURL *url = [NSURL URLWithString:@"http://api.chengmi.com/shindex?passdate=20150108&curlng=121.5093155189223&curlat=31.27483773025054"];
ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
request.delegate = self;//设置代理
request.tag = 101;//设置tag值来区分不同的ASI请求对象。
[request startAsynchronous];//发送请求,异步请求
[POST请求]#import "ASIFormDataRequest.h"
//1.创建一个NSURL类型的对象
NSURL *url = [NSURL URLWithString:@"http://api.m.koudai.com/listCommodityKind_v3.do"];
//2.创建一个ASIFormDataRequest对象
//继承于ASIHttpRequest
ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
//设置post请求体里面的内容,请求内容为键值对
NSString *bodyString = @"---";
NSArray *keyValueArray = [bodyString componentsSeparatedByString:@"&"];
for (NSString *keyValueString in keyValueArray) {
    //encryType=2
    NSArray *subArray = [keyValueString componentsSeparatedByString:@"="];
    //@[@"encryType",@"2"];
    if (subArray.count == 2) {
        //将键值对添加到请求体里面
        [request setPostValue:subArray[0] forKey:subArray[1]];
        //post请求如果传递图片
        //第一个参数：图片的二进制数据
        //第二参数：图片的名字
        //第三个参数：@"image/png"
        //第四个参数：key值
        /*
        id obj = [dic objectForKey:key];
        if ([obj isKindOfClass:[NSData data]]) {
            [request addData:(id) withFileName:(NSString *) andContentType:(NSString *) forKey:]
         }
         */
    }
}
//设置请求类型
[request setRequestMethod:@"Post"];
//设置代理
request.delegate = self;
//发送请求
[request startAsynchronous];
#pragma mark - ASIHTTPRequestDelegate
//请求结束时调用的方法
-(void)requestFinished:(ASIHTTPRequest *)request
{
    //返回的数据都存在request.responseData里面
    //解析JSON 
    id result = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
    if ([result isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dict = (NSDictionary *)result;
        NSArray *infoArray = dict[@"sectioninfo"];
        for (NSDictionary *subDict in infoArray) {
            //创建模型类的对象
            DataModel *model = [[DataModel alloc] init];
//            model.pic = subDict[@"pic"];
//            model.sid = subDict[@"sid"];
//            model.short_addr = subDict[@"short_addr"];
//            model.shortname = subDict[@"shortname"];
//            model.distance = subDict[@"distance"];
            //当模型中的属性名字和返回的数据字典中的名字一一对应时，可使用该方法，简化字典赋值操作。当key出现不一致时，可在函数(-(void)setValue:(id)value forUndefinedKey:(NSString *)key)中列出。 
            [model setValuesForKeysWithDictionary:subDict];
            [_dataArray addObject:model];
        }
        [self.tableView reloadData];
    }
}
-(void)requestFailed:(ASIHTTPRequest *)request
{//请求失败时调用
    NSLog(@"fail");
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DataCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellId"];
    DataModel *model = _dataArray[indexPath.row];
    [cell config:model];
    return cell;
}//这种取值方式需要在viewDidLoad中注册cell文件：
UINib *nib = [UINib nibWithNibName:@"DataCell" bundle:nil];//其中DataCell为Xib文件名。
[self.tableView registerNib:nib forCellReuseIdentifier:@"cellId"];

AFNetWorking使用了ARC ，在不使用ARC项目中使用时，对AFNetWorking的所有.m文件添加“-fobjc-arc”;在使用ARC项目中，使用“不使用ARC”的类库时，对类库的.m文件添加“-fno-objc-arc” 
[网络请求之四AFNetWorking]第三方库使用：支持arc+block,基于NSURLConnection封装的,支持iOS6以后的版本
1.导入AFNetWorking第三方库
引入头文件 #import "AFHTTPRequestOperationManager.h"
2.创建一个AFHTTPRequestOperationManager对象
AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] init];
3.设置返回的类型,返回的是NSData类型
manager.responseSerializer = [AFHTTPResponseSerializer serializer];
4.发送get请求
    //第一个参数：返回请求链接的字符串
    //第二个参数:请求时需要传递的参数
    //第三个参数:请求成功时调用的代码块
    //第四个参数:请求失败的时候调用
    [manager GET:@"http://api.chengmi.com/shindex?passdate=20150108&curlng=121.5093155189223&curlat=31.27483773025054" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //请求成功时处理数据
		//解析JSON数据
       id result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        //responseObject是返回的数据
        if ([result isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dict = (NSDictionary *)result;
            NSLog(@"%@",dict);
            //取到需要显示的数据
            NSArray *infoArray = dict[@"sectioninfo"];
            for (NSDictionary *subDict in infoArray) {
                //创建一个数据模型类
                DataModel *model = [[DataModel alloc] init];
                [model setValuesForKeysWithDictionary:subDict];
                [_dataArray addObject:model];
            }
            [self.tableView reloadData];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"fail");
    }];
if (nil == cell) {
    //从xib创建一个cell
    cell = [[[NSBundle mainBundle] loadNibNamed:@"DataCell" owner:self options:nil] lastObject];
}//这种方法不需要注册cell，但需要设置Xib文件的Restoration ID,即cellId。
//用SDWebImage下载图片
[_leftImageView sd_setImageWithURL:[NSURL URLWithString:model.pic]];
[AFNetWorking发送Post请求]
4.1设置请求体
/**
Creates and runs an `AFHTTPRequestOperation` with a `POST` request.

@param URLString The URL string used to create the request URL.
URL字符串
@param parameters The parameters to be encoded according to the client request serializer.
请求传递的参数，通常为字典形式
@param success A block object to be executed when the request operation finishes successfully. This block has no return value and takes two arguments: the request operation, and the response object created by the client response serializer.
@param failure A block object to be executed when the request operation finishes unsuccessfully, or that finishes successfully, but encountered an error while parsing the response data. This block has no return value and takes a two arguments: the request operation and the error describing the network or parsing error that occurred.

@see -HTTPRequestOperationWithRequest:success:failure:
 */
- (AFHTTPRequestOperation *)POST:(NSString *)URLString
                      parameters:(id)parameters
                         success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 Creates and runs an `AFHTTPRequestOperation` with a multipart `POST` request.
@param URLString The URL string used to create the request URL.
URL字符串
@param parameters The parameters to be encoded according to the client request serializer.
请求体传递的参数
@param block A block that takes a single argument and appends data to the HTTP body. The block argument is an object adopting the `AFMultipartFormData` protocol.
传递更多的参数，通常用来上传图片
@param success A block object to be executed when the request operation finishes successfully. This block has no return value and takes two arguments: the request operation, and the response object created by the client response serializer.
返回成功后执行的代码块
@param failure A block object to be executed when the request operation finishes unsuccessfully, or that finishes successfully, but encountered an error while parsing the response data. This block has no return value and takes a two arguments: the request operation and the error describing the network or parsing error that occurred.
返回失败后执行的代码块
 @see -HTTPRequestOperationWithRequest:success:failure:
 */
[request POST:(NSString *)URLString
   parameters:(id)parameters
constructingBodyWithBlock:^(id <AFMultipartFormData> formData){
//可以在这里上传图片
//方式一
//参数：1.图片的二进制数据；2.key；3.图片的名称；4.@"image/png"
	//formData appendPartWithFileData:(NSData *) name:(NSString *) fileName:(NSString *) mimeType:(NSString *)
//方式二
//参数：1。图片的路径；2.key ；3.图片名称；4.@"image/png"；5. NSError* 对象
	NSURL *url = [NSURL URLWithString:[[NSBundle mainBundle] pathForResource:@"1" ofType:@"png"]];
	//formData appendPartWithFileURL:url name:(NSString *) fileName:(NSString *) mimeType:(NSString *) error:(NSError *__autoreleasing *)
}
      success:^(AFHTTPRequestOperation *operation, id responseObject){
	id result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
    if ([result isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dict = result;
        NSLog(@"%@",dict);
    }
}
      failure:^(AFHTTPRequestOperation *operation, NSError *error){
}];
(http)get请求和post请求的区别:
 *1、post请求 请求地址和参数分离，比get更加安全
 *2、get请求只能获取服务器的数据不能上传文件，而post两者都可以
 *3、get请求在浏览器中字符串长度最大限制为1024,post 没有限制
 *4、post 上传文件 文件大小不能超过4G
 *5、get请求 NSURLConnetion 请求下来的数据，NSURLConnection 会做一定的数据缓存，post请求，请求下来的数据NSURLConnection不做数据缓存

- (id)performSelector:(SEL)aSelector withObject:(id)object;//调用选择器方法，传递两个参数
[self performSelector:(SEL) withObject:(id) afterDelay:(NSTimeInterval)];//执行选择器 withObject 作用对象 afterDelay 在多长时间后调用
[self performSelectorInBackground:(SEL) withObject:(id)];//在最开始的时候调用一个背景线程

//使用系统底层的函数，播放短暂的声音，一般要小于30秒
//创建系统声音ID 
SystemSoundID soundID;
//获取短暂声音的路径
NSString *soundPath = [[NSBundle mainBundle] pathForResource:@"Sound12" ofType:@"mp3"];
//将短暂声音的路径转化为NSURL
NSURL *soundURL = [NSURL fileURLWithPath:soundPath];
//注册声音，获取声音的位置，然后将NSURL与ID绑定
AudioServicesCreateSystemSoundID((CFURLRef)soundURL, &soundID);
//通过系统的ID，播放短暂的音乐
AudioServicesPlaySystemSound(soundID);

播放长度超过30秒的音频
给游戏加背景音乐，或者播放歌曲音乐
1.把音乐文件导入工程
2.导入AVFoundation库
3.导入#import <AVFoundation/AVFoundation.h>
4.创建音乐播放器AVAudioPlayer
//创建声音对象
AVAudioPlayer * player;
//现获取音乐文件所在的路径
NSString *soundPath = [[NSBundle mainBundle]pathForResource:@"Sound" ofType:@"mp3"];
//把音乐路径转化成NSURL
NSURL *soundURL = [NSURL fileURLWithPath:soundPath];
//注册声音
player=[[[AVAudioPlayer alloc] initWithContentsOfURL:soundURL error:nil] autorelease];
//准备播放
[player prepareToplay];
//播放
[player play];
//设置播放次数（-1表示循环无数次）
_player.numberOfLoops = -1;
player.delegate = self; //将当前界面设置为声音对象的代理，当音乐播放结束，声音对象会通知代理进行处理
player.currentTime //设置声音对象的当前播放时间
player.duration //获取声音对象的播放周期
player.volume //设置声音对象的音量大小
player.isPlaying//判断是否正在播放
//播放结束的时候调用
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag;
//播放出错的时候调用
-(void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error;
[UIPickerView:UIView]选择器视图<UIPickerViewDataSource,UIPickerViewDelegate>
只有固定的几种高度.
UIPickerView *pickView = [[UIPickerView alloc] initWithFrame:CGRectMake(80, 100, 200, 100)];
pickView.delegate = self;
pickView.dataSource = self;
#pragma mark - UIPickViewDelegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 2;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component) {
        return _dataArray0.count;
    }
//返回当前第一列选中的行数
NSInteger index = [pickerView selectedRowInComponent:0];
    return _dataArray.count;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component;
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component;
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    UITextField *view = (UITextField *)[self.view viewWithTag:100];
    view.text = _dataArray[row];
    [pickerView reloadComponent:1];//刷新第二列的数据
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (component) {
        return _dataArray0[row];
    }
    return _dataArray[row];
}

xml基本认识
/**
  1.第一行文字含义：固定的格式 <?xml version="1.0" encoding="utf-8" ?>
  2.节点（结点）Node
  3.子节点
  4.节点的名称，节点的值
  5.节点中属性的名称和值<Item key="1" value="A"></Item>
   */
xml解析
DOM: Document Object Model
SAX: Simple API For Xml

NSXmlParser封装的不是很好，效率不太高
libxml2
GData 基于libxml2,Google封装的，使用的比较多。

1.Gdata的使用，
2.导入GDataXml-master第三方库文件，导入libxml2.dylib系统库文件
3.给GDataxml添加 -fno-objc-arc
4.header search path : 添加 /usr/include/libxml2
GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:downloader.receiveData options:0 error:nil];
NSArray *arr = [doc nodesForXPath:@"/oschina/newslist/news" error:nil];
for (GDataXMLElement *ele in arr) {
	InfoModel *model = [[InfoModel alloc] init];
	model.pId = [[[ele elementsForName:@"id"] lastObject] stringValue];
}
[GDataXMLNode说明]
GDataXMLNode是Google提供的用于XML数据处理的类集。该类集对libxml2--DOM处理方式进行了封装，能对较小或中等的xml文档进行读写操作且支持XPath语法。
使用方法：
1、获取GDataXMLNode.h/m文件，将GDataXMLNode.h/m文件添加到工程中
2、向工程中增加“libxml2.dylib”库
3、在工程的“Build Settings”页中找到“Header Search Path”项，添加/usr/include/libxml2"到路径中
4、添加“GDataXMLNode.h”文件到头文件中，如工程能编译通过，则说明GDataXMLNode添加成功

[Xml解析之GDataXML-master]引入头文件GDataXMLNode.h
//1.创建GdataXMLDocument对象
NSString *path = [[NSBundle mainBundle] pathForResource:@"xml" ofType:@"txt"];
NSData *data = [NSData dataWithContentsOfFile:path];
//创建GData对象
//参数：1.二进制信息，2.mask信息，3.error
GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:data options:0 error:nil];
//2.取到一个节点（元素）
/**
 <root>
 <systemConfig>
 <CityName>北京</CityName>
 */
NSArray *array2 = [doc nodesForXPath:@"/root/systemConfig/CityName" error:nil];
GDataXMLElement *ele2 = [array2 lastObject];
//3.取到结点的文本信息、节点名称
NSLog(@"%@",ele2.stringValue);
NSLog(@"%@",ele2.name);
//4.取到任意结点信息，如取Item节点的信息
NSArray *array4 = [doc nodesForXPath:@"//Item" error:nil];
for (GDataXMLElement *ele in array4){
    NSArray *arr = ele.attributes;
}
//5.取属性的另一种方式，取出所有value属性对应的值，ele.name为value。
NSArray *array5 = [doc nodesForXPath:@"//@value" error:nil];
for (GDataXMLElement *ele in array5){
    NSLog(@"%@",ele.stringValue);
}
//6.取到根节点
GDataXMLElement *rootEle = doc.rootElement;
//取到所有子节点,rootEle.children
//取到子节点的个数,rootEle.childCount
//根据名称取节点
NSArray *elements = [rootEle elementsForName:@"systemConfig"];
//GDataXMLNode示例
 NSString *xmlPath = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"xml"];  
    NSString *xmlString = [NSString stringWithContentsOfFile:xmlPath encoding:NSUTF8StringEncoding error:nil];  
    GDataXMLDocument *xmlDoc = [[GDataXMLDocument alloc] initWithXMLString:xmlString options:0 error:nil];  
    GDataXMLElement *xmlEle = [xmlDoc rootElement];
    NSArray *array = [xmlEle children];  
    NSLog(@"count : %d", [array count]);  
    for (int i = 0; i < [array count]; i++) {  
        GDataXMLElement *ele = [array objectAtIndex:i];  
        // 根据标签名判断  
        if ([[ele name] isEqualToString:@"name"]) {  
            // 读标签里面的属性  
        NSLog(@"name --> %@", [[ele attributeForName:@"value"] stringValue]);  
        } else {  
        // 直接读标签间的String  
        NSLog(@"age --> %@", [ele stringValue]);  
    }         
}
[下拉刷新，上拉加载之MJRefresh-master]<MJRefreshBaseViewDelegate>
//1.引入头文件MJRefresh.h或者MJRefreshHeaderView.h和MJRefreshFooterView.h
//2.设置下拉刷新和上拉加载的实例变量MJRefreshHeaderView *_headerView;和MJRefreshFooterView *_footerView;    BOOL _isLoading;
//3.在createTableView中创建tableView之后，实例化下拉刷新和上拉加载对象，并设置代理和开始刷新
_headerView = [MJRefreshHeaderView header];
_headerView.scrollView = _tableView;
_headerView.delegate = self;
//[_tableView addSubview:_headerView];不需要添加
_footerView = [MJRefreshFooterView footer];
_footerView.scrollView = _tableView;
_footerView.delegate = self;
//[_tableView addSubview:_footerView];不需要添加

[_headerView beginRefreshing];
//4.实现MJRefresh代理中的方法
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{	//实现刷新的逻辑
    //下拉刷新时，加载新的数据
    //下载数据解析完成后，先将旧的数据源数组清空，再添加下载的数据
    if (_isLoading) {
        return;
    }
    _isLoading = YES;
    if (refreshView == _headerView) {
        _pageIndex = 0;
        [self loadListData];
    }else if (refreshView == _footerView) {
        _pageIndex ++;
        [self loadListData];
    }
}
//5.在downloadFinish方法中设置刷新成功后的操作
-(void)downloadFinish:(MyDownloader *)downloader{
	if (_pageIndex == 0) {//表示是第一次请求或者是下载刷新
    	[_dataArray removeAllObjects];
	}
    _isLoading = NO;
    [_headerView endRefreshing];//刷新结束
    [_footerView endRefreshing];
}
[下拉刷新，上拉加载之EGORefreshView]<EGORefreshTableDelegate>
//1.引入头文件EGORefreshTableHeaderView.h和EGORefreshTableFooterView.h。
//2.添加下拉刷新和上拉加载的实例变量EGORefreshTableHeaderView *_headerView和EGORefreshTableFooterView *_footerView；
//3.在cerateTableView中创建完tableView后，创建下拉刷新和上拉加载的对象，并设置代理和修改刷新时间。
//下拉刷新
_headerView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0, -_tbView.bounds.size.height, _tbView.bounds.size.width, _tbView.bounds.size.height)];
_headerView.delegate = self;
[_tbView addSubview:_headerView];
//修改刷新的时间
[_headerView refreshLastUpdatedDate];
_footerView = [[EGORefreshTableFooterView alloc] initWithFrame:CGRectZero];
_footerView.delegate = self;
[_tbView addSubview:_footerView];
//4.在viewDidAppear中设置下拉加载实例变量的frame。
-(void)viewDidAppear:(BOOL)animated{
    [self setFooterFrame];
    [super viewDidAppear:animated];
}
- (void)setFooterFrame{
    CGFloat height = MAX(_tbView.bounds.size.height, _tbView.contentSize.height);
    _footerView.frame = CGRectMake(0, height, _tbView.bounds.size.width, _tbView.bounds.size.height);   
}
//5.在downloadFinish中设置刷新成功后的操作
- (void)downloadFinish:(ZLDownloader *)downloader{
        if (_curPage == 1) {
            [_adArray removeAllObjects];
        }
        _isLoading = NO;
    }
    //刷新结束
    [self finishRefreshData];
}
- (void)finishRefreshData
{
	_isLoading = NO;
    [_headerView egoRefreshScrollViewDataSourceDidFinishedLoading:_tbView];
    [self setFooterFrame];
}
//6.实现EGORefresh代理中的方法
//滑动表格的时候
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [_headerView egoRefreshScrollViewDidScroll:scrollView];
    [_footerView egoRefreshScrollViewDidScroll:scrollView];
}
//停止滑动表格的时候
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [_headerView egoRefreshScrollViewDidEndDragging:scrollView];
    [_footerView egoRefreshScrollViewDidEndDragging:scrollView];
}
//判断是否正在刷新
-(BOOL)egoRefreshTableDataSourceIsLoading:(UIView *)view{
    return _isLoading;
}
//返回当前刷新时的时间
-(NSDate *)egoRefreshTableDataSourceLastUpdated:(UIView *)view{
    return [NSDate date];
}
//刷新的操作
-(void)egoRefreshTableDidTriggerRefresh:(EGORefreshPos)aRefreshPos{
    if (_isLoading) {
        return;
    }
    _isLoading = YES;
    if (aRefreshPos == EGORefreshHeader) {
        //下拉刷新
        _curPage = 1;
        [self loadADData];
        [self loadListData];
    }else if(aRefreshPos == EGORefreshFooter) {
        //加载更多
        _curPage ++;
        [self loadListData];
    }
}
-----------------------------------------------------------
iphone-app
开源中国社区 iPhone 客户端项目简析

注：本文假设你已经有xcode4或以上的开发环境 (建议 Xcode 4.3)
直接用双击 oschina.xcodeproj 文件启动 xcode 即可
本项目采用 GPL 授权协议，欢迎大家在这个基础上进行改进，并与大家分享。
下面将简单的解析下项目：

1、AFNetwork --- 通用网络库
2、GCDiscreetNotificationView --- 顶部弹出并会自动消失的通知栏
3、Thread --- 后台线程对象，处理后台发送带图片的动弹
4、SoftwareGroup --- 所有软件索引页以及软件分组页
5、Friends --- 好友列表页，包括粉丝与关注者
6、Search --- 搜索页
7、Favorite --- 收藏页
8、MBHUD --- 载入提示控件
9、FTColor --- 富文本显示控件
10、EGOImageLoading --- 异步图像控件
11、User --- 其他用户个人专页以及登陆用户专页
12、Comment --- 评论列表页以及发表评论页
13、AsyncImg --- 异步图像控件，总要用于列表中用户头像加载
14、Setting --- 登录，注销以及关于我们
15、Profile --- 动态页，发表留言，以及对话气泡
16、News --- 新闻，问答的列表以及所有类型的文章详情页
17、Tweet --- 动弹列表，发表动弹以及动弹详情
18、Helper --- 项目辅助类
19、TBXML --- xml解析，反序列化所有API返回的XML字符串
20、ASIHttp --- 另一种网络库，负责用户登陆以及发送带图片的动弹
21、Model --- 项目所有的实体对象
22、Resource --- 项目资源

下面是 Model 目录的子对象：

    Model
    ├ Tweet 动弹列表单元，也用于动弹详情
    ├ News 新闻列表单元
    ├ Post 问答列表单元
    ├ Message 留言列表单元
    ├ Activity 动态列表单元
    ├ Config 程序配置设置
    ├ SingleNews 新闻详情
    ├ SinglePostDetail 问答详情
    └ Comment 评论列表单元
    └ Software 软件详情
    └ Blog 博客详情
    └ Favorite 收藏列表单元
    └ SearchResult 搜索结果列表单元
    └ Friend 好友列表单元
    └ SoftwareCatalog 软件分类列表单元
    └ SoftwareUnit 软件列表单元
    └ BlogUnit 博客列表单元

项目的功能流程
1、APP启动流程

OSAppDelegate 的启动方法中，声明一个 UITabBarController，然后依次将
NewsBase
PostBase
TweetBase2
ProfileBase
SettingView
填充到5个UITabItem里
2、ipa文件生成流程

1,在OSX系统上启动iTunes程序
2,启动Xcode，将项目中的 OSChina/Products/oschina.app 按住command键然后用鼠标拖放到iTunes的应用程序栏目
3,然后在iTunes程序中右键点击"开源中国"图标，在弹出的的菜单中选择"在Finder中显示"，这样你就看到ipa文件的路径了。

KVC
//kvc:key-value-coding(键值编码)
User *user1 = [[User alloc] init];
user1.name = @"王力宏";
NSLog(@"%@",user1.name);

//一、setValue:forKey:
/*
 顺序:1)对应key值的set方法
    2)以下划线开头的成员变量
    3)同名的成员变量
    4)调用setValue:forUndefinedKey:
 */
//kvc使用一种内部元数据的机制来设置和获取我们的成员变量值
//1.kvc：可以使用setValue:forKey:方法去找到setName方法
//进行赋值
User *user2 = [[User alloc] init];
[user2 setValue:@"刘德华" forKey:@"name"];

NSLog(@"%@",user2.name);
//2.kvc:如果没有对应的setCountry方法,可以找到_country成员变量，给它赋值
[user2 setValue:@"中国" forKey:@"country"];
NSLog(@"_country:%@",user2->_country);
NSLog(@"country:%@",user2->country);
//成员变量不论是在头文件里面声明。还是在匿名类别里面声明，还是在实现部分声明的，都可以通过kvc设置它的值
[user2 setValue:@"香港" forKey:@"city"];
[user2 printCity];
[user2 setValue:@"男" forKey:@"gender"];
[user2 printGender];
//3.kvc也可以通过setValue:forKey:设置同名的成员变量值
[user2 setValue:@"朱丽倩" forKey:@"wife"];
NSLog(@"wife:%@",user2->wife);
//如果既有一下划线开头的成员变量,又又同名的成员变量,优先设置下划线开头的成员变量
//4.基本类型
//@50==[NSNumber numberWithInt:50];
[user2 setValue:@50 forKey:@"age"];
NSLog(@"age:%d",user2.age);
//5.如果找不到怎么处理
[user2 setValue:@170 forKey:@"height"];
/*
 Terminating app due to uncaught exception 'NSUnknownKeyException', reason: '[<User 0x7faf61e4fb90> setValue:forUndefinedKey:]: this class is not key value coding-compliant for the key height.'
 */
//二、valueForKey:
NSLog(@"name:%@,country:%@,city:%@,age:%@,gender:%@,wife:%@,height:%@",[user2 valueForKey:@"name"],[user2 valueForKey:@"country"],[user2 valueForKey:@"city"],[user2 valueForKey:@"age"],[user2 valueForKey:@"gender"],[user2 valueForKey:@"wife"],[user2 valueForKey:@"height"]);
/*
  Terminating app due to uncaught exception 'NSUnknownKeyException', reason: '[<User 0x7fa58970f3f0> valueForUndefinedKey:]: this class is not key value coding-compliant for the key height.'
 */
//
/*
 1)调用对应的get方法,比如name属性调用-(NSString *)name;
 2)获取以下划线开头的属性值
 3)获取同名属性值
 4)调用valueForUndefinedKey:方法
 */
//三、setValuesForKeysWithDictionary:方法就是kvc的一个具体的使用
//四、通过路径设置属性的值
House *house = [[House alloc] init];
user2.house = house;
[user2 setValue:@30 forKeyPath:@"house.price"];
NSLog(@"%d",user2.house.price);
//在没有key值得时候会调用这个方法
-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    NSLog(@"没有对应key值:%@",key);
}
//在这里根据model的颜色来修改自己的背景颜色
[KVO]，降低耦合度
//kvo：key value observing
//实现了观察者的设计模式
//设计模式是经过很长时间开发人员总结出来的一些开发的模板
//观察者对象->被观察对象
- (void)setModel:(ColorModel *)model
{
    _model = model;
    //_model是被观察者，它的属性myColor会变化
    //同时我们的当前对象(ColorView对象)需要在_model的myColor属性变化时修改自己的背景颜色
    //所以当前对象就可以作为一个观察者对象,去向_model对象注册一下将要观察的意愿,注册之后,如果_model的myColor属性变化了,就会通知当前对象,做自己需要的后续操作
    //注册观察意愿
    //第一个参数:观察者对象
    //第二个参数:需要观察什么属性的变化
    //第三个参数:要观察的是该属性的哪些值(旧值、新值)
    //第四个参数:上下文(nil)
    //_model是被观察对象
    [_model addObserver:self forKeyPath:@"myColor" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
}
//被观察者通知观察者对象的方法
//keyPath：属性路径
//object:被观察者对象
//change:传递的属性在不同状态下地值
//context:上下文
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([object isKindOfClass:[ColorModel class]]) {
        if ([keyPath isEqualToString:@"myColor"]) {
            //处理观察信息
            UIColor *old = change[@"old"];
            UIColor *new = change[@"new"];
            NSLog(@"old:%@,new:%@",old,new);
            self.backgroundColor = new;
        }
    }
}
-(void)dealloc
{
    [_model removeObserver:self forKeyPath:@"myColor"];
}

[GCD的方式创建单例]
+ (DownloadManager *)shareManager
{
    static DownloadManager *manager = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        manager = [[DownloadManager alloc] init];
    });
    return manager;
}
//苹果官方的单例模式代码
+ (id)sharedInstance  
{  
    static id sharedInstance;  
    static dispatch_once_t onceToken;  
    dispatch_once(&onceToken, ^{  
        sharedInstance = [[NSObject alloc] init];  
    });     
    return sharedInstance;  
}注：该函数接收一个dispatch_once_t用于检查该代码块是否已经被调度的谓词（是一个长整型，实际上作为BOOL使用）。它还接收一个希望在应用的生命周期内仅被调度一次的代码块。这不仅意味着代码仅会被运行一次，而且还是线程安全的，你不需要使用诸如@synchronized之类的来防止使用多个线程或者队列时不同步的问题。
Apple的GCD Documentation证实了这一点:如果被多个线程调用，该函数会同步等等直至代码块完成。
  
[SQLite之FMDatabase]FMDB (https://github.com/ccgus/fmdb) 是一款简洁、易用的封装库;使用 libsqlite3.dylib 依赖包
FMDB同时兼容ARC和非ARC工程，会自动根据工程配置来调整相关的内存管理代码。
FMDB常用类：
FMDatabase ： 一个单一的SQLite数据库，用于执行SQL语句。
FMResultSet ：执行查询一个FMDatabase结果集，这个和android的Cursor类似。
FMDatabaseQueue ：在多个线程来执行查询和更新时会使用这个类。
//创建数据库
db = [FMDatabase databaseWithPath:database_path];
1、当数据库文件不存在时，fmdb会自己创建一个。
2、 如果你传入的参数是空串：@"" ，则fmdb会在临时文件目录下创建这个数据库，数据库断开连接时，数据库文件被删除。
3、如果你传入的参数是 NULL，则它会建立一个在内存中的数据库，数据库断开连接时，数据库文件被删除。
[db open] [db close] //打开、关闭数据库，返回BOOL；
数据库增删改等操作：
除了查询操作，FMDB数据库操作都执行executeUpdate方法，这个方法返回BOOL型。
//创建表
if ([db open]) {  
   NSString *sqlCreateTable =  [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' ('%@' INTEGER PRIMARY KEY AUTOINCREMENT, '%@' TEXT, '%@' INTEGER, '%@' TEXT)",TABLENAME,ID,NAME,AGE,ADDRESS];  
   BOOL res = [db executeUpdate:sqlCreateTable];  
   if (!res) {  
      NSLog(@"error when creating db table");  
   } else {  
      NSLog(@"success to creating db table");  
   }  
   [db close];
}
//插入
NSString *insertSql1= [NSString stringWithFormat:@"INSERT INTO '%@' ('%@', '%@', '%@') VALUES ('%@', '%@', '%@')",TABLENAME, NAME, AGE, ADDRESS, @"张三", @"13", @"济南"];  
BOOL res = [db executeUpdate:insertSql1];
//修改
NSString *updateSql = [NSString stringWithFormat:@"UPDATE '%@' SET '%@' = '%@' WHERE '%@' = '%@'",TABLENAME,AGE,@"15",AGE, @"13"];
//删除
NSString *deleteSql = [NSString stringWithFormat:@"delete from %@ where %@ = '%@'",TABLENAME, NAME, @"张三"];  
BOOL res = [db executeUpdate:deleteSql];
//查询操作使用了executeQuery，并涉及到FMResultSet。
if ([db open]) {  
    NSString * sql = [NSString stringWithFormat:@"SELECT * FROM %@",TABLENAME];  
    FMResultSet * rs = [db executeQuery:sql];  
    while ([rs next]) {  
        int Id = [rs intForColumn:ID];  
        NSString * name = [rs stringForColumn:NAME];  
        NSString * age = [rs stringForColumn:AGE];  
        NSString * address = [rs stringForColumn:ADDRESS];  
        NSLog(@"id = %d, name = %@, age = %@  address = %@", Id, name, age, address);  
    }  
    [db close];  
}
数据库多线程操作：
如果应用中使用了多线程操作数据库，那么就需要使用FMDatabaseQueue来保证线程安全了。 应用中不可在多个线程中共同使用一个FMDatabase对象操作数据库，这样会引起数据库数据混乱。 为了多线程操作数据库安全，FMDB使用了FMDatabaseQueue，使用FMDatabaseQueue很简单，首先用一个数据库文件地址来初使化FMDatabaseQueue，然后就可以将一个闭包(block)传入inDatabase方法中。 在闭包中操作数据库，而不直接参与FMDatabase的管理。
[SQLite3]
对于SQL语言，有两个组成部分： 
DML（data manipulation language）：它们是SELECT、UPDATE、INSERT、DELETE，就象它的名字一样，这4条命令是用来对数据库里的数据进行操作的语言。 
DDL（data definition language）：DDL比DML要多，主要的命令有CREATE、ALTER、DROP等，DDL主要是用在定义或改变表（TABLE）的结构，数据类型，表之间的链接和约束等初始化工作上，他们大多在建立表时使用。
-- 建立数据库
sqlite3 test.db
create table test (id integer primary key, value text);
insert into test (id, value) values(2,'meenie');
insert into test (value) values('mo');
.mode column .headers on select * from test;
select last_insert_rowid(); -- 找出最后一个插入的元素的id
-- 添加一个索引和视图
create index test_idx on test (value);
create view schema as select * from sqlite_master;
.tables[pattern] 显示所有表和视图的列表
.indices[table name] 显示一个表的索引
.schema[table name] 显示一个表或视图的定义语句(DDL)，显示创建一个表的sql语句。
type -- 对象类型(table/index/trigger/view)
name -- 对象名称
tbl_name -- 对象关联的表
Rootpage -- 对象根页面在数据库的索引（开始的编号）
sql -- 对象的SL定义（DDL）
-- 查询当前数据库的sqlite_master表
.mode col
.headers on 打开头部显示，之后当使用SELECT语句时，每一列都会显示头部。
select type, name, tbl_name, sql from sqlite_master order by type;-- 会显示test.db对象的完整清单，包括：一个表、一个索引、一个视图，和每个各自最初的DDL创建语句。
.dump -- 导出数据，适合重新创建数据库对象和其中的数据，默认情况下，.dump命令的输出定向到屏幕。将整个表的内容转储成SQL语句。
.output file.sql -- 将输出重定向到文件，如果该文件存在，将被覆盖
.dump -- 导出数据
.output stdout -- 恢复输出到屏幕
[导入数据]根据导入文件的格式，有两种导入方法
.read -- 用来导入.dump创建的文件
.import [file] [table] -- 此命令将解析指定的文件并尝试将数据插入指定的表中。如果文件是由逗号或其他分隔符分隔的值(comma-separated values, CSV)组成，使用这种方法导入数据。
.separator -- 指定不同的分隔符
.show -- 显示用户shell中定义的所有设置，所以也包含当前默认的分隔符
[格式化]CLP提供的格式化选项命令可以使得结果集和输出更简洁整齐。
.echo -- 回显输入的命令
.headers -- 设为 on 时，查询结果显示时带有字段名。
.nullvalue NULL -- 以一个字符串NULL来显示null值，默认情况下null显示的是空串。
.prompt 'sqlite3>' -- 将CLP的shell提示符改为sqlite3>
.mode -- 设置结果数据的输出格式，可选的格式有：csv/column/html/insert/line/list/tabs/tcl;默认是list，list格式显示结果集时，列间以默认的分隔符分隔。
-- 将结果输出到csv文件的一个例子：
.output file.csv
.separator ,	-- 也可通过.mode来使用系统定义的CSV模式，不同的是会给字段值加上双引号
select * from test where value like 'm%'; -- m开头
.output stdout
--将CSV数据导入到与test表结果类似的表
creat table test2(id integer primary key, value text);
.import file.csv test2 -- 将数据导入数据库
[无人值守维护]
sqlite3 test.db .dump > test.sql //test.sql文件中包含数据库test.db所有可读的DDL和DML语句
sqlite3 test.db "select * from test" > test.txt //直接在bash shell中执行命令即可
sqlite3 test2.db < test.sql //直接从数据库dump文件中创建新的数据库
从文件创建数据库的另一种方式是使用init选项，并将test.sql作为参数：
sqlite3 -init test.sql test3.db .exit //不加.exit命令将进入CLP shell模式
[备份数据库]由于SQLite数据库包含在单个文件中，所以只需复制文件即可进行备份。对于长期备份，最好将数据库转储成SQL各式，因为这样是跨SQLite版本的，进行下面两个分别的命令：
sqlite3 test.db .dump > test.sql //备份数据库创建命令
.output file.sql
.dump
.output stdout
.exit     //备份数据库中数据
-------------------------------
[获取数据库文件信息]工具 SQLite Analyzer
其他工具：SQLite Database Browser:允许用户管理数据库、表和索引，以及导入导出这些对象。
[sqlite中的字段值， 常量, constants,表示确切的值]
字符串常量，由单引号引起的一个或多个字母或数字字符组成；如果字符串本身也包含单引号，则需要连续两个单引号，如'Kenny''s chicken'。
数字常量，整数、十进制、科学计数法
二进制常量：x'0fff'以十六进制表示
[创建表]
create [temp] table table_name (column_definitions [, constraints]);//方括号中的内容是可选的
temp或temporary关键字声明的表是临时表
[修改表]使用alter table命令改变表的部分结构，如改变表名，增加字段
alter table table_name { rename to name | add column column_def }
eg: alter table contacts add column email text not null default '' collate nocase;
[select命令从from开始，接收一个或多个输入关系；将它们组合成单一复合关系；传递给后续操作链]
select [distinct] heading
	from tables
	where predicate
	group by columns
	having predicate
	order by columns
	limit count,offset;
select * from foods where name='JujyFruit' and type_id=9;
select burger
	from kitchen
	where patties=2
	and toppings='jalopenos'
	and condiment != 'mayo'
	limit 1;
[二元操作符] <>和!= 都表示不等于.
like字符串匹配，name like 'J%'匹配J开头的name值的信息，%是贪婪匹配，匹配0个或多个字符。
select id,name from foods where name like '%ac%P%' and name not like '%Sch%' -- 使用NOT否定某些模式
glob文件名匹配,与like操作符类似，关键的不同在于它有些像UNIX/Linux文件名替换语法。也就是说，它会使用文件名替换相关的通配符，例如*和_，并且匹配是大小写敏感的。
select id, name from foods where name glob 'Pine*';//匹配以Pine开头的name值的信息。等同于like的%。
sqlite中，false可以由数字0代替，true由非0值代替
limit指定返回记录的最大数量
offset指定偏移的记录数
select * from food_types order by id limit 1 offset 1; -- 关键字offset在结果集中跳过一行，limit限制最多返回一行数据。
order by子句的语法与select子句语法类似：以逗号分隔的一系列字段，每个字段项都可以配合排序方向，asc(升序，默认)或desc(降序)。
select * from foods where name like 'B%' order by type_id desc, name limit 10; -- 
注：limit和offset同时使用时，可用逗号代替offset关键字。limit 1 offset 2;等同于limit 2,1; -- 在sqlite中，使用缩写时，offset总是优先于limit，也要注意offset依赖于limit。
[函数和聚合]sqlite提供了多种内置的函数和聚合，可以用在不同的子句中。函数的种类包括: 数学函数(如计算绝对值的abs())、字符串格式函数、将字符串的值转化为大写或小写的upper()和lower()。函数名不区分大小写。
select upper('hello newman'), length('hello newman'), abs(-12);
select id, upper(name), length(name) from foods 
		where type_id=1 limit 10;
select id, upper(name), length(name) from foods
        where length(name) < 5 limit 5;
聚合(对表中的每一行做某种操作)是一类特殊的函数，它从一组记录中计算聚合值。标准的聚合函数包括sum()/avg()/count()/min()/max()。
select count(*) from foods where type_id=1; -- count()聚合返回关系中所有行的数目。
聚合不仅可以聚合字段，也可以聚合任何表达式，包括函数。
select avg(length(name)) from foods;-- avg()计算出指定集单元中的非空值的平均值
select type_id, count(*) from foods group by type_id; -- 找出所有的type_id,并输出各组的元素数量 ，使用group by时，select子句对每组单独应用聚合，而不是对整个结果进行聚合
select type_id, count(*) from foods
        group by type_id having count(*) < 20;-- 在上面的基础上只返回数量小于20的组。断言count(*)<20应用到所有的组上，任何不满足这一条件的结果都无法传递到select子句。
注：having是一个可以应用到group by的断言。它从group by中过滤组的方式与where子句从from子句过滤行的方式相同。唯一不同的是，where子句的预测是针对单个行的，而having的断言是针对聚合值的。
注：group by和having一起工作可以对where有约束。group by接收where子句的约束，将结果行分成共享某值的组，having对每组应用过滤，通过过滤的组传递给select子句来做聚合和映射。
select distinct type_id from foods; -- 从foods表中取得所有不同的type_id，distinct处理select的结果并过滤掉其中重复的行。
[多表连接join]连接(join)是多表(关系)数据工作的关键，它是select命令的第一个操作。连接操作的结果作为输入，供select语句的其他部分(过滤)处理。
--sqlite支持六种不同类型的连接---
-- 内连接，通过表的两个字段进行连接，也就是关系代数的求交集，可通过维恩图展示。
select foods.name, food_types.name
        from foods, food_types
		where foods.type_id=food_types.id limit 10;-- 连接表时，使用table_name.column_name是一种非常好的避免歧义的方式。
Select * from foods inner join food_types on foods.id = food_types.id;-- 内连接
-- 交叉连接，也称为笛卡尔积或者交叉乘积。在这种连接中，行之间不存在关系，也没有连接条件，只是简单地组合在一起，是几乎无意义的连接。
select * from foods, food_types;
-- 左外连接：不管是否匹配，左边的行都会包含在结果集中。
select * from foods left outer join foods_episodes on foods.id=foods_episodes.food_id; -- 会将所有匹配的行都包含在结果集中，而左表foods中没有匹配foods_episodes的剩余行也会出现在结果集中，当foods_episodes没有提供相应的行时，它会以null补充。
-- 目前，sqlite不支持右外连接和全外连接。可以通过复合查询实现。
select * from foods, food_types where foods.id=food_types.food_id; -- 从语法上讲，可以通过各种方式指定连接。当列出多个表时，默认会做连接操作，最低限度也会做交叉连接。应该避免的过时语法。
-- SQL中正确表达连接的方法是(SQL92中规定的)使用连接关键字：
select heading from left_table join_type right_table on join_condition;
select * from foods inner join food_types on foods.id=food_types.food_id;
select * from foods left outer join food_types on foods.id=food_types.food_id;
select * from foods cross join food_types;
[名称和别名]别名实际上是一种重命名的关系操作，来将简单地一个关系命名成另一个关系。
Select base-name [[as] alias] ...    -- as是可选的。
select f.name, t.name
	from foods f, food_types t 
	where f.type_id = t.id
	limit 10; -- 可以在from子句中对表重命名，然后在其它的地方直接使用。
-- 别名实现自我连接。
select f.name as food, e1.name, e1.season, e2.name, e2.season
	from episodes e1, foods_episodes fe1, foods f,
		 episodes e2, foods_episodes fe2
	where
		(e1.id = fe1.episode_id and e1.season = 4) and fe1.food_id = f.id
		and (fe1.food_id = fe2.food_id)
		and (fe2.episode_id = e2.id AND e2.season != e1.season)
	order by f.name;
[子查询]
子查询或内部查询或嵌套查询是另一个SQLite查询和嵌入在WHERE子句中的查询。
使用子查询返回的数据将被用来在主查询中作为条件，以进一步限制要检索的数据。
[复合查询]
[条件结果]
[DML语句]
[insert]insert into table (column_list) values (values_list); -- 变量column_list为用逗号分隔的字段名称，这些字段必须在表中存在。变量value_list是用逗号分隔的值列表，这些值与column_list中的字段一一对应。
insert into foods (name, type_id) values ('Cinnamon Bobka', 1);
select max(id) from foods;
select last_insert_rowid();-- 返回最后一个自增长的值
注：如果在insert语句中为表的所有字段提供值，可以省略字段列表。
insert into foods values(NULL, 1, 'Blueberry Bobka');-- 省略字段列表时，insert中的值列表顺序必须和待插入表中字段的顺序一致；第一个参数指定null，表示不提供值，会自动触发自增长值的产生。
-- 子查询可以用在insert语句中，既可作为值列表的一部分，也可以完全替代整个值列表。指定子查询为值列表时，实际上是在插入一组行，因为子查询返回的通常是一组行。
insert into foods
	values (null,
    	(select id from food_types where name='Bakery'),
       	'Blackberry Bobka');
insert into foods
select null, type_id, name from foods
	where name='Chocolate Bobka';-- 本例使用select语句完全替代了值列表。只要select子句的字段数目和要插入的表的字段数目匹配，或者与提供的字段列表匹配，insert语句就可以正常工作。
create table foods2 (id int, type_id int, name text);
insert into foods2 select * from foods;-- 插入表foods的所有记录
create table foods2 as select * from foods;-- 直接从select语句创建表，使用ceate table这种形式时，要意识要源表的任何约束是否定义在新表中，特别是，自增长字段不会在新表中创建，索引也不会创建，UNIOUE约束等都不会创建。
[update]用于更新表中的记录，该命令可以修改一个表中一行或多行中的一个或多个字段。一般格式为：
update table set update_list where predicate;-- update_list 是一个或多个字段赋值(column_name=value)的列表。
update foods set name='CHOCOLATE BOBKA' where name='Chocolate Bobka';
[delete]一般格式为：
delete from table where predicate;
delete from foods where name='CHOCOLATE BOBKA';
[数据完整性]-用于定义和保护表内部或表之间的数据关系
--域完整性-涉及控制字段内的值
--实体完整性-涉及表中的行
--引用完整性-涉及表之间的行，具体的讲，就是外键关系
--用户定义完整性-
注：约束也是表定义的一部分，他们可以和字段定义或者表定义实体关联起来。
字段级的约束包括，not null/ unique/ primary key/ foreign key/ check/ collate.
表一级的约束包括，primary key/ unique/ check.
[唯一性约束，unique]unique约束是主键的基础。unique约束要求一个或一组字段的所有值互不相同。主键由至少带有unique约束(唯一性约束)的一个或一组字段组成。
unique约束可以在字段级和表级定义：在表级定义时，唯一性可以应用到多个字段中，这种情况下，这些字段值的联合必须是唯一的。
--NULL和unique，sqlite中定义为unique约束的字段可以放入任意多个NULL。因为NULL不等于任何值，甚至不等于其他NULL。PostgreSQL和Oracle数据库对NULL的处理方式和sqlite一样；Informix、Sybase、SQL Server只能插入一个NULL；DB2禁止插入NULL。
--SQLite使用64-bit单符号整数主键，该字段最大值为2^63 - 1;当主键整数值达到最大值时，SQLite会开始搜索该字段还未使用的值，并作为将要插入的值。从表中删除记录时，rowid可能被回收并在后面的插入中使用。因此新创建的rowid不一定是按照严格顺序增长的。
注：不要认为或者假定关系数据库的数据具有某种特定的顺序--即使直觉告诉你这样做是安全的。记得order by。
--如果想在SQLite中使用唯一的自动主键值，而不是‘填补空白’，可以在主键定义integer primary key 中加入关键字autoincrement。如果字段中包含autoincrement约束，SQLite会在一个名为sqlite_sequence的系统表中记录该字段当前的最大值，它在后面的insert语句中只使用比当前值大的值，如果达到了绝对最大值，SQLite会在后面的insert语句中返回SQLITE_FULL。1.虽然SQLite在系统表sqlite_sequence中中追踪autoincrement字段的最大值，但它不会阻值你在insert语句中自己提供值，只是要求你提供的值必须是该字段唯一的。
--像唯一性约束一样，主键约束也可以定义在多个字段中。主键也不一定要使用整型值，如果选择使用其他的值，SQLite内部仍然维护rowid字段，它也在你定义的主键上实施唯一性约束。
create table pkey(x text, y text, primary key(x,y));--本例中的主键从技术上讲横跨两个字段，具有唯一性约束。
[域完整性domain]字段中的值必须是字段定义范围内的。域处理两件事：类型和范围。
name text not null collate nocase;--name字段域是除了null值之外的所有text，并且大小写不敏感。
-域完整性分为：类型检查和范围检查。
--默认值，关键字default保证该字段有值，并在需要时出现。如果字段没有默认值，并在insert语句中没有提供指定值，SQLite将为该字段自动赋值null。
--default还可接受3中预定义格式的ANSI/ISO保留值，用于生成日期和时间值。current_time将会生成(hh:mm:ss)格式的当前时间。current_date会生成(yyyy-MM-dd)格式的当前日期。current_timestamp会生成(yyy-MM-dd hh:mm:ss)格式的日期时间的组合。
create table times ( id int,
	date not null default current_date,
	time not null default current_time,
	timestamp not null default current_timestamp );
insert into times (id) values (1);
insert into times (id) values (2);
select * from times;//这些默认值对于需要记录日志或时间戳事件非常有用。
--NOT NULL约束，not null可以确保该字段值不为NULL，insert语句不能向该字段插入NULL，update语句也不能将该字段已存在的值修改为NULL。处理未知数据和NOT NULL约束的实用方法是给字段设定默认值。
--check约束，允许定义表达式来测试要插入或者更新的字段值。如果该值不满足设定的表达式标准，数据库会报约束违反错误。
create table contacts ( id integer primary key,
	name text not null collate nocase,--定义字段的排序规则，忽略大小写
	phone text not null default 'UNKNOWN',
	unique (name,phone),
	check (length(phone)>=7) );--确保电话号码最少7位数字。
--外键约束。关系完整性也叫外键，它确保了一个表中的关键值必须从另一个表中引用，且该数据必须在另一个表中实际存在。经典的例子就是父子关系、主从关系以及订单和商品这样的关系。
create table foods(
  id integer primary key,--设置主键
  type_id integer references food_types(id) --设置外键，type_id引用自表food_type的id字段。
  on delete restrict
  deferrable initially deferred,--这只delete restrict约束，如果当从food_types中删除某行将导致foods表中的id没有父id时，禁止删除。
  name text );
--完整性规则定义如下：
set null --如果父值被删除或不存在后，剩余的子值将改为null。
set default --如果父值被删除或者不存在了，剩余的子值将修改为默认值。
cascade --更新父值时，更新所有预知匹配的子值。删除父值时，删除所有子值。
restrict -- 如果更新或删除父值时会出现孤立的子值，就阻止(终止)事务。
no action --使用一种松弛的方法，不干涉操作执行，只是观察变化。在整个语句的结尾报出错误。
注：SQLite支持deferrable子句，该子句控制定义的约束是立即强制实施还是延迟到整个事务结束时。
--排序规则，涉及文本值如何比较。
--SQLite有三种内置的排序规则，默认是二进制排序规则，该规则使用C函数memcmp()逐字节比较文本值。对于英语等是合适的。第二种，nocase是拉丁字母中使用的26个ASCII字符的非大小写敏感排序算法。第三种，是reverse排序规则，它与二进制排序规则相反，更多地被用来测试。
name text not null collate nocase,--关键字collate定义字段的排序规则，本例中忽略大小写。SQLite排序规则默认是大小写敏感的。
--存储类。SQL函数typeof()根据值的表示法返回其存储类。
select typeof(3.14), 		--real实数
		typeof('3.14'),		--text文本
		typeof(314), 		--integer整数值
		typeof(x'3142'), 	--blob二进制
		typeof(NULL);		--NULL存储类
--注：SQLite中单独的一个字段可以包含不同存储类的值。这也是SQLite处理数据与其他数据库不同的第一个地方。
create table domain(x);
insert into domain values (3.142);
insert into domain values ('3.142');
insert into domain values (3142);
insert into domain values (x'3142');
insert into domain values (null);
select rowid, x, typeof(x) from domain;
--如上，具有不同存储类的值可以存储在同一个字段中。可以被排序，因为这些值可以相互比较。SQLite通过一种叫做‘类值’的定义规则来对不同存储类的值进行排序。
--1. NULL具有最低的类值。在NULL之间没有具体的排序顺序。
--2. integer和real存储类的类值相等，高于NULL。它们之间通过其数值比较。
--3. text的类值高于integer和real。两个text值通过该值定义的排序法决定。
--4. blob具有最高的类值。blob类的值大于其他所有类的值，blob之间使用memcmp()函数比较，即比较比特位。
--[视图]即虚拟表，也称为派生表，因为它们的内容都派生自其他表的查询结果。视图看起来就像基本表一样，但他们不是基本表，基本表的内容是持久的，而视图的内容是使用时动态产生的。
create view name as select-stmt;--视图名称由name指定，其定义由select-stmt定义。最终生成的视图看起来就像是名为name的基本表，就像是有一个一直在运行的查询。
select f.name, ft.name, e.name
	from foods f
	inner join food_types ft on f.type_id=ft.id
	inner join foods_episodes fe on f.id=fe.food_id
	inner join episodes e on fe.episode_id=e.id;--该查询返回所有food的名称以及所在的系列。查询结果是个多达504行的大表，我们不用每次需要这些结果时都写出前面的查询，可以将他们整理成名为details的视图形式：
create view details as
	select f.name as fd, ft.name as tp, e.name as ep, e.season as ssn 
	from foods f
	inner join food_types ft on f.type_id=ft.id
	inner join foods_episodes fe on f.id=fe.food_id
	inner join episodes e on fe.episode_id=e.id;
--可以像查询表一样查询details:
select fd as Food, ep as Episode
    from details where ssn=7 and tp like 'Drinks';--视图的内容是动态生成的，因此，每次使用details时，基于数据库的当前数据执行相关的SQL语句，返回结果。
drop view name;--删除名为name的视图。
--注：SQLite不支持可更新的视图，使用触发器可以创建类似的东西。
--索引：创建索引时，一定要有理由确保可以获得性能的改善。
--触发器：当具体的表发生特定的数据库事件时，触发器执行对应的SQL命令。
create [temp|temporary] trigger name
	[before|after] [insert|delete|update|update of columns] on table
	action;--触发器通过名称、行为和表来定义。行为(触发体)由一系列SQL命令组成，当某些事件发生时，触发器负责启动这些命令。
--触发器可以用来创建自定义完整性约束、日志改变、更新表等等很多事情。注意触发器的作用只限于所写的SQL命令。
create temp table log(x);--创建一个名为log的临时表。
--在表foods的name字段上创建一个临时的update触发器
create temp trigger foods_update_log update of name on foods
begin -- 该触发器执行时，会向log表插入一条消息。
	insert into log values('updated foods: new name=' || new.name);
end;
begin;-- 该事务的第一步更新name为JUJYFRUIT所在的行的name字段，这将促使update触发器执行。当触发器执行时，它会向log插入一条记录。
	update foods set name='JUJYFRUIT' where name='JujyFruit';
	select * from log; --事务的第二步。
rollback;--回滚刚才的改变
--连接结束时，销毁log表和update触发器。
--SQLite支持在update触发器中对未更新行(最初的行)和已更新行的访问。未更新行引用为old，已更新行引用为new。old/new的所有属性都可以通过点号访问。new.type_id
--错误处理：定义为时间发生前执行的触发器有机会阻值事件的发生，定义为事件发生后执行的触发器可以检查事件，具备重新思考的机会。
raise(resolution, error_message);--第一个参数是冲突解决策略(abort/fail/ignore/rollback等)，第二个参数是错误消息。
--可更新的视图：先创建一个视图，然后创建负责处理视图上更新事件的触发器。
create view foods_view as -- 该视图通过外键关系连接两个表。
	select f.id fid, f.name fname, t.id tid, t.name tname
	from foods f, food_types t;

create trigger on_update_foods_view -- 创建update触发器，实现可更新的视图。
instead of update on foods_view -- 使用instead of替代触发器的定义
for each row
begin
	update foods set name=new.fname where id=new.fid;
	update food_types set name=new.tname where id=new.tid;
end;

.echo on
-- Update the view within a transaction
begin;
update foods_view set fname='Whataburger', tname='Fast Food' where fid=413;
-- Now view the underlying rows in the base tables:
select * from foods f, food_types t where f.type_id=t.id and f.id=413;
-- Roll it back
rollback;
-- 也可以添加insert、delete触发器实现通过视图控制数据。
--事务：事务定义了一组SQL命令的边界，这组命令或者作为一个整体被全部执行，或者都不执行，这被称为数据库完整性的原子性原则。
--事务的范围：事务由三个命令控制:begin/commit/rollback。begin之后的所有操作都可以取消，如果连接终止前没有发出commit，也会被取消。commit提交事务开始后所执行的所有操作。rollback还原begin之后的所有操作。
--默认情况下，SQLite中的每条SQL语句自成事务，也称为自动提交模式:SQLite以自动提交模式运行单个命令，如果命令没有失败，那它将自动提交。
--SQLite也支持savepoint和release命令。包含多个语句的工作体可以设置savepoint，回滚可以返回到某个savepoint。savepoint就像是汇编语言中的跳转标签。
savepoint justincase; --创建并启动一个名为justincase的savepoint。
rollback [transaction] to justincase; --返回设置justincase的地方，而不会回滚整个事务。
--冲突解决。SQLite提供5种冲突解决方案或策略，它们可以用来解决冲突(约束违反): replace/ignore/fail/abort/rollback。这5种方法定义了错误的容忍范围或敏感度。遇到约束违反时，默认行为是终止命令并回滚所有的修改。
[数据完整性]-用于定义和保护表内部或表之间的数据关系
--域完整性-涉及控制字段内的值
--实体完整性-涉及表中的行
--引用完整性-涉及表之间的行，具体的讲，就是外键关系
--用户定义完整性-
--锁，SQLite使用锁逐步提升机制，为了写数据库，连接必须逐级升级获得排它锁，五种不同的锁状态
--未加锁unlocked，最初的状态，在此状态下，连接还没有访问数据库，当连接一个数据库时，甚至已经用begin开始了一个事务时，连接都还处于未加锁状态。
--共享shared，当从数据库读数据时，连接必须首先进入共享状态，也就是说首先要获得一个共享锁。多个连接可以同时获得并保持共享锁。也就是说，多个连接可以同时从同一个数据库读取数据，但哪怕只有一个共享锁还没释放，也不允许任何连接写数据库。
--预留reserved，当向数据库写数据时，必须首先获得一个预留锁。一个数据库同时只能有一个预留锁，该预留锁可以与共享锁共存，他是写数据库的第一个阶段。预留锁既不阻止其它拥有共享锁的连接继续读数据库，也不阻止其它连接获得新的共享锁。一旦一个连接获得了预留锁，他就可以开始处理数据库修改操作了，而这些修改还保存在内存缓冲区中，不是实际写到磁盘。
--未决pending，当连接想要提交修改(事务)时，需要将预留锁提升为排他锁。为了得到排他锁，还必须首先加预留锁提升为未决锁。获得未决锁后，其它连接就不能再获得新的共享锁了，当已经拥有共享锁的连接仍然可以继续正常读数据库。此时，拥有未决锁的连接等待其它拥有共享锁的连接完成工作并释放其共享锁。
--排它excusive，一旦所有的其它共享锁都被释放，拥有未决锁的连接就可以将其锁提升至排它锁，此时就可以自由的对数据库进行修改。所以此前所有缓存的修改都会被写到数据库文件中。
--事务的类型
begin [ deferred | immediate | exclusive ] transaction;
--仅仅使用begin开是一个事务，那么事务就是延迟的，停留在未锁定状态(默认是deferred)。多个连接可以在同一个时刻未创建任何锁的情况下开始延迟事务，这种情况下，第一个对数据库的读操作获取共享锁，类似的，第一个对数据库的写操作视图获取预留锁。
--由begin开始的immediate事务在begin执行时试图获取预留锁。如果成功，begin immediate保证没有其他连接可以写数据库。预留锁的另一个结果是，没有其他连接能成功启动begin或者begin exclusive命令。这时可以对数据库进行修改，但还不能提交，需要等到其他的操作全部完成后才能提交事务。
--由begin开始的exclusive事务会试着获取排它锁，这与immediate工作方式类似，但一旦成功，exclusive事务保证数据库中没有其他的活动连接，所以就可以对数据库进行任意的读写操作。
--基本的准则：如果使用的数据库没有其他连接，用begin就足够了；如果使用的数据库有其他也会对数据库进行写操作的连接，就得使用begin immediate或begin exclusive开始事务。
--[附加数据库]
--SQLite允许用attach命令将多个数据库"附加"到当前连接上。当附加了一个数据库时，他的所有内容在当前数据库文件的全局范围内都是可存取的。
attach [database] filename as database_name;--filename指SQLite数据库的文件名和路径，database_name指要引用的数据库和对象的逻辑名称。
detach [database] database_name; --将数据库分离
--[数据库清理]
--reindex collation_name;--重建所有使用指定排序名称的索引。
--rdindex table_name|index_name;
--vacuum通过重构数据库文件清理那些未使用的空间。
--数据库的大小可以通过编译指示auto_vacuum自动保持在最小值。(为了支持这种功能，数据库内部需要存储额外的信息，这将导致数据库文件比不启用auto_vacuum的稍微大一些。vaccum命令对使用auto_vacuum的数据库不起作用)。
sqlite> pragma cache_size;--取出当前数据库默认的缓冲区大小
pragma cache_size=1000;--设置当前数据库默认的缓冲区大小
--使用default_cache_size编译指示为所有的连接设置永久缓冲区的大小，这种设置可以存储在数据库中，且只对之后的连接生效，当前连接不受影响。
pragma database_list;--列出所有附着的数据库
pragma index_info(foods_name_type_idx);--列出索引内字段的相关信息，索引名作为参数。
pragma index_list(foods);--列出表中的索引信息，表名作参数
pragma table_info(foods);--列出表中所有字段的相关信息。
--[写同步]通常情况下，SQLite会在关键时刻将所有的变化提交到磁盘以确保事务的持久性。这类似于其他数据库的检查点功能。但是，考虑到性能因素，可以关闭这一功能，可以通过编译指示synchronous来实现。该编译指示有三种设置：full/normal/off。
--[临时存储器temp_store[ default|file|memory]/temp_store_directory
--编译器指示temp_store明确是否使用RAM或基于文件的存储。如果采用基于文件的存储，可以使用编译指示temp_store_directory来明确在何处创建存储文件。]
--[系统目录]sqlite_master表是系统表，包含数据库中的所有表、视图、索引、触发器的信息。
select type, name, rootpage from sqlite_master;--type字段说明对象的类型，name为对象的名称，rootpage指对象的第一个B-tree页面在数据库文件中的位置。
--sqlite_master表还包含用来创建存储对象的DDL(SQL语言)。
select sql from sqlite_master where name = 'foods_update_trg';
--[查看查询计划]使用explain query plan 命令可以查看SQLite执行查询的方法，该命令会列出SQLite执行查询时访问处理表和数据的具体步骤。格式为：explain query plan 后跟上正常的查询文本。
explain query plan select * from foods where id = 145;--查询计划可以看到哪些地方何时、如何使用索引，以及表连接时的顺序。
--[SQLite有关的C API]
sqlite3--连接对象
sqlite_stmt--语句对象，包括：字节码、执行命令和迭代结果集所需的所有其他资源。
sqlite3_open --连接或打开数据库
--一个连接对象可以连接到多个数据库对象---一个主数据库和多个附加数据库。每个数据库对象都有一个B-tree和相应的一个pager对象。
--[执行预查询
--准备：由sqlite3_prepare_v2()函数完成，
--执行：执行是个逐步的过程，由sqlite3_step()发起。对于select语句，sqlite3_step()每次调用将使语句句柄的游标位置移动到结果集的下一行。当游标未达到结果集的末尾时，返回SQLITE_ROW，反之会返回SQLITE_DONE。对于其他SQL语句(insert/update/delete等)，第一次调用sqlite3_step()将促使VDBE执行整个命令。
--完成：VDBE关闭语句并释放资源。由sqlite3_finalize()执行。该函数使VDBE终止程序、释放资源并关闭statement句柄。
--每一步(准备、执行、完成)对应statement句柄各自的状态(准备状态、活动状态、完成状态)。]
--[参数化SQL。下面为两种形式的参数绑定。位置和命名
insert into foods (id,name) values(?,?);--使用位置参数
insert into episodes (id,name) (:id, :name);--使用命名参数
--参数绑定的优点是无须重新编译，就可以多次执行相同的语句。只需重置该语句、绑定新值、并重新执行。
sqlite3_reset();--重置语句，只释放语句资源，保持VDBE字节代码及其参数不变。
--参数绑定的另一个优点是SQLite会处理绑定到参数的转义字符。例如参数值为"Kenny's Chick"，参数绑定过程自动将其转换为"Kenny''s Chick"--将单引号转义为两个单引号。]
--[封装查询。共两个方法，大多数扩展将第一个方法引用为exec(),第二个引用为get_table()。
sqlite3_exec();--通常用来执行不返回数据的查询。
sqlite3_get_table();--通常用来执行返回数据的查询。
--函数exec()执行insert/update和delete语句或用于创建和销毁数据库对象的DDL语句。exec()能一次处理和运行以分号分隔的多个SQL语句字符串。如果传递给它的多个语句并且其中一个失败了，exec()会在那个失败命令处终止，返回相关的错误代码。
--函数get_table()会在内存中返回完整的结果集，结果集的展示方式取决于扩展。get_table的优点是它一步就可以执行查询并获得结果，其缺点是它将结果完全存储在内存中。]
--[错误处理，
sqlite3_errcode()-- 该函数返回最后一个被调用函数的返回代码
sqlite3_errmsg()-- 该函数返回更详细的错误信息，提供最后一个错误的详细信息。
if db.errcode() != SQLITE_OK
	print db.errmsg(stmt) -- 使用这种方式返回错误信息]
--[钩子函数/回调函数
sqlite3_commit_hook() --用于监视连接上的事务提交
selite3_rollback_hook() --用于监视回滚
sqlite3_update_hook() --用于监视来自insert/update/delete命令的更改操作
sqlite3_set_authorizer() --编译时钩子。该函数几乎提供对数据库中发生的一切事件的细粒度控制，并能够限制对数据库、表和列的访问和修改。]
--[创建自定义聚合;例子为称为pusum的简单SUM()聚合例子。
connection = apsw.Connection("foods.db")
def step(context, *args): context['value'] += args[0]
def finalize(context): return context['value']
def pysum(): return ({'value' : 0}, step, finalize)
connection.createaggregatefunction("pysum", pysum)
c = connection.cursor()
print c.execute("select pysum(id) from foods").next()[0]
--说明：函数createaggregatefunction()注册聚合，传入step()函数和finalize()函数。SQLite传递给step()一个上下文环境参数，该上下文用来存储step()调用之间的中间值。本例用于计算总和。处理完最后一条记录后，调用finalize()。这里的finalize()返回聚合的总和。SQLite自动清理上下文环境。]
--[事务生命周期: 读事务、写事务
--读事务，从select语句的锁进程开始，执行select语句的连接启动事务，从未锁定转到共享锁，提交之后回到未锁定状态，操作结束。
--写事务，
]
--[使用恰当的事务
--进行数据库写操作，需要发出begin IMMEDIATE命令。如果得到SQLITE_BUSY，那么至少知道在什么状态，知道可以安全的继续尝试而不会阻挡另一个连接，一旦成功，知道自己处于什么状态(保留锁)，现在如果必须的话，可以使用蛮力，因为这是当前唯一正确的连接。如果使用begin exclusive启动，这种情况下是正在以独占方式工作，与保留锁相比，这对并发并不好。
--SQLite通过对数据库文件加锁来处理并发性。SQLite完全依赖于文件管理系统并发使用的锁。无论是在正常的文件系统中还是在网络文件系统中，SQLite均使用相同的锁定机制。它在UNIX/Linux上使用POSIX建议锁，在Windows上使用LockFile()、LockFileEx()、UnlockFile()系统调用。这些调用是标准的系统调用，在正常的文件系统上能正常工作。网络文件模拟正常的文件系统工作。
--注：在写另一个连接之前始终要调用finalize()或reset()。在自动提交模式下，step()和finalize()常常是是事务和锁定的边界。在它们之间处理其他连接应该特别注意。 ]
--[共享缓存模式：在共享缓存模式中，一个线程可以创建共享相同页面缓存的多个连接。该组连接可以同一时间在同一数据库中有多个读操作和一个写操作(独占)工作。困难在于这些连接不能在线程间共享-他们被严格限制在创建他们的线程内。
--[核心C-SQLite3 API
int sqlite3_open_v2( -- 打开数据库P172
	const char *filename,	--数据库文件名UTF-8
	sqlite3 **ppDb,			--OUT:SQLite数据库的句柄
	int flags,				--标志
	const char *zVfs		--要使用的VFS模块的名称
);
int sqlite3_close(sqlite3*);	--关闭数据库连接,该函数要成功执行，必须完成与连接关联的所有准备查询。只要有一个查询未完成，都会返回SQLITE_BUSY的错误信息。
注：使用sqlite3_close()关闭连接时，如果连接上有打开的事物，该事务将自动回滚。
int sqlite3_exec(		--执行SQL命令的便捷函数
	sqlite3*,			--打开的数据库
	const char *sql,	--要执行的SQL
	sqlite_callback,	--回调函数
	void *data,			--回调函数的第一个参数
	char **errmsg		--错误信息
);
注：参数SQL中可以包含多个SQL命令，sqlite3_exec()将解析和执行SQL字符串中的每个命令，直到到达该字符串的末尾或遇到错误。可通过回调接口收集所有的返回数据。
--实际上可以从sqlite3_exec()获取记录，虽然看不到它的实现。sqlite3_exec()提供了获得select语句结果的回调机制，这种机制是该函数的第三第四个参数实现的。第三个参数是指向回调函数的指针。如果提供了回调函数，SQLite将调用该函数处理每个sql参数中执行的select语句的结果。
typedef int (*sqlite3_callback)(	--回调函数的声明
	void*,		--sqlite3_exec()函数第四个参数提供的数据，泛型指针
	int,		--行中字段的数目
	char**,		--代表行中字段名称的字符串数组
	char**		--代表字段名称的字符串数组
);
注：sqlite3_exec()的第四个参数是void指针，该指正指向该指针指向想要提供给回调函数的应用程序的特定数据。SQLite将此数据作为回调函数的第一个参数。
注：最后一个参数(errmsg)是指向错误消息字符串的指针，可以将处理中发生的错误消息写入该字符串。因此，sqlite3_exec()有两个错误来源：第一个是返回值，第二个是可读的字符串errmsg。如果将null传递给errmsg，SQLite将不提供任务错误的消息。
注：如果提供了errmsg指针，用来创建错误信息的内存是在堆上分配的。因此，在调用后应该检查一个是否为null，如果有错误发生，需要使用sqlite3_free()释放errmsg所占的内存。如果只是单纯的释放errmsg内存，无须检查errmsg是否为null，因为selite3_free(null)执行的是无害的空操作。
----exec.c--------------
#include <stdio.h>
#include <sqlite3.h>

int callback(void* data, int ncols, char** values, char** headers);

int main(int argc, char **argv)
{
    sqlite3 *db;
    int rc; 
    char *sql;
    char *zErr;

    rc = sqlite3_open.v2("test.db", &db);

    if(rc) {
        fprintf(stderr, "Can't open database: %s\n", sqlite3_errmsg(db));        sqlite3_close(db);
        exit(1);
    }       

    const char* data = "Callback function called";
    sql = "insert into episodes (id, name) values (11,'Mackinaw Peaches');"
          "select * from episodes;";
    rc = sqlite3_exec(db, sql, callback, data, &zErr);

    if(rc != SQLITE_OK) {
        if (zErr != NULL) { 
            fprintf(stderr, "SQL error: %s\n", zErr);
            sqlite3_free(zErr); 
        }       
    }       

    sqlite3_close(db);
    return 0;
}

int callback(void* data, int ncols, char** values, char** headers)
{
    int i;
    fprintf(stderr, "%s: ", (const char*)data);
    for(i=0; i < ncols; i++) {
        fprintf(stderr, "%s=%s ", headers[i], values[i]);
    }       
    fprintf(stderr, "\n");
    return 0;
}
注：回调函数的返回值会影响到sqlite3_exec()的执行。如果回调函数返回非零值，sqlite3_exec()将终止(换句话说，它将终止当前命令和sql字符串中后续命令的所有处理)。
------------------
sqlite3_changes() 	--提供受最后一次执行的更新、插入、删除语句影响的记录数目。但sqlite3_changes()不包括由原始命令所激活的触发器造成的结果。
sqlite3_last_insert_rowid()  --返回最后插入记录的主键值，也可在SQL内通过SQL函数 last_insert_rowid() 获取该值。
int sqlite3_get_table(	--返回单独函数调用中一个命令的整个结果集
	sqlite3*,			--打开的数据库
	const char *sql,	--要执行的SQL
	char ***resultp,	--结果写入该指针指向的char *[]
	int *nrow,			--结果集中行的数目
	int *ncolumn,		--结果集中字段的数目
	char **errmsg		--错误信息
);
注：此函数接受sql中的SQL语句返回的所有记录，使用堆上声明的内存(sqlite3_malloc())将它们存储在参数resultp中。必须使用sqlite3_free_table()释放内存，该函数将resultp指针作为唯一的参数。resultp中的第一行记录实际上不是记录，而是结果集中列的名称。
------------
char *result[];			--二维数组
sql = "select * from episodes;";
rc = sqlite3_get_table(db, sql, &result, &nrows, &ncols, &zErr);

/* Do something with data */
for(i=0; i < nrows; i++) {
    for(j=0; j < ncols; j++) {
        /* the i+1 term skips over the first record,
        which is the column headers */
        fprintf(stdout, "%s", result[(i+1)*ncols + j]);
    }   
}
/* Free memory */
sqlite3_free_table(result)
------------]
--[准备查询
--准备查询不需要回调接口，这样编码就更简单、清晰
--准备查询关联了提供列信息的函数，可以获取列的存储类型、声明类型、模式名称、表名、数据库名。而sqlite3_exec()的回调接口只提供列的名称。
--准备查询提供一种除文本外的获取字段/列值的方法，可以以C数据类型获取，而sqlite3_exec()的回调接口只提供字符串格式的字段值。
--准备查询可以重新运行，可以重用已编译的SQL
--准备查询支持参数化的SQL语句

int sqlite3_prepare_v2(	--编译或准备接受SQL语句，编译成虚拟数据库引擎(VDBE)可读的字节码
	sqlite3 *db,			--数据库句柄
	const char *zSql,		--SQL文本，UTF-8编码
	int nBytes,				--zSql的字节长度
	sqlite3_stmt **ppStmt,	--OUT:语句句柄
	const char **pzTail		--OUT:指向zSql未使用的部分
);
int sqlite3_step(		--执行
	sqlite3_stmt *pStmt		--语句句柄
);
int sqlite3_finalize(sqlite3_stmt *pStmt);	--完成并关闭语句；释放资源并提交或回滚任何隐式事务(如果该连接是自动提交模式)，清除日志文件并释放相关联的锁。
int sqlite3_reset(sqlite3_stmt *pStmt);		--重置语句；该函数将保持已编译的SQL语句(和任何绑定的参数)，然后将当前语句相关联的变化提交到数据库。如果启动了自动提交，它还释放锁定并清除日志文件。
注：sqlite3_finalize()和sqlite3_reset()之间的主要差别在于后者保留与语句关联的资源，使它可以重新执行，避免了再次调用sqlite3_prepare()编译SQL命令。
--与sqlite3_exec()一样，sqlite3_prepare_v2()可以接受包含多条SQL语句的字符串。与sqlite3_exec()不同的是，它只处理字符串中的第一条语句。当调用sqlite3_prepare_v2()之后，该函数会将pzTail参数指向zsql字符串中的下一条语句的起始位置。使用pzTail可以在循环中执行给定字符串中的一批SQL命令，如：
while(sqlite3_complete(sql)){
	rc = sqlite3_prepare_v2(db, sql, -1, &stmt, &tail);
	/*处理查询结果*/
	--跳到字符串中的下一条命令
	sql = tail;
}
sqlite3_complete(sql) --检测sql是否是一个完整的SQL语句，是就返回true，否则返回false。实际上该函数只是检查字符串中的终止符是否为分号。它只是不断给出继续提示符的工具而已。
int sqlite3_column_count(sqlite3_stmt *pStmt);	--返回与语句句柄关联的字段数，可以在语句实际执行之前在语句句柄上调用。如果不是select语句，则返回0 。
int sqlite3_data_count(sqlite3_stmt *pStmt);	--返回当前记录的列数。只有语句句柄具有活动游标时，该函数才可以工作。
const char *sqlite3_column_name(	--获取当前记录中的所有列
	sqlite3_stmt*,			--语句句柄
	int iCol				--字段的次序
);
int sqlite3_column_type(		--获取每个字段关联的存储类
	sqlite3_stmt*,			--语句句柄
	int iCol				--字段的次序
);
--该函数返回的五个存储类(数据类型)对应的整数值为：
#define SQLITE_INTEGER	1
#define SQLITE_FLOAT	2
#define SQLITE_TEXT		3
#define SQLITE_BLOB		4
#define SQLITE_NULL		5
--P167
xxx sqlite3_column_xxx(		--获取当前记录的所有字段值，xxx为数据类型
	sqlite3_stmt*,
	int iCol
);
int sqlite3_column_bytes(	--获取实际数据的长度
	sqlite3_stmt*,		--语句句柄
	int					--字段次序
);
--假设在结果集的第一列包含二进制数据，获取该数据副本的方法为：
int len = sqlite3_column_bytes(stmt, 0);
void *data = malloc(len);
memcpy(data, len, sqlite3_column_blob(stmt,0));
---------
int sqlite3_db_handle(sqlite3_stmt*); --给定一个语句句柄，该函数会返回与之关联的连接句柄。P170]
--[查询参数化
insert into episodes (id,name) values (?,?);
--sqlite3_prepare()识别到上述SQL语句有参数。在内部，为每个参数分配一个可唯一标识的编号，位置参数从1开始，并以此类推使用顺序整数值。它在生成的语句句柄(sqlite3_stmt结构体)中存储这些信息，然后期望特定值在执行前绑定到对应参数。如果参数没有绑定值，语句执行时，sqlite3_step()将默认使用NULL作为该参数的值。
int sqlite3_bind_xxx(	--绑定参数值，xxx为要绑定值的数据类型
	sqlite3_stmt*,		--语句句柄
	int i,				--参数个数
	xxx value,			--绑定的值
);
--总体上，绑定函数可分为两类，一类用于标量值(int,double,int64,null)，另一类用于数组(blob,text,text16)，他们的区别只在于数组绑定函数需要一个长度参数和指向清理函数的指针。
int sqlite3_bind_blob(
	sqlite3_stmt*,		--语句句柄
	int,				--次序
	const void*,		--指向blob的数据
	int n,				--数据的字节长度
	void(*)(void*)		--清理处理程序
);
--API为清理语句句柄有两个预定义值
#define SQLITE_STATIC		((void(*)(void *)) 0)	--告诉数组绑定函数数组内存驻留在非托管的空间，所以SQLite不会试图清理该空间。
#define SQLITE_TRANSIENT	((void(*)(void *)) -1)	--告诉绑定函数数组内存经常变化，因此，SQLite需要使用自己的数据副本，该数据副本在语句终结时会自动清除。
--清理函数的形式必须是：void cleanup_fn(void*)  ，如果提供了自定义清理函数，语句结束时，SQLite将调用该清理函数，并将数组内存传入。
注：绑定的参数在语句句柄生命周期内依然是绑定的，甚至在调用sqlite3_reset()后，依然是绑定的。只有在sqlite3_finalize()完成时，才被释放。
--绑定完参数后，sqlite3_step()将接收绑定值，替换SQL语句中的对应参数，然后开始执行命令。





--[高级网络
]

--[Core Data ] 是面向对象领域同数据库领域之间的桥梁（映射）。数据模型包括entities实体、attributes属性、relationships关系、fecth properties取回属性。
实体就是对象，它们会映射到我们的对象。即数据库中的表
属性相当于对象的属性，即数据库中的列
关系也是对象上的属性，但它们是指针，指向数据库中的其他对象，或指向一些别的对象，就像是数据库中的将不同表格连在一起
取回属性是一种精密筹划的方式，得到一个指针指向其它属性
--数据库中的所有属性都是某种形式的对象(NSString/NSNumber/NSDate/NSData)。其中的Transformable是NSData对象，它提供一种可转换的对象，能将其转换为别的类型，甚至是struct。
All Attributes are objects. Numeric ones are NSNumber, Boolean is also NSNumber, Binary Data is NSData, Date is NSDate, String is NSString
photos和whoTook是一对多关系，photos是NSSet类型，whoTook是NSManagedObject*类型，是指向数据库中对象的指针。
NSManagedObject是数据库中所有对象的超类
删除规则：Nullify，如果从数据库中删除了拍照者，对应的对象设为nil; Cascade指的是对应的对象也都删除。
--[UIManagedDocument:UIDocument]
UIDocument是一系列用于管理存储的机制
所做的只是打开或创建一个UIManagedDocument，然后抓取它的ManagedObjectContext。然后用它来做数据库。
1.打开或创建一个UIManagedDocument，并获取它的ManagedObjectContext，然后在考虑有了context如何做Core Data
--Creating a UIManagedDocument
NSFileManager *fileManager = [NSFileManager defaultManager];
NSURL *documentsDirectory = [[fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] firstObject];
NSString *documentName = @"MyDocument";
NSURL *url = [documentsDirectory URLByAppendingPathComponent:documentName];
UIManagedDocument *document = [[UIManagedDocument alloc] initWithFileURL:url];
This creates the UIManagedDocument instance, but does not open nor create the underlying file.
--How to open or create a UIManagedDocument!
First, check to see if the UIManagedDocument’s underlying file exists on disk ...
BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:[url path]];
... if it does, open the document using ...
[document openWithCompletionHandler:^(BOOL success) { /* block to execute when open */ }]; !
... if it does not, create the document using ...
[document saveToURL:url // could (should?) use document.fileURL property here
	forSaveOperation:UIDocumentSaveForCreating
	competionHandler:^(BOOL success) { /* block to execute when create is done */ }];
--open or create the underlying file is asynchronous.open和save方法是异步的，这些操作要花费一些时间，它们会立刻返回，但文件此时还没打开或创建好，只有在之后CompletionHandler被调用的时候，才能用这个document。异步的意思是这些操作需要花费一些时间，当这些操作完成之后调用你的block。下面是个例子
self.document = [[UIManagedDocument alloc] initWithFileURL:(URL *)url];
if ([[NSFileManager defaultManager] fileExistsAtPath:[url path]]) {
    [document openWithCompletionHandler:^(BOOL success) {
        if (success) [self documentIsReady];
        if (!success) NSLog(@“couldn’t open document at %@”, url);
}]; } else {
    [document saveToURL:url forSaveOperation:UIDocumentSaveForCreating
      completionHandler:^(BOOL success) {
        if (success) [self documentIsReady];
        if (!success) NSLog(@“couldn’t create document at %@”, url);
    }];
}
// can’t do anything with the document yet (do it in documentIsReady).
在这还不能对文档进行任何操作，因为这两个调用是异步的，必须等block被调用后，并激活一些条件才可以。
如果document打开了或创建好了，documentIsReady被调用了，你就可以使用它了：最好对document的状态做个判断
- (void)documentIsReady
{
	if (self.document.documentState == UIDocumentStateNormal) { 
		NSManagedObjectContext *context = self.document.managedObjectContext;		
		// start using document
	} 
}
--Other documentStates!
document中有一个documentState的东西，通常在使用它之前都会检查这个documentState，最重要的状态就是UIDocumentStateNormal，意思就是已经打开好了，可以用了。如果状态是normal的话，我要做的是获得document context，然后就可以做Core Data的操作了，创建对象，查询，或从数据库在读取一些东西等等。
UIDocumentStateClosed-- (you haven’t done the open or create yet)这是document开始时的状态，当alloc initWithFileURL时，它的状态就是closed
UIDocumentStateSavingError-- (success will be NO in completion handler)
UIDocumentStateEditingDisabled --(temporary situation, try again)这个状态是一个瞬时的状态，或许document正在重置，重置回以前保存的状态，或者保存操作正在进行，不能进行编辑；
UIDocumentStateInConflict --(e.g., because some other device changed it via iCloud)!
--
--Saving the document!
UIManagedDocuments AUTOSAVE themselves!!
However, if, for some reason you wanted to manually save (asynchronous!) ...
[self.document saveToURL:document.fileURL
		forSaveOperation:UIDocumentSaveForOverwriting
		competionHandler:^(BOOL success) { 
			/* block to execute when save is done */ 
			if (!success) NSLog(@"failed to save document %@", self.document.localizedName);
}];
--Note that this is almost identical to creation (just UIDocumentSaveForOverwriting is different).! This is a UIKit class and so this method must be called on the main queue.
--Closing the document!
--Will automatically close if there are no strong pointers left to it.! But you can explicitly close with (asynchronous!) ...! 
[self.document closeWithCompletionHandler:^(BOOL success) {
	if (!success) NSLog(@"failed to close document %@", self.document.localizedName); 
}];-- 它是异步的，得等到block执行了，它才会关闭。
--UIManagedDocument’s localizedName method ...
@property (strong) NSString *localizedName; // suitable for UI (but only valid once saved)
--
--How would you watch a document’s managedObjectContext?!
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
	NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self
               selector:@selector(contextChanged:)
                   name:NSManagedObjectContextDidSaveNotification
				 object:document.managedObjectContext]; //don’t pass nil here! object是指你想收听的对象，你可以注册收听广播站上的任何广播，或者只收听某个特定的广播，如果是nil，就是收听所有的广播。
}
- (void)viewWillDisappear:(BOOL)animated
{
    [center removeObserver:self
                      name:NSManagedObjectContextDidSaveNotification
                    object:document.managedObjectContext];
    [super viewWillDisappear:animated];
}
	[center removeObserver:self];
--必须指定selector的名字，它的参数总是NSNotification *。NSNotification有三个property，一个是name，就是radio station的name，和上面一样；object，就是给你发送通知的那个对象，和上面一样。然后是userInfo，它就是个ID，可以是任何东西，由广播员负责告诉你现在正在播放什么内容，通常它会像一个词典或者某种容器来保存数据。
--NSManagedObjectContextDidSaveNotification
- (void)contextChanged:(NSNotification *)notification
{
	// The notification.userInfo object is an NSDictionary with the following keys: 在用户信息这个字典中有三个数组，是所有变化了的对象的列表，你可以通过NSManagedObjectContext中的方法，将这些变化合并到你的context中
	NSInsertedObjectsKey //an array of objects which were inserted 
	NSUpdatedObjectsKey  //an array of objects whose attributes changed 
	NSDeletedObjectsKey  //an array of objects which were deleted
}
这个方法就是 - (void)mergeChangesFromContextDidSaveNotification:(NSNotification *)notification;传递给他notification，它会自动将所有变化合并到你的context中
--监听Core Data数据库是否有变化。要注意的是，可以由多个不同的managedObjectContext改变数据库，这样会造成混淆，如果多线程就容易解决。广播者是managedObjectContext，如果数据库中添加，删除，或者有一些更改，它就会向你广播。广播站叫NSManagedObjectContextObjectsDidChangeNotification。
--现在从document中获得了一个NSManagedObjectContext，就可以进行插入和删除操作，可以进行查询。
--通过调用NSEntityDescription中的方法来插入数据，这是一个类方法：
NSManagedObject *photo = [NSEntityDescription insertNewObjectForEntityForName:@"Photo" inManagedObjectContext:(NSManagedObjectContext *)context];
--数据库中的所有对象都是由NSManagedObject表示的，NSEntityDescription insert的返回值是一个NSManagedObject *，它返回一个指向新创建对象的指针。
--现在有这个对象了，需要设置它的attribute，怎么访问这些attribute呢？可以用NSKeyValueObserving协议，注意NSKeyValueObserving协议中的Observing，可以观察任何支持这个协议的对象的setting和geting这两个property，你希望观察这些property，这看起来和NSNotificationCenter很相似，可以说添加一个观察者，来观察这个对象的某个property，只要这个对象为这个property实现了这个协议。
- (id)valueForKey:(NSString *)key; 
- (void)setValue:(id)value forKey:(NSString *)key;
如果使用valueForKeyPath:/setValue:forKeyPath:方法，它就会跟踪那个relationship。key是attribute的名字，而value是所存的内容。
对UIManagedDocument做的所有修改都是在内存中进行的，直到做了save操作。
--但是调用valueForKey:/setValueForKey:会使代码变得很乱，这么做没有任何的类型检查，所以通常不用这种方法。用property，但是如何给NSManagedObject添加一个property，并且它的类型是Photographer *，而不是NSManagedObject *，而且是在NSManagedObject不认识这些东西的情况下。方法是创建NSManagedObject的子类，比如创建一个名为Photo的NSManagedObject的子类来表示photo entity，它在头文件里生成的就是@property，这个@property对应着所有的attribute，在实现文件中采用的不是@synthesize，因为@synthesize是给它生成一个实例变量，但这些property并不是以实例变量存储的，它是存储在SQL数据库里的。
有了Photographer.h、Photographer.m文件、Photo.h和Photo.m文件，那如何访问property呢？用"."的方式调用就可以。
photo.lastViewedDate = [NSDate date]; !
photo.whoTook = ...; // a Photographer object we created or got by querying! 
photo.whoTook.name = @"CS193p Instructor"; // yes, multiple dots will follow relationships!
--
@implementation Photo (AddOn)
- (UIImage *)image // image is not an attribute in the database, but photoURL is
{
    NSURL *imageURL = [NSURL URLWithString:self.photoURL];
    NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
    return [UIImage imageWithData:imageData];
}
- (BOOL)isOld // whether this Photo was uploaded more than a day ago {
    return [self.uploadDate timeIntervalSinceNow] > -24*60*60;
}
@end
--使用category有一个很大的限制就是，它自己是不能添加实例变量的。所以在实现一个category时，内部是不能有@synthesize。
--向NSManagedObject的子类，添加的最常用的category是Create：
@implementation Photo (Create) 
+ (Photo *)photoWithFlickrData:(NSDictionary *)flickrData
        inManagedObjectContext:(NSManagedObjectContext *)context
{
    Photo *photo = ...; // see if a Photo for that Flickr data is already in the database
    if (!photo) {
        photo = [NSEntityDescription insertNewObjectForEntityForName:@“Photo” inManagedObjectContext:context];
        // initialize the photo from the Flickr data 
        // perhaps even create other database objects (like the Photographer)
    }
    return photo;
} 
@end
--Deletion
Deleting objects from the database is easy
[aDocument.managedObjectContext deleteObject:photo];
--Make sure that the rest of your objects in the database are in a sensible state after this.
--Relationships will be updated for you (if you set Delete Rule for relationship attributes properly). 
--And don’t keep any strong pointers to photo after you delete it!
--
--有一个prepareForDeletion方法，而且可以在category中实现它，这个方法必须由一个NSManagedObject的子类来实现，才可以调用。在将要进行删除操作的时候，就会调用它。就是说，如果有谁调用了deletePhoto，这个过程的前期就是调用这个prepareForDeletion。
This is another method we sometimes put in a category of an NSManagedObject subclass ...!
@implementation Photo (Deletion)
- (void)prepareForDeletion
{
	// we don’t need to set our whoTook to nil or anything here (that will happen automatically)!
￼	// but if Photographer had, for example, a “number of photos taken” attribute,!
	// we might adjust it down by one here (e.g. self.whoTook.photoCount--). 
}
@end
--
Create objects in the database with insertNewObjectForEntityForName:inManagedObjectContext:. 
Get/set properties with valueForKey:/setValue:forKey: or @propertys in a custom subclass.
Delete objects using the NSManagedObjectContext deleteObject: method.!
--Querying查询
怎么查询呢？通过创建、执行NSFetchRequest(取回请求)对象来完成。首先要创建，然后请求NSManagedObjectContext替你执行这个fetch。
在建立NSFetchRequest时，有四点很重要：
1.指明entity； Entity to fetch (required)
2.NSPredicate(断言)How many objects to fetch at a time and/or maximum to fetch (optional, default: all)，指定一次取多少个，即批大小
3.NSSortDescriptors(排序描述器)，因为fetch会返回一个array，就是一个有序列表，所以要指明排序规则；NSSortDescriptors to specify the order in which the array of fetched objects are returned
4.NSPredicate(谓词) specifying which of those Entities to fetch (optional, default is all of them)查询条件
创建一个NSFetchRequest的方式：
NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Photo"];
request.fetchBatchSize = 20;//批大小
request.fetchLimit = 100;
request.sortDescriptors = @[sortDescriptor];//排序数组
request.predicate = ...;//谓词
--NSSortDescriptor排序描述器，类方法创建
--NSArrays are “ordered,” so we should specify the order when we fetch.
--We do that by giving the fetch request a list of “sort descriptors” that describe what to sort by.
NSSortDescriptor *sortDescriptor =
    [NSSortDescriptor sortDescriptorWithKey:@"title"  //key
                                  ascending:YES		//YES升序
                                   selector:@selector(localizedStandardCompare:)];	//这个选择器方法将被用于在排序过程中对比照片，这里结果将会以标题排序
localizedStandardCompare: is for ordering strings like the Finder on the Mac does (very common).按照一般人认为应该的方法来排序，对大小写不敏感，对发音符做出正确反应。
localizedCaseInsensitiveCompare: 对字符串类型的属性，类似上面的方法。
--创建SortDescriptor时，可以不用选择器，只用[sortDescriptorWithKey ascending]，这样对比使用的是默认值。
--为什么要给FetchRequest一个数组？两个排序描述器：主要排序、次要排序
We give an array of these NSSortDescriptors to the NSFetchRequest because sometimes!
we want to sort first by one key (e.g. last name), then, within that sort, by another (e.g. first name).!
￼Examples: @[sortDescriptor] or @[lastNameSortDescriptor, firstNameSortDescriptor]
--NSPredicate谓词
Creating one looks a lot like creating an NSString, but the contents have semantic meaning.
NSString *serverName = @"flickr-5";
NSPredicate *predicate = [NSPredicate predicateWithFormat:@"thumbnailURL contains %@", serverName];
--谓词举例
@"uniqueId = %@", [flickrInfo objectForKey:@“id”] // unique a photo in the database 
@"name contains[c] %@", (NSString *) // matches name case insensitively；[c]意思是大小写不敏感
@"viewed > %@", (NSDate *) // viewed is a Date attribute in the data mapping
@"whoTook.name = %@", (NSString *) // Photo search (by photographer’s name)!
@"any photos.title contains %@", (NSString *) // Photographer search (not a Photo search)!查找所有的拍照者
--复合谓词NSCompoundPredicate
You can use AND and OR inside a predicate string, e.g. @"(name = %@) OR (title = %@)" 
Or you can combine NSPredicate objects with special NSCompoundPredicates.
NSArray *array = @[predicate1, predicate2];
NSPredicate *predicate = [NSCompoundPredicate andPredicateWithSubpredicates:array]; 
This predicate is “predicate1 AND predicate2”. Or available too, of course.
--使用SQL函数进行高级查询 ADvanced Querying
Can actually do predicates like @"photos.@count > 5"  (Photographers with more than 5 photos).
@count is a function (there are others) executed in the database itself.
[propertyListResults valueForKeyPath:@"photos.photo.@avg.latitude"] on Flickr results returns the average latitude of all of the photos in the results (yes, really)
@"photos.photo.title.length" would return an array of the lengths of the titles of the photos
--有种机制可以到数据库中查询，但不获得NSManagedObject，而是获得对其中内容进行计算后得到的数据。这时，返回的数据将不会是NSManagedObject数组，而是NSDictionary，字典中包含的键值对就是要找的数据，相应的值会是一个数组。即NSFetchRequest可以被用于实际取回数据，而不是取回ManagedObject.
NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"..."];
[request setResultType:NSDictionaryResultType]; // fetch returns array of dicts instead of NSMO’s
[request setPropertiesToFetch:@[@"name", expression, etc.]];
--以上做的只不过是生成一个大的SQL语句，将表结合在一起，然后进行查询
--下面是一个完整的查询操作：
1. 创建request
Let’s say we want to query for all Photographers ...!
NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@“Photographer”];
... who have taken a photo in the last 24 hours ...!
NSDate *yesterday = [NSDate dateWithTimeIntervalSinceNow:-24*60*60];
request.predicate = [NSPredicate predicateWithFormat:@"any photos.uploadDate > %@", yesterday];
... sorted by the Photographer’s name ...
request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];	//升序
2. 执行request
NSManagedObjectContext *context = aDocument.managedObjectContext;
NSError *error;
NSArray *photographers = [context executeFetchRequest:request error:&error];
Returns nil if there is an error (check the NSError for details).
Returns an empty array(not nil) if there are no matches in the database.
Returns an NSArray of NSManagedObjects (or subclasses thereof) if there were any matches.! 
You can pass NULL for error: if you don’t care why it fails.
3. 查询结果；假设要查询1000个数据，查询结束后并不会得到1000个数据，而只是会得到1000个占位符，当开始看属性时，才会从数据库中获取它们。Core Data的性能优化。
The above fetch does not necessarily fetch any actual data.!
It could be an array of “as yet unfaulted” objects, waiting for you to access their attributes.! Core Data is very smart about “faulting” the data in as it is actually accessed.!
For example, if you did something like this ...!
for (Photographer *photographer in photographers) {
    NSLog(@“fetched photographer %@”, photographer);
}//只会得到占位符
You may or may not see the names of the photographers in the output!
(you might just see “unfaulted object”, depending on whether it prefetched them)!
But if you did this ...!
for (Photographer *photographer in photographers) {
    NSLog(@“fetched photographer named %@”, photographer.name);
}//查看属性时，才会真正从数据库中获取数据
... then you would definitely fault all the Photographers in from the database.! That’s because in the second case, you actually access the NSManagedObject’s data.
--Core Data Thread Safety
NSManagedObjectContext is not thread safe
Luckily, Core Data access is usually very fast, so multithreading is only rarely needed.
Usually we create NSManagedObjectContext using a queue-based concurrency model.
This means that you can only touch a context and its NSMO’s in the queue it was created on.
--Thread-Safe Access to an NSManagedObjectContext!
[context performBlock:^{ // or performBlockAndWait:
	// do stuff with context in its safe queue (the queue it was created on)，在这个block中执行的所有数据库操作都会在安全队列中执行，确保线程安全
}]; 
Note that the Q might well be the main Q, so you’re not necessarily getting "multithreaded".

--Optimistic locking(乐观锁) (deleteConflictsForObject:)
Rolling back unsaved changes
Undo/Redo
Staleness(不刷新时间) (how long after a fetch until a refetch of an object is required?)

@dynamic是编译器的一种避陷机制，避免发出警告，即如果发送给对象一个消息，而对象不懂这个方法，它就会尝试别的方法，以免崩溃或者无法响应选择器。而当NSManagedObject获得了不理解的信息时，它就会查找自己是否有个相同名字的属性，如果有，它就调用 valueForKey或者setValue: forKey:，如果这个行不通，这时它就会说无法识别选择器。

--Core Data and UITableView
NSFetchedResultsController 取回结果控制器
Simply hooks an NSFetchRequest up to a UITableViewController
它的作用是将这两者关联起来，这样一来，Fetch取回的任何东西都会显示在TableView中，只要数据库发生变化，它就会更新TableView。
这里可以使用tableView委托中的所有方法，例如：
- (NSUInteger)numberOfSectionsInTableView:(UITableView *)sender
{
    return [[self.fetchedResultsController sections] count];
}
- (NSUInteger)tableView:(UITableView *)sender numberOfRowsInSection:(NSUInteger)section
{
    return [[[self.fetchedResultsController sections] objectAtIndex:section] numberOfObjects];
}
- (NSManagedObject *)objectAtIndexPath:(NSIndexPath *)indexPath; //返回数据库中的什么实体显示在给定行中，表格中的行同数据库中的对象之间有一对一的映射关系。用这个方法，可以抽出属性，放到UITableViewCell中：
- (UITableViewCell *)tableView:(UITableView *)sender cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = ...;
	NSManagedObject *managedObject = [self.fetchedResultsController objectAtIndexPath:indexPath];
	// or, e.g., Photo *photo = (Photo *) ... 
	// load up the cell based on the properties of the managedObject!
	// of course, if you had a custom subclass, you’d be using dot notation to get them 
	return cell;
}
--创建NSFetchedResultsController--
1. 创建一个照片请求
NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Photo"];
2. 排序描述器，说明数据在tableView中的顺序
request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"title" ...]];
3. 谓词
request.predicate = [NSPredicate predicateWithFormat:@"whoTook.name = %@", photogName];
4. 创建
NSFetchedResultsController *frc = [[NSFetchedResultsController alloc]
    initWithFetchRequest:(NSFetchRequest *)request
    managedObjectContext:(NSManagedObjectContext *)context
      sectionNameKeyPath:(NSString *)keyThatSaysWhichSectionEachManagedObjectIsIn
               cacheName:@"MyPhotoCache"];  // careful!
--最后一个参数cache 如果指定nil，它不会缓存
----
--使用这个委托，它能监视Core Data中发生的事情
- (void)controller:(NSFetchedResultsController *)controller
    didChangeObject:(id)anObject
        atIndexPath:(NSIndexPath *)indexPath
      forChangeType:(NSFetchedResultsChangeType)type
       newIndexPath:(NSIndexPath *)newIndexPath
{
	// here you are supposed call appropriate UITableView methods to update rows
	// but don’t worry, we’re going to make it easy on you ...
}

注： + (void)initialize{} //一个类只会调用一次
--取出设置主题的对象
UINavigationBar *navBar = [UINavigationBar appearance];
if ([[[UIDevice currentDevice] systemVersion] floatValue] >7.0){
	
}else{

}

#define kColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]

//设置渐变色背景
CAGradientLayer *gradient = [CAGradientLayer layer];
gradient.frame = frame; 
gradient.colors = [NSArray arrayWithObjects:(id)[UIColor clearColor].CGColor,(id)[UIColor blackColor].CGColor,nil];
[self.layer insertSublayer:gradient atIndex:0];

在要使用一个Cell的时候我们先去看看tableView中有没有可以重用的cell，如果有就用这个可以重用的cell，只有在没有的时候才去创建一个Cell。这就是享元模式。

享元模式可以理解成，当细粒度的对象数量特别多的时候运行的代价会相当大，此时运用共享的技术来大大降低运行成本。比较突出的表现就是内容有效的抑制内存抖动的情况发生，还有控制内存增长。它的英文名字是flyweight，让重量飞起来。哈哈。名副其实，在一个TableView中Cell是一个可重复使用的元素，而且往往需要布局的cell数量很大。如果每次使用都创建一个Cell对象，系统的内容抖动会非常明显，而且系统的内存消耗也是比较大的。突然一想，享元模式只是给对象实例共享提供了一个比较霸道的名字吧。

在程序中如何让复制粘贴英文键改为中文键？在plist的Localizations里面改成chinese也行。

[UIImagePickerController:UINavigationController]
用iOS设备的摄像头进行拍照，视频。并且从相册中选取我们需要的图片或者视频。关于iOS摄像头和相册的应用，可以使用UIImagePickerController类来完成控制。
该类提供照相的功能,以及图片,视频浏览的功能。 
 #pragma mark - 摄像头和相册相关的公共类

// 判断设备是否有摄像头
- (BOOL) isCameraAvailable{

    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];

}

// 前面的摄像头是否可用
- (BOOL) isFrontCameraAvailable{

    return [UIImagePickerControllerisCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];

}

// 后面的摄像头是否可用
- (BOOL) isRearCameraAvailable{

    return [UIImagePickerControllerisCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];

}

// 判断是否支持某种多媒体类型：拍照，视频
- (BOOL) cameraSupportsMedia:(NSString *)paramMediaType sourceType:(UIImagePickerControllerSourceType)paramSourceType{
    __block BOOL result = NO;
    if ([paramMediaType length] == 0){
        NSLog(@"Media type is empty.");
        return NO;
    }
    NSArray *availableMediaTypes =[UIImagePickerController availableMediaTypesForSourceType:paramSourceType];
    [availableMediaTypes enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
         NSString *mediaType = (NSString *)obj;
         if ([mediaTypeisEqualToString:paramMediaType]){
              result = YES;
              *stop= YES;
         }
    }];
    return result;
}

 // 检查摄像头是否支持录像
- (BOOL) doesCameraSupportShootingVideos{

    return [self cameraSupportsMedia:( NSString *)kUTTypeMoviesourceType:UIImagePickerControllerSourceTypeCamera];

}

// 检查摄像头是否支持拍照
- (BOOL) doesCameraSupportTakingPhotos{

    return [self cameraSupportsMedia:( NSString *)kUTTypeImagesourceType:UIImagePickerControllerSourceTypeCamera];

}

#pragma mark - 相册文件选取相关

// 相册是否可用
- (BOOL) isPhotoLibraryAvailable{

    return [UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypePhotoLibrary];

}

// 是否可以在相册中选择视频
- (BOOL) canUserPickVideosFromPhotoLibrary{

    return [self cameraSupportsMedia:( NSString *)kUTTypeMovie sourceType:UIImagePickerControllerSourceTypePhotoLibrary];

}

// 是否可以在相册中选择照片
- (BOOL) canUserPickPhotosFromPhotoLibrary{

    return [self cameraSupportsMedia:( NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypePhotoLibrary];

}

三、用摄像头进行拍照和录像功能

1.我们将UIImagePickerController功能写在一个按钮的点击事件中：

#pragma mark - 拍照按钮事件

- (void)ClickControlAction:(id)sender{
    // 判断有摄像头，并且支持拍照功能
    if ([self isCameraAvailable] && [self doesCameraSupportTakingPhotos]){
        // 初始化图片选择控制器

        UIImagePickerController *controller = [[UIImagePickerController alloc] init];

        [controller setSourceType:UIImagePickerControllerSourceTypeCamera];// 设置类型
        // 设置所支持的类型，设置只能拍照，或则只能录像，或者两者都可以
        NSString *requiredMediaType = ( NSString *)kUTTypeImage;

        NSString *requiredMediaType1 = ( NSString *)kUTTypeMovie;

        NSArray *arrMediaTypes=[NSArray arrayWithObjects:requiredMediaType, requiredMediaType1,nil];

        [controller setMediaTypes:arrMediaTypes];

        // 设置录制视频的质量

        [controller setVideoQuality:UIImagePickerControllerQualityTypeHigh];

        //设置最长摄像时间

        [controller setVideoMaximumDuration:10.f];

        [controller setAllowsEditing:YES];// 设置是否可以管理已经存在的图片或者视频

        [controller setDelegate:self];// 设置代理

        [self.navigationController presentModalViewController:controller animated:YES];

        [controller release];

    } else {

        NSLog(@"Camera is not available.");

    }

}

解释：

2. setSourceType方法

通过设置setSourceType方法可以确定调用出来的UIImagePickerController所显示出来的界面
typedef NS_ENUM(NSInteger, UIImagePickerControllerSourceType) {

    UIImagePickerControllerSourceTypePhotoLibrary,

    UIImagePickerControllerSourceTypeCamera,

    UIImagePickerControllerSourceTypeSavedPhotosAlbum

};

分别表示：图片列表，摄像头，相机相册

3.setMediaTypes方法

// 设置所支持的类型，设置只能拍照，或则只能录像，或者两者都可以

        NSString *requiredMediaType = ( NSString *)kUTTypeImage;

        NSString *requiredMediaType1 = ( NSString *)kUTTypeMovie;

        NSArray *arrMediaTypes=[NSArray arrayWithObjects:requiredMediaType, requiredMediaType1,nil];

        [controller setMediaTypes:arrMediaTypes];


4.关于UIImagePickerControllerDelegate协议

我们要对我们拍摄的照片和视频进行存储，那么就要实现UIImagePickerControllerDelegate协议的方法。

#pragma mark - UIImagePickerControllerDelegate 代理方法

// 保存图片后到相册后，调用的相关方法，查看是否保存成功

- (void) imageWasSavedSuccessfully:(UIImage *)paramImage didFinishSavingWithError:(NSError *)paramError contextInfo:(void *)paramContextInfo{

    if (paramError == nil){

        NSLog(@"Image was saved successfully.");

    } else {

        NSLog(@"An error happened while saving the image.");

        NSLog(@"Error = %@", paramError);

    }

}

// 当得到照片或者视频后，调用该方法
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{

    NSLog(@"Picker returned successfully.");

    NSLog(@"%@", info);

    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];

    // 判断获取类型：图片

    if ([mediaType isEqualToString:( NSString *)kUTTypeImage]){

        UIImage *theImage = nil;

        // 判断，图片是否允许修改

        if ([picker allowsEditing]){

            //获取用户编辑之后的图像

            theImage = [info objectForKey:UIImagePickerControllerEditedImage];

        } else {

            // 照片的元数据参数

            theImage = [info objectForKey:UIImagePickerControllerOriginalImage];

        }        

        // 保存图片到相册中

        SEL selectorToCall = @selector(imageWasSavedSuccessfully:didFinishSavingWithError:contextInfo:);

        UIImageWriteToSavedPhotosAlbum(theImage, self,selectorToCall, NULL);

    }else if ([mediaType isEqualToString:(NSString *)kUTTypeMovie]){

        // 判断获取类型：视频

        //获取视频文件的url

        NSURL* mediaURL = [info objectForKey:UIImagePickerControllerMediaURL];

        //创建ALAssetsLibrary对象并将视频保存到媒体库

        // Assets Library 框架包是提供了在应用程序中操作图片和视频的相关功能。相当于一个桥梁，链接了应用程序和多媒体文件。

        ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc] init];

        // 将视频保存到相册中

        [assetsLibrary writeVideoAtPathToSavedPhotosAlbum:mediaURL completionBlock:^(NSURL *assetURL, NSError *error) {

        if (!error) {

        	NSLog(@"captured video saved with no error.");

        }else{

            NSLog(@"error occured while saving the video:%@", error);

        }

        }];

        [assetsLibrary release];

    }

    [picker dismissModalViewControllerAnimated:YES];

}

// 当用户取消时，调用该方法

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{

    [picker dismissModalViewControllerAnimated:YES];

}

//判断输入的手机号码是否符合手机号样式。
+ (BOOL)checkPhoneNumber:(NSString *)phoneNumber
{
    NSString *pattern = @"^1+[3578]+\\d{9}";
	NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
	BOOL isMatch = [pred evaluateWithObject:phoneNumber];
	return isMatch;
}

[associative 关联]
关联是指把两个对象相互关联起来，使得其中的一个对象作为另外一个对象的一部分。
使用关联，我们可以不用修改类的定义而为其对象增加存储空间。这在我们无法访问到类的源码的时候或者是考虑到二进制兼容性的时候是非常有用。
关联是基于关键字的，因此，我们可以为任何对象增加任意多的关联，每个都使用不同的关键字即可。关联是可以保证被关联的对象在关联对象的整个生命周期都是可用的（在垃圾自动回收环境下也不会导致资源不可回收）。

associative机制提供了三个方法：

OBJC_EXPORT void objc_setAssociatedObject(id object, const void *key, id value, objc_AssociationPolicy policy)
OBJC_EXPORT id objc_getAssociatedObject(id object, const void *key)
OBJC_EXPORT void objc_removeAssociatedObjects(id object)


/**
创建关联要使用到Objective-C的运行时函数：objc_setAssociatedObject来把一个对象与另外一个对象进行关联。该函数需要四个参数：源对象，关键字，关联的对象和一个关联策略。
   关键字是一个void类型的指针。每一个关联的关键字必须是唯一的。通常都是会采用静态变量来作为关键字。
   关联策略表明了相关的对象是通过赋值，保留引用还是复制的方式进行关联的；还有这种关联是原子的还是非原子的。这里的关联策略和声明属性时的很类似。这种关联策略是通过使用预先定义好的常量来表示的。
 */
static char overlayKey;
objc_setAssociatedObject(self, &overlayKey, overlay, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//获取相关联的对象
objc_getAssociatedObject(self, &overlayKey);

//断开associative是使用objc_setAssociatedObject函数，传入nil值即可。
objc_setAssociatedObject(self, &overlayKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

使用函数objc_removeAssociatedObjects可以断开所有associative。通常情况下不建议这么做，因为他会断开所有关联。

#define ZLKEY "overlayKey"
objc_getAssociatedObject(self, ZLKEY);

为NSObject子类添加任何信息

这是一个方便，强大，并且简单的类。利用associative机制，为任何Object，添加你所需要的信息。比如用户登录，向服务端发送用户名/密码时，可以将这些信息绑定在请求的项之中。等请求完成后，再取出你所需要的信息，进行逻辑处理。而不需要另外设置成员，保存这些数据。

具体的实现如下：
//.h
@interface NSObject (BDAssociation)

- (id)associatedObjectForKey:(NSString*)key;

- (void)setAssociatedObject:(id)object forKey:(NSString*)key;

@end 

//.m
#import "NSObject+BDAssociation.h"

@implementation NSObject (BDAssociation)

static char associatedObjectsKey;

- (id)associatedObjectForKey:(NSString*)key {

    NSMutableDictionary *dict = objc_getAssociatedObject(self, &associatedObjectsKey);

    return [dict objectForKey:key];

}

- (void)setAssociatedObject:(id)object forKey:(NSString*)key {

    NSMutableDictionary *dict = objc_getAssociatedObject(self, &associatedObjectsKey);

    if (!dict) {

        dict = [[NSMutableDictionary alloc] init];

        objc_setAssociatedObject(self, &associatedObjectsKey, dict, OBJC_ASSOCIATION_RETAIN);

    }

    [dict setObject:object forKey:key];

}
@end

如果需要已进入某个页面后，页面中的textField处于编辑状态，并且键盘已弹出，则在只要在viewWillApper里面加上这个就行了  if (self.isEdit) {[_textField becomeFirstResponder];}

解决在模拟器上录制播放，不能在真机上录制播放的问题
录音的时候设置
AVAudioSession *audioSession = [AVAudioSession sharedInstance];
[audioSession setCategory:AVAudioSessionCategoryRecord  error:nil];
[audioSession setActive:YES error:nil];
播放的时候设置
 AVAudioSession *audioSession = [AVAudioSession sharedInstance];
[audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];

------------------录音-------
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryRecord error:nil];
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    
    NSDictionary *setting = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithFloat: 8000.0f],                  AVSampleRateKey,
                             [NSNumber numberWithInt: kAudioFormatLinearPCM],                   AVFormatIDKey,
                             [NSNumber numberWithInt: 1],                              AVNumberOfChannelsKey,
                             [NSNumber numberWithInt: AVAudioQualityHigh],                       AVEncoderAudioQualityKey,
                             nil];
    
    
    //时间转时间戳的方法:
    NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
    NSString *nameStr = [NSString stringWithFormat:@"R_5_%@.wav",timeSp];
    NSLog(@"timeSp::%@",timeSp);
    recordfile = [NSTemporaryDirectory() stringByAppendingString:nameStr];
    
    NSURL *url = [NSURL fileURLWithPath:recordfile];
    NSError *error = nil;
    recorder = [[AVAudioRecorder alloc] initWithURL:url settings:setting error:&error];
    if (error != nil)
    {
        NSLog(@"recorder error:%@", error);
    }
    recorder.delegate = self;
    [recorder prepareToRecord];
    [recorder record];
------------------播放
     //把音频文件转换成url格式
   NSURL *url = [NSURL fileURLWithPath:voicePath];
   //初始化音频类 并且添加播放文件
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    avAudioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil] ;
    avAudioPlayer.delegate = self;
    [avAudioPlayer prepareToPlay];
    [avAudioPlayer play];
-------------------

现在Xcode都默认使用storyboard了，和原先xib方式相比，有很直观的便利。
但一些问题也比较陌生，比如如何push到xib？
那把navigationController作为入口即可
如何push到自身？
部分情况下是需要一个跟自己类似的viercontroller的，比如大集合到小集合，只是范围不同，但展示方式一样
这时候不能用performSegueWithIdentifier了
因为自己不能做segue到自身
那可以这样：

        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        PhotoAlbumViewController *initViewController = [storyBoard instantiateViewControllerWithIdentifier:@"PhotoAlbum"];
        [self.navigationController pushViewController:initViewController animated:YES];


第一个参数是storyboard的名称，第二个是给里面的页面起个Storyboard ID名称即可
如果是自身storyboard里的viewcontroller，会更方便些
PhotoAlbumViewController *initViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PhotoAlbum"];
push和pop都可以按往常一样使用 


segue是storyboard中进行场景转换的核心。
实际操作的时候，和以前的代码思维方式有不同之处。比如说，login的实现。
（一）代码思维代码：
- (void)configureLoginButton
{
    UIButton *loginButton = [UIButton ButtonWithType:UIButtonTypeCustom];

    // 省略button的设置代码。

    [loginButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)buttonClicked:(id)sender
{
    UIViewController *VC = [[UIViewController alloc] init];

    [self presentViewController:VC animated:YES completion:nil];
}

（二）这种代码思维如果被带到storyboard中，可能会这样操作：
    在场景中设置一个loginButton。
    选中loginButton，Ctrl＋拖拽到相应文件的代码中，生成一个IBAction方法。
    在这个IBAction方法中执行上面的buttonClicked中的两个方法，实现页面跳转。
但是这种方法就没有用到segue，只是把storyboard当做是界面搭建工具。

（三）更进一步的做法是：选中loginButton，Ctrl＋拖拽到要跳转到的页面。这样就会自动生成一个segue。点击按钮就会跳转到这个页面，而无需任何代码。
不过这里会产生问题。因为我们login是要通过服务器进行判断，登录信息是否正确。如果不正确，是不执行页面跳转操作的。但是通过上面的这种方法执行，无论判断是否通过，都会跳转到下一个页面。
而解决这个问题的方法很简单，只是要对上面的（二）（三）操作略作修改：

    把（二）中的第三个步骤，修改成，在IBAction方法里面执行[self performSegueWithIdentifier:segueIdentify sender:self]; 这个方法是使用segue的一个方法。要用这个方法，首先要在storyboard里面，设置对应的segue的Identify。这样，这个方法就能够找到这个segue，并执行这个segue所设定的跳转操作。除此之外，第二个参数sender，对应的是这个segue是由谁发出的。这里是由self发出的，而不是loginButton发出的。这样，就可以实现跳转和按钮按下这个动作的分离。

    那么如何实现self，也就是有loginButton按钮的这个viewController向目标viewController发出segue呢？看下图。只要把第一个场景的ViewController连线到第二个场景中，就能看到如图所示的结果，在弹出框中选择你想要的跳转模式，这个segue就创建好了。

以纯代码的方式创建模态场景切换：

//获取"MyMain.storyboard"故事板的引用
UIStoryboard *mainStoryboard =[UIStoryboard storyboardWithName:@"MyMain" bundle:nil];

//实例化Identifier为"myConfig"的视图控制器
ConfigViewController *configVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"myConfig"];

//为视图控制器设置过渡类型
configVC.modalTransitionStyle = UIModalTransitionStyleCoverVertical;

//为视图控制器设置显示样式
configVC.modalPresentationStyle = UIModalPresentationFullScreen;

//显示视图
[self presentViewController:configVC animated:YES completion:nil];

视图的modalTransitionStyle(过渡类型)属性有以下枚举值：
UIModalTransitionStyleCoverVertical -- 默认值，从下向上覆盖
UIModalTransitionStyleFlipHorizontal -- 水平翻转
UIModalTransitionStyleCrossDissolve -- 淡入淡出
UIModalTransitionStylePartialCurl -- 像书页一样翻开以显示下面的视图

视图的modalPresentationStyle(显示样式)属性有以下枚举值：
UIModalPresentationFullScreen -- 默认值，如何旋转都是全屏，iPhone下仅有这一个样式有效
UIModalPresentationFormSheet -- 宽度和高度均会小于屏幕尺寸，居中显示，四周是变暗区域。仅适用于iPad
UIModalPresentationPageSheet -- 在竖屏下和UIModalPresentationFullScreen表现一样，横屏下高度和当前屏幕高度相同，宽度和竖屏模式下屏幕宽度相同，剩余未覆盖区域将会变暗并阻止用户点击
UIModalPresentationCurrentContext -- 与父视图的显示样式相同


在Iphone上有两种读取图片数据的简单方法: UIImageJPEGRepresentation和UIImagePNGRepresentation. 



UIImageJPEGRepresentation函数需要两个参数:图片的引用和压缩系数.而UIImagePNGRepresentation只需要图片引用作为参数.通过在实际使用过程中,比较发现: UIImagePNGRepresentation(UIImage* image) 要比UIImageJPEGRepresentation(UIImage* image, 1.0) 返回的图片数据量大很多.譬如,同样是读取摄像头拍摄的同样景色的照片, UIImagePNGRepresentation()返回的数据量大小为199K ,而 UIImageJPEGRepresentation(UIImage* image, 1.0)返回的数据量大小只为140KB,比前者少了50多KB.如果对图片的清晰度要求不高,还可以通过设置 UIImageJPEGRepresentation函数的第二个参数,大幅度降低图片数据量.譬如,刚才拍摄的图片, 通过调用UIImageJPEGRepresentation(UIImage* image, 1.0)读取数据时,返回的数据大小为140KB,但更改压缩系数后,通过调用UIImageJPEGRepresentation(UIImage* image, 0.5)读取数据时,返回的数据大小只有11KB多,大大压缩了图片的数据量 ,而且从视角角度看,图片的质量并没有明显的降低.因此,在读取图片数据内容时,建议优先使用UIImageJPEGRepresentation,并可根据自己的实际使用场景,设置压缩系数,进一步降低图片数据量大小.

//------------------------
当shouldRasterize设成true时，layer被渲染成一个bitmap，并缓存起来，等下次使用时不会再重新去渲染了。实现圆角本身就是在做颜色混合（blending），如果每次页面出来时都blending，消耗太大，这时shouldRasterize = yes，下次就只是简单的从渲染引擎的cache里读取那张bitmap，节约系统资源。

额外收获：如果在滚动tableView时，每次都执行圆角设置，肯定会阻塞UI，设置这个将会使滑动更加流畅。
//------------------------

 extern float ceilf(float);
 extern double ceil(double);
 extern long double ceill(long double);

 extern float floorf(float);
 extern double floor(double);
 extern long double floorl(longdouble);

 extern float roundf(float);
 extern double round(double);
 extern long double roundl(longdouble);

 round：如果参数是小数，则求本身的四舍五入。
 ceil：如果参数是小数，则求最小的整数但不小于本身.
 floor：如果参数是小数，则求最大的整数但不大于本身. 

 Example:如何值是3.4的话，则
 3.4 -- round 3.000000
     -- ceil 4.000000
    -- floor 3.00000

STPopup 提供了一个可在 iPhone 和 iPad 上使用的具有 UINavigationController 弹出效果的 STPopupController 类, 并能在 Storyboard 上很好的工作
https://github.com/kevin0571/STPopup

[xcode 插件 更新] 升级
find ~/Library/Application\ Support/Developer/Shared/Xcode/Plug-ins -name Info.plist -maxdepth 3 | xargs -I{} defaults write {} DVTPlugInCompatibilityUUIDs -array-add `defaults read /Applications/Xcode.app/Contents/Info.plist DVTPlugInCompatibilityUUID`

_cmd是隐藏的参数，代表当前方法的selector，他和self一样都是每个方法调用时都会传入的参数，动态运行时会提及如何传的这两个参数。
比如这样一个语句。
NSLog(@"%@",NSStringFromSelector(_cmd));
执行这个方法就会输出方法的名称， 这样做是为了跟踪查看方法调用的前后顺序，或者想看看程序到底在那个方法内部崩溃的！
另外,
[self performSelector:_cmd withObject:nil afterDelay:arc4random()%3 + 1];
这样的话，每隔3到4秒调用本身一次,类似定时器效果。 
