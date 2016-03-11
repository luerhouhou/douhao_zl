[Array 对象属性]
Array是JavaScript的内置对象，同时也是一个构造函数，可以用它生成新的数组。
作为构造函数时，Array可以接受参数，但是不同的参数，会使得Array产生不同的行为。

// 无参数时，返回一个空数组
new Array() // []

// 单个正整数参数，表示返回的新数组的长度
new Array(1) // [undefined × 1]
new Array(2) // [undefined x 2]

// 单个非正整数参数（比如字符串、布尔值、对象等），
// 则该参数是返回的新数组的成员
new Array('abc') // ['abc']
new Array([1]) // [Array[1]]

// 多参数时，所有参数都是返回的新数组的成员
new Array(1, 2) // [1, 2]
从上面代码可以看到，Array作为构造函数，行为很不一致。因此，不建议使用它生成新数组，直接使用数组的字面量是更好的方法。
// bad
var arr = new Array(1, 2);
// good
var arr = [1, 2];




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

[Array 对象的静态方法]

isArray方法
Array.isArray方法用来判断一个值是否为数组。它可以弥补typeof运算符的不足。

var a = [1, 2, 3];

typeof a // "object"
Array.isArray(a) // true
上面代码表示，typeof运算符只能显示数组的类型是Object，而Array.isArray方法可以对数组返回true。

[Array 实例的方法]

concat()   // 连接两个或更多的数组，并返回结果。该方法不会改变现有的数组，而仅仅会返回被连接数组的一个副本。

把 concat() 中的参数连接到数组 a 中：
var a = [1,2,3];
document.write(a.concat(4,5));

创建了三个数组，然后使用 concat() 把它们连接起来：
var arr = ["George","John","Thomas"]
var arr2 = ["James","Adrew","Martin"]
var arr3 = ["William","Franklin"]
document.write(arr.concat(arr2,arr3))

join() // 把数组的所有元素放入一个字符串。元素通过指定的分隔符进行分隔。
arrayObject.join(separator)
separator   可选。指定要使用的分隔符。如果省略该参数，则使用逗号作为分隔符
var a = [1, 2, 3, 4];
a.join() // "1,2,3,4"
a.join('') // '1234'
a.join("|") // "1|2|3|4"

通过函数的call方法，join方法（即Array.prototype.join）也可以用于字符串。
Array.prototype.join.call('hello', '-')
// "h-e-l-l-o"

pop()  // 删除并返回数组的最后一个元素
pop() 方法将删除 arrayObject 的最后一个元素，把数组长度减 1，并且返回它删除的元素的值。如果数组已经为空，则 pop() 不改变数组，并返回 undefined 值。

push()  //向数组的末尾添加一个或更多元素，并返回新的长度。
push() 方法可把它的参数顺序添加到 arrayObject 的尾部。它直接修改 arrayObject，而不是创建一个新的数组。push() 方法和 pop() 方法使用数组提供的先进后出栈的功能。
var a = [];
a.push(1) // 1
a.push('a') // 2
a.push(true, {}) // 4
a // [1, 'a', true, {}]

如果需要合并两个数组，可以这样写。
var a = [1, 2, 3];
var b = [4, 5, 6];

Array.prototype.push.apply(a, b)
// 或者
a.push.apply(a,b)

// 上面两种写法等同于
a.push(4,5,6)

a // [1, 2, 3, 4, 5, 6]
push方法还可以用于向对象添加元素，添加后的对象变成“类似数组的”对象，即新加入元素的键对应数组的索引，并且对象有一个length属性。
var a = {a: 1};

[].push.call(a, 2);
a // {a:1, 0:2, length: 1}

[].push.call(a, [3]);
a // {a:1, 0:2, 1:[3], length: 2}



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

toSource()  // 返回该对象的源代码。
只有Firefox支持改方法

valueOf 返回数组本身
var a = [1, 2, 3];
a.valueOf() // [1, 2, 3]

toString()  // 返回数组的字符串形式。
返回值: arrayObject 的字符串表示。返回值与没有参数的 join() 方法返回的字符串相同。
var a = [1, 2, 3];
a.toString() // "1,2,3"
var a = [1, 2, 3, [4, 5, 6]];
a.toString() // "1,2,3,4,5,6"

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
