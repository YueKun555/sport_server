//
//  SportController.swift
//  
//
//  Created by 岳坤 on 2021/4/29.
//

import Fluent
import Vapor


struct SportRecordRequest: Content {
    let userUuid: UUID
}

struct SportController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let todos = routes.grouped("sports")
        todos.on(.POST, body: .collect(maxSize: "10mb"), use: create)
        todos.get(use: record)
    }
    
    func create(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        let request = try req.content.decode(SportRecordModel.self)
        return request.save(on: req.db)
            .map { () -> (HTTPStatus) in
                return HTTPStatus.ok
            }
    }
    
    func record(req: Request) throws -> EventLoopFuture<[SportRecordModel]> {
        let request = try req.query.decode(SportRecordRequest.self)
        return SportRecordModel.query(on: req.db)
            .filter(\.$userUuid == request.userUuid)
            .sort(\.$createdAt, .descending)
            .all()
    }
    
}

