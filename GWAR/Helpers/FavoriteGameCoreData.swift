//
//  FavoriteGameCoreData.swift
//  GWAR
//
//  Created by Kevin Hermawan on 01/08/21.
//

import UIKit
import CoreData

class FavoriteGameCoreData {
  func save(game: GameForCoreData) {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
    
    let managedContext = appDelegate.persistentContainer.viewContext
    let entity = NSEntityDescription.entity(forEntityName: "FavoriteGame", in: managedContext)!
    let obj = NSManagedObject(entity: entity, insertInto: managedContext)
    
    obj.setValue(game.id, forKey: "id")
    obj.setValue(game.name, forKey: "name")
    obj.setValue(game.genre, forKey: "genre")
    obj.setValue(game.rating, forKey: "rating")
    obj.setValue(game.releaseDate, forKey: "releaseDate")
    obj.setValue(game.backgroundImage, forKey: "backgroundImage")
    
    do {
      try managedContext.save()
    } catch {
      fatalError("save Error: \(error)")
    }
  }
  
  func retrieve() -> [GameForCoreData] {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return [] }
    
    let managedContext = appDelegate.persistentContainer.viewContext
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FavoriteGame")
    let objs = try? managedContext.fetch(fetchRequest) as? [NSManagedObject]
    
    var games = [GameForCoreData]()
    
    objs?.forEach { obj in
      var game = GameForCoreData()
      game.id = obj.value(forKey: "id") as? Int32
      game.name = obj.value(forKey: "name") as? String
      game.genre = obj.value(forKey: "genre") as? String
      game.rating = obj.value(forKey: "rating") as? String
      game.releaseDate = obj.value(forKey: "releaseDate") as? String
      game.backgroundImage = obj.value(forKey: "backgroundImage") as? String
      
      games.append(game)
    }
    
    return games
  }
  
  func delete(id: Int32) {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
    
    let managedContext = appDelegate.persistentContainer.viewContext
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FavoriteGame")
    fetchRequest.predicate = NSPredicate(format: "id == \(id)")
    fetchRequest.fetchLimit = 1
    
    let result = try? managedContext.fetch(fetchRequest) as? [NSManagedObject]
    let selectedGame = result?.first
    
    if let gameToDelete = selectedGame {
      managedContext.delete(gameToDelete)
    }
    
    do {
      try managedContext.save()
    } catch {
      fatalError("removeGameToFavorite Error: \(error)")
    }
  }
}
