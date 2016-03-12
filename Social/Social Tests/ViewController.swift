//
//  ViewController.swift
//  Social Tests
//
//  Created by 胡 帅 on 15/5/18.
//  Copyright (c) 2015年 griffith. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var resultBox: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func testPersistence(){
        var textResult:NSMutableString = NSMutableString(capacity: 0)
        contacts = mockData()
        DataPersistence().save()
        
        textResult.appendString("contacts before save:" )
        textResult.appendString(contacts![0].firstName! as String)
        textResult.appendString(", " )
        textResult.appendString(contacts![1].firstName! as String)
        textResult.appendString("\n" )

        contacts = nil
        textResult.appendString("contacts cleared\n" )
        var newContacts:[Contact]?  = DataPersistence().load()
        textResult.appendString("contacts reload :" )
        textResult.appendString(newContacts![0].firstName! as String)
        textResult.appendString(", " )
        textResult.appendString(newContacts![1].firstName! as String)

        resultBox.text = textResult as String
    }


}

