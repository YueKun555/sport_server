//
//  SportRecordModel.swift
//  
//
//  Created by 岳坤 on 2021/4/29.
//

import Fluent
import Vapor

enum SportType: String, Codable  {
    case outdoorRunning
    case cycling
    case walk
    case climbing
}

final class SportRecordModel: Model, Content {
    static let schema = "sport_records"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "user_uuid")
    var userUuid: UUID
    
    @Enum(key: "sport_type")
    var sportType: SportType
    
    @Field(key: "start_date")
    var startDate: String
    
    @Field(key: "duration")
    var duration: Int
    
    @Field(key: "distance")
    var distance: Double
    
    @Field(key: "kcal")
    var kcal: Double
    
    @Field(key: "locations")
    var locations: String
    
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
        sportType: SportType,
        startDate: String,
        duration: Int,
        distance: Double,
        kcal: Double,
        locations:String
    ) {
        self.id = id
        self.userUuid = userUuid
        self.sportType = sportType
        self.startDate = startDate
        self.duration = duration
        self.distance = distance
        self.kcal = kcal
        self.locations = locations
    }
}

