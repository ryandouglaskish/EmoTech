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
   
    
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @FetchRequest(entity: Check.entity(),
                  sortDescriptors: [NSSortDescriptor(key: "timeAdded", ascending: true)])
    var checks: FetchedResults<Check>
    
    
    @State var newText: String = ""
    
    @State var numChecks = 0
    
    @State var show = true
    @State var currentText = "Not set"
    
    @State var notCompletable = true
    
    
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
            self.managedObjectContext.delete(checks[i])
            
        }
        do {
            try self.managedObjectContext.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    @State var addIsActive = false
   
    var body: some View {
  
        ZStack {
            VStack(spacing: 0)  {
                Spacer().frame(height: 20)
                
                HStack {
                    Spacer().frame(width: 20)
                    
                    Text("Checklist").font(Font.custom(bold, size: 30)).multilineTextAlignment(.leading)
                    Spacer()
                    Button(action: {
                        notCompletable = true
                        //print("Delete button tapped!")
                        deleteAllChecks()
                    }) {
                        Text("Complete")
                    }.disabled(notCompletable)
                    Spacer().frame(width: 20)
                }
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
                                    onEditingChanged: { _ in
                                        addIsActive = false
                                        
                                        
                                    },
                                    onCommit: {
                                        addIsActive = true
                                                                                
                                        if getText(i: i).trimmingCharacters(in: .whitespacesAndNewlines) == "" {
                                            self.managedObjectContext.delete(checks[i])
                                            
                                            do {
                                                try self.managedObjectContext.save()
                                            } catch {
                                                print(error.localizedDescription)
                                            }
                                            currentText = "Not set"
                                        } else {
                                            //print("CURRENT: \(currentText)")
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
                     
                        TextField(
                            "Add to checklist",
                            text: $newText,
                            onEditingChanged: { _ in  },
                            onCommit: {
                                addIsActive = false
                                if newText.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
                                    let newCheck = Check(context: self.managedObjectContext)
                                    
                                    newCheck.timeAdded = Date()
                                    newCheck.id = UUID()
                                    newCheck.text = newText
                                    newCheck.checked = false
                                    newText = ""
                                    numChecks += 1
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
                            //print("showOnboarding is now: \(showOnboarding)")
                            
                        }) {
                            Image("Info")
                        }
                        Spacer().frame(width: 20)
                    }
                    
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
//                print("App needs: \(needsAppOnboarding)")
//                print("Should show: \(showOnboarding)")
            }
            .onChange(of: needsAppOnboarding) { needsAppOnboarding in
//                print("changed needsapponboarding")
//                print(needsAppOnboarding)
                
            }.onChange(of: showOnboarding) { _ in
                needsAppOnboarding = false
            }.disabled(showOnboarding)
            if showOnboarding {
                
                ZStack {
                    Color.black.opacity(0.4).ignoresSafeArea().onTapGesture(count: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/, perform: {
                        showOnboarding = false
                    })
                    RoundedRectangle(cornerRadius: 20).foregroundColor(.purple).frame(width: 300, height: 400)
                    RoundedRectangle(cornerRadius: 20).foregroundColor(.white).frame(width: 298, height: 398)
                    VStack()  {
                        Spacer().frame(height: 20)
                        
                        HStack {
                            Spacer().frame(width: 20)
                            ScrollView {
                                Text("Welcome to your daily checklist! You can set yourself daily goals, objectives, or anything you need to get done. It can be anything from doing your homework to being more grateful for your family, to filing your taxes. Just get it done!").font(Font.custom(book, size: 15)).multilineTextAlignment(.leading).frame(width: 260.0).lineLimit(nil)
                                Spacer().frame(height: 20)
                                Text("When all items are checked, you can complete the list with the buttton on the top right.").font(Font.custom(book, size: 15)).multilineTextAlignment(.leading).frame(width: 260.0).lineLimit(nil)
                                Spacer().frame(width: 20)
                                Text("You may be asking why you should do this. The answer to that question is that people are more satisfied, fulfilled, and happier when they complete their goals. Also, knowing what you need to do each day will reduce your anxiety, which we all know and hate. So keep a checklist!").font(Font.custom(book, size: 15)).multilineTextAlignment(.leading).frame(width: 260.0).lineLimit(nil)
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
        }.ignoresSafeArea(.keyboard)
    }
}

struct ChecklistOldOS: View {
    @State var showOnboarding: Bool = false
   
    
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @FetchRequest(entity: Check.entity(),
                  sortDescriptors: [NSSortDescriptor(key: "timeAdded", ascending: true)])
    var checks: FetchedResults<Check>
    
    
    @State var newText: String = ""
    
    @State var numChecks = 0
    
    @State var show = true
    @State var currentText = "Not set"
    
    @State var notCompletable = true
    
    
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
            self.managedObjectContext.delete(checks[i])
            
        }
        do {
            try self.managedObjectContext.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    @State var addIsActive = false
   
    var body: some View {
  
        ZStack {
            VStack(spacing: 0)  {
                Spacer().frame(height: 20)
                
                HStack {
                    Spacer().frame(width: 20)
                    
                    Text("Checklist").font(Font.custom(bold, size: 30)).multilineTextAlignment(.leading)
                    Spacer()
                    Button(action: {
                        notCompletable = true
                        //print("Delete button tapped!")
                        deleteAllChecks()
                    }) {
                        Text("Complete")
                    }.disabled(notCompletable)
                    Spacer().frame(width: 20)
                }
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
                                    onEditingChanged: { _ in
                                        addIsActive = false
                                        
                                        
                                    },
                                    onCommit: {
                                        addIsActive = true
                                                                                
                                        if getText(i: i).trimmingCharacters(in: .whitespacesAndNewlines) == "" {
                                            self.managedObjectContext.delete(checks[i])
                                            
                                            do {
                                                try self.managedObjectContext.save()
                                            } catch {
                                                print(error.localizedDescription)
                                            }
                                            currentText = "Not set"
                                        } else {
                                            //print("CURRENT: \(currentText)")
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
                     
                        TextField(
                            "Add to checklist",
                            text: $newText,
                            onEditingChanged: { _ in  },
                            onCommit: {
                                addIsActive = false
                                if newText.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
                                    let newCheck = Check(context: self.managedObjectContext)
                                    
                                    newCheck.timeAdded = Date()
                                    newCheck.id = UUID()
                                    newCheck.text = newText
                                    newCheck.checked = false
                                    newText = ""
                                    numChecks += 1
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
                            //print("showOnboarding is now: \(showOnboarding)")
                            
                        }) {
                            Image("Info")
                        }
                        Spacer().frame(width: 20)
                    }
                    
                }
            }.onAppear {
                
                if getNumChecked() == checks.count && checks.count != 0 {
                    notCompletable = false
                }
                
//                print("App needs: \(needsAppOnboarding)")
//                print("Should show: \(showOnboarding)")
            }.disabled(showOnboarding)
            if showOnboarding {
                
                ZStack {
                    Color.black.opacity(0.4).onTapGesture(count: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/, perform: {
                        showOnboarding = false
                    })
                    RoundedRectangle(cornerRadius: 20).foregroundColor(.purple).frame(width: 300, height: 400)
                    RoundedRectangle(cornerRadius: 20).foregroundColor(.white).frame(width: 298, height: 398)
                    VStack()  {
                        Spacer().frame(height: 20)
                        
                        HStack {
                            Spacer().frame(width: 20)
                            ScrollView {
                                Text("Welcome to your daily checklist! You can set yourself daily goals, objectives, or anything you need to get done. It can be anything from doing your homework to being more grateful for your family, to filing your taxes. Just get it done!").font(Font.custom(book, size: 15)).multilineTextAlignment(.leading).frame(width: 260.0).lineLimit(nil)
                                Spacer().frame(height: 20)
                                Text("When all items are checked, you can complete the list with the buttton on the top right.").font(Font.custom(book, size: 15)).multilineTextAlignment(.leading).frame(width: 260.0).lineLimit(nil)
                                Spacer().frame(width: 20)
                                Text("You may be asking why you should do this. The answer to that question is that people are more satisfied, fulfilled, and happier when they complete their goals. Also, knowing what you need to do each day will reduce your anxiety, which we all know and hate. So keep a checklist!").font(Font.custom(book, size: 15)).multilineTextAlignment(.leading).frame(width: 260.0).lineLimit(nil)
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
        }
    }
}

//struct Checklist_Previews: PreviewProvider {
//    static var previews: some View {
//        //Checklist()
////        if #available(iOS 14.0, *) {
////            Checklist()
////        } else {
////            // Fallback on earlier versions
////        }
//    }
//}
