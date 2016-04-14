遍历器（Iterator）是一种接口，为各种不同的数据结构提供统一的访问机制。任何数据结构只要部署Iterator接口，就可以完成遍历操作（即依次处理该数据结构的所有成员）。

Iterator的作用有三个：一是为各种数据结构，提供一个统一的、简便的访问接口；二是使得数据结构的成员能够按某种次序排列；三是ES6创造了一种新的遍历命令for...of循环，Iterator接口主要供for...of消费。

Iterator的遍历过程是这样的。

（1）创建一个指针对象，指向当前数据结构的起始位置。也就是说，遍历器对象本质上，就是一个指针对象。

（2）第一次调用指针对象的next方法，可以将指针指向数据结构的第一个成员。

（3）第二次调用指针对象的next方法，指针就指向数据结构的第二个成员。

（4）不断调用指针对象的next方法，直到它指向数据结构的结束位置。

每一次调用next方法，都会返回数据结构的当前成员的信息。具体来说，就是返回一个包含value和done两个属性的对象。其中，value属性是当前成员的值，done属性是一个布尔值，表示遍历是否结束。

调用Iterator接口的场合 § ⇧

有一些场合会默认调用Iterator接口（即Symbol.iterator方法），除了下文会介绍的for...of循环，还有几个别的场合。

（1）解构赋值

对数组和Set结构进行解构赋值时，会默认调用Symbol.iterator方法。

let set = new Set().add('a').add('b').add('c');

let [x,y] = set;
// x='a'; y='b'

let [first, ...rest] = set;
// first='a'; rest=['b','c'];

（2）扩展运算符

扩展运算符（...）也会调用默认的iterator接口。

// 例一
var str = 'hello';
[...str] //  ['h','e','l','l','o']

// 例二
let arr = ['b', 'c'];
['a', ...arr, 'd']
// ['a', 'b', 'c', 'd']

上面代码的扩展运算符内部就调用Iterator接口。

yield*后面跟的是一个可遍历的结构，它会调用该结构的遍历器接口。

let generator = function* () {
  yield 1;
  yield* [2,3,4];
  yield 5;
};

var iterator = generator();

iterator.next() // { value: 1, done: false }
iterator.next() // { value: 2, done: false }
iterator.next() // { value: 3, done: false }
iterator.next() // { value: 4, done: false }
iterator.next() // { value: 5, done: false }
iterator.next() // { value: undefined, done: true }


//字符串的Iterator接口
字符串是一个类似数组的对象，也原生具有Iterator接口。
var someString = "qwertyy";
var iterator = someString[Symbol.iterator]();
iterator.next()
Object {value: "q", done: false}
iterator.next()
Object {value: "w", done: false}

//遍历器对象的return()，throw()
遍历器对象除了具有next方法，还可以具有return方法和throw方法。如果你自己写遍历器对象生成函数，那么next方法是必须部署的，return方法和throw方法是否部署是可选的。
注意，return方法必须返回一个对象，这是Generator规格决定的。

throw方法主要是配合Generator函数使用，一般的遍历器对象用不到这个方法。

// for...of循环
ES6借鉴C++、Java、C#和Python语言，引入了for...of循环，作为遍历所有数据结构的统一的方法。一个数据结构只要部署了Symbol.iterator属性，就被视为具有iterator接口，就可以用for...of循环遍历它的成员。也就是说，for...of循环内部调用的是数据结构的Symbol.iterator方法。

for...of循环可以使用的范围包括数组、Set和Map结构、某些类似数组的对象（比如arguments对象、DOM NodeList对象）、后文的Generator对象，以及字符串。
如：

var obj = {//该对象类似数组结构，可以遍历
    0:6,
    1:"TC39",
    2:"ECMA-262",
    length:3,
    [Symbol.iterator]:Array.prototype[Symbol.iterator]
};

for(let e of obj){
    console.log(e);
}
//6
//TC39
//ECMA-262

var es6 = {//该对象非数组结构，无法遍历
    edition: 6,
    committee: "TC39",
    standard: "ECMA-262",
    length:3,
    [Symbol.iterator]:Array.prototype[Symbol.iterator]
};
for(let e of es6){
    console.log(e);//输出结果是undefined
}


//数组具有原生的iterator接口
ES6提供for...of循环，允许遍历获得键值。
var arr = ['a', 'b', 'c', 'd'];

for (let a in arr) {
  console.log(a); // 0 1 2 3
}

for (let a of arr) {
  console.log(a); // a b c d
}

上面代码表明，for...in循环读取键名，for...of循环读取键值。如果要通过for...of循环，获取数组的索引，可以借助数组实例的entries方法和keys方法

for...of循环调用遍历器接口，数组的遍历器接口只返回具有数字索引的属性。这一点跟for...in循环也不一样。

let arr = [3, 5, 7];
arr.foo = 'hello';

for (let i in arr) {
  console.log(i); // "0", "1", "2", "foo"
}

for (let i of arr) {
  console.log(i); //  "3", "5", "7"
}

上面代码中，for...of循环不会返回数组arr的foo属性。

//Set和Map结构也原生具有Iterator接口，可以直接使用for...of循环。
var engines = new Set(["Gecko", "Trident", "Webkit", "Webkit"]);
for (var e of engines) {
  console.log(e);
}
// Gecko
// Trident
// Webkit

var es6 = new Map();
es6.set("edition", 6);
es6.set("committee", "TC39");
es6.set("standard", "ECMA-262");
for (var [name, value] of es6) {
  console.log(name + ": " + value);
}
// edition: 6
// committee: TC39
// standard: ECMA-262

let map = new Map().set('a', 1).set('b', 2);
for (let pair of map) {
  console.log(pair);
}
// ['a', 1]
// ['b', 2]

for (let [key, value] of map) {
  console.log(key + ' : ' + value);
}
// a : 1
// b : 2

值得注意的地方有两个，首先，遍历的顺序是按照各个成员被添加进数据结构的顺序。其次，Set结构遍历时，返回的是一个值，而Map结构遍历时，返回的是一个数组，该数组的两个成员分别为当前Map成员的键名和键值。

// 字符串
let str = "hello";

for (let s of str) {
  console.log(s); // h e l l o
}

// DOM NodeList对象
let paras = document.querySelectorAll("p");

for (let p of paras) {
  p.classList.add("test");
}

// arguments对象
function printArgs() {
  for (let x of arguments) { //arguments为传入的参数
    console.log(x);
  }
}
printArgs('a', 'b');
// 'a'
// 'b'

对于字符串来说，for...of循环还有一个特点，就是会正确识别32位UTF-16字符。

for (let x of 'a\uD83D\uDC0A') {
  console.log(x);
}
// 'a'
// '\uD83D\uDC0A'

并不是所有类似数组的对象都具有iterator接口，一个简便的解决方法，就是使用Array.from方法将其转为数组。

let arrayLike = { length: 2, 0: 'a', 1: 'b' };

// 报错
for (let x of arrayLike) {
  console.log(x);
}

// 正确
for (let x of Array.from(arrayLike)) {
  console.log(x);
}

对象

对于普通的对象，for...of结构不能直接使用，会报错，必须部署了iterator接口后才能使用。但是，这样情况下，for...in循环依然可以用来遍历键名。

var es6 = {
  edition: 6,
  committee: "TC39",
  standard: "ECMA-262"
};

for (e in es6) {
  console.log(e);
}
// edition
// committee
// standard

for (e of es6) {
  console.log(e);
}
// TypeError: es6 is not iterable

上面代码表示，对于普通的对象，for...in循环可以遍历键名，for...of循环会报错。

一种解决方法是，使用Object.keys方法将对象的键名生成一个数组，然后遍历这个数组。

for (var key of Object.keys(someObject)) {
  console.log(key + ": " + someObject[key]);
}

一个方便的方法是将数组的Symbol.iterator属性，直接赋值给其他对象的Symbol.iterator属性。比如，想要让for...of环遍历jQuery对象，只要加上下面这一行就可以了。

jQuery.prototype[Symbol.iterator] =
  Array.prototype[Symbol.iterator];

另一个方法是使用Generator函数将对象重新包装一下。

function* entries(obj) {
  for (let key of Object.keys(obj)) {
    yield [key, obj[key]];
  }
}

for (let [key, value] of entries(obj)) {
  console.log(key, "->", value);
}
// a -> 1
// b -> 2
// c -> 3

for...of 与其他遍历语法的比较

以数组为例，JavaScript提供多种遍历语法。最原始的写法就是for循环。

for (var index = 0; index < myArray.length; index++) {
  console.log(myArray[index]);
}

这种写法比较麻烦，因此数组提供内置的forEach方法。

myArray.forEach(function (value) {
  console.log(value);
});

这种写法的问题在于，无法中途跳出forEach循环，break命令或return命令都不能奏效。

for...in循环可以遍历数组的键名。

for (var index in myArray) {
  console.log(myArray[index]);
}

for...in循环有几个缺点。

    数组的键名是数字，但是for...in循环是以字符串作为键名“0”、“1”、“2”等等。
    for...in循环不仅遍历数字键名，还会遍历手动添加的其他键，甚至包括原型链上的键。
    某些情况下，for...in循环会以任意顺序遍历键名。

总之，for...in循环主要是为遍历对象而设计的，不适用于遍历数组。

for...of循环相比上面几种做法，有一些显著的优点。

for (let value of myArray) {
  console.log(value);
}

    有着同for...in一样的简洁语法，但是没有for...in那些缺点。
    不同用于forEach方法，它可以与break、continue和return配合使用。
    提供了遍历所有数据结构的统一操作接口。

下面是一个使用break语句，跳出for...of循环的例子。

for (var n of fibonacci) {
  if (n > 1000)
    break;
  console.log(n);
}

上面的例子，会输出斐波纳契数列小于等于1000的项。如果当前项大于1000，就会使用break语句跳出for...of循环。
