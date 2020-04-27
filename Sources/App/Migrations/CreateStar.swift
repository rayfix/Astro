//
//  CreateStar.swift
//  Created by Ray Fix on 4/27/20.
//

import Fluent

struct CreateStar: Migration {
  
  static let schema = "stars"
  static let idKey: FieldKey = "id"
  static let nameKey: FieldKey = "name"
  static let galaxyKey: FieldKey = "galaxy_id"
  
  
  func prepare(on database: Database) -> EventLoopFuture<Void> {
    database.schema(Self.schema)
      .field(Self.idKey, .int, .required, .identifier(auto: true))  // use .id() for UUID
      .field(Self.nameKey, .string, .required)
      .field(Self.galaxyKey, .int, .required, .references(CreateGalaxy.schema, CreateGalaxy.idKey))
      .create()
    
  }
  func revert(on database: Database) -> EventLoopFuture<Void> {
    database.schema(Self.schema).delete()
  }
}
