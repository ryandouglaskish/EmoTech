//
//  test.swift
//  EmoTechD4
//
//  Created by Ryan Kish on 9/10/20.
//  Copyright © 2020 Ryan Kish. All rights reserved.
//

import SwiftUI

struct test: View {
    @State private var searchText = ""
    
    var body: some View {
        VStack {
            // Text("More Emotions").font(Font.custom(book, size: 27))
            SearchBar(text: $searchText).padding(.horizontal, 20)
            ScrollView(.horizontal) {
                HStack {
                    // TODO: implement search
                    ForEach(emotions.filter({searchText.isEmpty ? true: $0.emotion.lowercased().contains(searchText.lowercased()) })) { emotion in
//                        NavigationLink(destination: DetailView(emotion: emotion)) {
//                            Button(action: {
//                                print("order s")
//                            }, label: {
//                                VStack {
//                                    ZStack {
//                                        Rectangle().fill(Color.white).scaledToFit().frame(height: 70)
//                                        Image(emotion.emotion).resizable().scaledToFit().frame(width: 60)
//                                    }.shadow(color: Color("ShadowBlue"), radius: 20, x: 1, y: 5).cornerRadius(10)
//                                    
//                                    Spacer().frame(height: 13)
//                                    Text(emotion.emotion).font(Font.custom(book, size: 19))
//                                }.padding(.leading, 40)
//                            })
//                        
//                            
//                            
//                            
//                        }.lineSpacing(30) // Navlink
                        
                        
                        
                        
                    }.buttonStyle(PlainButtonStyle())
                }.frame(height: 190)
            }
            Spacer().frame(height: 10)
        }
    }
}

struct test_Previews: PreviewProvider {
    static var previews: some View {
        test()
    }
}
