//: Playground - noun: a place where people can play
import Foundation



let a="a23"
let b="b43"
let c="a24"
let d = a.compare(b, options: NSStringCompareOptions.LiteralSearch, range: nil, locale: nil) == NSComparisonResult.OrderedAscending
let e = b.compare(a, options: NSStringCompareOptions.LiteralSearch, range: nil, locale: nil) == NSComparisonResult.OrderedAscending
let k = 2

