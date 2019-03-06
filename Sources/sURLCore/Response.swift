//
//  Response.swift
//  Alamofire
//
//  Created by Emrah Usar on 3/5/19.
//

import Foundation

public class Response {
    
    public var response:URLResponse?
    
    init(response:URLResponse?) {
        self.response = response
    }
    
    public func debugPrint() -> String {
        
        var debugOutput = ""
        guard let response = self.response as? HTTPURLResponse else { return "" }
        debugOutput = """
        Status Code: \(response.statusCode)\n
        """
        for (key, value) in response.allHeaderFields {
            debugOutput = debugOutput + ("\(key): \(value)\n")
        }
        return debugOutput
    }
}
