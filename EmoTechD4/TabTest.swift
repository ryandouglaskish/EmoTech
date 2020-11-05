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
    
    //    @FetchRequest(entity: Check.entity(),
    //                  sortDescriptors: [NSSortDescriptor(key: "timeAdded", ascending: true)])
    //    var checks: FetchedResults<Check>
    //
    
    
    @State private var selectedTab = 0
    // let v = Checklist().environment(\.managedObjectContext, persistentContainer.viewContext)
    //var homePage: HomePage
    
    
    var body: some View {
        // HomePage(recentPicks: _recentPicks)
        //HomePage()
        //Checklist()
        //StepTracker()
        ZStack(alignment: Alignment.bottom) {
            TabView(selection: $selectedTab) {
                
                //                ChecklistOnboarding().tabItem {
                //                    VStack(alignment: .center) {
                ////                        Image("HeartSymbol")
                ////                        Text("Emotions")
                //                        Text("")
                //                    }
                //                }
                
                HomePage().tabItem {
                    Text("") // < invisible tab item
                }.tag(0)
                Checklist().tabItem {
                    Text("") // < invisible tab item
                }.tag(1)
                StepTracker().tabItem {
                    Text("") // < invisible tab item
                }.tag(2)
                
                /*
                 HomePage().tabItem {
                 VStack {
                 HStack {
                 Image("HeartSymbol")
                 }
                 Text("Emotions")
                 }
                 }
                 Checklist().tabItem {
                 VStack {
                 HStack {
                 
                 Image("HomeSymbol")
                 }
                 Text("Checklist")
                 }
                 }
                 
                 StepTracker().tabItem {
                 Image("StepsSymbol")
                 //Image(systemName: "StepsSymbol.symbolset")
                 //Image(<#T##name: String##String#>)
                 //VStack {
                 //HStack {
                 //Image(systemName: "StepsSymbol")
                 //.resizable()
                 //.aspectRatio(contentMode: .fit)
                 //.background(Color.pink)
                 // Image(uiImage: UIImage(systemName: "StepsSymbol")!)
                 // Image("StepsSymbol")
                 Text("Steps")
                 //}
                 //Text("Steps")
                 // }
                 }
                 */
            }
            
            HStack(alignment: .center) {
                Spacer()
                VStack {
                    Image("HeartSymbol") // << align & highlight as needed
                    Text("Emotions")
                }.onTapGesture(count: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/, perform: {
                    self.selectedTab = 0
                        print("Home")
                }).foregroundColor(selectedTab == 0 ? Color.blue:Color.gray).frame(width: 90)
                Spacer()
                VStack {
                    Image("CheckSymbol") // << align & highlight as needed
                    Text("Checklist")
                }.onTapGesture(count: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/, perform: {
                    self.selectedTab = 1
                        print("Home")
                }).foregroundColor(selectedTab == 1 ? Color.blue:Color.gray).frame(width: 90)
               Spacer()
                VStack {
                    Image("StepsSymbol") // << align & highlight as needed
                    Text("Steps")
                }.onTapGesture(count: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/, perform: {
                    self.selectedTab = 2
                        print("Steps")
                }).foregroundColor(selectedTab == 2 ? Color.blue:Color.gray).frame(width: 90)
                Spacer()
//                Button(action: { self.selectedTab = 0
//                    print("Home")
//                } ) {
//                    VStack {
//                        Image("HeartSymbol") // << align & highlight as needed
//                        Text("Emotions")
//                    }
//                }.foregroundColor(selectedTab == 0 ? Color.blue:Color.gray)
//                Spacer()
//                Button(action: { self.selectedTab = 1
//                    print("Checklist")
//                } ) {
//                    VStack {
//                        Image("StepsSymbol") // << align & highlight as needed
//                        Text("Checklist")
//                    }
//                }.foregroundColor(selectedTab == 1 ? Color.blue:Color.gray)
//                Spacer()
//                Button(action: { self.selectedTab = 2
//                    print("steps")
//                } ) {
//                    VStack {
//                        Image("StepsSymbol") // << align & highlight as needed
//                        Text("Steps")
//                    }
//                }.foregroundColor(selectedTab == 2 ? Color.blue:Color.gray)
//                Spacer()
            }
        }
        
        
        
        
        /*
         TabView(selection: $selectedTab) {
         VStack {
         
         HomePage(recentPicks: _recentPicks)
         //Checklist().environment(\.managedObjectContext, persistentContainerR.viewContext)
         
         }
         //            .tabItem {
         //                VStack {
         //                    Image("HomeSmall").resizable().scaledToFit().frame(width: 10)
         //                    Text("Home")
         //                }
         }
         VStack {
         Text("hello")
         }
         
         //            VStack {
         //                //Text("Hi")
         //                Checklist()
         //                //Checklist(checks: _checks)
         //            }
         
         */
    }
    
}

struct TabTest_Previews: PreviewProvider {
    static var previews: some View {
        TabTest()
    }
}

//struct TabTest_Previews: PreviewProvider {
//    static var previews: some View {
//        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
//    }
//}
