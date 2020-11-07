//
//  TabTest.swift
//  EmoTechD4
//
//  Created by Ryan Kish on 10/21/20.
//  Copyright © 2020 Ryan Kish. All rights reserved.
//

import SwiftUI
import CoreData


struct TabTest: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @FetchRequest(entity: RecentPick.entity(),
                  sortDescriptors: [NSSortDescriptor(key: "added", ascending: false)])
    var recentPicks: FetchedResults<RecentPick>
  
    
    @State private var selectedTab = 0
  
    @available(iOS 14.0, *)
    var body: some View {
  
        ZStack(alignment: Alignment.bottom) {
            TabView(selection: $selectedTab) {
                
                
                HomePage().tabItem {
                    Text("")
                }.tag(0)
                if #available(iOS 14.0, *) {
                
                Checklist().tabItem {
                    Text("")
                }.tag(1)
                } else {
                    ChecklistOldOS().tabItem {
                        Text("")
                    }.tag(1)
                }
                
                if #available(iOS 14.0, *) {
                StepTracker().tabItem {
                    Text("")
                }.tag(2)
                } else {
                    StepTrackerOldOS().tabItem {
                        Text("")
                    }.tag(2)
                }
                
            }
            if #available(iOS 14.0, *) {
            HStack(alignment: .center) {
                Spacer()
                VStack {
                    Image("HeartSymbol")
                    Text("Emotions")
                }.onTapGesture(count: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/, perform: {
                    self.selectedTab = 0
                }).foregroundColor(selectedTab == 0 ? Color.blue:Color.gray).frame(width: 90)
                Spacer()
                VStack {
                    Image("CheckSymbol")
                    Text("Checklist")
                }.onTapGesture(count: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/, perform: {
                    self.selectedTab = 1
                }).foregroundColor(selectedTab == 1 ? Color.blue:Color.gray).frame(width: 90)
               Spacer()
                VStack {
                    Image("StepsSymbol")
                    Text("Steps")
                }.onTapGesture(count: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/, perform: {
                    self.selectedTab = 2
                }).foregroundColor(selectedTab == 2 ? Color.blue:Color.gray).frame(width: 90)
                Spacer()

            }
            }
        }.ignoresSafeArea(.keyboard)
        
    
    }
    
}

struct TabTest_Previews: PreviewProvider {
    static var previews: some View {
        TabTest()
    }
}

