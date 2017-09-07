//
//  ViewController.swift
//  Swift_Test
//
//  Created by VRV2 on 2017/9/6.
//  Copyright © 2017年 Hosten_lym. All rights reserved.
//

import UIKit
class Person : NSObject {
//    存储属性
    var name : String?{
        //在该方法中，系统有一个标识符
        willSet {
            print(name ?? "haha")
            print(newValue ?? "444")
        }
        didSet {
            print(name!)
            print(oldValue ?? "haha")
        }
    }
    var age : Int = 0
    
    var money : Double = 0.0
//计算属性
    var avarageSorce :Double {
        get {
            return money;
        }
    }
//     类属性
    static var courseCount : Int = 0
    
    override init() {
        //可以不调用，如果不调用系统会默认调用
//        super.init()
        
    }
    //自定义初始化构造函数
    init(name : String , age : Int) {
        self.name = name;
        self.age  = age;
    }
    
    lazy var names: [String] = {
        return ["12334","88888"]
    }()
}

class testClass {
    var name = "hello world!"
    
}
class ViewController: UIViewController{
    var testFunC :testFun?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
       let FunC = testFun()
        FunC.testDelgate = self
        FunC.doSomeon()
       //添加一tableveiw
        let tableView = UITableView()
        tableView.frame = self.view.bounds
        self.view .addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func restAll() -> () {
        let stu = Person()
        stu.name = "hhh"
        print(stu.avarageSorce)
        
        Person.courseCount = 45//类属性，必须用类调用
        let per = Person(name:"222", age:23)
        print(per)
        testFunC = testFun();
        
        let tests = testCollect()
        //调用类的方法
        //        tests.testArrDicSet()
        //        let restStr = tests.testRange()
        //          let _ = tests.testOptional()
        tests.testIF()
        
        let _view : UIView = UIView.init(frame: CGRect.init(x: 0, y: 0, width:100, height: 100))
        _view.backgroundColor = UIColor.red
        self.view.addSubview(_view)
        
        let lab = UILabel.init(frame: CGRect.init(x:0.0, y: self.view.frame.size.height*0.5, width: self.view.frame.size.width, height: 100))
        lab.text = "test the value"
        lab.backgroundColor = UIColor.green
        lab.textColor = UIColor.white
        self.view.addSubview(lab)
        
        //字符创格式化
        let name  = 2
        let msg = 45
        
        let time = String.init(format: "%02d:%02d",arguments: [name,msg])
        print("现在是\(time)")
        
        //        let indexS = "dfsdsfafhostenllllll"
        
        //        self.testFuncVale(redView: _view)
    }
// MARK: ----这是一个分段
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        testFunC?.requ(callback: { 
            print("开始请求数据了")
        })
    }
    
    func testFuncVale(redView:UIView){
       
        let tesy = "luo yongmeng"
        let strCount : Int = tesy.characters.count
        var testInt = 0
        var testBool : Bool
        var testDouble : Double
        testInt = 5
        testBool = true
        testDouble = 3.14153333
    
        var str:String
        str = "testInt -->\(testInt)"+"testDouble -->\(testDouble)testDouble-->\(strCount)"
        print("append string is \(str) is contain \(str.contains("\(testBool)"))")
        
        var testFloat : Float
        var reserveDouble : Double
        testFloat  = 2.3333333
        reserveDouble =  2.3344123412512512
        //低精度转高精度
        reserveDouble = Double(testFloat)
        //高精度转低精度
        testFloat = Float(reserveDouble)
        
        
        var `var` = 4566
        `var` = 333333
        print("the \(`var`)")
        
        
        
        //        元组
        let tupleMu = (10,redView,true,testClass().name)
        //        let tupleMu1 : (Int,UIView,Bool,String) = (10,_view,true,testClass().name)
        
        //获取元组的元素
        
        print("获取元组的元素 get tuple to \(tupleMu) with type :\(type(of: tupleMu))")
        //通过下标获取
        print("通过下标获取 get tuple to 1\(tupleMu.1)  2 :\(type(of: tupleMu.3))")
        //      指定 元组标签
        
        let tupleMuCl = (isInt:10,isView:redView,isBool:true,myClass:testClass().name)
        print("指定 元组标签 get tuple to 1\(tupleMuCl.isInt)  2 :\(tupleMuCl.myClass)")
        
        
        //字符创格式化
        let name  = 2
        let msg = 45
        
        let time = String.init(format: "%02d:%02d", [name,msg])
        print("现在是\(time)")
        
        
    }
}
extension ViewController:UITableViewDataSource,UITableViewDelegate,testProtoDelate{
    // MARK:- tableView数据源方法
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let ID = "Cell"
        
        // 从缓冲池中取出cell
        var cell = tableView.dequeueReusableCell(withIdentifier: ID)
        
        // 判断是否为nil,如果为nil,则创建
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: ID)
        }
        
        cell?.textLabel?.text = "测试数据\(indexPath.row)"
        
        return cell!
    }
    
    // MARK:- tableView代理方法
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("点击了\(indexPath.row)")
    }
    
    func getSomething(someThing someS: String?) -> String? {
        print("协议 告诉我 \(someS!)")
        return "电话已经打完了！"
    }
}
