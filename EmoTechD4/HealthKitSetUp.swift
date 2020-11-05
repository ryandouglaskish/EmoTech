//
//  HealthKitSetUp.swift
//  EmoTechD4
//
//  Created by Ryan Kish on 10/21/20.
//  Copyright © 2020 Ryan Kish. All rights reserved.
//

import Foundation
import HealthKit

//extension Date {
//    static func mondayAt12AM() -> Date {
//        return Calendar(identifier: .iso8601).date(from: Calendar(identifier: .iso8601).dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date()))!
//    }
//}

class HealthKitSetupAssistant {
    
    var healthStore: HKHealthStore?
    var stepQuery: HKStatisticsCollectionQuery?
    
    
    private enum HealthkitSetupError: Error {
        case notAvailableOnDevice
        case dataTypeNotAvailable
    }
    init() {
        if HKHealthStore.isHealthDataAvailable() {
            healthStore = HKHealthStore()
        }
    }
    
    
     func authorizeHealthKit(completion: @escaping (Bool, Error?) -> Swift.Void) {
        
        //1. Check to see if HealthKit Is Available on this device
//        guard HKHealthStore.isHealthDataAvailable() else {
//            completion(false, HealthkitSetupError.notAvailableOnDevice)
//            return
//        }
        guard let healthStore = self.healthStore else { return completion(false, HealthkitSetupError.notAvailableOnDevice) }

        
        // ========
        guard let stepCount = HKQuantityType.quantityType(forIdentifier: .stepCount) else {
            completion(false, HealthkitSetupError.dataTypeNotAvailable)
            return
        }
        
        
        
        // =========
        
        /*
         //2. Prepare the data types that will interact with HealthKit
         guard   let dateOfBirth = HKObjectType.characteristicType(forIdentifier: .dateOfBirth),
         let bloodType = HKObjectType.characteristicType(forIdentifier: .bloodType),
         let biologicalSex = HKObjectType.characteristicType(forIdentifier: .biologicalSex),
         let bodyMassIndex = HKObjectType.quantityType(forIdentifier: .bodyMassIndex),
         let height = HKObjectType.quantityType(forIdentifier: .height),
         let bodyMass = HKObjectType.quantityType(forIdentifier: .bodyMass),
         let activeEnergy = HKObjectType.quantityType(forIdentifier: .activeEnergyBurned) else {
         
         completion(false, HealthkitSetupError.dataTypeNotAvailable)
         return
         }
         */
        //3. Prepare a list of types you want HealthKit to read and write
        /*
         let healthKitTypesToWrite: Set<HKSampleType> = [bodyMassIndex,
         activeEnergy,
         HKObjectType.workoutType()]
         
         let healthKitTypesToRead: Set<HKObjectType> = [dateOfBirth,
         bloodType,
         biologicalSex,
         bodyMassIndex,
         height,
         bodyMass,
         HKObjectType.workoutType()]
         */
        let healthKitTypesToRead: Set<HKObjectType> = [stepCount]
        
        //4. Request Authorization
        //    HKHealthStore().requestAuthorization(toShare: healthKitTypesToWrite,
        //                                         read: healthKitTypesToRead) { (success, error) in
        //      completion(success, error)
        //    }
        healthStore.requestAuthorization(toShare: nil, read: healthKitTypesToRead) { (success, error) in
            completion(success, error)
        }
    }
    
    
    func calculateWeeklySteps(completion: @escaping (HKStatisticsCollection?) -> Void) {
        let stepType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)!
        
        let startDate = Calendar.current.date(byAdding: .day, value: -7, to: Date())
        
        let anchorDate = Date.mondayAt12AM()
        
        let weekly = DateComponents(day: 1)
        
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: Date(), options: .strictStartDate)
        
        let q = HKStatisticsCollectionQuery(quantityType: stepType, quantitySamplePredicate: predicate, options: .cumulativeSum, anchorDate: anchorDate, intervalComponents: weekly)
        
        q.initialResultsHandler = { query, statisticsCollection, error in completion(statisticsCollection) }
        
        if let healthStore = healthStore, let stepQuery = self.stepQuery {
            healthStore.execute(stepQuery)
        }
     
        //HKHealthStore.execute(q)
        
        /*
        q.initialResultsHandler = {
            q, results, error in
            
            guard let statsCollection = results else {
                // Perform proper error handling here
                fatalError("*** An error occurred while calculating the statistics: \(error?.localizedDescription) ***")
            }
            
            let endDate = NSDate()
            
            guard let startDate = Calendar.dateByAddingUnit(.Month, value: -3, toDate: endDate, options: []) else {
                fatalError("*** Unable to calculate the start date ***")
            }
            
            // Plot the weekly step counts over the past 3 months
            statsCollection.enumerateStatisticsFromDate(startDate, toDate: endDate) { [unowned self] statistics, stop in
                
                if let quantity = statistics.sumQuantity() {
                    let date = statistics.startDate
                    let value = quantity.doubleValueForUnit(HKUnit.countUnit())
                    
                    // Call a custom method to plot each data point.
                    self.plotWeeklyStepCount(value, forDate: date)
                }
            }
            
            //q.initialResultsHandler = { query, }
            
            //let query = HKStatisticsQuery(quantityType: stepType, quantitySamplePredicate: predicate, options: .cumulativeSum, completionHandler: {query, statisticsOrNil, errorOrNil} in
            
            // )
            // HKStatisticsQuery(quantityType: stepType, quantitySamplePredicate: predicate, options: .cumulativeSum, anchorDate: anchorDate, intervalComponents: .daily)
            
            //HKStatisticsQuery(
        }
        
        */
    }
    
}
