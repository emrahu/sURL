import Foundation

let VERSION = "1.0.0"
let BUILD = "1"

public final class sURL{
    private let arguments:[String]
    
    public init(arguments:[String] = CommandLine.arguments) {
        self.arguments = arguments
    }
    
    public func run() throws{
        guard arguments.count > 1 else {
            consoleLog("surl: try 'surl --help' for more information")
            throw Error.missingCommand
            
        }
        let option = arguments[1]
        
        
        switch option {
        case "-h", "--help":
            helpMenu()
        case "-v", "--version":
            version()
        case "-I":
            guard arguments.count > 2 else {
                throw Error.noURLProvided
            }
            let url = arguments[2]
            do{
                try Request.get(url: url, params: nil) { (data, response) in
                    Console.log("Data received: \(data!)")
                    let response = Response(response:response!)
                    Console.log(response.debugPrint())
                }
            } catch Error.invalidURL {
                consoleLog("Invalid URL", to: .error)
            } catch(let error){
                Console.log("\(error.localizedDescription)", to: .error)
            }

        case "-d":
            guard arguments.count > 2 else {
                throw Error.noURLProvided
            }
            let data = arguments[2]
            let url = arguments[3]
            do {
                try Request.post(url: url, data: data, completionHandler: { (data, response) in
                    Console.log("Data received: \(data!)")
                    let data = String(data: data!, encoding: String.Encoding.utf8)!
                    Console.log(data)
                    let response = Response(response:response!)
                    Console.log(response.debugPrint())
                })
            } catch {
                Console.log("\(error)")
            }

        default:
            throw Error.unknownOption
        }
    }
    
    
    
    private func helpMenu(){
        
        consoleLog("sURL")
        consoleLog("Usage: sURL [options...] <url>")
        consoleLog("")
        consoleLog("Options:")
        consoleLog("\t-h, --help \t Get help for sURL")
        consoleLog("\t-v, --version \t sURL version")
        consoleLog("\t-I <url> \t Get request")
        consoleLog("\t-d <data> <url> \t Post request. The post data must be url encoded.")
        consoleLog("")
    }
    
    private func version(){
        consoleLog("sURL \(VERSION) (b\(BUILD))")
    }
}

public extension sURL{
    enum Error:Swift.Error {
        case missingCommand
        case unknownOption
        case unknownError
        case failedToCreateFile
        case invalidURL
        case noURLProvided
    }
    
    enum OutputType {
        case `default`
        case warning
        case error
    }
    
    public func consoleLog(_ message:String, to:OutputType = .default){
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

extension String {
    var isValidURL: Bool {
        let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        if let match = detector.firstMatch(in: self, options: [], range: NSRange(location: 0, length: self.endIndex.encodedOffset)){
            return match.range.length == self.endIndex.encodedOffset
        } else {
            return false
        }
    }
}
