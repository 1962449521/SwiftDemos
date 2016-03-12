//
//  ViewController.swift
//  FlyweightExampleSolution
//
//  Created by TomCat on 15-10-10.
//  Copyright (c) 2015年 Disney. All rights reserved.
//

import UIKit




class ViewController: UIViewController {
    @IBOutlet weak var toolBar: UIToolbar!
    
    @IBOutlet weak var boardView: BoardView!
    
    let shapeColor:Array = [UIColor.orangeColor(), UIColor.redColor(), UIColor.yellowColor(), UIColor.blueColor(), UIColor.purpleColor(), UIColor.cyanColor(), UIColor.magentaColor(), UIColor.blackColor(), UIColor.grayColor()];
    
    private func getRandColor()->UIColor{
        let index:Int = Int(arc4random()%8)
        return shapeColor[index]
    }
    private func getRandX()->CGFloat{ return CGFloat(Float(arc4random()%100)/100.0*Float(self.boardView.bounds.size.width) )}
    
    private func getRandY()->CGFloat{ return  CGFloat(Float(arc4random()%100)/100.0*Float(self.boardView.bounds.size.height) ) }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // NO flyweight
                // flyweight
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    let iterations = 500
        @IBAction func drawWithoutFlyweight(sender: AnyObject) {
        let  start = NSDate().timeIntervalSince1970
        var count1:Int?
        for  count in 1...iterations {
            let newRect = MyRect(color: self.getRandColor())
            let rect = CGRectMake(getRandX(), getRandY(), abs(getRandX() - getRandX()), abs(getRandX() - getRandY()))
            let s:RectState = RectState(rect: newRect, area:rect)
            boardView.rectList .append(s)
            count1 = count
        }
        boardView.setNeedsDisplay()
        let  end = NSDate().timeIntervalSince1970
        UIAlertView(title: "Without Flyweight Time Cost iter:\(count1)", message: "cost \(end-start) ms", delegate: nil, cancelButtonTitle: "ok").show()

    }
    @IBAction func clearSubviews(sender: AnyObject) {

        self.boardView.rectList.removeAll()
        boardView.setNeedsDisplay()

    }

    @IBAction func drawWithFlyWeight(sender: AnyObject) {
        let  start = NSDate().timeIntervalSince1970
        var count1:Int?
        let rectFactory = RectFactory()
        for  count in 1...iterations {
            let newRect = rectFactory.getRect( self.getRandColor())
            let rect = CGRectMake(getRandX(), getRandY(), abs(getRandX() - getRandX()), abs(getRandX() - getRandY()))
            let s:RectState = RectState(rect: newRect, area:rect)
            boardView.rectList .append(s)
            count1 = count
        }
        boardView.setNeedsDisplay()
        let  end = NSDate().timeIntervalSince1970
        UIAlertView(title: "Flyweight Time Cost iter:\(count1)", message: "cost \(end-start) ms", delegate: nil, cancelButtonTitle: "ok").show()
    }

}

