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
Swift ��һ�ָ�Ч��ϵͳ������ԣ�����������֧���ִ��﷨���ṩ��C�Լ�OC��ܵ��޷����ӣ������ڴ氲ȫ�ġ�
Swift��Ȼ���ܵ�OC�������ܶ����Ե����������䲢����Cϵͳ�����ԡ���Ϊһ����ȫ��ȫ���������ԣ�Swiftӵ�к��ĵ������������ƣ����ݽṹ����������objects, protocols, closures, and generics ����Э�飬��װ�����͡�Swift������ģ�飬����Ҫ����ͷ�ļ���

// ע��
Swift �Ķ���ע�Ϳ���Ƕ���������Ķ���ע��֮�С������������һ������ע�Ϳ飬Ȼ�������ע�Ϳ�֮����Ƕ�׳ɵڶ�������ע�͡���ֹע��ʱ�Ȳ���ڶ���ע�Ϳ����ֹ��ǣ�Ȼ���ٲ����һ��ע�Ϳ����ֹ��ǣ�

/* ���ǵ�һ������ע�͵Ŀ�ͷ
/* ���ǵڶ�����Ƕ�׵Ķ���ע�� */
���ǵ�һ������ע�͵Ľ�β */

ͨ������Ƕ�׶���ע�ͣ�����Կ��ٷ����ע�͵�һ��δ��룬��ʹ��δ���֮���Ѿ������˶���ע�Ϳ顣

Swift �ṩ��8��16��32��64λ���з��ź��޷����������͡�UInt8,UInt16

let minValue = UInt8.min  // minValue Ϊ 0���� UInt8 ����
let maxValue = UInt8.max  // maxValue Ϊ 255���� UInt8 ����


��32λƽ̨�ϣ�Int��Int32������ͬ��
��64λƽ̨�ϣ�Int��Int64������ͬ��

��32λƽ̨�ϣ�UInt��UInt32������ͬ��
��64λƽ̨�ϣ�UInt��UInt64������ͬ��


Double��ʾ64λ��������������Ҫ�洢�ܴ���ߺܸ߾��ȵĸ�����ʱ��ʹ�ô����͡�
Float��ʾ32λ������������Ҫ�󲻸ߵĻ�����ʹ�ô����͡�

let meaningOfLife = 42
// meaningOfLife �ᱻ�Ʋ�Ϊ Int ����

let pi = 3.14159
// pi �ᱻ�Ʋ�Ϊ Double ����

���ƶϸ�����������ʱ��Swift ���ǻ�ѡ��Double������Float��

������ʽ��ͬʱ�����������͸��������ᱻ�ƶ�ΪDouble���ͣ�

let anotherPi = 3 + 0.14159
// anotherPi �ᱻ�Ʋ�Ϊ Double ����

let decimalInteger = 17
let binaryInteger = 0b10001       // �����Ƶ�17
let octalInteger = 0o21           // �˽��Ƶ�17
let hexadecimalInteger = 0x11     // ʮ�����Ƶ�17

���һ��ʮ��������ָ��Ϊexp����������൱�ڻ�����10^exp�ĳ˻���

1.25e2 ��ʾ 1.25 �� 10^2������ 125.0��
1.25e-2 ��ʾ 1.25 �� 10^-2������ 0.0125��

���һ��ʮ����������ָ��Ϊexp����������൱�ڻ�����2^exp�ĳ˻���

0xFp2 ��ʾ 15 �� 2^2������ 60.0��
0xFp-2 ��ʾ 15 �� 2^-2������ 3.75��

��ֵ�����������԰�������ĸ�ʽ����ǿ�ɶ��ԡ������͸�������������Ӷ�����㲢�Ұ����»��ߣ�������Ӱ����������

let paddedDouble = 000123.456
let oneMillion = 1_000_000
let justOverOneMillion = 1_000_000.000_000_1

typealias AudioSample = UInt16

������һ�����ͱ���֮����������κ�ʹ��ԭʼ���ĵط�ʹ�ñ�����

var maxAmplitudeFound = AudioSample.min
// maxAmplitudeFound ������ 0

�����ֻ��Ҫһ����Ԫ��ֵ���ֽ��ʱ����԰�Ҫ���ԵĲ������»��ߣ�_����ǣ�

let (justTheStatusCode, _) = http404Error
print("The status code is \(justTheStatusCode)")
// ��� "The status code is 404"

���⣬�㻹����ͨ���±�������Ԫ���еĵ���Ԫ�أ��±���㿪ʼ��

print("The status code is \(http404Error.0)")
// ��� "The status code is 404"
print("The status message is \(http404Error.1)")
// ��� "The status message is Not Found"

if let firstNumber = Int("4"), secondNumber = Int("42") where firstNumber < secondNumber {
    print("\(firstNumber) < \(secondNumber)")
}
// prints "4 < 42"

�� Swift ������ԶԸ���������ȡ�����㣨%����Swift ���ṩ�� C ����û�еı������֮���ֵ�������������a..<b��a...b�����ⷽ�����Ǳ��һ�������ڵ���ֵ��

8 % 2.5   // ���� 0.5

"hello, " + "world"  // ���� "hello, world"

let three = 3
let minusThree = -three       // minusThree ���� -3

һԪ���ţ�+�������κθı�ط��ز�������ֵ��
let minusSix = -6
let alsoMinusSix = +minusSix  // alsoMinusSix ���� -6

�պ������(a ?? b)���Կ�ѡ����a���п��жϣ����a����һ��ֵ�ͽ��н�⣬����ͷ���һ��Ĭ��ֵb.������������������:

���ʽa������Optional����
Ĭ��ֵb�����ͱ���Ҫ��a�洢ֵ�����ͱ���һ��

ע�⣺ ���aΪ�ǿ�ֵ(non-nil),��ôֵb�����ᱻ��ֵ����Ҳ������ν�Ķ�·��ֵ��

for index in 1...5 {// �����������
    print("\(index) * 5 = \(index * 5)")
}
// 1 * 5 = 5
// 2 * 5 = 10
// 3 * 5 = 15
// 4 * 5 = 20
// 5 * 5 = 25

let names = ["Anna", "Alex", "Brian", "Jack"]
let count = names.count
for i in 0..<count {// �뿪����
    print("�� \(i + 1) ���˽� \(names[i])")
}
// �� 1 ���˽� Anna
// �� 2 ���˽� Alex
// �� 3 ���˽� Brian
// �� 4 ���˽� Jack

������ͨ�������Bool���͵�isEmpty�������жϸ��ַ����Ƿ�Ϊ�գ�
if emptyString.isEmpty {
    print("Nothing to see here")
}
// ��ӡ�����"Nothing to see here"

let multiplier = 3
let message = "\(multiplier) times 2.5 is \(Double(multiplier) * 2.5)"
// message is "3 times 2.5 is 7.5"

let wiseWords = "\"Imagination is more important than knowledge\" - Einstein"
// "Imageination is more important than knowledge" - Enistein
let dollarSign = "\u{24}"             // $, Unicode ���� U+0024
let blackHeart = "\u{2665}"           // �7�3, Unicode ���� U+2665
let sparklingHeart = "\u{1F496}"      // �9�4, Unicode ���� U+1F496

ע��:ͨ��characters���Է��ص��ַ��������������������ͬ�ַ���NSString��length������ͬ��NSString��length���������� UTF-16 ��ʾ��ʮ��λ���뵥Ԫ���֣������� Unicode ����չ���ַ�Ⱥ������Ϊ��֤����һ��NSString��length���Ա�һ��Swift��Stringֵ����ʱ��ʵ�����ǵ�����utf16Count��


[assert]
assert(celsius > absoluteZeroInCelsius, "����������¶Ȳ��ܵ��ھ������")
����������ʱ����������󣬱�����ջ�����׳�Ԥ�����Ϣ��Ĭ������£�ֻ��Debug����ʱ��Ч������ʱ��������ִ�С�
�ı�Ĭ�����п�����ӱ����ǣ���������Ķ�
target-Build Setting�� Swift Compiler - Custom Flags �е�Other Swift Flags�����-assert-config Debug��ǿ�����ö��ԣ�����-assert-config Release��ǿ�ƽ��ö���.
ע�⣺���������Ҫ��Release����ʱ���޷�����ʱ������ǿ����ֹ�Ļ���Ӧ�ÿ���ʹ����������fatalError�ķ�ʽ����ֹ����

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
ע�⣺�쳣ֻ��һ��ͬ������ר�õĴ�����ƣ�Cocoa���������첽API����ʱ��������ԭ����NSError���ơ�
Swift2.0ʱ���Ĵ�����һ������ʵ���ǣ�����ͬ��APIʹ���쳣���ƣ������첽APIʹ�÷���ö�١�
try! ��ʾȷ�������׳��쳣����������г����쳣�ᵼ�³��������
try? û���쳣�򷵻�Optionalֵ�����쳣�򷵻�nil������ζ�������˴���ľ������ͺͺ��塣
��throws��һ��throwsʱ��Ӧ�ý�ǰ���throws��Ϊrethrows��


[�Զ��� description]
����Ҫ�Զ����������и�ʽ��ʱ�����ǿ���ͨ��ʵ��CustomStringConvertible�ӿ�������һ�������á�
extension User : CustomStringConvertible {
    var description: String {
        return "\(self.age)and\(self.weight)and\(self.height)"
    }
}
ʵ��CustomDebugStringConvertible�ӿ���������debuggerʱ������po����������
public protocol CustomDebugStringConvertible {
    /// A textual representation of `self`, suitable for debugging.
    public var debugDescription: String { get }
}


[swift2 �б���----��������������]
// [arc4random and arc4random_uniform]
//swift��ʹ��arc4randomʱÿ�ζ��᷵��һ��UInt32��ֵ����ΪiPhone5�������豸��32λ�ģ�����һ��ļ��ʻ�������������
//��ȫ��������arc4random_uniform



[swiftc]swift�ǳ�����˼�������й���
����ʹ��swiftʵ��һЩ�����г���
swift --help        swiftc --help
// --hellp.swift
#!/usr/bin/env swift
print("hello")
// --
chmod 755 hello.swift
./hello.swift   // ֱ�����ն�����

swiftc -O hello.swift -o hello.asm  // ����asm������



[Unmanaged]
public func performSelector(aSelector: Selector) -> Unmanaged<AnyObject>!
public func retain() -> Unmanaged<Instance>
public func release()
public func autorelease() -> Unmanaged<Instance>
��OC��ARC�����ֻ��NSObject���Զ����ü�������˶���CF��Core Foundation�������޷������ڴ�����������ڰѶ�����NS��CF֮�����ת��ʱ����Ҫ�������˵���Ƿ���Ҫת���ڴ�Ĺ���Ȩ�����ڲ��漰�ڴ����ת��ʱ��OC��ֱ���ڱ���ǰ����__bridge������˵������ʾ�ڴ����Ȩ���䡣����CFϵ��API�����API�����к���Create, Copy, Retain�Ļ�����ʹ����ɺ���Ҫ����CFRelease�����ͷš�
����ϵͳ��CF API��˵��swift�Ѿ������������RAC�Ĺ���Χ����������ƽʱ�ǲ���Ҫ���ж��⴦��ġ�
������Ҫ���м�������Ķ����ǣ�swift�᷵��Unmanaged����Ȼ��������Ҫʹ��takeUnretainedValue����takeRetainedValue����ȡ��CF����ת������Ҫ�����͡�
takeUnretainedValue������ԭ�������ü������䣬������Ҫ�Լ�ȥ�ͷ�ԭ�����ڴ�ʱʹ�á�
takeRetainedValue����������ü�����һ��ʹ�������Ҫ��ԭ����Unmanaged��������ֶ��ͷš�UnmanagedΪ�����ṩ��retain/release/autorelease���������ü�����

[Assiciated Objec]
// -- switf ��ʵ��extension���������
class MyClass {
}

// MyClassExtension.swift
private var key0: Void?
private var key1: Void?

//public func objc_getAssociatedObject(object: AnyObject!, _ key: UnsafePointer<Void>) -> AnyObject!
//public func objc_setAssociatedObject(object: AnyObject!, _ key: UnsafePointer<Void>, _ value: AnyObject!, _ policy: objc_AssociationPolicy)

// extension�в�����Ӵ洢����(willSet/didSet)��ֻ����Ӽ������ԣ�ʵ�� get ���� get/set��������������ʱ

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
Swift�е�protocol���Զ�������֧�֣��� class, struct, enum������struct��enum����Ϊ�ӿ�ʵ�֣�����class��ʱ��������Ϊ�ӿ���ʹ���⣬��������Ϊί��-����ĳ���ģʽ��
����ί��-����ʱ��protocol������������Ϊ@objo����class���ͣ����£�
@objc protocol MyClassDelegate { }
protocol MyClassDelegate: class {}  // ���ָ��ã�ȥ����oc���ݱ�־
������ָ����MyClassDelegateֻ����classʵ��

[sizeof / sizeofVale]
��swift��ͨ���������鳤��������NSDataת��ʱ����Ҫ�����������鳤�ȣ�sizeof(CChar) * bytes.count��ֱ��ʹ��sizeof��sizeofValue�Լ�strideof��strideofValue�����пӣ�------��������������������
var bytes: [CChar] = [1,2,3]
let data = NSData(bytes: &bytes, length:sizeof(CChar) * bytes.count)
sizeofValue(bytes)      // 8
sizeof(bytes.dynamicType)       // 8
sizeof(CChar) * bytes.count     // 3 
sizeof(Int)     // 8
sizeof(UInt16)     // 2
strideofValue(bytes)        // 8
?? ���ص�8Ϊ64λϵͳ�ϵ�һ�����õĳ��ȡ�
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
����Swift�е���C����ʱ��һ�ַ�ʽ�ǽ���bridge�ļ�������ͷ�ļ���
��һ�ַ�ʽ����@asmname�����ַ�ʽҲ����������������C������ϵͳ������ʱ��
//-- File.swift
// ��C �� test����ӳ��ΪSwift�е�c_test����
@asmname("test") func c_test(a: Int32) -> Int32
func testSwift(inputL Int32) {
    let result = c_test(input)
    print(result)
}
testSwift(1)    // 2
// --

[��ʽ�����]
��������Ҫ�������%.2f���ָ�ʽʱ��swift����Ҫ��ת��
let aa = 1.23456
print(String(format: "%.2f", aa))

extension Double {
    func format(f:String) -> String {
        return String(format: "%\(f)f", self)
    }
}
print(aa.format(".2"))

[��������]
#if <condition>
#elseif <condition>
#else
#endif
swift�����˼���condition����Сд����
os()        OSX,iOS
arch()      x86_64,arm,arm64,i386
�Զ������
��Ҫ���Զ���ķ��ż���Build Setting �С�

[�෽����ʵ������]
class MyClass1 {
    func method(number: Int) -> Int {
        return number + 1
    }
    
    class func method(number: Int) -> Int {
        return number
    }
}
let f1 = MyClass1.method    // ��ֱ�ӵ����෽��
f1(4)
// class func method �İ汾
let f2: Int -> Int = MyClass1.method
// �� f1 ��ͬ

let f3: MyClass1 -> Int -> Int = MyClass1.method 
ע�⣺��ͬһ�����У�����ʵ���������෽������ʱ����f1һ����Ĭ��ȡ�������෽���������ڱ���ǰ������������ȡʵ��������

[Selector]�����swiftд�����Ǽ̳���NSObject�ģ�swift���Զ�Ϊ���з�private��ǰ�����@objcǰ׺���������Ҫ��oc�е���private����������Ҫ����ǰ�����@objc��
ͨ��Selector���ɷ���ʱ����Ҫ�ڷ���ǰ����@objcǰ׺������Ҫ���ɵķ�����һ���������ⲿ����ʱ�����չ���Ҫ�ڷ������͵�һ���ⲿ����֮�����with:
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
ע�⣺������������������ʱ������ʧ�ܣ���������������Ҫ��������������ʱ�ĵ��÷���
// let four: Selector = "dMethodWithStr:str0:"
// let dd = aaa.performSelector(four, withObject: s, withObject: ss)
// --
[]
let squares = Array((1...10).map{ $0 * $0 })    // 1��10��ƽ��������
let sum = squares.reduce(0, combine: { $0 + $1 })   // ���


[where]
public func !=<T : RawRepresentable where T.RawValue : Equatable>(lhs: T, rhs: T) -> Bool
Լ������!=��������Ĳ����Ĺ���Ϊ����T.RawValue����Equatable�������£�TҲ��������RawRepresentableЭ�飻�������ܹ���֤�ܹ��ж���������RawRepresentableֵ�Ƿ���ȡ�

��Щʱ�����ǻ�ϣ��һ���ӿڵ�Ĭ��ʵ��ֻ��ĳЩ�ض����������á�
extension MutableCollectionType where Self.Generator.Element : Comparable {
    @warn_unused_result(mutable_variant="sortInPlace")
    public func sort() -> [Self.Generator.Element]
}

������
1. let sortableArray: [Int] = [3,1,2,4,5]
sortableArray.sort()
��ΪInt����Ĭ��ʵ����Comparable�ӿڣ����Կ��Ե���Ĭ�ϵ�sort��������
public struct Int : SignedIntegerType, Comparable, Equatable {

2. let unsortableArray: [AnyObject?] = ["Hello", 4, nil]
��ΪAnyObjectû��ʵ��Comparable�ӿڣ����Բ��ܵ���Ĭ�ϵ�sort��������ֻ��ʹ���Զ�����д��sort
public protocol AnyObject {
//unsortableArray.sort()


[protocol extension]����swift��ǿ�������ԡ�OC�������õļ̳���ʵ��requested��optional�ģ��Լ�ûʵ������ø���ġ�
���ȣ��ӿ���չ����ʵ���ṩ�˽ӿ��й涨�ķ�����Ĭ��ʵ�֣�ʹ�ýӿ��й涨�ķ��������Ǳ���ʵ�ֵġ��ο�tableView
�ӿ���չ��OC�еļ̳п���һ�Ƚϣ�OC��ͨ������ʵ�ֽӿڣ�����ѡ���Ե�ʵ�ַ�����ʵ��--��ѡ������Ĭ��ʵ����һ���ܡ�
��������ƶϵõ�����ʵ�ʵ����ͣ���ô�����е�ʵ�ֽ������ã����������û��ʵ�ֵĻ����ӿ���չ�е�Ĭ��ʵ�ֽ���ʹ�á�����������£��������û��ʵ�֣����ӿ���չ�����Ҳ���ʱ���ᱨ��û��ʵ�ֽӿڵĴ���
��������ƶϵõ����ǽӿڶ�����ʵ�����ͣ�1. (1)���ҷ����ڽӿ��н����˶��壬��ô�����е�ʵ�ֽ������ã�(2)���������û��ʵ�֣���ô�ӿ���չ�е�Ĭ��ʵ�ֱ�����(������@objc����protocolʱ���ڶ����������û��ʵ����ᱨ��Execution was interrupted,reson:signal SIGABRT. Ҳ����˵��ocЭ��û����չ��һ˵�������������Ҳ���ʵ�־ͱ����ˣ�ȥ��@objc�ͺ�swift����һ���ˣ���ʹ���Ǽ̳���OC�ģ���NSObject��)��2. ����÷����ڽӿ���û�ж��壬��չ�е�Ĭ��ʵ�ֽ������ã�������ȥ����ʵ��������ʵ�ֵ��Ǹ����������ڶ�������£��ӿ��ڵ�������δ����ķ���ʱ���ᰵʾ�����������չ��ʵ���ˣ����û��ʵ�֣�������Value of type '�ӿ�����' has no member '���func'�Ĵ���




[Optional]
public enum Optional<Wrapped> : _Reflectable, NilLiteralConvertible {
    case None
    case Some(Wrapped)
    ...
}

var aNil: String = nil
var anotherNil: String?? = aNil
var literalNil: String?? = nil

fr v -R ��ӡ����δ�ӹ�������Ϣ
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


[������ʽ]
.   ƥ������з�����������ַ�
\w  ƥ����ĸ�����ֻ��»��߻���
\s  ƥ������Ŀհ׷�
\d  ƥ������
\b  ƥ�䵥�ʵĿ�ʼ�����
^   ƥ���ַ����Ŀ�ʼ��һ�������ף�
$   ƥ���ַ����Ľ�����һ������β��
+   һ�λ�����
*   ���������������0��
?   ��λ�һ��
{n} ƥ�� n ��
{n,}    ƥ�� n �λ�����
{n��m} �ظ����������� n �Σ������� m ��
[aeiou]��ƥ���κ�һ��Ӣ��Ԫ����ĸ��[.?!]ƥ�������(.��?��!)
[0-9]����ĺ�����\d������ȫһ�µģ�һλ���֣�ͬ��[a-z0-9A-Z_]Ҳ��ȫ��ͬ��\w�����ֻ����Ӣ�ĵĻ���

\W  ƥ�����ⲻ����ĸ�����֣��»��ߣ����ֵ��ַ�
\S  ƥ�����ⲻ�ǿհ׷����ַ�
\D  ƥ����������ֵ��ַ�
\B  ƥ�䲻�ǵ��ʿ�ͷ�������λ��
[^x]    ƥ�����x����������ַ�
[^aeiou]    ƥ�����aeiou�⼸����ĸ����������ַ�

����
\b(\w+)\b\s+\1\b��������ƥ���ظ��ĵ��ʣ���go go, ����kitty kitty��������ʽ������һ�����ʣ�Ҳ���ǵ��ʿ�ʼ���ͽ�����֮��Ķ���һ������ĸ������(\b(\w+)\b)��������ʻᱻ���񵽱��Ϊ1�ķ����У�Ȼ����1���򼸸��հ׷�(\s+)������Ƿ���1�в�������ݣ�Ҳ����ǰ��ƥ����Ǹ����ʣ�(\1)��

����    ����/�﷨           ˵��
����    (exp)           ƥ��exp,�������ı����Զ�����������
        (?<name>exp)    ƥ��exp,�������ı�������Ϊname�����Ҳ����д��(?'name'exp)
        (?:exp)         ƥ��exp,������ƥ����ı���Ҳ�����˷���������
������    (?=exp)     ƥ��expǰ���λ��
            (?<=exp)    ƥ��exp�����λ��
            (?!exp)     ƥ�������Ĳ���exp��λ��
            (?<!exp)    ƥ��ǰ�治��exp��λ��
ע��    (?#comment)     �������͵ķ��鲻��������ʽ�Ĵ�������κ�Ӱ�죬�����ṩע�������Ķ�

ע�⣺1. ����0��Ӧ����������ʽ��2. ʵ������ŷ��������Ҫ��������ɨ������ģ���һ��ֻ��δ��������䣬�ڶ���ֻ����������䣭������������������Ŷ�����δ��������ţ�3. �����ʹ��(?:exp)�������﷨������һ���������ŷ���Ĳ���Ȩ��


^[a-z0-9_-]{3,16}$
��Сд��ĸ�����֡��»��ߡ������߿�ͷ������3��16���������ַ�����һֱ���н�βû�������ַ��ġ�
^#?([a-f0-9]{6}|[a-f0-9]{3})$
��һ�������#��ͷ�����6��Сд��ĸ��3��Сд��ĸ��β���С�
^[a-z0-9-]+$
����һ������Сд��ĸ�����֡������ߵ���

matching an email
^({a-z0-9_\.-]+)@([\da-z\.-]+)\.([a-z\.]{2,6}$)
��һ������Сд��ĸ�����֡�_ ��. ��- ��ͷ�����@��һ���������ֻ�Сд��ĸ��.��-�����. ����2��6����ĸ��.��β 

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
sayHello1(str2: " ", str3: "World") // ����Ĭ�ϲ����ɲ�����ֵ
sayHello2("Hello", str2: " ")
����������Ĭ�ϲ���ʱ��ϵͳ���Զ��ṩ������Ĭ�ϲ����ķ�����

// swift�ṩ�� NSLocalizedString �Ͱ���������Ĭ�ϲ���
public func NSLocalizedString(key: String, tableName: String? = default, bundle: NSBundle = default, value: String = default, comment: String) -> String

[singleton]
class MyManager {
    private static let sharedInstance = MyManager()
    class var sharedManager : MyManager {
        return sharedInstance
    }
}

MyManager.sharedManager

[���ͷ�Χ������ static / class]
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
    // ��class �п���ʹ��class
    class func foo() -> String {
        return "MyStruct.foo()"
    }
    // Ҳ����ʹ��static
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
                                    @"nickname" : @"�ÿ�_�ֻ�Ʒ��",
                                    @"sex" : @(0),
                                    @"marketId" : [AppInfo marketId],
                                    @"serverId" : [ServiceProvider sharedServiceProvider].currentServerId
                                    };
    NSDictionary *userDeviceInfo = @{@"accessToken" : [AppInfo deviceUUID],
                                     @"expiresIn" : @(7199),
                                     @"openId" : [ASIdentifierManager sharedManager].advertisingIdentifier.UUIDString,
                                     @"platform" : @"�ÿ�"
                                     };
    [[YTXUserManager sharedManager] thirdPartyLogin:@{ @"userInfo" : userInfoParam, @"authentication" : userDeviceInfo }];
}



[�ӿ����]Protocol compositions do not define a new,permanent protocol type. Rather, they define a temporary local protocol that has the combined requirements of all protocols in the compositions.
�ӿ���������һ����ʱ�Ľӿڼ��ϲ���ĳЩ����Ĳ�����
typealias PetLike = protocol<KittenLike, DogLike> // �������������������ε����Լ����


// -- ��ͬ�ӿ��ڵķ�������ʱ���Ƚ�ʵ��asΪ��ͬ�Ľӿ��ٵ�����Ӧ�ķ�����
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
func wishHappyBirthday(celebrator: protocol<Named,Aged>) {// ͬʱʵ���������ӿڵ�class�����Դ���
    print("\(celebrator.name)-\(celebrator.age)")
}
let person = Person(name: "HiBort", age: 12)

wishHappyBirthday(person)

// protocol<Named,Aged>��˼���κ�ͬʱ����Named��Aged����Э���type
// --

[@objc classes]
ΪЭ�����optionalѡ��ʱ����Ҫ��ǰ�����@objc
@objc protocol �������Э�� should be exposed to OC code and is described in Using Swift with Cocoa and OC.
@objc protocolֻ�����������̳���OC����������������@objc ǰ׺���ࡣ��������struct and enum��
���仰˵�����ǰ����п�ѡ���͵�Э�鲻������swiftר�е��ࡣ

[��ʼ����������˳��]
override init() {
    power = 10
    super.init()
    name = "tiger"
}
1. ���������Լ���Ҫ��ʼ���Ĳ���
2. ���ø������Ӧ�ĳ�ʼ������
3. �Ը����е���Ҫ�ı�ĳ�Ա�����趨��
ע�⣺������Ҫ�Ը����е�ֵ���и���ʱ�����Բ���ʽ�ĵ���self.init()����ʵ������swift�����ǽ�������ʽ�ĵ��ã�

[Array, ContiguousArray, ArraySlice]ֵ����
`Array` is an efficient, tail-growable random-access collection of arbitrary elements.��Ч�ģ�β������ӣ������ȡ����������λ�õ�Ԫ��
Value Semantics ֵ����
Array�����Զ��Ž�OC
ContiguousArray����Array�������Ž�OC
ArraySlice����ʹ����˲ʱ������������м���̣������Ž�OC


[�ɱ����]
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

[��ʼ��������ѭ�Ĺ���]
��ʼ��·�����뱣֤������ȫ��ʼ���������ͨ�����ñ����͵�designated��ʼ����������֤��
���Ը�init�������requiredǰ׺��Ҫ���������ʵ�֡�������δ�ͬ�����д����ԣ��磺inout����
1. �����designated��ʼ������������ø����designated��������֤������ɳ�ʼ����
2. convenience��ʼ������������ñ������һ����ʼ����������ɳ�ʼ����
3. convenience��ʼ���������ձ�����ñ����designated��ʼ��������
// P466

In functional programming, you think of immutable data structures and functions that convert them. 

In object-oriented programming, you think about objects that send messages to each other.

�ں���ʽ��̵���������ǲ�������ݽṹ�Լ���Щת�����ǵĺ���������Զ����̵����㿼�ǵ��ǻ��෢����Ϣ�Ķ���

[������ѭ��ͬ��Э����ʵ�ֲ�ͬ�ķ���]
����һ��д��������չ�Ժ����ĺܺõķ�����ͨ��ʹ��һ����Ҫ����Э�飬������һ��ʵʵ���ڵ����ͣ���� API ���û��ܹ������������͡�����Ȼ�������� enum ������ԣ�����ͨ������������Э�飬����Ը��õر���Լ�����˼��������ľ�������������ڿ������ɵ�ѡ���Ƿ񿪷���� API��

[Methods And Functions]
Functions are standalone, while methods are functions that are encapsulated in a class, struct, or enum.
�����Ƕ����ģ��������Ǻ�����װ���࣬�ṹ����ö���еĺ�����

[If you want the external and internal parameter names to be the same.]
func hello(name name: String) {
    println("hello \(name)")
}
����
func hello(#name: String) {
    println("hello \(name)")
}
hello(name: "Robot")


struct Celsius {
    var temperatureInCelsius: Double
    init(fromFahrenheit fahrenheit: Double) {// �����ⲿ������
        temperatureInCelsius = (fahrenheit - 32.0) / 1.8
    }
    init(fromKelvin kelvin: Double) {
        temperatureInCelsius = kelvin - 273.15
    }
    init(_ celsius: Double) { // �����ⲿ������������д
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

[Parameters with Default Values]it is best practice to put all your parameters with default values at the end of a function��s parameter list. 
func hello(name: String = "you") {
    println("hello, \(name)")
}

hello(name: "Mr. Roboto")
// hello, Mr. Roboto

hello()
// hello, you

// I��m a huge fan of default parameters, mostly because it makes code easy to change and backward compatible. You might start out with two parameters for your specific use case at the time, such as a function to configure a custom UITableViewCell, and if another use case comes up that requires another parameter (such as a different text color for your cell��s label), just add a new parameter with a default value �� all the other places where this function has already been called will be fine, and the new part of your code that needs the parameter can just pass in the non-default value!

�ɱ����
[Variadic Parameters]Variadic parameters are simply a more readable version of passing in an array of elements. In fact, if you were to look at the type of the internal parameter names in the below example, you��d see that it is of type [String] (array of strings):
func helloWithNames(names: String...) {
    if names.count > 0 {// The catch here is to remember that it is possible to pass in 0 values, just like it is possible to pass in an empty array, so don��t forget to check for the empty array if needed:
        for name in names {
            println("Hello, \(name)")
        }
    } else {
        println("Nobody here!")
    }
}
// Another note about variadic parameters: the variadic parameter must be the last parameter in your function��s parameter list!

func arithmeticMean(numbers: Double...) -> Double {
    var total: Double = 0
    for number in numbers {
        total += number
    }
    return total / Double(numbers.count)
}
arithmeticMean(1, 2, 3, 4, 5)
// returns 3.0, which is the arithmetic mean of these five numbers

[Inout Parameters] ͨ��Inout ���������ı��ⲿ����
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

// ʹ�ñ�����������ֱ��ʹ�ô���Ĳ�����������ı����ԭ����ֵ�������������������ں������õ����������С�
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

[Generic Parameter Types] ���� ��һ�������н����������Ͳ����Ĳ�������ȷ��������������������ͬ�ģ�
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
ֵ��ע���������� inout ������ͬ �� �������������޸��ⲿ��������������ǿ���һ�ݱ������������㣬����Ӱ��ԭ���ı���

[��Ϊ�����ĺ���]
�� Swift �У��������Ա����������������ݡ����磬һ���������Ժ���һ���������͵Ĳ�����
func luckyNumberForName(name: String, #lotteryHandler: (String, Int) -> String) -> String {
    let luckyNumber = Int(arc4random() % 100)
    return lotteryHandler(name, luckyNumber)
}

func defaultLotteryHandler(name: String, luckyNumber: Int) -> String {
    return "\(name), your lucky number is \(luckyNumber)"
}

luckyNumberForName("Mr. Roboto", lotteryHandler: defaultLotteryHandler)
// Mr. Roboto, your lucky number is 38
ע����ֻ�к��������ñ����� �� �ڱ������� defaultLotteryHandler���������֮���Ƿ�ִ�����ɽ��յĺ���������
ʵ������Ҳ���������Ƶķ������룺
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

Ϊ������ĺ���������߿ɶ��ԣ����Կ���Ϊ�㺯�������ʹ������� (������ Objective-C �е� typedef)��
typealias lotteryOutputHandler = (String, Int) -> String
func luckyNumberForName(name: String, #lotteryHandler: lotteryOutputHandler) -> String {
    let luckyNumber = Int(arc4random() % 100)
    return lotteryHandler(name, luckyNumber)
}

��Ҳ����ʹ�ò������������ĺ��� (������ Objective-C �е� blocks)��
func luckyNumberForName(name: String, #lotteryHandler: (String, Int) -> String) -> String {
    let luckyNumber = Int(arc4random() % 100)
    return lotteryHandler(name, luckyNumber)
}
luckyNumberForName("Mr. Roboto", lotteryHandler: {name, number in
    return "\(name)'s' lucky number is \(number)"
})
// Mr. Roboto's lucky number is 74
�� Objective-C �У�ʹ�� blocks ��Ϊ�������첽�����ǲ�������ʱ�Ļص��ʹ�����ĳ�����ʽ����һ��ʽ�� Swift �еõ��˺ܺõ�������

[Access Controls]
Swift �����������Ȩ�޿��ƣ�
Public Ȩ�� ����Ϊʵ�����ö������ǵ�ģ���е�Դ�ļ��ķ��ʣ���������ģ���Դ�ļ���ֻҪ�����˶���ģ���Ҳ�ܽ��з��ʡ�ͨ������£�Framework �ǿ��Ա��κ���ʹ�õģ�����Խ�������Ϊ public ����
Internal Ȩ�� ����Ϊʵ�����ö������ǵ�ģ���е�Դ�ļ��ķ��ʣ������ڶ���ģ��֮����κ�Դ�ļ��ж����ܷ�������ͨ������£�app �� Framework ���ڲ��ṹʹ�� internal ����
Private Ȩ�� ֻ���ڵ�ǰԴ�ļ���ʹ�õ�ʵ�塣ʹ�� private ���𣬿�������ĳЩ���ܵ��صص�ʵ��ϸ�ڡ�
Ĭ������£�ÿ�������ͱ����� internal �� ���� �����ϣ���޸����ǣ�����Ҫ��ÿ�������ͱ�����ǰ��ʹ�� private ���� public �ؼ��֣�
public func myPublicFunc() {
}

func myInternalFunc() {
}

private func myPrivateFunc() {
}

private func myOtherPrivateFunc() {
}


[Fancy Return Types��������] �� Swift �У������ķ������ͺͷ���ֵ����� Objective-C ���Ը��Ӹ��ӣ������������ѡ�Ͷ���������͡�
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
And of course, when you��re using the optional return value, don��t forget to unwrap:
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
In the above example function, my logic is flawed �� it is possible that no values could be passed in, so my program would actually crash if that ever happened. If no values are passed in, I might want to make my whole return value optional:
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

[Nested Functions]Ƕ�׺���
func myFunctionWithNumber(someNumber: Int) {

    func increment(var someNumber: Int) -> Int {
        return someNumber + 10
    }

    let incrementedNumber = increment(someNumber)
    println("The incremented number is \(incrementedNumber)")
}
myFunctionWithNumber(5)
// The incremented number is 15


ios���ʻ�
http://www.cnblogs.com/lisa090818/p/3240708.html

���ios
http://www.cnblogs.com/zhidao-chen/category/461198.html

Swift ��ǿ�������ԣ����������ƶϵ����Ե����ԡ�
Swift is very much into strong typing and type inference and all that. 

[������]
//MARK: TableViewDataSource
//MARK: -  TableViewDataSource
private typealias TableViewDataSource = ViewController

let label = "The width is"
let width = 94
let widthLabel = "label +String(width)"

һԪ���������
��ֵ�������ſ���ʹ��ǰ׺ - (��һԪ����)���л�:
let three = 3
let minusThree = -three // minusThree ���� -3
let plusThree = -minusThree // plusThree ���� 3, �� "����3"
һԪ����( - )д�ڲ�����֮ǰ,�м�û�пո�

һԪ��������� ͬ����һԪ���������

���ڵ���( a >= b )
С�ڵ���( a <= b )

�պ������(Nil Coalescing Operator)
�պ������( a ?? b )���Կ�ѡ���� a ���п��ж�,��� a ����һ��ֵ�ͽ��н��,����ͷ���һ��Ĭ��ֵ b .�� �����������������:
    ���ʽ a ������Optional����
    Ĭ��ֵ b �����ͱ���Ҫ�� a �洢ֵ�����ͱ���һ��

[ClosedInterval]�����������( a...b )����һ�������� a �� b (���� a �� b )������ֵ������, b ������ڵ��� a ��
[HalfOpenInterval]�뿪����( a..<b )����һ���� a �� b �������� b �����䡣
ֻ���û����㣨ĳ�������Ƿ����ĳ�ַ������֡�valu�����������������ַ����ȡ�
\0...~   �ж�ĳ���ַ��Ƿ�����Ч��ASCII�ַ�

import UIKit

var str = "Hello, playground"

let label = "The width is "
let width = 94
let widthLabel = label + String(width)
let widthL = label + "\(width)"

//ʹ��[]������������ֵ䣬��ʹ���±��key������Ԫ��
var shoppingList = ["catfish", "water", "tulips", "blue pa"]
shoppingList[1] = "bottle of water"
var occupations = [
    "Malcolm": "Captain",
    "Kaylee": "Mechanic",
]
occupations["Jayne"] = "Public Relations"
//ʹ�ó�ʼ������������һ����������ֵ�
let emptyArray = [String]()
let ematyDictionary = Dictionary<String, Float>()
let list = []
let occ = [:]

let scores = [75,43,103,23,45]
var teamScore = 0
for score in scores {
    if score > 50 { //��if����У�����������һ���������ʽ���������ε���0��1���Ա�
        teamScore += 3
    } else {
        teamScore += 1
    }
}
teamScore

var optionalString: String? = "Hello"
optionalString = nil

var optionalName: String? = "John" //���ͺ����һ���ʺ���������������ֵ�ǿ�ѡ��
optionalName = nil
var greeting = "Hello!"
if let name = optionalName {
    greeting = "Hello, \(name)"
} else {
    greeting = "Hello, greet"
}

//switch ֧���������͵������Լ����ֱȽϲ���--�������������Լ�������ȣ����е�switch ��ƥ�䵽���Ӿ�󣬳������Ƴ�����������������У����Բ���Ҫ��ÿ���Ӿ��β���break
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

//����ʹ��for-in�������ֵ䣬��Ҫ������������ʾÿ����ֵ��
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

for i in 0...3 { //...����������½�ķ�Χ
    largest -= 1
}
largest

//ʹ��func������һ��������ʹ�����ֺͲ��������ú�����ʹ��->��ָ����������ֵ
func greet(name: String, day: String) ->String {
    return "Hello \(name), today is \(day)"
}

//ʹ��һ��Ԫ�������ض��ֵ
func getGasPrices() -> (Double, Double, Double) {
    return (3.45, 3.46, 3.56)
}
getGasPrices()

//�����Ĳ����ǿɱ�ģ���һ����������ȡ����
func sumOf(numbers:Int...) ->Int {
    var sum = 0
    for number in numbers {
        sum += number
    }
    return sum
}
sumOf()
sumOf(42, 45, 67)

//��������Ƕ�ף���Ƕ�׵ĺ������Է�����ຯ���ı���������ʹ��Ƕ�׺������ع�һ�����ڸ��ӵĺ���
//����Ҳ������Ϊ��һ�������ķ���ֵ
func makeIncrementer() -> (Int ->Int) {
    func addOne(number : Int) ->Int {
        return 1 + number
    }
    return addOne
}
var increment = makeIncrementer()
increment(7)

//����Ҳ���Ե�������������һ������
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
//����ʵ������һ������ıհ��������ʹ��{}������һ�������հ���ʹ��in �������ͷ���ֵ����������հ���������з���
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


�հ����ʽ��Closure Expression��
�հ���closure�� ���ʽ���Խ���һ���հ���������������Ҳ�� lambda, ���� ����������anonymous function����. ��������function��������һ���� �հ���closure�������˿�ִ�еĴ��루���������壨statement�����ƣ� �Լ����գ�capture���Ĳ����� ������ʽ���£�

{ (parameters) -> return type in
    statements
}

�հ��Ĳ���������ʽ�������е�����һ��, ��μ���Function Declaration.

�հ����м����������ʽ, ��ʹ�ø��Ӽ�ࣺ

1. �հ�����ʡ�� ���Ĳ�����type �ͷ���ֵ��type. ���ʡ���˲����Ͳ������ͣ���ҲҪʡ�� 'in'�ؼ��֡� �����ʡ�Ե�type �޷�����������֪��inferred�� ����ô�ͻ��׳��������
2. �հ�����ʡ�Բ�����ת���ڷ����壨statement����ʹ�� $0, $1, $2 �����ó��ֵĵ�һ�����ڶ�����������������
3. ����հ���ֻ������һ�����ʽ����ô�ñ��ʽ�ͻ��Զ���Ϊ�ñհ��ķ���ֵ�� ��ִ�� 'type inference 'ʱ���ñ��ʽҲ�᷵�ء�

���漸�� �հ����ʽ�� �ȼ۵ģ�
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


���Լ�����

���Լ�������غ���Ӧ����ֵ�ı仯��ÿ�����Ա�����ֵ��ʱ�򶼻�������Լ������������µ�ֵ�����ڵ�ֵ��ͬ��ʱ��Ҳ�����⡣

����Ϊ�����ӳٴ洢����֮��������洢����������Լ�������Ҳ����ͨ���������Եķ�ʽΪ�̳е����ԣ������洢���Ժͼ������ԣ�������Լ�����������������ο��̳�һ�µ����ء�

ע�⣺����ҪΪ�޷����صļ�������������Լ���������Ϊ����ͨ�� setter ֱ�Ӽ�غ���Ӧֵ�ı仯��

[���������]
��ͽṹ����Ϊ"���еĲ�����"�ṩ�Զ����ʵ�֣���ͨ������Ϊ���������(overloading)��
struct Vector2D {
    var x = 0.0, y = 0.0
}
//һ�������
func + (left: Vector2D, right: Vector2D) -> Vector2D {
    return Vector2D(x: left.x + right.x, y: left.y + right.y)
}
//ǰ׺��׺�����
����ṹ��Ҳ���ṩ��׼��Ŀ�����(unary operators)��ʵ�֡���Ŀ�����ֻ��һ������Ŀ�ꡣ������������ڲ���Ŀ��֮ǰʱ��������ǰ׺(prefix)��(���� -a)�������������ڲ���Ŀ��֮��ʱ�������Ǻ�׺(postfix)��(���� i++)��

Ҫʵ��ǰ׺���ߺ�׺���������Ҫ�����������������ʱ���� func �ؼ���֮ǰָ�� prefix ���� postfix �޶�����

prefix func - (cube: Cube) -> Cube{
    return Cube(side: -cube.side)
}

postfix func ++ (cube: Cube) -> Cube {
    return Cube(side: cube.side + 1)
}

���ϸ�ֵ�����

���ϸ�ֵ�����(Compound assignment operators)����ֵ�����(=)��������������н�ϡ����磬���ӷ��븳ֵ��ϳɼӷ���ֵ�����(+=)����ʵ�ֵ�ʱ����Ҫ�����������������ó� inout ���ͣ���Ϊ���������ֵ���������������ֱ�ӱ��޸ġ�
func += (inout left: Cube, right: Cube) {
        left =  left + right
}

���� ? b : c �������ء��Խ���ֵ�� prefix �� postfix �޶����������������Ĵ���Ϊ Vector2D ʵ��ʵ����ǰ׺���������(++a)��

ע�⣺ ���ܶ�Ĭ�ϵĸ�ֵ�����(=)�������ء�ֻ����ϸ�ֵ�����Ա����ء�ͬ���أ�Ҳ�޷�����Ŀ��������� a ? b : c �������ء�

�ȼ۲�����

�Զ������ͽṹ��û�жԵȼ۲�����(equivalence operators)����Ĭ��ʵ�֣��ȼ۲�����ͨ������Ϊ����ȡ�������(==)�롰���ȡ�������(!=)�������Զ������ͣ�Swift �޷��ж����Ƿ���ȡ�����Ϊ����ȡ��ĺ���ȡ������Щ�Զ�����������Ĵ����������ݵĽ�ɫ��

Ϊ��ʹ�õȼ۲����������Զ�������ͽ����еȲ�������ҪΪ���ṩ�Զ���ʵ�֣�ʵ�ֵķ�����������׺�����һ����
func == (left:Cube, right:Cube) -> Bool {
        return left.side == right.side
}
func != (left:Cube, right:Cube) -> Bool {
        return left.side != right.side
}

[=== �� !==]
�ж����������������Ƿ���ͬ��ͬ��ָ�뼶��ġ�

[�Զ��������]
ע�⣺���±�Ǳ������������ţ����������Զ����������(��)��{��}��[��]��.��,��:��;��=��@��#��&����Ϊǰ׺����������->��`��? �� !(��Ϊ��׺������)��
���Ե������ֻ��ʹ����Щ�ַ� / = - + * % < > ! & | ^ . ~��
�Զ������׺(infix)�����Ҳ����ָ�����ȼ�(precedence)�ͽ����(associativity)�����ȼ��ͽ��������ϸ��������������������ζ���׺��������������Ӱ��ġ�

�����(associativity)��ȡ��ֵ��left��right �� none���������������������ͬ���ȼ������������д��һ��ʱ�������ߵĲ��������н�ϡ�ͬ�����ҽ���������������ͬ���ȼ����ҽ�������д��һ��ʱ������ұߵĲ��������н�ϡ����ǽ����������ܸ�������ͬ���ȼ��������д��һ��

ע�⣺����Ϊǰ׺�ͺ�׺�����ָ�����ȼ������ǵ�ǰ׺������ͺ�׺�����ͬʱ����ͬһ��������ʱ�������ȵ��ú�׺�������

�����(associativity)��Ĭ��ֵ�� none�����ȼ�(precedence)���û��ָ������Ĭ��Ϊ 100��

�������Ӷ�����һ���µ���׺����� +-���˲����������ϵģ������������ȼ�Ϊ 140��

infix operator ** { associativity left precedence 200 }
func ** (left: Cube, right: Cube) -> Cube {
    return Cube(side: left.side * right.side)
}

// ---- �Զ��� ?? �����
infix operator ~?? {
    associativity left  // ����ԣ�Ĭ��none
    precedence 140      // ���ȼ���Ĭ��100
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

ע�⣺������дĬ�ϵ�=���������Ҳ������дĬ�ϵ���Ŀ�����--?: ��

// �����������Ǿ��д������Ƶġ�����makeIncrementor�ķ�����Ҳ��Ҫ������֧����ȷ�����η����������ڲ��Ķ��壬�����޷�����ͨ����
let start = 1
// �����������Ǿ��д������ʵ�
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
���ڵ��ļ���|���ڵ�����|���ڵ�����|���ڵ�function������
��ĳ��������function���У�__FUNCTION__ �᷵�ص�ǰ���������֡� ��ĳ��������method���У����᷵�ص�ǰ���������֡� ��ĳ��property ��getter/setter�л᷵��������Ե����֡� ������ĳ�Ա��init/subscript�� �᷵������ؼ��ֵ����֣���ĳ���ļ��Ķ��ˣ�the top level of a file���������ص��ǵ�ǰmodule�����֡�

[��׺self���ʽ��Postfix Self Expression��]
��׺���ʽ�� ĳ�����ʽ + '.self' ���. ��ʽ���£�
    expression.self
    type.self
��ʽ1 ��ʾ�᷵�� expression ��ֵ�����磺 x.self ���� x
��ʽ2�����ض�Ӧ��type�����ǿ�����������̬�Ļ�ȡĳ��instance��type��
    ����Self ���ʽ�﷨
    ����self���ʽ �� ���ñ��ʽ . self

[dynamic���ʽ��Dynamic Type Expression��]
��̬���ͱ��ʽ�᷵��"����ʱ"ĳ��instance��type, �����뿴��������ӣ�
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
����Ϊ����������µ�һ����ȫ����������
1. willSet�������µ�ֵ֮ǰ����
2. didSet���µ�ֵ������֮����������

willSet�������Ὣ�µ�����ֵ��Ϊ�̶��������룬��willSet��ʵ�ִ����п���Ϊ�������ָ��һ�����ƣ������ָ���������Ȼ���ã���ʱʹ��Ĭ������newValue��ʾ��didSet�������Ὣ�ɵ�����ֵ��Ϊ�������룬����Ϊ�ò�����������ʹ��Ĭ�ϲ�����oldValue��

ע�⣺willSet��didSet�����������Գ�ʼ�������в��ᱻ���ã�����ֻ�ᵱ���Ե�ֵ�ڳ�ʼ��֮��ĵط�������ʱ�����á�
//������������ֵ�����������������������

������һ��willSet��didSet��ʵ�����ӣ����ж�����һ����ΪStepCounter���࣬����ͳ�Ƶ��˲���ʱ���ܲ��������Ը��Ʋ����������ճ�������ͳ��װ�õ������������ʹ�á�
class StepCounter {
var totalSteps: Int = 0 {
    willSet(newTotalSteps) {
     //   newValueΪ�µ�ֵ
        println("About to set totalSteps to \(newTotalSteps)")
    }
    didSet {
     //   oldValueΪ�ɵ�ֵ
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

[willSet and didSet]������÷���update UI
eg: �ı���ĳ��controller�����ԣ���didSet�У���UI���и��¡�

StepCounter�ඨ����һ��Int���͵�����totalSteps������һ���洢���ԣ�����willSet��didSet��������

��totalSteps������ֵ��ʱ������willSet��didSet���������ᱻ���ã��������µ�ֵ�����ڵ�ֵ��ȫ��ͬҲ����á�

�����е�willSet����������ʾ��ֵ�Ĳ����Զ���ΪnewTotalSteps�����������ֻ�Ǽ򵥵Ľ��µ�ֵ�����

didSet��������totalSteps��ֵ�ı�󱻵��ã������µ�ֵ�;ɵ�ֵ���жԱȣ�����ܵĲ��������ˣ������һ����Ϣ��ʾ�����˶��ٲ���didSetû���ṩ�Զ������ƣ�����Ĭ��ֵoldValue��ʾ��ֵ�Ĳ�������

ע�⣺�����didSet��������Ϊ���Ը�ֵ�����ֵ���滻������֮ǰ���õ�ֵ��

��������������������жԸ������������������Թ۲죬���������⸸���е����Ǵ洢���Ի��Ǽ������ԡ�

ȫ�ֱ����;ֲ�����

�������Ժ����Լ�������������ģʽҲ��������ȫ�ֱ����;ֲ�������ȫ�ֱ������ں������������հ����κ�����֮�ⶨ��ı������ֲ��������ں�����������հ��ڲ�����ı�����

ǰ���½��ᵽ��ȫ�ֻ�ֲ����������ڴ洢�ͱ��������洢�������ƣ����ṩ�ض����͵Ĵ洢�ռ䣬�������ȡ��д�롣

���⣬��ȫ�ֻ�ֲ���Χ�����Զ�������ͱ�����Ϊ�洢�ͱ�������������������ͱ�������������һ��������һ�������ֵ�����Ǵ洢ֵ��������ʽҲ��ȫһ����

ע�⣺ȫ�ֵĳ�������������ӳټ���ģ����ӳٴ洢�������ƣ���ͬ�ĵط����ڣ�ȫ�ֵĳ������������Ҫ���@lazy���ԡ� �ֲ���Χ�ĳ�������������ӳټ��㡣

[Lazy Initialization]
�ڳ�ʼ������ǰ���lazy��ʾ����������ʹ�ñհ��ͺ��������Խ��г�ʼ����ֻ����������Ա��õ�ʱ�Żᱻִ�С�
�������property���Ϊlazy��ʹ�ú��������Խ��г�ʼ���ǲ�����ģ���Ϊ�����ʼ��֮ǰ������ķ������ǲ��ɵ��õġ����ǵ�get�������ʱ�����Ѿ����������Կ����������á�
ֻ��var����ʹ��lazy�� let������ʹ��lazy��
lazy var str: String = "Hello"

let result = data.lazy.map {  // ������Щ����Ҫ��ȫ���У�������ǰ�˳��������ʹ��lazy�������Ż���Ч������
    (i : Int) -> Int {
        return i * 2
    }
}

��������

ʵ������������һ���ض�����ʵ����ÿ������ʵ������ӵ���Լ���һ������ֵ��ʵ��֮��������໥������

Ҳ����Ϊ���ͱ��������ԣ����������ж��ٸ�ʵ������Щ���Զ�ֻ��Ψһһ�ݡ��������Ծ����������ԡ�

�����������ڶ����ض���������ʵ����������ݣ���������ʵ�������õ�һ������������ C �����еľ�̬����������������ʵ�����ܷ��ʵ�һ������������ C �����еľ�̬��������
����ֵ���ͣ�ָ�ṹ���ö�٣����Զ���洢�ͺͼ������������ԣ������ࣨclass����ֻ�ܶ���������������ԡ�

ֵ���͵Ĵ洢���������Կ����Ǳ����������������������Ը�ʵ���ļ�������һ������ɱ������ԡ�

ע�⣺��ʵ���Ĵ洢���Բ�ͬ��������洢����������ָ��Ĭ��ֵ����Ϊ���ͱ����޷��ڳ�ʼ��������ʹ�ù��������������Ը�ֵ��

���������﷨

�� C �� Objective-C �У���̬�����;�̬�����Ķ�����ͨ���ض����ͼ���global�ؼ��֡��� Swift ��������У�������������Ϊ���Ͷ����һ����д�����������Ļ������ڣ�����������÷�ΧҲ��������֧�ֵķ�Χ�ڡ�

ʹ�ùؼ���static������ֵ���͵��������ԣ��ؼ���class��Ϊ�ࣨclass�������������ԡ������������ʾ�˴洢�ͺͼ������������Ե��﷨��

struct SomeStructure {
static var storedTypeProperty = "Some value."
static var computedTypeProperty: Int {
// ���ﷵ��һ�� Int ֵ
}
}
enum SomeEnumeration {
static var storedTypeProperty = "Some value."
static var computedTypeProperty: Int {
// ���ﷵ��һ�� Int ֵ
}
}
class SomeClass {
class var computedTypeProperty: Int {
// ���ﷵ��һ�� Int ֵ
}
}

ע�⣺�����еļ���������������ֻ���ģ���Ҳ���Զ���ɶ���д�ļ������������ԣ���ʵ���������Ե��﷨���ơ�

��ȡ�������������Ե�ֵ
��ʵ��������һ�����������Եķ���Ҳ��ͨ��������������У����ǣ�����������ͨ�����ͱ�������ȡ�����ã�������ͨ��
ʵ�������磺
println(SomeClass.computedTypeProperty)
// ��� "42"
println(SomeStructure.storedTypeProperty)
// ��� "Some value."
SomeStructure.storedTypeProperty = "Another value."
println(SomeStructure.storedTypeProperty)
// ��� "Another value.��
��������Ӷ�����һ���ṹ�壬ʹ�������洢��������������ʾ���������������ƽֵ��ÿ��������һ�� 0 �� 10 ֮�������
��ʾ������ƽֵ��
�����ͼ��չʾ���������ʹ��������������ʾһ����������������ƽֵ���������ĵ�ƽֵ�� 0��û��һ���ƻ�����������
�ĵ�ƽֵ�� 10�����еƵ�������ͼ�У��������ĵ�ƽ�� 9���������ĵ�ƽ�� 7��

����������������ģ��ʹ��AudioChannel�ṹ������ʾ��
struct AudioChannel {
static let thresholdLevel = 10
static var maxInputLevelForAllChannels = 0
var currentLevel: Int = 0 {
didSet {
if currentLevel > AudioChannel.thresholdLevel {
// ���µ�ƽֵ����Ϊ��ֵ
currentLevel = AudioChannel.thresholdLevel
}
if currentLevel > AudioChannel.maxInputLevelForAllChannels {
// �洢��ǰ��ƽֵ��Ϊ�µ���������ƽ
AudioChannel.maxInputLevelForAllChannels = currentLevel
}
}
}
}

�ṹAudioChannel������ 2 ���洢������������ʵ���������ܡ���һ����thresholdLevel����ʾ������ƽ�����������
ֵ������һ��ȡֵΪ 10 �ĳ�����������ʵ�����ɼ������������ƽ���� 10����ȡ�������ֵ 10����������������
�ڶ������������Ǳ����洢������maxInputLevelForAllChannels����������ʾ����AudioChannelʵ���ĵ�ƽֵ����
��ֵ����ʼֵ�� 0��
AudioChannelҲ������һ����ΪcurrentLevel��ʵ���洢���ԣ���ʾ��ǰ�������ڵĵ�ƽֵ��ȡֵΪ 0 �� 10��
����currentLevel����didSet���Լ����������ÿ�������ú������ֵ��������������飺
���currentLevel����ֵ�����������ֵthresholdLevel�����Լ�������currentLevel��ֵ�޶�Ϊ��
ֵthresholdLevel��
����������currentLevelֵ�����κ�֮ǰ����AudioChannelʵ���е�ֵ�����Լ���������ֵ�����ھ�̬��
��maxInputLevelForAllChannels�С�

ע�⣺
�ڵ�һ���������У�didSet���Լ�������currentLevel���ó��˲�ͬ��ֵ������ʱ�����ٴε������Լ�������

incrementBy���������������� amount��numberOfTimes��Ĭ������£�Swi ft  ֻ��amount����һ���ֲ����ƣ�����
��numberOfTimes�������ֲ������ֿ����ⲿ���ơ�����������������
let counter = Counter()
counter.incrementBy(5, numberOfTimes: 3)
// counter value is now 15
�㲻��Ϊ��һ������ֵ�ٶ���һ���ⲿ����������Ϊ�Ӻ�����incrementBy�Ѿ��ܺ�����ؿ����������á����ǵڶ�����
������Ҫ��һ���ⲿ�����������޶����Ա��ڷ���������ʱ��ȷ�������á�
����Ĭ�ϵ���Ϊ�ܹ���Ч�Ĵ�������method��,�������ڲ���numberOfTimesǰдһ�����ţ�#����
func incrementBy(amount: Int, #numberOfTimes: Int) {
count += amount * numberOfTimes
}
����Ĭ����Ϊʹ���������ζ�ţ��� Swift �ж��巽��ʹ������ Objective-C ͬ�����﷨��񣬲��ҷ���������Ȼ���ʽ�ķ�ʽ�����á�
�޸ķ������ⲿ��������(Modifying  External  Parameter  Name  Behavior  for  Methods)
��ʱΪ�����ĵ�һ�������ṩһ���ⲿ���������Ƿǳ����õģ������ⲻ��Ĭ�ϵ���Ϊ��������Լ����һ����ʽ���ⲿ���ƻ�����һ�����ţ�#����Ϊ��һ��������ǰ׺��������ֲ����Ƶ����ⲿ����ʹ�á��෴������㲻��Ϊ�����ĵڶ����������Ĳ����ṩһ���ⲿ���ƣ�����ͨ��ʹ���»��ߣ�_����Ϊ�ò�������ʽ�ⲿ���ƣ�������������Ĭ����Ϊ��

���Ƽ����ⲿ����ǰ��_

override  ���Ǹ��෽��
final   ���ܱ���д


[Inheriting init]ֻ��ȫ���̳л��߲��̳�

required ��ʾ�������ʵ�ָ÷���

[Failable init]
init?(arg1: type1, ...) {
//��Щ��ʼ������������ʧ�ܲ�����nil
}

let image = UIImage(named: "foo") //image is an Optional UIImage (i.e. UIImage?)
//������Ϊfoo��ͼƬ����image��ͼƬ������ʱ�����ؿ�; ע�����Ǿɵ�������ʽ

�����������ʱ�����ǻ�ʹ��let
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
let button = UIButton.buttonWithType(UIButtonType.System)   //�෽����������

Or obviously sometimes other objects will create objects for you ...
let commaSeparatedArrayElements: String = ",".join(myArray)
//join��������ƴ���ַ����������л᷵���ɶ��ŷָ����ַ���

[Any and AnyObject]
Any��ʾ��������ͣ�����class/struct/enum
AnyObject��ʾ�����class
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
    case let someDouble as Double where someDouble > 0: // ����where����
        print("")
    case is Double:
    case let someString as String: 
    case let (x,y) as (Double,Double): // Ԫ��
    case let movie as Movie: // ��
    case let stringConverter as String -> String:// ��ֵΪ��func����ʱ��
        print(stringConverter("Michael"))
    case -1.0...1.0:
        print("������")
        fallthrough     // �ǵ�����case�����Զ�break������Ž�����һ��case
    case nil:
        print("û��ֵ")
    case "aasda":
    }    
}
ע�⣺switch����ʹ����~=����������ģʽƥ�䣬caseָ����ģʽ��Ϊ�������switch����Ĳ�����Ϊ�Ҳ������������ǿ���ͨ������~=����������switchʹ�������Զ����~=ģʽƥ�䷽����
// --

let a: Any = 5
switch a {
// ��������ƥ��
case let n as Int: 
    print (n + 1)        // 5
    fallthrough
    print (n + 1)        // ��䲻��ִ��
case is UIView:         // case��������ִ�У���Ч��,��Ϊǰһ��case����fallthrough�ؼ��֣����Բ��������case�������������б�case�������������а�����let��var������ִ�С�������������fallthrough�ؼ��ֺ�����ŵ�case�����к���let��var
    print (a as! Int + 1)       // 5
default: ()
    print("111")
}
ע�⣺��case �м��� fallthrough �ؼ���ʱ���������е�ǰcase�����������ֱ�ӽ�����һ��case���������¸�case�������Ƿ������
Ҳ����ʹ��break ��ǰ����case��

// ���Ը�where����һ����־��Ȼ�����continue����break�������־��labels��
gameLoop: while true {
  switch state() {
     case .Waiting: continue gameLoop
     case .Done: calculateNextState()
     case .GameOver: break gameLoop
  }
}

var result: String? = secretMethod()
switch result {
case nil:       // ���� case .None:
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

[ģʽƥ��] case�ؼ���
2.0 ��ģʽƥ�����֧��for/if/
func nonnil<T>(array: [T?]) -> [T] {
    var result: [T] = []
    for case let x? in array {  // ƥ�������nil
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
    guard case let Entity.Entry(.Player, _, _, hp) = entity // ģʽƥ��
        where hp < MAX_HP
        else { return 0 }
    return MAX_HP - hp
}

print("Soldier", healthHP(Entity.Entry(type: .Soldier, x: 10, y: 10, hp: 79)))
print("Player", healthHP(Entity.Entry(type: .Player, x: 10, y: 10, hp: 57)))
// --
if case �� guard case �෴
func move(entity: Entity, xd: Int, yd: Int) -> Entity {
    if case Entity.Entry(let t, let x, let y, let hp) = entity
    where (x + xd) < 1000 &&
        (y + yd) < 1000 {
    return Entity.Entry(type: t, x: (x + xd), y: (y + yd), hp: hp)
    }
    return entity
}
print(move(Entity.Entry(type: .Soldier, x: 10, y: 10, hp: 79), xd: 30, yd: 500))
// ���: Entry(main.Entity.EntityType.Soldier, 40, 510, 79)
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
//e.g. a UIViewController method prepareForSegue, It takes a normal argument there, segue,(����һ����ͨ�Ĳ���segue) but then it also takes a sender, which can be AnyObject.(����������һ��sender���������������������AnyObject��) ���������е�����ΪSender ȷʵ�������������

�����AnyObject������oc�е�id���ͣ�����ʹ������Ψһ��ʽ���ǽ���ת������֪���Ǹ����ͣ�We don't usually use it directly. Instead, we convert it to another, known type��
We need to create a new variable which is of a known object type.
e.g. var destinationViewController : AnyObject
let calcVC = destinationViewController as CalculatorViewController  //ʹ�� as �������͵�ǿ��ת�������ַ�ʽת��ʱ��������ͳ���ͻᵼ�³�������

//��ֹ���������������
if let calcVC = destinationViewController as? CalculatorViewController { ... }
//as?��as����ͬ�����£���ͬ���ǣ� as? returns an Optional (calcVC = nil if dvc was not a CalculatorViewController)
Ҳ���Ե����ļ�������Ƿ���֪��
if destinationViewController is CalculatorViewController { ... }
//ͨ��ʹ��as? ����鲢ת����һ�θ㶨

�������AnyObject���͵�����ʱ������ var toolbarItems: [AnyObject]
for item in toolbarItems {
    if let toolbarItem = item as? UIBarButtonItem {
    //do something with the toolbarItem    
    }
}
 ... or ...
for toolbarItem in toolbarItems as [UIBarButtonItem] {
    //do something with the toolbarItem    
}//����ǽ�����������ת���ɶ�Ӧ�����ͣ����Ա���ȷ������������ȷ��ע�����ﲻ��ʹ�� as? , ��Ϊ for toolbarItem in nil �����塣

ʹ��XIB�����¼�����ʱ����Ҫǿ��ת��
@IBAction func appendDigit(sender: AnyObject) {
    if let sendingButton = sender as? UIButton {
        let digit = sendingButton.currentTitle!
        ...
    }
}

[Array]
Array ������   += [T]   ֻ����һ��Array������һ��Array
first -> T?     ���ص�һ��Ԫ��-
last -> T?      �������һ��Ԫ��-
ע�⣺first �� last ���ص���optional���ͣ�So, they don't do Array index out of bounds. So, they'll return nil if your Array is empty.
[ddd.d,ss.dfd,fd.sa]
var a = [a,b,c]

append(T)
insert(T, atIndex: Int) //��ָ����������Ԫ��
splice(Array<T>, atIndex: Int) //��ָ������ƴ�ӵ�ָ������ a.splice([d,e], atIndex:1), a = [a,d,e,b,c]
removeAtIndex(Int)
removeRange(Range) //a.removeRange(0..<2), a = [c]
replaceRange(Range, [T]) //a.replaceRange(0...1, with: [x,y,z]), a = [x,y,z,b]
sort(isOrderedBefore: (T, T) -> Bool) //a.sort { $0 < $1}
sorted  //�������ź��������Ŀ���

filter(includeElement: (T) -> Bool) -> (T) //���ع��˺�������飬ָ�����������ú�����ʾ������BOOLֵ���������Ԫ���ǲ�����Ҫ�ġ�

//һ�д���Ϳɽ�����ӳ��ɲ�ͬ���͵�����
map(transform: (T) -> U) -> [U]
let stringified: [String] = [1,2,3].map { "\($0)" }//��һ��Int�е�����ӳ�䵽���ǵ��ַ�����ʽ

//ʹ��Reduce���Խ���������������һ��ֵ
reduce(initial: U, combine: (U, T) -> U) -> U
let sum: Int = [1,2,3].reduce(0) { $0 + $1 } //��ʼֵΪ0 ����ǰһ���Ӻ�һ����
//�����������һ��������������������Զ��ĳ�ʼֵ������һ��������Ϊ����������������뵱ǰ��ֵ����һ��Array�е�Ԫ�أ���ֻ��Ҫ�����������ߵ������ʲô��������һֱ��ϡ���ϡ���ϣ�ֱ���õ����յĽ����
//So this one takes an argument which is the initial value you want to start with. And then it just takes a function that takes the value so far and the next element in the Array and you return what the combination is. So you're just combining, combining, comgining

// In Swift 2, reduce has been removed as a global function and has been added as an instance method on all objects that conform to the SequenceType protocol via a protocol extension. Usage is as follows.

[String]

�ַ�������ͨ���ӷ������( + )�����һ��(��ơ����ӡ�)����һ���µ��ַ���
Ҳ����ͨ���ӷ���ֵ����� ( += ) ��һ���ַ�����ӵ�һ���Ѿ������ַ���������
�� append ������һ���ַ����ӵ�һ���ַ���������β��

ע��:���ܽ�һ���ַ��������ַ���ӵ�һ���Ѿ����ڵ��ַ�������,��Ϊ�ַ�����ֻ�ܰ���һ���ַ���

�ַ�����ֵ (String Interpolation)
�ַ�����ֵ��һ�ֹ������ַ����ķ�ʽ,���������а����������������������ͱ��ʽ�� ��������ַ��������� ��ÿһ����Է�б��Ϊǰ׺��Բ������
let multiplier = 3
let message = "\(multiplier) times 2.5 is \(Double(multiplier) * 2.5)" 
// message �� "3 times 2.5 is 7.5"

ע��:��ֵ�ַ�����д�������еı��ʽ���ܰ�����ת��˫���� ( " ) �ͷ�б�� ( \�1�6 ),���Ҳ��ܰ����س����з���

�����ַ����� (Counting Characters): ȫ�ֺ��� count( )
let unusualMenagerie = "Koala ?, Snail ?, Penguin ?, Dromedary ?" println("unusualMenagerie has \(count(unusualMenagerie)) characters") // ��ӡ���:"unusualMenagerie has 40 characters"

��Ҫע�����ͨ�� count(_:) ���ص��ַ��������������������ͬ�ַ��� NSString �� length ������ ͬ�� NSString �� length ���������� UTF-16 ��ʾ��ʮ��λ���뵥Ԫ����,������ Unicode ����չ���ַ�Ⱥ ������Ϊ��֤,��һ�� NSString �� length ���Ա�һ��Swift�� String ֵ����ʱ,ʵ�����ǵ����� utf16Coun t��

String.Index
-In Unicode, a given glyph might be represented by mutiple Unicode characters (accents, etc.)
-As a result, you can't index a String by Int (because it's a collection of characters, not glyphs)

starIndex   //��ȡString����ĸ
String.Index.advancedBy(Int) //ȫ�ֺ����������������������������ƽ����ٴΣ�Ȼ��᷵��һ���µ�����λ��
var s = "hello"
let index = advance(s.startIndex,2) //index is a String.Index to the 3rd glyph, "l", index��String.Index����
s.splice("abc", index)  //It will splice a String into the middle of another String. s will now be "heabcllo"

let startIndex = advance(s.startIndex, 1)
let endIndex = advance(s.startIndex, 6)
let substring = s[index..<endIndex] //substring will be "eabcl"�� �ַ�������ʹ�÷������������Ӵ���

s.characters.indices    -----    0..<12

var straa = "aaaiaaaaaaaa"
straa.startIndex
straa.endIndex
straa.endIndex.predecessor()//�õ�ǰһ������
straa.startIndex.successor()//�õ���һ������
straa.advancedBy(3) // i
var index:Int = 4
straa.insert("!", atIndex: straa.endIndex)
straa.insertContentsOf("there".characters, at:straa.endIndex)
straa.removeAtIndex(3)
straa.characters.indices // ʹ��characters���Ե�indices���Իᴴ��һ������ȫ�������ķ�Χ(Range)
let range = straa.endIndex.advancedBy(-6)..<straa.endIndex
straa.removeRange(range)
�ַ���/�ַ������õ��ڲ�����(==)�Ͳ����ڲ�����(!=)


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
// --��String������ҪRange�ķ���ʱ��Ҳ����ת��NSString�����ã�
let levels = "ABCDE"
let nsRange = NSMakeRange(1, 4)
(levels as NSString).stringByReplacingCharactersInRange(nsRange, withString: "AAAA")
(levels as NSString).substringWithRange(NSMakeRange(1, 4))

description -> String   //Printable
endIndex -> String.Index
hasPrefix(String) -> Bool
hasSuffix(String) -> Bool
toInt() -> Int? //���ַ�����ֻ��toInt��û��toDouble. toInt()���ص�ʱoptional���ͣ�����ԡ�hello��ʱ���᷵��nil
capitalizedString -> String
lowercaseString -> String
uppercaseString -> String
join(Array) -> String  //",".join(["1","1","1"]) = "1,1,1"
componentsSeparatedByString(String) -> [String] //��ָ���ַ�������������ַ����ָ�Ϊ������ʽ "1,2,3".csbs(",") = ["1","2","3"]

let d: Double = 37.5
let f:Float = 37.5
let x = Int(d)  //truncates�ض�
let xd = Double(x)
let cgf = CGFloat(d)
������ȡ�ࣺ 8 % 2.5 // ���� 0.5

�ַ������������ͨ����ʼ����������໥ת��
let a = Array("abc")    //a = ["a","b","c"], i.e. array of Character
let s = String(["a","b","c"])   //s = "abc" (the array is of Character, not String)

let arr = [Int]()
+ ƴ������
var anotherThreeDoubles = Array(count: 3, repeatedValue: 2.5)
// anotherThreeDoubles ���ƶ�Ϊ [Double]���ȼ��� [2.5, 2.5, 2.5]
var sixDoubles = threeDoubles + anotherThreeDoubles
// sixDoubles ���ƶ�Ϊ [Double]���ȼ��� [0.0, 0.0, 0.0, 2.5, 2.5, 2.5]
var anotherThreeDoubles = Array(count: 3, repeatedValue: 2.5)
// anotherThreeDoubles ���ƶ�Ϊ [Double]���ȼ��� [2.5, 2.5, 2.5]
var sixDoubles = threeDoubles + anotherThreeDoubles
// sixDoubles ���ƶ�Ϊ [Double]���ȼ��� [0.0, 0.0, 0.0, 2.5, 2.5, 2.5]

���� Swift �������ƶϻ��ƣ�������������������ֻӵ����ͬ����ֵ�����ʱ�����ǲ��ذ���������Ͷ��������
var shoppingList = ["Eggs", "Milk"]
��Ϊ�����������е�ֵ������ͬ�����ͣ�Swift �����ƶϳ�[String]��shoppinglist�б�������ȷ���͡�
�ȼ���   var shoppingList : [String] = ["Eggs", "Milk"]

��������Ӱ�"Chocolate Spread"��"Cheese"����"Butter"�滻Ϊ"Bananas"�� "Apples"��
shoppingList[4...6] = ["Bananas", "Apples"]

let apples = shoppingList.removeLast()// remove last


let s = String(52) //���ܵ���String(37.5)����������ת���ַ���������ͨ������ķ���ʵ��
let s = "\(37.5)"      //ͨ�����������toInt()����ʵ���ַ����͸�����֮����໥ת����
�������ü���\(���ʽ)����"\(���ʽ)"��������ʽ���Զ��Ա��ʽ��ֵ��ת��Ϊ�ַ�����ʽ��

for (index, value) in shoppingList.enumerate() {
    print("Item \(String(index + 1)): \(value)")
}
// Item 1: Six eggs
// Item 2: Milk
// Item 3: Flour
// Item 4: Baking Powder
// Item 5: Bananas

var namesOfIntegers = [Int: String]()
// namesOfIntegers ��һ���յ� [Int: String] �ֵ�

if let oldValue = airports.updateValue("Dublin Airport", forKey: "DUB") {
    print("The old value for DUB was \(oldValue).")
}
// ��� "The old value for DUB was Dublin." ���ظ���ֵǰ��ԭֵ�����������жϸ����Ƿ�ɹ���

removeValueForKey(_:)����Ҳ�����������ֵ����Ƴ���ֵ�ԡ���������ڼ�ֵ�Դ��ڵ�����»��Ƴ��ü�ֵ�Բ��ҷ��ر��Ƴ���ֵ������û��ֵ������·���nil

if #available(iOS 9, OSX 10.10, *) {
    // �� iOS ʹ�� iOS 9 �� API, �� OS X ʹ�� OS X v10.10 �� API
} else {
    // ʹ����ǰ�汾�� iOS �� OS X �� API
}

//��ȡ"/"�ָ����ַ��������һ����
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

����
Debugging Aid
Intentionally crash your program if some condition is not true (and give a message)
assert(() -> Bool, "message")   //They basically take a closure as the first argument.(����һ���հ���Ϊ��һ������)
�����һ��������ֵ��Ϊ�棬�ڶ����������ַ��������ڿ���̨���������Ӧ���ǳ����ģ����������ᵼ�³������
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
let reversed: Array = reverse(aCollection)//���ط�ת������
let backwardsString = String(reverse(s))//ͨ�������½�

[guard]
guard����if����е����ƣ����Ǹ�����ؼ���֮��ı��ʽ�Ĳ���ֵ������һ��ִ��ʲô������if��䲻ͬ���ǣ�guard���ֻ����һ������飬����if������if else�������顣
func checkup(person: [String: String!]) {
   
    // ������֤��������֤û�������ܽ��뿼��
    guard let id = person["id"] else {
        print("û�����֤�����ܽ��뿼��!")
        return
    }
    print("\(id)")    
    }
}
guard�ж���ĳ���id����������������������ʹ�ã������ǽ����ġ�

[�����ű�]
�����ű����Զ����� class/struct/enum �У�������Ϊ�Ƿ��ʶ��󡢼��ϡ����еĿ�ݷ�ʽ������Ҫ����ʵ�����ض��ĸ�ֵ�ͷ��ʷ�����
����ͬһ��Ŀ����Զ����������ű���ͨ������ֵ���͵Ĳ�ͬ���������أ���������ֵ�����Ƕ����
��ʵ��������ͬ���ǣ������ű������趨��д��ֻ����
subscript(index: Int) -> Int {
  get {
    // ����
  }
  set(newValue) {
    // newVale�����ͱ���͸����ű�����ķ���������ͬ�������newValue���㲻д����set��������Ȼ����ֱ��ʹ��Ĭ�ϵ�newValue������������ֵ��
  }
}

subscript(index: Int) -> Int {
  // ���������ƥ���Int���͵�ֵ
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

ͨ�� `.dynamicType` ����ȡһ������Ķ�̬���ͣ�Ҳ��������ʱ��ʵ�����ͣ����Ǳ���ʱָ�������͡�
let string = "Hello"
let name = string.dynamicType
println(name)
// �����
// Swift.String
ע�⣺1. ��Swift�У�������Ȼ����ͨ��denamicType����ȡһ������Ķ�̬���ͣ���ʹ���У�Swift���ڲ��ܸ��ݶ����ڶ�̬ʱ�����ͽ��к��ʵ����ط������á�
2. ���÷���ʱ��swift������βε����������������ĸ����������������ʵ�ε����������ö�Ӧ�ķ�������ΪSwiftĬ���ǲ����ö�̬�ɷ��ģ����Է����ĵ���ֻ���ڱ���ʱ����������Ҫ�ƹ��������ʱ������Ҫ���βε����ͽ����жϺ�ת�����������
func printThemAgain(pet: Pet, _ cat: Cat) {
    if let aCat = pet as? Cat {
        printPet(aCat)
    } else if let aDog = pet as? Dog {
        printPet(aDog)
    }
    printPet(cat)
}
printThemAgain(Dog(), Cat())
// �����
// Bark
// Meow

.Type ��ʾ����ĳ�����͵�Ԫ���ͣ����� Swift �У����� `class`��`struct` �� `enum` �����������⣬���ǻ����Զ��� `protocol`��

���� `protocol` ��˵����ʱ������Ҳ����ȡ�ýӿڵ�Ԫ���͡���ʱ���ǿ�����ĳ�� `protocol` �����ֺ���ʹ�� .Protocol ����ȡ��ʹ�õķ����� .Type �����Ƶġ�


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

Swift �ı��˼�룺��forѭ����if-let���ߣ��滻��map��flatmap��


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
--��Ч��
extension Array {
    func objectsOfType<T>(type:T.Type) -> [T] {
        return flatMap { $0 as? T }
    }
}
let filteredArray1 = myStructs.objectsOfType(TypeA.self)
// --
weak and unowned
unowned ������ǰ�� unsafe_unretained���� weak ������ǰ�� weak
unowned �����Ժ�ʹ��ԭ�����õ������Ѿ����ͷ��ˣ�����Ȼ�ᱣ�ֶԱ��Ѿ��ͷ��˵Ķ����һ�� "��Ч��" ���ã��������� Optional ֵ��Ҳ���ᱻָ�� nil��
�����Ϊ @weak �ı���һ����Ҫ�� Optional ֵ
��������ʹ�õ�ѡ��Apple �����ǵĽ���������ܹ�ȷ���ڷ���ʱ�����ѱ��ͷŵĻ�������ʹ�� unowned��������ڱ��ͷŵĿ��ܣ��Ǿ�ѡ���� weak��

[defer]
defer {
    print("1111")
}
defer���������ڵĿ����������֮ǰ���У�returnִ��֮��ִ�С�
���defer��������ѹ��ר���ڿ�Ķ�ջ�У�����ʱpop��ִ�С�

// swift ��ô�ж��Ƿ�ΪBoolֵ







// ���� �� ֻ��Ҫ��֤һ��������������ͣ�����һ����������������ƥ�伴�ɡ�
func funcBuild<T, U, V>(f: T -> U, _ g: V -> T)
    -> V -> U {
        return {
            f(g($0))
        }
}
let f3 = funcBuild({ "No." + String($0) }, {$0 * 2})
f3(23) // ����� "No.46"





