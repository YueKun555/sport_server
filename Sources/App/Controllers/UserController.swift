//
//  File.swift
//  
//
//  Created by 岳坤 on 2021/4/29.
//

import Fluent
import Vapor

struct UserEmpty: Error {
    
}

struct UserInfoUpdateRequest: Content {
    let userUuid: UUID
    let weight: String
}

struct UserController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let todos = routes.grouped("users")
        todos.post("info", use: update)
    }
    
    func create(req: Request, uuid: UUID) throws -> EventLoopFuture<HTTPStatus> {
        let user = UserModel(uuid: uuid)
        return user.save(on: req.db)
            .map({ (_)  in
                return HTTPStatus.ok
            })
    }
    
    func query(req: Request, uuid: UUID) throws -> EventLoopFuture<UserModel> {
        return UserModel.query(on: req.db)
            .filter(\.$uuid == uuid)
            .first()
            .flatMap { (value) -> EventLoopFuture<UserModel> in
                if let result = value {
                    return req.eventLoop.makeSucceededFuture(result)
                } else {
                    return req.eventLoop.makeFailedFuture(UserEmpty())
                }
            }
    }
    
    func update(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        let request = try req.content.decode(UserInfoUpdateRequest.self)
        return UserModel.query(on: req.db)
            .filter(\.$uuid == request.userUuid)
            .first()
            .flatMap { (value) -> EventLoopFuture<HTTPStatus> in
                if let result = value {
                    result.weight = request.weight
                    return result.save(on: req.db)
                        .transform(to: HTTPStatus.ok)
                }
                return req.eventLoop.makeFailedFuture(UserEmpty())
            }
    }
    
}
