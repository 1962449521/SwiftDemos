//: Playground - noun: a place where people can play

import Foundation

protocol Writer {
    func write(s:String)  -> String
}

class SystemOutPrinter {
    func printToSystemOut(s:String) -> String{
        return s
    }
}

class SystemOutNewPrinter {
    func newPrintToSystemOut(s:String) -> String {
        return s
    }
}

class PrinterAdapter: Writer {
    private let target : SystemOutPrinter
    func write(s:String) -> String{
        return self.target.printToSystemOut(s)
    }
    init(_ target:SystemOutPrinter) {
        self.target = target
    }
}

class NewPrinterAdapter: Writer {
    private let target : SystemOutNewPrinter
    func write(s:String)  -> String{
        return self.target.newPrintToSystemOut(s)
    }
    init(_ target:SystemOutNewPrinter) {
        self.target = target
    }
}



print("Creating the Adaptees...")
let adaptee:SystemOutPrinter = SystemOutPrinter()
let newAdaptee:SystemOutNewPrinter = SystemOutNewPrinter()

print("Issuing the request to the Adaptees...")
adaptee.printToSystemOut("Test successful.")
newAdaptee.newPrintToSystemOut("Test successful.")


print("Now generate the same output, but using Adapters...");
print("Creating the Adapters...");
let myTarget =  PrinterAdapter(adaptee)
let myNewTarget =  NewPrinterAdapter(newAdaptee)

print("Each pair of Adapter and Adaptee are the same object? ")
print( "\(myTarget === adaptee)")
print("\(myNewTarget === newAdaptee)")

print("Issuing the request to the Adapters...")
myTarget.write("Test successful.")
myNewTarget.write("Test successful.")

