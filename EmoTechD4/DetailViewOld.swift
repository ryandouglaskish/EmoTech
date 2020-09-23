//
//  DetailView.swift
//  EmoTechD4
//
//  Created by Ryan Kish on 7/17/20.
//  Copyright © 2020 Ryan Kish. All rights reserved.
//

import SwiftUI



struct DetailViewOld: View {
    
    var emotion: Emotion
    
    @State var toShow = [false, false, false]
    
    var body: some View {
        //Text(emotions[0].emotion)
        
        ZStack {
            Rectangle().fill(Color("EmoWhite"))

        VStack {
            Text("\(emotion.emotion) Tips")
                .font(.system(size: 40, weight: .black, design: .rounded))
            
            
            ForEach(0..<emotion.tips.count, id: \.self) { i in
                ZStack {
                    Rectangle().fill(Color.white)
                        .cornerRadius(8)
                        .shadow(color: .gray, radius: 3, x: 1, y: 1)
                    
                    VStack{
                        HStack {
                            VStack(alignment: .leading) {
                                //Text(self.emotion.tips[i].title).bold()
                                Text("Expand").font(.subheadline)
                            }.padding(15).foregroundColor(Color.black)
                            Spacer()
                        }
                        
                        if self.toShow[i] {
                            Spacer().frame(height: 2)
                            //Text("\(self.emotion.tips[i].text)").padding(15)
                            //Spacer()
                            
                        }
                    }
                }.onTapGesture {
                    withAnimation {
                        if self.toShow[i] == true {
                            self.toShow[i] = false
                        } else {
                            
                            if self.toShow.filter({$0}).count != 0 {
                            for i in 0..<self.toShow.count {
                                self.toShow[i] = false
                            }
                            }
                        
                        self.toShow[i].toggle()
                        }
                            
//                        print("tapped \(self.emotion.tips[i].title)")
//                        self.emotion.tips[i].cellExpanded = !self.emotion.tips[i].cellExpanded
//                        print("\(self.emotion.tips[i].cellExpanded)")
                    }
                }
            }
            //            VStack {
            //                Text("Listen to the curated happiness playlist to lift your vibe")
            //            HStack {
            //                Image("Album").resizable().frame(width: 100.0, height: 100.0)
            //                Text("Happiness Playlist")
            //            }
            //                HStack {
            //                    Image("Spotify").resizable().frame(width: 150, height: 100)
            //                    Spacer()
            //                }
            //            }
            
        }
        }
    }
}

struct DetailViewOld_Previews: PreviewProvider {
    static var previews: some View {
        DetailViewOld(emotion: emotions[0])
    }
}

