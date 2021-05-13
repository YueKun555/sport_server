//
//  HomePageController.swift
//  
//
//  Created by 岳坤 on 2021/4/29.
//

import Fluent
import Vapor


struct HomeRequest: Content {
    let userUuid: UUID
}


struct HomeResponse: Content {
    let distance: Double
    let kcal: Double
    let isShowMoney: Bool
}


struct HomePageController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let todos = routes.grouped("homepage")
        todos.get(use: index)
    }

    func index(req: Request) throws -> EventLoopFuture<HomeResponse> {
        let request = try req.query.decode(HomeRequest.self)
        return SportRecordModel.query(on: req.db)
            .filter(\.$userUuid == request.userUuid)
            .all()
            .map({ (values) -> (HomeResponse) in
                var distance = 0.0
                var kcal = 0.0
                for obj in values {
                    distance += obj.distance
                    kcal += obj.kcal
                }
                return HomeResponse(
                    distance: distance,
                    kcal: kcal,
                    isShowMoney: false
                )
            })
    }
    
}

