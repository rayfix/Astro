//
//  CreateGalaxy.swift
//  Created by Ray Fix on 4/27/20.
//

import Fluent

struct CreateGalaxy: Migration {
  
  static let schema = "galaxies"
  static let idKey: FieldKey = "id"
  static let nameKey: FieldKey = "name"
    
  func prepare(on database: Database) -> EventLoopFuture<Void> {
    database.schema(Self.schema)
      .field(Self.idKey, .int, .required, .identifier(auto: true))  // Use .id() for UUID
      .field(Self.nameKey, .string, .required)
      .create()
  }
  
  func revert(on database: Database) -> EventLoopFuture<Void> {
    database.schema(Self.schema).delete()
  }
}
