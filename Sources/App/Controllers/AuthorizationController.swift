//
//  AuthorizationController.swift
//  
//
//  Created by 岳坤 on 2021/4/29.
//

import Fluent
import Vapor


struct AuthorizationError: Error {
    
}

struct AuthorizationController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let todos = routes.grouped("authorizations")
        todos.post("register", use: regiseter)
        todos.post("login", use: login)
    }
    
    func regiseter(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        let authorization = try req.content.decode(AuthorizationModel.self)
        return authorization.save(on: req.db)
            .flatMap({ () -> EventLoopFuture<HTTPStatus> in
                do {
                    return try UserController().create(req: req, uuid: authorization.id!)
                } catch {
                    return req.eventLoop.makeFailedFuture(error)
                }
            })
    }
    
    func login(req: Request) throws -> EventLoopFuture<UserModel> {
        let authorization = try req.content.decode(AuthorizationModel.self)
        return AuthorizationModel.query(on: req.db)
            .filter(\.$phone == authorization.phone)
            .filter(\.$password == authorization.password)
            .first()
            .flatMap({ (value) -> EventLoopFuture<UserModel> in
                if let result = value {
                    do {
                        return try UserController().query(req: req, uuid: result.id!)
                    } catch {
                        return req.eventLoop.makeFailedFuture(error)
                    }
                } else {
                    return req.eventLoop.makeFailedFuture(AuthorizationError())
                }
            })
    }
    
    func index(req: Request) throws -> EventLoopFuture<[Todo]> {
        return Todo.query(on: req.db).all()
    }

    func create(req: Request) throws -> EventLoopFuture<Todo> {
        let todo = try req.content.decode(Todo.self)
        return todo.save(on: req.db).map { todo }
    }

    func delete(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        return Todo.find(req.parameters.get("todoID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { $0.delete(on: req.db) }
            .transform(to: .ok)
    }
}

