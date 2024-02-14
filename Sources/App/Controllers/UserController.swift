//
//  File.swift
//  
//
//  Created by Jayanth Ambaldhage on 29/11/23.
//

import Foundation
import Fluent
import Vapor

class UserController: RouteCollection {
    func boot(routes: Vapor.RoutesBuilder) throws {
        let api = routes.grouped("api")
        // api/register
        api.post("register", use: register)
        // api/login
        api.post("login", use: login)
    }
    
    func login(req: Request) async throws -> LoginResponseDTO {
        let user = try req.content.decode(User.self)
        
        // check if user exists in database
        guard let existingUser = try await User.query(on: req.db)
            .filter(\.$username == user.username)
            .first() else {
            return LoginResponseDTO(error: true, reason: "Username not found.")
            }
        //validate password
        let result = try await req.password.async.verify(user.password, created: existingUser.password)
        
        if !result {
            return LoginResponseDTO(error: true, reason: "Password is incorrect.")
        }
        
        //generate the token and return it to the user
        let authPayload = try AuthPayload(subject: .init(value: "Grocery App"), expiration: .init(value: .distantFuture) , userId: existingUser.requireID())
        return try LoginResponseDTO(error: false, token: req.jwt.sign(authPayload), userId: existingUser.requireID())
        
      
    }
    
    func register(req: Request) async throws -> RegisterResponseDTO {
        
        try User.validate(content: req)
        let user = try req.content.decode(User.self)
        
        if let _ = try await User.query(on: req.db)
            .filter(\.$username == user.username)
            .first(){
            throw Abort(.conflict, reason: "Username is already taken.")
        }
        
        //if username is unique then hash the password
        user.password = try req.password.hash(user.password)
        try await user.save(on: req.db)
        return RegisterResponseDTO(error: false)
        
    }
    
    
}
