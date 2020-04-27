//
//  UniqueStarNames.swift
//  Created by Ray Fix on 4/27/20.
//

import Fluent


// BROKEN in 4-rc
// Currently broken in Fluent. TODO: File an Issue

struct UniqueStarNames: Migration {
  func prepare(on database: Database) -> EventLoopFuture<Void> {
    database.schema(CreateStar.schema)
      .unique(on: CreateStar.nameKey)
      .update()
  }
  func revert(on database: Database) -> EventLoopFuture<Void> {
    database.schema(CreateStar.schema).update()
  }
}
