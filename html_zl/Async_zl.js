ES6诞生以前，异步编程的方法，大概有下面四种。

    回调函数
    事件监听
    发布/订阅
    Promise 对象

ES6将JavaScript异步编程带入了一个全新的阶段，ES7的Async函数更是提出了异步编程的终极解决方案。


//回调函数
fs.readFile('/etc/passwd', function (err, data) {
  if (err) throw err;
  console.log(data);
});

不难想象，如果依次读取多个文件，就会出现多重嵌套。代码不是纵向发展，而是横向发展，很快就会乱成一团，无法管理。这种情况就称为"回调函数噩梦"（callback hell）。

Promise就是为了解决这个问题而提出的。它不是新的语法功能，而是一种新的写法，允许将回调函数的横向加载，改成纵向加载。采用Promise，连续读取多个文件，写法如下。

var readFile = require('fs-readfile-promise');

readFile(fileA)
.then(function(data){
  console.log(data.toString());
})
.then(function(){
  return readFile(fileB);
})
.then(function(data){
  console.log(data.toString());
})
.catch(function(err) {
  console.log(err);
});

上面代码中，我使用了fs-readfile-promise模块，它的作用就是返回一个Promise版本的readFile函数。Promise提供then方法加载回调函数，catch方法捕捉执行过程中抛出的错误。

可以看到，Promise 的写法只是回调函数的改进，使用then方法以后，异步任务的两段执行看得更清楚了，除此以外，并无新意。

Promise 的最大问题是代码冗余，原来的任务被Promise 包装了一下，不管什么操作，一眼看去都是一堆 then，原来的语义变得很不清楚。

//协程 Generator
读取文件的协程写法如下。

function *asnycJob() {
  // ...其他代码
  var f = yield readFile(fileA);
  // ...其他代码
}

上面代码的函数asyncJob是一个协程，它的奥妙就在其中的yield命令。它表示执行到此处，执行权将交给其他协程。也就是说，yield命令是异步两个阶段的分界线。

协程遇到yield命令就暂停，等到执行权返回，再从暂停的地方继续往后执行。它的最大优点，就是代码的写法非常像同步操作，如果去除yield命令，简直一模一样。

Generator函数可以暂停执行和恢复执行，这是它能封装异步任务的根本原因。除此之外，它还有两个特性，使它可以作为异步编程的完整解决方案：函数体内外的数据交换和错误处理机制。

Generator 函数内部还可以部署错误处理代码，捕获函数体外抛出的错误。

function* gen(x){
  try {
    var y = yield x + 2;
  } catch (e){
    console.log(e);
  }
  return y;
}

var g = gen(1);
g.next();
g.throw('出错了');
// 出错了

上面代码的最后一行，Generator函数体外，使用指针对象的throw方法抛出的错误，可以被函数体内的try ...catch代码块捕获。这意味着，出错的代码与处理错误的代码，实现了时间和空间上的分离，这对于异步编程无疑是很重要的。

//异步任务的封装
var fetch = require('node-fetch');

function* gen(){
  var url = 'https://api.github.com/users/github';
  var result = yield fetch(url);
  console.log(result.bio);
}

上面代码中，Generator函数封装了一个异步操作，该操作先读取一个远程接口，然后从JSON格式的数据解析信息。就像前面说过的，这段代码非常像同步操作，除了加上了yield命令。

执行这段代码的方法如下。

var g = gen();
var result = g.next();

result.value.then(function(data){
  return data.json();
}).then(function(data){
  g.next(data);
});

上面代码中，首先执行Generator函数，获取遍历器对象，然后使用next 方法（第二行），执行异步任务的第一阶段。由于Fetch模块返回的是一个Promise对象，因此要用then方法调用下一个next 方法。

//Thunk函数
编译器的"传名调用"实现，往往是将参数放到一个临时函数之中，再将这个临时函数传入函数体。这个临时函数就叫做Thunk函数。

function f(m){
  return m * 2;
}
f(x + 5);

// 等同于
var thunk = function () {
  return x + 5;
};
function f(thunk){
  return thunk() * 2;
}

上面代码中，函数f的参数x + 5被一个函数替换了。凡是用到原参数的地方，对Thunk函数求值即可。 这就是Thunk函数的定义，它是"传名调用"的一种实现策略，用来替换某个表达式。

//Thunk 编译器的"传名调用"实现，往往是将参数放到一个临时函数之中，再将这个临时函数传入函数体。这个临时函数就叫做Thunk函数。
var Thunk = function(fn){
  return function (){
    var args = Array.prototype.slice.call(arguments);
    return function (callback){
      args.push(callback);
      return fn.apply(this, args);
    }
  };
};

//生产环境的转换器，建议使用Thunkify模块

//Thunk函数的自动流程管理

Thunk函数真正的威力，在于可以自动执行Generator函数。下面就是一个基于Thunk函数的Generator执行器。

function run(fn) {
  var gen = fn();

  function next(err, data) {
    var result = gen.next(data);
    if (result.done) return;
    result.value(next);
  }

  next();
}

//函数gen封装了n个异步的读取文件操作，只要执行run函数，这些操作就会自动完成。
var gen = function* (){
  var f1 = yield readFile('fileA');
  var f2 = yield readFile('fileB');
  // ...
  var fn = yield readFile('fileN');
};

run(gen);

上面代码的run函数，就是一个Generator函数的自动执行器。内部的next函数就是Thunk的回调函数。next函数先将指针移到Generator函数的下一步（gen.next方法），然后判断Generator函数是否结束（result.done 属性），如果没结束，就将next函数再传入Thunk函数（result.value属性），否则就直接退出。











