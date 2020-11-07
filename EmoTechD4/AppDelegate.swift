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
import HealthKit


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
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
        
                var tipDescriptionsLoad: [String] = []
                tipDescriptionsLoad.append(dict["T1Text"]!)
                tipDescriptionsLoad.append(dict["T2Text"]!)
                tipDescriptionsLoad.append(dict["T3Text"]!)
                tipDescriptionsLoad.append(dict["T4Text"]!)
                
                
                
                let spotify = dict["Spotify Playlist Link"]!
              
                emotions.append(Emotion(emotion: dict["Emotion"] ?? "ERROR", mood: dict["Mood"]!, tips: tipDescriptionsLoad, spotify: spotify, spotifyLength: dict["Hours for playlist"]!))

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

