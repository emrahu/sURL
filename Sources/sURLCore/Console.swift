//
//  Console.swift
//  sURL
//
//  Created by Emrah Usar on 3/5/19.
//

import Foundation
public class Console{
    
    enum OutputType {
        case `default`
        case warning
        case error
    }
    
    class func log(_ message:String, to:OutputType = .default){
        switch to {
        case .default:
            print("\u{001B}[;m\(message)")
        case .error:
            fputs("\u{001B}[0;31m\(message)\n\n", stderr)
            print("\u{001B}[;m")
        default:
            print(message)
        }
    }
}
