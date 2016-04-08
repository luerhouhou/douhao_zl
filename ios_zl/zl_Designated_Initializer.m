1. 每个类的正确初始化过程应当是按照从子类到父类的顺序，依次调用每个类的Designated Initializer。并且用父类的Designated Initializer初始化一个子类对象，也需要遵从这个过程。
2. 如果子类指定了新的初始化器，那么在这个初始化器内部必须调用父类的Designated Initializer。并且需要重写父类的Designated Initializer，将其指向子类新的初始化器。
3. 你可以不自定义Designated Initializer，也可以重写父类的Designated Initializer，但需要调用直接父类的Designated Initializer。
4. 如果有多个Secondary initializers(次要初始化器)，它们之间可以任意调用，但最后必须指向Designated Initializer。在Secondary initializers内不能直接调用父类的初始化器。因为直接调用父类初始化器就不会调用自定义的初始化器。不能正确的初始化。
5. 如果有多个不同数据源的Designated Initializer，那么不同数据源下的Designated Initializer应该调用相应的[super (designated initializer)]。如果父类没有实现相应的方法，则需要根据实际情况来决定是给父类补充一个新的方法还是调用父类其他数据源的Designated Initializer。比如UIView的initWithCoder调用的是NSObject的init。
6. 需要注意不同数据源下添加额外初始化动作的时机。
使用Category添加对应的实现方法。

建议将initWithCoder:视为Secondary initializers，然后在里面调用[self (designated initializer)]。这样做的目的是为了保证[self (designated initializer)]会被调用，以保证初始化是正确的。

#import "TestInitView.h"

@implementation TestInitView

//super override
- (id)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame andName:@""];
}

//Designated Initializer
- (instancetype)initWithFrame:(CGRect)frame andName:(NSString *)name{
    if (self = [super initWithFrame:frame]){
        [self someInit];
        self.name=name;
        //correct From Name
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    if (self=[super initWithCoder:aDecoder]) {
        self.name=[aDecoder decodeObjectForKey:@"name"];
        //correct From NSKeyedUnarchiver
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [super encodeWithCoder:aCoder];
    [aCoder encodeObject:self.name forKey:@"name"];
}

- (void)awakeFromNib{
    [super awakeFromNib];
    [self someInit];
    //correct From UINibDecoder
}

- (void)someInit{
    self.name=@"";
    //anyelse....
}

@end

在你需要标示为Designated Initializer的方法后面加上 NS_DESIGNATED_INITIALIZER。

/* XCode 5.0 Compatibility for NS_DESIGNATED_INITIALIZER*/
#ifndef NS_DESIGNATED_INITIALIZER
    #if __has_attribute(objc_designated_initializer)
        #define NS_DESIGNATED_INITIALIZER __attribute__((objc_designated_initializer))
    #else
        #define NS_DESIGNATED_INITIALIZER
    #endif
#endif
加上这个宏后，当没有按规定实现初始化方法时，Xcode会提示警告信息。

