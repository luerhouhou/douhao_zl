
iOS 8 inserts a new “UITextEffectsWindow” above your application’s main UIWindow that currently intercepts clicks when selecting items in the Reveal canvas. To work around this you can either Command-Click to select through the UITextEffectsWindow or double-click on your app’s UIWindow in Reveal’s outline view to focus on the application window.


UIWindow的常用属性：

1）windowLevel

UIWindowLevel 类型，多个 UIWindow 的显示顺序是按照 windowLevel 从高到低排列的，windowLevel 最高的显示在最前面。比如：windowLevel 较高的 UIAlertView 警告窗口会显示在一般窗口的前面。UIWindowLevel 类型的定义如下：

const UIWindowLevel UIWindowLevelNormal;   // 默认等级
const UIWindowLevel UIWindowLevelAlert;       // UIAlertView 的等级
const UIWindowLevel UIWindowLevelStatusBar;   // 状态栏的等级
typedef CGFloat UIWindowLevel;

从 UIWindowLevel 的定义可知，windowLevel 的值其实是一个 CGFloat 类型，我们将系统预设的三个等级打印出来，他们的值如下：

UIWindowLevelNormal：0.000000
UIWindowLevelAlert：2000.000000
UIWindowLevelStatusBar：1000.000000

UIWindowLevelNormal < UIWindowLevelStatusBar < UIWindowLevelAlert
而当你需要一个额外的 UIWindow，并且此 UIWindow 需要显示在 UIAlertView 的前面，可以将此 windowLevel 设置为 ：UIWindowLevelAlert + 1，那么此 UIWindow 与 UIAlertView 同时显示时，此 UIWindow 将显示在 UIAlertView 前面。

如果有多个UIWindow，且其UIWindowLevel都相同，那先调用 makeKeyAndVisble 的会一直显示在前面。

2）keyWindow

BOOL 类型，只读，用于判断是否是当前应用的 key window (key window 是指可接收到键盘输入及其他非触摸事件的 UIWindow，一次只能有一个 key window)

3）rootViewController

rootViewController ：UIViewController 类型，iOS 4.0新增属性，设置此属性后，rootViewController 所包含的 view 将被添加到 UIWindow 中，iOS 4.0之前版本可采用 addSubview: 方法达到同样的效果，因为 UIWindow 类本身就是 UIView 的子类。

4) screen

IOS物理设备的替代者，【【UIScreen mainScreen】bounds]获取设备大小，如果iphone和iPad的尺寸不一样，如果做适配要用该属性。

UIWindow的常用方法：

 

    makeKeyWindow ：将当前 UIWindow 设置成应用的 key window。

    makeKeyAndVisible ：将当前 UIWindow 设置成应用的 key window，并使得 UIWindow 可见；你也可以使用 UIView 的 hidden 属性来显示或者隐藏一个 UIWindow。
     

 

—————————-

一、UIWindow是一种特殊的UIView，通常在一个程序中只会有一个UIWindow，但可以手动创建多个UIWindow，同时加到程序里面。UIWindow在程序中主要起到三个作用：

1、作为容器，包含app所要显示的所有视图

2、传递触摸消息到程序中view和其他对象

3、与UIViewController协同工作，方便完成设备方向旋转的支持

二、通常我们可以采取两种方法将view添加到UIWindow中：

1、addSubview

直接将view通过addSubview方式添加到window中，程序负责维护view的生命周期以及刷新，但是并不会为去理会view对应的ViewController，因此采用这种方法将view添加到window以后，我们还要保持view对应的ViewController的有效性，不能过早释放。

2、rootViewController

rootViewController时UIWindow的一个遍历方法，通过设置该属性为要添加view对应的ViewController，UIWindow将会自动将其view添加到当前window中，同时负责ViewController和view的生命周期的维护，防止其过早释放

三、WindowLevel

UIWindow在显示的时候会根据UIWindowLevel进行排序的，即Level高的将排在所有Level比他低的层级的前面。下面我们来看UIWindowLevel的定义：

　　　　const UIWindowLevel UIWindowLevelNormal;
　　　　const UIWindowLevel UIWindowLevelAlert;
　　　　const UIWindowLevel UIWindowLevelStatusBar;
　　　　typedef CGFloat UIWindowLevel;

IOS系统中定义了三个window层级，其中每一个层级又可以分好多子层级(从UIWindow的头文件中可以看到成员变量CGFloat _windowSublevel;)，不过系统并没有把则个属性开出来。UIWindow的默认级别是UIWindowLevelNormal，我们打印输出这三个level的值分别如下：
2012-03-27 22:46:08.752 UIViewSample[395:f803] Normal window level: 0.000000
2012-03-27 22:46:08.754 UIViewSample[395:f803] Alert window level: 2000.000000
2012-03-27 22:46:08.755 UIViewSample[395:f803] Status window level: 1000.000000

这样印证了他们级别的高低顺序从小到大为Normal < StatusBar < Alert，下面请看小的测试代码：
复制代码

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    self.window.backgroundColor = [UIColor yellowColor];
    [self.window makeKeyAndVisible];
    
    UIWindow *normalWindow = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    normalWindow.backgroundColor = [UIColor blueColor];
    normalWindow.windowLevel = UIWindowLevelNormal;
    [normalWindow makeKeyAndVisible];
    
    CGRect windowRect = CGRectMake(50,
                                   50,
                                   [[UIScreen mainScreen] bounds].size.width - 100,
                                   [[UIScreen mainScreen] bounds].size.height - 100);
    UIWindow *alertLevelWindow = [[UIWindow alloc] initWithFrame:windowRect];
    alertLevelWindow.windowLevel = UIWindowLevelAlert;
    alertLevelWindow.backgroundColor = [UIColor redColor];
    [alertLevelWindow makeKeyAndVisible];
    
    UIWindow *statusLevelWindow = [[UIWindow alloc] initWithFrame:CGRectMake(0, 50, 320, 20)];
    statusLevelWindow.windowLevel = UIWindowLevelStatusBar;
    statusLevelWindow.backgroundColor = [UIColor blackColor];
    [statusLevelWindow makeKeyAndVisible];
    
    NSLog(@"Normal window level: %f", UIWindowLevelNormal);
    NSLog(@"Alert window level: %f", UIWindowLevelAlert);
    NSLog(@"Status window level: %f", UIWindowLevelStatusBar);
    
    return YES;
}

复制代码

 

运行结果如下图：

我们可以注意到两点：

1）我们生成的normalWindow虽然是在第一个默认的window之后调用makeKeyAndVisible，但是仍然没有显示出来。这说明当Level层级相同的时候，只有第一个设置为KeyWindow的显示出来，后面同级的再设置KeyWindow也不会显示。

2）statusLevelWindow在alertLevelWindow之后调用makeKeyAndVisible，仍然只是显示在alertLevelWindow的下方。这说明UIWindow在显示的时候是不管KeyWindow是谁，都是Level优先的，即Level最高的始终显示在最前面。

那么如何才能将后加的同一层级的window显示出来呢？

经过测试 normalWindow.windowLevel = UIWindowLevelNormal+1;

 

——————————

UIWindow的一点儿思考

每一个IOS程序都有一个UIWindow，在我们通过模板简历工程的时候，xcode会自动帮我们生成一个window，然后让它变成keyWindow并显示出来。这一切都来的那么自然，以至于我们大部分时候都忽略了自己也是可以创建UIWindow对象。

通常在我们需要自定义UIAlertView的时候（IOS 5.0以前AlertView的背景样式等都不能换）我们可以使用UIWindow来实现（设置windowLevel为Alert级别），网上有很多例子，这里就不详细说了。

我的上一篇文章UIWindowLevel详解，中讲到了关于Windowlevel的东西，当时还只是看了看文档，知道有这么一回儿事。今天刚好遇到这块儿的问题，就顺便仔细看了一下UIWindow方面的东西，主要包括：WindowLevel以及keyWindow两个方面。

一、UIWindowLevel

我们都知道UIWindow有三个层级，分别是Normal，StatusBar，Alert。打印输出他们三个这三个层级的值我们发现从左到右依次是0，1000，2000，也就是说Normal级别是最低的，StatusBar处于中等水平，Alert级别最高。而通常我们的程序的界面都是处于Normal这个级别上的，系统顶部的状态栏应该是处于StatusBar级别，UIActionSheet和UIAlertView这些通常都是用来中断正常流程，提醒用户等操作，因此位于Alert级别。

上一篇文章中我也提到了一个猜想，既然三个级别的值之间相差1000，而且我们细心的话查看UIWindow的头文件就会发现有一个实例变量_windowSublevel，那我们就可以定义很多中间级别的Window。例如可以自定义比系统UIAlertView级别低一点儿的window。于是写了一个小demo，通过打印发现系统的UIAlertView的级别是1996，而与此同时UIActionSheet的级别是2001，这样也验证了subLevel的确存在。
复制代码

    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alert View"
                                                        message:@"Hello Wolrd, i'm AlertView!!!"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:@"Cancel", nil];
    [alertView show];
    [alertView release];
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"ActionSheet"
                                                             delegate:nil
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:@"Don't do that!"
                                                    otherButtonTitles:@"Hello Wolrd", nil];
    [actionSheet showInView:self.view];
    [actionSheet release];

复制代码

下面是程序运行截图：

根据window显示级别优先的原则，级别高的会显示在上面，级别低的在下面，我们程序正常显示的view位于最底层，至于具体怎样获取UIAlertView和UIActionSheet的level，我会在下面第二部分keyWindow中介绍并给出相应的代码。

二、KeyWindow

什么是keyWindow，官方文档中是这样解释的”The key window is the one that is designated to receive keyboard and other non-touch related events. Only one window at a time may be the key window.” 翻译过来就是说，keyWindow是指定的用来接收键盘以及非触摸类的消息，而且程序中每一个时刻只能有一个window是keyWindow。

下面我们写个简单的例子看看非keyWindow能不能接受键盘消息和触摸消息，程序中我们在view中添加一个UITextField，然后新建一个alert级别的window，然后通过makeKeyAndVisible让它变成keyWindow并显示出来。代码如下：
复制代码

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    self.viewController = [[[SvUIWindowViewController alloc] initWithNibName:@"SvUIWindowViewController" bundle:nil] autorelease];
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    
    UIWindow *window1 = [[UIWindow alloc] initWithFrame:CGRectMake(0, 80, 320, 320)];
    window1.backgroundColor = [UIColor redColor];
    window1.windowLevel = UIWindowLevelAlert;
    [window1 makeKeyAndVisible];

    return YES;
}

复制代码
复制代码

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self registerObserver];
    
    // add a textfield
    UITextField *filed = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 320, 60)];
    filed.placeholder = @"Input something here";
    filed.clearsOnBeginEditing = YES;
    filed.borderStyle = UITextBorderStyleRoundedRect;
    [self.view addSubview:filed];
    [filed release];
}

复制代码

运行截图如下：

从图中可以看出，虽然我们自己新建了一个然后设置为keyWindow并显示，但是点击程序中默认window上添加的textField还是可以唤出键盘，而且还可以正常接受键盘输入，只是键盘被挡住了，说明非keyWindow也是可以接受键盘消息，这一点和文档上说的不太一样。

观察UIWindow的文档，我们可以发现里面有四个关于window变化的通知：

　　UIWindowDidBecomeVisibleNotification

　　UIWindowDidBecomeHiddenNotification

　　UIWindowDidBecomeKeyNotification

　　UIWindowDidResignKeyNotification

　　这四个通知对象中的object都代表当前已显示（隐藏），已变成keyWindow（非keyWindow）的window对象，其中的userInfo则是空的。于是我们可以注册这个四个消息，再打印信息来观察keyWindow的变化以及window的显示，隐藏的变动。

　　代码如下：
SvUIWindowViewController.m

　　a、当我们打开viewDidAppear中“[self presentAlertView];”的时候，控制台输出如下：

　　根据打印的信息我们可以看出流程如下：

　　1、程序默认的window先显示出来

　　2、默认的window再变成keyWindow

　　3、AlertView的window显示出来

　　4、默认的window变成非keyWindow

　　5、最终AlertView的window变成keyWindow

　　总体来说就是“要想当老大（keyWindow），先从小弟（非keyWindow）开始混起” 而且根据打印的信息我们同事可以知道默认的window的level是0，即normal级别；AlertView的window的level是1996，比Alert级别稍微低了一点儿。

　　b、当我们打开viewDidAppear中“[self presentActionSheet];”的时候，控制台输出如下：

　　keyWindow的变化和window的显示和上面的流程一样，同时我们可以看出ActionSheet的window的level是2001。

　　c、接着上一步，我们点击弹出ActionSheet的cancel的时候，控制台输出如下：

　　我们看出流程如下：

　　1、首先ActionSheet的window变成非keyWindow

　　2、程序默认的window变成keyWindow

　　3、ActionSheet的window在隐藏掉

　　总体就是“想隐居幕后可以，但得先交出权利”。

　　以上是这两天遇到的，总结一下，欢迎补充，如果有不对的地方也请多多指正。
Share this:

    TwitterFacebookGoogle

Related

UIGraphicsBeginImageContext和UIGraphicsBeginImageContextWithOptions

UITableViewIn "ios"

(FWD) Intellij IDEA vs. eclipseIn "java"
ios
Post navigation
Previous Postconst, extern , static,
Next Postdelegate & protocol
Leave a Reply
ocean-coding-family

