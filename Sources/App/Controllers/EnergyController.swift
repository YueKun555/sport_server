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

struct MoneyTransformRequest: Content {
    let money: Int
}

struct EnergyController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let todos = routes.grouped("energys")
        todos.get(use: index)
        todos.post(use: create)
        todos.post("transform", use: transform)
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
    
    func transform(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        let request = try req.content.decode(MoneyTransformRequest.self)
        return req.db.transaction { (db) -> EventLoopFuture<HTTPStatus> in
            UserModel.query(on: db)
                .sum(\.$energy)
                .map({ (total) -> (Double) in
                    if let value = total {
                        return Double(request.money) * 100.0 / Double(value)
                    }
                    return 0
                })
                .flatMap { (value) -> EventLoopFuture<HTTPStatus> in
                    return UserModel.query(on: db)
                        .all()
                        .flatMapEach(on: req.eventLoop) { (model) -> EventLoopFuture<HTTPStatus> in
                            if value > 0 {
                                let energy = model.energy
                                let money = Int(Double(energy) * value / 100.0)
                                if money > 0 {
                                    model.energy = 0
                                    model.money += money
                                }
                            }
                            return model.save(on: db)
                                .transform(to: HTTPStatus.ok)
                        }
                        .transform(to: HTTPStatus.ok)
                }
        }
    }
    
}

