
一个 Functor (函子) 就是一种实现了 Functor typeclass 的数据类型；
一个 Applicative 就是一种实现了 Applicative typeclass 的数据类型；
一个 Monad 就是一种实现了 Monad typeclass 的数据类型。

Applicative 是增强型的 Functor ，一种数据类型要成为 Applicative 的前提条件是它必须是 Functor ；同样的，Monad 是增强型的 Applicative ，一种数据类型要成为 Monad 的前提条件是它必须是 Applicative 。

RAC(self, objectProperty) = objectSignal;
RAC(self, stringProperty, @"foobar") = stringSignal;
RAC(self, integerProperty, @42) = integerSignal;


信号源

    RACStream
    RACSignal
    RACSubject
    RACSequence

订阅者

    RACSubscriber
    RACMulticastConnection

调度器

    RACScheduler

清洁工

    RACDisposable



信号源：RACStream 及其子类；
订阅者：RACSubscriber 的实现类及其子类；
调度器：RACScheduler 及其子类；
清洁工：RACDisposable 及其子类。


// 信号源 
RACStream 

- RACSignal

-- RACSubject :
RACSubject 代表的是可以手动控制的信号，我们可以把它看作是 RACSignal 的可变版本，就好比 NSMutableArray 是 NSArray 的可变版本一样。RACSubject 继承自 RACSignal ，所以它可以作为信号源被订阅者订阅，同时，它又实现了 RACSubscriber 协议，所以它也可以作为订阅者订阅其他信号源，这个就是 RACSubject 为什么可以手动控制的原因
--- RACGroupedSignal ：分组信号，用来实现 RACSignal 的分组功能；
--- RACBehaviorSubject ：重演最后值的信号，当被订阅时，会向订阅者发送它最后接收到的值；
	    
--- RACReplaySubject ：重演信号，保存发送过的值，当被订阅时，会向订阅者重新发送这些值。

    RACEmptySignal ：空信号，用来实现 RACSignal 的 +empty 方法；
    RACReturnSignal ：一元信号，用来实现 RACSignal 的 +return: 方法；
    RACDynamicSignal ：动态信号，使用一个 block 来实现订阅行为，我们在使用 RACSignal 的 +createSignal: 方法时创建的就是该类的实例；
    RACErrorSignal ：错误信号，用来实现 RACSignal 的 +error: 方法；
    RACChannelTerminal ：通道终端，代表 RACChannel 的一个终端，用来实现双向绑定。

- RACSequence
RACSequence 代表的是一个不可变的值的序列，与 RACSignal 不同，它是 pull-driven 类型的流。从严格意义上讲，RACSequence 并不能算作是信号源，因为它并不能像 RACSignal 那样，可以被订阅者订阅，但是它与 RACSignal 之间可以非常方便地进行转换。

从理论上说，一个 RACSequence 由两部分组成：

    head ：指的是序列中的第一个对象，如果序列为空，则为 nil ；
    tail ：指的是序列中除第一个对象外的其它所有对象，同样的，如果序列为空，则为 nil 。

一个序列的 tail 也可以看作是由 head 和 tail 组成，而这个新的 tail 又可以继续看作是由 head 和 tail 组成，这个过程可以一直进行下去。而这个就是 RACSequence 得以建立的理论基础，所以一个 RACSequence 子类的最小实现就是 head 和 tail。

总的来说，RACSequence 存在的最大意义就是为了简化 Objective-C 中的集合操作：

比如下面的代码：

NSMutableArray *results = [NSMutableArray array];
for (NSString *str in strings) {
    if (str.length < 2) {
        continue;
    }

    NSString *newString = [str stringByAppendingString:@"foobar"];
    [results addObject:newString];
}

可以用 RACSequence 来优雅地实现：

RACSequence *results = [[strings.rac_sequence
    filter:^ BOOL (NSString *str) {
        return str.length >= 2;
    }]
    map:^(NSString *str) {
        return [str stringByAppendingString:@"foobar"];
    }];

因此，我们可以非常方便地使用 RACSequence 来实现集合的链式操作，直到得到你想要的最终结果为止。除此之外，使用 RACSequence 的另外一个主要好处是，RACSequence 中包含的值在默认情况下是懒计算的，即只有在真正用到的时候才会被计算，并且只会计算一次。

同样的，RACSequence 的一系列功能也是通过类簇来实现的，它共有九个用来实现不同功能的私有子类：

    RACUnarySequence ：一元序列，用来实现 RACSequence 的 +return: 方法；
    RACIndexSetSequence ：用来遍历索引集；
    RACEmptySequence ：空序列，用来实现 RACSequence 的 +empty 方法；
    RACDynamicSequence ：动态序列，使用 blocks 来动态地实现一个序列；
    RACSignalSequence ：用来遍历信号中的值；
    RACArraySequence ：用来遍历数组中的元素；
    RACEagerSequence ：非懒计算的序列，在初始化时立即计算所有的值；
    RACStringSequence ：用来遍历字符串中的字符；
    RACTupleSequence ：用来遍历元组中的元素。

RACSequence 为类簇提供了统一的对外接口，对于使用它的客户端代码来说，完全不需要知道私有子类的存在，很好地隐藏了实现细节。另外，值得一提的是，RACSequence 实现了快速枚举的协议 NSFastEnumeration ，在这个协议中只声明了一个看上去非常抽筋的方法：

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(id __unsafe_unretained [])buffer count:(NSUInteger)len;

我们也可以直接使用 for in 来遍历一个 RACSequence 。

// 订阅者
RACSubscriber 为了获取信号源中的值，我们需要对信号源进行订阅。在 ReactiveCocoa 中，订阅者是一个抽象的概念，所有实现了 RACSubscriber 协议的类都可以作为信号源的订阅者。

在 RACSubscriber 协议中，声明了四个必须实现的方法：

其中 -sendNext: 、-sendError: 和 -sendCompleted 分别用来从 RACSignal 接收 next 、error 和 completed 事件，而 -didSubscribeWithDisposable: 则用来接收代表某次订阅的 disposable 对象。

注意：在 ReactiveCocoa 中并没有专门的类 RACSubscription 来代表一次订阅，而间接地使用 RACDisposable 来充当这一角色。因此，一个 RACDisposable 对象就代表着一次订阅，并且我们可以用它来取消这次订阅。

除了 RACSignal 的子类外，还有两个实现了 RACSubscriber 协议的类: RACSubscriber 和 RACPassthroughSubscriber。

RACSubscriber 类的名字与 RACSubscriber 协议的名字相同，这跟 Objective-C 中的 NSObject 类的名字与 NSObject 协议的名字相同是一样的。
通常来说，RACSubscriber 类充当的角色就是信号源的真正订阅者，它老老实实地实现了 RACSubscriber 协议。

在 ReactiveCocoa 中，一个订阅者是可以订阅多个信号源的，也就是说它会拥有多个 RACDisposable 对象，并且它可以随时取消其中任何一个订阅。为了实现这个功能，ReactiveCocoa 就引入了 RACPassthroughSubscriber 类，它是 RACSubscriber 类的一个装饰器，封装了一个真正的订阅者 RACSubscriber 对象，它负责转发所有事件给这个真正的订阅者，而当此次订阅被取消时，它就会停止转发

RACMulticastConnection 让多个订阅者之间共享一次订阅
RACMulticastConnection 通过一个标志 _hasConnected 来保证只对 sourceSignal 订阅一次，然后对外暴露一个 RACSubject 类型的 signal 供外部订阅者订阅。这样一来，不管外部订阅者对 signal 订阅多少次，我们对 sourceSignal 的订阅至多只会有一次

// 调度者
有了信号源和订阅者，我们还需要由调度器来统一调度订阅者订阅信号源的过程中所涉及到的任务，这样才能保证所有的任务都能够合理有序地执行。

RACScheduler 在 ReactiveCocoa 中就是扮演着调度器的角色，本质上，它就是用 GCD 的串行队列来实现的，并且支持取消操作。是的，在 ReactiveCocoa 中，并没有使用到 NSOperationQueue 和 NSRunloop 等技术，RACScheduler 也只是对 GCD 的简单封装而已。

同样的，RACScheduler 的一系列功能也是通过类簇来实现的，除了用来测试的子类外，总共还有四个私有子类：

    RACImmediateScheduler ：立即执行调度的任务，这是唯一一个支持同步执行的调度器；
    RACQueueScheduler ：一个抽象的队列调度器，在一个 GCD 串行列队中异步调度所有任务；
    RACTargetQueueScheduler ：继承自 RACQueueScheduler ，在一个以一个任意的 GCD 队列为 target 的串行队列中异步调度所有任务；
    RACSubscriptionScheduler ：一个只用来调度订阅的调度器。

值得一提的是，在 RACScheduler 中有一个非常特殊的方法：

- (RACDisposable *)scheduleRecursiveBlock:(RACSchedulerRecursiveBlock)recursiveBlock;

这个方法的作用非常有意思，它可以将递归调用转换成迭代调用，这样做的目的是为了解决深层次的递归调用可能会带来的堆栈溢出问题。

清洁工

正如我们前面所说的，在订阅者订阅信号源的过程中，可能会产生副作用或者消耗一定的资源，所以当我们在取消订阅或者完成订阅时，我们就需要做一些资源回收和垃圾清理的工作。
RACDisposable

RACDisposable 在 ReactiveCocoa 中就充当着清洁工的角色，它封装了取消和清理一次订阅所必需的工作。它有一个核心的方法 -dispose ，调用这个方法就会执行相应的清理工作，这有点类似于 NSObject 的 -dealloc 方法。RACDisposable 总共有四个子类：

    RACSerialDisposable ：作为 disposable 的容器使用，可以包含一个 disposable 对象，并且允许将这个 disposable 对象通过原子操作交换出来；
    RACKVOTrampoline ：代表一次 KVO 观察，并且可以用来停止观察；
    RACCompoundDisposable ：跟 RACSerialDisposable 一样，RACCompoundDisposable 也是作为 disposable 的容器使用。不同的是，它可以包含多个 disposable 对象，并且支持手动添加和移除 disposable 对象，有点类似于可变数组 NSMutableArray 。而当一个 RACCompoundDisposable 对象被 disposed 时，它会调用其所包含的所有 disposable 对象的 -dispose 方法，有点类似于 autoreleasepool 的作用;
    RACScopedDisposable ：当它被 dealloc 的时候调用本身的 -dispose 方法。

咋看之下，RACDisposable 的逻辑似乎有些复杂，不过换汤不换药，不管它们怎么换着花样玩，最终都只是为了能够在合适的时机调用 disposable 对象的 -dispose 方法，执行清理工作而已。

