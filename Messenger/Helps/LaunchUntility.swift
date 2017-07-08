//
//  LaunchUntility.swift
//  Messenger
//
//  Created by Matt Tian on 7/7/17.
//  Copyright © 2017 Bizersoft. All rights reserved.
//

import Foundation
import CoreData

extension FriendsViewController {
    
    var context: NSManagedObjectContext {
        return CoreDataManager.shared.viewContext
    }
    
    func setupData() {
        clearData()
        createData()
        loadData()
    }
    
    private func clearData() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Friend")

        do {
            let managedObjects = try context.fetch(request) as! [NSManagedObject]
            
            for object in managedObjects {
                context.delete(object)
            }
            
            CoreDataManager.shared.saveContext()
            
        } catch let err {
            print(err.localizedDescription)
        }
        
    }
    
    private func createData() {
        let steve = Friend(context: context)
        steve.name = "Steve Jobs"
        steve.profileImageName = "steve_profile"
        
        createMessage("Hello, welcome to Apple!", friend: steve, minutesAge: 3, context: context)
        createMessage("How are you feel today?", friend: steve, minutesAge: 2, context: context)
        createMessage("Let's have a cup of coffee.", friend: steve, minutesAge: 1, context: context)
        
        let mark = Friend(context: context)
        mark.name = "Mark Zuckerberg"
        mark.profileImageName = "zuckprofile"
        
        createMessage("I create Facebook. Please enjoy it.", friend: mark, minutesAge: 2, context: context)
        
        CoreDataManager.shared.saveContext()
        
        let trump = Friend(context: context)
        trump.name = "Donald Trump"
        trump.profileImageName = "donald_trump_profile"
        
        createMessage("I'm very very rich.", friend: trump, minutesAge: 0, context: context)
        
        let hillary = Friend(context: context)
        hillary.name = "Hillary Clinton"
        hillary.profileImageName = "hillary_profile"
    }
    
    private func createMessage(_ text: String, friend: Friend, minutesAge: Double, context: NSManagedObjectContext) {
        let message = Message(context: context)
        message.text = text
        message.friend = friend
        message.date = Date().addingTimeInterval(-minutesAge * 60)
    }
    
    private func loadData() {
        let friendRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Friend")
        let messageRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Message")
        messageRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        messageRequest.fetchLimit = 1
        
        do {
            let managedFriends = try context.fetch(friendRequest) as! [Friend]
            
            var _messages = [Message]()
            
            for friend in managedFriends {
                if let name = friend.name {
                    messageRequest.predicate = NSPredicate(format: "friend.name == %@", name)
                    
                    let managedMessages = try context.fetch(messageRequest) as! [Message]
                    
                    _messages.append(contentsOf: managedMessages)
                }
            }
            
            messages = _messages.sorted { $0.date! > $1.date! }
        } catch let error {
            NSLog("Core Data Fetch Error: \(error)")
        }
    }
    
}