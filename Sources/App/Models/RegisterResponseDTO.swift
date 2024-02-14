//
//  File.swift
//  
//
//  Created by Jayanth Ambaldhage on 29/11/23.
//

import Foundation
import Vapor

struct RegisterResponseDTO: Content {
    
    let error: Bool
    var resson: String? = nil
}
