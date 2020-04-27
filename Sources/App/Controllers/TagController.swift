//
//  TagController.swift
//  Created by Ray Fix on 4/27/20.
//

import Vapor
import Fluent

struct TagController: RouteCollection {
  
  func boot(routes: RoutesBuilder) throws {
    let group = routes.grouped("tags")
    group.get(use: index)
    group.get(":id", use: get)
    group.delete(":id", use: delete)
    group.post(use: create)
  }
  
  func create(_ req: Request) throws -> EventLoopFuture<Tag> {
    let tag = try req.content.decode(Tag.self)
    return tag.save(on: req.db).map { tag }
  }
  
  func index(_ req: Request) throws -> EventLoopFuture<[Tag]> {
    Tag.query(on: req.db).all()
  }
  
  func get(_ req: Request) throws -> EventLoopFuture<Tag> {
    Tag.find(req.parameters.get("id"), on: req.db)
      .unwrap(or: Abort(.notFound))
  }
  
  func delete(_ req: Request) throws -> EventLoopFuture<HTTPStatus> {
    try get(req)
      .flatMap { $0.delete(on: req.db) }
      .transform(to: .noContent)
  }
}
