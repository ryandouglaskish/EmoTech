//
//  Checklist.swift
//  EmoTechD4
//
//  Created by Ryan Kish on 10/21/20.
//  Copyright © 2020 Ryan Kish. All rights reserved.
//

import SwiftUI
import Foundation
import CoreData


struct ChecklistItem: Identifiable {
    var id = UUID()
    var text: String
    var checked: Bool = false
}




@available(iOS 14.0, *)
struct Checklist: View {
    @AppStorage("needsAppOnboarding") private var needsAppOnboarding: Bool = true
    
    @State var showOnboarding: Bool = true
    //    init() {
    //        print(needsAppOnboarding)
    //        showOnboarding = needsAppOnboarding.hashValue != 0
    //        print(showOnboarding)
    //    }
    
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @FetchRequest(entity: Check.entity(),
                  sortDescriptors: [NSSortDescriptor(key: "timeAdded", ascending: true)])
    var checks: FetchedResults<Check>
    
    @State var checks_texts = [String](repeating: "", count: 1000)
    
    @State var newText: String = ""
    
    @State var numChecks = 0
    
    @State var show = true
    @State var currentText = "Not set"
    
    @State var notCompletable = true
    
    //    init() {
    //        if getNumChecked() == checks.count && checks.count != 0 {
    //            notCompletable = false
    //        }
    //    }
    //
    //var numChecks = 0
    
    func getText(i: Int) -> String {
        if i == checks.count {
            return ""
        }
        return checks[i].text!
    }
    func setAText(i: Int, text: String) {
        checks[i].text = text
    }
    
    func removeCheck(at offsets: IndexSet) {
        for index in offsets {
            print("INDEX: \(index)")
            managedObjectContext.delete(checks[index])
        }
        do {
            try self.managedObjectContext.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    func getNumChecked() -> Int {
        var numChecked = 0
        if checks.count > 0 {
            for c in checks {
                if c.checked {
                    numChecked += 1
                }
            }
        }
        return numChecked
    }
    
    func deleteAllChecks()  {
        let t = checks.count
        for i in 0...t-1 {
            print(t-i-1)
            self.managedObjectContext.delete(checks[i])
            
        }
        do {
            try self.managedObjectContext.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    @State var addIsActive = false
    //@State var list = [ChecklistItem(text: "Submit tax return"), ChecklistItem(text: "Call mom"), ChecklistItem(text: "Meditate"), ChecklistItem(text: "Buy hand sanitizer"),ChecklistItem(text: "add new")]
    var body: some View {
        //        Button(action: {
        //            let newCheck = Check(context: self.managedObjectContext)
        //            newCheck.id = UUID()
        //            newCheck.text = "racks"
        //            newCheck.checked = false
        //            do {
        //                try self.managedObjectContext.save()
        //            } catch {
        //                print(error.localizedDescription)
        //            }
        //            print(checks.count)
        //
        //        }) {
        //            Text("Press me")
        //        }
        ZStack {
            VStack(spacing: 0)  {
                Spacer().frame(height: 20)
                
                HStack {
                    Spacer().frame(width: 20)
                    
                    Text("Checklist").font(Font.custom(bold, size: 30)).multilineTextAlignment(.leading)
                    Spacer()
                    Button(action: {
                        notCompletable = true
                        print("Delete button tapped!")
                        deleteAllChecks()
                    }) {
                        Text("Complete")
                    }.disabled(notCompletable)
                    Spacer().frame(width: 20)
                }
                // Text("\(checks.count)")
                Spacer().frame(height: 20)
                Divider()
                
                List {
                    if (checks.count>0) {
                        ForEach(checks.indices, id:\.self) { i in
                            HStack {
                                if checks[i].checked == false {
                                    Image("Unchecked").resizable().scaledToFit().frame(height: 24).onTapGesture(count: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/, perform: {
                                        checks[i].checked = true
                                        if getNumChecked() == checks.count {
                                            notCompletable = false
                                        }
                                        do {
                                            try self.managedObjectContext.save()
                                        } catch {
                                            print(error.localizedDescription)
                                        }
                                        
                                    })
                                } else {
                                    Image("Checked").resizable().scaledToFit().frame(height: 24).onTapGesture(count: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/, perform: {
                                        checks[i].checked = false
                                        if getNumChecked() != checks.count {
                                            notCompletable = true
                                        }
                                        do {
                                            try self.managedObjectContext.save()
                                        } catch {
                                            print(error.localizedDescription)
                                        }
                                    })
                                }
                                
                                TextField(
                                    "",
                                    text: Binding<String>(
                                        get: { getText(i: i) },
                                        //  set: {currentText = $0}),
                                        set: {setAText(i: i, text: $0)}),
                                    onEditingChanged: { _ in print(i)
                                        addIsActive = false
                                        
                                        
                                    },
                                    onCommit: {
                                        print("COMMIT: \(currentText)")
                                        addIsActive = true
                                        
                                        print(checks.count)
                                        // delete if blank
                                        
                                        if getText(i: i).trimmingCharacters(in: .whitespacesAndNewlines) == "" {
                                            //print(i)
                                            self.managedObjectContext.delete(checks[i])
                                            
                                            do {
                                                try self.managedObjectContext.save()
                                            } catch {
                                                print(error.localizedDescription)
                                            }
                                            currentText = "Not set"
                                        } else {
                                            print("CURRENT: \(currentText)")
                                            //checks[i].text = String(getText(i: i))
                                            do {
                                                try self.managedObjectContext.save()
                                            } catch {
                                                print(error.localizedDescription)
                                            }
                                        }
                                    }
                                )
                                
                            }
                        }
                        .onDelete(perform: removeCheck)
                        
                        
                    }
                    HStack {
                        Image("Unchecked").resizable().scaledToFit().frame(height: 24)
                        //CustomTextField(text: $newText, isFirstResponder: addIsActive).scaledToFit()
                        TextField(
                            "Add to checklist",
                            text: $newText,
                            onEditingChanged: { _ in print("changed") },
                            onCommit: {
                                addIsActive = false
                                if newText.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
                                    let newCheck = Check(context: self.managedObjectContext)
                                    // Specify date components
                                    //                            var dateComponents = DateComponents()
                                    //                            dateComponents.year = 1980
                                    //                            dateComponents.month = 1
                                    //                            dateComponents.day = 1
                                    //                            dateComponents.timeZone = TimeZone(abbreviation: "JST") // Japan Standard Time
                                    //                            dateComponents.hour = 0
                                    //                            dateComponents.minute = 0
                                    //                            dateComponents.second = 0
                                    
                                    // Create date from components
                                    //                            let userCalendar = Calendar.current // user calendar
                                    //                            let someDateTime = userCalendar.date(from: dateComponents)
                                    //                            newCheck.timeAdded = someDateTime!
                                    newCheck.timeAdded = Date()
                                    // print(someDateTime!)
                                    
                                    newCheck.id = UUID()
                                    newCheck.text = newText
                                    newCheck.checked = false
                                    newText = ""
                                    print("commit")
                                    numChecks += 1
                                    //print(numChecks)
                                    do {
                                        try self.managedObjectContext.save()
                                    } catch {
                                        print(error.localizedDescription)
                                    }
                                } else {
                                    newText = ""
                                }
                            }
                        )
                        
                    }
                    
                    Spacer().frame(height: 0)
                }
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
                    //                .sheet(isPresented: $showOnboarding) {
                    //
                    //                    // Scenario #1: User has NOT completed app onboarding
                    //                    ChecklistOnboarding().onDisappear {
                    //                        print("info")
                    //                    }
                    //                }
                }
            }.onAppear {
                
                if getNumChecked() == checks.count && checks.count != 0 {
                    notCompletable = false
                }
                if needsAppOnboarding {
                    showOnboarding = true
                }  else {
                    showOnboarding = false
                }
                print("App needs: \(needsAppOnboarding)")
                print("Should show: \(showOnboarding)")
            }
            //        }.sheet(isPresented: $needsAppOnboarding) {
            //
            //            // Scenario #1: User has NOT completed app onboarding
            //            ChecklistOnboarding().onDisappear {
            //                print("app onboarding")
            //            }
            //        }
            
            // #2
            .onChange(of: needsAppOnboarding) { needsAppOnboarding in
                print("changed needsapponboarding")
                print(needsAppOnboarding)
                
            }.onChange(of: showOnboarding) { _ in
                needsAppOnboarding = false
            }.disabled(showOnboarding)
            /*
             .sheet(isPresented: $showOnboarding) {
             if needsAppOnboarding {
             ChecklistOnboarding().onDisappear {
             print("info")
             needsAppOnboarding = false
             }
             } else {
             // Scenario #1: User has NOT completed app onboarding
             ChecklistOnboarding().onDisappear {
             print("info")
             }
             }
             }.disabled(!show)
             */
            // }
            if showOnboarding {
                
                ZStack {
                    Color.black.opacity(0.4).ignoresSafeArea().onTapGesture(count: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/, perform: {
                        showOnboarding = false
                    })
                    RoundedRectangle(cornerRadius: 20).foregroundColor(.purple).frame(width: 300, height: 400)
                    RoundedRectangle(cornerRadius: 20).foregroundColor(.white).frame(width: 298, height: 398)
                    // ChecklistOnboarding().frame(width: 298, height: 398)
                    VStack()  {
                        Spacer().frame(height: 20)
                        
                        HStack {
                            Spacer().frame(width: 20)
                            ScrollView {
                                Text("Welcome to your daily checklist! You can set yourself daily goals, objectives, or anything you need to get done. It can be anything from doing your homework to being more grateful for your family, to filing your taxes. Just get it done!").font(Font.custom(book, size: 15)).multilineTextAlignment(.leading).frame(width: 260.0)
                                Spacer().frame(height: 20)
                                Text("When all items are checked, you can complete the list with the buttton on the top right.").font(Font.custom(book, size: 15)).multilineTextAlignment(.leading).frame(width: 260.0)
                                Spacer().frame(width: 20)
                                Text("You may be asking why you should do this. The answer to that question is that people are more satisfied, fulfilled, and happier when they complete their goals. Also, knowing what you need to do each day will reduce your anxiety, which we all know and hate. So keep a checklist!").font(Font.custom(book, size: 15)).multilineTextAlignment(.leading).frame(width: 260.0)
                                Spacer().frame(width: 20)
                                
                            }
                            Spacer().frame(width: 22)
                        }
                        /*
                         //Spacer()
                         HStack {
                         Spacer().frame(width: 20)
                         Text("Welcome to your daily checklist! You can set yourself daily goals, objectives, or anything you need to get done. It can be anything from doing your homework to being more grateful for your family, to filing your taxes. Just get it done!").font(Font.custom(book, size: 15)).multilineTextAlignment(.leading)
                         Spacer().frame(width: 20)
                         }
                         Spacer().frame(height: 20)
                         HStack {
                         Spacer().frame(width: 20)
                         Text("When all items are checked, you can complete the list with the buttton on the top right.").font(Font.custom(book, size: 15)).multilineTextAlignment(.leading)
                         Spacer().frame(width: 20)
                         }
                         */
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
        }
    }
}

struct Checklist_Previews: PreviewProvider {
    static var previews: some View {
        if #available(iOS 14.0, *) {
            Checklist()
        } else {
            // Fallback on earlier versions
        }
    }
}
