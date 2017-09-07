//
//  test.swift
//  Swift_Test
//
//  Created by VRV2 on 2017/9/6.
//  Copyright © 2017年 Hosten_lym. All rights reserved.
//

import Foundation


class testCollect {
    func testArrDicSet() {
//        let myArr = [Int]()
//        let myArr = Array<Int>()
        let myArr  = [1,3,5,4.5555];
        for temp in 1..<5 {
            print(temp)
        }
        print(myArr)
//        常用函数 myArr.count myArr.isEmpty myArr.contains myArr.insert myArr.remove
        
        let isContain = myArr.contains(5)
        print("iscontain = \(isContain)")
        
        
//        var myDic = Dictionary<String, Int>()
//        // 通过字典的不定参数个数的构造方法创建一个字典对象，
//        
//        myDic = Dictionary<String, Int>(dictionaryLiteral: ("1", 1), ("2", 2), ("3", 3))
//        // 使用字典的默认构造方法创建一个空的字典常量。
//        var myDic1 = [Int : Float]()
//        myDic1 = [23:33.3,23:332.444]
//         
//        // 这里也是通过字典的不定参数个数的构造方法创建一个字典常量
//        let myDicC = [Int : Float](dictionaryLiteral: (0, 0.0), (1, 1.1), (2, 2.2))
        var   myDic = ["one":33.3,"three":332.444]
        myDic = ["one":33.3,"two":332.444]
        print("获取字典值:\(String(describing: myDic["two"]))")
    }
    func  testRange() -> Int {
        // 表示该范围从"aaa"到"ccc"之间
        let stringRange = "aaa" ... "ccc"
        switch "ccb" {
        case stringRange:
            // 结果输出：In stringRange!
            print("the string is  stringRange numbers!")
        default:
            print("Not in stringRange numbers!")
        }
        return 1
    }
    func  testOptional() -> Int {
        // 声明Optional变量testOptF类型为 Int?,初始化为空
        var testOptF: Float? = nil
        // 这里使用optional链操作符，
        // 在这里会先判断testOptF是否为空，不为空则执行a = 10操作，
        // 否则不执行任何操作。
        testOptF? = 3.1415
        // 这条语句同上面一样
        testOptF? += 10
        // 这里输出：testOptF = nil
        print("testOptF = \(String(describing: testOptF))")
        
        
        testOptF! += 10
        
        print("testOptF! = \(testOptF!)")
        
        if testOptF != nil {
            
        }
   
        return 1
    }
    
    
    func testIF() -> () {
        
        var a = 20
        
        // 1> 判断句不用加（）
        // 2< 判断句结果必须是一个真假值
        repeat{
            if a > 10 {
                print("a 是大于 0 a =\(a)")
                a -= 1
            }else{
                print("a 是小于 0 a =\(a)")
                a -= 2
            }
        }
        while a > 0
        
        /// guard 示例
       let _ = self.testGuard(age: 30)
        
        let sex = "男"
        switch sex {
        case "男":
            print("是男的")
            //如果需要继续执行下一个case，加上fallthrough
//            fallthrough
        case "女":
            print("是女的")
        default:
            print("是未知性别")
        }
        
    }
    
    func testGuard(age : Int ) -> Bool {
        guard age >= 20 else {
            print("错误 信息 重新开始")
            return false
        }
        print("信息正确 继续执行 ")
        return true
    }

}
