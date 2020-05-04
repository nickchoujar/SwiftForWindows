//
//  NetworkServices.swift
//  Griddy
//
//  Created by Bilal on 9/22/16.
//  Copyright © 2016 Citrusbits. All rights reserved.
//

import UIKit
import Alamofire
import AFNetworking


class NetworkServices: NSObject {
    
    static let sharedInstance = NetworkServices()

    fileprivate override init() {
        
    }
    
    //post web service method
    func postWebServiceWith(_ methodName:String, params:[String : AnyObject], headers:[String : String],completion:@escaping (_ success: Bool, _ responseDict:[String: AnyObject])->()) {
        
        let url:String = paths.Base_Url + methodName
        
        print(url)
        Alamofire.request(url, method: .post, parameters: params, encoding: URLEncoding.default, headers: [:]).responseJSON { response in
            
            
            guard response.result.isSuccess else {
                
                print("Error while fetching tags: \(String(describing: response.result.error))")
               
                if let descriptionMessage = response.result.error?.localizedDescription {
                
                    print(descriptionMessage)
                    
                    completion(false, ["message":descriptionMessage as AnyObject])
                    
                    return
                }
                else {
                
                    completion(false, ["message":"Unknown error from server" as AnyObject])
                    
                    return
                }
            }
            
            guard let responseJSON = response.result.value as? [String: AnyObject] else {
                print("Invalid tag information received from service")
                
                if let descriptionMessage = response.result.error?.localizedDescription {
                    
                    print(descriptionMessage)
                    
                    completion(false, ["message":descriptionMessage as AnyObject])
                    
                    return
                }
                else {
                    
                    completion(false, ["message":"Unknown error from server" as AnyObject])
                    
                    return
                }
            }
            
            print(responseJSON)
            completion(responseJSON["status"]! as! Bool, responseJSON)
        }
    }
    
    //post web service method
    func postContactsWebServiceWith(_ methodName:String, params:[String : AnyObject], headers:[String : String],completion:@escaping (_ success: Bool, _ responseDict:[String: AnyObject])->()) {
        
        let strUrl:String = paths.Base_Url + methodName
        let url =  NSURL(string:strUrl)
        print(url!)
        
        var request = URLRequest(url: url as! URL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let data = try! JSONSerialization.data(withJSONObject: params, options: JSONSerialization.WritingOptions.prettyPrinted)
        
        let json = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
        if let json = json {
            print(json)
        }
        request.httpBody = json!.data(using: String.Encoding.utf8.rawValue);
        
        
        let manager =  AFHTTPSessionManager()
        let url1:String = paths.Base_Url + methodName
        manager.responseSerializer = AFHTTPResponseSerializer()
        manager.requestSerializer = AFHTTPRequestSerializer()
        manager.post(url1, parameters: params, constructingBodyWith: { (formData) in
            formData.appendPart(withForm: json!.data(using: String.Encoding.utf8.rawValue)!, name: "contact_list")
        }, progress: { (progress) in
            print("Upload Progress: \(progress.fractionCompleted)")
        }, success: { (operation, responseObject) in
            completion(true, [:])
     //       print("Success: \(progress.fractionCompleted)")
            
        }) { (operation, error) in
            completion(false, [:])
            print(error)
          //  print(responseObject)
   //         print("other: \(progress.fractionCompleted)")
        }

    }

    
    //get web service method
    func getWebServiceWith(_ methodName:String, params:[String : AnyObject], completion:@escaping (_ success: Bool, _ responseDict:NSDictionary)->()) {
        let url:String = methodName
//        print(url)
        
        Alamofire.request(url, method: .get, parameters: params, encoding: URLEncoding.default, headers: [:]).responseJSON { response in
            guard response.result.isSuccess else {
                print("Error while fetching tags: \(String(describing: response.result.error))")
                
                if let descriptionMessage = response.result.error?.localizedDescription {
                    
                    print(descriptionMessage)
                    
                    completion(false, ["message":descriptionMessage as AnyObject])
                    
                    return
                }
                else {
                    
                    completion(false, ["message":"Unknown error from server" as AnyObject])
                    
                    return
                }
            }
            
            guard let responseJSON = response.result.value as? [String: AnyObject] else {
                print("Invalid tag information received from service")
                
                if let descriptionMessage = response.result.error?.localizedDescription {
                    
                    print(descriptionMessage)
                    
                    completion(false, ["message":descriptionMessage as AnyObject])
                    
                    return
                }
                else {
                    
                    completion(false, ["message":"Unknown error from server" as AnyObject])
                    
                    return
                }
            }
            
            print(responseJSON)
            completion(true, responseJSON as NSDictionary)
            
        }
    }
    
    func uploadImageWithparams(_ methodName:String, img:UIImage ,params:[String : AnyObject], completion:@escaping (_ success: Bool, _ responseDict:NSDictionary)->()) {
        
        let url:String = paths.Base_Url + methodName
        
        let parameters =  params
        
        Alamofire.upload(multipartFormData: { multipartFormData in
            for (key, value) in parameters {
                if value is NSArray {
                    let data = try! JSONSerialization.data(withJSONObject: value, options: JSONSerialization.WritingOptions.prettyPrinted)
                    
                    multipartFormData.append(data, withName: key)
                }
                else {                    
                    multipartFormData.append(value.data(using: String.Encoding.utf8.rawValue)!, withName: key)
                }
            }
            
            if let imageData = UIImageJPEGRepresentation(img, 0.5) {
                multipartFormData.append(imageData, withName: "picture",fileName: "file.jpg", mimeType: "image/jpg")
            }
            
        },
                         to:url)
        { (result) in
            switch result {
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { (progress) in
                    print("Upload Progress: \(progress.fractionCompleted)")
                })
                
                upload.responseJSON { response in
//                    print(response.result.value!)
                    completion(true, ["data":response.result.value!])
                }
                
            case .failure(let encodingError):
                print(encodingError)
                completion(false, [:])
            }
        }
    }
    
    func uploadImageWithparameters(_ methodName:String, img:UIImage ,params:[String : AnyObject], completion:@escaping (_ success: Bool, _ responseDict:NSDictionary)->()) {
        
        
        let imageData = UIImageJPEGRepresentation(img, 0.5)
//         let url:String = paths.Base_Url + methodName
//        let manager =  AFHTTPSessionManager()
        
        
        let strUrl:String = paths.Base_Url + methodName
        let url =  NSURL(string:strUrl)
        print(url!)
        
        var request = URLRequest(url: url as! URL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let data = try! JSONSerialization.data(withJSONObject: params, options: JSONSerialization.WritingOptions.prettyPrinted)
        
        let json = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
        if let json = json {
            print(json)
        }
        request.httpBody = json!.data(using: String.Encoding.utf8.rawValue);
        
        
        let manager =  AFHTTPSessionManager()
        let url1:String = paths.Base_Url + methodName
        manager.responseSerializer = AFHTTPResponseSerializer()
        manager.requestSerializer = AFHTTPRequestSerializer()
        
        
        var parameters = params
        
//        parameters["picture"] = "" as AnyObject
        
//       manager.responseSerializer = AFHTTPResponseSerializer()
//        manager.requestSerializer = AFHTTPRequestSerializer()
        manager.post(url1, parameters: nil, constructingBodyWith: { (formData) in
            formData.appendPart(withForm: imageData!, name: "picture")
            
//            formData.append(imageData, withName: "picture",fileName: "file.jpg", mimeType: "image/jpg")
            
            for (key, value) in params {
                
                if value is NSArray {
                
                    
                    let data = try! JSONSerialization.data(withJSONObject: params, options: JSONSerialization.WritingOptions.prettyPrinted)
                    
                    
                    formData.appendPart(withForm: data, name: key)
                }
                else {
                
                    formData.appendPart(withForm: value.data(using: String.Encoding.utf8.rawValue)!, name: key)
                }
                
            }
            
        }, progress: { (progress) in
            print("Upload Progress: \(progress.fractionCompleted)")
        }, success: { (operation, responseObject) in
            
            print(responseObject!)
            completion(true, [:])
        }) { (operation, error) in
            
            print("Operation: \(operation), \n Error: \(error)")
            
            completion(false, [:])
        }
        
        
    }
    
    
    func uploadImageWithP(_ methodName:String, img:UIImage ,params:[String : AnyObject], completion:@escaping (_ success: Bool, _ responseDict:NSDictionary)->()) {
    
        let url:String = paths.Base_Url + methodName
        
        print(url)
        Alamofire.request(url, method: .post, parameters: params, encoding: URLEncoding.default, headers: ["Content-Type":"application/json"]).responseString { response in
            guard response.result.isSuccess else {
                print("Error while fetching tags: \(response.result.error)")
                print(response)
                
                if let descriptionMessage = response.result.error?.localizedDescription {
                    
                    print(descriptionMessage)
                    
                    completion(false, ["message":descriptionMessage as AnyObject])
                    
                    return
                }
                else {
                    
                    completion(false, ["message":"Unknown error from server" as AnyObject])
                    
                    return
                }
            }
            
            
            print(response)
            print("Error while fetching tags: \(response.result.error)")
            
            guard let responseJSON = response.result.value as? [String: AnyObject] else {
                
                print("Invalid tag information received from service")
                
                if let descriptionMessage = response.result.error?.localizedDescription {
                    
                    print(descriptionMessage)
                    
                    completion(false, ["message":descriptionMessage as AnyObject])
                    
                    return
                }
                else {
                    
                    completion(false, ["message":"Unknown error from server" as AnyObject])
                    
                    return
                }
            }
            print(responseJSON)
            completion(responseJSON["status"]! as! Bool, responseJSON as NSDictionary)
        }

    }
}

