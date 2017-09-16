//
//  MJNIndexViewSwift.swift
//  VIMDemo
// 罗永孟
//  Created by VRV2 on 2017/9/14.
//  Copyright © 2017年 ymluo. All rights reserved.
//

import UIKit
import QuartzCore
import CoreText


protocol MJNIndexViewSwiftDataSource {
    
    /// you have to implement this method to provide this UIControl with NSArray of items you want to display in your index
    ///
    /// - Parameter indexView: suoyin
    /// - Returns:
    func swiftSectionIndexTitles(ForMJNIndexView indexView:MJNIndexViewSwift)->([String])
    
    /// you have to implement this method to get the selected index item
    ///
    /// - Parameters:
    ///   - title: biaoti
    ///   - index: suoyin
    /// - Returns:
    func swiftSectionFor(SectionMJNIndexTitle title:String , atIndex index:Int)->()
}
class MJNIndexViewSwift: UIControl {
//    宏定义
    private let DEBUG = 0
    
    
    // FOR ALL COLORS USE RGB MODEL - DON'T USE whiteColor, blackColor, grayColor or colorWithWhite, colorWithHue
    public var dataSource :MJNIndexViewSwiftDataSource?{
        didSet{
           print("hosten ..........setDatasource ")
            self.indexItems = self.dataSource?.swiftSectionIndexTitles(ForMJNIndexView: self)

        }
    }
    // set this to NO if you want to get selected items during the pan (default is YES)
    public var getSelectedItemsAfterPanGestureIsFinished :Bool
    /* set the font and size of index items (if font size you choose is too large it will be automatically adjusted to the largest possible)
     (default is HelveticaNeue 15.0 points)*/
    public var font :UIFont
    /* set the font of the selected index item (usually you should choose the same font with a bold style and much larger)
     (default is the same font as previous one with size 40.0 points) */
    public var selectedItemFont :UIFont?
    // set the color for index items
    public var fontColor :UIColor?{
        didSet{
            if (fontColor?.isEqual(UIColor.gray))! {
                self.fontColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0)
            } else if (fontColor?.isEqual(UIColor.black))! {
                self.fontColor = UIColor.init(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
            } else if (fontColor?.isEqual(UIColor.white))! {
                self.fontColor = UIColor.init(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            }
        }
    }
    // set if items in index are going to darken during a pan (default is YES)
    public var darkening :Bool
    // set if items in index are going ti fade during a pan (default is YES)
    public var fading :Bool
    // set the color for the selected index item
    public var selectedItemFontColor :UIColor
    // set index items aligment (NSTextAligmentLeft, NSTextAligmentCenter or NSTextAligmentRight - default is NSTextAligmentCenter)
    public var itemsAligment :NSTextAlignment?
    // set the right margin of index items (default is 10.0 points)
    public var rightMargin :Float
    /* set the upper margin of index items (default is 20.0 points)
     please remember that margins are set for the largest size of selected item font*/
    public var upperMargin :Float
    // set the lower margin of index items (default is 20.0 points)
    // please remember that margins are set for the largest size of selected item font
    public var lowerMargin :Float
    // set the maximum amount for item deflection (default is 75.0 points)
    public var maxItemDeflection :Float
    // set the number of items deflected below and above the selected one (default is 3 items)
    public var rangeOfDeflection :Int
    // set the curtain color if you want a curtain to appear (default is none)
    public var curtainColor :UIColor
    // set the amount of fading for the curtain between 0 to 1 (default is 0.2)
    public var curtainFade :Float
    // set if you need a curtain not to hide completely (default is NO)
    public var curtainStays :Bool
    // set if you want a curtain to move while panning (default is NO)
    public var curtainMoves :Bool
    // set if you need a curtain to have the same upper and lower margins (default is NO)
    public var curtainMargins :Bool
    // set the minimum gap between item (default is 5.0 points)
    public var minimumGapBetweenItems :Float?
    // set this property to YES and it will automatically set margins so that gaps between items are set to the minimumItemGap value (default is YES)
    public var ergonomicHeight :Bool
    // set the maximum height for index egronomicHeight - it might be useful for iPad (default is 400.0 ponts)
    public var maxValueForErgonomicHeight :Float?
    
    
    // item properties
     fileprivate var indexItems : [String]?
     fileprivate  var itemsAtrributes : [NSCache<AnyObject, AnyObject>]
     fileprivate var section : NSNumber?
    // sizes for items
     fileprivate var itemsOffset : Float
     fileprivate var firstItemOrigin : CGPoint?
     fileprivate var indexSize : CGSize?
     fileprivate var maxWidth : Float
     fileprivate var maxHeight : Float
     fileprivate var animate : Bool
     fileprivate var actualRangeOfDeflection : Int?
    
    // curtain properties
    fileprivate var gradientLayer :CAGradientLayer?{
//        get{
//            
//            return self .gradientLayer
//        }
        didSet{
            if ((self.gradientLayer?.superlayer) != nil) {
                self.gradientLayer?.removeFromSuperlayer()
                self.gradientLayer = nil
            }
            //         }   self.curtainFade = curtainFade;
        }
    }

     fileprivate var curtain : Bool
     fileprivate var curtainFadeFactor : Float?    // easter eggs properties
     fileprivate var dot : Bool
     fileprivate var times :Int
    

    // use this method if you want to change index items or change some properties for layout
    public func refreshIndexItems() -> () {
        //        if (debug == 1) {
        //            NSLog(@"Running %@ '%@'",self.class, NSStringFromSelector(_cmd));
        //        }
        
        // if items existed we have to remove all sublayers from main layer
        if self.itemsAtrributes.count > 0 {
            for item in self.itemsAtrributes {
                let layer:CALayer = item.object(forKey: "layer" as AnyObject) as! CALayer
                layer.removeFromSuperlayer()
            }
            self.itemsAtrributes.removeAll()
        }
        
        //    if (self.gradientLayer) [self.gradientLayer removeFromSuperlayer];
        if fontColor == nil {
            fontColor = UIColor.init(red: 0.2, green: 0.2, blue: 0.2, alpha: 1.0)
        }
        if let count = indexItems {
            if count.count > 0{
                print("hosten init index value")
                self.getAllItemsSize()
                self.initialiseAllAttributes()
                self.resetPosition()
            }else{
                print("hosten init false as indexItems haven value")
            }
        }else{
            print("hosten init false as indexItems is nil")
        }
        
        //        self.getAllItemsSize()
        //        self.initialiseAllAttributes()
        //        self.resetPosition()
    }
    
////   MARK: ---getters
   public func getFontColor() -> UIColor {
        if fontColor == nil{
            self.fontColor = UIColor.init(red: 0.2, green: 0.2, blue: 0.2, alpha: 1.0)
        }
        
        return fontColor!
    }
//  public  func getSelectedItemFontColor() -> UIColor {
//        if selectedItemFontColor == nil{
//            self.selectedItemFontColor = UIColor.init(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
//        }
//        
//        return selectedItemFontColor!
//    }
//   MARK: ---setters
 public   func InitSetCurtainColor(_ curtainColor :UIColor )
    {
        //    if (debug == 1) {
        //    NSLog(@"Running %@ '%@'",self.class, NSStringFromSelector(_cmd));
        //    }
        
        self.curtainColor = curtainColor;
        
    }
    
    
    
 public   func InitSetFontColor(fontColor :UIColor)
    {
        
        //    if (debug == 1) {
        //    NSLog(@"Running %@ '%@'",self.class, NSStringFromSelector(_cmd));
        //    }
        
        // we need to convert grayColor, whiteColor and blackColor to RGB;
        if (fontColor.isEqual(UIColor.gray)) {
            self.fontColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0)
        } else if (fontColor.isEqual(UIColor.black)) {
            self.fontColor = UIColor.init(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
        } else if (fontColor.isEqual(UIColor.white)) {
            self.fontColor = UIColor.init(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        } else{
            self.fontColor = fontColor
        }
    }
    
  public  func InitSetCurtainFade(_ curtainFade:Float)
    {
        //    if (debug == 1) {
        //    NSLog(@"Running %@ '%@'",self.class, NSStringFromSelector(_cmd));
        //    }
        
        if ((self.gradientLayer) != nil) {
            self.gradientLayer?.removeFromSuperlayer()
            self.gradientLayer = nil;
        }
        self.curtainFade = curtainFade;
    }
    
    
   public func initSetDataSource(_ dataSource:MJNIndexViewSwiftDataSource)
    {
//        if (debug == 1) {
//            NSLog(@"Running %@ '%@'",self.class, NSStringFromSelector(_cmd));
//        }
        
        self.dataSource = dataSource;
        self.indexItems = dataSource.swiftSectionIndexTitles(ForMJNIndexView: self)
    }
  
//   MARK: ---view lifecycle methods

     override init(frame: CGRect) {
        darkening = true
        fading = true
        itemsAligment = .center
        upperMargin = 20.0;
        lowerMargin = 20.0;
        rightMargin = 10.0;
        maxItemDeflection = 100.0;
        rangeOfDeflection = 3;
        font = UIFont.init(name: "HelveticaNeue", size: 15.0)!
        
        selectedItemFont = UIFont.init(name: "HelveticaNeue", size: 15.0)
        ergonomicHeight = true
        maxValueForErgonomicHeight = 400.0
        minimumGapBetweenItems = 5.0
        getSelectedItemsAfterPanGestureIsFinished = true
        itemsOffset = 0.0
        curtainColor = .clear
        curtainFade = 0.2
        curtainStays = false
        curtainMoves = false
        curtainMargins = false
        animate = true
        curtain = false
        dot = false
        itemsAtrributes = [NSCache<AnyObject, AnyObject>]()
        
        maxWidth  = Float(0.0)
        maxHeight = Float(0.0)
        times = 0
        selectedItemFontColor = UIColor.init(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
        super.init(frame: frame)
        self.backgroundColor = .clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public  override func didMoveToSuperview() {
        if DEBUG == 1 {
//            print("Running \(self.class) \(NSStringFromSelector(_cmd))")
        }
        if let count = indexItems {
            if count.count > 0{
                print("hosten init index value")
                self.getAllItemsSize()
                self.initialiseAllAttributes()
                self.resetPosition()
            }else{
                print("hosten init false as indexItems haven value")
            }
        }else{
            print("hosten init false as indexItems is nil")
        }
       
    }

//   MARK: ---    calculating initial values and sizes then setting them
    fileprivate func getAllItemsSize(){
        if DEBUG == 1 {
            //            print("Running \(self.class) \(NSStringFromSelector(_cmd))")
        }
        print("hosten function is getAllItemsSize ")
        var  indexSize:CGSize = CGSize.init(width: 0, height: 0)
        
        // determining font sizes
        let lineHeight :Float = Float(self.font.lineHeight)
        var maxlineHeight:Float = Float(self.selectedItemFont!.capHeight)
        let capitalLetterHeight:Float = Float(self.font.capHeight)
        let ascender:Float = Float(self.font.ascender)
        let descender:Float = -Float(self.font.descender)
        var entireHeight:Float = ascender
        
        // checking for upper and lower case letters and setting entireHeight value accordingly
        if (self.checkForLowerCase() && self.checkForUpperCase()) {
            entireHeight = lineHeight
            maxlineHeight = Float((self.selectedItemFont?.lineHeight)!)
        } else if (self.checkForLowerCase() && !self.checkForUpperCase()) {
            entireHeight = capitalLetterHeight + descender;
            maxlineHeight = Float((self.selectedItemFont?.lineHeight)!)
        }
        
        // calculating size of all index items
        
        for item in indexItems! {
            let currentItemSize:CGSize = item.size(attributes: [NSFontAttributeName:font])
            
            // if index items are smaller than 5.0 points display alert and do not display index at all
            if currentItemSize.height < 5.0 {
                //[NSException raise:@"Too many items in index" format:@"Items are to small to be legible"];
                print(" ******* Too many items in index. Items are too small to be legible. Index won't be displayed. *******");
                return;
            }
            indexSize.height = CGFloat(Float(indexSize.height) + entireHeight)
            if (currentItemSize.width > indexSize.width) {
                indexSize.width = currentItemSize.width
            }
        }
        
        // calculating if deflectionRange is not too small based on the width of the longest index item using the font for selected item
        for item in self.indexItems! {
            let currentItemSize = item.size(attributes: [NSFontAttributeName:font])
                if Float(currentItemSize.width) > maxWidth {
                    self.maxWidth = Float(currentItemSize.width)
                }
                if (Float(currentItemSize.width) > self.maxItemDeflection) {
                    self.maxItemDeflection = Float(currentItemSize.width)
                }
                if (Float(currentItemSize.height) > maxWidth) {
                    self.maxHeight = Float(currentItemSize.height)
                }

        }
        
        // ajdusting margins to ensure that minimum offset is 5.0 points
        var optimalIndexHeight:Float = Float(indexSize.height)
        if optimalIndexHeight > self.maxValueForErgonomicHeight! {
            optimalIndexHeight = self.maxValueForErgonomicHeight!
        }
        let offsetRatio:Float = self.minimumGapBetweenItems! * (Float(self.indexItems!.count)-1.0) + optimalIndexHeight + maxlineHeight / 1.5
        if (self.ergonomicHeight && (Float(self.bounds.size.height) - offsetRatio > 0.0)) {
            self.upperMargin = (Float(self.bounds.size.height) - offsetRatio)/Float(2)
            self.lowerMargin = self.upperMargin;
        }
        
        // checking if self.font size is not to large to draw entire index - if it's calculating the largest possible using recurency
        let heiget = Float(self.bounds.size.height) - (self.upperMargin + self.lowerMargin) - (self.minimumGapBetweenItems! * Float((self.indexItems?.count)!))
        if (Float(indexSize.height) > heiget) {
            self.font = self.font.withSize(self.font.pointSize)
//            UIFont
            self.getAllItemsSize()
            
        } else {
            // calculating an offset between index items
            let tempA:Float = Float(self.bounds.size.height) - (self.upperMargin + self.lowerMargin + maxlineHeight / 1.5)
            self.itemsOffset = (tempA - Float(indexSize.height)) / Float((self.indexItems?.count)!-1)
            
            
            
            
            // calculating the first item origin based on the offset, an items aligment and marging
            if (self.itemsAligment == .right) {
                self.firstItemOrigin = CGPoint.init(x: self.bounds.size.width - CGFloat(self.rightMargin), y: CGFloat( self.upperMargin + maxlineHeight / 2.5 + entireHeight / 2.0))

            } else if (self.itemsAligment == .center) {
                self.firstItemOrigin = CGPoint.init(x: self.bounds.size.width - CGFloat(self.rightMargin) - indexSize.width/2, y: CGFloat(self.upperMargin + maxlineHeight / 2.5 + entireHeight / 2.0))
                
                
            } else {
                self.firstItemOrigin = CGPoint.init(x: self.bounds.size.width - CGFloat(self.rightMargin) - indexSize.width, y: CGFloat(self.upperMargin + maxlineHeight / 2.5 + entireHeight / 2.0))
            }
            //
            self.itemsOffset += entireHeight;
            self.indexSize = indexSize;
        }
        
        // checking if range of items to deflect is not too big
        if (self.indexItems?.count == 1) {
            // if there is only one item in index there is no need to animate index
            self.actualRangeOfDeflection = 0;
        } else if (self.rangeOfDeflection > ((self.indexItems?.count)!/2 - 1)) { // if items range of deflection is bigger than half of items in index we should set it to exact half of items number
            self.actualRangeOfDeflection = (self.indexItems?.count)!/2;
        } else {
            self.actualRangeOfDeflection = self.rangeOfDeflection;
        }
        
    }
    
    fileprivate func checkForLowerCase() -> Bool{
        let lowerCaseSet: CharacterSet = CharacterSet.lowercaseLetters
        for item in indexItems! {
            let rangeS = item.rangeOfCharacter(from: lowerCaseSet)
//            NSNotFound
            
            if rangeS != nil {
                return true
            }
        }
        return false
        
        
    }
    fileprivate func checkForUpperCase() -> Bool{
        let upperCaseSet: CharacterSet = CharacterSet.uppercaseLetters
        for item in indexItems! {
            if item.rangeOfCharacter(from: upperCaseSet) != nil {
                return true
            }
        }
        return false
        
        
    }
    fileprivate func initialiseAllAttributes(){
//        if (debug == 1) {
//            //        print("Running %@ '%@'",self.class, NSStringFromSelector(_cmd));
//        }
        
        var verticalPos:Float = Float(self.firstItemOrigin!.y);
        var newItemsAttributes = [NSCache<AnyObject, AnyObject>]();
        
        var count:Int = 0;
        
        for item in indexItems! {
            
            // calculating items origins based on items aligment and firstItemOrigin
            var point:CGPoint = CGPoint.init(x: 0, y: 0);
            
            if (self.itemsAligment == .center){
                
                let itemSize:CGSize = item.size(attributes: [NSFontAttributeName:font])
                point.x = (self.firstItemOrigin?.x)! - itemSize.width/2;
            } else if (self.itemsAligment == .right) {
                
                let itemSize:CGSize = item.size(attributes: [NSFontAttributeName:font])
                point.x = (self.firstItemOrigin?.x)! - itemSize.width;
            } else{
                
                point.x = (self.firstItemOrigin?.x)!
                
            }
            
            point.y = CGFloat(verticalPos);
            let newValueForPoint: NSValue  = NSValue.init(cgPoint: point)
            
            
            if self.itemsAtrributes.count < 1 {
                let singleItemTextLayer: CATextLayer  = CATextLayer.init();
                
                let alpha = NSNumber.init(value:Float((self.fontColor?.cgColor.alpha)!))
                
                // setting zPosition a little above because we might need to put something below
                let zPosition = NSNumber.init(value: 5.0);
                let itemAttributes : NSCache<AnyObject, AnyObject> = NSCache<AnyObject, AnyObject>()
                itemAttributes.setObject(item as AnyObject, forKey: "item" as AnyObject)
                itemAttributes.setObject(newValueForPoint, forKey: "origin" as AnyObject)
                itemAttributes.setObject(newValueForPoint, forKey: "position" as AnyObject)
                itemAttributes.setObject(alpha, forKey: "alpha" as AnyObject)
                itemAttributes.setObject(zPosition, forKey: "zPosition" as AnyObject)
                itemAttributes.setObject(singleItemTextLayer, forKey: "layer" as AnyObject)
                itemAttributes.setObject(self.fontColor!, forKey: "color" as AnyObject)
                itemAttributes.setObject(CTFontCreateWithName(font.fontName as CFString? , (font.pointSize), nil), forKey: "font" as AnyObject)
                itemAttributes.setObject(NSNumber.init(value:Float(font.pointSize)), forKey: "fontSize" as AnyObject)
//                itemAttributes = cachDic
                newItemsAttributes.append(itemAttributes);
            } else {
                 let attCach = self.itemsAtrributes[count]
                var origin:CGPoint = attCach.object(forKey: "origin" as AnyObject) as! CGPoint
                var poins:CGPoint = attCach.object(forKey: "position" as AnyObject) as! CGPoint
                 origin = newValueForPoint as! CGPoint
                 poins = newValueForPoint as! CGPoint
            }
            
            verticalPos += self.itemsOffset
            count += 1
            
        }

        self.addCurtain()
        if self.itemsAtrributes.count < 1 {
            self.itemsAtrributes = newItemsAttributes

        }
    }
    
    
    // reseting positions of index items
    fileprivate func resetPosition(){
        //        if (debug == 1) {
        //            NSLog(@"Running %@ '%@'",self.class, NSStringFromSelector(_cmd));
        //        }
        
        for itemAttribute in self.itemsAtrributes{
            let origin:CGPoint = itemAttribute.object(forKey: "origin" as AnyObject) as! CGPoint
            itemAttribute.setObject(CTFontCreateWithName(font.fontName as CFString?, (font.pointSize), nil), forKey: "font" as AnyObject)
            itemAttribute.setObject(NSValue.init(cgPoint: origin), forKey: "position" as AnyObject)
            itemAttribute.setObject(NSNumber.init(value: 1.0), forKey: "alpha" as AnyObject)
            itemAttribute.setObject(NSNumber.init(value: 5.0), forKey: "zPosition" as AnyObject)
            itemAttribute.setObject(self.fontColor!, forKey: "color" as AnyObject)
            
        }
        
        self.drawIndex();
        self.setNeedsDisplay();
        
        self.animate = true;
    }
    
    
    // MARK: ---- calculating item position during the pan gesture
    fileprivate func positionForIndexItemsWhilePanLocation(location : CGPoint){
        //        if (debug == 1) {
        //            NSLog(@"Running %@ '%@'",self.class, NSStringFromSelector(_cmd));
        //        }
        
        var verticalPos:Float = Float(self.firstItemOrigin!.y);
        
        var section:Int = 0
        for itemAttribute in self.itemsAtrributes {
            
            var alpha:Float = itemAttribute.object(forKey: "alpha" as AnyObject) as! Float
            var point:CGPoint = itemAttribute.object(forKey: "position" as AnyObject) as! CGPoint
            let origin:CGPoint = itemAttribute.object(forKey: "origin" as AnyObject) as! CGPoint
            var fontSize:Float = itemAttribute.object(forKey: "fontSize" as AnyObject) as! Float
            var fontColor:UIColor
            
            var inRange:Bool = false
            
            // we have to map amplitude of deflection
            
            let mappedAmplitude:Float = self.maxItemDeflection / self.itemsOffset / Float(self.actualRangeOfDeflection!)
            
            // now we are checking if touch is within the range of items we would like to deflect
            let min:Bool = Float(location.y) > Float(point.y) - (Float(self.actualRangeOfDeflection!) * self.itemsOffset)
            let max:Bool = Float(location.y) < Float(point.y) + (Float(self.actualRangeOfDeflection!) * self.itemsOffset)
            
            if (min && max) {
                
                // these calculations are necessary to make our deflection not linear
                let differenceMappedToAngle:Float = 90.0 / (self.itemsOffset * Float(self.actualRangeOfDeflection!));
                let angle:Float = (Float(fabs(point.y - location.y))*differenceMappedToAngle);
                let angleInRadians:Float = angle * Float(Double.pi/180);
                let arcusTan:Float = fabs(atan(angleInRadians));
                
                // now we have to calculate the deflected position of an item
                point.x = origin.x - CGFloat(self.maxItemDeflection) + CGFloat(CGFloat(fabsf(Float(point.y - location.y))) * CGFloat(mappedAmplitude)) * CGFloat(arcusTan)
                
                point.x = point.x>origin.x ? origin.x : point.x
                
                // we have to map difference to range in order to determine right zPosition
                let differenceMappedToRange:Float = Float(self.actualRangeOfDeflection!) / (Float(self.actualRangeOfDeflection!) * self.itemsOffset);
                
                let zPosition:Float = Float(self.actualRangeOfDeflection!) - Float(fabs(point.y - location.y)) * differenceMappedToRange;
                let cach = NSCache<AnyObject, AnyObject>.init()
                cach.setObject(NSNumber.init(value: 5.0 + zPosition), forKey: "zPosition" as AnyObject)
             
                
                // calculating a fontIncrease factor of the deflected item
                var fontIncrease:Float = (self.maxItemDeflection - Float(fabs(point.y - location.y)) *
                    mappedAmplitude) / (self.maxItemDeflection / Float((self.selectedItemFont?.pointSize)! - (self.font.pointSize)))
                
                fontIncrease = fontIncrease>0.0 ? fontIncrease : 0.0;
                
                fontSize = Float((self.font.pointSize)) + fontIncrease;
                cach.setObject(NSNumber.init(value:fontSize), forKey: "fontSize" as AnyObject)
                itemsAtrributes.append(cach)
                // calculating a color darkening factor
                let differenceMappedToColorChange:Float = 1.0 / (Float(self.actualRangeOfDeflection!) * self.itemsOffset);
                let colorChange:Float = Float(fabs(point.y - location.y)) * differenceMappedToColorChange;
                
                if (self.darkening) {
                    fontColor = self.darkerColor(self.fontColor!, byvalue: colorChange)
//                    [self darkerColor:self.fontColor by: colorChange];
                } else{
                    fontColor = self.fontColor!
                }
                
                // we're using the same factor for alpha (fading)
                if (self.fading) {
                    alpha = colorChange;
                } else{
                    alpha = 1.0
                }
                itemAttribute.setObject(CTFontCreateWithName(font.fontName as CFString?, (font.pointSize), nil), forKey: "font" as AnyObject)
                itemAttribute.setObject(fontColor, forKey: "color" as AnyObject)
                
                // checking if the item is the most deflected one -> it means it is the selected one
                let selectedInRange:Bool  = location.y > point.y - CGFloat( self.itemsOffset / 2.0) && location.y < point.y + CGFloat(self.itemsOffset / 2.0);
                // we need also to check if the selected item is the first or the last one in the index
                let firstItemInRange:Bool = (section == 0 && (location.y < CGFloat(self.upperMargin) + ((self.selectedItemFont?.pointSize)!) / 2.0));
                let lastItemInRange:Bool = (section == self.itemsAtrributes.count - 1 &&
                location.y > (self.bounds.size.height - (CGFloat(self.lowerMargin) + (self.selectedItemFont?.pointSize)! / 2.0)));
                
                // if our location is pointing to the selected item we have to change this item's font, color and make it's zPosition the largest to be sure it's on the top
                if (selectedInRange || firstItemInRange || lastItemInRange) {
                    alpha = 1.0;
                    itemAttribute.setObject(CTFontCreateWithName(self.selectedItemFont?.fontName as CFString?, (font.pointSize), nil), forKey: "font" as AnyObject)
                    itemAttribute.setObject(selectedItemFontColor, forKey: "color" as AnyObject)
                    itemAttribute.setObject(NSNumber.init(value: 10.0) as AnyObject, forKey: "zPosition" as AnyObject)
                    
                    if (!self.getSelectedItemsAfterPanGestureIsFinished && Int(self.section!) != section) {
                        self.dataSource?.swiftSectionFor(SectionMJNIndexTitle: (self.indexItems?[section])!, atIndex: section)
                    }
                    self.section = NSNumber.init(value: section);
                    
                }
                
                // we're marking these items as inRange items
                inRange = true;
                
            }
            
            // if item is not in range we have to reset it's x position, alpha value, font name, size and color, zPosition
            if (!inRange) {
                
                point.x = origin.x;
                alpha = 1.0;
                itemAttribute.setObject(CTFontCreateWithName(self.selectedItemFont?.fontName as CFString?, (font.pointSize), nil), forKey: "font" as AnyObject)
                if let fontColorT = self.fontColor{
                    fontColor = fontColorT
                    itemAttribute.setObject(fontColorT, forKey: "color" as AnyObject)
                    itemAttribute.setObject(NSNumber.init(value: 5.0) as AnyObject, forKey: "zPosition" as AnyObject)

                }else{
                    print("hosten The font color is nill with fontColor--> \(String(describing: self.fontColor))")
                }
               
            }
            
            // we have to store some values in itemAtrributes array
            point.y = CGFloat(verticalPos);
            let newValueForPoint: NSValue  = NSValue.init(cgPoint: point)
            itemAttribute.setObject(newValueForPoint, forKey: "position" as AnyObject)
            itemAttribute.setObject(NSNumber.init(value: alpha) as AnyObject, forKey: "alpha" as AnyObject)
       
            verticalPos += self.itemsOffset
            section += 1
        }
        
        // when are calculations are over we can redraw all items
        self.drawIndex()
        // we set this to NO because we want the animation duration to be as short as possible
        self.animate = true;
    }

    // calculating darker color to the given one
    fileprivate func darkerColor(_ color:UIColor, byvalue value :Float)->UIColor{
//        if (debug == 1) {
//            NSLog(@"Running %@ '%@'",self.class, NSStringFromSelector(_cmd));
//        }
        
        var h:CGFloat = 1.0;
        var s:CGFloat = 1.0;
        var b:CGFloat = 1.0;
        var a:CGFloat = 1.0;
        
        if color.getHue(&h, saturation: &s, brightness: &b, alpha: &a){
            return UIColor.init(hue: h, saturation: s, brightness: b, alpha: a)
        }
        return UIColor.clear
    }
    
    
    //  MARK: ---- drawing CATextLayers with indexitems
    fileprivate func  drawIndex(){
        //    if (debug == 1) {
        //    NSLog(@"Running %@ '%@'",self.class, NSStringFromSelector(_cmd));
        //    }
        
        for itemAttribute in self.itemsAtrributes {
            // getting attributes necessary to check if we need to animate
            var currentFont:CTFont = itemAttribute.object(forKey: "font" as AnyObject) as! CTFont
            var singleItemTextLayer:CATextLayer = itemAttribute.object(forKey: "layer" as AnyObject) as! CATextLayer
            
            // checking if all CATexts exists
            if (self.itemsAtrributes.count != (self.layer.sublayers?.count)! - 1) {
                self.layer.addSublayer(singleItemTextLayer)
            }
            
            // checking if font size is different if it's different we have to animate CALayer
            if (singleItemTextLayer.fontSize != CTFontGetSize(currentFont)) {
                // we have to animate several CALayers at once
                CATransaction.begin()
                
                // if we need to animate faster we're changing the duration to be as short as possible
                
                if (!self.animate) {
                    CATransaction.setAnimationDuration(0.005)
                }
                else {
                     CATransaction.setAnimationDuration(0.2);
                }
                
                // getting other attributes and updading CALayer
                
                let point:CGPoint = itemAttribute.object(forKey: "position" as AnyObject) as! CGPoint
                let currentItem:String = itemAttribute.object(forKey: "item" as AnyObject) as! String
                
                let stringRef:CFString = currentItem as CFString
                let attrStr:CFMutableAttributedString = CFAttributedStringCreateMutable(kCFAllocatorDefault, 0);
                CFAttributedStringReplaceString (attrStr, CFRangeMake(0, 0), stringRef);
//                let alignment:CTTextAlignment = .justified;
                var  lineSpacing:CGFloat = 5
                let settings = [CTParagraphStyleSetting(spec: .lineSpacingAdjustment, valueSize: MemoryLayout<CGFloat>.size, value:&lineSpacing),CTParagraphStyleSetting(spec: .maximumLineSpacing, valueSize: MemoryLayout<CGFloat>.size, value: &lineSpacing),CTParagraphStyleSetting(spec: .minimumLineSpacing, valueSize: MemoryLayout<CGFloat>.size, value: &lineSpacing)]
       
                let paragraphStyle:CTParagraphStyle = CTParagraphStyleCreate(settings, 3);
                CFAttributedStringSetAttribute(attrStr, CFRangeMake(0, CFAttributedStringGetLength(attrStr)), kCTParagraphStyleAttributeName, paragraphStyle);
                CFAttributedStringSetAttribute(attrStr, CFRangeMake(0, CFAttributedStringGetLength(attrStr)), kCTFontAttributeName, currentFont);
                let framesetter:CTFramesetter = CTFramesetterCreateWithAttributedString(attrStr);
                 let size = CGSize.init(width:CGFloat( maxWidth), height: CGFloat(maxHeight*2.0))
                 let textSize:CGSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRange.init(location: 0, length: currentItem.characters.count), nil, size, nil)
                
                let fontColor:UIColor = itemAttribute.object(forKey: "color" as AnyObject) as! UIColor
                
                singleItemTextLayer.zPosition = itemAttribute.object(forKey: "zPosition" as AnyObject) as! CGFloat
                singleItemTextLayer.font = currentFont;
                singleItemTextLayer.fontSize = CTFontGetSize(currentFont);
                singleItemTextLayer.opacity = itemAttribute.object(forKey: "alpha" as AnyObject) as! Float
                singleItemTextLayer.string = currentItem;
                singleItemTextLayer.backgroundColor = UIColor.clear.cgColor;
                singleItemTextLayer.foregroundColor = fontColor.cgColor;
                singleItemTextLayer.bounds = CGRect.init(x: CGFloat(0.0), y: CGFloat(0.0), width: textSize.width, height: textSize.height)
                
                singleItemTextLayer.position = CGPoint.init(x:point.x + textSize.width/2.0,
                                                            y:point.y)
                singleItemTextLayer.contentsScale = UIScreen.main.scale;
                
                CATransaction.commit()
                
            }
        }
    }
    
    
    //   MARK:------ managing touch events
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        //    if (debug == 1) {
        //    NSLog(@"Running %@ '%@'",self.class, NSStringFromSelector(_cmd));
        //    }
        
        var section:Int = 0;
        
        // checking if item any item is touched
        for itemAttribute in self.itemsAtrributes  {
            let point:CGPoint = itemAttribute.object(forKey: "position" as AnyObject) as! CGPoint
            let location:CGPoint = touch.location(in: self)
            if (location.y > point.y - CGFloat(self.itemsOffset / 2.0)  &&
                location.y < point.y + CGFloat(self.itemsOffset / 2.0)) {
                self.section = NSNumber.init(value: section)
            }
            section += 1
        }
        self.dot = false;
        return true;
    }
    override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        //    if (debug == 1) {
        //    NSLog(@"Running %@ '%@'",self.class, NSStringFromSelector(_cmd));
        //    }
        
        let currentY:CGFloat = touch.location(in: self).y;
        let prevY:CGFloat = touch.previousLocation(in: self).y;
        
        
        self.showCurtain()
        
        // if pan is longer than three pixel we need to accelerate animation by setting self.animate to NO
        if (fabs(currentY - prevY) > 3.0) {
            self.animate = false;
        }
        // drawing deflection
        self.positionForIndexItemsWhilePanLocation(location: touch.location(in: self))
        return true;
    }
    
    
    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        //    if (debug == 1) {
        //    NSLog(@"Running %@ '%@'",self.class, NSStringFromSelector(_cmd));
        //    }
        
        if (self.indexItems?.count)! > 0 {
            // sending selected items to dataSource
            self.dataSource?.swiftSectionFor(SectionMJNIndexTitle: (self.indexItems?[Int(section!)])!, atIndex: Int(section!))
            
            // some easter eggs ;)
            if let sectionT = section {
                if (Int(sectionT) == 3 * times) {
                    self.times += 1
                    if (self.times == 5) {
                        self.dot = true;
                        self.setNeedsDisplay()
                    }
                } else {
                    self.times = 0;
                }
                

            }
                       // if pan stopped we can deacellerate animation, reset position and hide curtain
            self.animate = true;
            self.resetPosition()
            self.hideCurtain()
        }
       
    }
    
    override func cancelTracking(with event: UIEvent?) {
        //    if (debug == 1) {
        //    NSLog(@"Running %@ '%@'",self.class, NSStringFromSelector(_cmd));
        //    }
        
        // if touch was canceled we reset everything
        self.animate = true;
        self.resetPosition()
        self.hideCurtain()

    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        //        if (debug == 1) {
        //            NSLog(@"Running %@ '%@'",self.class, NSStringFromSelector(_cmd));
        //        }
        
        // UIView will be "transparent" for touch events if we return NO
        // we are going to return YES only if items or area right to them is being touched
        let pintX = self.bounds.size.width - ((self.indexSize?.width)! + CGFloat( self.rightMargin + 10.0))
        if point.x > pintX && point.y > 0.0 && point.y < CGFloat(self.bounds.size.height){
            return true
        }
        //if (point.y > self.bounds.size.height) return NO;
        return true
 
    }
    
//MAEK:---- drawing curtain with CAGradientLayer or CALayer

    fileprivate func addCurtain()
    {
//        if (debug == 1) {
//            NSLog(@"Running %@ '%@'",self.class, NSStringFromSelector(_cmd));
//        }
        
        // if we want a curtain to fade we have to use CAGradientLayer
        if self.curtainFade != 0.0 {
            if (self.curtainFade > 1){
                self.curtainFade = 1
            }
            if !(self.gradientLayer != nil) {
                self.gradientLayer = CAGradientLayer()
                layer.insertSublayer(gradientLayer!, at: 0)
            }
            // we have to read color components
            let colorComponents =  self.curtainColor.cgColor.components!
            let arr: [CGColor]
            if colorComponents.count < 3 {
                 arr = [UIColor.init(red: colorComponents[0], green: colorComponents[1], blue: colorComponents[1], alpha: 0.0).cgColor,self.curtainColor.cgColor]
            }else{
                 arr  = [UIColor.init(red: colorComponents[0], green: colorComponents[1], blue: colorComponents[2], alpha: 0.0).cgColor,self.curtainColor.cgColor]
            }
            self.gradientLayer?.colors = arr
            
            // calculating end?Point for gradient based on maxItemDeflection and maxWidth of longest selected item
            let temtfL:Float = Float(self.bounds.size.width) - self.rightMargin - self.maxItemDeflection - 0.25 * self.maxWidth - 15.0
            self.curtainFadeFactor = temtfL / Float(self.bounds.size.width)
            self.gradientLayer?.startPoint =  CGPoint.init(x: Double(curtainFadeFactor! - (self.curtainFade * self.curtainFadeFactor!)), y: 0.0)
            if curtainFadeFactor! > 0.02 {
                self.gradientLayer?.endPoint = CGPoint.init(x:Double(curtainFadeFactor!),y:0.0)
            }else{
                self.gradientLayer?.endPoint = CGPoint.init(x:0.02,y:0.0)
            }
            
            
        } else {
            
            // if we do not need the fading curtain we can use simple CALayer
            if (!(self.gradientLayer != nil)) {
                self.gradientLayer = (CALayer() as! CAGradientLayer);
                self.layer.insertSublayer(self.gradientLayer!, at:0);
            }
            self.gradientLayer?.backgroundColor = self.curtainColor.cgColor;
        }
        
        // curtain is added now we have to hide it first
        self.curtain = true;
        self.hideCurtain();
    }
    
    // hiding the curtain
    fileprivate func hideCurtain()
    {
//        if (debug == 1) {
//            NSLog(@"Running %@ '%@'",self.class, NSStringFromSelector(_cmd));
//        }
        
        // first we have to check if the curtain is shown and a color for it is set
        if self.curtain {
            var curtainBoundsRect:CGRect;
            var curtainVerticalCenter:Float;
            var curtainHorizontalCenter:Float;
            var multiplier:Float = Float(2.0);
            
            if (!self.curtainMargins) {
                let windth = Float(Float((indexSize?.width)!) * multiplier) + self.rightMargin
                curtainBoundsRect = CGRect.init(x: CGFloat(0.0), y: CGFloat(0.0), width:CGFloat(windth), height:self.bounds.size.height)
                curtainVerticalCenter = Float(self.bounds.size.height / 2.0)
            } else {
                // if we need cutain to have the same margins as index items we have to change its height and its vertical center
                let windth = (self.indexSize?.width)! * CGFloat(multiplier) + CGFloat(rightMargin)
                curtainBoundsRect = CGRect.init(x: 0.0, y: 0.0, width:windth ,height: CGFloat(self.bounds.size.height) - CGFloat(self.upperMargin + self.lowerMargin))
               
                curtainVerticalCenter = self.upperMargin + Float(curtainBoundsRect.size.height) / 2.0
            }
            
            
            if (!self.curtainStays) {
                curtainHorizontalCenter = Float(self.bounds.size.width + self.bounds.size.width / 2.0)
                
            } else {
                // if we don't want the curtain to hide completely we have again to check if we need margins or not and change its height respectively
                if (self.curtainMargins) {
                    curtainBoundsRect = CGRect.init(x:CGFloat( 0.0), y: CGFloat(0.0), width:self.bounds.size.width, height:self.bounds.size.height - CGFloat(self.upperMargin + self.lowerMargin))
                }else{
                   curtainBoundsRect = self.bounds
                }
                
                
                // now we need to calculate an offset needed to position curtain not entirely outside the screen
                // to do this we must check items aligment and calculate horizontal center for its position
                var offset: Float;
                if (self.itemsAligment == .right){
                    offset = Float(self.bounds.size.width - ((self.firstItemOrigin?.x)!  - (self.indexSize?.width)!/2.0))
                }else if (self.itemsAligment == .center){
                    offset =  (Float(self.bounds.size.width - (self.firstItemOrigin?.x)!))
                }else{
                    offset = (Float(self.bounds.size.width - ((self.firstItemOrigin?.x)! +  (self.indexSize?.width)!/2.0)))
                }
                
                curtainHorizontalCenter = Float(self.bounds.size.width + self.bounds.size.width / 2.0) -  Float(2 * offset)
                
                // if we are using CAGradientLayer we have to change horizonl center value and recalculate the start and endpoint for gradient
                if (self.gradientLayer?.isKind(of: CAGradientLayer.self))! {
                    
                    curtainHorizontalCenter = (Float(self.bounds.size.width) + Float(self.bounds.size.width) / 2.0) -  (2.0  * offset + self.curtainFade * offset)
                    
                    self.gradientLayer?.startPoint = CGPoint.init(x:0.001,y:0.0)
                    
                    if curtainFade > Float(300.0 * (self.gradientLayer?.startPoint.x)!) {
                        self.gradientLayer?.endPoint = CGPoint.init(x:CGFloat(curtainFade * 00.1), y:CGFloat(0.0))
                    }else{
                        self.gradientLayer?.endPoint = CGPoint.init(x:CGFloat(300.0 * (self.gradientLayer?.startPoint.x)! * 00.1), y:CGFloat(0.0))
                    }
                    
                }
            }
            
            // now we can set the courtain bounds and position andset the BOOL self.curtain to NO which meanse the curtain is hidden
            self.gradientLayer?.bounds = curtainBoundsRect;
            self.gradientLayer?.position = CGPoint.init(x:CGFloat(curtainHorizontalCenter), y:CGFloat(curtainVerticalCenter));
            self.curtain = false;
        }
    }
    
    
    // showing the curtain
    fileprivate func showCurtain()
    {
//        if (debug == 1) {
//            NSLog(@"Running %@ '%@'",self.class, NSStringFromSelector(_cmd));
//        }
        
        // first we have to check if the curtain is shown and a color for it is set
    
            if (!self.curtain && self.curtainMoves && self.actualRangeOfDeflection! > 0) {
                var curtainVerticalCenter:Float
                var curtainBoundsRect:CGRect
                
                // again like in case for hideCurtain we must calculate position and size for all possible configurations
                if (!self.curtainMargins) {
                    curtainBoundsRect = self.bounds
                    curtainVerticalCenter = Float(self.bounds.size.height / 2.0)
                } else {
                    curtainBoundsRect = CGRect.init(x:CGFloat(0.0), y:CGFloat(self.upperMargin), width:CGFloat(self.bounds.size.width),height:CGFloat(self.bounds.size.height) - CGFloat(self.upperMargin + self.lowerMargin))
                    
                    //                    CGRectMake(0.0, self.upperMargin, self.bounds.size.width, self.bounds.size.height - (self.upperMargin + self.lowerMargin));
                    curtainVerticalCenter = self.upperMargin + Float(curtainBoundsRect.size.height / 2.0)
                }
                
                if (self.gradientLayer?.isKind(of: CAGradientLayer.self))! {
                    // we need to use CATransaction because we need the animation to bee faster
                    CATransaction.begin()
                    CATransaction.setAnimationDuration(0.075)
                    
                    self.gradientLayer?.bounds = curtainBoundsRect;
                    
                    
                    let maxTest = self.curtainFadeFactor! - self.curtainFade * self.curtainFadeFactor!
                    self.gradientLayer?.startPoint = CGPoint.init(x:CGFloat(maxTest > Float(0.001) ? maxTest : Float(0.001)), y:CGFloat(0.0))
                    self.gradientLayer?.endPoint = CGPoint.init(x:CGFloat(curtainFadeFactor!>Float(0.3) ? curtainFadeFactor! : Float(0.3)),y:CGFloat(0.0))
                    self.gradientLayer?.position = CGPoint.init(x:CGFloat(Float(self.bounds.size.width) / 2.0), y:CGFloat(curtainVerticalCenter))
                    CATransaction .commit()
                } else {
                    CATransaction.begin()
                    CATransaction.setAnimationDuration(0.075)
                    
                    self.gradientLayer?.bounds = curtainBoundsRect;
                    self.gradientLayer?.position = CGPoint.init(x:(CGFloat(self.bounds.size.width - CGFloat(self.rightMargin) - CGFloat(self.maxItemDeflection) - CGFloat(0.25) * CGFloat(self.maxWidth) - CGFloat(15.0)) + self.bounds.size.width / CGFloat(2.0)),y: CGFloat(curtainVerticalCenter))
                    CATransaction .commit()
                };
                
                self.curtain = true
        }
        
            
        
        
    }
    
    // drawing text labels for test purposes only
    fileprivate func drawLabel(_ label :String, withFont font: UIFont, forSizE size:CGSize,
                               atPoint point:CGPoint, withAlignment alignment:NSTextAlignment, lineBreakMode lineBreak:NSLineBreakMode ,WithColor color:UIColor)
    {
//        if (debug == 1) {
//            NSLog(@"Running %@ '%@'",self.class, NSStringFromSelector(_cmd));
//        }
        
        // obtain current context
        let context:CGContext = UIGraphicsGetCurrentContext()!;
        
        // save context state first
        context.saveGState();
        
        
        // obtain size of drawn label
        let lableNss:NSString = label as NSString
        let newSize:CGSize = lableNss.size(attributes: [NSFontAttributeName:font])
        
        
        // determine correct rect for this label
         let rect = CGRect.init(x:point.x , y: point.y, width: newSize.width, height: newSize.height)
        
        // set text color in context
        context.setFillColor(color.cgColor)
        
        // draw text
        lableNss.draw(in: rect, withAttributes: [NSFontAttributeName:font])
        
        // restore context state
        context.restoreGState();
    }
    
    
    // drawing rectangles - for test purposes only
    fileprivate func drawTestRectangle(AtPoint p:CGPoint, withSize size:CGSize, WithRed red:Float,AndGreen green:Float,andBlue blue:Float,withalpha alpha:Float)
    {
//        if (debug == 1) {
//            NSLog(@"Running %@ '%@'",self.class, NSStringFromSelector(_cmd));
//        }
        
        let context:CGContext = UIGraphicsGetCurrentContext()!;
        context.saveGState();
        context.setFillColor(red: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha: CGFloat(alpha));
        context.beginPath();
        let rect = CGRect.init(x:p.x , y: p.y, width:  size.width, height: size.height)
        context.addRect(rect);
        context.fillPath();
        context.restoreGState();
    }
    
    // our drawRect - for test purposee only
    override func draw(_ rect: CGRect) {
//        if (debug == 1) {
//            NSLog(@"Running %@ '%@'",self.class, NSStringFromSelector(_cmd));
//        }
        
        if (self.dot) {
            self.drawTestRectangle(AtPoint: CGPoint.init(x: self.bounds.size.width / 2.0 - 100.0, y:  self.bounds.size.height / 2.0 - 100.0), withSize: CGSize.init(width: 200.0, height: 200.0), WithRed: 1.0, AndGreen: 1.0, andBlue: 1.0, withalpha: 1.0)
          
            self.drawLabel("Index for tableView designed by mateusz@ nuckowski.com", withFont: UIFont.init(name: "HelveticaNeue-UltraLight", size: 25.0)!, forSizE: CGSize.init(width: 175.0, height: 150.0), atPoint: CGPoint.init(x: self.bounds.size.width / 2.0 - 78.0, y: self.bounds.size.height / 2.0 - 80.0), withAlignment: .center, lineBreakMode: .byWordWrapping, WithColor: UIColor.init(red: 0.0, green: 105.0/255.0, blue: 240.0/255.0, alpha: 1.0))
        }
        
    }

}
