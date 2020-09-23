//
//  ContentView.swift
//  EmoTechD4
//
//  Created by Ryan Kish on 7/11/20.
//  Copyright © 2020 Ryan Kish. All rights reserved.
//

import SwiftUI

import UIKit

//let fontName = "Avenir"




extension Color {
    static let emoWhite = Color(hue: 0.153, saturation: 0.01, brightness: 0.999)
}

extension UIColor {
//static var emoPurple = UIColor(red: 232/255, green: 68/255, blue: 133/255, alpha: 1)
    static var emoWhite = UIColor(hue: 0.153, saturation: 0.01, brightness: 0.999, alpha: 1.0)
}

struct ContentView: View {

    @State private var searchText = ""
    let recentEmotions = emotions[0...2]

    let cellPadding: CGFloat = 20.0
    var body: some View {
        //Text(emotions[0].emotion)
        ZStack {
            Color.emoWhite.edgesIgnoringSafeArea(.all)


        NavigationView {
            ZStack {
            Color.emoWhite.edgesIgnoringSafeArea(.all)

                VStack(spacing: 20) {
//                    VStack {
//                        Text("Recent Picks")
//                        List(recentEmotions) { emotion in
//                            Text(emotion.emotion)
//                        }
//
//                    }
                //                .font(.system(size: 40, weight: .black, design: .rounded))

                    SearchBar(text: $searchText).padding(.horizontal, 20)
                    //.padding(.top, 0)

                    ScrollView() {
                    ForEach(emotions.filter({searchText.isEmpty ? true: $0.emotion.lowercased().contains(searchText.lowercased()) })) { emotion in
                //ForEach(emotions.filter({ $0.emotion.contains(searchText) })) { emotion in

//                    NavigationLink(destination: DetailView(emotion: emotion)) {
//                        ZStack {
//                            Rectangle().fill(Color.emoWhite)
//                                .cornerRadius(8).padding(.horizontal, self.cellPadding)
//                                .shadow(color: .gray, radius: 3, x: 1, y: 1)
//                                .brightness(0.0).blur(radius: 0.0)
//                            //List(0..<emotions.count) { i in
//                            //Image(systemName: "TesterImage")
//                            HStack {
//                                //VStack(alignment: .leading) {
//                                HStack {
//                                    Text(emotion.emotion).bold().font(.custom(fontName, size: 20))
//                                    Spacer()
//                                    ZStack {
//                                        Rectangle()
//                                            .fill(Color(hue: 0.698, saturation: 0.317, brightness: 1.0)) .frame(width: 100.0)
//                                            .cornerRadius(8)
//                                        Text("See tips").font(.custom(fontName, size: 16)).padding(5)
//                                    }
//                                }.padding(25).foregroundColor(Color.black)
//                                Spacer()
//                            }.padding(.horizontal, self.cellPadding)
//                        }.padding(.vertical, 8)
//                    }.labelsHidden()
                }.background(Color.clear)
                    .onAppear {
                   // UITableView.appearance().separatorStyle = .none
                }
                }


            }
                // below: //.navigationBarHidden(true
            }.navigationBarTitle("Choose an Emotion", displayMode: .inline).background(Color.clear).background(NavigationConfigurator { nc in


            nc.navigationBar.barTintColor = .emoWhite
                nc.navigationBar.titleTextAttributes = [.foregroundColor : UIColor.black, NSAttributedString.Key.font: UIFont(name: fontName, size: 20)!]
                nc.navigationBar.barStyle = .black
//                let image: UIImage = UIImage(named: "owl")!
//                let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
//                imageView.contentMode = .scaleAspectFit
//                imageView.image = image
//                nc.navigationItem.titleView = UIImageView.init(image: UIImage(named:"twitter"))


            })


//            .navigationBarItems(leading: Button(action: { }) {
//                HStack {
//                    Image(systemName: "arrow.left")
//                    Text("Back")
//                }
//            })
            //}.background(Color.red)
        }.accentColor(Color.purple).navigationViewStyle(StackNavigationViewStyle())
        }

    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
