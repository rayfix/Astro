//
//  Galaxy.swift
//  Created by Ray Fix on 4/26/20.
//

import Vapor
import Fluent

final class Galaxy: Model, Content {
  // Name of the table or collection.
  static let schema = CreateGalaxy.schema
  
  // Unique identifier for this Galaxy.
  // Recommendation is to use UUID? but showing an
  // Int here for practice and because it makes shorter URLs
  // For UUID use:
  // @ID(key: .id) var id: UUID?

  @ID(custom: CreateGalaxy.idKey, generatedBy: .database)
  var id: Int?

  @Field(key: CreateGalaxy.nameKey) var name: String
  @Children(for: \.$galaxy) var stars: [Star]
  
  init() { }
  
  init(id: Int? = nil, name: String) {
    self.id = id
    self.name = name
  }
}
