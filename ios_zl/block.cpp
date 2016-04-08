typedef void (^voidBlock) (void)
// 原来的书写方式
@property (copy, nonatomic) void(^cancle)(void);
// 现在的书写方式
@property (copy, nonatomic) voidBlock conform; 

id __weak obj = [[NSObject alloc] init];
弱引用不会+1，所以该新创建的变量引用计数为0，所以会被立即释放，所以编译器会有警>告

__weak 与 __unsafe_unretained 相同的是都不会持有引用的对象。不同的是当引用的对象被废弃时，weak会将自身设置为nil表示空引用，而_unsafe_unretained则不会进行任何处>理，所以，我们可以通过判断weak变量是否是nil来判断对象是否已废弃，而_unsafe_unretained则无法判断引用的对象是否已被废弃，所以使用_unsafe_retained时，需要程序员自>身来保证引用对象的有效性。

MyObject *obj = [[MyObject alloc] init];
[obj method:10];
使用 clang 的 -rewrite-objc 选项，上述代码会转换为：
MyObject *obj = objc_msgSend(
    objc_getClass("MyObject"), sel_registerName("alloc"));
obj = objc_msgSend(
    obj, sel_registerName("init"));
objc_msgSend(obj, sel_registerName("method:"), 10);
objc_msgSend 函数根据指定的对象和函数名，从对象持有类的结构体中检索 _|_MyObject_method_ 函数的指针并调用。此时，objc_msgSend 函数的第一个参数 obj 作为 _|_MyObject_method_ 函数的第一个参数 self 进行传递。

Block 就是 OC 的对象

// Create a heap based copy of a Block or simply add a reference(引用) to an existing one.
// This must be paired(成对的) with Block_release to recover memory, even when running
// under Objective-C Garbage Collection.
BLOCK_EXPORT void *_Block_copy(const void *aBlock)
    __OSX_AVAILABLE_STARTING(__MAC_10_6, __IPHONE_3_2);

// Lose the reference, and if heap based and last reference, recover the memory
BLOCK_EXPORT void _Block_release(const void *aBlock)
    __OSX_AVAILABLE_STARTING(__MAC_10_6, __IPHONE_3_2);

// Used by the compiler. Do not call this function yourself.
BLOCK_EXPORT void _Block_object_assign(void *, const void *, const int)
    __OSX_AVAILABLE_STARTING(__MAC_10_6, __IPHONE_3_2);

// Used by the compiler. Do not call this function yourself.
BLOCK_EXPORT void _Block_object_dispose(const void *, const int)
    __OSX_AVAILABLE_STARTING(__MAC_10_6, __IPHONE_3_2);

// Used by the compiler. Do not use these variables yourself.
BLOCK_EXPORT void * _NSConcreteGlobalBlock[32]
    __OSX_AVAILABLE_STARTING(__MAC_10_6, __IPHONE_3_2);
BLOCK_EXPORT void * _NSConcreteStackBlock[32]
    __OSX_AVAILABLE_STARTING(__MAC_10_6, __IPHONE_3_2);



NSMallocBlock: With ARC, the block is properly allocated on the heap as an autoreleased NSMallocBlock to begin with.

NSGlobalBlock: Since the block doesn’t capture any variables in its closure, it doesn’t need any state set up at runtime. it gets compiled as an NSGlobalBlock. It’s neither on the stack nor the heap, but part of the code segment, like any C function. This works both with and without ARC.

clang -rewrite-objc test.m

struct __block_impl {
  void *isa;
  int Flags;// 当block被copy时，执行的操作
  int Reserved;// 保留字段
  void *FuncPtr;// 指向block内的函数实现
};

static struct __main_block_desc_0 {
  size_t reserved;// 保留字段
  size_t Block_size;// 结构体的大小 sizeof
} __main_block_desc_0_DATA = { 0, sizeof(struct __main_block_impl_0)};

// block 的实现
struct __main_block_impl_0 {
  struct __block_impl impl;
  struct __main_block_desc_0* Desc;

  __main_block_impl_0(void *fp, struct __main_block_desc_0 *desc, int flags=0) {//   结构体构造函数
    impl.isa = &_NSConcreteStackBlock;
    impl.Flags = flags;
    impl.FuncPtr = fp;
    Desc = desc;
  }
};

// block中实现(根据Block语法所属的函数名，和该Block在该函数中出现的顺序来命名)，__cself 相当于OC中的self
static void __main_block_func_0(struct __main_block_impl_0 *__cself) {
   printf("Hello, World!\n"); 
}

int main()
{
    // 第一个参数是block内的实现，第二个参数是block结构体的sizeof
    ((void (*)())&__main_block_impl_0((void *)__main_block_func_0, &__main_block_de  sc_0_DATA)) ();

    void (*blk)(void) = 
        (void (*)(void))&__main_block_impl_0(
                (void *)__main_block_func_0, &__main_block_desc_0_DATA);
    return 0;
}

// 截获变量值
// 当不使用__block传入外部变量时：
struct __main_block_impl_0 {
  struct __block_impl impl;
  struct __main_block_desc_0* Desc;
  int i;// Block 中使用的自动变量被作为成员变量追加到了 __main_block_impl_0 结构体中。
  // 一个参数是block内的实现，第二个参数是block结构体的sizeof
  __main_block_impl_0(void *fp, struct __main_block_desc_0 *desc, int _i, int flags=0) : i(_i) {
    impl.isa = &_NSConcreteStackBlock;
    impl.Flags = flags;
    impl.FuncPtr = fp;
    Desc = desc;
  }
};
static void __main_block_func_0(struct __main_block_impl_0 *__cself) {
  int i = __cself->i; // bound by copy
  printf("i = %d", i);
}

static struct __main_block_desc_0 {
  size_t reserved;
  size_t Block_size;
} __main_block_desc_0_DATA = { 0, sizeof(struct __main_block_impl_0)};

int main(){
    int i = 4;
    void (*blk)(void) = ((void (*)())&__main_block_impl_0((void *)__main_block_func_0, &__main_block_desc_0_DATA, i)); // 传入参数(i 值传递)对结构体追加的成员变量进行初始化
    i++;
    ((void (*)(__block_impl *))((__block_impl *)blk)->FuncPtr)((__block_impl *)blk);
    return 0;
}

// 当使用__block标示变量时：
__block int i = 4; 被转换为：
__Block_byref_i_0 i = {(void*)0,
    (__Block_byref_i_0 *)&i, 
    0, 
    sizeof(__Block_byref_i_0), 
    4
};

新增的struct为：
// 新增 来保存变量
struct __Block_byref_i_0 {
  void *__isa;
__Block_byref_i_0 *__forwarding;
 int __flags;
 int __size;
 int i;
};

// 截获变量值
// 当使用__block传入外部变量时：
struct __main_block_impl_0 {
  struct __block_impl impl;
  struct __main_block_desc_0* Desc;
  __Block_byref_i_0 *i;// Block 中使用的自动变量被作为成员变量追加到了 __main_block_impl_0 结构体中。
  // 一个参数是block内的实现，第二个参数是block结构体的sizeof
  __main_block_impl_0(void *fp, struct __main_block_desc_0 *desc, __Block_byref_i_0 *_i, int flags=0) : i(_i->__forwarding) {
    impl.isa = &_NSConcreteStackBlock;
    impl.Flags = flags;
    impl.FuncPtr = fp;
    Desc = desc;
  }
};

// 实现
static void __main_block_func_0(struct __main_block_impl_0 *__cself) {
  __Block_byref_i_0 *i = __cself->i; // bound by ref
  printf("i = %d", (i->__forwarding->i));
}

static void __main_block_copy_0(
        struct __main_block_impl_0 *dst, struct __main_block_impl_0 *src) {
    _Block_object_assign((void*)&dst->i, (void*)src->i, 8/*BLOCK_FIELD_IS_BYREF*/);// copy 操作
}

static void __main_block_dispose_0(struct __main_block_impl_0*src) {
    _Block_object_dispose((void*)src->i, 8/*BLOCK_FIELD_IS_BYREF*/);// release 操作
}

static struct __main_block_desc_0 {
  size_t reserved;
  size_t Block_size;
  void (*copy)(struct __main_block_impl_0*, struct __main_block_impl_0*);
  void (*dispose)(struct __main_block_impl_0*);
  // 结构体的大小，而且加上了copy 和 release 操作
} __main_block_desc_0_DATA = { 0, sizeof(struct __main_block_impl_0), __main_block_copy_0, __main_block_dispose_0};

int main(){
    __attribute__((__blocks__(byref)))
    __Block_byref_i_0 i = { // __block i = 4 变成了结构体实例(即栈上生成的__Block_byref_i_0 结构体实例)
        (void*)0,
        (__Block_byref_i_0 *)&i,
        0, 
        sizeof(__Block_byref_i_0), 
        4 // 初始化为 4
    };
    void (*blk)(void) = ((void (*)())&__main_block_impl_0((void *)__main_block_func_0, &__main_block_desc_0_DATA, (__Block_byref_i_0 *)&i, 570425344));// 传入参数(&i 传入 i 指针指向的地址)对结构体追加的成员变量进行初始化
    (i.__forwarding->i)++; // 赋值代码
    ((void (*)(__block_impl *))((__block_impl *)blk)->FuncPtr)((__block_impl *)blk);
    return 0;
}

本文主要介绍Objective-C语言的block在编译器中的实现方式。主要包括：
block的内部实现数据结构介绍
block的三种类型及其相关的内存管理方式
block如何通过capture变量来达到访问函数外的变量

block实际上就是Objective-C语言对于闭包的实现。 block配合上dispatch_queue，可以方便地实现简单的多线程编程和异步编程

实现方式
数据结构定义
block的结构体定义如下
[---
struct Block_descriptor {
    unsigned long int reserved;
    unsigned long int size;
    void (*copy)(void *dst, void *src);
    void (*dispose)(void *);
};

struct Block_layout {
    void *isa;
    int flags;
    int reserved;
    void (*invoke)(void *, ...);
    struct Block_descriptor *descriptor;
    /* Imported variables. */
};
---]
通过该图，我们可以知道，一个block实例实际上由6部分构成：
	1. isa指针，所有对象都有该指针，用于实现对象相关的功能。
    2. flags，用于按bit位表示一些block的附加信息，本文后面介绍block copy的实现代码可以看到对该变量的使用。
    3. reserved，保留变量。
    4. invoke，函数指针，指向具体的block实现的函数调用地址。
    5. descriptor， 表示该block的附加描述信息，主要是size大小，以及copy和dispose函数的指针。
    6. variables，capture过来的变量，block能够访问它外部的局部变量，就是因为将这些变量（或变量的地址）复制到了结构体中。

该数据结构和后面的clang分析出来的结构实际是一样的，不过仅是结构体的嵌套方式不一样。但这一点我一开始没有想明白，所以也给大家解释一下，如下2个结构体SampleA和SampleB在内存上是完全一样的，原因是结构体本身并不带有任何额外的附加信息。
[---
struct SampleA {
    int a;
    int b;
    int c;
};

struct SampleB {
    int a;
    struct Part1 {
        int b;
    };
    struct Part2 {
        int c;
    };
};
---]
在Objective-C语言中，一共有3种类型的block：
   1.  _NSConcreteGlobalBlock 全局的静态block，不会访问任何外部变量。保存在程序的数据区。
   2.  _NSConcreteStackBlock 保存在栈中的block，当函数返回时会被销毁。
   3.  _NSConcreteMallocBlock 保存在堆中的block(由 malloc 分配的内存块)，当引用计数为0时会被销毁。

我们在下面会分别来查看它们各自的实现方式上的差别。

研究工具：clang

为了研究编译器是如何实现block的，我们需要使用clang。clang提供一个命令，可以将Objetive-C的源码改写成c语言的，借此可以研究block具体的源码实现方式。该命令是
clang -rewrite-objc block.c
[---block.c
#include <stdio.h>

int main()
{
    ^{ printf("Hello, World!\n"); } ();
    return 0;
}
---]
在命令行中输入clang -rewrite-objc block1.c即可在目录中看到clang输出了一个名为block1.cpp的文件。该文件就是block在c语言实现.将block1.cpp中一些无关的代码去掉，将关键代码引用如下：
[---block.cpp
struct __block_impl {
    void *isa;
    int Flags;
    int Reserved;
    void *FuncPtr;
};

struct __main_block_impl_0 {
    struct __block_impl impl;
    struct __main_block_desc_0* Desc;
    __main_block_impl_0(void *fp, struct __main_block_desc_0 *desc, int flags=0) {
        impl.isa = &_NSConcreteStackBlock;
        impl.Flags = flags;
        impl.FuncPtr = fp;
        Desc = desc;
    }
};
static void __main_block_func_0(struct __main_block_impl_0 *__cself) {
    printf("Hello, World!\n");
}

static struct __main_block_desc_0 {
    size_t reserved;
    size_t Block_size;
} __main_block_desc_0_DATA = { 0, sizeof(struct __main_block_impl_0) };

int main()
{
    (void (*)())&__main_block_impl_0((void *)__main_block_func_0, &__main_block_desc_0_DATA) ();
    return 0;
}
---]
下面我们就具体看一下是如何实现的。__main_block_impl_0就是该block的实现，从中我们可以看出：
    1. 一个block实际是一个对象，它主要由一个 isa 和 一个 impl 和 一个descriptor组成。
	2. 由于clang改写的具体实现方式和LLVM不太一样，并且这里没有开启ARC。所以这里我们看到isa指向的还是_NSConcreteStackBlock。但在LLVM的实现中，开启ARC时，block应该是_NSConcreteGlobalBlock类型，具体可以看《objective-c-blocks-quiz》第二题的解释。
	3. impl是实际的函数指针，本例中，它指向__main_block_func_0。这里的impl相当于之前提到的invoke变量，只是clang编译器对变量的命名不一样而已。
	4. descriptor是用于描述当前这个block的附加信息的，包括结构体的大小，需要capture和dispose的变量列表等。结构体大小需要保存是因为，每个block因为会capture一些变量，这些变量会加到__main_block_impl_0这个结构体中，使其体积变大。在该例子中我们还看不到相关capture的代码，后面将会看到。

[---block2.c
#include <stdio.h>

int main() {
    int a = 100;
    void (^block2)(void) = ^{
        printf("%d\n", a);
    };
    block2();

    return 0;
}
---]
[---
struct __main_block_impl_0 {
    struct __block_impl impl;
    struct __main_block_desc_0* Desc;
    int a;
    __main_block_impl_0(void *fp, struct __main_block_desc_0 *desc, int _a, int flags=0) : a(_a) {
        impl.isa = &_NSConcreteStackBlock;
        impl.Flags = flags;
        impl.FuncPtr = fp;
        Desc = desc;
    }
};
static void __main_block_func_0(struct __main_block_impl_0 *__cself) {
    int a = __cself->a; // bound by copy
    printf("%d\n", a);
}

static struct __main_block_desc_0 {
    size_t reserved;
    size_t Block_size;
} __main_block_desc_0_DATA = { 0, sizeof(struct __main_block_impl_0)};

int main()
{
    int a = 100;
    void (*block2)(void) = (void (*)())&__main_block_impl_0((void *)__main_block_func_0, &__main_block_desc_0_DATA, a);
    ((void (*)(__block_impl *))((__block_impl *)block2)->FuncPtr)((__block_impl *)block2);

    return 0;
}
---]
	1. 本例中，isa指向_NSConcreteStackBlock，说明这是一个分配在栈上的实例。
	2. main_block_impl_0 中增加了一个变量a，在block中引用的变量a实际是在申明block时，被复制到main_block_impl_0结构体中的那个变量a。因为这样，我们就能理解，在block内部修改变量a的内容，不会影响外部的实际变量a。
	3. main_block_impl_0 中由于增加了一个变量a，所以结构体的大小变大了，该结构体大小被写在了main_block_desc_0中。

我们修改上面的源码，在变量前面增加__block关键字：
[---
#include <stdio.h>

int main()
{
    __block int i = 1024;
    void (^block1)(void) = ^{
        printf("%d\n", i);
        i = 1023;
    };
    block1();
    return 0;
}
---]
[---
struct __Block_byref_i_0 {
    void *__isa;
    __Block_byref_i_0 *__forwarding;
    int __flags;
    int __size;
    int i;
};

struct __main_block_impl_0 {
    struct __block_impl impl;
    struct __main_block_desc_0* Desc;
    __Block_byref_i_0 *i; // by ref
    __main_block_impl_0(void *fp, struct __main_block_desc_0 *desc, __Block_byref_i_0 *_i, int flags=0) : i(_i->__forwarding) {
        impl.isa = &_NSConcreteStackBlock;
        impl.Flags = flags;
        impl.FuncPtr = fp;
        Desc = desc;
    }
};
static void __main_block_func_0(struct __main_block_impl_0 *__cself) {
    __Block_byref_i_0 *i = __cself->i; // bound by ref

    printf("%d\n", (i->__forwarding->i));
    (i->__forwarding->i) = 1023;
}

static void __main_block_copy_0(struct __main_block_impl_0*dst, struct __main_block_impl_0*src) {_Block_object_assign((void*)&dst->i, (void*)src->i, 8/*BLOCK_FIELD_IS_BYREF*/);}

static void __main_block_dispose_0(struct __main_block_impl_0*src) {_Block_object_dispose((void*)src->i, 8/*BLOCK_FIELD_IS_BYREF*/);}

static struct __main_block_desc_0 {
    size_t reserved;
    size_t Block_size;
    void (*copy)(struct __main_block_impl_0*, struct __main_block_impl_0*);
    void (*dispose)(struct __main_block_impl_0*);
} __main_block_desc_0_DATA = { 0, sizeof(struct __main_block_impl_0), __main_block_copy_0, __main_block_dispose_0};

int main()
{
    __attribute__((__blocks__(byref))) __Block_byref_i_0 i = {(void*)0,(__Block_byref_i_0 *)&i, 0, sizeof(__Block_byref_i_0), 1024};
    void (*block1)(void) = (void (*)())&__main_block_impl_0((void *)__main_block_func_0, &__main_block_desc_0_DATA, (__Block_byref_i_0 *)&i, 570425344);
    ((void (*)(__block_impl *))((__block_impl *)block1)->FuncPtr)((__block_impl *)block1);
    return 0;
}
---]
	1. 源码中增加一个名为__Block_byref_i_0 的结构体，用来保存我们要capture并且修改的变量i。
	2. main_block_impl_0 中引用的是Block_byref_i_0的结构体指针，这样就可以达到修改外部变量的作用。
	3. __Block_byref_i_0结构体中带有isa，说明它也是一个对象。
	4. 我们需要负责Block_byref_i_0结构体相关的内存管理，所以main_block_desc_0中增加了copy和dispose函数指针，对于在调用前后修改相应变量的引用计数。
--
NSConcreteMallocBlock 类型的block的实现

NSConcreteMallocBlock类型的block通常不会在源码中直接出现，因为默认它是当一个block被copy的时候，才会将这个block复制到堆中。以下是一个block被copy时的示例代码，可以看到，在第8步，目标的block类型被修改为_NSConcreteMallocBlock。
[---
static void *_Block_copy_internal(const void *arg, const int flags) {
    struct Block_layout *aBlock;
    const bool wantsOne = (WANTS_ONE & flags) == WANTS_ONE;

    // 1
    if (!arg) return NULL;

    // 2
    aBlock = (struct Block_layout *)arg;

    // 3
    if (aBlock->flags & BLOCK_NEEDS_FREE) {
        // latches on high
        latching_incr_int(&aBlock->flags);
        return aBlock;
    }

    // 4
    else if (aBlock->flags & BLOCK_IS_GLOBAL) {
        return aBlock;
    }

    // 5
    struct Block_layout *result = malloc(aBlock->descriptor->size);
    if (!result) return (void *)0;

    // 6
    memmove(result, aBlock, aBlock->descriptor->size); // bitcopy first

    // 7
    result->flags &= ~(BLOCK_REFCOUNT_MASK);    // XXX not needed
    result->flags |= BLOCK_NEEDS_FREE | 1;

    // 8
    result->isa = _NSConcreteMallocBlock;

    // 9
    if (result->flags & BLOCK_HAS_COPY_DISPOSE) {
        (*aBlock->descriptor->copy)(result, aBlock); // do fixup
    }

    return result;
}
---]
变量的复制
对于block外的变量引用，block默认是将其复制到其数据结构中来实现访问的.

对于用__block修饰的外部变量引用，block是复制其引用地址来实现访问的.

---
LLVM源码

在LLVM开源的关于block的实现源码，其内容也和我们用clang改写得到的内容相似，印证了我们对于block内部数据结构的推测。

ARC对block类型的影响

在ARC开启的情况下，将只会有 NSConcreteGlobalBlock和 NSConcreteMallocBlock类型的block。

在ARC情况下，生成的block也是NSConcreteStackBlock。不过对strong对象赋值时，会对其进行copy。在例子中block1是strong类型对象，因为经过了赋值的过程，已经copy过了，所以打印出来的是__NSMallocBlock__。若是直接对其打印，略过赋值过程，会是NSConcreteStackBlock。不过ARC情况下不需要我们手动copy了，系统会帮我们copy

[---
#import <Foundation/Foundation.h>

int main(int argc, const char * argv[])
{
    @autoreleasepool {
        int i = 1024;
        void (^block1)(void) = ^{
            printf("%d\n", i);
        };
        block1();
        NSLog(@"%@", block1);
    }
    return 0;
}
---]
我个人认为这么做的原因是，由于ARC已经能很好地处理对象的生命周期的管理，这样所有对象都放到堆上管理，对于编译器实现来说，会比较方便。

==============================
stryct __main_block_impl_0 {
    struct __block_impl impl;
    struct __main_block_desc_0* Desc;
    id __strong array;
}
static struct __main_block_desc_0 {
    size_t reserved;
    size_t Block_size;
    void (*copy)(struct __main_block_impl_0*, struct __main_block_impl_0*);
    void (*dispose)(struct __main_block_impl_0*);
} __main_block_desc_0_DATA = { 
    0, 
    sizeof(struct __main_block_impl_0),
    __main_block_copy_0, 
    __main_block_dispose_0}
;

static void __main_block_copy_0(struct __main_block_impl_0*dst, struct __main_block_impl_0*src) {
    // retain
    _Block_object_assign((void*)&dst->i, (void*)src->i, 8/*BLOCK_FIELD_IS_BYREF*/);
}

static void __main_block_dispose_0(struct __main_block_impl_0*src) {
    // release
    _Block_object_dispose((void*)src->i, 8/*BLOCK_FIELD_IS_BYREF*/);
}

在OC中，C语言结构体不能含有附有__strong 修饰符的变量，因为编译器不知道应何时进行C语言结构体的初始化和废弃操作，不能很好的管理内存。
但是，OC的运行时库能够准确的把握block 从栈复制到堆上以及堆上block 被废弃的时机，因此block结构体(__main_block_impl_0)中即使含有附有__strong和__weak修饰符的变量，也可以恰当地进行初始化和废弃操作。
为此需要在__main_block_impl_0 中增加的成员变量copy 和 dispose，以及作为指针赋值给该成员变量的__main_block_copy_0函数和__main_block_dispose_0函数。

什么时候栈上的block会复制到堆上呢？
1. copy
2. block 作为函数返回值返回时
3. 将block 赋值给__strong id 类型的类或block类型的成员变量时
4. 在方法名中含有usingBlock的Cocoa框架方法或GCD的API中传递block时。

有了这种构造，通过使用附有__strong修饰符的自动变量，block中截获的对象就能够超出作用域而存在。

block 中使用对象类型自动变量时(不加 static 或者 __block 前缀)，除了一下情形外，推荐调用block的copy实例方法。
1. block 作为函数返回值返回时
2. 将block 赋值给__strong id 类型的类或block类型的成员变量时
3. 在方法名中含有usingBlock的Cocoa框架方法或GCD的API中传递block时。

栈上的block复制到堆上时，会在block 结构体中自动生成__strong类型的变量来对外部变量强引用

Block 调用self 的属性时，实际上是截获了self，因为对象编译后其实是struct，而调用结构体内成员变量时，必须首先调用结构体，self->obj。因为self 持有 Block，于是乎循环引用。



================================
什么是GCD

Grand Central Dispatch (GCD)是Apple开发的一个多核编程的解决方法。该方法在Mac OS X 10.6雪豹中首次推出，并随后被引入到了iOS4.0中。GCD是一个替代诸如NSThread, NSOperationQueue, NSInvocationOperation等技术的很高效和强大的技术。

GCD和block的配合使用，可以方便地进行多线程编程。

应用举例

让我们来看一个编程场景。我们要在iPhone上做一个下载网页的功能，该功能非常简单，就是在iPhone上放置一个按钮，点击该按钮时，显示一个转动的圆圈，表示正在进行下载，下载完成之后，将内容加载到界面上的一个文本控件中。

不用GCD前

虽然功能简单，但是我们必须把下载过程放到后台线程中，否则会阻塞UI线程显示。所以，如果不用GCD, 我们需要写如下3个方法：

	1. someClick 方法是点击按钮后的代码，可以看到我们用NSInvocationOperation建了一个后台线程，并且放到NSOperationQueue中。后台线程执行download方法。
	2. download 方法处理下载网页的逻辑。下载完成后用performSelectorOnMainThread执行download_completed 方法。
	3. download_completed 进行clear up的工作，并把下载的内容显示到文本控件中。

这3个方法的代码如下。可以看到，虽然 开始下载 –> 下载中 –> 下载完成 这3个步骤是整个功能的三步。但是它们却被切分成了3块。他们之间因为是3个方法，所以还需要传递数据参数。如果是复杂的应用，数据参数很可能就不象本例子中的NSString那么简单了，另外，下载可能放到Model的类中来做，而界面的控制放到View Controller层来做，这使得本来就分开的代码变得更加散落。代码的可读性大大降低。
[---
static NSOperationQueue * queue;

- (IBAction)someClick:(id)sender {
    self.indicator.hidden = NO;
    [self.indicator startAnimating];
    queue = [[NSOperationQueue alloc] init];
    NSInvocationOperation * op = [[[NSInvocationOperation alloc] initWithTarget:self selector:@selector(download) object:nil] autorelease];
    [queue addOperation:op];
}

- (void)download {
    NSURL * url = [NSURL URLWithString:@"http://www.youdao.com"];
    NSError * error;
    NSString * data = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&error];
    if (data != nil) {
        [self performSelectorOnMainThread:@selector(download_completed:) withObject:data waitUntilDone:NO];
    } else {
        NSLog(@"error when download:%@", error);
        [queue release];
    }
}

- (void) download_completed:(NSString *) data {
    NSLog(@"call back");
    [self.indicator stopAnimating];
    self.indicator.hidden = YES;
    self.content.text = data;
    [queue release];
}
---]
使用GCD后

如果使用GCD，以上3个方法都可以放到一起，如下所示：
[---
// 原代码块一
self.indicator.hidden = NO;
[self.indicator startAnimating];
dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    // 原代码块二
    NSURL * url = [NSURL URLWithString:@"http://www.youdao.com"];
    NSError * error;
    NSString * data = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&error];
    if (data != nil) {
        // 原代码块三
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.indicator stopAnimating];
            self.indicator.hidden = YES;
            self.content.text = data;
        });
    } else {
        NSLog(@"error when download:%@", error);
    }
});
---]
首先我们可以看到，代码变短了。因为少了原来3个方法的定义，也少了相互之间需要传递的变量的封装。

另外，代码变清楚了，虽然是异步的代码，但是它们被GCD合理的整合在一起，逻辑非常清晰。如果应用上MVC模式，我们也可以将View Controller层的回调函数用GCD的方式传递给Modal层，这相比以前用@selector的方式，代码的逻辑关系会更加清楚。

block的定义

block的定义有点象函数指针，差别是用 ^ 替代了函数指针的 * 号，如下所示：
[---
 // 申明变量
 (void) (^loggerBlock)(void);
 // 定义
 loggerBlock = ^{
      NSLog(@"Hello world");
 };
 // 调用
 loggerBlock();
---]
但是大多数时候，我们通常使用内联的方式来定义block，即将它的程序块写在调用的函数里面，例如这样：
[---
 dispatch_async(dispatch_get_global_queue(0, 0), ^{
      // something
 });
---]
从上面大家可以看出，block有如下特点：
	1. 程序块可以在代码中以内联的方式来定义。
    2. 程序块可以访问在创建它的范围内的可用的变量。
----------
系统提供的dispatch方法

为了方便地使用GCD，苹果提供了一些方法方便我们将block放在主线程 或 后台线程执行，或者延后执行。使用的例子如下：
[---
 //  后台执行：
 dispatch_async(dispatch_get_global_queue(0, 0), ^{
      // something
 });
 // 主线程执行：
 dispatch_async(dispatch_get_main_queue(), ^{
      // something
 });
 // 一次性执行：(单例)
 static dispatch_once_t onceToken;
 dispatch_once(&onceToken, ^{
     // code to be executed once
 });
 // 延迟2秒执行：
 double delayInSeconds = 2.0;
 dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
 dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
     // code to be executed on the main queue after delay
 });
---]
dispatch_queue_t 也可以自己定义，如要要自定义queue，可以用dispatch_queue_create方法，示例如下：
[---
dispatch_queue_t urls_queue = dispatch_queue_create("blog.devtang.com", NULL);
dispatch_async(urls_queue, ^{
     // your code
});
dispatch_release(urls_queue);
---]
另外，GCD还有一些高级用法，例如让后台2个线程并行执行，然后等2个线程都结束后，再汇总执行结果。这个可以用dispatch_group, dispatch_group_async 和 dispatch_group_notify来实现，示例如下：
[---
 dispatch_group_t group = dispatch_group_create();
 dispatch_group_async(group, dispatch_get_global_queue(0,0), ^{
      // 并行执行的线程一
 });
 dispatch_group_async(group, dispatch_get_global_queue(0,0), ^{
      // 并行执行的线程二
 });
 dispatch_group_notify(group, dispatch_get_global_queue(0,0), ^{
      // 汇总结果
 });
---]
后台运行

使用block的另一个用处是可以让程序在后台较长久的运行。在以前，当app被按home键退出后，app仅有最多5秒钟的时候做一些保存或清理资源的工作。但是应用可以调用UIApplication的beginBackgroundTaskWithExpirationHandler方法，让app最多有10分钟的时间在后台长久运行。这个时间可以用来做清理本地缓存，发送统计数据等工作。

让程序在后台长久运行的示例代码如下：
[---
// AppDelegate.h文件
@property (assign, nonatomic) UIBackgroundTaskIdentifier backgroundUpdateTask;

// AppDelegate.m文件
- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [self beingBackgroundUpdateTask];
    // 在这里加上你需要长久运行的代码
    [self endBackgroundUpdateTask];
}

- (void)beingBackgroundUpdateTask
{
    self.backgroundUpdateTask = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        [self endBackgroundUpdateTask];
    }];
}

- (void)endBackgroundUpdateTask
{
    [[UIApplication sharedApplication] endBackgroundTask: self.backgroundUpdateTask];
    self.backgroundUpdateTask = UIBackgroundTaskInvalid;
}
---]

======================================
cocoaTouch框架下动画效果的Block的调用

动画效果是IOS界面重要的特色之一，其中CAAnimation是所有动画对象的抽象父类，作为新人，使用较多的是UIView下的动画方法（类方法）。使用UIView下的动画，有下面几个方法。

方法一：设置beginAnimations

其中memberView为需要添加的子视图的视图，mivc.view为子视图，在使用的时候，需要将这两个地方替换
[---
[UIView beginAnimations:@"view flip" context:nil];  
[UIView setAnimationDuration:1];  
[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:memberView cache:YES];  
[memberView addSubview:mivc.view];  
[UIView commitAnimations];
---]



有两种Dispatch Queue，一种是等待现在执行中处理结束的Serial Dispatch Queue （串行，使用一个线程），另一种是不等待现在执行中处理结束的Concurrent Dispatch Queue（并发，使用多个线程）。

dispatch_queue_t mySerialDispatchQueue = dispatch_queue_create("com.alamofire.networking.session.manager.creation", DISPATCH_QUEUE_SERIAL);
当生成多个Serial Dispatch Queue时，各个Serial Dispatch Queue 将并行执行。虽然在一个Serial Dispatch Queue 中只能执行一个追加处理，但如果将处理分别追加到四个Serial Dispatch Queue 中，各个Serial Dispatch Queue 执行1个，即同事执行 4 个处理。系统对一个 Serial Dispatch Queue 就只生成并使用一个线程。

注意：Serial Dispatch Queue 的生成个数应当仅限所必需的数量，例如，更新数据库时，一个表生成一个Serial Dispatch Queue，更新文件时，一个文件或是可以分割的一个文件块生成一个Serial Dispatch Queue。
当处理并行执行而不会发生数据竞争的操作时，使用Concurrent Dispatch Queue。
dispatch_queue_t myConcurrentDispatchQueue = dispatch_queue_create("com.alamofire.networking.session.manager.creation", DISPATCH_QUEUE_CONCURRENT);

变更生成的dispatch queue 的优先级。
dispatch_set_target_queue( mySerialDispatchQueue , dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0));
dispatch_queue_t queue = dispatch_queue_create(name.UTF8String, DISPATCH_QUEUE_SERIAL);
dispatch_set_target_queue(queue, targetQueue);

注意：在必须将不可并行执行的处理追加到多个Serial Dispatch Queue 中时，如果使用dispatch_set_target_queue 函数将目标指定为某一个Serial Dispatch Queue，即可防止处理并行执行。因为可以将指定的queue 调整为优先级更高。

#define NSEC_PER_SEC 1000000000ull   秒
#define NSEC_PER_MSEC   1000000ull   毫秒
#define USEC_PER_SEC    1000000ull
#define NSEC_PER_USEC      1000ull
ull 表示 unsigned long long
dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW/*从现在开始*/, 3ull * NSEC_PER_SEC);
dispatch_after(time, dispatch_get_main_queue(), ^{
    NSLog(@"dispatch_after 并不是在指定时间后执行处理，而是只是在指定时间后追加到dispatch queue中。等待时间time时间后，用dispatch_async 函数将block 追加到指定线程中");
});

dispatch_time 通常用于计算相对时间，dispatch_walltime 用于计算绝对时间。
当计算机睡眠时，定时器dispatch source会被挂起，稍后系统唤醒时，定时器dispatch source也会自动唤醒。根据你提供的配置，暂停定时器可能会影响定时器下一次的触发。如果定时器dispatch source使用 dispatch_time 函数或 DISPATCH_TIME_NOW 常量设置，定时器dispatch source会使用系统默认时钟来确定何时触发，但是默认时钟在计算机睡眠时不会继续。

如果你使用 dispatch_walltime 函数来设置定时器dispatch source，则定时器会根据挂钟时间来跟踪，这种定时器比较适合触发间隔相对比较大的场合，可以防止定时器触发间隔出现太大的误差。

dispatch_time_t类型的时间我们可以通过dispatch_time来创建，也可以通过dispatch_walltime来创建。前者创 建的时间多以第一个参数为参照物，之后过多久执行任务。后者多用于创建绝对时间，如某年某月某日某时某分执行某任务，比如闹钟的设置。

dispatch_time stops running when your computer goes to sleep. dispatch_walltime continues running. So if you want to do an action in one hour minutes, but after 5 minutes your computer goes to sleep for 50 minutes, dispatch_walltime will execute an hour from now, 5 minutes after the computer wakes up. dispatch_time will execute after the computer is running for an hour, that is 55 minutes after it wakes up. 

dispatch_group_t group = strongSelf.completionGroup ?: url_request_operation_completion_group();
dispatch_queue_t queue = strongSelf.completionQueue ?: dispatch_get_main_queue();

dispatch_group_async(group, queue, ^{
    block();
});

dispatch_group_async(group, queue, ^{
    block();
});
// 设置group中queue 都执行完后的扫尾操作
dispatch_group_notify(group/*要监听的group*/, url_request_operation_completion_queue(), ^{
    [strongSelf setCompletionBlock:nil];
});
long result = dispatch_group_wait(group, time/*指定超时时间，DISPATCH_TIME_FOREVER 意味着永久等待，指定DISPATCH_TIME_NOW，则不用任何等待即可判定属于该group的处理是否已经结束*/);
if (result == 0) {
    // 数据该group的处理已全部结束
} else {
    // 处理还在进行中
}

dispatch_barrier_async 函数会等待追加到 concurrent dispatch queue  中的并行执行的处理全部执行结束之后，再讲指定的处理追加到concurrent dispatch queue 中，然后等待追加的操作执行完后才会恢复为一般的 Concurrent Dispatch Queue，后面的处理又可以并行执行了。
 
使用 Concurrent Dispatch Queue 和 dispatch_barrier_async 可实现高效率的数据库访问和文件访问。

死锁举例：
在主线程中执行如下代码就会发生死锁。
dispatch_sync(dispatch_get_main_queue(), ^{
    NSLog(@"等待block执行结束才能继续执行主线程中的其他任务（暂停当前线程的执行），而这时主线程正在执行该block语句；所以就死锁了");
});

// 将block 加入queue 中指定次数。dispatch_apply 会等待全部处理结束。串行执行
dispatch_apply(10, queue, ^(size_t index) {
    NSLog(@"10次执行结束");
});

dispatch_suspend(queue);// 挂起指定的queue
dispatch_resume(queue);// 挂起指定的queue

Dispatch Semaphore 实现更细粒度的排他控制。Dispatch Semaphore 使用计数来实现该功能，计数为0时等待，计数为1或大于1时，减去1而不是等待。
dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
dispatch_semaphore_signal(semaphore);// 计数值加一
dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);// 等待Dispatch Semaphore 的计数值达到大于或等于1 。当计数值>=1 或者待机中计数值>=1 时，对该计数进行减一，并返回。

dispatch_semaphore_t semaphore = dispatch_semaphore_create(1);
NSMutableArray *array = [NSMutableArray array];
int i = 1000;
while (i--) {
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);// 永远等待(返回恒为0)，计数值>=1后，减一，然后下一步
    [array addObject:@(i)];
    dispatch_semaphore_signal(semaphore);// 计数值加一
}

if (result == 0) {
    // 由于计数值>=1 ，所以减一，返回0
} else {
    // 由于计数值为0，而且等待时间已到
}

就算初始值是100，两个函数dispatch_semaphore_wait与dispatch_semaphore_signal还是会减“1”、加“1”)。保证可访问 NSMutableArray 类对象的线程同时只能有1个。

通过 dispatch_once函数，即使在多线程环境下也可保证百分百安全。

Dispatch Source 是 BSD 系统内核工程 kqueue 的包装。

https://github.com/ming1016/study/wiki/%E7%BB%86%E8%AF%B4GCD%EF%BC%88Grand-Central-Dispatch%EF%BC%89%E5%A6%82%E4%BD%95%E7%94%A8
细说GCD（Grand Central Dispatch）如何用
