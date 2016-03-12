//: Playground - noun: a place where people can play

import UIKit
import Foundation

var displayStr = ""
protocol Visitable {
    func accept( visitor:Visitor)->Double;
}

protocol Visitor {
    func  visit( liquorItem:Liquor) ->Double;
    
    func  visit( tobaccoItem:Tobacco) ->Double;
    
    func  visit( necessityItem:Necessity) ->Double;
}

class Liquor: Visitable {
    private  let price:Double
    init(item:Double){
        self.price = item
    }
    
    func accept( visitor:Visitor)->Double{
        return visitor.visit(self);
    }
    func getPrice()->Double{
        return self.price
    }
}
class Tobacco: Visitable {
    private  let price:Double
    init(item:Double){
        self.price = item
    }
    
    func accept( visitor:Visitor)->Double{
        return visitor.visit(self);
    }
    func getPrice()->Double{
        return self.price
    }

}
class Necessity: Visitable {
    private  let price:Double
    init(item:Double){
        self.price = item
    }
    
    func accept( visitor:Visitor)->Double{
        return visitor.visit(self);
    }
    func getPrice()->Double{
        return self.price
    }
}
class TaxVisitor: Visitor {
    func  visit( liquorItem:Liquor) ->Double{
        displayStr = displayStr + "Liquor Item: Price with Tax\n"
        let dou:NSString = NSString(format: "%.2f", (liquorItem.getPrice() * 0.18) + liquorItem.getPrice())
        return dou.doubleValue
    }
    
    func  visit( tobaccoItem:Tobacco) ->Double{
        displayStr = displayStr + "Tobacco Item: Price with Tax\n"
        let dou:NSString = NSString(format: "%.2f", (tobaccoItem.getPrice() * 0.32) + tobaccoItem.getPrice())
        return dou.doubleValue
    }
    
    func  visit( necessityItem:Necessity) ->Double{
        displayStr = displayStr + "Necessity Item: Price with Tax\n"
        let dou:NSString = NSString(format: "%.2f", necessityItem.getPrice())
        return dou.doubleValue
    }
   
}

var taxCalc =  TaxVisitor()

var milk =  Necessity(item: 3.47)
var vodka =  Liquor(item: 11.99)
var cigars =  Tobacco(item: 19.99)

let k1 = "\(milk.accept(taxCalc))"
displayStr = displayStr + k1 + "\n"
let k2 = "\(vodka.accept(taxCalc))"
displayStr = displayStr + k2 + "\n"
let k3 = "\(cigars.accept(taxCalc))"
displayStr = displayStr + k3 + "\n"

displayStr = displayStr + "TAX HOLIDAY PRICES\n"

displayStr


