//
//  File.swift
//  
//
//  Created by 岳坤 on 2021/4/29.
//

import Fluent

struct CreateUser: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("users")
            .id()
            .field("uuid", .uuid, .required)
            .field("energy", .int, .required)
            .field("money", .int, .required)
            .field("weight", .string)
            .field("created_at", .datetime, .required)
            .field("updated_at", .datetime, .required)
            .field("deleted_at", .datetime)
            .create()
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("todos").delete()
    }
}

