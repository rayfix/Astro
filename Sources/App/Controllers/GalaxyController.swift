//
//  StarController.swift
//  Created by Ray Fix on 4/27/20.
//

import Fluent
import Vapor

struct GalaxyController: RouteCollection {
  
  func boot(routes: RoutesBuilder) throws {

    let group = routes.grouped("galaxies")
    group.post(use: create)
    group.get(use: index)
    group.get(":id", use: get)
    group.get(":id", "stars", use: getStars)
    group.delete(":id", use: delete)
  }
  
  func index(_ req: Request) throws -> EventLoopFuture<[Galaxy]> {
    Galaxy.query(on: req.db).with(\.$stars) { $0.with(\.$tags) }.all()
  }
  
  func create(_ req: Request) throws -> EventLoopFuture<Galaxy> {
    let todo = try req.content.decode(Galaxy.self)
    return todo.save(on: req.db).map { todo }
  }
  
  func get(_ req: Request) throws -> EventLoopFuture<Galaxy> {
    Galaxy.find(req.parameters.get("id"), on: req.db)
      .unwrap(or: Abort(.notFound))
  }
  
  func getStars(_ req: Request) throws -> EventLoopFuture<[Star]> {
    guard let id = req.parameters.get("id", as: Int.self) else {
        throw Abort(.badRequest)
    }
    
    return Galaxy.query(on: req.db).with(\.$stars) { $0.with(\.$tags) }
      .filter(\.$id == id)
      .first()
      .unwrap(or: Abort(.notFound))
      .map { $0.stars }
  }
  
  func delete(_ req: Request) throws -> EventLoopFuture<HTTPStatus> {
    try get(req)
      .flatMap { $0.delete(on: req.db) }
      .transform(to: .ok)
  }
}
