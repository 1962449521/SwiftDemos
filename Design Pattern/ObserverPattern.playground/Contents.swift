//: Playground - noun: a place where people can play

import Foundation
import UIKit

var displayStr = ""

protocol ChangeSubject {
    func addObserver(o: ChangeObserver)
    func removeObserver(o: ChangeObserver)
    func notifyObservers()
    func className()->String
}

protocol ChangeObserver {
    func refresh(s:ChangeSubject)
}



class Point:AnyObject, ChangeSubject {
     var x : Int
     var y : Int
     var color : UIColor
     private var observer: Array<ChangeObserver> = []
    
    func className()->String{
        return "Point"
    }
    
    init(x:Int, y:Int, color:UIColor){
        self.x = x
        self.y = y
        self.color = color
    }
     func setX(x:Int){
        self.x = x
        notifyObservers()
    }

    func setY(y:Int){
        self.y = y
        notifyObservers()
    }
    func setColor(color:UIColor){
        self.color = color
        notifyObservers()
    }
    func addObserver(o: ChangeObserver){
        self.observer.append(o)
    }
    func removeObserver(o: ChangeObserver){
        var index = -1
        for  item in self.observer {
            index++
            if (item as? AnyObject === o as? AnyObject) {
                self.observer.removeAtIndex(index)
            }
        }

    }
    func notifyObservers(){
        for  item in self.observer {
            item.refresh(self)
        }
    }
}

class Screen:AnyObject, ChangeSubject, ChangeObserver {
    private var name:String
    private var observer: Array<ChangeObserver> = []
    func className()->String{
        return "Screen"
    }

    
    init(s:String){
        self.name = s
    }
    
    func display(s:String){
        displayStr = displayStr + self.name + ":" + s
        notifyObservers()
    }
    
    func addObserver(o: ChangeObserver){
        self.observer.append(o)
    }
    func removeObserver(o: ChangeObserver){
        var index = -1
        for  item in self.observer {
            index++
            if (item as? AnyObject === o as? AnyObject) {
                self.observer.removeAtIndex(index)
            }
        }
        
    }
    func notifyObservers(){
        for  item in self.observer {
            item.refresh(self)
        }
    }
    
    func refresh(s:ChangeSubject) {
display("update received from a "+s.className()+" object\n")
        
    }
    

}

var p = Point(x: 5, y: 5, color: UIColor.blueColor())

print("Creating Screen s1,s2,s3,s4,s5 and Point p")

var s1 = Screen(s: "s1")
var s2 = Screen(s: "s2")

var s3 = Screen(s: "s3")
var s4 = Screen(s: "s4")

var s5 = Screen(s: "s5")

print("Creating observing relationships:")
print("- s1 and s2 observe color changes to p")
print("- s3 and s4 observe coordinate changes to p")
print("- s5 observes s2's and s4's display() method")

p.addObserver(s1);
p.addObserver(s2);

p.addObserver(s3);
p.addObserver(s4);

s2.addObserver(s5);
s4.addObserver(s5);

print("Changing p's color:");

p.setColor(UIColor.redColor());

print("Changing p's x-coordinate:");

p.setX(4);

print("done.")

displayStr

