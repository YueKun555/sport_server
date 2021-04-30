//
//  File.swift
//  
//
//  Created by 岳坤 on 2021/4/29.
//

import Fluent
import Vapor

final class AuthorizationModel: Model, Content {
    static let schema = "authorizations"
    
    @ID(key: .id)
    var id: UUID?

    @Field(key: "phone")
    var phone: String
    
    @Field(key: "password")
    var password: String
    
    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?

    @Timestamp(key: "updated_at", on: .update)
    var updatedAt: Date?
    
    @Timestamp(key: "deleted_at", on: .delete)
    var deletedAt: Date?
    
    init() { }

    init(id: UUID? = nil, phone: String, password: String) {
        self.id = id
        self.phone = phone
        self.password = password
    }
}


