[JavaScript 变量]
JavaScript 拥有动态类型。这意味着相同的变量可用作不同的类型：
var x                // x 为 undefined
var x = 6;           // x 为数字
var x = "Bill";      // x 为字符串
字符串可以是引号中的任意文本。您可以使用单引号或双引号，可以在字符串中使用引号，只要不匹配包围字符串的引号即可：
var answer="Nice to meet you!";
var answer="He is called 'Bill'";
var answer='He is called "Bill"';

布尔（逻辑）只能有两个值：true 或 false。

var x=true
var y=false

[JavaScript 数组]

-1. var cars=new Array();
cars[0]="Audi";
cars[1]="BMW";
cars[2]="Volvo";
或者 (condensed array):
-2. var cars=new Array("Audi","BMW","Volvo");
或者 (literal array):
-3. var cars=["Audi","BMW","Volvo"];
//当把构造函数作为函数调用，不使用 new 运算符时，它的行为与使用 new 运算符调用它时的行为完全一样。
-4. var cars=new Array(5);//当调用构造函数时只传递给它一个数字参数，该构造函数将返回具有指定个数、元素为 undefined 的数组。

-[Array 对象属性]
constructor //返回对创建此对象的数组函数的引用。就是new后面那个

length  //设置或返回数组中元素的数目。

prototype  // 使您有能力向对象添加属性和方法。
<script type="text/javascript">

function employee(name,job,born)
{
this.name=name;
this.job=job;
this.born=born;
}
var bill=new employee("Bill Gates","Engineer",1985);
employee.prototype.salary=null;//添加属性
bill.salary=20000;
document.write(bill.salary);//输出20000
</script>

let [foo, [[bar], baz]] = [1, [[2], 3]];
foo // 1
bar // 2
baz // 3

let [ , , third] = ["foo", "bar", "baz"];
third // "baz"

let [x, , y] = [1, 2, 3];
x // 1
y // 3

let [head, ...tail] = [1, 2, 3, 4];
head // 1
tail // [2, 3, 4]

let [x, y, ...z] = ['a'];
x // "a"
y // undefined
z // []


[Array 对象方法]
concat()   // 连接两个或更多的数组，并返回结果。该方法不会改变现有的数组，而仅仅会返回被连接数组的一个副本。

把 concat() 中的参数连接到数组 a 中：
var a = [1,2,3];
document.write(a.concat(4,5));

创建了三个数组，然后使用 concat() 把它们连接起来：
var arr = new Array(3)
arr[0] = "George"
arr[1] = "John"
arr[2] = "Thomas"
var arr2 = new Array(3)
arr2[0] = "James"
arr2[1] = "Adrew"
arr2[2] = "Martin"
var arr3 = new Array(2)
arr3[0] = "William"
arr3[1] = "Franklin"
document.write(arr.concat(arr2,arr3))

join() // 把数组的所有元素放入一个字符串。元素通过指定的分隔符进行分隔。
arrayObject.join(separator)
separator   可选。指定要使用的分隔符。如果省略该参数，则使用逗号作为分隔符

pop()  // 删除并返回数组的最后一个元素
pop() 方法将删除 arrayObject 的最后一个元素，把数组长度减 1，并且返回它删除的元素的值。如果数组已经为空，则 pop() 不改变数组，并返回 undefined 值。

push()  //向数组的末尾添加一个或更多元素，并返回新的长度。
push() 方法可把它的参数顺序添加到 arrayObject 的尾部。它直接修改 arrayObject，而不是创建一个新的数组。push() 方法和 pop() 方法使用数组提供的先进后出栈的功能。

reverse()  //颠倒数组中元素的顺序。
注释：该方法会改变原来的数组，而不会创建新的数组。

shift()    //删除并返回数组的第一个元素
如果数组是空的，那么 shift() 方法将不进行任何操作，返回 undefined 值。请注意，该方法不创建新数组，而是直接修改原有的 arrayObject。

slice()    //从某个已有的数组返回选定的元素
arrayObject.slice(start,end)
start   //必需。规定从何处开始选取。如果是负数，那么它规定从数组尾部开始算起的位置。也就是说，-1 指最后一个元素，-2 指倒数第二个元素，以此类推。
end     //可选。规定从何处结束选取。该参数是数组片断结束处的数组下标。如果没有指定该参数，那么切分的数组包含从 start 到数组结束的所有元素。如果这个参数是负数，那么它规定的是从数组尾部开始算起的元素。

返回一个新的数组，包含从 start 到 end （不包括该元素）的 arrayObject 中的元素。
说明

请注意，该方法并不会修改数组，而是返回一个子数组。如果想删除数组中的一段元素，应该使用方法 Array.splice()。

sort()  //对数组的元素进行排序
arrayObject.sort(sortby)
sortby  //可选。规定排序顺序。必须是函数。
请注意，数组在原数组上进行排序，不生成副本。

如果调用该方法时没有使用参数，将按字母顺序对数组中的元素进行排序，说得更精确点，是按照字符编码的顺序进行排序。要实现这一点，首先应把数组的元素都转换成字符串（如有必要），以便进行比较。
如果想按照其他标准进行排序，就需要提供比较函数，该函数要比较两个值，然后返回一个用于说明这两个值的相对顺序的数字。比较函数应该具有两个参数 a 和 b，其返回值如下：
    若 a 小于 b，在排序后的数组中 a 应该出现在 b 之前，则返回一个小于 0 的值。
    若 a 等于 b，则返回 0。
    若 a 大于 b，则返回一个大于 0 的值。

splice()    //删除元素，并向数组添加新元素。然后返回被删除的项目。
arrayObject.splice(index,howmany,item1,.....,itemX)
index   //必需。整数，规定添加/删除项目的位置，使用负数可从数组结尾处规定位置。
howmany     //必需。要删除的项目数量。如果设置为 0，则不会删除项目。
item1, ..., itemX   //可选。向数组添加的新项目。

splice() 方法可删除从 index 处开始的零个或多个元素，并且用参数列表中声明的一个或多个值来替换那些被删除的元素。
如果从 arrayObject 中删除了元素，则返回的是含有被删除的元素的数组。

注释：请注意，splice() 方法与 slice() 方法的作用是不同的，splice() 方法会直接对数组进行修改。

toSource()  //返回该对象的源代码。
只有Firefox支持改方法

toString()  //把数组转换为字符串，并返回结果。
返回值: arrayObject 的字符串表示。返回值与没有参数的 join() 方法返回的字符串相同。
当数组用于字符串环境时，JavaScript 会调用这一方法将数组自动转换成字符串。但是在某些情况下，需要显式地调用该方法。数组中的元素之间用逗号分隔。

toLocaleString()    //把数组转换为本地数组，并返回结果。
返回值
arrayObject 的本地字符串表示。
说明
首先调用每个数组元素的 toLocaleString() 方法，然后使用地区特定的分隔符把生成的字符串连接起来，形成一个字符串。

unshift()   //向数组的开头添加一个或更多元素，并返回新的长度。
请注意，unshift() 方法不创建新的创建，而是直接修改原有的数组。
注释：该方法会改变数组的长度。
注释：unshift() 方法无法在 Internet Explorer 中正确地工作！
提示：要把一个或多个元素添加到数组的尾部，请使用 push() 方法。

valueOf()   //返回数组对象的原始值
valueOf() 方法返回 Array 对象的原始值。
该原始值由 Array 对象派生的所有对象继承。
valueOf() 方法通常由 JavaScript 在后台自动调用，并不显式地出现在代码中。

[JS Boolean 对象]
"true" 或 "false"。

返回值:
-1. 当作为一个构造函数（带有运算符 new）调用时，Boolean() 将把它的参数转换成一个布尔值，并且返回一个包含该值的 Boolean 对象。
-2. 如果作为一个函数（不带有运算符 new）调用时，Boolean() 只将把它的参数转换成一个原始的布尔值，并且返回这个值。
-3. 注释：如果省略 value 参数，或者设置为 0、-0、null、""、false、undefined 或 NaN，则该对象设置为 false。否则设置为 true（即使 value 参数是字符串 "false"）。

[JS Date 对象]
var myDate=new Date() // Date 对象会自动把当前日期和时间保存为其初始值。

//-----
Date()  //返回当日的日期和时间。
getDate()   //从 Date 对象返回一个月中的某一天 (1 ~ 31)。
getDay()    //从 Date 对象返回一周中的某一天 (0 ~ 6)。
getMonth()  //从 Date 对象返回月份 (0 ~ 11)。
getFullYear()   //从 Date 对象以四位数字返回年份。
getYear()   //请使用 getFullYear() 方法代替。
getHours()  返回 Date 对象的小时 (0 ~ 23)。
getMinutes()    返回 Date 对象的分钟 (0 ~ 59)。
getSeconds()    返回 Date 对象的秒数 (0 ~ 59)。
getMilliseconds()   返回 Date 对象的毫秒(0 ~ 999)。
getTime()   返回 1970 年 1 月 1 日至今的毫秒数。
getTimezoneOffset()     返回本地时间与格林威治标准时间 (GMT) 的分钟差。
getUTCDate()    根据世界时从 Date 对象返回月中的一天 (1 ~ 31)。
getUTCDay()     根据世界时从 Date 对象返回周中的一天 (0 ~ 6)。
getUTCMonth()   根据世界时从 Date 对象返回月份 (0 ~ 11)。
getUTCFullYear()    根据世界时从 Date 对象返回四位数的年份。
getUTCHours()   根据世界时返回 Date 对象的小时 (0 ~ 23)。
getUTCMinutes()     根据世界时返回 Date 对象的分钟 (0 ~ 59)。
getUTCSeconds()     根据世界时返回 Date 对象的秒钟 (0 ~ 59)。
getUTCMilliseconds()    根据世界时返回 Date 对象的毫秒(0 ~ 999)。
parse()     返回1970年1月1日午夜到指定日期（字符串）的毫秒数。
setDate()   设置 Date 对象中月的某一天 (1 ~ 31)。
setMonth()  设置 Date 对象中月份 (0 ~ 11)。
setFullYear()   设置 Date 对象中的年份（四位数字）。
setYear()   请使用 setFullYear() 方法代替。
setHours()  设置 Date 对象中的小时 (0 ~ 23)。
setMinutes()    设置 Date 对象中的分钟 (0 ~ 59)。
setSeconds()    设置 Date 对象中的秒钟 (0 ~ 59)。
setMilliseconds()   设置 Date 对象中的毫秒 (0 ~ 999)。
setTime()   以毫秒设置 Date 对象。
setUTCDate()    根据世界时设置 Date 对象中月份的一天 (1 ~ 31)。
setUTCMonth()   根据世界时设置 Date 对象中的月份 (0 ~ 11)。
setUTCFullYear()    根据世界时设置 Date 对象中的年份（四位数字）。
setUTCHours()   根据世界时设置 Date 对象中的小时 (0 ~ 23)。
setUTCMinutes()     根据世界时设置 Date 对象中的分钟 (0 ~ 59)。
setUTCSeconds()     根据世界时设置 Date 对象中的秒钟 (0 ~ 59)。
setUTCMilliseconds()    根据世界时设置 Date 对象中的毫秒 (0 ~ 999)。
toSource()  返回该对象的源代码。
toString()  把 Date 对象转换为字符串。
toTimeString()  把 Date 对象的时间部分转换为字符串。
toDateString()  把 Date 对象的日期部分转换为字符串。
toGMTString()   请使用 toUTCString() 方法代替。
toUTCString()   根据世界时，把 Date 对象转换为字符串。
toLocaleString()    根据本地时间格式，把 Date 对象转换为字符串。
toLocaleTimeString()    根据本地时间格式，把 Date 对象的时间部分转换为字符串。
toLocaleDateString()    根据本地时间格式，把 Date 对象的日期部分转换为字符串。
UTC()   根据世界时返回 1970 年 1 月 1 日 到指定日期的毫秒数。
valueOf()   返回 Date 对象的原始值。
//-----

[JS Math 对象]
使用 Math 的属性和方法的语法：
var pi_value=Math.PI;
var sqrt_value=Math.sqrt(15);

[Math 对象属性]
E   返回算术常量 e，即自然对数的底数（约等于2.718）。
LN2     返回 2 的自然对数（约等于0.693）。
LN10    返回 10 的自然对数（约等于2.302）。
LOG2E   返回以 2 为底的 e 的对数（约等于 1.414）。
LOG10E  返回以 10 为底的 e 的对数（约等于0.434）。
PI  返回圆周率（约等于3.14159）。
SQRT1_2     返回返回 2 的平方根的倒数（约等于 0.707）。
SQRT2   返回 2 的平方根（约等于 1.414）。

[Math 对象方法]
abs(x)  返回数的绝对值。
acos(x)     返回数的反余弦值。
asin(x)     返回数的反正弦值。
atan(x)     以介于 -PI/2 与 PI/2 弧度之间的数值来返回 x 的反正切值。
atan2(y,x)  返回从 x 轴到点 (x,y) 的角度（介于 -PI/2 与 PI/2 弧度之间）。
ceil(x)     对数进行上舍入。
cos(x)  返回数的余弦。
exp(x)  返回 e 的指数。
floor(x)    对数进行下舍入。
log(x)  返回数的自然对数（底为e）。
max(x,y)    返回 x 和 y 中的最高值。
min(x,y)    返回 x 和 y 中的最低值。
pow(x,y)    返回 x 的 y 次幂。
random()    返回 0 ~ 1 之间的随机数。
round(x)    把数四舍五入为最接近的整数。
sin(x)  返回数的正弦。
sqrt(x)     返回数的平方根。
tan(x)  返回角的正切。
toSource()  返回该对象的源代码。
valueOf()   返回 Math 对象的原始值。

[JS Number 对象]

当 Number() 和运算符 new 一起作为构造函数使用时，它返回一个新创建的 Number 对象。如果不用 new 运算符，把 Number() 作为一个函数来调用，它将把自己的参数转换成一个原始的数值，并且返回这个值（如果转换失败，则返回 NaN）。

[String 对象]
字符串是 JavaScript 的一种基本的数据类型。

String 对象的 length 属性声明了该字符串中的字符数。

String 类定义了大量操作字符串的方法，例如从字符串中提取字符或子串，或者检索字符或子串。

需要注意的是，JavaScript 的字符串是不可变的（immutable），String 类定义的方法都不能改变字符串的内容。像 String.toUpperCase() 这样的方法，返回的是全新的字符串，而不是修改原始字符串。

在较早的 Netscape 代码基的 JavaScript 实现中（例如 Firefox 实现中），字符串的行为就像只读的字符数组。例如，从字符串 s 中提取第三个字符，可以用 s[2] 代替更加标准的 s.charAt(2)。此外，对字符串应用 for/in 循环时，它将枚举字符串中每个字符的数组下标（但要注意，ECMAScript 标准规定，不能枚举 length 属性）。因为字符串的数组行为不标准，所以应该避免使用它。

var s = 'fdsa'
s.codePointAt(0); // codePointAt方法会正确返回32位的UTF-16字符的码点。对于那些两个字节储存的常规字符，它的返回结果与charCodeAt方法相同。
s.charCodeAt(2);
// 连接字符，原字符串不受影响，返回一个新字符串。
'a'.concat('b','c') // "abc"

// 检测一个字符是由两个字节还是四个字节组成：
function is32Bit(c) {
  return c.codePointAt(0) > 0xFFFF;
}
is32Bit("𠮷") // true
is32Bit("a") // false


// --[这三个方法都用来返回一个字符串的子串，而不会改变原字符串。它们都可以接受一个或两个参数，区别只是参数含义的不同。]

// substring方法的第一个参数表示子字符串的开始位置，第二个位置表示结束结果。因此，第二个参数应该大于第一个参数。如果出现第一个参数大于第二个参数的情况，substring方法会自动更换两个参数的位置。
var a = 'The Three Musketeers';
a.substring(4, 9) // 'Three'
a.substring(9, 4) // 'Three'

// substr方法的第一个参数是子字符串的开始位置，第二个参数是子字符串的长度。
var b = 'The Three Musketeers';
b.substr(4, 9) // 'Three Mus'
b.substr(9, 4) // ' Mus'

// slice方法的第一个参数是子字符串的开始位置，第二个参数是子字符串的结束位置。与substring方法不同的是，如果第一个参数大于第二个参数，slice方法并不会自动调换参数位置，而是返回一个空字符串。
var c = 'The Three Musketeers';
c.slice(4, 9) // 'Three'
c.slice(9, 4) // ''

总结：第一个参数的含义

对这三个方法来说，第一个参数都是子字符串的开始位置，如果省略第二个参数，则表示子字符串一直持续到原字符串结束。

"Hello World".slice(3)
// "lo World"

"Hello World".substr(3)
// "lo World"

"Hello World".substring(3)
// "lo World"

（5）总结：第二个参数的含义

如果提供第二个参数，对于slice和substring方法，表示子字符串的结束位置；对于substr，表示子字符串的长度。

"Hello World".slice(3,7)
// "lo W"

"Hello World".substring(3,7)
// "lo W"

"Hello World".substr(3,7)
// "lo Worl"

总结：负的参数

如果参数为负，对于slice方法，表示字符位置从尾部开始计算。
"Hello World".slice(-3)
// "rld"

"Hello World".slice(4,-3)
// "o Wo"

对于substring方法，会自动将负数转为0。
"Hello World".substring(-3)
// "Hello World"

"Hello World".substring(4,-3)
// "Hell"

对于substr方法，负数出现在第一个参数，表示从尾部开始计算的字符位置；负数出现在第二个参数，将被转为0。
"Hello World".substr(-3)
// "rld"

"Hello World".substr(4,-3)
// ""

indexOf 和 lastIndexOf 方法
这两个方法用于确定一个字符串在另一个字符串中的位置，如果返回-1，就表示不匹配。两者的区别在于，indexOf从字符串头部开始匹配，lastIndexOf从尾部开始匹配。
"hello world".indexOf("o")
// 4
"hello world".lastIndexOf("o")
// 7

它们还可以接受第二个参数，对于indexOf，表示从该位置开始向后匹配；对于lastIndexOf，表示从该位置起向前匹配。
"hello world".indexOf("o", 6)
// 7
"hello world".lastIndexOf("o", 6)
// 4

trim 方法

该方法用于去除字符串两端的空格。
"  hello world  ".trim()
// "hello world"
该方法返回一个新字符串，不改变原字符串。

toLowerCase用于将一个字符串转为小写，toUpperCase则是转为大写。
"Hello World".toLowerCase()
// "hello world"
"Hello World".toUpperCase()
// "HELLO WORLD"

localeCompare方法用于比较两个字符串。它返回一个数字，如果小于0，表示第一个字符串小于第二个字符串；如果等于0，表示两者相等；如果大于0，表示第一个字符串大于第二个字符串。
'apple'.localeCompare('banana')
// -1
'apple'.localeCompare('apple')
// 0


String对象

String对象是JavaScript原生提供的三个包装对象之一，用来生成字符串的包装对象实例。

var s = new String("abc");

typeof s // "object"
s.valueOf() // "abc"

上面代码生成的变量s，就是String对象的实例，类型为对象，值为原来的字符串。实际上，String对象的实例是一个类似数组的对象。

new String("abc")
// String {0: "a", 1: "b", 2: "c"}

除了用作构造函数，String还可以当作工具方法使用，将任意类型的值转为字符串。

String(true) // "true"
String(5) // "5"

上面代码将布尔值ture和数值5，分别转换为字符串。
String.fromCharCode()

String对象直接提供的方法，主要是fromCharCode()。该方法根据Unicode编码，生成一个字符串。

String.fromCharCode(104, 101, 108, 108, 111)
// "hello"

注意，该方法不支持编号大于0xFFFF的字符。


String.fromCharCode(0x20BB7)
// "ஷ"

上面代码返回字符的编号是0x0BB7，而不是0x20BB7。这种情况下，只能使用四字节的UTF-16编号，得到正确结果。


String.fromCharCode(0xD842, 0xDFB7)
// "𠮷"
    
String.fromCodePoint(), 可以识别0xFFFF的字符，弥补了String.fromCharCode方法的不足。在作用上，正好与codePointAt方法相反。

// ES6为字符串添加了遍历器接口（详见《Iterator》一章），使得字符串可以被for...of循环遍历。
for (let codePoint of 'foo') {
  console.log(codePoint)
}
// "f"
// "o"
// "o"

除了遍历字符串，这个遍历器最大的优点是可以识别大于0xFFFF的码点，传统的for循环无法识别这样的码点。
var text = String.fromCodePoint(0x20BB7);
for (let i = 0; i < text.length; i++) {
  console.log(text[i]);
}
// " "
// " "
for (let i of text) {
  console.log(i);
}
// "𠮷"
上面代码中，字符串text只有一个字符，但是for循环会认为它包含两个字符（都不可打印），而for...of循环会正确识别出这一个字符。


实例对象的属性和方法
length属性

该属性返回字符串的长度。

"abc".length
// 3

charAt 和 charCodeAt 方法

charAt方法返回一个字符串的给定位置的字符，位置从0开始编号。

var s = new String("abc");

s.charAt(1) // "b"
s.charAt(s.length-1) // "c"

这个方法完全可以用数组下标替代。

'abc'[1] // "b"

charCodeAt方法返回给定位置字符的Unicode编码（十进制表示）。

var s = new String("abc");

s.charCodeAt(1)
// 98

需要注意的是，charCodeAt方法返回的Unicode编码不大于65536（0xFFFF），也就是说，只返回两个字节。因此如果遇到Unicode大于65536的字符（根据UTF-16的编码规则，第一个字节在U+D800到U+DBFF之间），就必需连续使用两次charCodeAt，不仅读入charCodeAt(i)，还要读入charCodeAt(i+1)，将两个16字节放在一起，才能得到准确的字符。

如果给定位置为负数，或大于等于字符串的长度，则这两个方法返回NaN。

ES6 提供 String.at() 方法。可以识别Unicode编号大于0xFFFF的字符，返回正确的字符。
'abc'.at(0) // "a"
'𠮷'.at(0) // "𠮷"

ES6提供字符串实例的normalize()方法，用来将字符的不同表示方法统一为同样的形式，这称为Unicode正规化。

'\u01D1'.normalize() === '\u004F\u030C'.normalize()
// true


    includes()：返回布尔值，表示是否找到了参数字符串。
    startsWith()：返回布尔值，表示参数字符串是否在源字符串的头部。
    endsWith()：返回布尔值，表示参数字符串是否在源字符串的尾部。
var s = 'Hello world!';

s.startsWith('Hello') // true
s.endsWith('!') // true
s.includes('o') // true

这三个方法都支持第二个参数，表示开始搜索的位置。

var s = 'Hello world!';

s.startsWith('world', 6) // true
s.endsWith('Hello', 5) // true
s.includes('Hello', 6) // false

上面代码表示，使用第二个参数n时，endsWith的行为与其他两个方法有所不同。它针对前n个字符，而其他两个方法针对从第n个位置直到字符串结束。

repeat方法返回一个新字符串，表示将原字符串重复n次。

'x'.repeat(3) // "xxx"
'hello'.repeat(2) // "hellohello"
'na'.repeat(0) // ""

参数如果是小数，会被取整。

'na'.repeat(2.9) // "nana"

如果repeat的参数是负数或者Infinity，会报错。

'na'.repeat(Infinity)
// RangeError
'na'.repeat(-1)
// RangeError

但是，如果参数是0到-1之间的小数，则等同于0，这是因为会先进行取整运算。0到-1之间的小数，取整以后等于-0，repeat视同为0。

'na'.repeat(-0.9) // ""

参数NaN等同于0。

'na'.repeat(NaN) // ""

如果repeat的参数是字符串，则会先转换成数字。

'na'.repeat('na') // ""
'na'.repeat('3') // "nanana"

ES7推出了字符串补全长度的功能。如果某个字符串不够指定长度，会在头部或尾部补全。padStart用于头部补全，padEnd用于尾部补全。

'x'.padStart(5, 'ab') // 'ababx'
'x'.padStart(4, 'ab') // 'abax'

'x'.padEnd(5, 'ab') // 'xabab'
'x'.padEnd(4, 'ab') // 'xaba'

上面代码中，padStart和padEnd一共接受两个参数，第一个参数用来指定字符串的最小长度，第二个参数是用来补全的字符串。

如果原字符串的长度，等于或大于指定的最小长度，则返回原字符串。

'xxx'.padStart(2, 'ab') // 'xxx'
'xxx'.padEnd(2, 'ab') // 'xxx'

如果用来补全的字符串与原字符串，两者的长度之和超过了指定的最小长度，则会截去超出位数的补全字符串。

'abc'.padStart(10, '0123456789')
// '0123456abc'

如果省略第二个参数，则会用空格补全长度。

'x'.padStart(4) // '   x'
'x'.padEnd(4) // 'x   '

padStart的常见用途是为数值补全指定位数。下面代码生成10位的数值字符串。

'1'.padStart(10, '0') // "0000000001"
'12'.padStart(10, '0') // "0000000012"
'123456'.padStart(10, '0') // "0000123456"

另一个用途是提示字符串格式。

'12'.padStart(10, 'YYYY-MM-DD') // "YYYY-MM-12"
'09-12'.padStart(10, 'YYYY-MM-DD') // "YYYY-09-12"

模板字符串：

te string）是增强版的字符串，用反引号（`）标识。它可以当作普通字符串使用，也可以用来定义多行字符串，或者在字符串中嵌入变量。

// 普通字符串
`In JavaScript '\n' is a line-feed.`

// 多行字符串
`In JavaScript this is
 not legal.`

console.log(`string text line 1
string text line 2`);

// 字符串中嵌入变量
var name = "Bob", time = "today";
`Hello ${name}, how are you ${time}?`

上面代码中的字符串，都是用反引号表示。如果在模板字符串中需要使用反引号，则前面要用反斜杠转义。

var greeting = `\`Yo\` World!`;

如果使用模板字符串表示多行字符串，所有的空格和缩进都会被保留在输出之中。

$("#warning").html(`
  <h1>Watch out!</h1>
  <p>Unauthorized hockeying can result in penalties
  of up to ${maxPenalty} minutes.</p>
`);

模板字符串中嵌入变量，需要将变量名写在${}之中。

function authorize(user, action) {
  if (!user.hasPrivilege(action)) {
    throw new Error(
      // 传统写法为
      // 'User '
      // + user.name
      // + ' is not authorized to do '
      // + action
      // + '.'
      `User ${user.name} is not authorized to do ${action}.`);
  }
}

大括号内部可以放入任意的JavaScript表达式，可以进行运算，以及引用对象属性。

var x = 1;
var y = 2;

`${x} + ${y} = ${x + y}`
// "1 + 2 = 3"

`${x} + ${y * 2} = ${x + y * 2}`
// "1 + 4 = 5"

var obj = {x: 1, y: 2};
`${obj.x + obj.y}`
// 3

模板字符串之中还能调用函数。

function fn() {
  return "Hello World";
}

`foo ${fn()} bar`
// foo Hello World bar

如果大括号中的值不是字符串，将按照一般的规则转为字符串。比如，大括号中是一个对象，将默认调用对象的toString方法。

如果模板字符串中的变量没有声明，将报错。

// 变量place没有声明
var msg = `Hello, ${place}`;
// 报错

由于模板字符串的大括号内部，就是执行JavaScript代码，因此如果大括号内部是一个字符串，将会原样输出。

`Hello ${'World'}`
// "Hello World"

如果需要引用模板字符串本身，可以像下面这样写。

// 写法一
let str = 'return ' + '`Hello ${name}!`';
let func = new Function('name', str);
func('Jack') // "Hello Jack!"

// 写法二
let str = '(name) => `Hello ${name}!`';
let func = eval.call(null, str);
func('Jack') // "Hello Jack!"

ES6还为原生的String对象，提供了一个raw方法。

String.raw方法，往往用来充当模板字符串的处理函数，返回一个斜杠都被转义（即斜杠前面再加一个斜杠）的字符串，对应于替换变量后的模板字符串。

String.raw`Hi\n${2+3}!`;
// "Hi\\n5!"

String.raw`Hi\u000A!`;
// 'Hi\\u000A!'

如果原字符串的斜杠已经转义，那么String.raw不会做任何处理。

String.raw`Hi\\n`
// "Hi\\n"



concat方法

字符串的concat方法用于连接两个字符串。

var s1 = 'abc';
var s2 = 'def';

s1.concat(s2) // "abcdef"
s1 // "abc"

使用该方法后，原字符串不受影响，返回一个新字符串。
该方法可以接受多个参数。

'a'.concat('b', 'c') // "abc"

如果参数不是字符串，concat方法会将其先转为字符串，然后再连接。

var one = 1;
var two = 2;
var three = '3';

''.concat(one, two, three) // "123"
one + two + three // "33"

上面代码中，concat方法将参数先转成字符串再连接，所以返回的是一个三个字符的字符串。而加号运算符在两个运算数都是数值时，不会转换类型，所以返回的是一个两个字符的字符串。

【特殊字符 】
var s = "𠮷";
s.length // 2
s.charAt(0) // ''
s.charAt(1) // ''
s.charCodeAt(0) // 55362
s.charCodeAt(1) // 57271

substring方法，substr方法和slice方法

这三个方法都用来返回一个字符串的子串，而不会改变原字符串。它们都可以接受一个或两个参数，区别只是参数含义的不同。

（1）substring方法

substring方法的第一个参数表示子字符串的开始位置，第二个位置表示结束结果。因此，第二个参数应该大于第一个参数。如果出现第一个参数大于第二个参数的情况，substring方法会自动更换两个参数的位置。

var a = 'The Three Musketeers';
a.substring(4, 9) // 'Three'
a.substring(9, 4) // 'Three'

上面代码中，调换substring方法的两个参数，都得到同样的结果。

（2）substr方法

substr方法的第一个参数是子字符串的开始位置，第二个参数是子字符串的长度。

var b = 'The Three Musketeers';
b.substr(4, 9) // 'Three Mus'
b.substr(9, 4) // ' Mus'

（3）slice方法

slice方法的第一个参数是子字符串的开始位置，第二个参数是子字符串的结束位置。与substring方法不同的是，如果第一个参数大于第二个参数，slice方法并不会自动调换参数位置，而是返回一个空字符串。

var c = 'The Three Musketeers';
c.slice(4, 9) // 'Three'
c.slice(9, 4) // ''

（4）总结：第一个参数的含义

对这三个方法来说，第一个参数都是子字符串的开始位置，如果省略第二个参数，则表示子字符串一直持续到原字符串结束。

"Hello World".slice(3)
// "lo World"

"Hello World".substr(3)
// "lo World"

"Hello World".substring(3)
// "lo World"

（5）总结：第二个参数的含义

如果提供第二个参数，对于slice和substring方法，表示子字符串的结束位置；对于substr，表示子字符串的长度。

"Hello World".slice(3,7)
// "lo W"

"Hello World".substring(3,7)
// "lo W"

"Hello World".substr(3,7)
// "lo Worl"

（6）总结：负的参数

如果参数为负，对于slice方法，表示字符位置从尾部开始计算。

"Hello World".slice(-3)
// "rld"

"Hello World".slice(4,-3)
// "o Wo"

对于substring方法，会自动将负数转为0。

"Hello World".substring(-3)
// "Hello World"

"Hello World".substring(4,-3)
// "Hell"

对于substr方法，负数出现在第一个参数，表示从尾部开始计算的字符位置；负数出现在第二个参数，将被转为0。

"Hello World".substr(-3)
// "rld"

"Hello World".substr(4,-3)
// ""

indexOf 和 lastIndexOf 方法

这两个方法用于确定一个字符串在另一个字符串中的位置，如果返回-1，就表示不匹配。两者的区别在于，indexOf从字符串头部开始匹配，lastIndexOf从尾部开始匹配。

"hello world".indexOf("o")
// 4

"hello world".lastIndexOf("o")
// 7

它们还可以接受第二个参数，对于indexOf，表示从该位置开始向后匹配；对于lastIndexOf，表示从该位置起向前匹配。

"hello world".indexOf("o", 6)
// 7

"hello world".lastIndexOf("o", 6)
// 4

trim 方法

该方法用于去除字符串两端的空格。

"  hello world  ".trim()
// "hello world"

该方法返回一个新字符串，不改变原字符串。
toLowerCase 和 toUpperCase 方法

toLowerCase用于将一个字符串转为小写，toUpperCase则是转为大写。

"Hello World".toLowerCase()
// "hello world"

"Hello World".toUpperCase()
// "HELLO WORLD"

localeCompare方法

该方法用于比较两个字符串。它返回一个数字，如果小于0，表示第一个字符串小于第二个字符串；如果等于0，表示两者相等；如果大于0，表示第一个字符串大于第二个字符串。

'apple'.localeCompare('banana')
// -1

'apple'.localeCompare('apple')
// 0

[搜索和替换] 与搜索和替换相关的有4个方法，它们都允许使用正则表达式。
1. match：用于确定原字符串是否匹配某个子字符串，返回匹配的子字符串数组。

match方法返回一个数组，成员为匹配的第一个字符串。如果没有找到匹配，则返回null。返回数组还有index属性和input属性，分别表示匹配字符串开始的位置（从0开始）和原始字符串。
var matches = "cat, bat, sat, fat".match("at");
matches // ["at"]
matches.index // 1
matches.input // "cat, bat, sat, fat"

2. search：等同于match，但是返回值不一样。

search方法的用法等同于match，但是返回值为匹配的第一个位置。如果没有找到匹配，则返回-1。
"cat, bat, sat, fat".search("at")
// 1

3. replace：用于替换匹配的字符串。

replace方法用于替换匹配的子字符串，一般情况下只替换第一个匹配（除非使用带有g修饰符的正则表达式）。
"aaa".replace("a", "b")
// "baa"

4. split：将字符串按照给定规则分割，返回一个由分割出来的各部分组成的新数组。
split方法按照给定规则分割字符串，返回一个由分割出来的各部分组成的新数组。
"a|b|c".split("|")
// ["a", "b", "c"]

如果分割规则为空字符串，则返回数组的成员是原字符串的每一个字符。
"a|b|c".split("")
// ["a", "|", "b", "|", "c"]

如果省略分割规则，则返回数组的唯一成员就是原字符串。
"a|b|c".split()
// ["a|b|c"]

如果满足分割规则的两个部分紧邻着（即中间没有其他字符），则返回数组之中会有一个空字符串。
"a||c".split("|")
// ["a", "", "c"]

如果满足分割规则的部分处于字符串的开头或结尾（即它的前面或后面没有其他字符），则返回数组的第一个或最后一个成员是一个空字符串。
"|b|c".split("|")
// ["", "b", "c"]
"a|b|".split("|")
// ["a", "b", ""]

split方法还可以接受第二个参数，限定返回数组的最大成员数。
"a|b|c".split("|", 0) // []
"a|b|c".split("|", 1) // ["a"]
"a|b|c".split("|", 2) // ["a", "b"]
"a|b|c".split("|", 3) // ["a", "b", "c"]
"a|b|c".split("|", 4) // ["a", "b", "c"]




[JS RegExp 对象]

[JS 事件]
事件通常与函数配合使用，这样就可以通过发生的事件来驱动函数执行。

[事件句柄]
onabort     图像加载被中断
onblur  元素失去焦点
onchange    用户改变域的内容
onclick     鼠标点击某个对象
ondblclick  鼠标双击某个对象
onerror     当加载文档或图像时发生某个错误
onfocus     元素获得焦点
onkeydown   某个键盘的键被按下
onkeypress  某个键盘的键被按下或按住
onkeyup     某个键盘的键被松开
onload  某个页面或图像被完成加载
onmousedown     某个鼠标按键被按下
onmousemove     鼠标被移动
onmouseout  鼠标从某元素移开
onmouseover     鼠标被移到某元素之上
onmouseup   某个鼠标按键被松开
onreset     重置按钮被点击
onresize    窗口或框架被调整尺寸
onselect    文本被选定
onsubmit    提交按钮被点击
onunload    用户退出页面

[鼠标/键盘属性]
altKey  返回当事件被触发时，"ALT" 是否被按下。
button  返回当事件被触发时，哪个鼠标按钮被点击。
clientX     返回当事件被触发时，鼠标指针的水平坐标。
clientY     返回当事件被触发时，鼠标指针的垂直坐标。
ctrlKey     返回当事件被触发时，"CTRL" 键是否被按下。
metaKey     返回当事件被触发时，"meta" 键是否被按下。
relatedTarget   返回与事件的目标节点相关的节点。
screenX     返回当某个事件被触发时，鼠标指针的水平坐标。
screenY     返回当某个事件被触发时，鼠标指针的垂直坐标。
shiftKey    返回当事件被触发时，"SHIFT" 键是否被按下。

[JavaScript 对象]

对象由花括号分隔。在括号内部，对象的属性以名称和值对的形式 (name : value) 来定义。属性由逗号分隔：

var person={firstname:"Bill", lastname:"Gates", id:5566};

上面例子中的对象 (person) 有三个属性：firstname、lastname 以及 id。

空格和折行无关紧要。声明可横跨多行：

var person={
firstname : "Bill",
lastname  : "Gates",
id        :  5566
};

对象属性有两种寻址方式：
实例

name=person.lastname;
name=person["lastname"];

[Undefined 和 Null]

Undefined 这个值表示变量不含有值。
可以通过将变量的值设置为 null 来清空变量。
实例

cars=null;
person=null;


[声明变量类型]

当您声明新变量时，可以使用关键词 "new" 来声明其类型：

var carname=new String;
var x=      new Number;
var y=      new Boolean;
var cars=   new Array;
var person= new Object;

JavaScript 变量均为对象。当您声明一个变量时，就创建了一个新的对象。


注意：向未声明的 JavaScript 变量来分配值
如果您把值赋给尚未声明的变量，该变量将被自动作为全局变量声明。
这条语句：
carname="Volvo";
将声明一个全局变量 carname，即使它在函数内执行。

+ 运算符用于把文本值或字符串变量加起来（连接起来）。
如需把两个或多个字符串变量连接起来，请使用 + 运算符。
txt1="What a very";
txt2="nice day";
txt3=txt1+txt2;
如果把数字与字符串相加，结果将成为字符串。

==      等于    x==8 为 false
===     全等（值和类型）    x===5 为 true；x==="5" 为 false

JavaScript 支持不同类型的循环：
    for - 循环代码块一定的次数
    for/in - 循环遍历对象的属性
    while - 当指定的条件为 true 时循环指定的代码块
    do/while - 同样当指定的条件为 true 时循环指定的代码块: 该循环会执行一次代码块，在检查条件是否为真之前，然后如果条件为真的话，就会重复这个循环。

[JavaScript 标签]

正如您在 switch 语句那一章中看到的，可以对 JavaScript 语句进行标记。

如需标记 JavaScript 语句，请在语句之前加上冒号：

label:
语句

break 和 continue 语句仅仅是能够跳出代码块的语句。
语法

break labelname;

continue labelname;

continue 语句（带有或不带标签引用）只能用在循环中。

break 语句（不带标签引用），只能用在循环或 switch 中。

通过标签引用，break 语句可用于跳出任何 JavaScript 代码块：

try 语句允许我们定义在执行时进行错误测试的代码块。
catch 语句允许我们定义当 try 代码块发生错误时，所执行的代码块。
try
  {
  var x=document.getElementById("demo").value;
  if(x=="")    throw "empty";
  if(isNaN(x)) throw "not a number";
  if(x>10)     throw "too high";
  if(x<5)      throw "too low";//throw 语句允许我们创建自定义错误。
  }
catch(err)
  {
  var y=document.getElementById("mess");
  y.innerHTML="Error: " + err + ".";
  }//请注意，如果 getElementById 函数出错，上面的例子也会抛出一个错误。

[JS 验证]


[JavaScript HTML DOM]
通过可编程的对象模型，JavaScript 获得了足够的能力来创建动态的 HTML。
JavaScript 能够改变页面中的所有 HTML 元素
JavaScript 能够改变页面中的所有 HTML 属性
JavaScript 能够改变页面中的所有 CSS 样式
JavaScript 能够对页面中的所有事件做出反应

通过 id 找到 HTML 元素
var x=document.getElementById("intro");
查找 id="main" 的元素，然后查找 "main" 中的所有 <p> 元素：
var x=document.getElementById("main");
var y=x.getElementsByTagName("p");

document.write() 可用于直接向 HTML 输出流写内容。绝不要使用在文档加载之后使用 document.write()。这会覆盖该文档。

修改 HTML 内容的最简单的方法时使用 innerHTML 属性。
如需改变 HTML 元素的内容，请使用这个语法：
document.getElementById(id).innerHTML=new HTML

改变了 <img> 元素的 src 属性：
document.getElementById("image").src="landscape.jpg";

改变 HTML 元素的样式
document.getElementById("p2").style.color="blue";

本例改变了 id="id1" 的 HTML 元素的样式，当用户点击按钮时：
<h1 id="id1">My Heading 1</h1>
<button type="button" onclick="document.getElementById('id1').style.color='red'">
点击这里
</button>

<p id="p1">这是一段文本。</p>
<input type="button" value="隐藏文本" onclick="document.getElementById('p1').style.visibility='hidden'" />
<input type="button" value="显示文本" onclick="document.getElementById('p1').style.visibility='visible'" />

当用户在 <h1> 元素上点击时，会改变其内容：
<h1 onclick="this.innerHTML='谢谢!'">请点击该文本</h1>

<head>
<script>
function changetext(id)
{
id.innerHTML="谢谢!";
}
</script>
</head>
<body>
<h1 onclick="changetext(this)">请点击该文本</h1>
</body>

向 button 元素分配 onclick 事件：
<script>
document.getElementById("myBtn").onclick=function(){displayDate()};
</script>
名为 displayDate 的函数被分配给 id="myButn" 的 HTML 元素。
当按钮被点击时，会执行该函数。

[onload 和 onunload 事件]

onload 和 onunload 事件会在用户进入或离开页面时被触发。
onload 事件可用于检测访问者的浏览器类型和浏览器版本，并基于这些信息来加载网页的正确版本。
onload 和 onunload 事件可用于处理 cookie。

<body onload="checkCookies()">
<script>
function checkCookies()
{
if (navigator.cookieEnabled==true)
    {
    alert("已启用 cookie")
    }
else
    {
    alert("未启用 cookie")
    }
}
</script>
<p>提示框会告诉你，浏览器是否已启用 cookie。</p>
</body>

[onchange 事件]
onchange 事件常结合对输入字段的验证来使用。

当用户改变输入字段的内容时，会调用 upperCase() 函数。
<input type="text" id="fname" onchange="upperCase()">

[onmouseover 和 onmouseout 事件]
onmouseover 和 onmouseout 事件可用于在用户的鼠标移至 HTML 元素上方或移出元素时触发函数。
<div onmouseover="mOver(this)" onmouseout="mOut(this)">把鼠标移到上面</div>

<script>
function mOver(obj)
{
obj.innerHTML="谢谢"
}
function mOut(obj)
{
obj.innerHTML="把鼠标移到上面"
}
</script>

[onmousedown、onmouseup 以及 onclick 事件]
onmousedown, onmouseup 以及 onclick 构成了鼠标点击事件的所有部分。首先当点击鼠标按钮时，会触发 onmousedown 事件，当释放鼠标按钮时，会触发 onmouseup 事件，最后，当完成鼠标点击时，会触发 onclick 事件。

<head>
<script>
function myFunction(x)
{
x.style.background="yellow";
}
</script>
</head>
<body>
请输入英文字符：<input type="text" onfocus="myFunction(this)">
<p>当输入字段获得焦点时，会触发改变背景颜色的函数。</p>
</body>

[JavaScript HTML DOM 元素（节点）]

如需向 HTML DOM 添加新元素，您必须首先创建该元素（元素节点），然后向一个已存在的元素追加该元素。

<div id="div1">
<p id="p1">这是一个段落</p>
<p id="p2">这是另一个段落</p>
</div>
<script>
//创建新的 <p> 元素：
var para=document.createElement("p");
//如需向 <p> 元素添加文本，您必须首先创建文本节点。这段代码创建了一个文本节点：
var node=document.createTextNode("这是新段落。");
//向 <p> 元素追加这个文本节点：
para.appendChild(node);
//向一个已有的元素追加这个新元素。
var element=document.getElementById("div1");
element.appendChild(para);
</script>

如需删除 HTML 元素，您必须首先获得该元素的父元素：
<div id="div1">
<p id="p1">这是一个段落。</p>
<p id="p2">这是另一个段落。</p>
</div>
<script>
var parent=document.getElementById("div1");
var child=document.getElementById("p1");
parent.removeChild(child);
</script>

这是常用的解决方案：找到您希望删除的子元素，然后使用其 parentNode 属性来找到父元素：
var child=document.getElementById("p1");
child.parentNode.removeChild(child);


[JavaScript 类]
JavaScript 是面向对象的语言，但 JavaScript 不使用类。
在 JavaScript 中，不会创建类，也不会通过类来创建对象（就像在其他面向对象的语言中那样）。
JavaScript 基于 prototype(原型)，而不是基于类的。

for...in 循环中的代码块将针对每个属性执行一次。
var person={fname:"Bill",lname:"Gates",age:56};
for (x in person)
  {
  txt=txt + person[x];
  }//for...in 会取得每个属性的值

[JavaScript Number 对象]

[Array function]

1. forEatch

[1, 2 ,3, 4].forEach(alert);// 参数为function类型

[1, 2 ,3, 4].forEach(console.log);

// 结果：

// 1, 0, [1, 2, 3, 4]
// 2, 1, [1, 2, 3, 4]
// 3, 2, [1, 2, 3, 4]
// 4, 3, [1, 2, 3, 4]

// function回调支持三个参数，对应数组的值，index，及本身。
[].forEach(function(value, index, array) {
    // ...
});
// forEach 除了接受一个必须的回调函数参数，还可以接受一个可选的上下文参数（改变回调函数里面的this指向）（第2个参数）。
// forEach 会跳过空元素
var array = [1, 2, 3];

delete array[1]; // 移除 2
alert(array); // "1,,3"

alert(array.length); // but the length is still 3

array.forEach(alert); // 弹出的仅仅是1和3

2. map // 基本用法与forEach类似
array.map.(callback, [ thisObject]);

[].map(function(value, index, array){
    // ...
})

var users = [
  {name: "张含韵", "email": "zhang@email.com"},
  {name: "江一燕",   "email": "jiang@email.com"},
  {name: "李小璐",  "email": "li@email.com"}
];
var emails = users.map(function (user) { return user.email; });
console.log(emails.join(", ")); // zhang@email.com, jiang@email.com, li@email.com

3. filter // 返回过滤后的新数组。用法跟map极为相似
array.filter(callback,[ thisObject]);

var emailsZhang = users
  // 获得邮件
  .map(function (user) { return user.email; })
  // 筛选出zhang开头的邮件
  .filter(function(email) {  return /^zhang/.test(email); });

console.log(emailsZhang.join(", ")); // zhang@email.com

4. some // some意指“某些”，指是否“某些项”合乎条件。与下面的every算是好基友，every表示是否“每一项”都要靠谱。

array.some(callback,[ thisObject]);

// some要求至少有一个值使得block返回true即可
var scores = [5, 8, 3, 10];
var current = 7;
function higherThanCurrent(score) {
  return score > current;
}
if (scores.some(higherThanCurrent)) {
  alert("朕准了！");
}
5. every

if (scores.every(higherThanCurrent)) {
  alert("朕准了！");
} else {
  console.log("拖出去斩了！");
}

6. indexOf // indexOf方法在字符串中自古就有，string.indexOf(searchString, position)。数组这里的indexOf方法与之类似。

array.indexOf(searchElement[, fromIndex])

// 返回整数索引值，如果没有匹配（严格匹配），返回-1. fromIndex可选，表示从这个位置开始搜索，若缺省或格式不合要求，使用默认值0，我在FireFox下测试，发现使用字符串数值也是可以的，例如"3"和3都可以。
var data = [2, 5, 7, 3, 5];
console.log(data.indexOf(5, "x")); // 1 ("x"被忽略)
console.log(data.indexOf(5, "3")); // 4 (从3号位开始搜索)
console.log(data.indexOf(4)); // -1 (未找到)
console.log(data.indexOf("5")); // -1 (未找到，因为5 !== "5")

7. lastIndexOf // 与indexOf方法类似：

array.lastIndexOf(searchElement[, fromIndex])

var data = [2, 5, 7, 3, 5];
console.log(data.lastIndexOf(5)); // 4
console.log(data.lastIndexOf(5, 3)); // 1 (从后往前，索引值小于3的开始搜索)
console.log(data.lastIndexOf(4)); // -1 (未找到)

8. reduce // 归约
array.reduce(callback[, initialValue])

// 因为initialValue不存在，因此一开始的previous值等于数组的第一个元素。
// 从而current值在第一次调用的时候就是2.
// 最后两个参数为索引值index以及数组本身array.
var sum = [1, 2, 3, 4].reduce(function (previous, current, index, array) {
  return previous + current;
});
console.log(sum); // 10

// 实现二维数组的扁平化
var matrix = [
  [1, 2],
  [3, 4],
  [5, 6]
];
// 二维数组扁平化
var flatten = matrix.reduce(function (previous, current) {
  return previous.concat(current);
});
console.log(flatten); // [1, 2, 3, 4, 5, 6]

9. reduceRight // 与reduce区别在于，reduceRight是从数组的末尾开始实现

[this]
var story = {
    progress: "unknown",
    start: function() {
        this.progress = "start";
    }
}
story.start();
console.log(story.progress); // start

var story = {
    progress: "unknown",
    start: function() {
        story.progress = "start";
    }
};

story.start();
console.log(story.progress); // start

var story = {
    progress: "unknown",
    start: function() {
        this.progress = "start";
    }
};

var start = story.start;
start(); // 这时候的this是 start变量
console.log(story.progress); // unknown

console.log(foo); // 输出undefined
console.log(bar); // 报错ReferenceError
var foo = 2;
let bar = 2;
上面代码中，变量foo用var命令声明，会发生变量提升，即脚本开始运行时，变量foo已经存在了，但是没有值，所以会输出undefined。变量bar用let命令声明，不会发生变量提升。这表示在声明它之前，变量bar是不存在的，这时如果用到它，就会抛出一个错误
ES6明确规定，如果区块中存在let和const命令，这个区块对这些命令声明的变量，从一开始就形成了封闭作用域。凡是在声明之前就使用这些变量，就会报错。
总之，在代码块内，使用let命令声明变量之前，该变量都是不可用的。这在语法上，称为“暂时性死区”（temporal dead zone，简称TDZ）。

const命令声明的常量也是不提升，同样存在暂时性死区，只能在声明的位置后面使用。

const命令只是保证变量名指向的地址不变，并不保证该地址的数据不变，所以将一个对象声明为常量必须非常小心。
const a = [];
a.push("Hello"); // 可执行
a.length = 0;    // 可执行
a = ["Dave"];    // 报错

跨模块常量 
export const A = 1;

ES6 不存在函数提升，ES5 存在函数提升。下面例子中声明了同样名字的方法，在ES5中存在函数提升，因此不管方法是否执行，内层的方法都会覆盖外层方法，所以执行会输出语句二。ES6不存在函数提升，输出语句一。
function f() { console.log('语句一 ：I am outside!'); }
(function () {
  if(false) {
    // 重复声明一次函数f
    function f() { console.log('语句二：I am inside!'); }
  }
  f();
}());

// ------
var message = "Hello!";
let age = 25;
// 以下两行都会报错
const message = "Goodbye!";
const age = 30;

对于复合类型的变量，变量名不指向数据，而是指向数据所在的地址。const命令只是保证变量名指向的地址不变，并不保证该地址的数据不变，所以将一个对象声明为常量必须非常小心。

const foo = {};// foo存储的地址是不可变的，但依然可以为foo添加新属性。
foo.prop = 123;
foo.prop
// 123
foo = {} // TypeError: "foo" is read-only 不能改变地址
const a = [];// 数组a指向的地址是不可变的，但可以对数组进行操作。
a.push("Hello"); // 可执行
a.length = 0;    // 可执行
a = ["Dave"];    // 改变地址,报错 

// 全局对象的属性：
1. var命令和function命令声明的全局变量，依旧是全局对象的属性。
2. let命令、const命令、class命令声明的全局变量，不属于全局对象的属性。
var a = 1; // var声明的变量为全局对象的属性
// 如果在Node的REPL环境，可以写成global.a
// 或者采用通用方法，写成this.a
window.a // 1

let b = 1;// let声明的变量不属于全局对象的属性。
window.b // undefined

//var let const 变量的解构赋值：类似于模式匹配：
let [x, y] = [1, 2, 3];
x // 1
y // 2

let [a, [b], d] = [1, [2, 3], 4];
a // 1
b // 2
d // 4

let [foo, [[bar], baz]] = [1, [[2], 3]];
foo // 1
bar // 2
baz // 3

let [ , , third] = ["foo", "bar", "baz"];
third // "baz"

let [x, , y] = [1, 2, 3];
x // 1
y // 3

let [head, ...tail] = [1, 2, 3, 4];
head // 1
tail // [2, 3, 4]

let [x, y, ...z] = ['a'];
x // "a"
y // undefined
z // []

只要某种数据结构具有Iterator接口，都可以采用数组形式的解构赋值。
var [v1, v2, ..., vN ] = array;
let [v1, v2, ..., vN ] = array;
const [v1, v2, ..., vN ] = array;

var [first, second, third, fourth, fifth, sixth] = fibs();
sixth // 5
上面代码中，fibs是一个Generator函数，原生具有Iterator接口。解构赋值会依次从这个接口>获取值。


解构赋值允许指定默认值。
var [foo = true] = [];
foo // true
[x, y = 'b'] = ['a'] // x='a', y='b'
[x, y = 'b'] = ['a', undefined] // x='a', y='b'
注意，ES6内部使用严格相等运算符（===），判断一个位置是否有值。所以，如果一个数组成员不严格等于undefined，默认值是不会生效的。

字符串也可以解构赋值。这是因为此时，字符串被转换成了一个类似数组的对象。
const [a, b, c, d, e] = 'hello';
a // "h"
b // "e"
c // "l"
d // "l"
e // "o"
类似数组的对象都有一个length属性，因此还可以对这个属性解构赋值。
let {length : len} = 'hello';
len // 5

函数的参数也可以使用解构赋值。
function add([x, y]){
  return x + y;
}
add([1, 2]) // 3
[[1, 2], [3, 4]].map(([a, b]) => a + b)
// [ 3, 7 ]

undefined就会触发函数参数的默认值。
[1, undefined, 3].map((x = 'yes') => x)
// [ 1, 'yes', 3 ]

ES6的规则是，只要有可能导致解构的歧义，就不得使用圆括号。
但是，这条规则实际上不那么容易辨别，处理起来相当麻烦。因此，建议只要有可能，就不要在模式中放置圆括号。

变量解构 用途：
1. 交换变量的值
[x, y] = [y, x];
2. 从函数返回多个值
函数只能返回一个值，如果要返回多个值，只能将它们放在数组或对象里返回。有了解构赋值，取出这些值就非常方便。

// 返回一个数组
function example() {
  return [1, 2, 3];
}
var [a, b, c] = example();

// 返回一个对象
function example() {
  return {
    foo: 1,
    bar: 2
  };
}
var { foo, bar } = example();
3. 函数参数的定义
解构赋值可以方便地将一组参数与变量名对应起来。
// 参数是一组有次序的值
function f([x, y, z]) { ... }
f([1, 2, 3])

// 参数是一组无次序的值
function f({x, y, z}) { ... }
f({z: 3, y: 2, x: 1})

4. 提取JSON数据
解构赋值对提取JSON对象中的数据，尤其有用。
var jsonData = {
  id: 42,
  status: "OK",
  data: [867, 5309]
}
let { id, status, data: number } = jsonData;
console.log(id, status, number)
// 42, "OK", [867, 5309]

5. 函数参数的默认值

6. 遍历Map结构，使用for...of 循环遍历，来同时获取key/value
var map = new Map();
map.set('first', 'hello');
map.set('second', 'world');
for (let [key, value] of map) {
  console.log(key + " is " + value);
}
// first is hello
// second is world

// 获取键名
for (let [key] of map) {
  // ...
}
// 获取键值
for (let [,value] of map) {
  // ...
}

7. 输入模块的指定方法
加载模块时，往往需要指定输入那些方法。解构赋值使得输入语句非常清晰。
const { SourceMapConsumer, SourceNode } = require("source-map");















[举例分析]
x = { shift: [].shift };
x.shift();
x.length;   //返回的是？
// 0

;
