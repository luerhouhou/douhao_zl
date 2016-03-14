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
//
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

unshift()   //向数组的开头添加一个或更多元素，并返回新的长度。
请注意，unshift() 方法不创建新的创建，而是直接修改原有的数组。
注释：该方法会改变数组的长度。
注释：unshift() 方法无法在 Internet Explorer 中正确地工作！
提示：要把一个或多个元素添加到数组的尾部，请使用 push() 方法。

slice()    //从某个已有的数组返回选定的元素
arrayObject.slice(start,end)
slice方法用于提取原数组的一部分，返回一个新数组，原数组不变。
// 它的第一个参数为起始位置（从0开始），第二个参数为终止位置（但该位置的元素本身不包括在内）。如果省略第二个参数，则一直返回到原数组的最后一个成员。
// 格式
arr.slice(start_index, upto_index);
// 用法
var a = ['a', 'b', 'c'];
a.slice(1,2) // ["b"]
a.slice(1) // ["b", "c"]
a.slice(0) // ["a","b","c"]
a.slice(-2) // ["b", "c"]
a.slice(4) // []
a.slice(2, 6) // ["c"]
a.slice(2, 1) // []
如果slice方法的参数是负数，则从尾部开始选择的成员个数；如果参数值大于数组成员的个数，或者第二个参数小于第一个参数，则返回空数组。
// slice方法的一个重要应用，是将类似数组的对象转为真正的数组。
Array.prototype.slice.call({ 0: 'a', 1: 'b', length: 2 })
// ['a', 'b']
Array.prototype.slice.call(document.querySelectorAll("div"));
Array.prototype.slice.call(arguments);
上面代码的参数都不是数组，但是通过call方法，在它们上面调用slice方法，就可以把它们转为真正的数组。

start   //必需。规定从何处开始选取。如果是负数，那么它规定从数组尾部开始算起的位置。也就是说，-1 指最后一个元素，-2 指倒数第二个元素，以此类推。
end     //可选。规定从何处结束选取。该参数是数组片断结束处的数组下标。如果没有指定该参数，那么切分的数组包含从 start 到数组结束的所有元素。如果这个参数是负数，那么它规定的是从数组尾部开始算起的元素。

返回一个新的数组，包含从 start 到 end （不包括该元素）的 arrayObject 中的元素。
说明

请注意，该方法并不会修改数组，而是返回一个子数组。如果想删除数组中的一段元素，应该使用方法 Array.splice()。

sort()  //对数组的元素进行排序，默认是按照字典顺序排序。排序后，原数组将被改变。
arrayObject.sort(sortby)

['d', 'c', 'b', 'a'].sort()
// ['a', 'b', 'c', 'd']
[4, 3, 2, 1].sort()
// [1, 2, 3, 4]
[11, 101].sort()
// [101, 11]
[10111,1101,111].sort()
// [10111, 1101, 111]
注意：sort方法不是按照大小排序，而是按照对应字符串的字典顺序排序，所以101排在11的前面。

如果想让sort方法按照自定义方式排序，可以传入一个函数作为参数，表示按照自定义方法进行排序。该函数本身又接受两个参数，表示进行比较的两个元素。如果返回值"大于0，表示第一个元素排在第二个元素后面"；其他情况下，都是第一个元素排在第二个元素前面。
[10111,1101,111].sort(function (a,b){
  return a - b;
})
// [111, 1101, 10111]

[
  { name: "张三", age: 30 },
  { name: "李四", age: 24 },
  { name: "王五", age: 28  }
].sort(function(o1, o2) {
  return o1.age - o2.age;
})
// [
//   { name: "李四", age: 24 },
//   { name: "王五", age: 28  },
//   { name: "张三", age: 30 }
// ]

如果调用该方法时没有使用参数，将按字母顺序对数组中的元素进行排序，说得更精确点，是按照字符编码的顺序进行排序。要实现这一点，首先应把数组的元素都转换成字符串（如有必要），以便进行比较。

splice()    //删除元素，并向数组添加新元素。然后返回被删除的项目。
arrayObject.splice(index,howmany,item1,.....,itemX)
index   //必需。整数，规定添加删除项目的位置(起始位置)，使用负数可从数组结尾处规定位置。
howmany     //必需。要删除的项目数量。如果设置为 0，则不会删除项目。
item1, ..., itemX   //可选。向数组添加的新项目。

splice() 方法可删除从 index 处开始的零个或多个元素，并且用参数列表中声明的一个或多个值来替换那些被删除的元素。
如果从 arrayObject 中删除了元素，则返回的是含有被删除的元素的数组。

// 格式
arr.splice(index, count_to_remove, addElement1, addElement2, ...);

var a = ["a","b","c","d","e","f"];
a.splice(4,2)
// ["e", "f"] 单纯的删除元素
a
// ["a", "b", "c", "d"]

a.splice(4,2,1,2)
// ["e", "f"] 删除并替换
a
// ["a", "b", "c", "d", 1, 2]

var a = [1, 1, 1];
a.splice(1, 0, 2) // [] 第二个参数为0时，插入元素
a // [1, 2, 1, 1]

var a = [1, 2, 3, 4];
a.splice(2) // [3, 4] 只提供第一个参数，则实际上等同于将原数组在指定位置拆分成两个数组。
a // [1, 2]
注释：请注意，splice() 方法与 slice() 方法的作用是不同的，splice() 方法会直接对数组进行修改。

valueOf 返回数组本身
var a = [1, 2, 3];
a.valueOf() // [1, 2, 3]

toString()  // 返回数组的字符串形式。
返回值: arrayObject 的字符串表示。返回值与没有参数的 join() 方法返回的字符串相同。
var a = [1, 2, 3];
a.toString() // "1,2,3"
var a = [1, 2, 3, [4, 5, 6]];
a.toString() // "1,2,3,4,5,6"

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
// forEach 除了接受一个必须的回调函数参数，还可以接受一个可选的上下文参数（改变回调函数里面的this指向）（第2个参数）。类似 map 。
var out = [];
[1, 2, 3].forEach(function(elem) {
  this.push(elem * elem);
}, out);
out // [1, 4, 9]
上面代码中，空数组out是forEach方法的第二个参数，结果，回调函数内部的this关键字就指向out。

// forEach 会跳过空元素
var array = [1, 2, 3];

delete array[1]; // 移除 2
alert(array); // "1,,3"

alert(array.length); // but the length is still 3

array.forEach(alert); // 弹出的仅仅是1和3

2. map // 基本用法与forEach类似，也是遍历数组的所有成员，执行某种操作，但是forEach方法没有返回值，一般只用来操作数据。如果需要有返回值，一般使用map方法。
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

map方法不仅可以用于数组，还可以用于字符串，用来遍历字符串的每个字符。但是，不能直接用，而要通过函数的call方法间接使用，或者先将字符串转为数组，然后使用。

var upper = function (x) { return x.toUpperCase() };

[].map.call('abc', upper)
// [ 'A', 'B', 'C' ]

// 或者
'abc'.split('').map(upper)
// [ 'A', 'B', 'C' ]
其他类似数组的对象（比如document.querySelectorAll方法返回DOM节点集合），也可以用上面的方法遍历。

map方法还可以接受第二个参数，表示回调函数执行时this所指向的对象。

var arr = ['a', 'b', 'c'];

[1, 2].map(function(e){
  return this[e]; // 这里的this 指向 map 第二个参数 arr
}, arr)
// ['b', 'c']
上面代码通过map方法的第二个参数，将回调函数内部的this对象，指向arr数组。

map方法通过键名，遍历数组的所有成员。所以，只要数组的某个成员取不到键名，map方法就会跳过它。

var f = function(n){ return n + 1 };

[1, undefined, 2].map(f) // [2, NaN, 3]
[1, null, 2].map(f) // [2, 1, 3]
[1, , 2].map(f) // [2, undefined, 3]
上面代码中，数组的成员依次包含undefined、null和空位。前两种情况，map方法都不会跳过它们，因为可以取到undefined和null的键名。第三种情况，map方法实际上跳过第二个位置，因为取不到它的键名。

1 in [1, , 2] // false
上面代码说明，第二个位置的空位是取不到键名的，因此map方法会跳过它。

下面的例子会更清楚地说明这一点。

[undefined, undefined].map(function (){
  console.log('enter...');
  return 1;
})
// enter...
// enter...
// [1, 1]

Array(2).map(function (){
  console.log('enter...');
  return 1;
})
// [undefined x 2]
上面代码中，Array(2)生成的空数组是取不到键名的，因此map方法根本没有执行，直接返回了Array(2)生成的空数组。

3. filter // 依次对所有数组成员调用一个测试函数，返回结果为true的成员组成一个新数组返回。
[1, 2, 3, 4, 5].filter(function (elem) {
  return (elem > 3);
})
// [4, 5]

array.filter(callback,[ thisObject]);

var emailsZhang = users
  // 获得邮件
  .map(function (user) { return user.email; })
  // 筛选出zhang开头的邮件
  .filter(function(email) {  return /^zhang/.test(email); });

console.log(emailsZhang.join(", ")); // zhang@email.com

filter 和 map 类似，参数方法都可以接收三个参数
[1, 2, 3, 4, 5].filter(function(elem, index, arr){
  return index % 2 === 0;
});
// [1, 3, 5]

filter方法还可以接受第二个参数，指定测试函数所在的上下文对象（即this对象）。

var Obj = function () {
  this.MAX = 3;
};

var myFilter = function(item) {
  if (item > this.MAX) {
    return true;
  }
};

var arr = [2,8,3,4,1,3,2,9];
arr.filter(myFilter, new Obj())
// [8, 4, 9] myFilter 中的 this 指向 filter 的第二个参数
上面代码中，测试函数myFilter内部有this对象，它可以被filter方法的第二个参数绑定。

[some 和 every] 这两个方法类似“断言”（assert），用来判断数组成员是否符合某种条件。
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

6. indexOf 和 lastIndexOf// indexOf方法在字符串中自古就有，string.indexOf(searchString, position)。数组这里的indexOf方法与之类似。返回给定元素在数组中第一次出现的位置，如果没有出现则返回-1。
var a = ['a', 'b', 'c'];

a.indexOf('b') // 1
a.indexOf('y') // -1

indexOf方法还可以接受第二个参数，表示搜索的开始位置。

var data = [2, 5, 7, 3, 5];
data.indexOf(5, "x"); // 1 ("x"被忽略)
data.indexOf(5, "3"); // 4 (从3号位开始搜索)
data.indexOf(4); // -1 (未找到)
data.indexOf("5"); // -1 (未找到，因为5 !== "5")

lastIndexOf方法返回给定元素在数组中最后一次出现的位置，如果没有出现则返回-1。

var data = [2, 5, 7, 3, 5];
data.lastIndexOf(5); // 4
data.lastIndexOf(5, 3); // 1 (从后往前，索引值小于3的开始搜索)
data.lastIndexOf(4); // -1 (未找到)

注意，如果数组中包含NaN，这两个方法不适用。
[NaN].indexOf(NaN) // -1
[NaN].lastIndexOf(NaN) // -1

这是因为这两个方法内部，使用严格相等运算符（===）进行比较，而NaN是唯一一个不等于自身的值。

8. reduce 和 reduceRight // 归约，与reduce区别在于，reduceRight是从数组的末尾开始实现

reduce方法的第一个参数是一个处理函数。该函数接受四个参数，分别是：
	用来累计的变量（即当前状态），默认值为数组的第一个元素
	数组的当前元素
	当前元素在数组中的序号（从0开始）
	原数组
这四个参数之中，只有前两个是必须的，后两个则是可选的。

[1, 2, 3, 4, 5].reduce(function(x, y){
    return x+y;
});
// 15
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

如果要对累计变量指定初值，可以把它放在reduce方法的第二个参数。
[1, 2, 3, 4, 5].reduce(function(x, y){
  return x+y;
}, 10);
// 25
上面代码指定参数x的初值为10，所以数组元素从10开始累加，最终结果为25。

由于reduce方法依次处理每个元素，所以实际上还可以用它来搜索某个元素。比如，下面代码是找出长度最长的数组元素。
function findLongest(entries) {
  return entries.reduce(function (longest, entry) {
    return entry.length > longest.length ? entry : longest;
  }, '');
}

[ES6 扩展方法]
1. Array.from方法用于将两类对象转为真正的数组：类似数组的对象（array-like object）和可遍历（iterable）的对象（包括ES6新增的数据结构Set和Map）。

下面是一个类似数组的对象，Array.from将它转为真正的数组。

let arrayLike = {
    '0': 'a',
    '1': 'b',
    '2': 'c',
    length: 3
};

// ES5的写法
var arr1 = [].slice.call(arrayLike); // ['a', 'b', 'c']

// ES6的写法
let arr2 = Array.from(arrayLike); // ['a', 'b', 'c']

实际应用中，常见的类似数组的对象是DOM操作返回的NodeList集合，以及函数内部的arguments对象。Array.from都可以将它们转为真正的数组。

// NodeList对象
let ps = document.querySelectorAll('p');
Array.from(ps).forEach(function (p) {
  console.log(p);
});

// arguments对象
function foo() {
  var args = Array.from(arguments);
  // ...
}

上面代码中，querySelectorAll方法返回的是一个类似数组的对象，只有将这个对象转为真正的数组，才能使用forEach方法。

只要是部署了Iterator接口的数据结构，Array.from都能将其转为数组。

Array.from('hello') 
// ['h', 'e', 'l', 'l', 'o']

let namesSet = new Set(['a', 'b'])
Array.from(namesSet) // ['a', 'b']

上面代码中，字符串和Set结构都具有Iterator接口，因此可以被Array.from转为真正的数组。

如果参数是一个真正的数组，Array.from会返回一个一模一样的新数组。

Array.from([1, 2, 3])
// [1, 2, 3]

值得提醒的是，扩展运算符（...）也可以将某些数据结构转为数组。

// arguments对象
function foo() {
  var args = [...arguments];
}

// NodeList对象
[...document.querySelectorAll('div')]

扩展运算符背后调用的是遍历器接口（Symbol.iterator），如果一个对象没有部署这个接口，就无法转换。Array.from方法则是还支持类似数组的对象。所谓类似数组的对象，本质特征只有一点，即必须有length属性。因此，任何有length属性的对象，都可以通过Array.from方法转为数组，而此时扩展运算符就无法转换。

Array.from({ length: 3 });
// [ undefined, undefined, undefinded ]

上面代码中，Array.from返回了一个具有三个成员的数组，每个位置的值都是undefined。扩展运算符转换不了这个对象。

对于还没有部署该方法的浏览器，可以用Array.prototype.slice方法替代。

const toArray = (() =>
  Array.from ? Array.from : obj => [].slice.call(obj)
)();

Array.from还可以接受第二个参数，作用类似于数组的map方法，用来对每个元素进行处理，将处理后的值放入返回的数组。

Array.from(arrayLike, x => x * x);
// 等同于
Array.from(arrayLike).map(x => x * x);

Array.from([1, 2, 3], (x) => x * x)
// [1, 4, 9]

下面的例子是取出一组DOM节点的文本内容。

let spans = document.querySelectorAll('span.name');

// map()
let names1 = Array.prototype.map.call(spans, s => s.textContent);

// Array.from()
let names2 = Array.from(spans, s => s.textContent)

下面的例子将数组中布尔值为false的成员转为0。

Array.from([1, , 2, , 3], (n) => n || 0)
// [1, 0, 2, 0, 3]

另一个例子是返回各种数据的类型。

function typesOf () {
  return Array.from(arguments, value => typeof value)
}
typesOf(null, [], NaN)
// ['object', 'object', 'number']

如果map函数里面用到了this关键字，还可以传入Array.from的第三个参数，用来绑定this。

Array.from()可以将各种值转为真正的数组，并且还提供map功能。这实际上意味着，只要有一个原始的数据结构，你就可以先对它的值进行处理，然后转成规范的数组结构，进而就可以使用数量众多的数组方法。

Array.from({ length: 2 }, () => 'jack')
// ['jack', 'jack']

上面代码中，Array.from的第一个参数指定了第二个参数运行的次数。这种特性可以让该方法的用法变得非常灵活。

Array.from()的另一个应用是，将字符串转为数组，然后返回字符串的长度。因为它能正确处理各种Unicode字符，可以避免JavaScript将大于\uFFFF的Unicode字符，算作两个字符的bug。

function countSymbols(string) {
  return Array.from(string).length;
}

2. Array.of方法用于将一组值，转换为数组。

Array.of(3, 11, 8) // [3,11,8]
Array.of(3) // [3]
Array.of(3).length // 1

这个方法的主要目的，是弥补数组构造函数Array()的不足。因为参数个数的不同，会导致Array()的行为有差异。

Array() // []
Array(3) // [, , ,]
Array(a) // [a]
Array(3, 11, 8) // [3, 11, 8]

上面代码中，Array方法没有参数、一个参数、三个参数时，返回结果都不一样。只有当参数个数不少于2个时，Array()才会返回由参数组成的新数组。参数个数只有一个时，实际上是指定数组的长度。单个字符也会生成有这个字符构成的数组。

Array.of基本上可以用来替代Array()或new Array()，并且不存在由于参数不同而导致的重载。它的行为非常统一。

Array.of() // []
Array.of(undefined) // [undefined]
Array.of(1) // [1]
Array.of(1, 2) // [1, 2]

Array.of总是返回参数值组成的数组。如果没有参数，就返回一个空数组。

Array.of方法可以用下面的代码模拟实现。

function ArrayOf(){
  return [].slice.call(arguments);
}

3. 数组实例的copyWithin方法，在当前数组内部，将指定位置的成员复制到其他位置（会覆盖原有成员），然后返回当前数组。也就是说，使用这个方法，会修改当前数组。

Array.prototype.copyWithin(target, start = 0, end = this.length)

它接受三个参数。
    target（必需）：从该位置开始替换数据。
    start（可选）：从该位置开始读取数据，默认为0。如果为负值，表示倒数。
    end（可选）：到该位置前停止读取数据，默认等于数组长度。如果为负值，表示倒数。
这三个参数都应该是数值，如果不是，会自动转为数值。

[1, 2, 3, 4, 5].copyWithin(0, 3)
// [4, 5, 3, 4, 5]

上面代码表示将从3号位直到数组结束的成员（4和5），复制到从0号位开始的位置，结果覆盖了原来的1和2。

// 将3号位复制到0号位
[1, 2, 3, 4, 5].copyWithin(0, 3, 4)
// [4, 2, 3, 4, 5]

// -2相当于3号位，-1相当于4号位
[1, 2, 3, 4, 5].copyWithin(0, -2, -1)
// [4, 2, 3, 4, 5]

// 将3号位复制到0号位-----------------------------------------------？？？？？？？？？？
[].copyWithin(call({length: 5, 3: 1}), 0, 3)
// {0: 1, 3: 1, length: 5}

// 将2号位到数组结束，复制到0号位
var i32a = new Int32Array([1, 2, 3, 4, 5]);
i32a.copyWithin(0, 2);
// Int32Array [3, 4, 5, 4, 5]

// 对于没有部署TypedArray的copyWithin方法的平台
// 需要采用下面的写法-------------------------------------------------？？？？？？？？
[].copyWithin.call(new Int32Array([1, 2, 3, 4, 5]), 0, 3, 4);
// Int32Array [4, 2, 3, 4, 5]

4. 数组实例的find 和 findIndex方法
find 用于找出第一个符合条件的数组成员。它的参数是一个回调函数，所有数组成员依次执行该回调函数，直到找出第一个返回值为true的成员，然后返回该成员。如果没有符合条件的成员，则返回undefined。

[1, 4, -5, 10].find((n) => n < 0)
// -5

上面代码找出数组中第一个小于0的成员。

[1, 5, 10, 15].find(function(value, index, arr) {
  return value > 9;
}) // 10

上面代码中，find方法的回调函数可以接受三个参数，依次为当前的值、当前的位置和原数组。

数组实例的findIndex方法的用法与find方法非常类似，返回第一个符合条件的数组成员的"位置"，如果所有成员都不符合条件，则返回-1。

[1, 5, 10, 15].findIndex(function(value, index, arr) {
  return value > 9;
}) // 2

这两个方法都可以接受第二个参数，用来绑定回调函数的this对象。

另外，这两个方法都可以发现NaN，弥补了数组的IndexOf方法的不足。
[NaN].indexOf(NaN)
// -1

[NaN].findIndex(y => Object.is(NaN, y))
// 0

上面代码中，indexOf方法无法识别数组的NaN成员，但是findIndex方法可以借助Object.is方法做到。

5. 数组实例的fill()
fill方法使用给定值，填充一个数组。

['a', 'b', 'c'].fill(7)
// [7, 7, 7]

new Array(3).fill(7)
// [7, 7, 7]

上面代码表明，fill方法用于空数组的初始化非常方便。数组中已有的元素，会被全部抹去。

fill方法还可以接受第二个和第三个参数，用于指定填充的起始位置和结束位置。

['a', 'b', 'c'].fill(7, 1, 2)
// ['a', 7, 'c']

上面代码表示，fill方法从1号位开始，向原数组填充7，到2号位之前结束。

6. ES6提供三个新的方法——entries()，keys()和values()——用于遍历数组。它们都返回一个遍历器对象（详见《Iterator》一章），可以用for...of循环进行遍历，唯一的区别是keys()是对键名的遍历、values()是对键值的遍历，entries()是对键值对的遍历。

for (let index of ['a', 'b'].keys()) {
  console.log(index);
}
// 0
// 1

for (let elem of ['a', 'b'].values()) {
  console.log(elem);
}
// 'a'
// 'b'

for (let [index, elem] of ['a', 'b'].entries()) {
  console.log(index, elem);
}
// 0 "a"
// 1 "b"

如果不使用for...of循环，可以手动调用遍历器对象的next方法，进行遍历。

let letter = ['a', 'b', 'c'];
let entries = letter.entries();
console.log(entries.next().value); // [0, 'a']
console.log(entries.next().value); // [1, 'b']
console.log(entries.next().value); // [2, 'c']

7. 数组实例的includes()

Array.prototype.includes方法返回一个布尔值，表示某个数组是否包含给定的值，与字符串的includes方法类似。该方法属于ES7，但Babel转码器已经支持。

[1, 2, 3].includes(2);     // true
[1, 2, 3].includes(4);     // false
[1, 2, NaN].includes(NaN); // true

该方法的第二个参数表示搜索的起始位置，默认为0。如果第二个参数为负数，则表示倒数的位置，如果这时它大于数组长度（比如第二个参数为-4，但数组长度为3），则会重置为从0开始。

[1, 2, 3].includes(3, 3);  // false
[1, 2, 3].includes(3, -1); // true

没有该方法之前，我们通常使用数组的indexOf方法，检查是否包含某个值。

if (arr.indexOf(el) !== -1) {
  // ...
}

indexOf方法有两个缺点，一是不够语义化，它的含义是找到参数值的第一个出现位置，所以要去比较是否不等于-1，表达起来不够直观。二是，它内部使用严格相当运算符（===）进行判断，这会导致对NaN的误判。

[NaN].indexOf(NaN)
// -1

"includes使用的是不一样的判断算法，就没有这个问题。"

[NaN].includes(NaN)
// true

下面代码用来检查当前环境是否支持该方法，如果不支持，部署一个简易的替代版本。

const contains = (() =>
  Array.prototype.includes
    ? (arr, value) => arr.includes(value)
    : (arr, value) => arr.some(el => el === value)
)();
contains(["foo", "bar"], "baz"); // => false

另外，Map和Set数据结构有一个has方法，需要注意与includes区分。

Map结构的has方法，是用来查找键名的，比如Map.prototype.has(key)、WeakMap.prototype.has(key)、Reflect.has(target, propertyKey)。
Set结构的has方法，是用来查找值的，比如Set.prototype.has(value)、WeakSet.prototype.has(value)。

8. 数组的空位

数组的空位指，数组的某一个位置没有任何值。比如，Array构造函数返回的数组都是空位。

Array(3) // [, , ,]

上面代码中，Array(3)返回一个具有3个空位的数组。

注意，空位不是undefined，一个位置的值等于undefined，依然是有值的。空位是没有任何值，in运算符可以说明这一点。

0 in [undefined, undefined, undefined] // true
0 in [, , ,] // false

上面代码说明，第一个数组的0号位置是有值的，第二个数组的0号位置没有值。

ES5对空位的处理，已经很不一致了，大多数情况下会忽略空位。

    forEach(), filter(), every() 和some()都会跳过空位。
    map()会跳过空位，但会保留这个值
    join()和toString()会将空位视为undefined，而undefined和null会被处理成空字符串。

// forEach方法
[,'a'].forEach((x,i) => log(i)); // 1

// filter方法
['a',,'b'].filter(x => true) // ['a','b']

// every方法
[,'a'].every(x => x==='a') // true

// some方法
[,'a'].some(x => x !== 'a') // false

// map方法
[,'a'].map(x => 1) // [,1]

// join方法
[,'a',undefined,null].join('#') // "#a##"

// toString方法
[,'a',undefined,null].toString() // ",a,,"

ES6则是明确将空位转为undefined。

Array.from方法会将数组的空位，转为undefined，也就是说，这个方法不会忽略空位。

Array.from(['a',,'b'])
// [ "a", undefined, "b" ]

扩展运算符（...）也会将空位转为undefined。

[...['a',,'b']]
// [ "a", undefined, "b" ]

copyWithin()会连空位一起拷贝。

[,'a','b',,].copyWithin(2,0) // [,"a",,"a"]

fill()会将空位视为正常的数组位置。

new Array(3).fill('a') // ["a","a","a"]

for...of循环也会遍历空位。

let arr = [, ,];
for (let i of arr) {
  console.log(1);
}
// 1
// 1

上面代码中，数组arr有两个空位，for...of并没有忽略它们。如果改成map方法遍历，空位是会跳过的。

entries()、keys()、values()、find()和findIndex()会将空位处理成undefined。

// entries()
[...[,'a'].entries()] // [[0,undefined], [1,"a"]]

// keys()
[...[,'a'].keys()] // [0,1]

// values()
[...[,'a'].values()] // [undefined,"a"]

// find()
[,'a'].find(x => true) // undefined

// findIndex()
[,'a'].findIndex(x => true) // 0

由于空位的处理规则非常不统一，所以建议避免出现空位。

9. [数组推导]

数组推导（array comprehension）提供简洁写法，允许直接通过现有数组生成新数组。这项功能本来是要放入ES6的，但是TC39委员会想继续完善这项功能，让其支持所有数据结构（内部调用iterator对象），不像现在只支持数组，所以就把它推迟到了ES7。Babel转码器已经支持这个功能。

var a1 = [1, 2, 3, 4];
var a2 = [for (i of a1) i * 2];

a2 // [2, 4, 6, 8]

上面代码表示，通过for...of结构，数组a2直接在a1的基础上生成。

注意，数组推导中，for...of结构总是写在最前面，返回的表达式写在最后面。

for...of后面还可以附加if语句，用来设定循环的限制条件。

var years = [ 1954, 1974, 1990, 2006, 2010, 2014 ];

[for (year of years) if (year > 2000) year];
// [ 2006, 2010, 2014 ]

[for (year of years) if (year > 2000) if(year < 2010) year];
// [ 2006]

[for (year of years) if (year > 2000 && year < 2010) year];
// [ 2006]

上面代码表明，if语句要写在for...of与返回的表达式之间，而且可以多个if语句连用。

下面是另一个例子。

var customers = [
  {
    name: 'Jack',
    age: 25,
    city: 'New York'
  },
  {
    name: 'Peter',
    age: 30,
    city: 'Seattle'
  }
];

var results = [
  for (c of customers)
    if (c.city == "Seattle")
      { name: c.name, age: c.age }
];
results // { name: "Peter", age: 30 }

数组推导可以替代map和filter方法。

[for (i of [1, 2, 3]) i * i];
// 等价于
[1, 2, 3].map(function (i) { return i * i });

[for (i of [1,4,2,3,-8]) if (i < 3) i];
// 等价于
[1,4,2,3,-8].filter(function(i) { return i < 3 });

上面代码说明，模拟map功能只要单纯的for...of循环就行了，模拟filter功能除了for...of循环，还必须加上if语句。

在一个数组推导中，还可以使用多个for...of结构，构成多重循环。

var a1 = ['x1', 'y1'];
var a2 = ['x2', 'y2'];
var a3 = ['x3', 'y3'];

[for (s of a1) for (w of a2) for (r of a3) console.log(s + w + r)];
// x1x2x3
// x1x2y3
// x1y2x3
// x1y2y3
// y1x2x3
// y1x2y3
// y1y2x3
// y1y2y3

上面代码在一个数组推导之中，使用了三个for...of结构。

需要注意的是，数组推导的方括号构成了一个单独的作用域，在这个方括号中声明的变量类似于使用let语句声明的变量。

由于字符串可以视为数组，因此字符串也可以直接用于数组推导。

[for (c of 'abcde') if (/[aeiou]/.test(c)) c].join('') // 'ae'

[for (c of 'abcde') c+'0'].join('') // 'a0b0c0d0e0'

上面代码使用了数组推导，对字符串进行处理。

数组推导需要注意的地方是，新数组会立即在内存中生成。这时，如果原数组是一个很大的数组，将会非常耗费内存。