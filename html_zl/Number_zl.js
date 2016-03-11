[JS Number 对象]

当 Number() 和运算符 new 一起作为构造函数使用时，它返回一个新创建的 Number 对象。如果不用 new 运算符，把 Number() 作为一个函数来调用，它将把自己的参数转换成一个原始的数值，并且返回这个值（如果转换失败，则返回 NaN）。

Number对象是数值对应的包装对象，可以作为构造函数使用，也可以作为工具函数使用。
作为构造函数时，它用于生成值为数值的对象。
var n = new Number(1);
typeof n // "object"
// 上面代码中，Number对象作为构造函数使用，返回一个值为1的对象。

作为工具函数时，它可以将任何类型的值转为数值。
Number(true) // 1
// 上面代码将布尔值true转为数值1。

Number.POSITIVE_INFINITY：正的无限，指向Infinity。
Number.NEGATIVE_INFINITY：负的无限，指向-Infinity。
Number.NaN：表示非数值，指向NaN。
Number.MAX_VALUE：表示最大的正数，相应的，最小的负数为-Number.MAX_VALUE。
Number.MIN_VALUE：表示最小的正数（即最接近0的正数，在64位浮点数体系中为5e-324），相应的，最接近0的负数为-Number.MIN_VALUE。
Number.MAX_SAFE_INTEGER：表示能够精确表示的最大整数，即9007199254740991。
Number.MIN_SAFE_INTEGER：表示能够精确表示的最小整数，即-9007199254740991。


Number.isFinite() // 用来检查一个数值是否非无穷（infinity）。
Number.isFinite(15); // true
Number.isFinite(0.8); // true
Number.isFinite(NaN); // false
Number.isFinite(Infinity); // false
Number.isFinite(-Infinity); // false
Number.isFinite('foo'); // false
Number.isFinite('15'); // false
Number.isFinite(true); // false

Number.isNaN() // 用来检查一个值是否为NaN。
Number.isNaN(NaN) // true
Number.isNaN(15) // false
Number.isNaN('15') // false
Number.isNaN(true) // false
Number.isNaN(9/NaN) // true
Number.isNaN('true'/0) // true
Number.isNaN('true'/'true') // true

// 传统方法先调用Number()将非数值的值转为数值，再进行判断，而这两个新方法只对数值有效，非数值一律返回false。

实例方法
1. Number.prototype.toString()
(10).toString(2) // "1010" 将10转为2进制，整数记得加括号。
10.5.toString(2) // "1010.1"，小数可以直接调用toString.
10['toString'](2) // "1010"，也可以使用方括号调用。

2. Number.prototype.parseInt() // 将其他进制的数，转回十进制

3. Number.prototype.toFixed() // 将一个数转为指定位数的小数。
(10).toFixed(2)
// "10.00"
// 10必须放在括号里，否则后面的点运算符会被处理小数点，而不是表示调用对象的方法。
(10.005).toFixed(2)
// "10.01" 
toFixed方法的参数为小数的位数，有效范围为0到20，超出这个范围将抛出RangeError错误。
4. Number.prototype.toExponential()
toExponential方法用于将一个数转为科学计数法形式。
(10).toExponential(1)
// "1.0e+1"
(1234).toExponential(1)
// "1.2e+3"
toExponential方法的参数表示小数点后有效数字的位数，范围为0到20，超出这个范围，会抛出一个RangeError。
5. Number.prototype.toPrecision()
toPrecision方法用于将一个数转为指定位数的有效数字。
(12.34).toPrecision(1) // "1e+1"
(12.34).toPrecision(2) // "12"
(12.34).toPrecision(3) // "12.3"
(12.34).toPrecision(4) // "12.34"
(12.34).toPrecision(5) // "12.340"
toPrecision方法的参数为有效数字的位数，范围是1到21，超出这个范围会抛出RangeError错误。
toPrecision方法用于四舍五入时不太可靠，跟浮点数不是精确储存有关。
(12.35).toPrecision(3) // "12.3"
(12.25).toPrecision(3) // "12.3"
(12.15).toPrecision(3) // "12.2"
(12.45).toPrecision(3) // "12.4"

6. Number.parseInt() 函数// 可解析一个字符串，并返回一个整数。
7. Number.parseInt() 函数// 可解析一个字符串，并返回一个整数。
ES6将全局方法parseInt()和parseFloat()，移植到Number对象上面，行为完全保持不变。
// ES5的写法
parseInt('12.34') // 12
parseFloat('123.45#') // 123.45
// ES6的写法
Number.parseInt('12.34') // 12
Number.parseFloat('123.45#') // 123.45
这样做的目的，是逐步减少全局性方法，使得语言逐步模块化。

8. Number.isInteger() // 用来判断一个值是否为整数。需要注意的是，在JavaScript内部，整数和浮点数是同样的储存方法，所以3和3.0被视为同一个值。
Number.isInteger(25) // true
Number.isInteger(25.0) // true
Number.isInteger(25.1) // false
Number.isInteger("15") // false
Number.isInteger(true) // false

9. Number.EPSILON // ES6在Number对象上面，新增一个极小的常量Number.EPSILON。
Number.EPSILON
// 2.220446049250313e-16
Number.EPSILON.toFixed(20)
// '0.00000000000000022204'
引入一个这么小的量的目的，在于为浮点数计算，设置一个误差范围。我们知道浮点数计算是不精确的。
0.1 + 0.2
// 0.30000000000000004
0.1 + 0.2 - 0.3
// 5.551115123125783e-17
5.551115123125783e-17.toFixed(20)
// '0.00000000000000005551'
但是如果这个误差能够小于Number.EPSILON，我们就可以认为得到了正确结果。
5.551115123125783e-17 < Number.EPSILON
// true
因此，Number.EPSILON的实质是一个可以接受的误差范围。
function withinErrorMargin (left, right) {
  return Math.abs(left - right) < Number.EPSILON
}
withinErrorMargin(0.1 + 0.2, 0.3)
// true
withinErrorMargin(0.2 + 0.2, 0.3)
// false
上面的代码为浮点数运算，部署了一个误差检查函数。

10. Number.isSafeInteger() // 用来判断一个整数是否落在安全范围之内。
ES6引入了Number.MAX_SAFE_INTEGER和Number.MIN_SAFE_INTEGER这两个常量，用来表示这个范围的上下限。
注意，验证运算结果是否落在安全整数的范围时，不要只验证运算结果，而要同时验证参与运算的每个值。
Number.isSafeInteger(9007199254740993)
// false
Number.isSafeInteger(990)
// true
Number.isSafeInteger(9007199254740993 - 990)
// true
9007199254740993 - 990
// 返回结果 9007199254740002
// 正确答案应该是 9007199254740003
上面代码中，9007199254740993不是一个安全整数，但是Number.isSafeInteger会返回结果，显示计算结果是安全的。这是因为，这个数超出了精度范围，导致在计算机内部，以9007199254740992的形式储存。
9007199254740993 === 9007199254740992
// true
所以，如果只验证运算结果是否为安全整数，很可能得到错误结果。下面的函数可以同时验证两个运算数和运算结果。

[自定义方法]
// 添加自定义方法 add
Number.prototype.add = function (x) {
    return this + x;
}
(8).add(2) // 10

8['add'](2) // 10

Number.prototype.subtract = function (x) {
    return this - x;
};
(8).add(2).subtract(4) // 6 链式调用自定义方法

注意：数值的自定义方法，只能定义在它的原型对象Number.prototype上面，数值本身是无法自定义属性的。

[二进制和八进制表示法]
ES6提供了二进制和八进制数值的新的写法，分别用前缀0b（或0B）和0o（或0O）表示。
0b111110111 === 503 // true
0o767 === 503 // true

