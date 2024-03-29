//
//  SearchBar.swift
//  EmoTechD4
//
//  Created by Ryan Kish on 7/17/20.
//  Copyright © 2020 Ryan Kish. All rights reserved.
//

import SwiftUI

let fontName = "Avenir"

//struct SearchBar: View {
//    @Binding var text: String
//
//    @State private var isEditing = false
//
//    var body: some View {
//        VStack {
//            Spacer()
//        HStack {
//
//            TextField("Search for an emotion...", text: $text).font(.custom(book, size: 14))
//                .padding(7)
//                .padding(.horizontal, 25)
//                .background(Color(.systemGray6))
//                .cornerRadius(14) //used to be 8
//                .overlay(
//                    HStack {
//                        Image(systemName: "magnifyingglass")
//                            .foregroundColor(.gray)
//                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
//                            .padding(.leading, 8)
//
//                        if isEditing {
//                            Button(action: {
//                                self.text = ""
//
//                            }) {
//                                Image(systemName: "multiply.circle.fill")
//                                    .foregroundColor(.gray)
//                                    .padding(.trailing, 8)
//                            }
//                        }
//                    }
//                )
//                .padding(.horizontal, 10)
//                .onTapGesture {
//                    self.isEditing = true
//                }
//
//            if isEditing {
//                Button(action: {
//                    self.isEditing = false
//                    self.text = ""
//
//                    // Dismiss the keyboard
//                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
//                }) {
//                    Text("Cancel")
//                }
//                .padding(.trailing, 10)
//                .transition(.move(edge: .trailing))
//                .animation(.default)
//            }
//        }
//        Spacer()
//    }
//    }
//}
/*
struct SearchBar_Previews: PreviewProvider {
    static var previews: some View {
        SearchBar(text: .constant(""))
    }
}
*/
struct SearchBar: View {
    @Binding var text: String

    @State private var isEditing = false
        
    var body: some View {
        GeometryReader { _ in
          //  Spacer()
        HStack {
            
            TextField("Search for an emotion...", text: $text).font(.custom(book, size: 14))
                .padding(7)
                .padding(.horizontal, 25)
                .background(Color(.systemGray6))
                .cornerRadius(14) //used to be 8
                .overlay(
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 8)
                        
                        if isEditing {
                            Button(action: {
                                self.text = ""
                                
                            }) {
                                Image(systemName: "multiply.circle.fill")
                                    .foregroundColor(.gray)
                                    .padding(.trailing, 8)
                            }
                        }
                    }
                )
                .padding(.horizontal, 10)
                .onTapGesture {
                    self.isEditing = true
                }
            
            if isEditing {
                Button(action: {
                    self.isEditing = false
                    self.text = ""
                    
                    // Dismiss the keyboard
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }) {
                    Text("Cancel")
                }
                .padding(.trailing, 10)
                .transition(.move(edge: .trailing))
                .animation(.default)
            }
        }
       // Spacer()
    }.ignoresSafeArea(.keyboard, edges: .bottom)
    }
}
