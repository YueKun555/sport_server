import Fluent
import Vapor

func routes(_ app: Application) throws {
    app.get { req in
        return "It works!"
    }

    app.get("hello") { req -> String in
        return "Hello, world!"
    }

    try app.register(collection: TodoController())
    try app.register(collection: AuthorizationController())
    try app.register(collection: UserController())
    try app.register(collection: HomePageController())
    try app.register(collection: SportController())
    try app.register(collection: EnergyController())
    try app.register(collection: MoneyExtractController())
}
