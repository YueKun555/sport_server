//
//  File.swift
//  
//
//  Created by 岳坤 on 2021/4/29.
//

import Fluent
import Vapor

struct MoneyExtractError: Error {
    
}

struct MoneyExtractGetRequest: Content {
    let userUuid: UUID
}

struct MoneyExtractRequest: Content {
    let userUuid: UUID
    let cardUser: String
    let cardNumber: String
}


struct MoneyExtractController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let todos = routes.grouped("moneys")
        todos.post("extract", use: create)
        todos.get("extract", use: index)
    }

    func index(req: Request) throws -> EventLoopFuture<[MoneyExtractRecordModel]> {
        let model = try req.query.decode(MoneyExtractGetRequest.self)
        return MoneyExtractRecordModel
            .query(on: req.db)
            .filter(\.$userUuid == model.userUuid)
            .sort(\.$createdAt, .descending)
            .all()
    }

    func create(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        let model = try req.content.decode(MoneyExtractRequest.self)
        return req.db.transaction { (db) -> EventLoopFuture<HTTPStatus> in
            return UserModel.query(on: db)
                .filter(\.$uuid == model.userUuid)
                .first()
                .flatMap { (value) -> EventLoopFuture<Int> in
                    if let user = value {
                        let money = user.money
                        user.money = 0
                        return user.save(on: db)
                            .map { () in
                                return money
                            }
                    }
                    return req.eventLoop.makeFailedFuture(MoneyExtractError())
                }
                .flatMap { (value) -> EventLoopFuture<HTTPStatus> in
                    return MoneyExtractRecordModel(
                        userUuid: model.userUuid,
                        number: value,
                        cardUser: model.cardUser,
                        cardNumber: model.cardNumber
                    )
                    .save(on: db)
                    .map { () in
                        return HTTPStatus.ok
                    }
                }
        }
    }

    func delete(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        return Todo.find(req.parameters.get("todoID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { $0.delete(on: req.db) }
            .transform(to: .ok)
    }
}

