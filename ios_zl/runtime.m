runtime提供了大量的函数来操作类与对象。类的操作方法大部分是以class为前缀的，而对象的操作方法大部分是以objc或object_为前缀。

[类相关操作函数]

// 获取类的类名
const char * class_getName ( Class cls );
如果传入的cls为Nil，则返回一个空字符串。

// 获取类的父类
Class class_getSuperclass ( Class cls );
//当cls为Nil或者cls为根类时，返回Nil。不过通常我们可以使用NSObject类的superclass方法来达到同样的目的。

// 判断给定的Class是否是一个元类
BOOL class_isMetaClass ( Class cls );
如果是cls是元类，则返回YES；如果否或者传入的cls为Nil，则返回NO。

// 获取实例大小
size_t class_getInstanceSize ( Class cls );

// 获取类中指定名称实例成员变量的信息
Ivar class_getInstanceVariable ( Class cls, const char *name );

// 获取类成员变量的信息
Ivar class_getClassVariable ( Class cls, const char *name );

// 添加成员变量
BOOL class_addIvar ( Class cls, const char *name, size_t size, uint8_t alignment, const char *types );

// 获取整个成员变量列表
Ivar * class_copyIvarList ( Class cls, unsigned int *outCount );



