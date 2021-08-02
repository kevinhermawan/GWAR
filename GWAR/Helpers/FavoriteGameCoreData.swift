//
//  FavoriteGameCoreData.swift
//  GWAR
//
//  Created by Kevin Hermawan on 01/08/21.
//

import UIKit
import CoreData

class FavoriteGameCoreData {
  func save(game: Game) {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
    
    let managedContext = appDelegate.persistentContainer.viewContext
    let entity = NSEntityDescription.entity(forEntityName: "FavoriteGame", in: managedContext)!
    let obj = NSManagedObject(entity: entity, insertInto: managedContext)
    
    let id = Int32(game.id)
    let name = game.name.withRatingEmoticon(rating: game.ratings?.first?.title)
    let genre = game.genres?.map({ $0.name }).joined(separator: ", ")
    let rating = "⭐ \(game.rating ?? 0.0)"
    let releaseDate = game.released?.formatReleaseDate(tba: game.tba)
    let backgroundImage = game.backgroundImage
    
    obj.setValue(id, forKey: "id")
    obj.setValue(name, forKey: "name")
    obj.setValue(genre, forKey: "genre")
    obj.setValue(rating, forKey: "rating")
    obj.setValue(releaseDate, forKey: "releaseDate")
    obj.setValue(backgroundImage, forKey: "backgroundImage")
    
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
  
  func retrieveById(id: Int) -> GameForCoreData {
    var game = GameForCoreData()
    
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return game }
    
    let managedContext = appDelegate.persistentContainer.viewContext
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FavoriteGame")
    fetchRequest.predicate = NSPredicate(format: "id == \(id)")
    fetchRequest.fetchLimit = 1
    
    let obj = try? managedContext.fetch(fetchRequest).first as? NSManagedObject
    
    game.id = obj?.value(forKey: "id") as? Int32
    game.name = obj?.value(forKey: "name") as? String
    game.genre = obj?.value(forKey: "genre") as? String
    game.rating = obj?.value(forKey: "rating") as? String
    game.releaseDate = obj?.value(forKey: "releaseDate") as? String
    game.backgroundImage = obj?.value(forKey: "backgroundImage") as? String
    
    return game
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
