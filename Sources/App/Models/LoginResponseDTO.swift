//
//  File.swift
//  
//
//  Created by Jayanth Ambaldhage on 30/11/23.
//

import Foundation
import Vapor

struct LoginResponseDTO: Content {
    let error: Bool
    var reason: String? = nil
    var token: String? = nil
    var userId: UUID? = nil
    
}
