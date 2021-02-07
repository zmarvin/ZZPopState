## 让导航栏随控制器view一起pop

1. **其它实现方式：** 当然自定义导航栏，或者嵌套控制器的方式是可以实现的。这样做的主要目的是为了每个控制器有自己独立的导航栏，互相之间没有牵扯，易维护。大型项目推荐用这样的方式。
2. **我的实现方式：** 是对导航栏截图，让截图跟随控制器view一起pop，以假乱真。
3. 这里简单说下我的代码实现，首先获取对pop消息的监听，然后获取导航控制器中的AnimatedTransition,使用黑魔法在其中植入导航栏截图的跟随动画，具体实现参看代码。

## 用法

1. 将分类UIViewController+ZZPopState.h和.m两个文件导入项目即可，再无需其它操作。
2. 如果某个控制器想要关闭，只需要：

	```objc
	viewController.zz_popSateDisabled = YES;
    ```
	
## 效果图 

（顺便推荐下自己的[仿网易云音乐](https://github.com/zmarvin/WangYiMusic)项目，O(∩_∩)O哈哈~）

![Examples](_Gifs/pop1.gif)


