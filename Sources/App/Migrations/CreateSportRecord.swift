//
//  CreateSportRecord.swift
//  
//
//  Created by 岳坤 on 2021/4/29.
//

import Fluent

struct CreateSportRecord: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("sport_records")
            .id()
            .field("user_uuid", .uuid, .required)
            .field("sport_type", .string, .required)
            .field("start_date", .string, .required)
            .field("duration", .int, .required)
            .field("distance", .double, .required)
            .field("kcal", .double, .required)
            .field("locations", .sql(.text), .required)
            .field("created_at", .datetime, .required)
            .field("updated_at", .datetime, .required)
            .field("deleted_at", .datetime)
            .create()
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("todos").delete()
    }
}
