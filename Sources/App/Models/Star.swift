//
//  Star.swift
//  Created by Ray Fix on 4/26/20.
//

import Fluent
import Vapor


final class Star: Model, Content {

  static let schema = CreateStar.schema
  
  @ID(custom: CreateStar.idKey, generatedBy: .database) var id: Int?
  @Field(key: CreateStar.nameKey) var name: String
  
  @Parent(key: CreateStar.galaxyKey) var galaxy: Galaxy
  
  @Siblings(through: StarTag.self, from: \.$star, to: \.$tag)
  var tags: [Tag]
  
  init() { }
  
  init(id: Int? = nil, name: String, galaxyID: Int) {
    self.id = id
    self.name = name
    self.$galaxy.id = galaxyID
  }
}
