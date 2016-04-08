自己生成的对象，自己所持有。
非自己生成的对象，自己也能持有。
不再需要自己持有的对象时释放。
非自己持有的对象无法释放。


[自己生成的对象，自己所持有。]

alloc
new
copy
mutableCopy
意味着自己生成的对象只有自己持有。

copy 基于NSCopying方法约定，由各类实现的copyWithZone: 方法生成并持有对象的副本。生成不可变对象。
mutableCopy 基于NSMutableCopy 方法约定，由各类实现的mutableCopyWithZone: 方法生成并持有对象的副本。生成可变对象。

[非自己生成的对象，自己也能持有。]



不再需要自己持有的对象时释放。
非自己持有的对象无法释放。
