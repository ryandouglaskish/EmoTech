//
//  HealthStore.swift
//  EmoTechD4
//
//  Created by Ryan Kish on 10/26/20.
//  Copyright © 2020 Ryan Kish. All rights reserved.
//

import Foundation
import HealthKit

extension Date {

    static func mondayAt12AM() -> Date {
        return Calendar(identifier: .iso8601).date(from: Calendar(identifier: .iso8601).dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date()))!
    }
}

func getMonday(myDate: Date) -> Date {
    let cal = Calendar.current
    var comps = cal.dateComponents([.weekOfYear, .yearForWeekOfYear], from: myDate)
    comps.weekday = 2 // Monday
    let mondayInWeek = cal.date(from: comps)!
    return mondayInWeek
}

class HealthStore {
    
    var healthStore: HKHealthStore?
    var query: HKStatisticsCollectionQuery?
    
    init() {
        if HKHealthStore.isHealthDataAvailable() {
            healthStore = HKHealthStore()
        }
    }
    
    func calculateSteps(completion: @escaping (HKStatisticsCollection?) -> Void) {
        
        let stepType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)!
        
        let previousMonday = getMonday(myDate: Date())
     //   let startDate = Calendar.current.date(byAdding: .day, value: -7, to: Date())
        
//        let startDate = Date().previous(.monday)
        let anchorDate = Date.mondayAt12AM()
        
        let daily = DateComponents(day: 1)
        
        let predicate = HKQuery.predicateForSamples(withStart: previousMonday, end: Date(), options: .strictStartDate)
        
        query = HKStatisticsCollectionQuery(quantityType: stepType, quantitySamplePredicate: predicate, options: .cumulativeSum, anchorDate: anchorDate, intervalComponents: daily)
        
        query!.initialResultsHandler = { query, statisticsCollection, error in
            completion(statisticsCollection)
        }
        
        if let healthStore = healthStore, let query = self.query {
            healthStore.execute(query)
        }
        
    }
    
    private enum HealthkitSetupError: Error {
        case notAvailableOnDevice
        case dataTypeNotAvailable
        case healthStoreNotAvailable
    }
    
    func saveMindfullAnalysis(startTime: Date, endTime: Date) {
        // Create a mindful session with the given start and end time
        let mindfulType = HKObjectType.categoryType(forIdentifier: .mindfulSession)!

        let mindfullSample = HKCategorySample(type: mindfulType, value: HKCategoryValue.notApplicable.rawValue, start: startTime, end: endTime)

        guard let healthStore = self.healthStore else { return }

        healthStore.save(mindfullSample, withCompletion: { (success, error) -> Void in
            if error != nil {return}
            print("Sent data to HealthKit: \(success)")
        })
    }

    func requestAuthorization(completion: @escaping (Bool, Error?) -> Void) {
        
        guard let stepType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount),
        let biologicalSex = HKObjectType.characteristicType(forIdentifier: .biologicalSex),
        let dateOfBirth = HKObjectType.characteristicType(forIdentifier: .dateOfBirth),
        let mindfulness = HKObjectType.categoryType(forIdentifier: .mindfulSession)
        else {
        
        completion(false, HealthkitSetupError.dataTypeNotAvailable)
        return
        }
            
        let healthKitTypesToRead: Set<HKObjectType> = [stepType, dateOfBirth,
        biologicalSex]
        
        guard let healthStore = self.healthStore else { return completion(false, HealthkitSetupError.healthStoreNotAvailable) }
        
        healthStore.requestAuthorization(toShare: [mindfulness], read: healthKitTypesToRead) { (success, error) in
            completion(success, error)
        }
        
    }
    
}
