## 让导航栏随控制器view一起pop

1. **其它实现方式：** 当然自定义导航栏，或者嵌套控制器的方式是可以实现的。这样做的主要目的是为了每个控制器有自己独立的导航栏，互相之间没有牵扯，责任分工明确，易管理。大型项目推荐用这样的方式。
2. **我的实现方式：** 是对导航栏截图，让截图跟随控制器view一起pop，以假乱真。这个截图产生在from控制器viewWillDisappear和to控制器viewWillAppear方法之前。
3. **有些遗憾的是：** 不能同样的方式实现pop时to控制器的截图动画，因为，导航栏还是被控制器共享，动画结束后，from和to控制器会再各自调用viewDidDisappear和viewDidAppear两个方法，这样导致对to控制器导航栏的截图可能不是最终显示结果，会有频闪的问题。
3. **简单说下我的代码实现：** 首先获取对pop消息的监听，然后获取导航控制器中的AnimatedTransition,使用黑魔法在其中植入截图的跟随动画。具体参看代码。

## 用法

1. 将分类UIViewController+ZZPopState.h和.m两个文件导入项目即可，再无需其它操作。
2. 如果某个控制器（包括导航控制器）想要关闭，只需要：

	```objc
	viewController.zz_popSateDisabled = YES;
    ```
	
## 效果图 

（顺便推荐下自己的[仿网易云音乐](https://github.com/zmarvin/WangYiMusic)项目，O(∩_∩)O哈哈~）

![Examples](_Gifs/pop1.gif)


