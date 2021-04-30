import Fluent
import FluentMySQLDriver
import Vapor

// configures your application
public func configure(_ app: Application) throws {
    // 从 'Public/' 目录提供文件
    let fileMiddleware = FileMiddleware(
        publicDirectory: app.directory.publicDirectory
    )
    app.middleware.use(fileMiddleware)
    
    // 跨越处理
    let corsConfiguration = CORSMiddleware.Configuration(
        allowedOrigin: .all,
        allowedMethods: [.GET, .POST, .PUT, .OPTIONS, .DELETE, .PATCH],
        allowedHeaders: [.accept, .authorization, .contentType, .origin, .xRequestedWith, .userAgent, .accessControlAllowOrigin]
    )
    let cors = CORSMiddleware(configuration: corsConfiguration)
    app.middleware.use(cors)
    
    switch app.environment {
    case .development:
        // 数据库
        app.databases.use(.mysql(
            hostname: "localhost",
            username: "root",
            password: "hahaha123YK",
            database: "sport",
            tlsConfiguration: .none
        ), as: .mysql)
    case .testing:
        // 数据库
        app.databases.use(.mysql(
            hostname: "rm-2zebd6syq0cd6x0685o.mysql.rds.aliyuncs.com",
            username: "yuekun",
            password: "hahaha123YK",
            database: "sport"
        ), as: .mysql)
    case .production:
        // 数据库
        app.databases.use(.mysql(
            hostname: "rm-2zebd6syq0cd6x0685o.mysql.rds.aliyuncs.com",
            username: "yuekun",
            password: "hahaha123YK",
            database: "sport"
        ), as: .mysql)
    default:
        break
    }

    app.migrations.add(CreateAuthorization())
    app.migrations.add(CreateUser())
    app.migrations.add(CreateEnergyRecord())
    app.migrations.add(CreateMoneyExtractRecord())
    app.migrations.add(CreateSportRecord())

    // register routes
    try routes(app)
}
