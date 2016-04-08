 UITableView : UIScrollView <NSCoding>

1. 创建一个 UITableView 对象

ITableView *tableView = [[UITableView alloc]initWithFrame:[[UIScreen mainScreen] bounds] style:UITableViewStylePlain];

2.separatorColor

分割线颜色

e.g. ableView.separatorColor = [UIColor redColor];

//tableView单元格之间分割线的样式 
tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLineEtched;
//UITableViewCellSeparatorStyleNone             没有分割线 
//UITableViewCellSeparatorStyleSingleLine       单条分割线 
//UITableViewCellSeparatorStyleSingleLineEtched

3.rowHeight

调整每个 cell 点高度（默认 44 ）

e.g. tableView.rowHeight = 60;

4.reloadData

刷新数据

e.g. [tableView reloadData];

5.<UITableViewDelegate,UITableViewDataSource>

两个必须实现的方法

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath

6. 选中 cell 时候使用的方法

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath

7. 取消选中时候用的方法

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath

8. 控制分组个数

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView

9.section 上 Header 显示的内容

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section

10.section 上 Footer 显示的内容

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section

11.section 顶部的高度

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section

12.cell 的高度

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath

13 该方法返回值用于在表格右边建立一个浮动的索引

- ( NSArray *)sectionIndexTitlesForTableView:( UITableView *)tableView; 

cell相关:

1.返回表格中指定indexPath对应的cell

- ( UITableViewCell *)cellForRowAtIndexPath:( NSIndexPath *)indexPath;

2.返回指定cell的indexPath

- ( NSIndexPath *)indexPathForCell:( UITableViewCell *)cell;

3.返回表格中指定点所在的indexPath

- ( NSIndexPath *)indexPathForRowAtPoint:( CGPoint )point;

4.返回表格中指定区域内所有indexPath 组成的数组

- ( NSArray *)indexPathsForRowsInRect:( CGRect )rect;   

5.返回表格中所有可见区域内cell的数组

- ( NSArray *)visibleCells;

6.返回表格中所有可见区域内cell对应indexPath所组成的数组

- ( NSArray *)indexPathsForVisibleRows;

7.控制该表格滚动到指定indexPath对应的cell的顶端 中间 或者下方

- ( void )scrollToRowAtIndexPath:( NSIndexPath *)indexPath atScrollPosition:( UITableViewScrollPosition )scrollPosition animated:( BOOL )animated;

8.控制该表格滚动到选中cell的顶端 中间 或者下方

-( void )scrollToNearestSelectedRowAtScrollPosition:( UITableViewScrollPosition )scrollPosition animated:( BOOL )animated;

处理单元格的选中

1.@property ( nonatomic ) BOOL allowsSelection

控制该表格是否允许被选中

2. @property ( nonatomic ) BOOL allowsMultipleSelection

控制该表格是否允许多选

3. @property ( nonatomic ) BOOL allowsSelectionDuringEditing; 

控制表格处于编辑状态时是否允许被选中

4. @property ( nonatomic ) BOOL allowsMultipleSelectionDuringEditing

控制表格处于编辑状态时是否允许被多选

5.获取选中cell对应的indexPath

- ( NSIndexPath *)indexPathForSelectedRow;

6.获取所有被选中的cell对应的indexPath组成的数组

- ( NSArray *)indexPathsForSelectedRows

7.控制该表格选中指定indexPath对应的表格行,最后一个参数控制是否滚动到被选中行的顶端 中间 和底部

- ( void )selectRowAtIndexPath:( NSIndexPath *)indexPath animated:( BOOL )animated scrollPosition:( UITableViewScrollPosition )scrollPosition;

8.控制取消选中该表格中指定indexPath对应的表格行

- ( void )deselectRowAtIndexPath:( NSIndexPath *)indexPath animated:( BOOL )animated;

<UITableViewDelegate>

9.当用户将要选中表格中的某行时触发方法

- ( NSIndexPath *)tableView:( UITableView *)tableView willSelectRowAtIndexPath:( NSIndexPath *)indexPath;

10.当用户完成选中表格中的某行时触发方法

-( void )tableView:( UITableView *)tableView didSelectRowAtIndexPath:( NSIndexPath *)indexPath

11.当用户将要取消选中表格中某行时触发

- ( NSIndexPath *)tableView:( UITableView *)tableView willDeselectRowAtIndexPath:( NSIndexPath *)indexPath

12.当用户完成取消选中表格中某行时触发

- ( void )tableView:( UITableView *)tableView didDeselectRowAtIndexPath:( NSIndexPath *)indexPath 

关于对表格的编辑

1.对表格控件执行多个连续的插入,删除和移动操作之前调用这个方法开始更新

- ( void )beginUpdates;

2.对表格控件执行多个连续的插入,删除和移动操作之后调用这个方法结束

- ( void )endUpdates;

3.在一个或多个indexPath处插入cell

- ( void )insertRowsAtIndexPaths:( NSArray *)indexPaths withRowAnimation:( UITableViewRowAnimation )animation;

4.删除一个或多个indexPath处的cell

- ( void )deleteRowsAtIndexPaths:( NSArray *)indexPaths withRowAnimation:( UITableViewRowAnimation )animation;

5.将制定indexPath处的cell移动到另个一indexPath处

- ( void )moveRowAtIndexPath:( NSIndexPath *)indexPath toIndexPath:( NSIndexPath *)newIndexPath 

6.指定的indexSet所包含的一个或多个分区号对应的位置插入分区

- ( void )insertSections:( NSIndexSet *)sections withRowAnimation:( UITableViewRowAnimation )animation;

7.删除指定indexSet所包含的一个或多个分区号所对应的分区

- ( void )deleteSections:( NSIndexSet *)sections withRowAnimation:( UITableViewRowAnimation )animation;

8.将指定分区移动到另一个位置

- ( void )moveSection:( NSInteger )section toSection:( NSInteger )newSection

@protocol UITableViewDataSource< NSObject >

9.该方法返回值决定指定indexPath对应的cell是否可以编辑

- ( BOOL )tableView:( UITableView *)tableView canEditRowAtIndexPath:( NSIndexPath *)indexPath;

10.该方法返回值决定指定indexPath对应的cell是否可以移动

- ( BOOL )tableView:( UITableView *)tableView canMoveRowAtIndexPath:( NSIndexPath *)indexPath;

11.当用户对指定表格行编辑(包括插入和删除)时触发该方法

- ( void )tableView:( UITableView *)tableView commitEditingStyle:( UITableViewCellEditingStyle )editingStyle forRowAtIndexPath:( NSIndexPath *)indexPath;

12.该方法触发移动  通常对数据进行处理(重要)

- ( void )tableView:( UITableView *)tableView moveRowAtIndexPath:( NSIndexPath *)sourceIndexPath toIndexPath:( NSIndexPath *)destinationIndexPath;

@protocol UITableViewDelegate< NSObject , UIScrollViewDelegate >

13.开始/完成 编辑时调用的两个方法

- ( void )tableView:( UITableView *)tableView willBeginEditingRowAtIndexPath:( NSIndexPath *)indexPath;

- ( void )tableView:( UITableView *)tableView didEndEditingRowAtIndexPath:( NSIndexPath *)indexPath;

14.该方法返回值决定了 indexPath处的cell 的编辑状态  返回值为枚举类型 分别为 None Delete Insert 

- ( UITableViewCellEditingStyle )tableView:( UITableView *)tableView editingStyleForRowAtIndexPath:( NSIndexPath *)indexPath;

15.该方法决定了 cell处于被编辑状态时是否应该缩进  若未重写 所有cell处于编辑状态时都会缩进

- ( BOOL )tableView:( UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:( NSIndexPath *)indexPath;

UITableViewCell  :  UIView  < NSCoding ,  UIGestureRecognizerDelegate >

这里涉及到自定义 UITableViewCell  以下为具体步骤以及需要注意到地方

1. 首先创建一个类继承 UITableViewCell

2. 把自定义 cell 上到自定义视图全部设置为属性（注意：属性名一定不要和系统属性命重复 e.g.  imageView,textLable,detailTextLable ）

3. 在 cell 的初始化方法中   对自定义视图对属性初始化，在初始化对时候可以不指定 frame （注意，这里加载到视图上时   加载到 contentView  上    同时注意内存管理）

4. 在 layoutSubviews 方法中完成最后操作   通常给出 frame （注意，这个方法为系统自带方法，当一个 cell 显示到屏幕上之前，最后调用到一个方法，   所有 cell 到操作   包括赋值，调整高度等   都已经完成    一定不要忘记 [super layoutSubviews]; ）

附加: 当一个 cell 被选中的方法

- (void)setSelected:(BOOL)selected animated:(BOOL)animated

一些小操作:

// 将单元格的边框设置为圆角

cell. layer . cornerRadius  =  12 ;

cell. layer . masksToBounds  =  YES ;
