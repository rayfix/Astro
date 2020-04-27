import Fluent
import FluentPostgresDriver
import Vapor

// configures your application
public func configure(_ app: Application) throws {

  // On macOS set the working directory to the app directory in the scheme options.
  // You add a .env file here and set the values of DATABASE_HOST, DATABASE_USERNAME,
  // etc here.  Your .env file might look like this:
  //
  // DATABASE_HOST=localhost
  // DATABASE_USERNAME=vapor_user
  // DATABASE_PASSWORD=vapor_password
  // DATABASE_NAME=astro_database
  // SERVER_HOSTNAME=localhost
  // SERVER_PORT=8080
  
  if let hostname = Environment.get("SERVER_HOSTNAME") {
    app.http.server.configuration.hostname = hostname
  }
  
  if let portStr = Environment.get("SERVER_PORT"),
     let port = Int(portStr) {
    app.http.server.configuration.port = port
  }
  
  app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
  app.views.use(.leaf)
  
  if !app.environment.isRelease {
    print("Turn off caching")
    app.leaf.cache.isEnabled = false
  }
    
  app.databases.use(.postgres(
    hostname: Environment.get("DATABASE_HOST")!,
    username: Environment.get("DATABASE_USERNAME")!,
    password: Environment.get("DATABASE_PASSWORD")!,
    database: Environment.get("DATABASE_NAME")!
    ), as: .psql)

  
  // Run migration by passing "migrate" as an argument
  app.migrations.add(CreateGalaxy())
  app.migrations.add(CreateStar())
  //app.migrations.add(UniqueStarNames())  There is a bug that causes this to fail.
  app.migrations.add(CreateTag())
  app.migrations.add(CreateStarTag())
  
  // register routes
  try routes(app)
}
