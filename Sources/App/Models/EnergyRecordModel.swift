//
//  File.swift
//  
//
//  Created by 岳坤 on 2021/4/29.
//

import Fluent
import Vapor

final class EnergyRecordModel: Model, Content {
    static let schema = "energy_records"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "user_uuid")
    var userUuid: UUID
    
    @Field(key: "number")
    var number: Int
    
    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?

    @Timestamp(key: "updated_at", on: .update)
    var updatedAt: Date?
    
    @Timestamp(key: "deleted_at", on: .delete)
    var deletedAt: Date?
    
    init() { }

    init(
        id: UUID? = nil,
        userUuid: UUID,
        number: Int
    ) {
        self.id = id
        self.userUuid = userUuid
        self.number = number
    }
}
