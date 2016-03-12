//
//  SPUtil.swift
//  Shopping
//
//  Created by 胡 帅 on 15/11/28.
//  Copyright © 2015年 Disney. All rights reserved.
//

import Alamofire
import SwiftyJSON
import BNRCoreDataStack
import Foundation
import CoreData
import CoreLocation


public class SPUtil: NSObject,CLLocationManagerDelegate {
    
    // singleton
    public class var sharedInstance : SPUtil {
        struct Static {
            static let instance : SPUtil = SPUtil()
        }
        return Static.instance
    }
    
    
    var locationManager:CLLocationManager = CLLocationManager()
    var completionHandler:((lati:Double, lgit:Double)->Void)?
    
    static let baseURL = "http://partiklezoo.com/products/"
    
    static func loadStoreInfoCompleted(completionHandler: (
        isSuccess: Bool,
        eror: NSError?)
        -> Void)  {
        let request:Request = Alamofire.request(.GET, self.baseURL)
        request.response { (_, _, data, error) -> Void in
            if (error != nil) {
                completionHandler(isSuccess: false,  eror: error)
            } else {
                self.lazyLoadCoreDataSourceFinish({ (isSuccess) -> Void in
                    if(!isSuccess) {
                        let error = NSError.init(domain: "Database", code: 1001, userInfo: [NSLocalizedDescriptionKey:"database initialize fail"])
                        completionHandler(isSuccess: false,  eror: error)
                    } else {
                        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
                        let workerContext = delegate.myCoreDataStack!.mainQueueContext

                        workerContext.performBlock() {
                            let request = NSFetchRequest(entityName: "ProductMO")
                            do {
                                let deleteObjects = try workerContext.executeFetchRequest(request) as! Array<ProductMO>
                                for mo:NSManagedObject in deleteObjects {
                                    workerContext.deleteObject(mo)
                                }
                            }
                            catch _ {
                                
                            }
                            
                            let entityDescription = NSEntityDescription.entityForName("ProductMO", inManagedObjectContext: workerContext)
                            let json = JSON(data: data!)
                            let resultArr = json.object as! Array<Dictionary<String, AnyObject>>
                            for dict:Dictionary<String, AnyObject> in resultArr {
                                let spProduct = SPProduct.init(fromDic: dict) as SPProduct
                                let managedObject = NSManagedObject.init(entity: entityDescription! , insertIntoManagedObjectContext: workerContext) as! ProductMO
                                spProduct.convert2ManagedObject(managedObject)
                            }

                            workerContext.saveContext({ (saveResult) -> Void in
                                switch saveResult {
                                case .Success:
                                    completionHandler(isSuccess: true, eror: nil)
                                default:
                                    let error = NSError.init(domain: "Database", code: 1002, userInfo: [NSLocalizedDescriptionKey:"productMO store fail"])
                                    completionHandler(isSuccess: false, eror: error)
                                }
                            })
                        }
                    }
                })
            }
        }
    }
    
    static func lazyLoadCoreDataSourceFinish(finishHandler:((isSuccess:Bool)->Void)) {
        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate

        if((delegate.myCoreDataStack) != nil) {
            finishHandler(isSuccess: true)
            return
        }
        CoreDataStack.constructSQLiteStack(withModelName: "SPCModel") { result in
            switch result {
            case .Success(let stack):
                delegate.myCoreDataStack = stack
                finishHandler(isSuccess: true)
            case .Failure(let error):
                print(error)
                finishHandler(isSuccess: false)
            }
        }

    }
    
    static func add2Cart(count:Int, product:SPProduct, completionHandler:((isSuccess:Bool,eror:NSError?)->Void)) {
        let attributeName = NSString(string: "uid")
        let attributeValue = NSString(string: "\(product.uid!)")
        let predicate = NSPredicate(format: "%K=%@", attributeName, attributeValue)
        
        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let workerContext = delegate.myCoreDataStack!.newBackgroundWorkerMOC()
        let request = NSFetchRequest(entityName: "CartMO")
        request.predicate = predicate
        
        var cart:CartMO?
        
        workerContext.performBlockAndWait { () -> Void in
            do {
                let carts = try workerContext.executeFetchRequest(request) as! Array<CartMO>
                   
                if (carts.count > 0) {
                    cart = carts[0] as CartMO
                } else {
                    let entityDescription = NSEntityDescription.entityForName("CartMO", inManagedObjectContext: workerContext)
                    cart =  NSManagedObject.init(entity: entityDescription! , insertIntoManagedObjectContext: workerContext) as? CartMO
                }
                cart!.count = NSNumber(integer: (cart!.count!.integerValue + count))
                if (cart!.count!.intValue > (Int32)(product.stock!)) {
                    cart!.count = NSNumber(int: (Int32)(product.stock!)!)
                }
                cart!.name = product.name
                cart!.image = product.image
                cart!.price = product.price
                cart!.uid = product.uid
            }
            catch _ {
                
            }
            workerContext.saveContext({ (saveResult) -> Void in
                switch saveResult {
                case .Success:
                    completionHandler(isSuccess: true, eror: nil)
                default:
                    let error = NSError.init(domain: "Database", code: 1002, userInfo: [NSLocalizedDescriptionKey:"cartMO store fail"])
                    completionHandler(isSuccess: false, eror: error)
                }
            })
        }
    }
    
    static func submitCart(completionHandler:((isSuccess:Bool, msg:String?)->Void)) {
        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let workerContext = delegate.myCoreDataStack!.mainQueueContext
        
        workerContext.performBlock() {
            let request = NSFetchRequest(entityName: "CartMO")
            do {
                let carts = try workerContext.executeFetchRequest(request) as! Array<CartMO>
                if (carts.count == 0) {
                    completionHandler(isSuccess:false, msg:"no any item in cart" )
                } else {
                    var queryStr:String = ""
                    var sum:Double = 0
                    for cart:CartMO in carts {
                        queryStr += "\(cart.uid!)=\(cart.count!)&"
                        sum += ((Double)(cart.price!)!) * ((Double)(cart.count!.intValue))
                    }
                    queryStr += "total=\(sum)"
                    let request:Request = Alamofire.request(.GET, self.baseURL+"?action=purchase&"+queryStr)
                    request.response { (_, _, data, error) -> Void in
                        if (error != nil) {
                            completionHandler(isSuccess:false, msg:"submit fail, please try again later" )
                        } else {
                            let json = JSON(data: data!)
                            let resultDic = json.object as! Dictionary<String, AnyObject>
                            let result = resultDic["success"] as! String
                            if(!(NSString(string:result).boolValue)) {
                                completionHandler(isSuccess: true, msg: "submit fail")
                            } else {
                                for cart:CartMO in carts {
                                    workerContext.deleteObject(cart)
                                }
                                workerContext.saveContext({ (saveResult) -> Void in
                                    switch saveResult {
                                    case .Success:
                                        completionHandler(isSuccess: true, msg: nil)
                                    default:
                                        completionHandler(isSuccess: true, msg: "cartMO store fail")
                                    }
                                })
                            }
                        }
                    }
                }
            }
            catch _ {
                
            }

        }
    }
    
    static func loadStore(lati:Double, lgit:Double, completionHandler:((result: Array<Dictionary<String, AnyObject>>)->Void)) {
        let strURL = self.baseURL + "?action=locations&coord1=\(lati)&coord2=\(lgit)"
        let request:Request = Alamofire.request(.GET, strURL)
        request.response { (_, _, data, error) -> Void in
            let json = JSON(data: data!)
            let resultArr = json.object as! Array<Dictionary<String, AnyObject>>
            completionHandler(result: resultArr)
        }
    }
    
    public func getGEO(completionHandler:((lati:Double, lgit:Double)->Void)) {
        self.completionHandler = completionHandler
        if (!(CLLocationManager.authorizationStatus() == CLAuthorizationStatus.AuthorizedAlways
            )) {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.locationManager.requestAlwaysAuthorization()
                })
        } else {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.distanceFilter = 1000.0
            locationManager.startUpdatingLocation()
        }
    }
    public func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let latitude = locations[0].coordinate.latitude
        let longitude = locations[0].coordinate.longitude
        locationManager.stopUpdatingLocation()
        self.completionHandler!(lati: latitude, lgit: longitude)
    }
    public func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        self.completionHandler!(lati: 0, lgit: 0)
    }
   }
