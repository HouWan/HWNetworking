///
/// ### Use this file to import your target's public headers that you would like to expose to Swift.
///
///         _______.____    __    ____  __   _______ .___________.
///        /       |\   \  /  \  /   / |  | |   ____||           |
///       |   (----` \   \/    \/   /  |  | |  |__   `---|  |----`
///        \   \      \            /   |  | |   __|      |  |
///    .----)   |      \    /\    /    |  | |  |         |  |
///    |_______/        \__/  \__/     |__| |__|         |__|
///
///
/// ### 1. 用于把OC的类 暴露给 Swift 调用
/// > 此类直接导入类头文件，或者库头文件，会对整个App Swift模块可见
/// > 注意在项目的`Build Setting`里面搜索`Defines Module`项，设置为`YES`
///
/// ### 2. Swift 类暴露给OC调用，会在项目自动生成一个隐藏文件`HWSwiftDemo-Swift.h`，在OC类中，直接`#import`此类即可
///
/// **注意**只有继承`NSObject`等OC的root类，才能对OC的类公开和调用
/// ```swift
/// class Person: NSObject {
///     @objc var name: String
///     @objc var age: Int
///
///     // 只有属性和方法加`@objc`才能在OC类里面调用和访问
///     @objc init(name: String, age: Int) {
///         self.name = name
///         self.age = age
///     }
/// }
/// ```
///
/// OC类中，对Swift类的一些常用宏:
/// ```c
/// @interface MyClass : NSObject
/// - (void)test1 NS_SWIFT_NAME(myTest());  // 改变在swift中方法名
/// - (void)test2 NS_SWIFT_UNAVAILABLE("请使用myTest");
/// @end
/// ```
///
/// ### 3. 一些参考链接
/// [混编讲解一](https://www.jianshu.com/p/3e32bacb8da2)
/// [混编讲解二](https://www.jianshu.com/p/89fb0f2a2694)
///


/// ***********************系统库***********************
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>



/// ***********************第三方***********************
#import <Alamofire/Alamofire-Swift.h>
#import <HandyJSON/HandyJSON-Swift.h>
#import <SwiftyJSON/SwiftyJSON-Swift.h>


/// ***********************自定义***********************



