//
//  ViewController.swift
//  RxSwiftDemo
//
//  Created by chengxianghe on 2019/3/10.
//  Copyright © 2019 cn. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {

    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
//        test1()
        testCreateObserverable()
    }
    
    func test1() {
        let temperature: Observable<Int> = Observable.create { observer -> Disposable in
            
            observer.onNext(0)
            observer.onNext(1)
            observer.onNext(2)
            observer.onNext(3)
            /*
             ...
             */
            observer.onNext(28)
            //observer.onError(NSError.init(domain: "", code: 0, userInfo: ["msg":"出问题了"]))
            observer.onNext(29)
            observer.onNext(30)
            observer.onCompleted()
            
            return Disposables.create()
        }
        
        temperature.subscribe(onNext: { (num) in
            print("温度正在升高:\(num)")
        }, onError: { (error) in
            print("发生错误： \(error.localizedDescription)")
        }, onCompleted: {
            print("任务完成")
        }).disposed(by: disposeBag)
    }
    
    ///创建 Observable 序列
    func testCreateObserverable() {
        //我们可以通过如下几种方法来创建一个 Observable序列
        //1 just() 方法
        //（1）该方法通过传入一个默认值来初始化。
        //（2）Observable<Int>，即指定了这个 Observable所发出的事件携带的数据类型必须是Int类型。
        let observableJust = Observable<Int>.just(5)

        //2，of() 方法
        //（1）该方法可以接受可变数量的参数（必需要是同类型的）
        //（2）下面样例中我没有显式地声明出 Observable 的泛型类型，Swift 也会自动推断类型。
        let observableOf = Observable.of("A", "B", "C")
        
        //3 from() 方法
        //（1）该方法需要一个数组参数。
        //（2）下面样例中数据里的元素就会被当做这个 Observable 所发出 event携带的数据内容，最终效果同上面饿 of()样例是一样的。
        let observableFrom = Observable.from(["A", "B", "C"])
        
        //4 empty() 方法
        //该方法创建一个空内容的 Observable 序列。
        let observableEmpty = Observable<Int>.empty()
        
        //订阅测试
        observableJust.subscribe {
            print($0)
        }.disposed(by: disposeBag)
        
        observableOf.subscribe {
            print($0)
        }.disposed(by: disposeBag)
        
        observableFrom.subscribe {
            print($0)
        }.disposed(by: disposeBag)
        
        observableEmpty.subscribe {
            print($0)
        }.disposed(by: disposeBag)
    }
    
    func testNe() {
        
//        5，never() 方法
//        该方法创建一个永远不会发出 Event（也不会终止）的 Observable 序列。
//        let observable = Observable<Int>.never()
        
//        6，error() 方法
//        该方法创建一个不做任何操作，而是直接发送一个错误的 Observable 序列。
        enum MyError: Error {
            case A
            case B
        }
        let observable = Observable<Int>.error(MyError.A)
        
//        7，range() 方法
//        （1）该方法通过指定起始和结束数值，创建一个以这个范围内所有值作为初始值的Observable序列。
//        （2）下面样例中，两种方法创建的 Observable 序列都是一样的。
        //使用range()
//        let observable = Observable.range(start: 1, count: 5)
        
        //使用of()
//        let observable = Observable.of(1, 2, 3 ,4 ,5)
        
//        8，repeatElement() 方法
//        该方法创建一个可以无限发出给定元素的 Event的 Observable 序列（永不终止）。
//        let observable = Observable.repeatElement(1)
        
//        9，generate() 方法
//        （1）该方法创建一个只有当提供的所有的判断条件都为 true 的时候，才会给出动作的 Observable 序列。
//        （2）下面样例中，两种方法创建的 Observable 序列都是一样的。
        //使用generate()方法
//        let observable = Observable.generate(
//            initialState: 0,
//            condition: { $0 <= 10 },
//            iterate: { $0 + 2 }
//        )
        
        //使用of()方法
//        let observable = Observable.of(0 , 2 ,4 ,6 ,8 ,10)
        
//        10，create() 方法
//        （1）该方法接受一个 block 形式的参数，任务是对每一个过来的订阅进行处理。
//        （2）下面是一个简单的样例。为方便演示，这里增加了订阅相关代码（关于订阅我之后会详细介绍的）。
        //这个block有一个回调参数observer就是订阅这个Observable对象的订阅者
        //当一个订阅者订阅这个Observable对象的时候，就会将订阅者作为参数传入这个block来执行一些内容
        let observable = Observable<String>.create{observer in
            //对订阅者发出了.next事件，且携带了一个数据"hangge.com"
            observer.onNext("hangge.com")
            //对订阅者发出了.completed事件
            observer.onCompleted()
            //因为一个订阅行为会有一个Disposable类型的返回值，所以在结尾一定要returen一个Disposable
            return Disposables.create()
        }
        
        //订阅测试
        observable.subscribe {
            print($0)
        }
        
        
//        11，deferred() 方法
//        （1）该个方法相当于是创建一个 Observable 工厂，通过传入一个 block 来执行延迟 Observable序列创建的行为，而这个 block 里就是真正的实例化序列对象的地方。
//        （2）下面是一个简单的演示样例：
        //用于标记是奇数、还是偶数
//        var isOdd = true
//
//        //使用deferred()方法延迟Observable序列的初始化，通过传入的block来实现Observable序列的初始化并且返回。
//        let factory : Observable<Int> = Observable.deferred {
//
//            //让每次执行这个block时候都会让奇、偶数进行交替
//            isOdd = !isOdd
//
//            //根据isOdd参数，决定创建并返回的是奇数Observable、还是偶数Observable
//            if isOdd {
//                return Observable.of(1, 3, 5 ,7)
//            }else {
//                return Observable.of(2, 4, 6, 8)
//            }
//        }
//
//        //第1次订阅测试
//        factory.subscribe { event in
//            print("\(isOdd)", event)
//        }
//
//        //第2次订阅测试
//        factory.subscribe { event in
//            print("\(isOdd)", event)
//        }
        
        
//        12，interval() 方法
//        （1）这个方法创建的 Observable 序列每隔一段设定的时间，会发出一个索引数的元素。而且它会一直发送下去。
//        （2）下面方法让其每 1 秒发送一次，并且是在主线程（MainScheduler）发送。
//        let observable = Observable<Int>.interval(1, scheduler: MainScheduler.instance)
//        observable.subscribe { event in
//            print(event)
//        }
        
        
//        13，timer() 方法
//        （1）这个方法有两种用法，一种是创建的 Observable序列在经过设定的一段时间后，产生唯一的一个元素。
        //5秒种后发出唯一的一个元素0
//        let observable = Observable<Int>.timer(5, scheduler: MainScheduler.instance)
//        observable.subscribe { event in
//            print(event)
//        }
        
        
//        （2）另一种是创建的 Observable 序列在经过设定的一段时间后，每隔一段时间产生一个元素。
//        延时5秒种后，每隔1秒钟发出一个元素
//        let observable = Observable<Int>.timer(5, period: 1, scheduler: MainScheduler.instance)
//        observable.subscribe { event in
//            print(event)
//        }
        
         let disposeBag = DisposeBag()
        let observable1 = Observable.of("A", "B", "C")
        observable1.subscribe { event in
                      print(event)
            }.disposed(by: disposeBag)
        
        let observable2 = Observable.of(1, 2, 3)
        observable2.subscribe { event in
                      print(event)
            }.disposed(by: disposeBag)

        
        //https://www.jianshu.com/p/63f1681236fd
    }


}

