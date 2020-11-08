//
//  HomePage2.swift
//  EmoTechD4
//
//  Created by Ryan Kish on 11/6/20.
//  Copyright © 2020 Ryan Kish. All rights reserved.
//

import SwiftUI

struct HomePage2: View {
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
    
    @State var recentPickOneMood = "Positive"
    @State var recentPickTwoMood = "Positive"

    @State var recentPickOneIndex = 0
    @State var recentPickTwoIndex = 1
    
    let range: Range<Int> = 0..<10
    
    
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                VStack(spacing: 0) {
                    SearchBar(text: $searchText).padding(.horizontal, 20).frame(height: 50)
                   // Spacer().frame(height: 10)
                    ScrollView(.horizontal) {
                        VStack {
                            Spacer().frame(height: geometry.size.height / 40.8)
                        HStack {
                            ForEach(emotions.filter({searchText.isEmpty ? true: $0.emotion.lowercased().contains(searchText.lowercased()) })) { emotion in
                                VStack {
                                    NavigationLink(destination: DetailView(emotionName: emotion.emotion, tip: tipText, length: emotion.spotifyLength, link: emotion.spotify), tag: emotion.emotion, selection: self.$selection) {
                                        Rectangle().frame(width: 0, height: 0)
                                        
                                    }.lineSpacing(30) // Nav link
                                    Button(action: {
                                        self.selection = emotion.emotion
                                             print(geometry.size.height)
                                       
                                        
                                        if first_click {
                                            order = 0
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
                                        
                                        tipText = emotion.nextTip()

                                        let recentPick = RecentPick(context: self.managedObjectContext)
                                        recentPick.added = order
                                        order = order+1
                                        recentPick.emotionName = emotion.emotion
                                        recentPick.id = UUID()
                                        recentPick.mood = emotion.mood
                                        recentPick.spotifyLength = emotion.spotifyLength

                                        recentPick.tip = tipText
                                        
                                        recentPick.spotify = emotion.spotify
                                      
                                        var prev_emotion_one = ""
                                        if self.recentPicks.count > 1 {
                                            prev_emotion_one = self.recentPicks[0].emotionName
                                        }
                                        
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
                                        
                                        if (self.recentPicks.count > 1) {
                                            if (self.recentPicks[0].emotionName == prev_emotion_one) {
                                                recentPickOneIndex += 1

                                            } else {
                                                recentPickTwoIndex = recentPickOneIndex
                                                recentPickOneIndex += 1

                                            }
                                            recentPickOneMood = self.recentPicks[0].mood
                                            recentPickTwoMood = self.recentPicks[1].mood
                                        }
      
                                        
                                        
                                    }, label: {
                                        VStack {
                                            ZStack {
                                                Rectangle().fill(Color.white).scaledToFit().frame(height: geometry.size.height * 0.145).cornerRadius(12).shadow(color: Color("ShadowBlue"), radius: 15, x: 1, y: 10)
                                                Image(emotion.emotion).resizable().scaledToFit().frame(height: geometry.size.height * 0.13)
                                            }
                                            
                                            Spacer().frame(height: 13)
                                            Text(emotion.emotion).font(Font.custom(book, size: 19))
                                        }.padding(.leading, 40)
                                    })
                                    
//                                    Rectangle().fill(Color.green).frame(width: geometry.size.height * 0.15, height: geometry.size.height * 0.15)
//                                    Text(emotion.emotion).font(Font.custom(book, size: 19))
                                }
                            }.buttonStyle(PlainButtonStyle()) // For Each
                        }
                            Spacer().frame(height: geometry.size.height / 40.8)
                        }
                    }.frame(height: geometry.size.height * 0.25)
                    Spacer()
                    
                    HStack {
                        Spacer().frame(width: 20)
                        Text("Recent Picks").font(Font.custom(book, size: 30))
                        Spacer()
                    }
                    VStack {
                    Spacer().frame(height: 20)
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
                            NavigationLink(destination: DetailView(emotionName: self.recentPicks[0].emotionName, tip: self.recentPicks[0].tip, length: self.recentPicks[0].spotifyLength, link: self.recentPicks[0].spotify), isActive: self.$recentOne, label:  {
                                Rectangle().frame(width: 0, height: 0)
                            })
                            
                            // BUTTON
                            Button(action:
                                    {
                                        self.recentOne = true
                                        
                                    }, label: {
                                        ZStack {
                                            Rectangle().fill(Color("EmoWhite")).cornerRadius(20).shadow(color: Color("ShadowBlue"), radius: 20, x: 1, y: 5).frame(height: geometry.size.height * 0.21)
                                            
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
                                                        Text(recentPicks[0].spotifyLength + " Hours").font(Font.custom(book, size: 13)).foregroundColor(Color("Orange"))
                                                        Spacer()
                                                    }
                                                }
                                                Spacer()
                                                VStack {
                                                    Spacer()
                                                    if (!first_click) {
                                                        if (recentPickOneMood=="Positive") {
                                                            Image(positiveCharacters[recentPickOneIndex%positiveCharacters.count]).resizable().scaledToFit()//.frame(height: geometry.size.height * 0.18)
                                                        } else {
                                                            Image(negativeCharacters[recentPickOneIndex%negativeCharacters.count]).resizable().scaledToFit()//.frame(height: geometry.size.height * 0.18)
                                                        }
                                                    } else {
                                                        if (recentPicks[0].mood=="Positive") {
                                                            Image(positiveCharacters[recentPickOneIndex%positiveCharacters.count]).resizable().scaledToFit()//.frame(height: geometry.size.height * 0.18)
                                                        } else {
                                                            Image(negativeCharacters[recentPickOneIndex%negativeCharacters.count]).resizable().scaledToFit()//.frame(height: geometry.size.height * 0.18)
                                                        }
                                                    }
                                                }.frame(height: geometry.size.height * 0.21)
                                                Spacer().frame(width: 40)
                                                
                                            }
                                        }.padding(.horizontal, 20) //.padding(.bottom, 30)
                                        
                                        
                                    })
                        
                        }.buttonStyle(PlainButtonStyle())
                        if self.recentPicks.count > 1 {
                            VStack {
                                NavigationLink(destination: DetailView(emotionName: self.recentPicks[1].emotionName, tip: self.recentPicks[1].tip, length: self.recentPicks[1].spotifyLength, link: self.recentPicks[1].spotify), isActive: self.$recentTwo, label:  {
                                    Rectangle().frame(width: 0, height: 0)
                                })
                                
                                Button(action:
                                        {
                                            self.recentTwo = true
                                            
                                        }, label: {
                                            ZStack {
                                                Rectangle().fill(Color("EmoWhite")).cornerRadius(20).shadow(color: Color("ShadowBlue"), radius: 20, x: 1, y: 5).frame(height: geometry.size.height * 0.21)
                                                
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
                                                            Text(recentPicks[1].spotifyLength + " Hours").font(Font.custom(book, size: 13)).foregroundColor(Color("Orange"))
                                                            Spacer()
                                                        }
                                                    }
                                                    Spacer()
                                                    VStack {
                                                        Spacer()
                                                        if (!first_click) {

                                                            if (recentPickTwoMood=="Positive") {
                                                                Image(positiveCharacters[recentPickTwoIndex%positiveCharacters.count]).resizable().scaledToFit()
                                                            } else {
                                                                Image(negativeCharacters[recentPickTwoIndex%negativeCharacters.count]).resizable().scaledToFit()
                                                            }
                                                        } else {
                                                            if (recentPicks[1].mood=="Positive") {
                                                                Image(positiveCharacters[recentPickTwoIndex%positiveCharacters.count]).resizable().scaledToFit()
                                                            } else {
                                                                Image(negativeCharacters[recentPickTwoIndex%negativeCharacters.count]).resizable().scaledToFit()
                                                            }
                                                        }
                                                    }
                                                    Spacer().frame(width: 40)
                                                    
                                                }
                                            }.padding(.horizontal, 20) // .padding(.bottom, 30)
                                            
                                            
                                        })
                                
                            }.buttonStyle(PlainButtonStyle())
                            Spacer().frame(height: 30)
                        }
                        
                    }
                    
//                    Rectangle().frame(height: geometry.size.height * 0.22)
//                    Spacer().frame(height: 20)
//                    Rectangle().frame(height: geometry.size.height * 0.22)
                    }.frame(height: geometry.size.height * 0.5)
                    Spacer().frame(height: 20)
                    //Rectangle().fill(
                    
                }
            }.navigationBarTitle("Choose an Emotion", displayMode: .large).background(Color.clear).ignoresSafeArea(.keyboard, edges: .bottom)
        }.navigationViewStyle(StackNavigationViewStyle())
        
    }
}

struct HomePage2_Previews: PreviewProvider {
    static var previews: some View {
        HomePage2()
    }
}
