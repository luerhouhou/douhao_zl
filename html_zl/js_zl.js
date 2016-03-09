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

[JS String 对象]
字符串是 JavaScript 的一种基本的数据类型。

String 对象的 length 属性声明了该字符串中的字符数。

String 类定义了大量操作字符串的方法，例如从字符串中提取字符或子串，或者检索字符或子串。

需要注意的是，JavaScript 的字符串是不可变的（immutable），String 类定义的方法都不能改变字符串的内容。像 String.toUpperCase() 这样的方法，返回的是全新的字符串，而不是修改原始字符串。

在较早的 Netscape 代码基的 JavaScript 实现中（例如 Firefox 实现中），字符串的行为就像只读的字符数组。例如，从字符串 s 中提取第三个字符，可以用 s[2] 代替更加标准的 s.charAt(2)。此外，对字符串应用 for/in 循环时，它将枚举字符串中每个字符的数组下标（但要注意，ECMAScript 标准规定，不能枚举 length 属性）。因为字符串的数组行为不标准，所以应该避免使用它。

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

