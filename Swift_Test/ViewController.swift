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
    fileprivate var indexView :MJNIndexViewSwift?
    fileprivate var tableView :UITableView?
    fileprivate lazy var  memberLists:[String] = {
        let memberList = ["A","B","C","D","E","*"]
        return memberList
    }()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.testOptionals()
        // Do any additional setup after loading the view, typically from a nib.
//       let FunC = testFun()
//       FunC.testDelgate = self
//       FunC.doSomeon()
        
//        let a:Int8 = 120
//        print("int8:\(a)")
//        let i = Int(a)
//        print("转成int：\(i)")
//        let testInt = 10003
//        let testInt8 = Int8(testInt&127)
//        let testint64 = Int64(testInt8|127)
//        print("高位向地位转换:\(testInt8) 或运算 \(testint64)")
       //添加一tableveiw
        let tableView = UITableView()
        self.tableView = tableView
        tableView.frame = self.view.bounds
        self.view .addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
        self.loadIndexView()
    }
    func loadIndexView() {
        let screenWid = UIScreen.main.bounds.size.width
        let screenHei = UIScreen.main.bounds.size.height
        if indexView == nil {
            indexView = MJNIndexViewSwift.init(frame: CGRect.init(x: 0, y: 0, width: screenWid, height: screenHei-64))
            indexView?.dataSource = self
            indexView?.font = UIFont.systemFont(ofSize: 13)
            indexView?.fontColor =  UIColor.init(red: 0.3, green: 0.3, blue: 0.3, alpha: 1.0)
            //            InitSetFontColor(fontColor: UIColor.init(red: 0.3, green: 0.3, blue: 0.3, alpha: 1.0))
            self.view.addSubview(indexView!)
        }
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
    //c测试可选类型
    func testOptionals() -> () {
        let testOp1 :Optional<Int> = 1008611
        print("定义方式一：未解包前类型和值是：\(String(describing: testOp1))")
//        let testInt8 :Int8 = Int8(testOp1!)错误
//         print("int转成int8是：\(testInt8)")
        let testOpt2 = Optional<String>("第二种定义方式")
        print("定义方式二：未解包前类型和值是：\(String(describing: testOpt2))")
        var testOpS : String?
        testOpS =  "4334675444635"
        print("定义方式三：未解包前类型和值是：\(String(describing: testOpS))")
        print("强制解包类型和值是：\(testOpS!)")
        if let deOptionS = testOpS {
            print("绑定解包类型和值是：\(deOptionS)")
            let reserint64 = Int64.init(deOptionS)
            print("转换成int64是：\(reserint64 ?? 12)")
            if let tempint64 = reserint64 {
                let reserNSNum = NSNumber.init(value: tempint64)
                print("转换成NSNumber是：\(reserNSNum)")
            }
            
            
        }
        let refClosure: ((_ cunS : String?)-> String?)? = {(_ cus:String?)-> String? in
            print("\(cus!)-->这是一个闭包引用")
            return "测试用例"
        }
        let testClosWithOpt = refClosure!("测试参数")
        print("测试闭包与可选类型======\(testClosWithOpt ?? "error")")
        
        let ss: NSString = "9876543210"
        let ll: Int64 = ss.longLongValue
        print("转成 int64是："+"\(ll)")
        
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
extension ViewController:UITableViewDataSource,UITableViewDelegate,testProtoDelate,MJNIndexViewSwiftDataSource{
    // MARK:- tableView数据源方法
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return memberLists.count
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
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
            let title = UILabel.init(frame: CGRect.init(x: 20, y: 0, width: self.view.frame.size.width, height: 20))
            title.backgroundColor = UIColor.clear
            title.textAlignment = .left
            title.textColor = UIColor.gray
            title.font = UIFont.systemFont(ofSize: 14)
            let sectionTitle = memberLists[section]
            title.text = sectionTitle == "@" ? "管理员" : sectionTitle
            return title
            
    }

    
    func swiftSectionFor(SectionMJNIndexTitle title: String, atIndex index: Int) {
        tableView?.scrollToRow(at: NSIndexPath.init(item: 0, section: index) as IndexPath, at:.top , animated: (self.indexView?.getSelectedItemsAfterPanGestureIsFinished)!)
    }
    func swiftSectionIndexTitles(ForMJNIndexView indexView: MJNIndexViewSwift) -> ([String]) {
        
        if memberLists.count > 0 {
            return memberLists
        }
        return [String]()
    }

}
