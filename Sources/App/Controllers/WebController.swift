//
//  WebController.swift
//  Created by Ray Fix on 4/27/20.
//

import Leaf
import Vapor

struct WebController: RouteCollection {
  
  func boot(routes: RoutesBuilder) throws {
    routes.get(use: index)
  }
  
  func index(_ req: Request) throws -> EventLoopFuture<View> {
    req.view.render("page", [
        "title": "Astro",
        "description": "Keep track of stars and galaxies.",
        "content": "Welcome to Astro"
    ])
  }
}
