//
//  File.swift
//  
//
//  Created by Jayanth Ambaldhage on 28/11/23.
//

import Foundation
import Fluent

struct CreateUsersTableMigrations: AsyncMigration {
    //creating tables in database
    func prepare(on database: Database) async throws {
        try await database.schema("users")
            .id()
            .field("username", .string, .required).unique(on: "username")
            .field("password", .string, .required)
            .create()
    }
    
    //undo created table
    func revert(on database: Database) async throws {
        try await database.schema("users")
            .delete()
    }
}
