登录注册 根据token获取用户信息，这三个接口：


大象：
1. 登录 login http://test.yg.device.baidao.com/jry-device/login
2. 注册 register http://test.yg.device.baidao.com/jry-device/ajax/register
3. 更改用户信息 updateUserDetail http://test.yg.device.baidao.com/jry-device/ajax/user/updateUserDetail.do
4. 更改头像 uploadUserImage http://test.yg.device.baidao.com/jry-device/ajax/user/uploadUserImage
5. 重置密码 resetPassword http://test.yg.device.baidao.com/jry-device/ajax/user/resetPassword
6. 获取(注册)验证码 getVerificationCode http://test.yg.device.baidao.com/jry-device/ajax/verificationCode
7. 获取(更改密码)验证码 getVerificationCodeToResetPassword http://test.yg.device.baidao.com/jry-device/ajax/user/verificationCode
p4:
1. 根据token获取用户信息 getUserInfon  http://tt.device.baidao.com/jry-device/ajax/user/getUserByToken.do
2. 绑定手机 bindUserMobileAndPassword  http://tt.device.baidao.com/jry-device/ajax/user/bindPhonePassword?

3. 已登录用户开户成功，需要重新登录 needLogout http://www.baidao.com/sso/ajax/needLogout
这个是因为，CRM里面有个开户审核，审核通过以后，就有交易账号，然后需要更新用户信息，提示用户重新登录。
4. 游客使用第三方登录接口注册 authentications http://www.baidao.com/sso/authentications/open
请求参数:
@{
@"userInfo" : @{
    @"nickname" : @"访客_苹果",
    @"sex" : @(0),
    @"marketId" : [AppInfo marketId],
    @"serverId" : @(YG)
},
@"authentication" : @{  @"accessToken" : [ASIdentifierManager sharedManager].advertisingIdentifier.UUIDString,
    @"expiresIn" : @(7199),
    @"openId" : [ASIdentifierManager sharedManager].advertisingIdentifier.UUIDString,
    @"platform" : @"YTXGuestChat"
}
};













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

[RACSignal]
[normal RACSignal]使用createSignal创建：
每增加一个订阅者就重新执行一遍。a normal RACSignal can be thought of as lazy, as it doesn’t do any work until it has a subscriber.
RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id  subscriber) {
      num++;
      NSLog(@"Increment num to: %i", num);
      [subscriber sendNext:@(num)];
      return nil;
  }];
冷信号，当存在订阅者时才会执行

[使用RACSubject 创建的 RACSignal]:
RACSubject *letters = [RACSubject subject];// 1
RACSignal *signal = letters;
[signal subscribeNext:^(id x) {// 2
      NSLog(@"S1: %@", x);
  }];
[letters sendNext:@"A"];// 3

热信号，类似发送广播，只有已经订阅的才能收到消息。

[-replay, -replayLast, and -replayLazily]

// 普通信号
__block int num = 0;
RACSignal *signal = [[RACSignal createSignal:^RACDisposable *(id  subscriber) {
    num++;
    NSLog(@"Increment num to: %i", num);
    [subscriber sendNext:@(num)];
    return nil;
}] replay];

NSLog(@"Start subscriptions");

// Subscriber 1 (S1)
[signal subscribeNext:^(id x) {
    NSLog(@"S1: %@", x);
}];

// Subscriber 2 (S2)
[signal subscribeNext:^(id x) {
    NSLog(@"S2: %@", x);
}];
// 添加 replay 后，signal代码块只会执行一次，每一次subscribeNext都只会传递第一次(这一次，只执行一次)执行(signal代码块)的结果。

RACSubject *letters = [RACSubject subject];
RACSignal *signal = [letters replay];
// 会将所有先前发送的广播发送给后来订阅的用户。

// -replayLast 返回最后一条消息(最后一个执行的sendNext:)。

RACSubject *letters = [RACSubject subject];
RACSignal *signal = [letters replayLast];
// RACSubject 形式的replayLast会取到订阅消息之前的一条消息，然后接着接收后面的消息。

__block int num = 0;
RACSignal *signal = [[RACSignal createSignal:^RACDisposable *(id  subscriber) {
    num++;
    NSLog(@"Increment num to: %i", num);
    [subscriber sendNext:@(num)];
    return nil;
}] replayLazily];
// cold形式的signal。replayLazily 与 replay 行为一致。（signal代码块执行一次，而不管其中有几个sendNext:都会执行），replayLast 只会返回上一次sendNext:的结果。

RACSubject *letters = [RACSubject subject];
RACSignal *signal = [letters replayLazily];
// [RACSubject replayLazily] 与 [RACSubject replay] 的不同之处在于，replayLazily是"懒生成的"，只有当其真正被subscriber时，才会去执行sendNext:，即：在replayLazily没有subscriber之前，所有的sendNext其实都不会执行。


[[view rac_signalForSelector:@selector(mouseDown:)] 
    subscribeNext:^(RACTuple *args) {
        NSEvent *event = args.first;
        NSLog(@"mouse button pressed: %@", event);
    }];

RACSignal *incomingScoresSignal = [[self rac_signalForSelector:@selector(scoreUpdated:timeRemaining:)]
    reduceEach:^id(NSString *score, NSNumber *timeRemaining) {
        return [NSString stringWithFormat:@"%@ with %@ seconds to go", score, timeRemaining];
    }];
// reduceEach 相当于map的作用

 - (RACSignal *)calculateTomorrowsDate {
    return [RACSignal defer:^{
        NSDate *tomorrow = [[NSDate date] dateByAddingTimeInterval:24 * 60 * 60];
        return [RACSignal return:tomorrow];
    }];
 }
// 延后生成 When calling this version of the method, a new signal is created and returned – but the actual work is lazily deferred until something subscribes to the resulting signal.

- (RACSignal *)retrieveScoreUpdates {
 
  @weakify(self)
  RACSignal *startServiceSignal = [RACSignal defer:^RACSignal * {
      @strongify(self)
      [self.scoreService start];
      return [RACSignal empty];
  }];
 
  RACSignal *incomingScoresSignal = 
    [[self rac_signalForSelector:@selector(scoreUpdated:timeRemaining:)]
      reduceEach:^id(NSString *score, NSNumber *timeRemaining) {
        return [NSString stringWithFormat:@"%@ with %@ seconds to go", score, timeRemaining];
      }];
 
  return [RACSignal merge:@[incomingScoresSignal, startServiceSignal]];
}
// 利用merge的副作用来执行[self.scoreService start]。

[RACSignal combineLatest:reduce:  // 当两个信号都有值时，才回触发信号，当其中任何一个值改变，都会再次触发信号，将所有信号的最新的值打包send
RACSubject *letters = [RACSubject subject];
RACSubject *numbers = [RACSubject subject];
RACSignal *combined = [RACSignal
    combineLatest:@[ letters, numbers ]
    reduce:^(NSString *letter, NSString *number) {
       return [letter stringByAppendingString:number];
    }];
 
// Outputs: B1 B2 C2 C3 D3 D4
[combined subscribeNext:^(id x) {
    NSLog(@"%@", x);
}];
 
[letters sendNext:@"A"];
[letters sendNext:@"B"];
[numbers sendNext:@"1"];
[numbers sendNext:@"2"];
[letters sendNext:@"C"];
[numbers sendNext:@"3"];
[letters sendNext:@"D"];
[numbers sendNext:@"4"];

// zip，会按顺序将两个个信号的值进行顺序配对。
RACSubject *letters = [RACSubject subject];
RACSubject *numbers = [RACSubject subject];
 
RACSignal *combined = [RACSignal
    zip:@[ letters, numbers ]
    reduce:^(NSString *letter, NSString *number) {
       return [letter stringByAppendingString:number];
    }];
 
// Outputs: A1 B2 C3 D4
[combined subscribeNext:^(id x) {
    NSLog(@"%@", x);
}];
 
[letters sendNext:@"A"];
[letters sendNext:@"B"];
[numbers sendNext:@"1"];
[numbers sendNext:@"2"];
[letters sendNext:@"C"];
[numbers sendNext:@"3"];
[letters sendNext:@"D"];

// When you need a signal that sends a value each time any of its inputs change, use +combineLatest:. When you need a signal that sends a value only when all of its inputs change, use +zip:.

// 使用RAC代替代理协议：
- (void)viewDidLoad {
  UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame: CGRectZero];
  self.searchController = [[UISearchDisplayController alloc] initWithSearchBar:self.searchBar contentsController:self];
  RAC(self, searchResults) = [self rac_liftSelector:@selector(search:) withSignals:self.searchBar.rac_textSignal, nil];
  RAC(self, searching) = [[self.searchController rac_isActiveSignal] doNext:^(id x) {
      NSLog(@"Searching %@", x);
  }];
}

// -timeout:onScheduler: can be used to manage a long-running asynchronous task. 

