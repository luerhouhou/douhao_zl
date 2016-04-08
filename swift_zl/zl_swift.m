MTypeNone =     00000000000000      0
IMFromCsr =     00000000000001      1
IMFromCustomer =00000000000010      2
IMBroadcast =   00000000000100      4
IMCall =        00000000001000      8
IMVoice         00000000010000      16
IMText =        00000000100000      32
IMTime =        00000001000000      64
IMFake =        00000010000000      128
IMNotification =00000100000000      256
IMGift =        00001000000000      512
IMJoin =        00010000000000      1024
IMLeft =        00100000000000      2048
IMImage =       01000000000000      4096
IMVOIP =        10000000000000

                00000000100001

Welcome to Swift
Swift 是一种高效的系统编程语言，他有清晰和支持现代语法，提供与C以及OC框架的无缝连接，他是内存安全的。
Swift虽然是受到OC及其他很多语言的启发，但其并不是C系统的语言。作为一个完全完全独立的语言，Swift拥有核心的特征，流控制，数据结构，方法，和objects, protocols, closures, and generics 对象，协议，封装，泛型。Swift包含的模块，不需要引用头文件。

// 注释
Swift 的多行注释可以嵌套在其它的多行注释之中。你可以先生成一个多行注释块，然后在这个注释块之中再嵌套成第二个多行注释。终止注释时先插入第二个注释块的终止标记，然后再插入第一个注释块的终止标记：

/* 这是第一个多行注释的开头
/* 这是第二个被嵌套的多行注释 */
这是第一个多行注释的结尾 */

通过运用嵌套多行注释，你可以快速方便的注释掉一大段代码，即使这段代码之中已经含有了多行注释块。

Swift 提供了8，16，32和64位的有符号和无符号整数类型。UInt8,UInt16

let minValue = UInt8.min  // minValue 为 0，是 UInt8 类型
let maxValue = UInt8.max  // maxValue 为 255，是 UInt8 类型


在32位平台上，Int和Int32长度相同。
在64位平台上，Int和Int64长度相同。

在32位平台上，UInt和UInt32长度相同。
在64位平台上，UInt和UInt64长度相同。


Double表示64位浮点数。当你需要存储很大或者很高精度的浮点数时请使用此类型。
Float表示32位浮点数。精度要求不高的话可以使用此类型。

let meaningOfLife = 42
// meaningOfLife 会被推测为 Int 类型

let pi = 3.14159
// pi 会被推测为 Double 类型

当推断浮点数的类型时，Swift 总是会选择Double而不是Float。

如果表达式中同时出现了整数和浮点数，会被推断为Double类型：

let anotherPi = 3 + 0.14159
// anotherPi 会被推测为 Double 类型

let decimalInteger = 17
let binaryInteger = 0b10001       // 二进制的17
let octalInteger = 0o21           // 八进制的17
let hexadecimalInteger = 0x11     // 十六进制的17

如果一个十进制数的指数为exp，那这个数相当于基数和10^exp的乘积：

1.25e2 表示 1.25 × 10^2，等于 125.0。
1.25e-2 表示 1.25 × 10^-2，等于 0.0125。

如果一个十六进制数的指数为exp，那这个数相当于基数和2^exp的乘积：

0xFp2 表示 15 × 2^2，等于 60.0。
0xFp-2 表示 15 × 2^-2，等于 3.75。

数值类字面量可以包括额外的格式来增强可读性。整数和浮点数都可以添加额外的零并且包含下划线，并不会影响字面量：

let paddedDouble = 000123.456
let oneMillion = 1_000_000
let justOverOneMillion = 1_000_000.000_000_1

typealias AudioSample = UInt16

定义了一个类型别名之后，你可以在任何使用原始名的地方使用别名：

var maxAmplitudeFound = AudioSample.min
// maxAmplitudeFound 现在是 0

如果你只需要一部分元组值，分解的时候可以把要忽略的部分用下划线（_）标记：

let (justTheStatusCode, _) = http404Error
print("The status code is \(justTheStatusCode)")
// 输出 "The status code is 404"

此外，你还可以通过下标来访问元组中的单个元素，下标从零开始：

print("The status code is \(http404Error.0)")
// 输出 "The status code is 404"
print("The status message is \(http404Error.1)")
// 输出 "The status message is Not Found"

if let firstNumber = Int("4"), secondNumber = Int("42") where firstNumber < secondNumber {
    print("\(firstNumber) < \(secondNumber)")
}
// prints "4 < 42"

在 Swift 中你可以对浮点数进行取余运算（%），Swift 还提供了 C 语言没有的表达两数之间的值的区间运算符（a..<b和a...b），这方便我们表达一个区间内的数值。

8 % 2.5   // 等于 0.5

"hello, " + "world"  // 等于 "hello, world"

let three = 3
let minusThree = -three       // minusThree 等于 -3

一元正号（+）不做任何改变地返回操作数的值：
let minusSix = -6
let alsoMinusSix = +minusSix  // alsoMinusSix 等于 -6

空合运算符(a ?? b)将对可选类型a进行空判断，如果a包含一个值就进行解封，否则就返回一个默认值b.这个运算符有两个条件:

表达式a必须是Optional类型
默认值b的类型必须要和a存储值的类型保持一致

注意： 如果a为非空值(non-nil),那么值b将不会被估值。这也就是所谓的短路求值。

for index in 1...5 {// 闭区间运算符
    print("\(index) * 5 = \(index * 5)")
}
// 1 * 5 = 5
// 2 * 5 = 10
// 3 * 5 = 15
// 4 * 5 = 20
// 5 * 5 = 25

let names = ["Anna", "Alex", "Brian", "Jack"]
let count = names.count
for i in 0..<count {// 半开区间
    print("第 \(i + 1) 个人叫 \(names[i])")
}
// 第 1 个人叫 Anna
// 第 2 个人叫 Alex
// 第 3 个人叫 Brian
// 第 4 个人叫 Jack

您可以通过检查其Bool类型的isEmpty属性来判断该字符串是否为空：
if emptyString.isEmpty {
    print("Nothing to see here")
}
// 打印输出："Nothing to see here"

let multiplier = 3
let message = "\(multiplier) times 2.5 is \(Double(multiplier) * 2.5)"
// message is "3 times 2.5 is 7.5"

let wiseWords = "\"Imagination is more important than knowledge\" - Einstein"
// "Imageination is more important than knowledge" - Enistein
let dollarSign = "\u{24}"             // $, Unicode 标量 U+0024
let blackHeart = "\u{2665}"           // ♥, Unicode 标量 U+2665
let sparklingHeart = "\u{1F496}"      // 💖, Unicode 标量 U+1F496

注意:通过characters属性返回的字符数量并不总是与包含相同字符的NSString的length属性相同。NSString的length属性是利用 UTF-16 表示的十六位代码单元数字，而不是 Unicode 可扩展的字符群集。作为佐证，当一个NSString的length属性被一个Swift的String值访问时，实际上是调用了utf16Count。


[assert]
assert(celsius > absoluteZeroInCelsius, "输入的摄氏温度不能低于绝对零度")
当遇到错误时，会产生错误，保留堆栈，并抛出预设的信息。默认情况下，只在Debug编译时有效，运行时不被编译执行。
改变默认运行可以添加编译标记，但不建议改动
target-Build Setting中 Swift Compiler - Custom Flags 中的Other Swift Flags中添加-assert-config Debug来强制启用断言，或者-assert-config Release来强制禁用断言.
注意：如果我们需要在Release发布时在无法继续时将程序强行终止的话，应该考虑使用致命错误fatalError的方式来终止程序。

[ErrorType do catch]
enum LoginError: ErrorType {
    case UserNotFound, UserPasswordNotMatch
}

func login(user: String, password: String) throws {
    let users = [String: String]()

    if !users.keys.contains(user) {
        throw LoginError.UserNotFound
    }
    
    if users[user] != password {
        throw LoginError.UserPasswordNotMatch
    }
    
    print("Login successfully.")
}

do {
    try login("onevcat", password: "123")
} catch LoginError.UserNotFound {
    print("UserNotFound")
} catch LoginError.UserPasswordNotMatch {
    print("UserPasswordNotMatch")
}
注意：异常只是一个同步方法专用的处理机制，Cocoa框架里对于异步API出错时，保留了原来的NSError机制。
Swift2.0时代的错误处理，一般的最佳实践是，对于同步API使用异常机制，对于异步API使用泛型枚举。
try! 表示确定不会抛出异常，如果调用中出现异常会导致程序崩溃。
try? 没有异常则返回Optional值，有异常则返回nil；这意味着无视了错误的具体类型和含义。
当throws另一个throws时，应该将前面的throws改为rethrows。


[自定义 description]
当需要对对象的输出进行格式化时，我们可以通过实现CustomStringConvertible接口来进行一次性设置。
extension User : CustomStringConvertible {
    var description: String {
        return "\(self.age)and\(self.weight)and\(self.height)"
    }
}
实现CustomDebugStringConvertible接口作用是在debugger时，规整po等命令的输出
public protocol CustomDebugStringConvertible {
    /// A textual representation of `self`, suitable for debugging.
    public var debugDescription: String { get }
}


[swift2 中变了----？？？？？？？]
// [arc4random and arc4random_uniform]
//swift中使用arc4random时每次都会返回一个UInt32的值，因为iPhone5及以下设备是32位的，所以一半的几率会造成溢出崩溃。
//安全的做法：arc4random_uniform



[swiftc]swift非常有意思的命令行工具
可以使用swift实现一些命令行程序
swift --help        swiftc --help
// --hellp.swift
#!/usr/bin/env swift
print("hello")
// --
chmod 755 hello.swift
./hello.swift   // 直接在终端运行

swiftc -O hello.swift -o hello.asm  // 生成asm汇编代码



[Unmanaged]
public func performSelector(aSelector: Selector) -> Unmanaged<AnyObject>!
public func retain() -> Unmanaged<Instance>
public func release()
public func autorelease() -> Unmanaged<Instance>
在OC中ARC负责的只是NSObject的自动引用计数。因此对于CF（Core Foundation）对象无法进行内存管理。当我们在把对象在NS和CF之间进行转换时，需要向编译器说明是否需要转移内存的管理权。对于不涉及内存管理转换时，OC中直接在变量前加上__bridge来进行说明，表示内存管理权不变。对于CF系的API，如果API名字中含有Create, Copy, Retain的话，在使用完成后，需要调用CFRelease进行释放。
对于系统的CF API来说，swift已经将大多数纳入RAC的管理范围，所以我们平时是不需要进行额外处理的。
对于需要进行计数管理的对象是，swift会返回Unmanaged对象，然后我们需要使用takeUnretainedValue或者takeRetainedValue从中取出CF对象并转换成需要的类型。
takeUnretainedValue将保持原来的引用计数不变，当不需要自己去释放原来的内存时使用。
takeRetainedValue这个会让引用计数加一，使用完后需要对原来的Unmanaged对象进行手动释放。Unmanaged为我们提供了retain/release/autorelease来管理引用计数。

[Assiciated Objec]
// -- switf 中实现extension中添加属性
class MyClass {
}

// MyClassExtension.swift
private var key0: Void?
private var key1: Void?

//public func objc_getAssociatedObject(object: AnyObject!, _ key: UnsafePointer<Void>) -> AnyObject!
//public func objc_setAssociatedObject(object: AnyObject!, _ key: UnsafePointer<Void>, _ value: AnyObject!, _ policy: objc_AssociationPolicy)

// extension中不能添加存储属性(willSet/didSet)，只能添加计算属性（实现 get 或者 get/set），除非用运行时

extension MyClass {
    var title: String? {
        get {
            return objc_getAssociatedObject(self, &key0) as? String
        }
        set {
            objc_setAssociatedObject(self,
                &key0, newValue,
                .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    var subTitle: String? {
        get {
            return objc_getAssociatedObject(self, &key1) as? String
        }
        set {
            objc_setAssociatedObject(self,
                &key1, newValue,
                .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}

let a = MyClass()
a.title = "Swifter.tips"
a.subTitle = "tips"
a.title     // Swifter.tips
a.subTitle      // tips
// -- oc
static char CharViewPageIndexKey;
- (void)setPageIndex:(NSInteger)pageIndex
{
    objc_setAssociatedObject(self, 
                             &CharViewPageIndexKey, @(pageIndex), 
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSInteger)pageIndex
{
    return [objc_getAssociatedObject(self, &CharViewPageIndexKey) integerValue];
}
// --

[delegate]
Swift中的protocol可以多种类型支持，如 class, struct, enum；而在struct和enum中作为接口实现，而在class中时，除了作为接口来使用外，还可以作为委托-代理的常用模式。
用于委托-代理时，protocol必须主动声明为@objo或着class类型，如下：
@objc protocol MyClassDelegate { }
protocol MyClassDelegate: class {}  // 这种更好，去除了oc兼容标志
这样就指定了MyClassDelegate只能由class实现

[sizeof / sizeofVale]
在swift中通过计算数组长度来进行NSData转换时，需要这样计算数组长度：sizeof(CChar) * bytes.count；直接使用sizeof和sizeofValue以及strideof和strideofValue都还有坑，------？？？？？？？？？？
var bytes: [CChar] = [1,2,3]
let data = NSData(bytes: &bytes, length:sizeof(CChar) * bytes.count)
sizeofValue(bytes)      // 8
sizeof(bytes.dynamicType)       // 8
sizeof(CChar) * bytes.count     // 3 
sizeof(Int)     // 8
sizeof(UInt16)     // 2
strideofValue(bytes)        // 8
?? 返回的8为64位系统上的一个引用的长度。
enum MyEnum : UInt16 {
    case A = 0
    case B = 1
    case C = 64435
}
sizeof(MyEnum)      // 1
sizeofValue(MyEnum.A)       // 1
sizeofValue(MyEnum.A.rawValue)      // 2
strideof(MyEnum)        // 1
strideofValue(MyEnum.A)     // 1
strideofValue(MyEnum.A.rawValue)    // 2


[@asmname]
当在Swift中调用C函数时，一种方式是借助bridge文件来引入头文件。
另一种方式就是@asmname；这种方式也可以用来当第三方C方法与系统库重名时，
//-- File.swift
// 将C 的 test方法映射为Swift中的c_test方法
@asmname("test") func c_test(a: Int32) -> Int32
func testSwift(inputL Int32) {
    let result = c_test(input)
    print(result)
}
testSwift(1)    // 2
// --

[格式化输出]
当遇到需要输出类似%.2f这种格式时，swift中需要先转换
let aa = 1.23456
print(String(format: "%.2f", aa))

extension Double {
    func format(f:String) -> String {
        return String(format: "%\(f)f", self)
    }
}
print(aa.format(".2"))

[条件编译]
#if <condition>
#elseif <condition>
#else
#endif
swift定义了几个condition：大小写敏感
os()        OSX,iOS
arch()      x86_64,arm,arm64,i386
自定义符号
需要将自定义的符号加载Build Setting 中。

[类方法与实例方法]
class MyClass1 {
    func method(number: Int) -> Int {
        return number + 1
    }
    
    class func method(number: Int) -> Int {
        return number
    }
}
let f1 = MyClass1.method    // 会直接调用类方法
f1(4)
// class func method 的版本
let f2: Int -> Int = MyClass1.method
// 和 f1 相同

let f3: MyClass1 -> Int -> Int = MyClass1.method 
注意：当同一个类中，存在实例方法和类方法重名时，像f1一样，默认取到的是类方法，可以在变量前加上类申明来取实例方法。

[Selector]如果用swift写的类是继承自NSObject的，swift会自动为所有非private类前面加上@objc前缀。而如果需要在oc中调用private方法，则需要在其前面加上@objc。
通过Selector生成方法时，需要在方法前加上@objc前缀；当需要生成的方法第一个参数有外部变量时，按照惯例要在方法名和第一个外部变量之间加上with:
func aMethod()
// --
class AAA: NSObject {
    var first:Int = 0
    func aMethod() -> String {
        return String(first)
    }
    func bMethod(str:String) -> String {
        print("\(first)")
        return String(first) + str
    }
    func cMethod(str str:String) -> String {
        print("\(first)")
        return String(first) + str
    }
    func dMethod(str:String, str0:String) -> String {
        print("\(first)")
        return String(first) + str + str0
    }
    
    init(fi:Int) {
        first = fi
    }
}
let s: String = "ww"
let ss: String = "ee"
let aaa = AAA(fi: 4)
let one: Selector = "aMethod"
let aa = aaa.performSelector(one).takeRetainedValue()
let two: Selector = "bMethod:"
let bb = aaa.performSelector(two, withObject: s).takeRetainedValue()
let three: Selector = "cMethodWithStr:"
let cc = aaa.performSelector(three, withObject: s).takeRetainedValue()
注意：当方法含有两个参数时，调用失败，。。。。。。需要继续找两个参数时的调用方法
// let four: Selector = "dMethodWithStr:str0:"
// let dd = aaa.performSelector(four, withObject: s, withObject: ss)
// --
[]
let squares = Array((1...10).map{ $0 * $0 })    // 1到10的平方的数组
let sum = squares.reduce(0, combine: { $0 + $1 })   // 求和


[where]
public func !=<T : RawRepresentable where T.RawValue : Equatable>(lhs: T, rhs: T) -> Bool
约定调用!=这个方法的参数的规则为：在T.RawValue遵守Equatable的条件下，T也必须遵守RawRepresentable协议；这样才能够保证能够判断这两个的RawRepresentable值是否相等。

有些时候，我们会希望一个接口的默认实现只在某些特定条件下适用。
extension MutableCollectionType where Self.Generator.Element : Comparable {
    @warn_unused_result(mutable_variant="sortInPlace")
    public func sort() -> [Self.Generator.Element]
}

分析：
1. let sortableArray: [Int] = [3,1,2,4,5]
sortableArray.sort()
因为Int类型默认实现了Comparable接口，所以可以调用默认的sort进行排序
public struct Int : SignedIntegerType, Comparable, Equatable {

2. let unsortableArray: [AnyObject?] = ["Hello", 4, nil]
因为AnyObject没有实现Comparable接口，所以不能调用默认的sort进行排序，只能使用自定义重写的sort
public protocol AnyObject {
//unsortableArray.sort()


[protocol extension]首先swift是强类型语言。OC里面是用的继承来实现requested和optional的，自己没实现则调用父类的。
首先，接口扩展中其实是提供了接口中规定的方法的默认实现，使得接口中规定的方法不再是必须实现的。参考tableView
接口扩展和OC中的继承可做一比较，OC中通过父类实现接口，子类选择性的实现方法来实现--可选方法的默认实现这一功能。
如果类型推断得到的是实际的类型，那么类型中的实现将被调用；如果类型中没有实现的话，接口扩展中的默认实现将被使用。（这种情况下，如果自身没有实现，而接口扩展中又找不到时，会报出没有实现接口的错误）
如果类型推断得到的是接口而不是实际类型：1. (1)并且方法在接口中进行了定义，那么类型中的实现将被调用；(2)如果类型中没有实现，那么接口扩展中的默认实现被调用(当调用@objc修饰protocol时，第二条如果类型没有实现则会报错Execution was interrupted,reson:signal SIGABRT. 也就是说，oc协议没有扩展这一说，所以在类中找不到实现就报错了，去掉@objc就和swift调用一致了，即使类是继承自OC的，如NSObject等)。2. 如果该方法在接口中没有定义，扩展中的默认实现将被调用，而不会去调用实际类型所实现的那个方法。（第二种情况下，接口在调用自身未定义的方法时，会暗示这个方法在扩展中实现了，如果没有实现，则会出现Value of type '接口类型' has no member '这个func'的错误）




[Optional]
public enum Optional<Wrapped> : _Reflectable, NilLiteralConvertible {
    case None
    case Some(Wrapped)
    ...
}

var aNil: String = nil
var anotherNil: String?? = aNil
var literalNil: String?? = nil

fr v -R 打印变量未加工过的信息
(lldb)fr v -R anotherNil
(Swift.Optional<Swift.Optional<Swift.String>>)
    anotherNil = Some {
    ...
}
(lldb)fr v -R literalNil
(Swift.Optional<Swift.Optional<Swift.String>>)
    literalNil = None {
    ...
}


[正则表达式]
.   匹配除换行符以外的任意字符
\w  匹配字母或数字或下划线或汉字
\s  匹配任意的空白符
\d  匹配数字
\b  匹配单词的开始或结束
^   匹配字符串的开始（一般是行首）
$   匹配字符串的结束（一般是行尾）
+   一次或更多次
*   任意次数，可能是0次
?   零次或一次
{n} 匹配 n 次
{n,}    匹配 n 次或更多次
{n，m} 重复次数不少于 n 次，不多于 m 次
[aeiou]就匹配任何一个英文元音字母，[.?!]匹配标点符号(.或?或!)
[0-9]代表的含意与\d就是完全一致的：一位数字；同理[a-z0-9A-Z_]也完全等同于\w（如果只考虑英文的话）

\W  匹配任意不是字母，数字，下划线，汉字的字符
\S  匹配任意不是空白符的字符
\D  匹配任意非数字的字符
\B  匹配不是单词开头或结束的位置
[^x]    匹配除了x以外的任意字符
[^aeiou]    匹配除了aeiou这几个字母以外的任意字符

分组
\b(\w+)\b\s+\1\b可以用来匹配重复的单词，像go go, 或者kitty kitty。这个表达式首先是一个单词，也就是单词开始处和结束处之间的多于一个的字母或数字(\b(\w+)\b)，这个单词会被捕获到编号为1的分组中，然后是1个或几个空白符(\s+)，最后是分组1中捕获的内容（也就是前面匹配的那个单词）(\1)。

分类    代码/语法           说明
捕获    (exp)           匹配exp,并捕获文本到自动命名的组里
        (?<name>exp)    匹配exp,并捕获文本到名称为name的组里，也可以写成(?'name'exp)
        (?:exp)         匹配exp,不捕获匹配的文本，也不给此分组分配组号
零宽断言    (?=exp)     匹配exp前面的位置
            (?<=exp)    匹配exp后面的位置
            (?!exp)     匹配后面跟的不是exp的位置
            (?<!exp)    匹配前面不是exp的位置
注释    (?#comment)     这种类型的分组不对正则表达式的处理产生任何影响，用于提供注释让人阅读

注意：1. 分组0对应整个正则表达式；2. 实际上组号分配过程是要从左向右扫描两遍的：第一遍只给未命名组分配，第二遍只给命名组分配－－因此所有命名组的组号都大于未命名的组号；3. 你可以使用(?:exp)这样的语法来剥夺一个分组对组号分配的参与权．


^[a-z0-9_-]{3,16}$
以小写字母、数字、下划线、连接线开头，包含3到16个这样的字符，并一直到行结尾没有其他字符的。
^#?([a-f0-9]{6}|[a-f0-9]{3})$
以一个或零个#开头，后跟6个小写字母或3个小写字母结尾的行。
^[a-z0-9-]+$
包含一个或多个小写字母、数字、连接线的行

matching an email
^({a-z0-9_\.-]+)@([\da-z\.-]+)\.([a-z\.]{2,6}$)
以一个或多个小写字母、数字、_ 、. 、- 开头，后接@，一个或多个数字或小写字母或.或-，后接. ，以2到6个字母或.结尾 

matching an url
^(https?:\/\/)?([\da-z\.-]+)\.([a-z\.]{2,6})([/\w\.-]*)*\/?$

matching an ip
^(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$

252.252.252.252
248.248.248.248
188.188.188.188
88.88.88.88
8.8.8.8

matching an html tag
^<([a-z]+)([^>]+)*(?:>(.*)<\/\1>|\s+\/>)$

<a3we3-3we3->.*</1
<a3we3-3we3-     />
<aaa3we3-3we3->.*</1
<aaa3we3-3we3-     />


[default param]
func sayHello1(str1: String = "Hello", str2: String, str3: String) {
    print(str1 + str2 + str3)
}
func sayHello2(str1: String, str2: String, str3: String = "World") {
    print(str1 + str2 + str3)
}
sayHello1(str2: " ", str3: "World") // 对于默认参数可不传入值
sayHello2("Hello", str2: " ")
当方法含有默认参数时，系统会自动提供不包含默认参数的方法。

// swift提供的 NSLocalizedString 就包含有三个默认参数
public func NSLocalizedString(key: String, tableName: String? = default, bundle: NSBundle = default, value: String = default, comment: String) -> String

[singleton]
class MyManager {
    private static let sharedInstance = MyManager()
    class var sharedManager : MyManager {
        return sharedInstance
    }
}

MyManager.sharedManager

[类型范围作用域 static / class]
protocol MyProtocol {
    static func foo() -> String
}
struct MyStruct: MyProtocol {
    static func foo() -> String {
        return "MyStruct"
    }
}
enum MyEnum: MyProtocol {
    static func foo() -> String {
        return "MyStruct"
    }
}
class MyClass: MyProtocol {
    // 在class 中可以使用class
    class func foo() -> String {
        return "MyStruct.foo()"
    }
    // 也可以使用static
    static func foo() -> String {
        return "MyStruct"
    }
}

    

// -----------
value = {
        birthday = "<null>";
        nickname = "\U5f20\U7984";
        sex = 0;
    },
    {
        accessToken = "OezXcEiiBSKSxW0eoylIeFUjnoSzBxyZEyUXIfsAB6HLCg-8_7N9lhMhUkjH9H7M-Kgk4DgeoUc1CN-cmwCqIjL-3SXKdx0fzEpk1dyOdJ__xUj52i-AQg6ceE-aPuMP0Xx-L0oMQKNWjXObPGDQbA";
        expiresIn = 7199;
        openId = oXwmpt5RbObeLtkkOhhEu30YDa6E;
        platform = Wechat;
    }

NSMutableDictionary *userInfoParam = [value.first mutableCopy];
                     userInfoParam[@"marketId"] = [AppInfo marketId];
                     userInfoParam[@"serverId"] = [ServiceProvider sharedServiceProvider].currentServerId;
                     return [[YTXUserManager sharedManager] thirdPartyLogin:@{ @"userInfo" : userInfoParam, @"authentication" : value.second }];

// -----------
@import AdSupport.ASIdentifierManager;

#pragma mark - autoRegisterAndLogin
- (void)autoRegisterAndLogin
{
    NSDictionary *userInfoParam = @{@"birthday" : @"<null>",
                                    @"nickname" : @"访客_手机品牌",
                                    @"sex" : @(0),
                                    @"marketId" : [AppInfo marketId],
                                    @"serverId" : [ServiceProvider sharedServiceProvider].currentServerId
                                    };
    NSDictionary *userDeviceInfo = @{@"accessToken" : [AppInfo deviceUUID],
                                     @"expiresIn" : @(7199),
                                     @"openId" : [ASIdentifierManager sharedManager].advertisingIdentifier.UUIDString,
                                     @"platform" : @"访客"
                                     };
    [[YTXUserManager sharedManager] thirdPartyLogin:@{ @"userInfo" : userInfoParam, @"authentication" : userDeviceInfo }];
}



[接口组合]Protocol compositions do not define a new,permanent protocol type. Rather, they define a temporary local protocol that has the combined requirements of all protocols in the compositions.
接口组合是组合一个临时的接口集合才做某些整体的操作。
typealias PetLike = protocol<KittenLike, DogLike> // 将组合起个别名，方便多次调用以及理解


// -- 不同接口内的方法重名时，先将实现as为不同的接口再调用相应的方法。
protocol A {
    func bar() -> Int
}
protocol B {
    func bar() -> String
}
class Class: A, B {
    func bar() -> Int {
        return 1
    }
    func bar() -> String {
        return "Hi"
    }
}
let instance = Class()
let num = (instance as A).bar()  // 1
let str = (instance as B).bar()  // "Hi"
// --
protocol Named {
    var name: String {get}
}
protocol Aged {
    var age: Int {get}
}
struct Person: Named, Aged {
    var name: String
    var age: Int
}
func wishHappyBirthday(celebrator: protocol<Named,Aged>) {// 同时实现这两个接口的class都可以传入
    print("\(celebrator.name)-\(celebrator.age)")
}
let person = Person(name: "HiBort", age: 12)

wishHappyBirthday(person)

// protocol<Named,Aged>意思是任何同时遵守Named和Aged这两协议的type
// --

[@objc classes]
为协议添加optional选项时，需要在前面加上@objc
@objc protocol 表明这个协议 should be exposed to OC code and is described in Using Swift with Cocoa and OC.
@objc protocol只作用于其他继承自OC的类或者是其他添加@objc 前缀的类。不能用于struct and enum。
换句话说，就是包含有可选类型的协议不能用于swift专有的类。

[初始化方法调用顺序]
override init() {
    power = 10
    super.init()
    name = "tiger"
}
1. 设置子类自己需要初始化的参数
2. 调用父类的相应的初始化方法
3. 对父类中的需要改变的成员进行设定。
注意：当不需要对父类中的值进行更改时，可以不显式的调用self.init()，（实际上是swift帮我们进行了隐式的调用）

[Array, ContiguousArray, ArraySlice]值类型
`Array` is an efficient, tail-growable random-access collection of arbitrary elements.高效的，尾部可添加，随机读取集合中任意位置的元素
Value Semantics 值语义
Array可以自动桥接OC
ContiguousArray类似Array，不能桥接OC
ArraySlice经常使用在瞬时操作，如计算中间过程，不能桥接OC


[可变参数]
extension Array {
    subscript(input: [Int]) -> ArraySlice<Element> {
        get {
            var result = ArraySlice<Element>()
            for i in input {
                assert(i < self.count, "Index out if bounds")
                result.append(self[i])
            }
            return result
        }
        set {
            for (index, i) in input.enumerate() {
                assert(i < self.count, "Index out if bounds")
                self[i] = newValue[index]
            }
        }
    }
}
var arr = [1,2,3,4,5]
arr.append(6)
arr[[1,3]]
arr[[0,2,3]] = [10,11,12]

extension Array {
    subscript(inputs: Int...) -> ArraySlice<Element> {
        get {
            var result = ArraySlice<Element>()
            
            for i in inputs {
                result.append(self[i])
            }
            return result
        }
        set {
            for (index,i) in inputs.enumerate() {
                self[i] = newValue[index]
            }
        }
    }
}
arr[2,3,4] = [33,44,55]

extension SequenceType {
    /// Return a lazy `SequenceType` containing pairs (*n*, *x*), where
    /// *n*s are consecutive `Int`s starting at zero, and *x*s are
    /// the elements of `base`:
    ///
    ///     > for (n, c) in "Swift".characters.enumerate() {
    ///         print("\(n): '\(c)'")
    ///       }
    ///     0: 'S'
    ///     1: 'w'
    ///     2: 'i'
    ///     3: 'f'
    ///     4: 't'
    @warn_unused_result
    public func enumerate() -> EnumerateSequence<Self>
}

[初始化方法遵循的规则]
初始化路径必须保证对象完全初始化，这可以通过调用本类型的designated初始化方法来保证。
可以给init方法添加required前缀来要求子类必须实现。这个修饰词同样具有传递性（如：inout）。
1. 子类的designated初始化方法必须调用父类的designated方法，保证父类完成初始化。
2. convenience初始化方法必须调用本类的另一个初始化方法来完成初始化。
3. convenience初始化方法最终必须调用本类的designated初始化方法。
// P466

In functional programming, you think of immutable data structures and functions that convert them. 

In object-oriented programming, you think about objects that send messages to each other.

在函数式编程当中你想的是不变的数据结构以及那些转换它们的函数。在面对对象编程当中你考虑的是互相发送信息的对象。

[根据遵循不同的协议来实现不同的方法]
这是一种写出具有延展性函数的很好的方法。通过使用一个需要遵守协议，而不是一个实实在在的类型，你的 API 的用户能够加入更多的类型。你仍然可以利用 enum 的灵活性，但是通过让它们遵守协议，你可以更好地表达自己的意思。根据你的具体情况，你现在可以轻松地选择是否开放你的 API。

[Methods And Functions]
Functions are standalone, while methods are functions that are encapsulated in a class, struct, or enum.
函数是独立的，而方法是函数封装在类，结构或者枚举中的函数。

[If you want the external and internal parameter names to be the same.]
func hello(name name: String) {
    println("hello \(name)")
}
或者
func hello(#name: String) {
    println("hello \(name)")
}
hello(name: "Robot")


struct Celsius {
    var temperatureInCelsius: Double
    init(fromFahrenheit fahrenheit: Double) {// 定义外部参数名
        temperatureInCelsius = (fahrenheit - 32.0) / 1.8
    }
    init(fromKelvin kelvin: Double) {
        temperatureInCelsius = kelvin - 273.15
    }
    init(_ celsius: Double) { // 忽略外部参数名，即不写
        temperatureInCelsius = celsius
    }
}

let boilingPointOfWater = Celsius(fromFahrenheit: 212.0)
// boilingPointOfWater.temperatureInCelsius is 100.0

let freezingPointOfWater = Celsius(fromKelvin: 273.15)
// freezingPointOfWater.temperatureInCelsius is 0.0

let bodyTemperature = Celsius(37.0)
// bodyTemperature.temperatureInCelsius is 37.0

[Optional return]
func myFuncWithOptionalType(optionalParameter: String?) {
    if let unwrappedOptional = optionalParameter {
        println("The optional has a value! It's \(unwrappedOptional)")
    } else {
        println("The optional is nil!")
    }
}

myFuncWithOptionalType("someString")
// The optional has a value! It's someString

myFuncWithOptionalType(nil)
// The optional is nil

[Parameters with Default Values]it is best practice to put all your parameters with default values at the end of a function’s parameter list. 
func hello(name: String = "you") {
    println("hello, \(name)")
}

hello(name: "Mr. Roboto")
// hello, Mr. Roboto

hello()
// hello, you

// I’m a huge fan of default parameters, mostly because it makes code easy to change and backward compatible. You might start out with two parameters for your specific use case at the time, such as a function to configure a custom UITableViewCell, and if another use case comes up that requires another parameter (such as a different text color for your cell’s label), just add a new parameter with a default value — all the other places where this function has already been called will be fine, and the new part of your code that needs the parameter can just pass in the non-default value!

可变参数
[Variadic Parameters]Variadic parameters are simply a more readable version of passing in an array of elements. In fact, if you were to look at the type of the internal parameter names in the below example, you’d see that it is of type [String] (array of strings):
func helloWithNames(names: String...) {
    if names.count > 0 {// The catch here is to remember that it is possible to pass in 0 values, just like it is possible to pass in an empty array, so don’t forget to check for the empty array if needed:
        for name in names {
            println("Hello, \(name)")
        }
    } else {
        println("Nobody here!")
    }
}
// Another note about variadic parameters: the variadic parameter must be the last parameter in your function’s parameter list!

func arithmeticMean(numbers: Double...) -> Double {
    var total: Double = 0
    for number in numbers {
        total += number
    }
    return total / Double(numbers.count)
}
arithmeticMean(1, 2, 3, 4, 5)
// returns 3.0, which is the arithmetic mean of these five numbers

[Inout Parameters] 通过Inout 参数，来改变外部变量
var name1 = "Mr. Potato"
var name2 = "Mr. Roboto"
func nameSwap(inout name1: String, inout name2: String) {
    let oldName1 = name1
    name1 = name2
    name2 = oldName1
}
nameSwap(&name1, name2: &name2)
name1
// Mr. Roboto
name2
// Mr. Potato

// 使用变量参数可以直接使用传入的参数，但不会改变参数原来的值。变量参数仅仅存在于函数调用的生命周期中。
func alignRight(var string: String, totalLength: Int, pad: Character) -> String {
    let amountToPad = totalLength - string.characters.count
    if amountToPad < 1 {
        return string
    }
    let padString = String(pad)
    for _ in 1...amountToPad {
        string = padString + string
    }
    return string
}
let originalString = "hello"
let paddedString = alignRight(originalString, totalLength: 10, pad: "-")
// paddedString is equal to "-----hello"
// originalString is still equal to "hello"

[Generic Parameter Types] 泛型 在一个函数中接受两个类型不定的参数，但确保这两个参数类型是相同的：
func valueSwap<T>(inout value1: T, inout value2: T) {
    let oldValue1 = value1
    value1 = value2
    value2 = oldValue1
}

valueSwap(&name1, value2: &name2)
name1 // Mr. Roboto
name2 // Mr. Potato

var number1 = 2
var number2 = 5
valueSwap(&number1, value2: &number2)
number1 // 5
number2 // 2

[Variable Parameters: var]
var name = "Mr. Roboto"
func appendNumbersToName(var name: String, #maxNumber: Int) -> String {
    for i in 0..<maxNumber {
        name += String(i + 1)
    }
    return name
}
appendNumbersToName(name, maxNumber:5)
// Mr. Robot12345
name
// Mr. Roboto
值得注意的是这个和 inout 参数不同 — 变量参数不会修改外部传入变量！就像是拷贝一份变量来进行运算，而不影响原来的变量

[作为参数的函数]
在 Swift 中，函数可以被用来当做变量传递。比如，一个函数可以含有一个函数类型的参数：
func luckyNumberForName(name: String, #lotteryHandler: (String, Int) -> String) -> String {
    let luckyNumber = Int(arc4random() % 100)
    return lotteryHandler(name, luckyNumber)
}

func defaultLotteryHandler(name: String, luckyNumber: Int) -> String {
    return "\(name), your lucky number is \(luckyNumber)"
}

luckyNumberForName("Mr. Roboto", lotteryHandler: defaultLotteryHandler)
// Mr. Roboto, your lucky number is 38
注意下只有函数的引用被传入 — 在本例中是 defaultLotteryHandler。这个函数之后是否执行是由接收的函数决定。
实例方法也可以用类似的方法传入：
func luckyNumberForName(name: String, #lotteryHandler: (String, Int) -> String) -> String {
    let luckyNumber = Int(arc4random() % 100)
    return lotteryHandler(name, luckyNumber)
}
class FunLottery {
    func defaultLotteryHandler(name: String, luckyNumber: Int) -> String {
        return "\(name), your lucky number is \(luckyNumber)"
    }
}
let funLottery = FunLottery()
luckyNumberForName("Mr. Roboto", lotteryHandler: funLottery.defaultLotteryHandler)
// Mr. Roboto, your lucky number is 38

为了让你的函数定义更具可读性，可以考虑为你函数的类型创建别名 (类似于 Objective-C 中的 typedef)：
typealias lotteryOutputHandler = (String, Int) -> String
func luckyNumberForName(name: String, #lotteryHandler: lotteryOutputHandler) -> String {
    let luckyNumber = Int(arc4random() % 100)
    return lotteryHandler(name, luckyNumber)
}

你也可以使用不包含参数名的函数 (类似于 Objective-C 中的 blocks)：
func luckyNumberForName(name: String, #lotteryHandler: (String, Int) -> String) -> String {
    let luckyNumber = Int(arc4random() % 100)
    return lotteryHandler(name, luckyNumber)
}
luckyNumberForName("Mr. Roboto", lotteryHandler: {name, number in
    return "\(name)'s' lucky number is \(number)"
})
// Mr. Roboto's lucky number is 74
在 Objective-C 中，使用 blocks 作为参数是异步操作是操作结束时的回调和错误处理的常见方式，这一方式在 Swift 中得到了很好的延续。

[Access Controls]
Swift 有三个级别的权限控制：
Public 权限 可以为实体启用定义它们的模块中的源文件的访问，另外其他模块的源文件里只要导入了定义模块后，也能进行访问。通常情况下，Framework 是可以被任何人使用的，你可以将其设置为 public 级别
Internal 权限 可以为实体启用定义它们的模块中的源文件的访问，但是在定义模块之外的任何源文件中都不能访问它。通常情况下，app 或 Framework 的内部结构使用 internal 级别。
Private 权限 只能在当前源文件中使用的实体。使用 private 级别，可以隐藏某些功能的特地的实现细节。
默认情况下，每个函数和变量是 internal 的 —— 如果你希望修改他们，你需要在每个方法和变量的前面使用 private 或者 public 关键字：
public func myPublicFunc() {
}

func myInternalFunc() {
}

private func myPrivateFunc() {
}

private func myOtherPrivateFunc() {
}


[Fancy Return Types返回类型] 在 Swift 中，函数的返回类型和返回值相较于 Objective-C 而言更加复杂，尤其是引入可选和多个返回类型。
[Optional Return Types]
If there is a possibility that your function could return a nil value, you need to specify the return type as optional:
func myFuncWithOptonalReturnType() -> String? {
    let someNumber = arc4random() % 100
    if someNumber > 50 {
        return "someString"
    } else {
        return nil
    }
}
myFuncWithOptonalReturnType()
And of course, when you’re using the optional return value, don’t forget to unwrap:
let optionalString = myFuncWithOptonalReturnType()
if let someString = optionalString {
    println("The function returned a value: \(someString)")
} else {
    println("The function returned nil")
}

[Multiple Return Values]
One of the most exciting features of Swift is the ability for a function to have multiple return values:
func findRangeFromNumbers(numbers: Int...) -> (min: Int, max: Int) {
    var min = numbers[0]
    var max = numbers[0]
    for number in numbers {
        if number > max {
            max = number
        }
        if number < min {
            min = number
        }
    }
    return (min, max)
}
findRangeFromNumbers(1, 234, 555, 345, 423)
// (1, 555)

As you can see, the multiple return values are returned in a tuple, a very simple data structure of grouped values. There are two ways to use the multiple return values from the tuple:

let range = findRangeFromNumbers(1, 234, 555, 345, 423)
println("From numbers: 1, 234, 555, 345, 423. The min is \(range.min). The max is \(range.max).")
// From numbers: 1, 234, 555, 345, 423. The min is 1. The max is 555.

let (min, max) = findRangeFromNumbers(236, 8, 38, 937, 328)
println("From numbers: 236, 8, 38, 937, 328. The min is \(min). The max is \(max)")
// From numbers: 236, 8, 38, 937, 328. The min is 8. The max is 937

[Multiple Return Values and Optionals]
The tricky part about multiple return values is when the return values can be optional, but there are two ways to handle dealing with optional multiple return values.
In the above example function, my logic is flawed — it is possible that no values could be passed in, so my program would actually crash if that ever happened. If no values are passed in, I might want to make my whole return value optional:
func findRangeFromNumbers(numbers: Int...) -> (min: Int, max: Int)? {
    if numbers.count > 0 {
        var min = numbers[0]
        var max = numbers[0]
        for number in numbers {
            if number > max {
                max = number
            }
            if number < min {
                min = number
            }
        }
        return (min, max)
    } else {
        return nil
    }
}

if let range = findRangeFromNumbers() {
    println("Max: \(range.max). Min: \(range.min)")
} else {
    println("No numbers!")
}
// No numbers!

In other cases, it might make sense to make each return value within a tuple optional, instead of making the whole tuple optional:
func componentsFromUrlString(urlString: String) -> (host: String?, path: String?) {
    let url = NSURL(string: urlString)
    return (url.host, url.path)
}

If you decide that some of your tuple values could be optionals, things become a little bit more difficult to unwrap, since you have to consider every single combination of optional values:

let urlComponents = NSURLComponents(string: "http://name.com/12345;param?foo=1&baa=2#fragment")

switch (urlComponents!.host, urlComponents!.path) {
case let (.Some(host), .Some(path)):
    print("This url consists of host \(host) and path \(path)")
case let (.Some(host), .None):
    print("This url only has a host \(host)")
case let (.None, .Some(path)):
    print("This url only has path \(path). Make sure to add a host!")
case (.None, .None):
    print("This is not a url!")
}

[Return a Function]
func myFuncThatReturnsAFunc() -> (Int) -> String {
    return { number in
        return "The lucky number is \(number)"
    }
}
let returnedFunction = myFuncThatReturnsAFunc()
returnedFunction(5) // The lucky number is 5

To make this more readable, you can of course use type-aliasing for your return function:

typealias returnedFunctionType = (Int) -> String
func myFuncThatReturnsAFunc() -> returnedFunctionType {
    return { number in
        return "The lucky number is \(number)"
    }
}
let returnedFunction = myFuncThatReturnsAFunc()
returnedFunction(5) // The lucky number is 5

[Nested Functions]嵌套函数
func myFunctionWithNumber(someNumber: Int) {

    func increment(var someNumber: Int) -> Int {
        return someNumber + 10
    }

    let incrementedNumber = increment(someNumber)
    println("The incremented number is \(incrementedNumber)")
}
myFunctionWithNumber(5)
// The incremented number is 15


ios国际化
http://www.cnblogs.com/lisa090818/p/3240708.html

随笔ios
http://www.cnblogs.com/zhidao-chen/category/461198.html

Swift 是强类型语言，并有类型推断的特性的语言。
Swift is very much into strong typing and type inference and all that. 

[代码标记]
//MARK: TableViewDataSource
//MARK: -  TableViewDataSource
private typealias TableViewDataSource = ViewController

let label = "The width is"
let width = 94
let widthLabel = "label +String(width)"

一元负号运算符
数值的正负号可以使用前缀 - (即一元负号)来切换:
let three = 3
let minusThree = -three // minusThree 等于 -3
let plusThree = -minusThree // plusThree 等于 3, 或 "负负3"
一元负号( - )写在操作数之前,中间没有空格。

一元正号运算符 同理于一元负号运算符

大于等于( a >= b )
小于等于( a <= b )

空合运算符(Nil Coalescing Operator)
空合运算符( a ?? b )将对可选类型 a 进行空判断,如果 a 包含一个值就进行解封,否则就返回一个默认值 b .这 个运算符有两个条件:
    表达式 a 必须是Optional类型
    默认值 b 的类型必须要和 a 存储值的类型保持一致

[ClosedInterval]闭区间运算符( a...b )定义一个包含从 a 到 b (包括 a 和 b )的所有值的区间, b 必须大于等于 a 。
[HalfOpenInterval]半开区间( a..<b )定义一个从 a 到 b 但不包括 b 的区间。
只能用户运算（某个区间是否包含某字符、数字、valu），不能用于生成字符串等。
\0...~   判断某个字符是否是有效的ASCII字符

import UIKit

var str = "Hello, playground"

let label = "The width is "
let width = 94
let widthLabel = label + String(width)
let widthL = label + "\(width)"

//使用[]来创建数组和字典，并使用下标或key来访问元素
var shoppingList = ["catfish", "water", "tulips", "blue pa"]
shoppingList[1] = "bottle of water"
var occupations = [
    "Malcolm": "Captain",
    "Kaylee": "Mechanic",
]
occupations["Jayne"] = "Public Relations"
//使用初始化方法来创建一个空数组或字典
let emptyArray = [String]()
let ematyDictionary = Dictionary<String, Float>()
let list = []
let occ = [:]

let scores = [75,43,103,23,45]
var teamScore = 0
for score in scores {
    if score > 50 { //在if语句中，条件必须是一个布尔表达式，不会隐形的与0或1做对比
        teamScore += 3
    } else {
        teamScore += 1
    }
}
teamScore

var optionalString: String? = "Hello"
optionalString = nil

var optionalName: String? = "John" //类型后面加一个问号来标记这个变量的值是可选的
optionalName = nil
var greeting = "Hello!"
if let name = optionalName {
    greeting = "Hello, \(name)"
} else {
    greeting = "Hello, greet"
}

//switch 支持任意类型的数据以及各种比较操作--不仅仅是整数以及测试相等，运行到switch 中匹配到的子句后，程序会会推出而不会继续向下运行，所以不需要在每个子句结尾添加break
let vegetable = "watercress"
switch vegetable {
case "celery":
    let vegetableComment = "Add some"
case "cucumber", "watercress":
    let vegetableComment = "That would"
case let x where x.hasPrefix("pepper"):
    let vegetableComment = "Is it a spicy \(x)?"
default:
    let vegetableComment = "Everything"
}

//可以使用for-in来遍历字典，需要两个变量来表示每个键值对
let insterestingNumbers = [
    "Prime": [2,3,4,5,6,7,8],
    "Fibonacci": [1,1,1,2,3,4],
    "Square": [3,3,3,6,7,8]
]
var largest = 0
var type = String()
for (kind, numbers) in insterestingNumbers {
    for number in numbers {
        if number > largest {
            largest = number
            type = kind
        }
    }
}
"\(type) : \(largest)"

for i in 0...3 { //...代表包含上下界的范围
    largest -= 1
}
largest

//使用func来声明一个函数，使用名字和参数来调用函数。使用->来指定函数返回值
func greet(name: String, day: String) ->String {
    return "Hello \(name), today is \(day)"
}

//使用一个元组来返回多个值
func getGasPrices() -> (Double, Double, Double) {
    return (3.45, 3.46, 3.56)
}
getGasPrices()

//函数的参数是可变的，用一个数组来获取它们
func sumOf(numbers:Int...) ->Int {
    var sum = 0
    for number in numbers {
        sum += number
    }
    return sum
}
sumOf()
sumOf(42, 45, 67)

//函数可以嵌套，被嵌套的函数可以访问外侧函数的变量，可以使用嵌套函数来重构一个过于复杂的函数
//函数也可以作为另一个函数的返回值
func makeIncrementer() -> (Int ->Int) {
    func addOne(number : Int) ->Int {
        return 1 + number
    }
    return addOne
}
var increment = makeIncrementer()
increment(7)

//函数也可以当做参数传入另一个函数
func hasAnyMatches(list: [Int], condition: Int -> Bool) -> Bool {
    for item in list {
        if condition(item) {
            item
            return true
        }
    }
    return false
}
func lessThanTen(number: Int) -> Bool {
    return number > 10
}

var numbers = [20, 19, 7, 12]
hasAnyMatches(numbers, lessThanTen)
println("11111111111111")
//函数实际上是一种特殊的闭包，你可以使用{}来创建一个匿名闭包，使用in 将参数和返回值类型声明与闭包函数体进行分离
numbers.map({
    (number: Int) -> Int in
    let result = 3 * number
    if result % 2 == 1 {
        return 0
    }
    return result
})
var  a = 10
//var b = numbers.map(a)

//sort([1, 5, 3, 12, 2]){$0 > $1}


闭包表达式（Closure Expression）
闭包（closure） 表达式可以建立一个闭包（在其他语言中也叫 lambda, 或者 匿名函数（anonymous function））. 跟函数（function）的声明一样， 闭包（closure）包含了可执行的代码（跟方法主体（statement）类似） 以及接收（capture）的参数。 它的形式如下：

{ (parameters) -> return type in
    statements
}

闭包的参数声明形式跟方法中的声明一样, 请参见：Function Declaration.

闭包还有几种特殊的形式, 让使用更加简洁：

1. 闭包可以省略 它的参数的type 和返回值的type. 如果省略了参数和参数类型，就也要省略 'in'关键字。 如果被省略的type 无法被编译器获知（inferred） ，那么就会抛出编译错误。
2. 闭包可以省略参数，转而在方法体（statement）中使用 $0, $1, $2 来引用出现的第一个，第二个，第三个参数。
3. 如果闭包中只包含了一个表达式，那么该表达式就会自动成为该闭包的返回值。 在执行 'type inference '时，该表达式也会返回。

下面几个 闭包表达式是 等价的：
myFunction {
        (x: Int, y: Int) -> Int in
            return x + y
}

myFunction {
        (x, y) in
            return x + y
}

myFunction { return $0 + $1 }

myFunction { $0 + $1 }


属性监视器

属性监视器监控和响应属性值的变化，每次属性被设置值的时候都会调用属性监视器，甚至新的值和现在的值相同的时候也不例外。

可以为除了延迟存储属性之外的其他存储属性添加属性监视器，也可以通过重载属性的方式为继承的属性（包括存储属性和计算属性）添加属性监视器。属性重载请参考继承一章的重载。

注意：不需要为无法重载的计算属性添加属性监视器，因为可以通过 setter 直接监控和响应值的变化。

[运算符重载]
类和结构可以为"现有的操作符"提供自定义的实现，这通常被称为运算符重载(overloading)。
struct Vector2D {
    var x = 0.0, y = 0.0
}
//一般运算符
func + (left: Vector2D, right: Vector2D) -> Vector2D {
    return Vector2D(x: left.x + right.x, y: left.y + right.y)
}
//前缀后缀运算符
类与结构体也能提供标准单目运算符(unary operators)的实现。单目运算符只有一个操作目标。当运算符出现在操作目标之前时，它就是前缀(prefix)的(比如 -a)，而当它出现在操作目标之后时，它就是后缀(postfix)的(比如 i++)。

要实现前缀或者后缀运算符，需要在声明运算符函数的时候在 func 关键字之前指定 prefix 或者 postfix 限定符：

prefix func - (cube: Cube) -> Cube{
    return Cube(side: -cube.side)
}

postfix func ++ (cube: Cube) -> Cube {
    return Cube(side: cube.side + 1)
}

复合赋值运算符

复合赋值运算符(Compound assignment operators)将赋值运算符(=)与其它运算符进行结合。比如，将加法与赋值结合成加法赋值运算符(+=)。在实现的时候，需要把运算符的左参数设置成 inout 类型，因为这个参数的值会在运算符函数内直接被修改。
func += (inout left: Cube, right: Cube) {
        left =  left + right
}

还可 ? b : c 进行重载。以将赋值与 prefix 或 postfix 限定符结合起来，下面的代码为 Vector2D 实例实现了前缀自增运算符(++a)：

注意： 不能对默认的赋值运算符(=)进行重载。只有组合赋值符可以被重载。同样地，也无法对三目条件运算符 a ? b : c 进行重载。

等价操作符

自定义的类和结构体没有对等价操作符(equivalence operators)进行默认实现，等价操作符通常被称为“相等”操作符(==)与“不等”操作符(!=)。对于自定义类型，Swift 无法判断其是否“相等”，因为“相等”的含义取决于这些自定义类型在你的代码中所扮演的角色。

为了使用等价操作符来对自定义的类型进行判等操作，需要为其提供自定义实现，实现的方法与其它中缀运算符一样：
func == (left:Cube, right:Cube) -> Bool {
        return left.side == right.side
}
func != (left:Cube, right:Cube) -> Bool {
        return left.side != right.side
}

[=== 和 !==]
判断两个引用型类型是否相同或不同。指针级别的。

[自定义操作符]
注意：以下标记被当作保留符号，不能用于自定义操作符：(、)、{、}、[、]、.、,、:、;、=、@、#、&（作为前缀操作符）、->、`、? 和 !(作为后缀操作符)。
个性的运算符只能使用这些字符 / = - + * % < > ! & | ^ . ~。
自定义的中缀(infix)运算符也可以指定优先级(precedence)和结合性(associativity)。优先级和结合性中详细阐述了这两个特性是如何对中缀运算符的运算产生影响的。

结合性(associativity)可取的值有left，right 和 none。当左结合运算符跟其他相同优先级的左结合运算符写在一起时，会跟左边的操作数进行结合。同理，当右结合运算符跟其他相同优先级的右结合运算符写在一起时，会跟右边的操作数进行结合。而非结合运算符不能跟其他相同优先级的运算符写在一起。

注意：不能为前缀和后缀运算符指定优先级，但是当前缀运算符和后缀运算符同时用于同一个操作数时，会首先调用后缀运算符。

结合性(associativity)的默认值是 none，优先级(precedence)如果没有指定，则默认为 100。

以下例子定义了一个新的中缀运算符 +-，此操作符是左结合的，并且它的优先级为 140：

infix operator ** { associativity left precedence 200 }
func ** (left: Cube, right: Cube) -> Cube {
    return Cube(side: left.side * right.side)
}

// ---- 自定义 ?? 运算符
infix operator ~?? {
    associativity left  // 结合性，默认none
    precedence 140      // 优先级，默认100
}
func ~??<T>(optional: T?, @autoclosure defaultValue: () -> T) -> T {
    switch optional {
    case .Some(let value):
        return value
    case .None:
        return defaultValue()
    }
}
// ----

注意：不能重写默认的=号运算符，也不能重写默认的三目运算符--?: 。

// 参数的修饰是具有传递限制的。外层的makeIncrementor的返回里也需要给参数支持明确的修饰符，来符合内部的定义，否则将无法编译通过。
let start = 1
// 参数的修饰是具有传递性质的
func makeIncrementer(addNumber:Int) -> ((inout Int) ->()) {
    func incrementer(inout info:Int) -> () {
        info += addNumber
    }
    return incrementer;
}

let ff = makeIncrementer(4)
ff(&start)
// ---


[__FILE__ | __LINE__ | __COLUMN__ | __FUNCTION__]
所在的文件名|所在的行数|所在的列数|所在的function的名字
在某个函数（function）中，__FUNCTION__ 会返回当前函数的名字。 在某个方法（method）中，它会返回当前方法的名字。 在某个property 的getter/setter中会返回这个属性的名字。 在特殊的成员如init/subscript中 会返回这个关键字的名字，在某个文件的顶端（the top level of a file），它返回的是当前module的名字。

[后缀self表达式（Postfix Self Expression）]
后缀表达式由 某个表达式 + '.self' 组成. 形式如下：
    expression.self
    type.self
形式1 表示会返回 expression 的值。例如： x.self 返回 x
形式2：返回对应的type。我们可以用它来动态的获取某个instance的type。
    后置Self 表达式语法
    后置self表达式 → 后置表达式 . self

[dynamic表达式（Dynamic Type Expression）]
动态类型表达式会返回"运行时"某个instance的type, 具体请看下面的列子：
class SomeBaseClass {
    class func printClassName() {
        println("SomeBaseClass")
    }
}
class SomeSubClass: SomeBaseClass {
    override class func printClassName() {
        println("SomeSubClass")
    }
}
let someInstance: SomeBaseClass = SomeSubClass()

// someInstance is of type SomeBaseClass at compile time, but
// someInstance is of type SomeSubClass at runtime
someInstance.dynamicType.printClassName()
// prints "SomeSubClass"



[Property Observers]
You can observe changes to any property with willSet and didSet.
可以为属性添加如下的一个或全部监视器：
1. willSet在设置新的值之前调用
2. didSet在新的值被设置之后立即调用

willSet监视器会将新的属性值作为固定参数传入，在willSet的实现代码中可以为这个参数指定一个名称，如果不指定则参数仍然可用，这时使用默认名称newValue表示。didSet监视器会将旧的属性值作为参数传入，可以为该参数命名或者使用默认参数名oldValue。

注意：willSet和didSet监视器在属性初始化过程中不会被调用，他们只会当属性的值在初始化之外的地方被设置时被调用。
//可以在重新设值后在这两个方法中添加提醒

这里是一个willSet和didSet的实际例子，其中定义了一个名为StepCounter的类，用来统计当人步行时的总步数，可以跟计步器或其他日常锻炼的统计装置的输入数据配合使用。
class StepCounter {
var totalSteps: Int = 0 {
    willSet(newTotalSteps) {
     //   newValue为新的值
        println("About to set totalSteps to \(newTotalSteps)")
    }
    didSet {
     //   oldValue为旧的值
        if totalSteps > oldValue  {
            println("Added \(totalSteps - oldValue) steps")
        }
    }
}
}
let stepCounter = StepCounter()
stepCounter.totalSteps = 200
// About to set totalSteps to 200
// Added 200 steps
stepCounter.totalSteps = 360
// About to set totalSteps to 360
// Added 160 steps
stepCounter.totalSteps = 896
// About to set totalSteps to 896
// Added 536 steps

[willSet and didSet]最常见的用法是update UI
eg: 改变了某个controller的属性，在didSet中，对UI进行更新。

StepCounter类定义了一个Int类型的属性totalSteps，它是一个存储属性，包含willSet和didSet监视器。

当totalSteps设置新值的时候，它的willSet和didSet监视器都会被调用，甚至当新的值和现在的值完全相同也会调用。

例子中的willSet监视器将表示新值的参数自定义为newTotalSteps，这个监视器只是简单的将新的值输出。

didSet监视器在totalSteps的值改变后被调用，它把新的值和旧的值进行对比，如果总的步数增加了，就输出一个消息表示增加了多少步。didSet没有提供自定义名称，所以默认值oldValue表示旧值的参数名。

注意：如果在didSet监视器里为属性赋值，这个值会替换监视器之前设置的值。

可以在子类的重载属性中对父类的属性任意添加属性观察，而不用在意父类中到底是存储属性还是计算属性。

全局变量和局部变量

计算属性和属性监视器所描述的模式也可以用于全局变量和局部变量，全局变量是在函数、方法、闭包或任何类型之外定义的变量，局部变量是在函数、方法或闭包内部定义的变量。

前面章节提到的全局或局部变量都属于存储型变量，跟存储属性类似，它提供特定类型的存储空间，并允许读取和写入。

另外，在全局或局部范围都可以定义计算型变量和为存储型变量定义监视器，计算型变量跟计算属性一样，返回一个计算的值而不是存储值，声明格式也完全一样。

注意：全局的常量或变量都是延迟计算的，跟延迟存储属性相似，不同的地方在于，全局的常量或变量不需要标记@lazy特性。 局部范围的常量或变量不会延迟计算。

[Lazy Initialization]
在初始化属性前添加lazy标示，甚至可以使用闭包和函数对属性进行初始化。只有在这个属性被用到时才会被执行。
如果不把property标记为lazy，使用函数对属性进行初始化是不允许的，因为在类初始化之前，类里的方法都是不可调用的。但是当get这个属性时，类已经建立，所以可以正常调用。
只有var可以使用lazy， let不可以使用lazy。
lazy var str: String = "Hello"

let result = data.lazy.map {  // 对于那些不需要完全运行，可能提前退出的情况，使用lazy来进行优化，效果不错。
    (i : Int) -> Int {
        return i * 2
    }
}

类型属性

实例的属性属于一个特定类型实例，每次类型实例化后都拥有自己的一套属性值，实例之间的属性相互独立。

也可以为类型本身定义属性，不管类型有多少个实例，这些属性都只有唯一一份。这种属性就是类型属性。

类型属性用于定义特定类型所有实例共享的数据，比如所有实例都能用的一个常量（就像 C 语言中的静态常量），或者所有实例都能访问的一个变量（就像 C 语言中的静态变量）。
对于值类型（指结构体和枚举）可以定义存储型和计算型类型属性，对于类（class）则只能定义计算型类型属性。

值类型的存储型类型属性可以是变量或常量，计算型类型属性跟实例的计算属性一样定义成变量属性。

注意：跟实例的存储属性不同，必须给存储型类型属性指定默认值，因为类型本身无法在初始化过程中使用构造器给类型属性赋值。

类型属性语法

在 C 或 Objective-C 中，静态常量和静态变量的定义是通过特定类型加上global关键字。在 Swift 编程语言中，类型属性是作为类型定义的一部分写在类型最外层的花括号内，因此它的作用范围也就在类型支持的范围内。

使用关键字static来定义值类型的类型属性，关键字class来为类（class）定义类型属性。下面的例子演示了存储型和计算型类型属性的语法：

struct SomeStructure {
static var storedTypeProperty = "Some value."
static var computedTypeProperty: Int {
// 这里返回一个 Int 值
}
}
enum SomeEnumeration {
static var storedTypeProperty = "Some value."
static var computedTypeProperty: Int {
// 这里返回一个 Int 值
}
}
class SomeClass {
class var computedTypeProperty: Int {
// 这里返回一个 Int 值
}
}

注意：例子中的计算型类型属性是只读的，但也可以定义可读可写的计算型类型属性，跟实例计算属性的语法类似。

获取和设置类型属性的值
跟实例的属性一样，类型属性的访问也是通过点运算符来进行，但是，类型属性是通过类型本身来获取和设置，而不是通过
实例。比如：
println(SomeClass.computedTypeProperty)
// 输出 "42"
println(SomeStructure.storedTypeProperty)
// 输出 "Some value."
SomeStructure.storedTypeProperty = "Another value."
println(SomeStructure.storedTypeProperty)
// 输出 "Another value.”
下面的例子定义了一个结构体，使用两个存储型类型属性来表示多个声道的声音电平值，每个声道有一个 0 到 10 之间的整数
表示声音电平值。
后面的图表展示了如何联合使用两个声道来表示一个立体声的声音电平值。当声道的电平值是 0，没有一个灯会亮；当声道
的电平值是 10，所有灯点亮。本图中，左声道的电平是 9，右声道的电平是 7。

上面所描述的声道模型使用AudioChannel结构体来表示：
struct AudioChannel {
static let thresholdLevel = 10
static var maxInputLevelForAllChannels = 0
var currentLevel: Int = 0 {
didSet {
if currentLevel > AudioChannel.thresholdLevel {
// 将新电平值设置为阀值
currentLevel = AudioChannel.thresholdLevel
}
if currentLevel > AudioChannel.maxInputLevelForAllChannels {
// 存储当前电平值作为新的最大输入电平
AudioChannel.maxInputLevelForAllChannels = currentLevel
}
}
}
}

结构AudioChannel定义了 2 个存储型类型属性来实现上述功能。第一个是thresholdLevel，表示声音电平的最大上限阈
值，它是一个取值为 10 的常量，对所有实例都可见，如果声音电平高于 10，则取最大上限值 10（见后面描述）。
第二个类型属性是变量存储型属性maxInputLevelForAllChannels，它用来表示所有AudioChannel实例的电平值的最
大值，初始值是 0。
AudioChannel也定义了一个名为currentLevel的实例存储属性，表示当前声道现在的电平值，取值为 0 到 10。
属性currentLevel包含didSet属性监视器来检查每次新设置后的属性值，有如下两个检查：
如果currentLevel的新值大于允许的阈值thresholdLevel，属性监视器将currentLevel的值限定为阈
值thresholdLevel。
如果修正后的currentLevel值大于任何之前任意AudioChannel实例中的值，属性监视器将新值保存在静态属
性maxInputLevelForAllChannels中。

注意：
在第一个检查过程中，didSet属性监视器将currentLevel设置成了不同的值，但这时不会再次调用属性监视器。

incrementBy方法有两个参数： amount和numberOfTimes。默认情况下，Swi ft  只把amount当作一个局部名称，但是
把numberOfTimes即看作局部名称又看作外部名称。下面调用这个方法：
let counter = Counter()
counter.incrementBy(5, numberOfTimes: 3)
// counter value is now 15
你不必为第一个参数值再定义一个外部变量名：因为从函数名incrementBy已经能很清楚地看出它的作用。但是第二个参
数，就要被一个外部参数名称所限定，以便在方法被调用时明确它的作用。
这种默认的行为能够有效的处理方法（method）,类似于在参数numberOfTimes前写一个井号（#）：
func incrementBy(amount: Int, #numberOfTimes: Int) {
count += amount * numberOfTimes
}
这种默认行为使上面代码意味着：在 Swift 中定义方法使用了与 Objective-C 同样的语法风格，并且方法将以自然表达式的方式被调用。
修改方法的外部参数名称(Modifying  External  Parameter  Name  Behavior  for  Methods)
有时为方法的第一个参数提供一个外部参数名称是非常有用的，尽管这不是默认的行为。你可以自己添加一个显式的外部名称或者用一个井号（#）作为第一个参数的前缀来把这个局部名称当作外部名称使用。相反，如果你不想为方法的第二个及后续的参数提供一个外部名称，可以通过使用下划线（_）作为该参数的显式外部名称，这样做将覆盖默认行为。

不推荐将外部名称前加_

override  覆盖父类方法
final   不能被重写


[Inheriting init]只能全部继承或者不继承

required 标示子类必须实现该方法

[Failable init]
init?(arg1: type1, ...) {
//有些初始化方法，允许失败并返回nil
}

let image = UIImage(named: "foo") //image is an Optional UIImage (i.e. UIImage?)
//将名称为foo的图片赋给image，图片不存在时，返回空; 注意这是旧的命名方式

遇到这种情况时，我们会使用let
if let image = UIImage(named: "foo"){
    //image was successfuly created
}else {
    //couldn't create the image
}

[Creating Objects]
- Usually you create an object by calling it's initializer via the type name
let x = CalculatorBrain()
let y = ComplicatedObject(arg1:42, arg2: "hello", ...)
let z = [string]()

But sometimes you create objects by calling type methods in classes ...
let button = UIButton.buttonWithType(UIButtonType.System)   //类方法创建对象

Or obviously sometimes other objects will create objects for you ...
let commaSeparatedArrayElements: String = ",".join(myArray)
//join函数用于拼接字符串；上例中会返回由逗号分隔的字符串

[Any and AnyObject]
Any表示任意的类型，包括class/struct/enum
AnyObject表示任意的class
/// - SeeAlso: `AnyObject`
public typealias AnyClass = AnyObject.Type

AnyObject can represent an instance of any class type.
Any can represent an instance of any type at all, including function types.

// --
for thing in things {
    switch thing {
        
    case 0 as Int:
        print("")
    case 0 as Dounble:
        print("")
    case let someInt as Int:
        print("")
    case let someDouble as Double where someDouble > 0: // 满足where条件
        print("")
    case is Double:
    case let someString as String: 
    case let (x,y) as (Double,Double): // 元组
    case let movie as Movie: // 类
    case let stringConverter as String -> String:// 当值为此func类型时。
        print(stringConverter("Michael"))
    case -1.0...1.0:
        print("区间内")
        fallthrough     // 是的这条case不会自动break，会接着进入下一个case
    case nil:
        print("没有值")
    case "aasda":
    }    
}
注意：switch就是使用了~=操作符进行模式匹配，case指定的模式作为左参数，switch传入的参数作为右参数。所以我们可以通过重载~=操作符来让switch使用我们自定义的~=模式匹配方法。
// --

let a: Any = 5
switch a {
// 两个都能匹配
case let n as Int: 
    print (n + 1)        // 5
    fallthrough
    print (n + 1)        // 这句不会执行
case is UIView:         // case条件不会执行（生效）,因为前一个case含有fallthrough关键字，所以不会检查这个case的条件。不会行本case条件所以条件中包含有let和var将不会执行。编译器不允许fallthrough关键字后面跟着的case条件中含有let和var
    print (a as! Int + 1)       // 5
default: ()
    print("111")
}
注意：当case 中加入 fallthrough 关键字时，不会运行当前case后面的语句而会直接进入下一个case，不会检查下个case的条件是否成立。
也可以使用break 提前跳出case。

// 可以给where设置一个标志，然后可以continue或者break到这个标志（labels）
gameLoop: while true {
  switch state() {
     case .Waiting: continue gameLoop
     case .Done: calculateNextState()
     case .GameOver: break gameLoop
  }
}

var result: String? = secretMethod()
switch result {
case nil:       // 或者 case .None:
    print("is nothing")
case let a?:
    print("\(a) is a value")
}

let uu = NSArray(array: [NSString(string: "String1"), NSNumber(int: 20), NSNumber(int: 40)])
for x in uu {
    switch x {
    case _ as NSString:
        print("string")
    case _ as NSNumber:
        print("number")
    default:
        print("Unknown types")
    }
}

[模式匹配] case关键字
2.0 中模式匹配可以支持for/if/
func nonnil<T>(array: [T?]) -> [T] {
    var result: [T] = []
    for case let x? in array {  // 匹配解包后非nil
        result.append(x)
    }
    return result
}
print(nonnil(["a", nil, "b", "c", nil]))
// --
enum Entity1 {
    enum EntityType {
        case Soldier
        case Player
    }
    case Entry(type: EntityType, x: Int, y: Int, hp: Int)
}
for case let Entity1.Entry(t, x, y, _) in gameEntities()
    where x > 0 && y > 0 {
        drawEntity(t, x, y)
}
// --
func example(a: String?) {
    guard let a = a else { return }
    print(a)
}
example("yes")
// --
let MAX_HP = 100

enum Entity {
    enum EntityType {
        case Soldier
        case Player
    }
    case Entry(type: EntityType, x: Int, y: Int, hp: Int)
}

func healthHP(entity: Entity) -> Int {
    guard case let Entity.Entry(.Player, _, _, hp) = entity // 模式匹配
        where hp < MAX_HP
        else { return 0 }
    return MAX_HP - hp
}

print("Soldier", healthHP(Entity.Entry(type: .Soldier, x: 10, y: 10, hp: 79)))
print("Player", healthHP(Entity.Entry(type: .Player, x: 10, y: 10, hp: 57)))
// --
if case 与 guard case 相反
func move(entity: Entity, xd: Int, yd: Int) -> Entity {
    if case Entity.Entry(let t, let x, let y, let hp) = entity
    where (x + xd) < 1000 &&
        (y + yd) < 1000 {
    return Entity.Entry(type: t, x: (x + xd), y: (y + yd), hp: hp)
    }
    return entity
}
print(move(Entity.Entry(type: .Soldier, x: 10, y: 10, hp: 79), xd: 30, yd: 500))
// 输出: Entry(main.Entity.EntityType.Soldier, 40, 510, 79)
// --

AnyObject   --  Special "Type" (actually it's a Protocol)
- Used primarily for compatibility with existing Objective-C-based APIs

So AnyObjects,means a pointer to an object. Meaning, an instance of a class. That you don't know what the class is. So it's just kind of pointer to unknown class.

Where will you see it?
AS properties (either singularly or as an array of them), e.g. ...
var destinationViewController: AnyObject
var toolbarItems: [AnyObject]

... or as arguments to functions ...
func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject)
func addConstraints(contraints: [AnyObject])
func appendDigit(sender: AnyObject)
//e.g. a UIViewController method prepareForSegue, It takes a normal argument there, segue,(接收一个普通的参数segue) but then it also takes a sender, which can be AnyObject.(但它还接受一个sender参数，这个参数的类型是AnyObject的) 这样将更有道理，因为Sender 确实可以是任意对象。

这里的AnyObject类似于oc中得id类型；我们使用他的唯一方式就是将它转换成已知的那个类型（We don't usually use it directly. Instead, we convert it to another, known type）
We need to create a new variable which is of a known object type.
e.g. var destinationViewController : AnyObject
let calcVC = destinationViewController as CalculatorViewController  //使用 as 进行类型的强制转换，这种方式转换时，如果类型出错就会导致程序奔溃。

//防止程序崩溃，这样来
if let calcVC = destinationViewController as? CalculatorViewController { ... }
//as?与as做了同样的事，不同的是， as? returns an Optional (calcVC = nil if dvc was not a CalculatorViewController)
也可以单纯的检查类型是否已知：
if destinationViewController is CalculatorViewController { ... }
//通常使用as? 做检查并转换，一次搞定

处理包含AnyObject类型的数组时，如下 var toolbarItems: [AnyObject]
for item in toolbarItems {
    if let toolbarItem = item as? UIBarButtonItem {
    //do something with the toolbarItem    
    }
}
 ... or ...
for toolbarItem in toolbarItems as [UIBarButtonItem] {
    //do something with the toolbarItem    
}//这个是将数组整个的转换成对应的类型，所以必须确保数组类型正确，注意这里不能使用 as? , 因为 for toolbarItem in nil 无意义。

使用XIB设置事件出口时，需要强制转换
@IBAction func appendDigit(sender: AnyObject) {
    if let sendingButton = sender as? UIButton {
        let digit = sendingButton.currentTitle!
        ...
    }
}

[Array]
Array 连接器   += [T]   只能是一个Array加上另一个Array
first -> T?     返回第一个元素-
last -> T?      返回最后一个元素-
注意：first 和 last 返回的是optional类型，So, they don't do Array index out of bounds. So, they'll return nil if your Array is empty.
[ddd.d,ss.dfd,fd.sa]
var a = [a,b,c]

append(T)
insert(T, atIndex: Int) //在指定索引插入元素
splice(Array<T>, atIndex: Int) //将指定数组拼接到指定索引 a.splice([d,e], atIndex:1), a = [a,d,e,b,c]
removeAtIndex(Int)
removeRange(Range) //a.removeRange(0..<2), a = [c]
replaceRange(Range, [T]) //a.replaceRange(0...1, with: [x,y,z]), a = [x,y,z,b]
sort(isOrderedBefore: (T, T) -> Bool) //a.sort { $0 < $1}
sorted  //返回已排好序的数组的拷贝

filter(includeElement: (T) -> Bool) -> (T) //返回过滤后的新数组，指定参数，可用函数表示，返回BOOL值来表明这个元素是不是想要的。

//一行代码就可将数组映射成不同类型的数组
map(transform: (T) -> U) -> [U]
let stringified: [String] = [1,2,3].map { "\($0)" }//将一个Int行得数组映射到它们的字符串形式

//使用Reduce可以将整个数组缩减到一个值
reduce(initial: U, combine: (U, T) -> U) -> U
let sum: Int = [1,2,3].reduce(0) { $0 + $1 } //初始值为0 返回前一个加后一个。
//这个方法接受一个参数，这个参数是你自定的初始值，还有一个函数作为参数，这个函数传入当前的值和下一个Array中得元素，你只需要返回他们两者的组合是什么。就这样一直组合、组合、组合，直到得到最终的结果。
//So this one takes an argument which is the initial value you want to start with. And then it just takes a function that takes the value so far and the next element in the Array and you return what the combination is. So you're just combining, combining, comgining

// In Swift 2, reduce has been removed as a global function and has been added as an instance method on all objects that conform to the SequenceType protocol via a protocol extension. Usage is as follows.

[String]

字符串可以通过加法运算符( + )相加在一起(或称“连接”)创建一个新的字符串
也可以通过加法赋值运算符 ( += ) 将一个字符串添加到一个已经存在字符串变量上
用 append 方法将一个字符附加到一个字符串变量的尾部

注意:不能将一个字符串或者字符添加到一个已经存在的字符变量上,因为字符变量只能包含一个字符。

字符串插值 (String Interpolation)
字符串插值是一种构建新字符串的方式,可以在其中包含常量、变量、字面量和表达式。 您插入的字符串字面量 的每一项都在以反斜线为前缀的圆括号中
let multiplier = 3
let message = "\(multiplier) times 2.5 is \(Double(multiplier) * 2.5)" 
// message 是 "3 times 2.5 is 7.5"

注意:插值字符串中写在括号中的表达式不能包含非转义双引号 ( " ) 和反斜杠 ( \￼ ),并且不能包含回车或换行符。

计算字符数量 (Counting Characters): 全局函数 count( )
let unusualMenagerie = "Koala ?, Snail ?, Penguin ?, Dromedary ?" println("unusualMenagerie has \(count(unusualMenagerie)) characters") // 打印输出:"unusualMenagerie has 40 characters"

需要注意的是通过 count(_:) 返回的字符数量并不总是与包含相同字符的 NSString 的 length 属性相 同。 NSString 的 length 属性是利用 UTF-16 表示的十六位代码单元数字,而不是 Unicode 可扩展的字符群 集。作为佐证,当一个 NSString 的 length 属性被一个Swift的 String 值访问时,实际上是调用了 utf16Coun t。

String.Index
-In Unicode, a given glyph might be represented by mutiple Unicode characters (accents, etc.)
-As a result, you can't index a String by Int (because it's a collection of characters, not glyphs)

starIndex   //获取String首字母
String.Index.advancedBy(Int) //全局函数，参数告诉这个函数你想向后推进多少次，然后会返回一个新的索引位置
var s = "hello"
let index = advance(s.startIndex,2) //index is a String.Index to the 3rd glyph, "l", index是String.Index类型
s.splice("abc", index)  //It will splice a String into the middle of another String. s will now be "heabcllo"

let startIndex = advance(s.startIndex, 1)
let endIndex = advance(s.startIndex, 6)
let substring = s[index..<endIndex] //substring will be "eabcl"， 字符串可以使用方括号来创建子串。

s.characters.indices    -----    0..<12

var straa = "aaaiaaaaaaaa"
straa.startIndex
straa.endIndex
straa.endIndex.predecessor()//得到前一个索引
straa.startIndex.successor()//得到后一个索引
straa.advancedBy(3) // i
var index:Int = 4
straa.insert("!", atIndex: straa.endIndex)
straa.insertContentsOf("there".characters, at:straa.endIndex)
straa.removeAtIndex(3)
straa.characters.indices // 使用characters属性的indices属性会创建一个包含全部索引的范围(Range)
let range = straa.endIndex.advancedBy(-6)..<straa.endIndex
straa.removeRange(range)
字符串/字符可以用等于操作符(==)和不等于操作符(!=)


rangeOfString returns an Optional Range<String.Index>
As an example, to get whole number part of a string representing a double ...
let num = "56.25"
if let decimalRange = num.rangeOfString(".")
    let wholeNumberPart = num[num.startIndex..<decimalRange.startIndex]
}
s.removeRange([s.startIndex..<decimalRange.startIndex])
replaceRange(Range, String)

let ranges = levels.startIndex.advancedBy(2) ..< levels.startIndex.advancedBy(6)
levels.stringByReplacingCharactersInRange(swiftRange, withString: "AAAA")
// --当String用于需要Range的方法时，也可以转成NSString来调用：
let levels = "ABCDE"
let nsRange = NSMakeRange(1, 4)
(levels as NSString).stringByReplacingCharactersInRange(nsRange, withString: "AAAA")
(levels as NSString).substringWithRange(NSMakeRange(1, 4))

description -> String   //Printable
endIndex -> String.Index
hasPrefix(String) -> Bool
hasSuffix(String) -> Bool
toInt() -> Int? //在字符串中只有toInt，没有toDouble. toInt()返回的时optional类型，例如对“hello”时，会返回nil
capitalizedString -> String
lowercaseString -> String
uppercaseString -> String
join(Array) -> String  //",".join(["1","1","1"]) = "1,1,1"
componentsSeparatedByString(String) -> [String] //以指定字符串将待处理的字符串分割为数组形式 "1,2,3".csbs(",") = ["1","2","3"]

let d: Double = 37.5
let f:Float = 37.5
let x = Int(d)  //truncates截断
let xd = Double(x)
let cgf = CGFloat(d)
浮点数取余： 8 % 2.5 // 等于 0.5

字符串和数组可以通过初始化方法完成相互转化
let a = Array("abc")    //a = ["a","b","c"], i.e. array of Character
let s = String(["a","b","c"])   //s = "abc" (the array is of Character, not String)

let arr = [Int]()
+ 拼接数组
var anotherThreeDoubles = Array(count: 3, repeatedValue: 2.5)
// anotherThreeDoubles 被推断为 [Double]，等价于 [2.5, 2.5, 2.5]
var sixDoubles = threeDoubles + anotherThreeDoubles
// sixDoubles 被推断为 [Double]，等价于 [0.0, 0.0, 0.0, 2.5, 2.5, 2.5]
var anotherThreeDoubles = Array(count: 3, repeatedValue: 2.5)
// anotherThreeDoubles 被推断为 [Double]，等价于 [2.5, 2.5, 2.5]
var sixDoubles = threeDoubles + anotherThreeDoubles
// sixDoubles 被推断为 [Double]，等价于 [0.0, 0.0, 0.0, 2.5, 2.5, 2.5]

由于 Swift 的类型推断机制，当我们用字面量构造只拥有相同类型值数组的时候，我们不必把数组的类型定义清楚。
var shoppingList = ["Eggs", "Milk"]
因为所有字面量中的值都是相同的类型，Swift 可以推断出[String]是shoppinglist中变量的正确类型。
等价于   var shoppingList : [String] = ["Eggs", "Milk"]

下面的例子把"Chocolate Spread"，"Cheese"，和"Butter"替换为"Bananas"和 "Apples"：
shoppingList[4...6] = ["Bananas", "Apples"]

let apples = shoppingList.removeLast()// remove last


let s = String(52) //不能调用String(37.5)来讲浮点数转成字符串但可以通过下面的方法实现
let s = "\(37.5)"      //通过这个方法和toInt()可以实现字符串和浮点数之间的相互转换。
在引号用加入\(表达式)，即"\(表达式)"，这种形式会自动对表达式求值并转换为字符串形式。

for (index, value) in shoppingList.enumerate() {
    print("Item \(String(index + 1)): \(value)")
}
// Item 1: Six eggs
// Item 2: Milk
// Item 3: Flour
// Item 4: Baking Powder
// Item 5: Bananas

var namesOfIntegers = [Int: String]()
// namesOfIntegers 是一个空的 [Int: String] 字典

if let oldValue = airports.updateValue("Dublin Airport", forKey: "DUB") {
    print("The old value for DUB was \(oldValue).")
}
// 输出 "The old value for DUB was Dublin." 返回更新值前的原值，可以用来判断更新是否成功。

removeValueForKey(_:)方法也可以用来在字典中移除键值对。这个方法在键值对存在的情况下会移除该键值对并且返回被移除的值或者在没有值的情况下返回nil

if #available(iOS 9, OSX 10.10, *) {
    // 在 iOS 使用 iOS 9 的 API, 在 OS X 使用 OS X v10.10 的 API
} else {
    // 使用先前版本的 iOS 和 OS X 的 API
}

//获取"/"分隔的字符串的最后一部分
public var lastPathComponent: String { get }

//-----------
public class func pathWithComponents(components: [String]) -> String
    public var pathComponents: [String] { get }
    
    public var absolutePath: Bool { get }
    
    public var lastPathComponent: String { get }
    public var stringByDeletingLastPathComponent: String { get }
    public func stringByAppendingPathComponent(str: String) -> String
    
    public var pathExtension: String { get }
    public var stringByDeletingPathExtension: String { get }
    public func stringByAppendingPathExtension(str: String) -> String?
    
    public var stringByAbbreviatingWithTildeInPath: String { get }
    public var stringByExpandingTildeInPath: String { get }
    
    public var stringByStandardizingPath: String { get }
    
    public var stringByResolvingSymlinksInPath: String { get }
    
    public func stringsByAppendingPaths(paths: [String]) -> [String]
    
    public func completePathIntoString(outputName: AutoreleasingUnsafeMutablePointer<NSString?>, caseSensitive flag: Bool, matchesIntoArray outputArray: AutoreleasingUnsafeMutablePointer<NSArray?>, filterTypes: [String]?) -> Int
    
    public var fileSystemRepresentation: UnsafePointer<Int8> { get }
    public func getFileSystemRepresentation(cname: UnsafeMutablePointer<Int8>, maxLength max: Int) -> Bool
//-----------

断言
Debugging Aid
Intentionally crash your program if some condition is not true (and give a message)
assert(() -> Bool, "message")   //They basically take a closure as the first argument.(接收一个闭包作为第一个参数)
如果第一个参数的值不为真，第二个参数的字符串将会在控制台输出。条件应该是成立的，不成立将会导致程序崩溃
e.g. assert(validation() != nil, "the validation function returned nil") //Will crash if validation() returns nil

Function that work on Array, Dictionary, String
Collections include Array, Dictionary, String
Sliceables include Array and String

let count = countElements(aCollection) //
let sub = dropFirst(aSliceable)
let sub = dropLast(aSliceable)
let first = first(aSliceable)
let last = last(aSliceable)
let prefix = prefix(aSliceable, X: Int)
let suffix = suffix(aSliceable, X: Int)
let reversed: Array = reverse(aCollection)//返回反转（逆序）
let backwardsString = String(reverse(s))//通过逆序并新建

[guard]
guard语句和if语句有点类似，都是根据其关键字之后的表达式的布尔值决定下一步执行什么。但与if语句不同的是，guard语句只会有一个代码块，不像if语句可以if else多个代码块。
func checkup(person: [String: String!]) {
   
    // 检查身份证，如果身份证没带，则不能进入考场
    guard let id = person["id"] else {
        print("没有身份证，不能进入考场!")
        return
    }
    print("\(id)")    
    }
}
guard中定义的常量id可在整个方法的作用域中使用，并且是解包后的。

[附属脚本]
附属脚本可以定义在 class/struct/enum 中，可以认为是访问对象、集合、序列的快捷方式，不需要调用实例的特定的赋值和访问方法。
对于同一个目标可以定义多个附属脚本，通过索引值类型的不同来进行重载，而且索引值可以是多个。
与实例方法不同的是，附属脚本可以设定读写或只读。
subscript(index: Int) -> Int {
  get {
    // 返回
  }
  set(newValue) {
    // newVale的类型必须和附属脚本定义的返回类型相同。这里的newValue就算不写，在set代码中依然可以直接使用默认的newValue变量来访问新值。
  }
}

subscript(index: Int) -> Int {
  // 返回与入参匹配的Int类型的值
}

private subscript(index index: Int) -> JSON {
  get {
    if self.type != .Array {
      var r = JSON.null
      r._error = self._error ?? NSError(domain: ErrorDomain, code: ErrorWrongType, userInfo: [NSLocalizedDescriptionKey: "Array[\(index)] failure, It is not an array"])
      return r
    } else if index >= 0 && index < self.rawArray.count { 
      return JSON(self.rawArray[index])
    } else {
      var r = JSON.null
      r._error = NSError(domain: ErrorDomain, code:ErrorIndexOutOfBounds , userInfo: [NSLocalizedDescriptionKey: "Array[\(index)] is out of bounds"])
      return r
     }
  }
  set {
    if self.type == .Array {
      if self.rawArray.count > index && newValue.error == nil {
        self.rawArray[index] = newValue.object
      }
    }
  }
}

通过 `.dynamicType` 来获取一个对象的动态类型，也就是运行时的实际类型，而非编译时指定的类型。
let string = "Hello"
let name = string.dynamicType
println(name)
// 输出：
// Swift.String
注意：1. 在Swift中，我们虽然可以通过denamicType来获取一个对象的动态类型，但使用中，Swift现在不能根据对象在动态时的类型进行合适的重载方法调用。
2. 调用方法时，swift会根据形参的类型来决定调用哪个方法，而不会根据实参的类型来调用对应的方法。因为Swift默认是不采用动态派发的，所以方法的调用只能在编译时决定。当需要绕过这个限制时，则需要对形参的类型进行判断和转换（解包）。
func printThemAgain(pet: Pet, _ cat: Cat) {
    if let aCat = pet as? Cat {
        printPet(aCat)
    } else if let aDog = pet as? Dog {
        printPet(aDog)
    }
    printPet(cat)
}
printThemAgain(Dog(), Cat())
// 输出：
// Bark
// Meow

.Type 表示的是某个类型的元类型，而在 Swift 中，除了 `class`，`struct` 和 `enum` 这三个类型外，我们还可以定义 `protocol`。

对于 `protocol` 来说，有时候我们也会想取得接口的元类型。这时我们可以在某个 `protocol` 的名字后面使用 .Protocol 来获取，使用的方法和 .Type 是类似的。


class MyClass: Copyable {
    var num = 1
    func copy() -> Self {
        let result = self.dynamicType()
        result.num = num
        return result
    }
    required init() {

    }
}

Swift 的编程思想：将for循环和if-let搬走，替换成map和flatmap。


do {
    if let url = NSURL(string: "YOU URL HERE"),
        let data = NSData(contentsOfURL: url),
        let jsonResult = try NSJSONSerialization.JSONObjectWithData(data, options: []) as? [[String:AnyObject]] {
        print(jsonResult)
        let longitudeArray = jsonResult.flatMap { $0["longitude"] as? String }
        let latitudeArray = jsonResult.flatMap { $0["latitude"] as? String }
        print(longitudeArray)
        print(latitudeArray)
    }
} catch let error as NSError {
    print(error.description)
}
// --
let fileterArr = myStructs.flatMap{
    $0 as? TypeA
}
--等效于
extension Array {
    func objectsOfType<T>(type:T.Type) -> [T] {
        return flatMap { $0 as? T }
    }
}
let filteredArray1 = myStructs.objectsOfType(TypeA.self)
// --
weak and unowned
unowned 更像以前的 unsafe_unretained，而 weak 就是以前的 weak
unowned 设置以后即使它原来引用的内容已经被释放了，它仍然会保持对被已经释放了的对象的一个 "无效的" 引用，它不能是 Optional 值，也不会被指向 nil。
被标记为 @weak 的变量一定需要是 Optional 值
关于两者使用的选择，Apple 给我们的建议是如果能够确定在访问时不会已被释放的话，尽量使用 unowned，如果存在被释放的可能，那就选择用 weak。

[defer]
defer {
    print("1111")
}
defer会在其所在的块作用域结束之前运行，return执行之后执行。
多个defer语句会依序压入专属于块的堆栈中，运行时pop出执行。

// swift 怎么判断是否为Bool值







// 泛型 ： 只需要保证一个函数的输出类型，与另一个函数的输入类型匹配即可。
func funcBuild<T, U, V>(f: T -> U, _ g: V -> T)
    -> V -> U {
        return {
            f(g($0))
        }
}
let f3 = funcBuild({ "No." + String($0) }, {$0 * 2})
f3(23) // 结果是 "No.46"





