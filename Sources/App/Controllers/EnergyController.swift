//
//  File.swift
//  
//
//  Created by 岳坤 on 2021/4/29.
//

import Fluent
import Vapor

struct EnergyError: Error {
    
}

struct EnergysRequest: Content {
    let userUuid: UUID
}


struct EnergysResponse: Content {
    let energy: Int
    let money: Int
    let message: String
}

struct EnergyController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let todos = routes.grouped("energys")
        todos.get(use: index)
        todos.post(use: create)
    }

    func index(req: Request) throws -> EventLoopFuture<EnergysResponse> {
        let requset = try req.query.decode(EnergysRequest.self)
        return try UserController().query(req: req, uuid: requset.userUuid)
            .map { (user) -> EnergysResponse in
                return EnergysResponse(
                    energy: user.energy,
                    money: user.money,
                    message: "观看创意广告可获取能量，每周日会把能量转换为现金。"
                )
            }
    }

    func create(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        let request = try req.content.decode(EnergyRecordModel.self)
        return req.db.transaction { (db) -> EventLoopFuture<HTTPStatus> in
            UserModel.query(on: db)
                .filter(\.$uuid == request.userUuid)
                .first()
                .flatMap { (value) -> EventLoopFuture<Void> in
                    if let user = value {
                        user.energy += request.number
                        return user.save(on: db)
                    } else {
                        return req.eventLoop.makeFailedFuture(EnergyError())
                    }
                }
                .flatMap { () -> EventLoopFuture<Void> in
                    return request.save(on: db)
                }
                .map { (_)  in
                    return HTTPStatus.ok
                }
        }
    }
}

