var o = {
  p: 'Hello World'
};

如果键名不符合标识名的条件（比如第一个字符为数字，或者含有空格或运算符），也不是数字，则必须加上引号。
如果键名是数字，则会默认转为对应的字符串。

var obj = {
  1e2: true,
  1e-2: true,
  .234: true,
  0xFF: true,
};

Obj
// {
//   100: true,
//   0.01: true,
//   0.234: true,
//   255: true
// }

上面代码表示，如果键名为数值，则会先转为标准形式的数值，然后再转为字符串。

ES6允许在对象之中，只写属性名，不写属性值。这时，属性值等于属性名所代表的变量。
var foo = 'bar';
var baz = {foo};
baz // {foo: "bar"}

// 等同于
var baz = {foo: foo};

var birth = '2000/01/01';
var Person = {
  name: '张三',
  //等同于birth: birth
  birth,
  // 等同于hello: function ()...
  hello() { console.log('我的名字是', this.name); }
};

注意，简洁写法的属性名总是字符串，这会导致一些看上去比较奇怪的结果。
var obj = {
  class () {}
};
// 等同于
var obj = {
  'class': function() {}
};
上面代码中，class是字符串，所以不会因为它属于关键字，而导致语法解析报错。

属性的赋值器（setter）和取值器（getter），事实上也是采用这种写法。
var cart = {
  _wheels: 4,

  get wheels () {
    return this._wheels;
  },

  set wheels (value) {
    if (value < this._wheels) {
      throw new Error('数值太小了！');
    }
    this._wheels = value;
  }
}

如果某个方法的值是一个Generator函数，前面需要加上星号。
var obj = {
  * m(){
    yield 'hello world';
  }
}

属性名表达式
// 方法一
obj.foo = true;
// 方法二
obj['a' + 'bc'] = 123;
ES6允许字面量定义对象时，用方法二（表达式）作为对象的属性名，即把表达式放在方括号内。
var lastWord = 'last word';

var a = {
  'first word': 'hello',
  [lastWord]: 'world'
};

a['first word'] // "hello"
a[lastWord] // "world"
a['last word'] // "world"

表达式还可以用于定义方法名。

let obj = {
  ['h'+'ello']() {
    return 'hi';
  }
};

obj.hello() // hi

注意，属性名表达式与简洁表示法，不能同时使用，会报错。

// 报错
var foo = 'bar';
var bar = 'abc';
var baz = { [foo] };

// 正确
var foo = 'bar';
var baz = { [foo]: 'abc' };

读取对象的属性，有两种方法，一种是使用点运算符，还有一种是使用方括号运算符。

var o = {
  p: 'Hello World'
};
o.p // "Hello World"
o['p'] // "Hello World"

请注意，如果使用方括号运算符，键名必须放在引号里面，否则会被当作变量处理。但是，数字键可以不加引号，因为会被当作字符串处理。

var o = {
  0.7: "Hello World"
};

o.['0.7'] // "Hello World"
o[0.7] // "Hello World"

方括号运算符内部可以使用表达式。

o['hello' + ' world']
o[3 + 3]

数值键名不能使用点运算符（因为会被当成小数点），只能使用方括号运算符。

obj.0xFF
// SyntaxError: Unexpected token
obj[0xFF]
// true

检查变量是否声明

如果读取一个不存在的键，会返回undefined，而不是报错。可以利用这一点，来检查一个变量是否被声明。

// 检查a变量是否被声明

if(a) {...} // 报错

if(window.a) {...} // 不报错
if(window['a']) {...} // 不报错

上面的后二种写法之所以不报错，是因为在浏览器环境，所有全局变量都是window对象的属性。window.a的含义就是读取window对象的a属性，如果该属性不存在，就返回undefined，并不会报错。

需要注意的是，后二种写法有漏洞，如果a属性是一个空字符串（或其他对应的布尔值为false的情况），则无法起到检查变量是否声明的作用。正确的写法是使用in运算符。

if('a' in window) {
  ...
}

写入属性

点运算符和方括号运算符，不仅可以用来读取值，还可以用来赋值。

o.p = 'abc';
o['p'] = 'abc';

上面代码分别使用点运算符和方括号运算符，对属性p赋值。

JavaScript允许属性的“后绑定”，也就是说，你可以在任意时刻新增属性，没必要在定义对象的时候，就定义好属性。

var o = { p: 1 };

// 等价于

var o = {};
o.p = 1;

查看所有属性

查看一个对象本身的所有属性，可以使用Object.keys方法。

var o = {
  key1: 1,
  key2: 2
};

Object.keys(o);
// ['key1', 'key2']

属性的删除

删除一个属性，需要使用delete命令。

var o = {p: 1};
Object.keys(o) // ["p"]

delete o.p // true
o.p // undefined
Object.keys(o) // []

上面代码表示，一旦使用delete命令删除某个属性，再读取该属性就会返回undefined，而且Object.keys方法返回的该对象的所有属性中，也将不再包括该属性。

麻烦的是，如果删除一个不存在的属性，delete不报错，而且返回true。

var o = {};
delete o.p // true

上面代码表示，delete命令只能用来保证某个属性的值为undefined，而无法保证该属性是否真的存在。

只有一种情况，delete命令会返回false，那就是该属性存在，且不得删除。

var o = Object.defineProperty({}, "p", {
        value: 123,
        configurable: false
});

o.p // 123
delete o.p // false

上面代码之中，o对象的p属性是不能删除的，所以delete命令返回false（关于Object.defineProperty方法的介绍，请看《标准库》一章的Object对象章节）。

另外，需要注意的是，delete命令只能删除对象本身的属性，不能删除继承的属性（关于继承参见《面向对象编程》一节）。delete命令也不能删除var命令声明的变量，只能用来删除属性。

如果不同的变量名指向同一个对象，那么它们都是这个对象的引用，也就是说指向同一个内存地址。修改其中一个变量，会影响到其他所有变量。
但是，这种引用只局限于对象，对于原始类型的数据则是传值引用，也就是说，都是值的拷贝。

in 运算符
in运算符用于检查对象是否包含某个属性（注意，检查的是键名，不是键值），如果包含就返回true，否则返回false。继承的属性也会识别
if ('x' in window) { return 1; }

in 运算符的一个问题是，它不能识别对象继承的属性。
var o = new Object();
o.hasOwnProperty('toString') // false
'toString' in o // true
上面代码中，toString方法是对象 o 继承的属性，hasOwnProperty方法可以说明这一点。in 对继承的属性也返回true。

for...in 循环用来遍历一个对象的全部属性。
使用for...in循环，进行数组赋值的例子。
var props = [], i = 0;

for (props[i++] in {x: 1, y: 2});

props // ['x', 'y']

注意，for...in循环遍历的是对象所有可enumberable的属性，其中不仅包括定义在对象本身的属性，还包括对象继承的属性。

with 为操作同一个对象的多个属性提供书写方便。
// 例一
with (o) {
  p1 = 1;
  p2 = 2;
}
// 等同于
o.p1 = 1;
o.p2 = 2;

// 例二
with (document.links[0]){
  console.log(href);
  console.log(title);
  console.log(style);
}
// 等同于
console.log(document.links[0].href);
console.log(document.links[0].title);
console.log(document.links[0].style);

注意，with区块内部的变量，必须是当前对象已经存在的属性，否则会创造一个当前作用域的全局变量。这是因为with区块没有改变作用域，它的内部依然是当前作用域。
var o = {};

with (o) {
  x = "abc";
}

o.x // undefined
x // "abc"

上面代码中，对象o没有属性x，所以with区块内部对x的操作，等于创造了一个全局变量x。正确的写法应该是，先定义对象o的属性x，然后在with区块内操作它。

with (o) {
  console.log(x);
}

单纯从上面的代码块，根本无法判断x到底是全局变量，还是o对象的一个属性。这非常不利于代码的除错和模块化，编译器也无法对这段代码进行优化，只能留到运行时判断，这就拖慢了运行速度。因此，建议不要使用with语句，可以考虑用一个临时变量代替with。

with(o1.o2.o3) {
  console.log(p1 + p2);
}

// 可以写成
var temp = o1.o2.o3;
console.log(temp.p1 + temp.p2);

1. Object.is()

ES5比较两个值是否相等，只有两个运算符：相等运算符（==）和严格相等运算符（===）。它们都有缺点，前者会自动转换数据类型，后者的NaN不等于自身，以及+0等于-0。JavaScript缺乏一种运算，在所有环境中，只要两个值是一样的，它们就应该相等。

ES6提出“Same-value equality”（同值相等）算法，用来解决这个问题。Object.is就是部署这个算法的新方法。它用来比较两个值是否严格相等，与严格比较运算符（===）的行为基本一致。

Object.is('foo', 'foo')
// true
Object.is({}, {})
// false

不同之处只有两个：一是+0不等于-0，二是NaN等于自身。

+0 === -0 //true
NaN === NaN // false

Object.is(+0, -0) // false
Object.is(NaN, NaN) // true

//Object.assign()
Object.assign()

Object.assign方法用于对象的合并，将源对象（source）的所有可枚举属性，复制到目标对象（target）。

var target = { a: 1 };

var source1 = { b: 2 };
var source2 = { c: 3 };

Object.assign(target, source1, source2);
target // {a:1, b:2, c:3}

Object.assign方法至少需要两个对象作为参数，第一个参数是目标对象，后面的参数都是源对象。只要有一个参数不是对象，就会抛出TypeError错误。

注意，如果目标对象与源对象有同名属性，或多个源对象有同名属性，则后面的属性会覆盖前面的属性。

var target = { a: 1, b: 1 };

var source1 = { b: 2, c: 2 };
var source2 = { c: 3 };

Object.assign(target, source1, source2);
target // {a:1, b:2, c:3}

Object.assign只拷贝自身属性，不可枚举的属性（enumerable为false）和继承的属性不会被拷贝。

Object.assign({b: 'c'},
  Object.defineProperty({}, 'invisible', {
    enumerable: false,
    value: 'hello'
  })
)
// { b: 'c' }

上面代码中，Object.assign要拷贝的对象只有一个不可枚举属性invisible，这个属性并没有被拷贝进去。

属性名为Symbol值的属性，也会被Object.assign拷贝。

Object.assign({ a: 'b' }, { [Symbol('c')]: 'd' })
// { a: 'b', Symbol(c): 'd' }

Object.assign方法实行的是浅拷贝，而不是深拷贝。也就是说，如果源对象某个属性的值是对象，那么目标对象拷贝得到的是这个对象的引用。

var obj1 = {a: {b: 1}};
var obj2 = Object.assign({}, obj1);

obj1.a.b = 2;
obj2.a.b // 2

上面代码中，源对象obj1的a属性的值是一个对象，Object.assign拷贝得到的是这个对象的引用。这个对象的任何变化，都会反映到目标对象上面。

对于这种嵌套的对象，一旦遇到同名属性，Object.assign的处理方法是替换，而不是添加。

var target = { a: { b: 'c', d: 'e' } }
var source = { a: { b: 'hello' } }
Object.assign(target, source)
// { a: { b: 'hello' } }

上面代码中，target对象的a属性被source对象的a属性整个替换掉了，而不会得到{ a: { b: 'hello', d: 'e' } }的结果。这通常不是开发者想要的，需要特别小心。

有一些函数库提供Object.assign的定制版本（比如Lodash的_.defaultsDeep方法），可以解决浅拷贝的问题，得到深拷贝的合并。

注意，Object.assign可以用来处理数组，但是会把数组视为对象。

Object.assign([1, 2, 3], [4, 5])
// [4, 5, 3]

上面代码中，Object.assign把数组视为属性名为0、1、2的对象，因此目标数组的0号属性4覆盖了原数组的0号属性1。

Object.assign方法有很多用处。

（1）为对象添加属性

class Point {
  constructor(x, y) {
    Object.assign(this, {x, y});
  }
}

上面方法通过assign方法，将x属性和y属性添加到Point类的对象实例。

（2）为对象添加方法


Object.assign(SomeClass.prototype, {
  someMethod(arg1, arg2) {
    ···
  },
  anotherMethod() {
    ···
  }
});

// 等同于下面的写法
SomeClass.prototype.someMethod = function (arg1, arg2) {
  ···
};
SomeClass.prototype.anotherMethod = function () {
  ···
};

上面代码使用了对象属性的简洁表示法，直接将两个函数放在大括号中，再使用assign方法添加到SomeClass.prototype之中。

（3）克隆对象

function clone(origin) {
  return Object.assign({}, origin);
}

上面代码将原始对象拷贝到一个空对象，就得到了原始对象的克隆。

不过，采用这种方法克隆，只能克隆原始对象自身的值，不能克隆它继承的值。如果想要保持继承链，可以采用下面的代码。

function clone(origin) {
  let originProto = Object.getPrototypeOf(origin);
  return Object.assign(Object.create(originProto), origin);
}

（4）合并多个对象

将多个对象合并到某个对象。

const merge =
  (target, ...sources) => Object.assign(target, ...sources);

如果希望合并后返回一个新对象，可以改写上面函数，对一个空对象合并。

const merge =
  (...sources) => Object.assign({}, ...sources);

（5）为属性指定默认值

const DEFAULTS = {
  logLevel: 0,
  outputFormat: 'html'
};

function processContent(options) {
  let options = Object.assign({}, DEFAULTS, options);
}

上面代码中，DEFAULTS对象是默认值，options对象是用户提供的参数。Object.assign方法将DEFAULTS和options合并成一个新对象，如果两者有同名属性，则option的属性值会覆盖DEFAULTS的属性值。

注意，由于存在深拷贝的问题，DEFAULTS对象和options对象的所有属性的值，都只能是简单类型，而不能指向另一个对象。否则，将导致DEFAULTS对象的该属性不起作用。

//Set 基本用法
ES6提供了新的数据结构Set。它类似于数组，但是成员的值都是唯一的，没有重复的值。

Set本身是一个构造函数，用来生成Set数据结构。

var s = new Set();

[2,3,5,4,5,2,2].map(x => s.add(x))

for (let i of s) {console.log(i)}
// 2 3 5 4

上面代码通过add方法向Set结构加入成员，结果表明Set结构不会添加重复的值。

Set函数可以接受一个数组（或类似数组的对象）作为参数，用来初始化。

var set = new Set([1, 2, 3, 4, 4])
[...set]
// [1, 2, 3, 4]

var items = new Set([1, 2, 3, 4, 5, 5, 5, 5]);
items.size // 5

function divs () {
  return [...document.querySelectorAll('div')]
}

var set = new Set(divs())
set.size // 56

// 类似于
divs().forEach(div => set.add(div))
set.size // 56

向Set加入值的时候，不会发生类型转换，所以5和"5"是两个不同的值。Set内部判断两个值是否不同，使用的算法叫做“Same-value equality”，它类似于精确相等运算符（===），主要的区别是NaN等于自身，而精确相等运算符认为NaN不等于自身。

let set = new Set();
let a = NaN;
let b = NaN;
set.add(a);
set.add(b);
set // Set {NaN}

上面代码向Set实例添加了两个NaN，但是只能加入一个。这表明，在Set内部，两个NaN是相等。

另外，两个对象总是不相等的。

let set = new Set();

set.add({})
set.size // 1

set.add({})
set.size // 2

上面代码表示，由于两个空对象不相等，所以它们被视为两个值。

Set结构的实例有以下属性。

    Set.prototype.constructor：构造函数，默认就是Set函数。
    Set.prototype.size：返回Set实例的成员总数。

Set实例的方法分为两大类：操作方法（用于操作数据）和遍历方法（用于遍历成员）。下面先介绍四个操作方法。

    add(value)：添加某个值，返回Set结构本身。
    delete(value)：删除某个值，返回一个布尔值，表示删除是否成功。
    has(value)：返回一个布尔值，表示该值是否为Set的成员。
    clear()：清除所有成员，没有返回值。
判断是否包括一个键上面，Object结构和Set结构的写法不同。

// 对象的写法
var properties = {
  "width": 1,
  "height": 1
};

if (properties[someName]) {
  // do something
}

// Set的写法
var properties = new Set();

properties.add("width");
properties.add("height");

if (properties.has(someName)) {
  // do something
}

Array.from方法可以将Set结构转为数组。

var items = new Set([1, 2, 3, 4, 5]);
var array = Array.from(items);

这就提供了一种去除数组的重复元素的方法。

function dedupe(array) {
  return Array.from(new Set(array));
}
dedupe([1,1,2,3]) // [1, 2, 3]

Set结构的实例有四个遍历方法，可以用于遍历成员。

    keys()：返回一个键名的遍历器
    values()：返回一个键值的遍历器
    entries()：返回一个键值对的遍历器
    forEach()：使用回调函数遍历每个成员
由于Set结构没有键名，只有键值（或者说键名和键值是同一个值），所以key方法和value方法的行为完全一致。
for ( let item of set.values() ){
  console.log(item);
}
// red
// green
// blue

for ( let item of set.entries() ){
  console.log(item);
}
// ["red", "red"]
// ["green", "green"]
// ["blue", "blue"]

Set结构的实例默认可遍历，它的默认遍历器生成函数就是它的values方法。

Set.prototype[Symbol.iterator] === Set.prototype.values
// true

这意味着，可以省略values方法，直接用for...of循环遍历Set。

let set = new Set(['red', 'green', 'blue']);

for (let x of set) {
  console.log(x);
}
// red
// green
// blue

由于扩展运算符（...）内部使用for...of循环，所以也可以用于Set结构。

let set = new Set(['red', 'green', 'blue']);
let arr = [...set];
// ['red', 'green', 'blue']

这就提供了另一种便捷的去除数组重复元素的方法。

let arr = [3, 5, 2, 2, 5, 5];
let unique = [...new Set(arr)];
// [3, 5, 2]

而且，数组的map和filter方法也可以用于Set了。

let set = new Set([1, 2, 3]);
set = new Set([...set].map(x => x * 2));
// 返回Set结构：{2, 4, 6}

let set = new Set([1, 2, 3, 4, 5]);
set = new Set([...set].filter(x => (x % 2) == 0));
// 返回Set结构：{2, 4}

因此使用Set，可以很容易地实现并集（Union）、交集（Intersect）和差集（Difference）。

let a = new Set([1, 2, 3]);
let b = new Set([4, 3, 2]);

// 并集
let union = new Set([...a, ...b]);
// [1, 2, 3, 4]

// 交集
let intersect = new Set([...a].filter(x => b.has(x)));
// [2, 3]

// 差集
let difference = new Set([...a].filter(x => !b.has(x)));
// [1]

Set结构的实例的forEach方法，用于对每个成员执行某种操作，没有返回值。

let set = new Set([1, 2, 3]);
set.forEach((value, key) => console.log(value * 2) )
// 2
// 4
// 6

forEach方法的参数就是一个处理函数。该函数的参数依次为键值、键名、集合本身（上例省略了该参数）。另外，forEach方法还可以有第二个参数，表示绑定的this对象。

如果想在遍历操作中，同步改变原来的Set结构，目前没有直接的方法，但有两种变通方法。一种是利用原Set结构映射出一个新的结构，然后赋值给原来的Set结构；另一种是利用Array.from方法。

// 方法一
let set = new Set([1, 2, 3]);
set = new Set([...set].map(val => val * 2));
// set的值是2, 4, 6

// 方法二
let set = new Set([1, 2, 3]);
set = new Set(Array.from(set, val => val * 2));
// set的值是2, 4, 6

上面代码提供了两种方法，直接在遍历操作中改变原来的Set结构。

//WeakSet
WeakSet结构与Set类似，也是不重复的值的集合。但是，它与Set有两个区别。

首先，WeakSet的成员只能是对象，而不能是其他类型的值。

其次，WeakSet中的对象都是弱引用，即垃圾回收机制不考虑WeakSet对该对象的引用，也就是说，如果其他对象都不再引用该对象，那么垃圾回收机制会自动回收该对象所占用的内存，不考虑该对象还存在于WeakSet之中。这个特点意味着，无法引用WeakSet的成员，因此WeakSet是不可遍历的。

var ws = new WeakSet();
ws.add(1)
// TypeError: Invalid value used in weak set
ws.add(Symbol())
// TypeError: invalid value used in weak set

上面代码试图向WeakSet添加一个数值和Symbol值，结果报错，因为WeakSet只能放置对象。

WeakSet是一个构造函数，可以使用new命令，创建WeakSet数据结构。

var ws = new WeakSet();

作为构造函数，WeakSet可以接受一个数组或类似数组的对象作为参数。（实际上，任何具有iterable接口的对象，都可以作为WeakSet的参数。）该数组的所有成员，都会自动成为WeakSet实例对象的成员。

var a = [[1,2], [3,4]];
var ws = new WeakSet(a);

上面代码中，a是一个数组，它有两个成员，也都是数组。将a作为WeakSet构造函数的参数，a的成员会自动成为WeakSet的成员。

注意，是a数组的成员成为WeakSet的成员，而不是a数组本身。这意味着，数组的成员只能是对象。

WeakSet结构有以下三个方法。

    WeakSet.prototype.add(value)：向WeakSet实例添加一个新成员。
    WeakSet.prototype.delete(value)：清除WeakSet实例的指定成员。
    WeakSet.prototype.has(value)：返回一个布尔值，表示某个值是否在WeakSet实例之中。

WeakSet没有size属性，没有办法遍历它的成员。

ws.size // undefined
ws.forEach // undefined

ws.forEach(function(item){ console.log('WeakSet has ' + item)})
// TypeError: undefined is not a function

上面代码试图获取size和forEach属性，结果都不能成功。

WeakSet不能遍历，是因为成员都是弱引用，随时可能消失，遍历机制无法保证成员的存在，很可能刚刚遍历结束，成员就取不到了。WeakSet的一个用处，是储存DOM节点，而不用担心这些节点从文档移除时，会引发内存泄漏。

下面是WeakSet的另一个例子。

const foos = new WeakSet()
class Foo {
  constructor() {
    foos.add(this)
  }
  method () {
    if (!foos.has(this)) {
      throw new TypeError('Foo.prototype.method 只能在Foo的实例上调用！')
    }
  }
}

上面代码保证了Foo的实例方法，只能在Foo的实例上调用。这里使用WeakSet的好处是，foos对实例的引用，不会被计入内存回收机制，所以删除实例的时候，不用考虑foos，也不会出现内存泄漏。

//Map结构的目的和基本用法
JavaScript的对象（Object），本质上是键值对的集合（Hash结构），但是只能用字符串当作键。这给它的使用带来了很大的限制。

var data = {};
var element = document.getElementById("myDiv");

data[element] = metadata;
data["[Object HTMLDivElement]"] // metadata

上面代码原意是将一个DOM节点作为对象data的键，但是由于对象只接受字符串作为键名，所以element被自动转为字符串[Object HTMLDivElement]。

ES6提供了Map数据结构。它类似于对象，也是键值对的集合，但是“键”的范围不限于字符串，各种类型的值（包括对象）都可以当作键。也就是说，Object结构提供了“字符串—值”的对应，Map结构提供了“值—值”的对应，是一种更完善的Hash结构实现。如果你需要“键值对”的数据结构，Map比Object更合适。

var m = new Map();
var o = {p: "Hello World"};

m.set(o, "content")
m.get(o) // "content"

m.has(o) // true
m.delete(o) // true
m.has(o) // false

上面代码使用set方法，将对象o当作m的一个键，然后又使用get方法读取这个键，接着使用delete方法删除了这个键。

作为构造函数，Map也可以接受一个数组作为参数。该数组的成员是一个个表示键值对的数组。
var map = new Map([["name", "张三"], ["title", "Author"]]);
map.size // 2
map.has("name") // true
map.get("name") // "张三"
map.has("title") // true
map.get("title") // "Author"

Map 的键实际上是跟内存地址绑定的，只要内存地址不一样，就视为两个键。这就解决了同名属性碰撞（clash）的问题，我们扩展别人的库的时候，如果使用对象作为键名，就不用担心自己的属性与原作者的属性同名。

如果Map的键是一个简单类型的值（数字、字符串、布尔值），则只要两个值严格相等，Map将其视为一个键，包括0和-0。另外，虽然NaN不严格相等于自身，但Map将其视为同一个键。

Map 实例的属性和操作方法
    proterty.size 返回Map结构的成员总数
    proterty.set(key,value) 设置key所对应的键值，然后返回整个Map结构。如果key已经有值，则键值会被更新，否则就新生成该键。
    proterty.get(key) 读取key对应的键值，如果找不到key，返回undefined。
    proterty.has(key) 返回一个布尔值，表示某个键是否在Map数据结构中。
    proterty.delete(key) 删除某个键，返回true。如果删除失败，返回false。
    proterty.clear() 清除所有成员，没有返回值。
注：set方法返回的是Map本身，因此可以采用链式写法。

遍历方法
Map原生提供三个遍历器生成函数和一个遍历方法。

    keys()：返回键名的遍历器。
    values()：返回键值的遍历器。
    entries()：返回所有成员的遍历器。
    forEach()：遍历Map的所有成员。

let map = new Map([
  ['F', 'no'],
  ['T',  'yes'],
]);

for (let key of map.keys()) {
  console.log(key);
}
// "F"
// "T"

for (let value of map.values()) {
  console.log(value);
}
// "no"
// "yes"

for (let item of map.entries()) {
  console.log(item[0], item[1]);
}
// "F" "no"
// "T" "yes"

// 或者
for (let [key, value] of map.entries()) {
  console.log(key, value);
}

// 等同于使用map.entries()
for (let [key, value] of map) {
  console.log(key, value);
}

上面代码最后的那个例子，表示Map结构的默认遍历器接口（Symbol.iterator属性），就是entries方法。

map[Symbol.iterator] === map.entries
// true

Map结构转为数组结构，比较快速的方法是结合使用扩展运算符（...）。

let map = new Map([
  [1, 'one'],
  [2, 'two'],
  [3, 'three'],
]);

[...map.keys()]
// [1, 2, 3]

[...map.values()]
// ['one', 'two', 'three']

[...map.entries()]
// [[1,'one'], [2, 'two'], [3, 'three']]

[...map]
// [[1,'one'], [2, 'two'], [3, 'three']]

结合数组的map方法、filter方法，可以实现Map的遍历和过滤（Map本身没有map和filter方法）。

let map0 = new Map()
  .set(1, 'a')
  .set(2, 'b')
  .set(3, 'c');

let map1 = new Map(
  [...map0].filter(([k, v]) => k < 3)
);
// 产生Map结构 {1 => 'a', 2 => 'b'}

let map2 = new Map(
  [...map0].map(([k, v]) => [k * 2, '_' + v])
    );
// 产生Map结构 {2 => '_a', 4 => '_b', 6 => '_c'}

此外，Map还有一个forEach方法，与数组的forEach方法类似，也可以实现遍历。

map.forEach(function(value, key, map)) {
  console.log("Key: %s, Value: %s", key, value);
};

forEach方法还可以接受第二个参数，用来绑定this。

var reporter = {
  report: function(key, value) {
    console.log("Key: %s, Value: %s", key, value);
  }
};

map.forEach(function(value, key, map) {
  this.report(key, value);
}, reporter);

上面代码中，forEach方法的回调函数的this，就指向reporter。

Map 与其他数据结构的互相转换

Map -> Array  使用扩展运算符(...)
let myMap = new Map().set(true, 7).set({foo: 3}, ['abc']);
[...myMap]
// [ [ true, 7 ], [ { foo: 3 }, [ 'abc' ] ] ]

Array -> Map 使用Array创建Map
new Map([[true, 7], [{foo: 3}, ['abc']]])
// Map {true => 7, Object {foo: 3} => ['abc']}

Map -> Object  前提条件是Map的所有键都是字符串
function strMapToObj(strMap) {
  let obj = new Object();
  for (let [k,v] of strMap) {
    obj[k] = v;
  }
  return obj;
}

let myMap = new Map().set('yes', true).set('no', false);
strMapToObj(myMap)
//Object {yes: true, no: false}

Object -> Map 
function objToStrMap(obj) {
  let strMap = new Map();
  for (let k of Object.keys(obj)) {
    strMap.set(k, obj[k]);
  }
  return strMap;
}

objToStrMap({yes: true, no: false})
//Map {"yes" => true, "no" => false}

Map -> JSON
Map转为JSON要区分两种情况。一种情况是，Map的键名都是字符串，这时可以选择转为对象JSON。
function strMapToJson(strMap) {
  return JSON.stringify(strMapToObj(strMap));//首先将Map转成对象
}

let myMap = new Map().set('yes', true).set('no', false);
strMapToJson(myMap)
//"{"yes":true,"no":false}"

另一种情况是，Map的键名有非字符串，这时可以选择转为数组JSON。
function mapToArrayJson(map) {
  return JSON.stringify([...map]);
}

let myMap = new Map().set(true, 7).set({foo: 3}, ['abc']);
mapToArrayJson(myMap)
//"[[true,7],[{"foo":3},["abc"]]]"

JSON -> Map
一种情况：所有键名都是字符串
function jsonToStrMap(jsonStr) {
  return objToStrMap(JSON.parse(jsonStr));
}

jsonToStrMap('{"yes":true,"no":false}')
//Map {"yes" => true, "no" => false}

一种情况：整个JSON就是一个数组，且每个数组成员本身，又是一个有两个成员的数组。这时，它可以一一对应地转为Map。这往往是数组转为JSON的逆操作。
function jsonToMap(jsonStr) {
  return new Map(JSON.parse(jsonStr));
}

jsonToMap('[[true,7],[{"foo":3},["abc"]]]')
//Map {true => 7, Object {foo: 3} => ['abc']}

//WeakMap
WeakMap结构与Map结构基本类似，唯一的区别是它只接受对象作为键名（null除外），不接受其他类型的值作为键名，而且键名所指向的对象，不计入垃圾回收机制。

var wm = new WeakMap();
var element = document.querySelector(".element");//获取class为element的节点

wm.set(element, "Original");
wm.get(element) // "Original"

element.parentNode.removeChild(element);
element = null;
wm.get(element) // undefined

上面代码中，变量wm是一个WeakMap实例，我们将一个DOM节点element作为键名，然后销毁这个节点，element对应的键就自动消失了，再引用这个键名就返回undefined。

WeakMap与Map在API上的区别主要是两个，一是没有遍历操作（即没有key()、values()和entries()方法），也没有size属性；二是无法清空，即不支持clear方法。这与WeakMap的键不被计入引用、被垃圾回收机制忽略有关。因此，WeakMap只有四个方法可用：get()、set()、has()、delete()。

let myElement = document.getElementById('logo');
let myWeakmap = new WeakMap();

myWeakmap.set(myElement, {timesClicked: 0});

myElement.addEventListener('click', function() {
  let logoData = myWeakmap.get(myElement);
  logoData.timesClicked++;
  myWeakmap.set(myElement, logoData);
}, false);
上面代码中，myElement是一个DOM节点，每当发生click事件，就更新一下状态。我们将这个状态作为键值放在WeakMap里，对应的键名就是myElement。一旦这个DOM节点删除，该状态就会自动消失，不存在内存泄漏风险。

WeakMap的另一个用处是部署私有属性。

let _counter = new WeakMap();
let _action = new WeakMap();

class Countdown {
  constructor(counter, action) {
    _counter.set(this, counter);//以this为key，以属性为值来简介部署私有属性
    _action.set(this, action);
  }
  dec() {
    let counter = _counter.get(this);
    if (counter < 1) return;
    counter--;
    _counter.set(this, counter);
    if (counter === 0) {
      _action.get(this)();
    }
  }
}

let c = new Countdown(2, () => console.log('DONE'));

c.dec()
c.dec()
// DONE

上面代码中，Countdown类的两个内部属性_counter和_action，是实例的弱引用，所以如果删除实例，它们也就随之消失，不会造成内存泄漏。
