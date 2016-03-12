//
//  ViewController.swift
//  MementoExample
//
//  Created by 胡 帅 on 15/10/13.
//  Copyright © 2015年 TomCat. All rights reserved.
//

import UIKit

class Memento {
    private var article:String
    
    init(articleSave:String){
        self.article = articleSave
    }
    
    func getSavedArticle() ->String {
        return self.article
    }
}

class Caretaker {
    
    var savedArticles:Array<Memento> = []
    
    func addMemento(m:Memento) {
        savedArticles.append(m)
    }
    func getMemento(index:Int)->Memento {
        return savedArticles[index]
    }
}

class Originator {
    private var article:String = ""
    
    func set(newArticle:String){
        print("From Originator: Current Version of Article\n\(newArticle)\n")
        self.article = newArticle;
        
    }
    func storeInMemento() ->Memento{
        print("From Originator: Saving to Memento\n")
        return Memento(articleSave: article)
    }
    func restoreFromMemento( memento:Memento)->String{
        article = memento.getSavedArticle();
        print("From Originator: Previous Article Saved in Memento\n\(article)\n")
        return article
    }
}



class ViewController: UIViewController {
    var caretaker: Caretaker = Caretaker()
    var originator: Originator = Originator()
    var saveFiles = 0
    var currentArticle = 0
    

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var saveBut: UIButton!
    @IBOutlet weak var undoBut: UIButton!
    @IBOutlet weak var redoBut: UIButton!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        undoBut.enabled = false
        redoBut.enabled = false
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func saveButClick(sender: UIButton) {
        let textInTextArea = self.textField.text
        self.originator.set(textInTextArea!)
        caretaker.addMemento(originator.storeInMemento())
        saveFiles++
        currentArticle++
        print("Save Files \(saveFiles)")
        undoBut.enabled = true
    }
    @IBAction func undoButClick(sender: UIButton) {
        if (currentArticle >= 1) {
            currentArticle--;
            let textBoxString = originator.restoreFromMemento(caretaker.getMemento(currentArticle));
            self.textField.text = textBoxString
            redoBut.enabled = true
        } else {
            undoBut.enabled = false
        }
    }
    @IBAction func redoButClick(sender: UIButton) {
        if ((saveFiles - 1) > currentArticle) {
            currentArticle++;
            
            let textBoxString = originator.restoreFromMemento(caretaker.getMemento(currentArticle));
            
            self.textField.text = textBoxString
            
            undoBut.enabled = true
            
        } else {
            redoBut.enabled = false
            
        }
    }
}

