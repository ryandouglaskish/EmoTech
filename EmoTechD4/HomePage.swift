//
//  HomePage.swift
//  EmoTechD4
//
//  Created by Ryan Kish on 9/6/20.
//  Copyright © 2020 Ryan Kish. All rights reserved.
//

import SwiftUI
import CoreData



let book = "CircularStd-Book"
let bold = "CircularStd-Bold"


struct NavigationConfigurator: UIViewControllerRepresentable {
    var configure: (UINavigationController) -> Void = { _ in }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<NavigationConfigurator>) -> UIViewController {
        UIViewController()
    }
    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<NavigationConfigurator>) {
        if let nc = uiViewController.navigationController {
            self.configure(nc)
        }
    }
}



struct HomePage: View {
    
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @FetchRequest(entity: RecentPick.entity(),
                  sortDescriptors: [NSSortDescriptor(key: "added", ascending: false)])
    var recentPicks: FetchedResults<RecentPick>
    
    @State private var selection: String? = nil
    
    @State var tipText = ""
        
    @State private var searchText = ""
    
    @State private var recentOne = false
    @State private var recentTwo = false
    
    @State var first_click = true
    
    var body: some View {
        
        NavigationView {
            VStack(alignment: .leading) {
                Spacer().frame(height: 10)
                
                VStack {
                   // Text(String(order))
                    //Text(String(recentPicks[0].added))

                    SearchBar(text: $searchText).padding(.horizontal, 20)
                    ScrollView(.horizontal) {
                        HStack {
                            
                            
                            ForEach(emotions.filter({searchText.isEmpty ? true: $0.emotion.lowercased().contains(searchText.lowercased()) })) { emotion in
                                
                                VStack {
                                    NavigationLink(destination: DetailView(emotionName: emotion.emotion, tip: tipText), tag: emotion.emotion, selection: self.$selection) {
                                        Rectangle().frame(width: 0, height: 0)
                                        
                                    }.lineSpacing(30) // Nav link
                                    
                                    Button(action: {
                                    
                                        if first_click {
                                            order = 0
                                           // print(first_click)
                                            first_click = false
                                            if (recentPicks.count == 1) {
                                                order = 1
                                                recentPicks[0].added = 0
                                            } else if (recentPicks.count == 2) {
                                                order = 2
                                                recentPicks[0].added = 1
                                                recentPicks[1].added = 0
                                            }
                                        }
                                        //print(order)
                                        
                                        
                                        tipText = emotion.nextTip()
                                        print(tipText)
                                        //print("TOP:" + String(self.recentPicks.count))
                                        self.selection = emotion.emotion
                                        let recentPick = RecentPick(context: self.managedObjectContext)
                                        recentPick.added = order
                                        order = order+1
                                        recentPick.emotionName = emotion.emotion
                                        recentPick.id = UUID()
                                        //print(emotion.tips)
                                        recentPick.tip = tipText
                                        //recentPick.tipDescriptions = emotion.tips
                                        recentPick.spotify = emotion.spotify
                                      

                                        if (self.recentPicks.count == 0) { // None -> add
                                            do {
                                                try self.managedObjectContext.save()
                                            } catch {
                                                print(error.localizedDescription)
                                            }
                                        } else if (self.recentPicks[0].emotionName == emotion.emotion) { // Same as first -> replacce
                                            self.managedObjectContext.delete(self.recentPicks[0])
                                            do {
                                                try self.managedObjectContext.save()
                                            } catch {
                                                print(error.localizedDescription)
                                            }
                                        } else if (recentPicks.count == 1) { // Just one -> add
                                            do {
                                                try self.managedObjectContext.save()
                                            } catch {
                                                print(error.localizedDescription)
                                            }
                                        } else if (self.recentPicks[1].emotionName == emotion.emotion) { // Same as second -> replace second
                                            self.managedObjectContext.delete(self.recentPicks[1])
                                            do {
                                                try self.managedObjectContext.save()
                                            } catch {
                                                print(error.localizedDescription)
                                            }
                                        } else { // Normal -> delete ind 1 and add
                                            do {
                                                self.managedObjectContext.delete(self.recentPicks[1]) // delete the one below the current [0]
                                                try self.managedObjectContext.save()
                                            } catch {
                                                print(error.localizedDescription)
                                            }
                                        }
                                        
                                        //self.recentPicks.sorted(by: order)
                                       // print(self.recentPicks.count)
//                                        print("========")
//                                        print(self.recentPicks[0].added)
//                                        print(self.recentPicks[1].added)
//                                        print("========")
//
                                    }, label: {
                                        VStack {
                                            ZStack {
                                                Rectangle().fill(Color.white).scaledToFit().frame(height: 70).cornerRadius(10).shadow(color: Color("ShadowBlue"), radius: 30, x: 1, y: 5)
                                                Image(emotion.emotion).resizable().scaledToFit().frame(height: 60)
                                            }
                                            
                                            Spacer().frame(height: 13)
                                            Text(emotion.emotion).font(Font.custom(book, size: 19))
                                        }.padding(.leading, 40)
                                    })
                                }
                            }.buttonStyle(PlainButtonStyle()) // For Each
                        }.frame(height: 190).padding(.trailing, 30) // HStack
                    } // Scroll View
                    Spacer().frame(height: 10)
                }
                
                Divider()
                
                
                VStack {
                    HStack {
                        Spacer().frame(width: 20)
                        Text("Recent Picks").font(Font.custom(book, size: 30))
                        Spacer()
                    }
                    if recentPicks.isEmpty {
                        VStack {
                            Spacer()
                            ZStack {
                                Text("You haven't found tips for any emotions yet").font(Font.custom(book, size: 20))
                                
                            }.padding(.horizontal, 20) //.padding(.bottom, 30)
                            Spacer()
                        }
                    } else {
                        
                        
                        VStack {
                            NavigationLink(destination: DetailView(emotionName: self.recentPicks[0].emotionName, tip: self.recentPicks[0].tip), isActive: self.$recentOne, label:  {
                                Rectangle().frame(width: 0, height: 0)
                            })
                            
                            
                            
                            Button(action:
                                    {
                                        self.recentOne = true
                                        //print("recentOne pressed.")
                                        
                                    }, label: {
                                        ZStack {
                                            Rectangle().fill(Color("EmoWhite")).cornerRadius(20).shadow(color: Color("ShadowBlue"), radius: 20, x: 1, y: 5)
                                            
                                            HStack {
                                                Spacer().frame(width: 30)
                                                VStack {
                                                    HStack {
                                                        Text(recentPicks[0].emotionName).font(Font.custom(book, size: 20))
                                                        Spacer()
                                                    }
                                                    Spacer().frame(height: 5)
                                                    HStack {
                                                        Image("Clock").resizable().scaledToFit().frame(height: 11)
                                                        Spacer().frame(width: 4)
                                                        Text("4 Hours").font(Font.custom(book, size: 11)).foregroundColor(Color("Orange"))
                                                        Spacer()
                                                    }
                                                }
                                                Spacer()
                                                VStack {
                                                    Spacer()
                                                    Image("OrangeBust").resizable().scaledToFit()
                                                }
                                                Spacer().frame(width: 40)
                                                
                                            }
                                        }.padding(.horizontal, 20) //.padding(.bottom, 30)
                                        
                                        
                                    })
                            
                        }.buttonStyle(PlainButtonStyle())
                        
                        if self.recentPicks.count > 1 {
                            VStack {
                                NavigationLink(destination: DetailView(emotionName: self.recentPicks[1].emotionName, tip: self.recentPicks[1].tip), isActive: self.$recentTwo, label:  {
                                    Rectangle().frame(width: 0, height: 0)
                                })
                                
                                Button(action:
                                        {
                                            self.recentTwo = true
                                            //print("recentTwo pressed.")
                                            
                                        }, label: {
                                            ZStack {
                                                Rectangle().fill(Color("EmoWhite")).cornerRadius(20).shadow(color: Color("ShadowBlue"), radius: 20, x: 1, y: 5)
                                                
                                                HStack {
                                                    Spacer().frame(width: 30)
                                                    VStack {
                                                        HStack {
                                                            Text(recentPicks[1].emotionName).font(Font.custom(book, size: 20))
                                                            Spacer()
                                                        }
                                                        Spacer().frame(height: 5)
                                                        HStack {
                                                            Image("Clock").resizable().scaledToFit().frame(height: 11)
                                                            Spacer().frame(width: 4)
                                                            Text("4 Hours").font(Font.custom(book, size: 11)).foregroundColor(Color("Orange"))
                                                            Spacer()
                                                        }
                                                    }
                                                    Spacer()
                                                    VStack {
                                                        Spacer()
                                                        Image("PinkBust").resizable().scaledToFit()
                                                    }
                                                    Spacer().frame(width: 40)
                                                    
                                                }
                                            }.padding(.horizontal, 20) // .padding(.bottom, 30)
                                            
                                            
                                        })
                                
                            }.buttonStyle(PlainButtonStyle())
                            Spacer().frame(height: 30)
                        }
                        
                        
                    }
                    
                }
                
                
            }.navigationBarTitle("Choose an Emotion", displayMode: .large).background(Color.clear)
            
            
            
            
            // below is navigation controller
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

//struct HomePage_Previews: PreviewProvider {
//    static var previews: some View {
////        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//       // return HomePage().environment(\.managedObjectContext, context)
//    }
//}



