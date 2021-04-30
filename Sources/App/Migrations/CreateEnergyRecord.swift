//
//  File.swift
//  
//
//  Created by 岳坤 on 2021/4/29.
//

import Fluent

struct CreateEnergyRecord: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("energy_records")
            .id()
            .field("user_uuid", .uuid, .required)
            .field("number", .int, .required)
            .field("created_at", .datetime, .required)
            .field("updated_at", .datetime, .required)
            .field("deleted_at", .datetime)
            .create()
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("energy_records").delete()
    }
}

