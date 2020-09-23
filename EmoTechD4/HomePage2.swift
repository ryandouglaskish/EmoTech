//
//  HomePage2.swift
//  EmoTechD4
//
//  Created by Ryan Kish on 9/10/20.
//  Copyright © 2020 Ryan Kish. All rights reserved.
//
/*
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

struct HomePage2: View {
    
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @FetchRequest(entity: RecentPick.entity(),
                  sortDescriptors: [])
    
    var recentPicks: FetchedResults<RecentPick>
    
    @State var inte = 1
    @State private var searchText = ""

    
    var body: some View {
        NavigationView {
            VStack {
                //VStack {
                    Text("here")
                    
                    Button(action: {
                        let newOrder = RecentPick(context: self.managedObjectContext)
                        newOrder.emotionName = String(self.inte)
                        self.inte = self.inte + 1
                        newOrder.id = UUID()
                        //print(self.recentPicks)
                        do {
                            try self.managedObjectContext.save()
                            print("Order saved.")
                            print(self.recentPicks.count)
                        } catch {
                            print(error.localizedDescription)
                        }
                    }) {
                        Text("Add Order")
                    }
                
                    ScrollView(.horizontal) {
                        HStack {
                            // TODO: implement search
                            ForEach(emotions.filter({searchText.isEmpty ? true: $0.emotion.lowercased().contains(searchText.lowercased()) })) { emotion in
                                NavigationLink(destination: DetailView(emotion: emotion)) {
                                    
                                    VStack {
                                        ZStack {
                                            Rectangle().fill(Color.white).scaledToFit().frame(height: 70)
                                            Image(emotion.emotion).resizable().scaledToFit().frame(width: 60)
                                            }.shadow(color: Color("ShadowBlue"), radius: 20, x: 1, y: 5).cornerRadius(10)
                                        
                                        Spacer().frame(height: 13)
                                        Text(emotion.emotion).font(Font.custom(book, size: 19))
                                    }.padding(.leading, 40)
                                    
                                    
                                }.lineSpacing(30)
                            }.buttonStyle(PlainButtonStyle())
                        }.frame(height: 190)
                    }
                    
                    
               // }
                
                
                
               // Divider()
                /*
                VStack {
                    HStack {
                        Spacer().frame(width: 20)
                        Text("Recent Picks").font(Font.custom(book, size: 30))
                        Spacer()
                    }
                    
                    ZStack {
                        Rectangle().fill(Color("EmoWhite")).cornerRadius(20).shadow(color: Color("ShadowBlue"), radius: 20, x: 1, y: 5)
                        
                        HStack {
                            Spacer().frame(width: 30)
                            Text(recentPicks[0].emotionName).font(Font.custom(book, size: 20))
                            Spacer()
                            VStack {
                                Spacer()
                                Image("OrangeBust").resizable().scaledToFit()
                            }
                            Spacer().frame(width: 40)
                            
                        }
                    }.padding(.bottom, 30).padding(.horizontal, 20)
                    ZStack {
                        Rectangle().fill(Color("EmoWhite")).cornerRadius(20).shadow(color: Color("ShadowBlue"), radius: 20, x: 1, y: 5)
                        
                        HStack {
                            Spacer().frame(width: 30)
                            Text(recentPicks[1].emotionName).font(Font.custom(book, size: 20))
                            Spacer()
                            VStack {
                                Spacer()
                                Image("PinkBust").resizable().scaledToFit()
                            }
                            Spacer().frame(width: 40)
                            
                        }
                    }.padding(.bottom, 30).padding(.horizontal, 20)
                } // Recent Picks VStack
                */
                
                
            }.navigationBarTitle("Choose an Emotion", displayMode: .inline).background(Color.clear).background(NavigationConfigurator { nc in
                            
                            
                            nc.navigationBar.barTintColor = .emoWhite
                            nc.navigationBar.titleTextAttributes = [.foregroundColor : UIColor.black, NSAttributedString.Key.font: UIFont(name: "CircularStd-Bold", size: 35)!]
            //                nc.navigationBar.addSubview(UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 1000)))
            //                //nc.navigationController?.view = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 1000))
                            
                            
                            
                            nc.navigationBar.barStyle = .black
                        }) // Full VStack
        }.navigationViewStyle(StackNavigationViewStyle()) // Navigation View
        
    }
}

struct HomePage2_Previews: PreviewProvider {
    static var previews: some View {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        return HomePage2().environment(\.managedObjectContext, context)
    }
}

*/
