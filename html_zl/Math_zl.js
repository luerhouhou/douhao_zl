[Math 对象]
Math对象是JavaScript的内置对象，提供一系列数学常数和数学方法。该对象不是构造函数，所以不能生成实例，所有的属性和方法都必须在Math对象上调用。

Math对象提供以下一些只读的数学常数。

E：常数e。
LN2：2的自然对数。
LN10：10的自然对数。
LOG2E：以2为底的e的对数。
LOG10E：以10为底的e的对数。
PI：常数Pi。
SQRT1_2：0.5的平方根。
SQRT2：2的平方根。

Math.E // 2.718281828459045
Math.LN2 // 0.6931471805599453
Math.LN10 // 2.302585092994046
Math.LOG2E // 1.4426950408889634
Math.LOG10E // 0.4342944819032518
Math.PI // 3.141592653589793
Math.SQRT1_2 // 0.7071067811865476
Math.SQRT2 // 1.4142135623730951

[数学方法]

1. Math.round 方法用于四舍五入。
Math.round(0.1) // 0
Math.round(0.5) // 1
它对于负值的运算结果与正值略有不同，主要体现在对0.5的处理。
Math.round(-1.1) // -1
Math.round(-1.5) // -1

2. Math.abs 方法返回参数值的绝对值。

Math.abs(1) // 1
Math.abs(-1) // 1
3. Math.max 方法返回最大的参数，Math.min 方法返回最小的参数。

Math.max(2, -1, 5) // 5
Math.min(2, -1, 5) // -1

4. Math.floor方法返回小于等于参数值的最大整数。
Math.floor(3.2) // 3
Math.floor(-3.2) // -4
   Math.ceil方法返回大于等于参数值的最小整数。
Math.ceil(3.2) // 4
Math.ceil(-3.2) // -3

5. Math.pow 方法返回以第一个参数为底数、第二个参数为幂的指数值。
Math.pow(2, 2) // 4
Math.pow(2, 3) // 8
   Math.sqrt 方法返回参数值的平方根。如果参数是一个负值，则返回NaN。
Math.sqrt(4) // 2
Math.sqrt(-4) // NaN

6. log方法返回以e为底的自然对数值。
Math.log(Math.E) // 1
Math.log(10) // 2.302585092994046
   求以10为底的对数，可以除以Math.LN10；求以2为底的对数，可以除以Math.LN2。
Math.log(100)/Math.LN10 // 2
Math.log(8)/Math.LN2 // 3
   exp方法返回常数e的参数次方。
Math.exp(1) // 2.718281828459045
Math.exp(3) // 20.085536923187668

7. random方法 // 该方法返回0到1之间的一个伪随机数，可能等于0，但是一定小于1。
Math.random() // 0.7151307314634323
// 返回给定范围内的随机数
function getRandomArbitrary(min, max) {
  return Math.random() * (max - min) + min;
}
// 返回给定范围内的随机整数
function getRandomInt(min, max) {
  return Math.floor(Math.random() * (max - min + 1) + min);
}

下面是返回随机字符的例子。
var ALPHABET = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_';
random_base64 = function random_base64(length) {
  var str = "";
  for (var i=0; i < length; ++i) {
    var rand = Math.floor(Math.random() * ALPHABET.length);
    str += ALPHABET.substring(rand, rand+1);
  }
  return str;
}
上面代码中，函数random_base64可以在给定范围ALPHABET之中，返回一个随机字符。

8. 三角函数方法
sin方法返回参数的正弦，cos方法返回参数的余弦，tan方法返回参数的正切。
Math.sin(0) // 0
Math.cos(0) // 1
Math.tan(0) // 0
asin方法返回参数的反正弦，acos方法返回参数的反余弦，atan方法返回参数的反正切。这个三个方法的返回值都是弧度值。
Math.asin(1) // 1.5707963267948966
Math.acos(1) // 0
Math.atan(1) // 0.7853981633974483

9. Math.trunc 方法用于去除一个数的小数部分，返回整数部分。
Math.trunc(4.1) // 4
Math.trunc(4.9) // 4
Math.trunc(-4.1) // -4
Math.trunc(-4.9) // -4
Math.trunc(-0.1234) // -0
对于非数值，Math.trunc内部使用Number方法将其先转为数值。
Math.trunc('123.456')
// 123
对于空值和无法截取整数的值，返回NaN。
Math.trunc(NaN);      // NaN
Math.trunc('foo');    // NaN
Math.trunc();         // NaN
对于没有部署这个方法的环境，可以用下面的代码模拟。
Math.trunc = Math.trunc || function(x) {
  return x < 0 ? Math.ceil(x) : Math.floor(x);
}

10. Math.sign方法用来判断一个数到底是正数、负数、还是零。
它会返回五种值。
    参数为正数，返回+1；
    参数为负数，返回-1；
    参数为0，返回0；
    参数为-0，返回-0;
    其他值，返回NaN。
Math.sign(-5) // -1
Math.sign(5) // +1
Math.sign(0) // +0
Math.sign(-0) // -0
Math.sign(NaN) // NaN
Math.sign('foo'); // NaN
Math.sign();      // NaN
对于没有部署这个方法的环境，可以用下面的代码模拟。
Math.sign = Math.sign || function(x) {
  x = +x; // convert to a number
  if (x === 0 || isNaN(x)) {
    return x;
  }
  return x > 0 ? 1 : -1;
}

11. Math.cbrt方法用于计算一个数的立方根。
Math.cbrt(-1) // -1
Math.cbrt(0)  // 0
Math.cbrt(1)  // 1
Math.cbrt(2)  // 1.2599210498948734
对于非数值，Math.cbrt方法内部也是先使用Number方法将其转为数值。
Math.cbrt('8') // 2
Math.cbrt('hello') // NaN
对于没有部署这个方法的环境，可以用下面的代码模拟。
Math.cbrt = Math.cbrt || function(x) {
  var y = Math.pow(Math.abs(x), 1/3);
  return x < 0 ? -y : y;
};

12. 待续 。。。
