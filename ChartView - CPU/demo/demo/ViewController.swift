//
//  ViewController.swift
//  demo
//
//  Created by IceChen on 16/1/10.
//  Copyright © 2016年 IceChen. All rights reserved.
//

import UIKit

class ViewController: UIViewController, CVRecordHitProtocol {
    var dataSource: CVRecordSet?
    @IBOutlet var test : ChartView?
    
    required init (coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    @IBAction func swithDisplayLevel(sender: UIBarButtonItem) {
        test!.setDisplayLevel(sender.tag)
        test!.makeChangeVisible()
    }
    
    @IBAction func switchDataSet(sender: UIBarButtonItem) {
        let res = ["res/500_data", "res/100_result"]
        let path:String? =  NSBundle.mainBundle().pathForResource(res[sender.tag], ofType: "json")
        dataSource = CVRecordSet()
        dataSource!.initDataWithJsonFile(path!)
        test!.setDataSource(dataSource!)
        test!.makeChangeVisible()
    }

    @IBOutlet weak var txfDate: UITextField!
    
    @IBAction func move2Date(sender: AnyObject) {
        self.view.endEditing(true)
        let strDate:String? = txfDate.text
        let ts = CVUtil.timeIntervalFromDate(strDate!)
        test!.moveToTimeInterval(ts)
        test!.makeChangeVisible()

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        test!.backgroundColor = UIColor.blueColor()
        let path:String? =  NSBundle.mainBundle().pathForResource("res/500_data", ofType: "json")
        dataSource = CVRecordSet()
        dataSource!.initDataWithJsonFile(path!)
        
        test!.delegate = self
        test!.setDataSource(dataSource!)
        
        test!.UI_HighCurve_Color = UIColor.blackColor()
        test!.UI_StartGradient_Color = UIColor.redColor()
        
        test!.makeChangeVisible()
        
    }
    
    func CVRecordHit(recordIndex:Int) {
        let record:CVRecord = (dataSource?.data[recordIndex])! as! CVRecord
        NSLog("曲线图回调--- ate:\(record.date), low: \(record.lowValue), high:\(record.highValue)");
    }
    
    

}

