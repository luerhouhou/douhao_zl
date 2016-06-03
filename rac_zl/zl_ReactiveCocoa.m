
Cell.rac_prepareForReuseSignal 定义当前信息的有效期
[[[RACObserve(model, computedProfitColor) ignore:nil] takeUntil:self.rac_prepareForReuseSignal] subscribeNext:^(UIColor *x) {
     @strongify(self)
     self.oProfitLabel.textColor = x;
}];

当前的model绑定有效期一直到 self.rac_prepareForReuseSignal触发。（Cell重用时触发。解除旧的数据绑定，添加新的数据绑定）
接触RAC兼职绑定。
RAC(self.nameLabel, text) = [RACObserve(item, name) takeUntil:self.rac_prepareForReuseSignal];

ReactiveCocoa 2

ReactiveCocoa是Github开源的一款cocoa FRP 框架

Native app有很大一部分的时间是在等待事件发生，然后响应事件，比如等待网络请求完成，等待用户的操作，等待某些状态值的改变等等，等这些事件发生后，再做进一步处理。 但是这些等待和响应，并没有一个统一的处理方式。Delegate, Notification, Block, KVO, 常常会不知道该用哪个最合适。有时需要chain或者compose某几个事件，就需要多个状态变量，而状态变量一多，复杂度也就上来了。为了解决这些问题，Github的工程师们开发了ReactiveCocoa。

--
// 只有当名字以'j'开头，才会被记录
[[RACObserve(self.username)
   filter:^(NSString *newName) {
       return [newName hasPrefix:@"j"];
   }]
   subscribeNext:^(NSString *newName) {
       NSLog(@"%@", newName);
   }];

[Network Request && Async work]
一个异步网络操作，可以返回一个subject，然后将这个subject绑定到一个subscriber或另一个信号。

- (void)doTest
{
    RACSubject *subject = [self doRequest];
    
    [subject subscribeNext:^(NSString *value){
        NSLog(@"value:%@", value);
    }];
}

- (RACSubject *)doRequest
{
    RACSubject *subject = [RACSubject subject];
    // 模拟2秒后得到请求内容
    // 只触发1次
    // 尽管subscribeNext什么也没做，但如果没有的话map是不会执行的
    // subscribeNext就是定义了一个接收体
    [[[[RACSignal interval:2] take:1] map:^id(id _){
        // the value is from url request
        NSString *value = @"content fetched from web";
        [subject sendNext:value];
        return nil;
    }] subscribeNext:^(id _){}];
    return subject;
}

SequenceNext
--


--
Signal获取到数据后，会调用Subscriber的sendNext, sendComplete, sendError方法来传送数据给Subscriber，Subscriber自然也有方法来获取传过来的数据，如：[signal subscribeNext:error:completed]。这样只要没有sendComplete和sendError，新的值就会通过sendNext源源不断地传送过来，举个简单的例子：

[RACObserve(self, username) subscribeNext: ^(NSString *newName){
    NSLog(@"newName:%@", newName);
}];

RACObserve使用了KVO来监听property的变化，只要username被自己或外部改变，block就会被执行。但不是所有的property都可以被RACObserve，该property必须支持KVO，比如NSURLCache的currentDiskUsage就不能被RACObserve。

Signal是很灵活的，它可以被修改(map)，过滤(filter)，叠加(combine)，串联(chain)，这有助于应对更加复杂的情况，比如：

--
冷信号(Cold)和热信号(Hot)

上面提到过这两个概念，冷信号默认什么也不干，比如下面这段代码

RACSignal *signal = [RACSignal createSignal:^ RACDisposable * (id<RACSubscriber> subscriber) {
    NSLog(@"triggered");
    [subscriber sendNext:@"foobar"];
    [subscriber sendCompleted];
    return nil;
}];
我们创建了一个Signal，但因为没有被subscribe，所以什么也不会发生。加了下面这段代码后，signal就处于Hot的状态了，block里的代码就会被执行。

[signal subscribeCompleted:^{
    NSLog(@"subscription %u", subscriptions);
}];
或许你会问，那如果这时又有一个新的subscriber了，signal的block还会被执行吗？这就牵扯到了另一个概念：Side Effect

Side Effect

还是上面那段代码，如果有多个subscriber，那么signal就会又一次被触发，控制台里会输出两次triggered。这或许是你想要的，或许不是。如果要避免这种情况的发生，可以使用 replay 方法，它的作用是保证signal只被触发一次，然后把sendNext的value存起来，下次再有新的subscriber时，直接发送缓存的数据

--
UIView Categories

上面看到的rac_textSignal是加在UITextField上的(UITextField+RACSignalSupport.h)，其他常用的UIView也都有添加相应的category，比如UIAlertView，就不需要再用Delegate了。

UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"Alert" delegate:nil cancelButtonTitle:@"YES" otherButtonTitles:@"NO", nil];
[[alertView rac_buttonClickedSignal] subscribeNext:^(NSNumber *indexNumber) {
    if ([indexNumber intValue] == 1) {
        NSLog(@"you touched NO");
    } else {
        NSLog(@"you touched YES");
    }
}];
[alertView show];

--


--

这样好用的ReactiveCocoa，根本停不下来

    你唱歌，我就跳舞

    RACSignal *signalA = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@"唱歌"];
        [subscriber sendCompleted];
        return nil;
    }];
    RAC(self, value) = [signalA map:^id(NSString* value) {
        if ([value isEqualToString:@"唱歌"]) {
            return @"跳舞";
        }
        return @"";
    }];

map 会触发 signal 运行；

双边

    你向西，他就向东，他向左，你就向右。

    RACChannelTerminal *channelA = RACChannelTo(self, valueA);
    RACChannelTerminal *channelB = RACChannelTo(self, valueB);
    [[channelA map:^id(NSString *value) {
        if ([value isEqualToString:@"西"]) {
            return @"东";
        }
        return value;
    }] subscribe:channelB];
    [[channelB map:^id(NSString *value) {
        if ([value isEqualToString:@"左"]) {
            return @"右";
        }
        return value;
    }] subscribe:channelA];
    [RACObserve(self, valueA) subscribeNext:^(NSString* x) {
        NSLog(@"你向%@", x);
    }];
    [RACObserve(self, valueB) subscribeNext:^(NSString* x) {
        NSLog(@"他向%@", x);
    }];
    self.valueA = @"西";
    self.valueB = @"左";

2015-08-15 20:14:46.544 Test[2440:99901] 你向西  
2015-08-15 20:14:46.544 Test[2440:99901] 他向东  
2015-08-15 20:14:46.545 Test[2440:99901] 他向左  
2015-08-15 20:14:46.545 Test[2440:99901] 你向右  

代理

    你是程序员，你帮我写个app吧。

@protocol Programmer <NSObject>
- (void)makeAnApp;
@end

RACSignal *ProgrammerSignal =  
[self rac_signalForSelector:@selector(makeAnApp)
               fromProtocol:@protocol(Programmer)];
[ProgrammerSignal subscribeNext:^(RACTuple* x) {
    NSLog(@"花了一个月，app写好了");
}];
[self makeAnApp];

2015-08-15 20:46:45.720 Test[2817:114564] 花了一个月，app写好了  

广播

    知道你的频道，我就能听到你了。

    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"代码之道频道" object:nil] subscribeNext:^(NSNotification* x) {
        NSLog(@"技巧：%@", x.userInfo[@"技巧"]);
    }];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"代码之道频道" object:nil userInfo:@{@"技巧":@"用心写"}];

2015-08-15 20:41:15.786 Test[2734:111505] 技巧：用心写  

连接

    生活是一个故事接一个故事。

    RACSignal *signalA = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@"我恋爱啦"];
        [subscriber sendCompleted];
        return nil;
    }];
    RACSignal *signalB = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@"我结婚啦"];
        [subscriber sendCompleted];
        return nil;
    }];
    // 将一个信号流添加到另一个信号流后面。
    [[signalA concat:signalB] subscribeNext:^(id x) {
        NSLog(@"%@",x);
    }];

2015-08-15 12:19:46.707 Test[1845:64122] 我恋爱啦  
2015-08-15 12:19:46.707 Test[1845:64122] 我结婚啦  

合并

    污水都应该流入污水处理厂被处理。

    RACSignal *signalA = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@"纸厂污水"];
        return nil;
    }];
    RACSignal *signalB = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@"电镀厂污水"];
        return nil;
    }];
    [[RACSignal merge:@[signalA, signalB]] subscribeNext:^(id x) {
        NSLog(@"处理%@",x);
    }];

2015-08-15 12:10:05.371 Test[1770:60147] 处理纸厂污水  
2015-08-15 12:10:05.372 Test[1770:60147] 处理电镀厂污水  

组合

    你是红的，我是黄的，我们就是红黄的，你是白的，我没变，我们是白黄的。

    RACSignal *signalA = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@"红"];
        [subscriber sendNext:@"白"];
        return nil;
    }];
    RACSignal *signalB = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@"白"];
        return nil;
    }];
    [[RACSignal combineLatest:@[signalA, signalB]] subscribeNext:^(RACTuple* x) {
        RACTupleUnpack(NSString *stringA, NSString *stringB) = x;
        NSLog(@"我们是%@%@的", stringA, stringB);
    }];

2015-08-15 12:14:19.837 Test[1808:62042] 我们就是红黄的  
2015-08-15 12:14:19.837 Test[1808:62042] 我们是白黄的  

压缩

    你是红的，我是黄的，我们就是红黄的，你是白的，我没变，哦，那就等我变了再说吧。

    RACSignal *signalA = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@"红"];
        [subscriber sendNext:@"白"];
        return nil;
    }];
    RACSignal *signalB = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@"白"];
        return nil;
    }];
    [[signalA zipWith:signalB] subscribeNext:^(RACTuple* x) {
        RACTupleUnpack(NSString *stringA, NSString *stringB) = x;
        NSLog(@"我们是%@%@的", stringA, stringB);
    }];

2015-08-15 20:34:24.274 Test[2660:108483] 我们是红白的  

映射

    我可以点石成金。

    RACSignal *signal = [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@"石"];
        return nil;
    }] map:^id(NSString* value) {
        if ([value isEqualToString:@"石"]) {
            return @"金";
        }
        return value;
    }];
    [signal subscribeNext:^(id x) {
        NSLog(@"%@", x);
    }];

2015-08-16 20:00:12.853 Test[740:15871] 金  

归约

    糖加水变成糖水。

    RACSignal *sugarSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@"糖"];
        return nil;
    }];
    RACSignal *waterSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@"水"];
        return nil;
    }];
    [[RACSignal combineLatest:@[sugarSignal, waterSignal] reduce:^id (NSString* sugar, NSString*water){
        return [sugar stringByAppendingString:water];
    }] subscribeNext:^(id x) {
        NSLog(@"%@", x);
    }];

2015-08-16 20:07:00.356 Test[807:19177] 糖水  

过滤

    未满十八岁，禁止进入。

    [[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@(15)];
        [subscriber sendNext:@(17)];
        [subscriber sendNext:@(21)];
        [subscriber sendNext:@(14)];
        [subscriber sendNext:@(30)];
        return nil;
    }] filter:^BOOL(NSNumber* value) {
        return value.integerValue >= 18;
    }] subscribeNext:^(id x) {
        NSLog(@"%@", x);
    }];

2015-08-16 20:11:20.071 Test[860:21214] 21  
2015-08-16 20:11:20.071 Test[860:21214] 30

扁平

    打蛋液，煎鸡蛋，上盘。

    [[[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSLog(@"打蛋液");
        [subscriber sendNext:@"蛋液"];
        [subscriber sendCompleted];
        return nil;
    }] flattenMap:^RACStream *(NSString* value) {
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            NSLog(@"把%@倒进锅里面煎",value);
            [subscriber sendNext:@"煎蛋"];
            [subscriber sendCompleted];
            return nil;
        }];
    }] flattenMap:^RACStream *(NSString* value) {
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            NSLog(@"把%@装到盘里", value);
            [subscriber sendNext:@"上菜"];
            [subscriber sendCompleted];
            return nil;
        }];
    }] subscribeNext:^(id x) {
        NSLog(@"%@", x);
    }];

2015-08-16 20:39:34.786 Test[1226:34386] 打蛋液  
2015-08-16 20:39:34.787 Test[1226:34386] 把蛋液倒进锅里面煎  
2015-08-16 20:39:34.787 Test[1226:34386] 把煎蛋装到盘里  
2015-08-16 20:39:34.787 Test[1226:34386] 上菜  

秩序

    把大象塞进冰箱只需要三步：打开冰箱门，把大象塞进冰箱，关上冰箱门。

    [[[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSLog(@"打开冰箱门");
        [subscriber sendCompleted];
        return nil;
    }] then:^RACSignal *{
       return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
           NSLog(@"把大象塞进冰箱");
           [subscriber sendCompleted];
           return nil;
       }];
    }] then:^RACSignal *{
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            NSLog(@"关上冰箱门");
            [subscriber sendCompleted];
            return nil;
        }];
    }] subscribeCompleted:^{
        NSLog(@"把大象塞进冰箱了");
    }];

2015-08-16 20:45:27.724 Test[1334:37870] 打开冰箱门  
2015-08-16 20:45:27.725 Test[1334:37870] 把大象塞进冰箱  
2015-08-16 20:45:27.725 Test[1334:37870] 关上冰箱门  
2015-08-16 20:45:27.726 Test[1334:37870] 把大象塞进冰箱了  

命令

    我命令你马上投降。

    RACCommand *aCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
       return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
           NSLog(@"我投降了");
           [subscriber sendCompleted];
           return nil;
       }];
    }];
    [aCommand execute:nil];

2015-08-16 20:54:32.492 Test[1450:41849] 我投降了

延迟

    等等我，我还有10秒钟就到了。

    [[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSLog(@"等等我，我还有10秒钟就到了");
        [subscriber sendNext:nil];
        [subscriber sendCompleted];
        return nil;
    }] delay:10] subscribeNext:^(id x) {
        NSLog(@"我到了");
    }];

2015-08-16 21:00:57.622 Test[1619:45924] 等等我，我还有10秒钟就到了  
2015-08-16 21:01:07.624 Test[1619:45924] 我到了  

重放

    一次制作，多次观看。

//如果有多个subscriber，那么signal就会又一次被触发，控制台里会输出两次triggered。这或许是你想要的，或许不是。如果要避免这种情况的发生，可以使用 replay 方法，它的作用是保证signal只被触发一次，然后把sendNext的value存起来，下次再有新的subscriber时，直接发送缓存的数据。

    RACSignal *replaySignal = [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSLog(@"大导演拍了一部电影《我的男票是程序员》");
        [subscriber sendNext:@"《我的男票是程序员》"];
        return nil;
    }] replay];
    [replaySignal subscribeNext:^(id x) {
        NSLog(@"小明看了%@", x);
    }];
    [replaySignal subscribeNext:^(id x) {
        NSLog(@"小红也看了%@", x);
    }];

2015-08-16 21:18:38.002 Test[1854:54712] 大导演拍了一部电影《我的男票是程序员》  
2015-08-16 21:18:38.004 Test[1854:54712] 小明看了《我的男票是程序员》  
2015-08-16 21:18:38.004 Test[1854:54712] 小红也看了《我的男票是程序员》  

定时

    每隔8个小时服一次药。

    [[RACSignal interval:60*60*8 onScheduler:[RACScheduler mainThreadScheduler]] subscribeNext:^(id x) {
        NSLog(@"吃药");
    }];

超时

    等了你一个小时了，你还没来，我走了。

    [[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            NSLog(@"我快到了");
            [subscriber sendNext:nil];
            [subscriber sendCompleted];
            return nil;
        }] delay:60*70] subscribeNext:^(id x) {
            [subscriber sendNext:nil];
            [subscriber sendCompleted];
        }];
        return nil;
    }] timeout:60*60 onScheduler:[RACScheduler mainThreadScheduler]] subscribeError:^(NSError *error) {
        NSLog(@"等了你一个小时了，你还没来，我走了");
    }];

2015-08-16 21:40:09.068 Test[2041:64720] 我快到了  
2015-08-16 22:40:10.048 Test[2041:64720] 等了你一个小时了，你还没来，我走了  

重试

    成功之前可能需要数百次失败。

    __block int failedCount = 0;
    [[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        if (failedCount < 100) {
            failedCount++;
            NSLog(@"我失败了");
            [subscriber sendError:nil];
        }else{
            NSLog(@"经历了数百次失败后");
            [subscriber sendNext:nil];
        }
        return nil;
    }] retry] subscribeNext:^(id x) {
        NSLog(@"终于成功了");
    }];

2015-08-16 21:59:07.159 Test[2411:77080] 我失败了  
2015-08-16 21:59:07.159 Test[2411:77080] 我失败了  
2015-08-16 21:59:07.159 Test[2411:77080] 我失败了  
2015-08-16 21:59:07.159 Test[2411:77080] 我失败了  
2015-08-16 21:59:07.160 Test[2411:77080] 我失败了  
2015-08-16 21:59:07.160 Test[2411:77080] 我失败了  
2015-08-16 21:59:07.161 Test[2411:77080] 我失败了  
2015-08-16 21:59:07.162 Test[2411:77080] 我失败了  
...
2015-08-16 21:59:07.162 Test[2411:77080] 我失败了  
2015-08-16 21:59:07.163 Test[2411:77080] 我失败了  
2015-08-16 21:59:07.163 Test[2411:77080] 我失败了  
2015-08-16 21:59:07.163 Test[2411:77080] 我失败了  
2015-08-16 21:59:07.164 Test[2411:77080] 我失败了  
2015-08-16 21:59:07.164 Test[2411:77080] 我失败了  
2015-08-16 21:59:07.164 Test[2411:77080] 我失败了  
2015-08-16 21:59:07.165 Test[2411:77080] 经历了数百次失败后  
2015-08-16 21:59:07.165 Test[2411:77080] 终于成功了  

节流

    不好意思，这里一秒钟只能通过一个人。

    [[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@"旅客A"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [subscriber sendNext:@"旅客B"];
        });
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [subscriber sendNext:@"旅客C"];
            [subscriber sendNext:@"旅客D"];
            [subscriber sendNext:@"旅客E"];
        });
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [subscriber sendNext:@"旅客F"];
        });
        return nil;
    }] throttle:1] subscribeNext:^(id x) {
        NSLog(@"%@通过了",x);
    }];

2015-08-16 22:08:45.677 Test[2618:83764] 旅客A  
2015-08-16 22:08:46.737 Test[2618:83764] 旅客B  
2015-08-16 22:08:47.822 Test[2618:83764] 旅客E  
2015-08-16 22:08:48.920 Test[2618:83764] 旅客F  

条件

    直到世界的尽头才能把我们分开。

    [[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [[RACSignal interval:1 onScheduler:[RACScheduler mainThreadScheduler]] subscribeNext:^(id x) {
            [subscriber sendNext:@"直到世界的尽头才能把我们分开"];
        }];
        return nil;
    }] takeUntil:[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSLog(@"世界的尽头到了");
            [subscriber sendNext:@"世界的尽头到了"];
        });
        return nil;
    }]] subscribeNext:^(id x) {
        NSLog(@"%@", x);
    }];

2015-08-16 22:17:22.648 Test[2766:88737] 直到世界的尽头才能把我们分开  
2015-08-16 22:17:23.648 Test[2766:88737] 直到世界的尽头才能把我们分开  
2015-08-16 22:17:24.645 Test[2766:88737] 直到世界的尽头才能把我们分开  
2015-08-16 22:17:25.648 Test[2766:88737] 直到世界的尽头才能把我们分开  
2015-08-16 22:17:26.644 Test[2766:88737] 直到世界的尽头才能把我们分开  
2015-08-16 22:17:26.645 Test[2766:88737] 世界的尽头到了  

完事

ReactiveCocoa是如此优雅，一旦使用，根本停不下来，上面也只是它的一角冰山，但愿我能挑起你的兴趣。
