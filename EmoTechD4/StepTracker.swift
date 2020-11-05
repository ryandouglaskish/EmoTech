//
//  StepTracker.swift
//  EmoTechD4
//
//  Created by Ryan Kish on 10/21/20.
//  Copyright © 2020 Ryan Kish. All rights reserved.
//

import SwiftUI
import HealthKit

struct Step: Identifiable {
    let id = UUID()
    let count: Int
    let date: Date
}

enum Sex {
    case Male
    case Female
    case Other
}

struct StepTracker: View {
    
    let total_height: CGFloat = 450
    @State var goal_steps: CGFloat = 10000
    
    private var healthStore: HealthStore?
    @State private var steps: [Step] = [Step]()
    
    init() {
        healthStore = HealthStore()
    }
    
    @State var cumSum: Int = 0
    
    // @State var c: Int = 0
    
    private func cum(steps: [Step]) -> Int {
        //        print("Running")
        var sum: Int = 0
        for step in steps {
            //            print("========")
            //            print(step.date)
            //            print(step.count)
            sum += step.count
        }
        return sum
    }
    
    //
    private func getGoalSteps(age: Int, sex: Int) {
        print("setting")
        if sex == 1 {
            if age < 7 {
                goal_steps = 10000
            } else if age < 12 {
                goal_steps = 11000
            } else if age < 20 {
                goal_steps = 10000
            } else if age < 66 {
                goal_steps = 9000
            } else {
                goal_steps = 7000
            }
        } else if sex == 2 {
            if age < 7 {
                goal_steps = 10000
            } else if age < 12 {
                goal_steps = 13000
            } else if age < 20 {
                goal_steps = 11000
            } else if age < 66 {
                goal_steps = 10000
            } else {
                goal_steps = 7500
            }
        } else { // Other or unset
            print("here")
            if age < 7 {
                goal_steps = 10000
            } else if age < 12 {
                goal_steps = 12000
            } else if age < 20 {
                goal_steps = 10500
            } else if age < 66 {
                goal_steps = 9500
            } else {
                goal_steps = 7250
            }
        }
    }
    
    
    // @State var age: Int = 18
    private func updateUIFromStatistics(_ statisticsCollection: HKStatisticsCollection) {
        //if sessionStarted {
        
        let previousMonday = getMonday(myDate: Date())
        let endDate = Date()
        
        statisticsCollection.enumerateStatistics(from: previousMonday, to: endDate) { (statistics, stop) in
            
            let count = statistics.sumQuantity()?.doubleValue(for: .count())
            
            let step = Step(count: Int(count ?? 0), date: statistics.startDate)
            steps.append(step)
            
            
        }
        var age: Int = 18
        var bSex: Int = 0
        /*
        do {
            if  let sex = try healthStore!.healthStore?.biologicalSex()
            {
                bSex = sex.biologicalSex.rawValue
            }
            
            
        } catch {
            print("Couldn't get sex")
        }
        do {
            if let birthDay = try healthStore!.healthStore?.dateOfBirthComponents()
            {
                let calendar = NSCalendar.current
                let birthdate = calendar.date(from: birthDay)!
                age = calendar.dateComponents([.year], from: birthdate, to: Date()).year!
            }
        } catch {
            print("Couldn't get birthday")
        }
        */
        getGoalSteps(age: age, sex: bSex)
        
        cumSum = cum(steps: steps)
    }
    // let goal = 10000
    @State var sessionStarted = false
    
    
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer().frame(height: 20)
            HStack {
                Spacer().frame(width: 20)
                Text("Step Tracker").font(Font.custom(bold, size: 30)).multilineTextAlignment(.leading)
                Spacer()
            }
            HStack {
                Spacer().frame(width: 20)
                Text("Week's Progess: \(cumSum)/\(Int(goal_steps))").font(Font.custom(book, size: 21)).multilineTextAlignment(.leading)
                Spacer()
            }
            
            Spacer()
            
            ZStack {
                Rectangle().fill(Color.white).frame(width: 200, height: 400).shadow(color: Color("StrongShadowBlue"), radius: 40, x: 1, y: -10)
                VStack(spacing: 0) {
                    
                    
                    if cumSum >= Int(goal_steps) {
                        Rectangle().fill(Color.green).frame(width: 200, height: total_height).padding(.horizontal)
                    } else {
                        Rectangle().fill(Color.white).frame(width: 200, height: (goal_steps - CGFloat(cumSum))/goal_steps * total_height).padding(.horizontal)
                        Rectangle().fill(Color.blue).frame(width: 200, height: CGFloat(cumSum)/goal_steps * total_height).padding(.horizontal)
                    }
                }
                //Text(String(cumSum))
            }
            Spacer()
        }.onAppear {
            if !sessionStarted {
                if let healthStore = healthStore {
                    healthStore.requestAuthorization { success, error  in
                        //print(error)
                        if success {
                            healthStore.calculateSteps { statisticsCollection in
                                if let statisticsCollection = statisticsCollection {
                                    // update the UI
                                    updateUIFromStatistics(statisticsCollection)
                                }
                            }
                        }
                    }
                }
                sessionStarted = true
            }
        }
        
        
        
    }
}

struct StepTracker_Previews: PreviewProvider {
    static var previews: some View {
        StepTracker()
    }
}
