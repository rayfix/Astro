//
//  Tag.swift
//  Created by Ray Fix on 4/27/20.
//

import Fluent
import Vapor

final class Tag: Model, Content {
  static let schema = CreateTag.schema
  
  @ID(custom: CreateTag.idKey, generatedBy: .database) var id: Int?
  @Field(key: CreateTag.nameKey) var name: String
  @Siblings(through: StarTag.self, from: \.$tag, to: \.$star) var stars: [Star]
  
  init() {}
  
  init(id: Int? = nil, name: String) {
    self.id = id
    self.name = name
  }
}

// PIVOT TABLE to associate stars and tags in a many-to-many (sibling) relationship.
final class StarTag: Model {
  static let schema = CreateStarTag.schema
  
  @ID(custom: CreateStarTag.idKey, generatedBy: .database) var id: Int?

  @Parent(key: CreateStarTag.tagKey) var tag: Tag
  @Parent(key: CreateStarTag.starKey) var star: Star

  init() {}
  
  init(id: Int? = nil, tagID: Int, starID: Int) {
    self.id = id
    self.$tag.id = tagID
    self.$star.id = starID
  }
}
