//
//  File.swift
//  Created by Ray Fix on 4/27/20.
//

import Fluent

struct CreateTag: Migration {
  
  static let schema = "tags"
  static let idKey: FieldKey = "id"
  static let nameKey: FieldKey = "name"
  
  func prepare(on database: Database) -> EventLoopFuture<Void> {
    database.schema(Self.schema)
      .field(Self.idKey, .int, .required, .identifier(auto: true))
      .field(Self.nameKey, .string)
      .create()
  }
  
  func revert(on database: Database) -> EventLoopFuture<Void> {
    database.schema(Self.schema).delete()
  }
}

struct CreateStarTag: Migration {
  
  static let schema = "star_tags"
  static let idKey: FieldKey = "id"
  static let starKey: FieldKey = "star_id"
  static let tagKey: FieldKey = "tag_id"
  
  func prepare(on database: Database) -> EventLoopFuture<Void> {
    database.schema(Self.schema)
      .field(Self.idKey, .int, .required, .identifier(auto: true))
      .field(Self.starKey, .int, .required, .references(CreateStar.schema, CreateStar.idKey))
      .field(Self.tagKey, .int, .required, .references(CreateTag.schema, CreateTag.idKey))
      .create()
  }
  
  func revert(on database: Database) -> EventLoopFuture<Void> {
    database.schema(Self.schema).delete()
  }
}
