//
//  AppDelegate.swift
//  EmoTechD4
//
//  Created by Ryan Kish on 7/11/20.
//  Copyright © 2020 Ryan Kish. All rights reserved.
//

import UIKit
import SwiftUI
import CoreData


//enum Category {
//    case positive
//    case negative
//}
class Emotion: Identifiable {
    var id = UUID()
    var emotion: String
    //var tips: [Tip]
    var tips: [String]
    var spotify: String
    var currInd: Int = 0
    
    init(emotion: String, tips: [String], spotify: String) {
        self.emotion = emotion
        self.tips = tips
        self.spotify = spotify
    }

    func nextTip() -> String {
        currInd += 1
        currInd = currInd % 4
        return tips[currInd]
    }
}


//struct Tip: Identifiable {
//    var id = UUID()
//    var title: String
//    var text: String
//    @State var cellExpanded = false
//}
//var positive_emotions: [Emotion] = []
//var negative_emotions: [Emotion] = []
var emotions: [Emotion] = []

var order: Int16 = 0

//extension UIColor {
//    //static var emoPurple = UIColor(red: 232/255, green: 68/255, blue: 133/255, alpha: 1)
//    static var emoOrange = UIColor(red: 228/225, green: 163/255, blue: 139/255, alpha: 0.95)
//    static var deepPurple = UIColor(red: 69/255, green: 41/255, blue: 76/255, alpha: 1)
//    static var lightPurple = UIColor(red: 154/255, green: 138/255, blue: 171/255, alpha: 1)
//}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    
//    private let positive_filename = "positive_emotions"
//    private let negative_filename = "negative_emotions"
    
    private let filename = "Emotions"
    private let file_type = "csv"

    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        loadInData(fileName: filename)
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    
    // MARK: - Core Data stack

//       lazy var persistentContainer: NSPersistentContainer = {
//           /*
//            The persistent container for the application. This implementation
//            creates and returns a container, having loaded the store for the
//            application to it. This property is optional since there are legitimate
//            error conditions that could cause the creation of the store to fail.
//           */
//           let container = NSPersistentContainer(name: "RecentPicksModel")
//           container.loadPersistentStores(completionHandler: { (storeDescription, error) in
//               if let error = error as NSError? {
//                   // Replace this implementation with code to handle the error appropriately.
//                   // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//                    
//                   /*
//                    Typical reasons for an error here include:
//                    * The parent directory does not exist, cannot be created, or disallows writing.
//                    * The persistent store is not accessible, due to permissions or data protection when the device is locked.
//                    * The device is out of space.
//                    * The store could not be migrated to the current model version.
//                    Check the error message to determine what the actual problem was.
//                    */
//                   fatalError("Unresolved error \(error), \(error.userInfo)")
//               }
//           })
//           return container
//       }()

       // MARK: - Core Data Saving support

//       func saveContext () {
//           let context = persistentContainer.viewContext
//           if context.hasChanges {
//               do {
//                   try context.save()
//               } catch {
//                   // Replace this implementation with code to handle the error appropriately.
//                   // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//                   let nserror = error as NSError
//                   fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
//               }
//           }
//       }

    
    
    // MARK: - Process data from csv
    
    func loadInData(fileName: String) {
        var data = readDataFromCSV(fileName: fileName, fileType: file_type)
        data = cleanRows(file: data!)
        let csvRows = csv(data: data!)
        map_csv(rows: csvRows)
    }
    
    func map_csv(rows: [[String]]) {
        for row in rows {
            var dict: Dictionary = [String: String]()
            if !(row==rows[0]) {
                for i in 0..<row.count {
                    dict[rows[0][i]] = row[i]
                }
                //print(dict)
                
//                let category: Category
//                if dict["Positivity Rating"]=="Positive" { category = Category.positive } else { category = Category.negative }
                var tipDescriptionsLoad: [String] = []
                tipDescriptionsLoad.append(dict["Tip1Text"]!)
                tipDescriptionsLoad.append(dict["Tip2Text"]!)
                tipDescriptionsLoad.append(dict["Tip3Text"]!)
                tipDescriptionsLoad.append(dict["Tip4Text"]!)

                let spotify = dict["Spotify"]!
                //emotions.append(Emotion(emotion: dict["Emotion"]!, tips: tipDescriptionsLoad, spotify: spotify))
                emotions.append(Emotion(emotion: dict["Emotion"] ?? "ERROR", tips: tipDescriptionsLoad, spotify: spotify))

            }
        }
        emotions = emotions.shuffled()
    }
    
    func readDataFromCSV(fileName:String, fileType: String)-> String!{
        guard let filepath = Bundle.main.path(forResource: fileName, ofType: fileType)
            else {
                print("Could not find file")
                return nil
        }
        do {
            var contents = try String(contentsOfFile: filepath, encoding: .utf8)
            contents = cleanRows(file: contents)
            return contents
        } catch {
            print("File Read Error for file \(filepath)")
            return nil
        }
    }
    func cleanRows(file:String)->String{
        var cleanFile = file
        cleanFile = cleanFile.replacingOccurrences(of: "\r", with: "\n")
        cleanFile = cleanFile.replacingOccurrences(of: "\n\n", with: "\n")
        //        cleanFile = cleanFile.replacingOccurrences(of: ";;", with: "")
        //        cleanFile = cleanFile.replacingOccurrences(of: ";\n", with: "")
        return cleanFile
    }
    func csv(data: String) -> [[String]] {
        var result: [[String]] = []
        let rows = data.components(separatedBy: "\n")
        for row in rows {
            if !(row.isEmpty) {
                let columns = row.components(separatedBy: ";")
                result.append(columns)
            }
        }
        return result
    }
    
    
    
}

