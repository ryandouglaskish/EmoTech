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
    @AppStorage("needsAppOnboardingSteps") private var needsAppOnboardingSteps: Bool = true
    
    @State var showOnboarding: Bool = true
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
            print("stats")
            let count = statistics.sumQuantity()?.doubleValue(for: .count())
            
            //let step = Step(count: Int(count ?? 0), date: statistics.startDate)
            //steps.append(step)
            cumSum += Int(count ?? 0)
            print(cumSum)
            
        }
        var age: Int = 18
        var bSex: Int = 0
        
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
        
        getGoalSteps(age: age, sex: bSex)
        print("now here")
        //cumSum = cum(steps: steps)
    }
    // let goal = 10000
    @State var sessionStarted = false
    
    
    
    var body: some View {
        ZStack {
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
                ZStack {
                    Rectangle().fill(Color.gray.opacity(0.4)).frame(height: 40)
                    HStack {
                        Spacer()
                        Button(action: {
                            showOnboarding = true
                            print("showOnboarding is now: \(showOnboarding)")
                            
                        }) {
                            Image("Info")
                        }
                        Spacer().frame(width: 20)
                    }
                }
                Spacer().frame(height: 0)
            }.disabled(showOnboarding)
            
            if showOnboarding {
                
                ZStack {
                    Color.black.opacity(0.4).ignoresSafeArea().onTapGesture(count: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/, perform: {
                        showOnboarding = false
                        print("clicked here")
                    })
                    RoundedRectangle(cornerRadius: 20).foregroundColor(.purple).frame(width: 300, height: 400)
                    RoundedRectangle(cornerRadius: 20).foregroundColor(.white).frame(width: 298, height: 398)
                    // ChecklistOnboarding().frame(width: 298, height: 398)
                    VStack()  {
                        Spacer().frame(height: 20)
                        
                        HStack {
                            Spacer().frame(width: 20)
                            ScrollView {
                                Text("Welcome to your step tracker! Here you can observe your daily steps by linking to the Health App. At the end of the week (Sunday), see if you got the goal number of steps that experts recommend.").font(Font.custom(book, size: 15)).multilineTextAlignment(.leading).frame(width: 260.0)
                                Spacer().frame(height: 20)
                                Text("The reason tracking your activity level is so important is because being active is a vital part of sustained happiness.").font(Font.custom(book, size: 15)).multilineTextAlignment(.leading).frame(width: 260.0)
                                Spacer().frame(width: 20)
                            }
                            Spacer().frame(width: 22)
                        }
                        
                        Spacer().frame(height: 20)
                        ZStack {
                            Rectangle().fill(Color.green).frame(width: 250, height: 60).cornerRadius(20)
                            Button(action: {
                                showOnboarding = false
                                print(showOnboarding)
                            }) {
                                Text("Continue").font(Font.custom(bold, size: 25)).foregroundColor(.white)
                            }
                        }
                        Spacer().frame(height: 20)
                        
                        
                        
                        
                    }.frame(width: 298, height: 398)
                    
                }
            }
            
        }.onAppear {
            if needsAppOnboardingSteps {
                showOnboarding = true
            }  else {
                showOnboarding = false
            }
            print("App needs: \(needsAppOnboardingSteps)")
            print("Should show: \(showOnboarding)")
            
            //  print(sessionStarted)
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
                        } else {
                            print("no success")
                        }
                    }
                }
                sessionStarted = true
            }
        }.onChange(of: showOnboarding) { _ in
            needsAppOnboardingSteps = false
        }.onChange(of: showOnboarding) { _ in
            needsAppOnboardingSteps = false
        }
        
    }
}

struct StepTracker_Previews: PreviewProvider {
    static var previews: some View {
        StepTracker()
    }
}
