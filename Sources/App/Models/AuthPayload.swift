//
//  File.swift
//  
//
//  Created by Jayanth Ambaldhage on 30/11/23.
//

import Foundation
import JWT

struct AuthPayload: JWTPayload {
    
    typealias Payload = AuthPayload
    
    enum CodingKeys: String, CodingKey {
        case subject = "sub"
        case expiration = "exp"
        case userId = "uid"
    }
    var subject: SubjectClaim
    var expiration: ExpirationClaim
    var userId: UUID
    
    func verify(using signer: JWTKit.JWTSigner) throws {
        try self.expiration.verifyNotExpired()
    }
    
    
}
