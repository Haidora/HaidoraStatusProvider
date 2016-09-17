# HaidoraStatusProvider

[![CI Status](http://img.shields.io/travis/mrdaios/HaidoraStatusProvider.svg?style=flat)](https://travis-ci.org/mrdaios/HaidoraStatusProvider)
[![Version](https://img.shields.io/cocoapods/v/HaidoraStatusProvider.svg?style=flat)](http://cocoapods.org/pods/HaidoraStatusProvider)
[![License](https://img.shields.io/cocoapods/l/HaidoraStatusProvider.svg?style=flat)](http://cocoapods.org/pods/HaidoraStatusProvider)
[![Platform](https://img.shields.io/cocoapods/p/HaidoraStatusProvider.svg?style=flat)](http://cocoapods.org/pods/HaidoraStatusProvider)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

#### 1.基本使用

```swift
//1.引入库
import HaidoraStatusProvider
//2.对需要使用hud的对象实现HaidoraStatusable
class ViewController: UIViewController,HaidoraStatusable {

    override func viewDidLoad() {
        super.viewDidLoad()
        //设置默认的provider(全局设置一次即可)
        HaidoraStatusConfig.shareInstance.provider = MBProgressHUDSwiftWrap.self   
    }

    @IBAction func showAction(sender: AnyObject) {
    	//显示
        self.show()
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(3 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) {
        	//隐藏
            self.hide()
        }
    }
}

```

#### 2.自定义
	当HaidoraStatusable提供的默认方法不够用时,可针对该协议扩展

```swift
extension HaidoraStatusable {
    
    public func custom_method() {
        print("上层接口－自定义方法")
        let statusView = self.buildProvider()
        //事件转发到Provider
        statusView.custom_method()
    }
}

extension HaidoraStatusProvider {
    
    public func custom_method() {
        print("真正实现-自定义方法")
    }
}

extension HaidoraStatusProvider where Self: MBProgressHUDSwiftWrap {
    public func custom_method() {
        print("某种hud-自定义方法")
    }
}

```


## Requirements
- Xcode8+
- Swift3.0
- iOS8+

## Installation

HaidoraStatusProvider is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
    pod "HaidoraStatusProvider"
```

## Inspired by these projects:
* [StatusProvider](https://github.com/mariohahn/StatusProvider)
* [HaidoraProgressHUDManager](https://github.com/Haidora/HaidoraProgressHUDManager)

## Author

mrdaios, mrdaios@gmail.com

## License

HaidoraStatusProvider is available under the MIT license. See the LICENSE file for more info.
