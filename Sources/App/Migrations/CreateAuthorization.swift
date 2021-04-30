//
//  CreateAuthorization.swift
//  
//
//  Created by 岳坤 on 2021/4/29.
//

import Fluent

struct CreateAuthorization: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("authorizations")
            .id()
            .field("phone", .string, .required)
            .field("password", .string, .required)
            .field("created_at", .datetime, .required)
            .field("updated_at", .datetime, .required)
            .field("deleted_at", .datetime)
            .create()
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("authorizations").delete()
    }
}

