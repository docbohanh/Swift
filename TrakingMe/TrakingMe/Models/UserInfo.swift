
//
//  UserInfo.swift
//  TrakingMe
//
//  Created by Thành Lã on 1/6/17.
//  Copyright © 2017 Bình Anh Electonics. All rights reserved.
//

import Foundation

public func == (l: UserInfo, r: UserInfo) -> Bool {
    return l.userID == r.userID
}

public struct UserInfo: CustomStringConvertible {
    public let username: String
    public let password: String
    public let companyID: Int
    public let companyType: Int
    public let name: String
    public let permission: [Int]
    public let userID: String
    public let userType: Int
    public let XNCode: Int
    
    init(username: String, password: String, companyID: Int, companyType: Int, name: String, permission: [Int], userID: String, userType: Int, XNCode: Int) {
        self.username    = username
        self.password    = password
        self.companyID   = companyID
        self.companyType = companyType
        self.name        = name
        self.permission  = permission
        self.userID      = userID
        self.userType    = userType
        self.XNCode      = XNCode
    }
    
    public var description: String {
        return "Login Response: " +
            "Company: " + "\(companyID)" + " - " + "\(companyType)" + " - " + "\(XNCode)" +
            "\nUser: " + userID + " - " + name + " - " + "\(permission)"
        
    }
}
