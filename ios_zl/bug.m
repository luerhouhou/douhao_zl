什么是BUG，简单点说就是，程序没有按照我们预想的方式运行。我比较喜欢把BUG分成两类：
    1. Crash掉的
    2. 没有Crash掉的

因此合理制造“BUG”的原则之一，也是最大的原则就是：尽量制造Crash的BUG，减少没有Crash的BUG，如果有可能将没有Crash掉的Bug转换成Crash的BUG以方便查找。

NSAssert

这个应该都比较熟悉，他的名字叫做“断言”。断言（assertion）是指在开发期间使用的、让程序在运行时进行自检的代码（通常是一个子程序或宏）。断言为真，则表明程序运行正常，而断言为假，则意味着它已经在代码中发现了意料之外的错误。断言对于大型的复杂程序或可靠性要求极高的程序来说尤其有用。而当断言为假的时候，几乎所有的系统的处理策略都是，让程序死掉，即Crash掉。方便你知道，程序出现了问题。

断言其实是“防御式编程”的常用的手段。防御式编程的主要思想是：子程序应该不因传入错误数据而被破坏，哪怕是由其他子程序产生的错误数据。这种思想是将可能出现的错误造成的影响控制在有限的范围内。断言能够有效的保证数据的正确性，防止因为脏数据让整个程序运行在不稳定的状态下面。

关于如何使用断言，还是参考《代码大全2》中“防御式编程”一章。这里简单的做了一点摘录，概括其大意：

1. 用错误处理代码来处理预期会发生的状况，用断言来处理绝不应该发生的状况。
2. 避免把需要执行的代码放到断言中
3. 用断言来注解并验证前条件和后条件
4. 对于高健壮性的代码，应该先使用断言再处理错误
5. 对来源于内部系统的可靠的数据使用断言，而不要对外部不可靠的数据使用断言，对于外部不可靠数据，应该使用错误处理代码。

系统外部的数据（用户输入，文件，网络读取等等）都是不可信的，需要严格检查（通常是错误处理）才能放行到系统内部，这相当于一个守卫。而对于系统内部的交互（比如子程序调用），如果每次也都去处理输入的数据，也就相当于系统没有可信的边界了，会让代码变的臃肿复杂；而事实上，在系统内部，传递给子程序预期的恰当数据应该是调用者的责任，系统内的调用者应该确保传递给子程序的数据是恰当可以正常工作的。这样一来，就隔离了不可靠的外部环境和可靠的系统内部环境，降低复杂度。

但是在开发阶段，代码极可能包含缺陷，也许是处理外部数据的程序考虑的不够周全，也许是调用系统内部子程序的代码存在错误，造成子程序调用失败。这个时候，断言就可以发挥作用，用来确诊到底是那部分出现了问题而导致子程序调用失败。在清理了所有缺陷之后，内外有别的信用体系就建立起来。等到发行版时候，这些断言就应该没有存在必要。

在iOS开发中，可以使用NSAssert()在程序中进行断言处理。NSAssert()使用正确，可以帮助开发者尽快定位bug。开发者没有必要在应用程序的每个版本中都进行断言检查，这是因为大多数项目都是有两个版本：Debug版和Release版。在Debug版中，开发者希望所有的断言都检查到，而在Release版中，往往都是禁用断言检查的。设置Release版本中禁用断言的方法如下：

在Build Settings菜单，找到Preprocessor Macros项，Preprocessor Macros项下面有一个选择，用于程序生成配置：Debug版和Release版。选择 Release项，设置NS_BLOCK_ASSERTIONS，不进行断言检查。

- (void)printMyName:(NSString *)myName 
{ 
    NSAssert(myName == nil, @"名字不能为空！"); 
    NSLog(@"My name is %@.",myName); 
}

我们验证myName的安全性，需要保证其不能为空。NSAssert会检查其内部的表达式的值，如果为假则继续执行程序，如果不为假让程序Crash掉。

每一个线程都有它自己的断言捕获器（一个NSAssertionHanlder的实例），当断言发生时，捕获器会打印断言信息和当前的类名、方法名等信息。然后抛出一个NSInternalInconsistencyException异常让整个程序Crash掉。并且在当前线程的断言捕获器中执行handleFailureInMethod:object:file:lineNumber:description:以上述信息为输出。


尽可能不要用Try-Catch

并不是说Try-Catch这样的异常处理机制不好。而是，很多人在编程中，错误了使用了Try-Catch，把异常处理机制用在了核心逻辑中。把其当成了一个变种的GOTO使用。把大量的逻辑写在了Catch中。弱弱的说一句，这种情况干嘛不用ifelse呢。

而实际情况是，异常处理只是用户处理软件中出现异常的情况。常用的情况是子程序抛出错误，让上层调用者知道，子程序发生了错误，并让调用者使用合适的策略来处理异常。一般情况下，对于异常的处理策略就是Crash，让程序死掉，并且打印出堆栈信息。

而在IOS编程中，抛出错误的方式，往往采用更直接的方式。如果上层需要知道错误信息，一半会传入一个NSError的指针的指针：

- (void) doSomething:(NSError* __autoreleasing*)error
{
    ...
    if(error != NULL)
    {
        *error = [NSError new];
    }
    ....
}

而能够留给异常处理的场景就极少了，所以在IOS编程中尽量不要使用Try-Catch。

尽量将没有Crash掉的BUG，让它Crash掉

上面主要讲的是怎么知道Crash的“BUG”。对于合理的制造“BUG”还有一条就是尽量把没有Crash掉的“BUG”，让他Crash掉。这个没有比较靠谱的方法，靠暴力吧。比如写一些数组越界在里面之类的。比如那些难调的多线程BUG，想办法让他Crash掉吧，crash掉查找起来就比较方便了。

总之，就是抱着让程序“死掉”的心态去编程，向死而生。

如何查找BUG

其实查找BUG这个说法，有点不太靠谱。因为BUG从来都不需要你去找，他就在那里，只增不减。都是BUG来找你，你很少主动去找BUG。程序死了，然后我们就得加班加点。其实我们找的是发生BUG的原因。找到引发BUG的罪魁祸首。说的比较理论化一点就是：在一堆可能的原因中，找到那些与BUG有因果性的原因（注意，是因果性，不是相关性）。

于是解决BUG一般可以分两步进行：
1. 合理性假设，找到可能性最高的一系列原因。
2. 对上面找到的原因与BUG之间的因果性进行分析。必须确定，这个BUG是由某个原因引起的，而且只由改原因引起。即确定特定原因是BUG的充分必要条件。

合理性假设

其实，BUG发生的原因可以分成两类：
1. 我们自己程序的问题。
2. 系统环境，包括OS、库、框架等的问题。

前者找到了，我们可以改。后者就比较无能为力了，要么发发牢骚，要么email开发商，最后能不能被改掉就不得而知了。比如IOS制作framework的时候，category会报方法无法找的异常，到现在都没有解决掉。

当然，一般情况下导致程序出问题的原因的99.999999%都是我们自己造成的。所以合理性假设第一条：

首先怀疑自己和自己的程序，其次怀疑一切。

而程序的问题，其实就是开发者自己的问题。毕竟BUG是程序员的亲子亲孙，我们一手创造了BUG。而之所以能够创造BUG，开发者的原因大致有三：
1. 知识储备不足，比如IOS常见的空指针问题，发现很多时候就是因为对于IOS的内存管理模型不熟悉导致。
2. 错心大意，比较典型的就是数组越界错误。还有在类型转化的时候没注意。比如下面这个程序：

//array.count = 9
for (int i = 100; array.count - (unsigned int)i/10 ; )
{
    i++
    .....
}

按道理讲，这应该是个可以正常执行的程序，但是你运行的话是个死循环。可能死循环的问题，你改了很多天也没解决。直到同事和你说array.count返回的是NSUInterge，当与无符号整形相减的时候，如果出现负值是会越界的啊。你才恍然大悟：靠，类型的问题。

3. 逻辑错误
这个就是思维方式的问题，但是也是问题最严重的。一旦发生，很难查找。人总是最难怀疑自己的思维方式。比如死循环的问题，最严重的是函数间的循环引用，还有多线程的问题。

但是庆幸的是绝大多数的BUG都是由于知识储备不足和粗心大意造成的。所以合理性假设的第二条：

首先怀疑基础性的原因，比如自己知识储备和粗心大意等人为因素，通过这些原因查找具体的问题。之后再去怀疑难处理的逻辑错误。

有了上面的合理性怀疑的一些基本策略，也不能缺少一些基本的素材啊。就是常见的Crash原因，最后我们还是得落地到这些具体的原因或者代码上，却找与BUG的因果性联系。

1. 访问了一个已经被释放的对象，比如 
NSObject * aObj = [[NSObject alloc] init];
[aObj release];
NSLog(@"%@", aObj);

原因: aObj 这个对象已经被释放，但是指针没有置空，这时访问这个指针指向的内存就会 Crash。
解决办法 :使用前要判断非空，释放后要置空。正确的释放应该是: 
[aObj release];
aObj = nil;

由于ObjC的特性，调用 nil 指针的任何方法相当于无作用，所以即使有人在使用这个指针时没有判断至少还不会挂掉。

在ObjC里面，一切基于 NSObject　的对象都使用指针来进行调用，所以在无法保证该指针一定有值的情况下，要先判断指针非空再进行调用。
if(aObj){ ... }

常见的如判断一个字符串是否为空：
if (aString && aString.length > 0) {//...}

2. 访问数组类对象越界或插入了空对象

NSMutableArray/NSMutableDictionary/NSMutableSet 等类下标越界，或者 insert 了一个 nil 对象。

原因: 一个固定数组有一块连续内存，数组指针指向内存首地址，靠下标来计算元素地址，如果下标越界则指针偏移出这块内存，会访问到野数据，ObjC 为了安全就直接让程序 Crash 了。

而 nil 对象在数组类的 init 方法里面是表示数组的结束，所以使用 addObject 方法来插入对象就会使程序挂掉。如果实在要在数组里面加入一个空对象，那就使用 NSNull。
[array addObject:[NSNull null]];

解决办法: 使用数组时注意判断下标是否越界，插入对象前先判断该对象是否为空。
if (aObj) {
    [array addObject:aObj];
}

可以使用 Cocoa 的 Category 特性直接扩展 NSMutable 类的 Add/Insert 方法。比如：
@interface NSMutableArray (SafeInsert)
-(void) safeAddObject:(id)anObject;
@end

@implementation NSMutableArray (SafeInsert)
-(void) safeAddObject:(id)anObject {
    if (anObject) {
        [self addObject:anObject];
    }
}
@end
这样，以后在工程里面使用 NSMutableArray 就可以直接使用 safeAddObject 方法来规避 Crash。

3. 访问了不存在的方法

ObjC 的方法调用跟 C++ 很不一样。 C++ 在编译的时候就已经绑定了类和方法，一个类不可能调用一个不存在的方法，否则就报编译错误。而 ObjC 则是在 runtime 的时候才去查找应该调用哪一个方法。

这两种实现各有优劣，C++ 的绑定使得调用方法的时候速度很快，但是只能通过 virtual 关键字来实现有限的动态绑定。而对 ObjC 来说，事实上他的实现是一种消息传递而不是方法调用。

[aObj aMethod];

这样的语句应该理解为，像 aObj 对象发送一个叫做 aMethod 的消息，aObj 对象接收到这个消息之后，自己去查找是否能调用对应的方法，找不到则上父类找，再找不到就 Crash。由于 ObjC 的这种特性，使得其消息不单可以实现方法调用，还能紧系转发，对一个 obj 传递一个 selector　要求调用某方法，他可以直接不理会，转发给别的　obj 让别的 obj 来响应，非常灵活。

[self methodNotExists];

调用一个不存在的方法，可以编译通过，运行时直接挂掉，报 NSInvalidArgumentException 异常：

-----error-----
-[WSMainViewController methodNotExist]: unrecognized selector sent to instance 0x1dd96160
2013-10-23 15:49:52.167 WSCrashSample[5578:907] *** Terminating app due to uncaught exception 'NSInvalidArgumentException', reason: '-[WSMainViewController methodNotExist]: unrecognized selector sent to instance 0x1dd96160'
-----------

解决方案: 像这种类型的错误通常出现在使用 delegate 的时候，因为 delegate 通常是一个 id 泛型，所以 IDE 也不会报警告，所以这种时候要用 respondsToSelector 方法先判断一下，然后再进行调用。

if ([self respondsToSelector:@selector(methodNotExist)]) {
    [self methodNotExist];
}

4. 字节对齐,(类型转换错误)

可能由于强制类型转换或者强制写内存等操作，CPU 执行 STMIA 指令时发现写入的内存地址不是自然边界，就会硬件报错挂掉。iPhone 5s 的 CPU 从32位变成64位，有可能会出现一些字节对齐的问题导致 Crash 率升高的。

char *mem = malloc(16); // alloc 16 bytes of data
double *dbl = mem + 2;
double set = 10.0;
*dbl = set;

像上面这段代码，执行到
*dbl = set;
这句的时候，报了 EXC_BAD_ACCESS(code=EXC_ARM_DA_ALIGN) 错误。

原因: 要了解字节对齐错误还需要一点点背景知识，知道的童鞋可以略过直接看后面了。

[--背景知识

计算机最小数据单位是bit（位），也就是0或1。

而内存空间最小单元是byte（字节），一个byte为8个bit。

内存地址空间以byte划分，所以理论上访问内存地址可以从任意byte开始，但是事实上我们不是直接访问硬件地址，而是通过操作系统的虚拟内存地址来访问，虚拟内存地址是以字为单位的。一个32位机器的字长就是32位，所以32位机器一次访问内存大小就是4个byte。再者为了性能考虑，数据结构(尤其是栈)应该尽可能地在自然边界上对齐。原因在于，为了访问未对齐的内存，处理器需要作两次内存访问；而对齐的内存访问仅需要一次访问。
--]

解决办法: 使用 memcpy 来作内存拷贝，而不是直接对指针赋值。对上面的例子作修改就是： 

char *mem = malloc(16); // alloc 16 bytes of data
double *dbl = mem + 2;
double set = 10.0;
memcpy(dbl, &set, sizeof(set));

改用 memcpy 之后运行就不会有问题了，这是因为 memcpy 自己的实现就已经做了字节对齐的优化了。我们来看glibc2.5中的memcpy的源码：
--
void *memcpy (void *dstpp, const void *srcpp, size_t len) {

    unsigned long int dstp = (long int) dstpp;
    unsigned long int srcp = (long int) srcpp;

    if (len >= OP_T_THRES) {
      len -= (-dstp) % OPSIZ;
      BYTE_COPY_FWD (dstp, srcp, (-dstp) % OPSIZ);
      PAGE_COPY_FWD_MAYBE (dstp, srcp, len, len);
      WORD_COPY_FWD (dstp, srcp, len, len);
    }
    BYTE_COPY_FWD (dstp, srcp, len);
    return dstpp;
}

分析这个函数，首先比较一下需要拷贝的内存块大小，如果小于 OP_T_THRES (这里定义为 16)，则直接字节拷贝就完了，如果大于这个值，视为大内存块拷贝，采用优化算法。

len -= (-dstp) % OPSIZ;
BYTE_COPY_FWD (dstp, srcp, (-dstp) % OPSIZ);

// #define OPSIZ   (sizeof(op_t))
// enum op_t

OPSIZE 是 op_t 的长度，op_t 是字的类型，所以这里 OPSIZE 是获取当前平台的字长。
dstp 是内存地址，内存地址是按byte来算的，对内存地址 unsigned long 取负数再模 OPSIZE 得到需要对齐的那部分数据的长度，然后用字节拷贝做内存对齐。取负数是因为要以dstp的地址作为起点来进行复制，如果直接取模那就变成0作为起点去做运算了。
--

5. 堆栈溢出

6. 多线程并发操作

这个应该是全平台都会遇到的问题了。当某个对象会被多个线程修改的时候，有可能一个线程访问这个对象的时候另一个线程已经把它删掉了，导致 Crash。比较常见的是在网络任务队列里面，主线程往队列里面加入任务，网络线程同时进行删除操作导致挂掉。

解决方法
1> 加锁 NSLock

普通的锁，加锁的时候 lock，解锁调用 unlock。

- (void)addPlayer:(Player *)player {
    if (player == nil) return;
        NSLock* aLock = [[NSLock alloc] init];
        [aLock lock];
        [players addObject:player];
        [aLock unlock];
    }
}

2> 可以使用标记符 @synchronized 简化代码：

- (void)addPlayer:(Player *)player {
    if (player == nil) return;
    @synchronized(players) {
        [players addObject:player];
    }
}

3> NSRecursiveLock 递归锁

使用普通的 NSLock 如果在递归的情况下或者重复加锁的情况下，自己跟自己抢资源导致死锁。Cocoa 提供了 NSRecursiveLock 锁可以多次加锁而不会死锁，只要 unlock 次数跟 lock 次数一样就行了。

4> NSConditionLock 条件锁

多数情况下锁是不需要关心什么条件下 unlock 的，要用的时候锁上，用完了就 unlock　就完了。Cocoa 提供这种条件锁，可以在满足某种条件下才解锁。这个锁的 lock 和 unlock, lockWhenCondition 是随意组合的，可以不用对应起来。

5> NSDistributedLock 分布式锁
这是用在多进程之间共享资源的锁，对 iOS 来说暂时没用处。

6> 无锁

放弃加锁，采用原子操作，编写无锁队列解决多线程同步的问题。酷壳有篇介绍无锁队列的文章可以参考一下：无锁队列的实现

7> 使用其他备选方案代替多线程：Operation Objects, GCD, Idle-time notifications, Asynchronous functions, Timers, Separate processes。

7. Repeating NSTimer

如果一个 Timer 是不停 repeat，那么释放之前就应该先 invalidate。非repeat的timer在fired的时候会自动调用invalidate，但是repeat的不会。这时如果释放了timer，而timer其实还会回调，回调的时候找不到对象就会挂掉。

原因: NSTimer 是通过 RunLoop 来实现定时调用的，当你创建一个 Timer 的时候，RunLoop 会持有这个 Timer 的强引用，如果你创建了一个 repeating timer，在下一次回调前就把这个 timer release了，那么 runloop 回调的时候就会找不到对象而 Crash。

解决方案: 我写了个宏用来释放Timer
----------------
/*
 * 判断这个Timer不为nil则停止并释放
 * 如果不先停止可能会导致crash
 */
#define WVSAFA_DELETE_TIMER(timer) { \
    if (timer != nil) { \
        [timer invalidate]; \
        [timer release]; \
        timer = nil; \
    } \
}
-----------------

合理性假设第三条：尽可能的查找就有可能性的具体原因。

因果性分析

首先必须先说明的是，我们要找的是“因果性”而不是“相关性“。这是两个极度被混淆的概念。而且，很多时候我们错误的把相关性当成了因果性。比如，在解决一个多线程问题的时候，发现了一个数据混乱的问题，但是百思不得其解。终于，有一天你意外的给某个对象加了个锁，数据就正常了。然后你就说这个问题是这个对象没有加锁导致的。

但是，根据上述你的分析，只能够得出该对象加锁与否与数据异常有关系，而不能得出就是数据异常的原因。因为你没能证明对象加锁是数据异常的充分必要条件，而只是使用了一个单因变量实验，变量是加锁状态，取值x=[0，1],x为整型。然后实验结果是加锁与否与数据异常呈现正相关性。

相关性：在概率论和统计学中，相关（Correlation，或称相关系数或关联系数），显示两个随机变量之间线性关系的强度和方向。在统计学中，相关的意义是用来衡量两个变量相对于其相互独立的距离。在这个广义的定义下，有许多根据数据特点而定义的用来衡量数据相关的系数。  

因果性：因果是一个事件（即“因”）和第二个事件（即“果”）之间的关系，其中后一事件被认为是前一事件的结果。

错误的把相关性等价于因果性。不止是程序员，几乎所有人常见的逻辑错误。为了加深认识，可以看一下这篇小科普：相关性 ≠ 因果性。

// ----------
有时候app crash的时候会看到类似如下的信息，除此之外就再也没有其他信息了
MyApp [4413:40b] -[UIImage isKindOfClass]: message sent to deallocated instance 0x4dbb170
这时候的错误定位方法如下：
－ 使用gdb调试时，在debug窗口输入：info malloc-history 0x4dbb170（这里写已经dead的内存地址
－ 使用lldb调试［此方法仅适用于模拟器调试，需要勾选scheme中Malloc Stack选项］，打开terminal，su权限（没su权限可能会报错）
   输入：malloc_history 4413 0x4dbb170 //4413是这个app的进程pid，在报错信息中能找到MyApp [4413:40b]
// -------
