//
//  UserModel.swift
//  
//
//  Created by 岳坤 on 2021/4/29.
//

import Fluent
import Vapor

final class UserModel: Model, Content {
    static let schema = "users"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "uuid")
    var uuid: UUID
    
    @Field(key: "energy")
    var energy: Int
    
    @Field(key: "money")
    var money: Int
    
    @Field(key: "weight")
    var weight: String?
    
    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?

    @Timestamp(key: "updated_at", on: .update)
    var updatedAt: Date?
    
    @Timestamp(key: "deleted_at", on: .delete)
    var deletedAt: Date?
    
    var isShowAd: Bool?
    
    init() { }

    init(
        id: UUID? = nil,
        uuid: UUID,
        energy: Int = 0,
        money: Int = 0,
        isShowAd: Bool = false
    ) {
        self.id = id
        self.uuid = uuid
        self.energy = energy
        self.money = money
        self.isShowAd = isShowAd
    }
}
