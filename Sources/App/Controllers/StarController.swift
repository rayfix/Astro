//
//  StarController.swift
//  Created by Ray Fix on 4/27/20.
//

import Vapor
import Fluent

struct StarController: RouteCollection {
  func boot(routes: RoutesBuilder) throws {
    let group = routes.grouped("stars")
    group.get(use: index)
    group.get(":id", use: get)
    group.delete(":id", use: delete)
    group.post(use: create)
    group.post(":starID", "tag", ":tagID", use: attachTag)
  }
  
  func index(_ req: Request) throws -> EventLoopFuture<[Star]> {
    Star.query(on: req.db).with(\.$tags).all()
  }
  
  func create(_ req: Request) throws -> EventLoopFuture<Star> {
    let star = try req.content.decode(Star.self)
    return star.save(on: req.db).map { star }
  }
  
  func get(_ req: Request) throws  -> EventLoopFuture<Star> {
    Star.find(req.parameters.get("id"), on: req.db)
      .unwrap(or: Abort(.notFound))
  }
  
  func delete(_ req: Request) throws -> EventLoopFuture<HTTPStatus> {
    try get(req).flatMap { $0.delete(on: req.db) }.transform(to: .noContent)
  }
  
  func attachTag(_ req: Request) throws -> EventLoopFuture<HTTPStatus> {
    let star = Star.find(req.parameters.get("starID"), on: req.db)
      .unwrap(or: Abort(.notFound))
    let tag = Tag.find(req.parameters.get("tagID"), on: req.db)
      .unwrap(or: Abort(.notFound))
    return star.and(tag).flatMap { (star, tag) in
      star.$tags.attach(tag, on: req.db)
    }.transform(to: .ok)
  }
}
