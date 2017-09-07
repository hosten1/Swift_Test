//
//  testFun.swift
//  Swift_Test
//
//  Created by VRV2 on 2017/9/7.
//  Copyright © 2017年 Hosten_lym. All rights reserved.
//

import Foundation
import UIKit

protocol testProtoDelate {
    func getSomething(someThing someS:String?) -> String?
}

class testFun: NSObject {
    var testDelgate :testProtoDelate?
    //闭包类型：(参数列表)->(参数)
    func requ(callback : @escaping ()->()) -> () {
        DispatchQueue.global().async { () -> Void in
            let currentThread = Thread.current
            print("当前线程为\(currentThread)")
            DispatchQueue.main.async { () -> Void in
                let currentThread = Thread.current
                print("回调 当前线程为\(currentThread)")
               callback()
            }
        }
    }
    func doSomeon() -> () {
       
       let eatS = testDelgate?.getSomething(someThing: "帮我打个电话吧")
        print("好了吗？ "+eatS!)
    }
}
