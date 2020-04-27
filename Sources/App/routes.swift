import Fluent
import Vapor

func routes(_ app: Application) throws {
  
  try app.routes.register(collection: WebController())
  
  let apiRoutes = app.routes.grouped("api")
  try apiRoutes.register(collection: GalaxyController())
  try apiRoutes.register(collection: StarController())
  try apiRoutes.register(collection: TagController())
}
