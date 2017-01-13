//
//  String+Ex.swift
//  OneTaxi
//
//  Created by Hoan Pham on 8/8/16.
//  Copyright © 2016 Hoan Pham. All rights reserved.
//

import Foundation

extension String {
    /**
     Đổi "đ" -> "d"
     */
    
    public func replace(string target: String, with string: String) -> String {
        return self.lowercased().replacingOccurrences(of: target, with: string)
    }
    
    public func replaceTheD() -> String {
        return self.replace(string: "đ", with: "d")
    }
    
}

public protocol URLStringConvertible {
    /**
     A URL that conforms to RFC 2396.
     
     Methods accepting a `URLStringConvertible` type parameter parse it according to RFCs 1738 and 1808.
     
     See https://tools.ietf.org/html/rfc2396
     See https://tools.ietf.org/html/rfc1738
     See https://tools.ietf.org/html/rfc1808
     */
    var URLString: String { get }
}

extension String: URLStringConvertible {
    public var URLString: String {
        return self
    }
}

extension URL: URLStringConvertible {
    public var URLString: String {
        return absoluteString
    }
}

extension URLComponents: URLStringConvertible {
    public var URLString: String {
        return url!.URLString
    }
}

extension URLRequest: URLStringConvertible {
    public var URLString: String {
        return url!.URLString
    }
}
