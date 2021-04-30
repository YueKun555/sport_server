//
//  File.swift
//  
//
//  Created by 岳坤 on 2021/4/29.
//

import Fluent
import Vapor

enum Status: String, Codable {
    case ing
    case success
    case failure
}

final class MoneyExtractRecordModel: Model, Content {
    static let schema = "money_extract_records"
    
    @ID(key: .id)
    var id: UUID?

    @Field(key: "user_uuid")
    var userUuid: UUID
    
    @Enum(key: "status")
    var status: Status
    
    @Field(key: "number")
    var number: Int
    
    @Field(key: "card_user")
    var cardUser: String
    
    @Field(key: "card_number")
    var cardNumber: String
    
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
        status: Status = .ing,
        number: Int,
        cardUser: String,
        cardNumber: String
    ) {
        self.id = id
        self.userUuid = userUuid
        self.status = status
        self.number = number
        self.cardUser = cardUser
        self.cardNumber = cardNumber
    }
}

