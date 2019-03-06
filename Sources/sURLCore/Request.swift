//
//  Request.swift
//  sURL
//
//  Created by Emrah Usar on 3/5/19.
//

import Foundation

public class Request{
    typealias Parameters = [String : Any]
    
    class func get(url:String, params:Parameters?, completionHandler: @escaping (_ data: Data?, _ response: URLResponse?)->() ) throws{
        let semaphore = DispatchSemaphore(value: 0)
        let defaultSession = URLSession(configuration: URLSessionConfiguration.default)
        var dataTask: URLSessionDataTask?
        
        dataTask?.cancel()
        
        if url.isValidURL == false {
            throw sURL.Error.invalidURL
        }
        
        guard let url = URL(string: url) else {
            throw sURL.Error.invalidURL
        }
        
        dataTask = defaultSession.dataTask(with: url, completionHandler: { (data, response, error) in
            defer{ dataTask = nil }
            
            if error != nil {
                Console.log("Error: \(error!)", to: .error)
            }
            
            completionHandler(data, response)
            semaphore.signal()
        })
        dataTask?.resume()
        semaphore.wait()
    }
    
    public class func post(url:String, data:String, completionHandler:@escaping(_ data:Data?, _ response:URLResponse?)->()) throws{
        if url.isValidURL == false {
            throw sURL.Error.invalidURL
        }
        
        guard let url = URL(string: url) else {
            throw sURL.Error.invalidURL
        }
        
        let semaphore = DispatchSemaphore(value: 0)
        let session = URLSession.shared
        
        
        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
        let postEncoded = data.data(using: String.Encoding.ascii, allowLossyConversion: true)
        let postLength = String(format: "%d", postEncoded!.count)
        request.httpMethod = "POST"        
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("sURL \(VERSION) (\(BUILD))", forHTTPHeaderField: "User-Agent")
        request.setValue(postLength, forHTTPHeaderField: "Content-Length")
        request.httpBody = postEncoded
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            completionHandler(data, response)
            semaphore.signal()
        }
        dataTask.resume()
        semaphore.wait()
        
        
    }

    public class func put(){
        
    }
    
    public class func patch(){
        
    }
    
    public class func delete(){
        
    }
}
