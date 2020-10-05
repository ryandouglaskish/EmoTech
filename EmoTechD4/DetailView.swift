//
//  DetailView.swift
//  EmoTechD4
//
//  Created by Ryan Kish on 7/17/20.
//  Copyright © 2020 Ryan Kish. All rights reserved.
//

import SwiftUI
import UIKit



struct ActivityViewController: UIViewControllerRepresentable {
    
    var text: String
    
    var applicationActivities: [UIActivity]? = nil
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ActivityViewController>) -> UIActivityViewController {
        let textToShare = [ text ]
        let controller = UIActivityViewController(activityItems: textToShare as [Any], applicationActivities: applicationActivities)
        controller.excludedActivityTypes = [
            UIActivity.ActivityType.addToReadingList,
            UIActivity.ActivityType.airDrop,
            UIActivity.ActivityType.mail,
            UIActivity.ActivityType.openInIBooks,
            UIActivity.ActivityType.postToFlickr,
            UIActivity.ActivityType.postToFlickr,
            UIActivity.ActivityType.postToVimeo,
            UIActivity.ActivityType.postToWeibo,
            UIActivity.ActivityType.postToTencentWeibo,
            UIActivity.ActivityType.print,
            UIActivity.ActivityType.saveToCameraRoll,
            UIActivity.ActivityType.markupAsPDF
            
            
        ]
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: UIViewControllerRepresentableContext<ActivityViewController>) {}
}

struct DetailView: View {
    
    @State private var isSharePresented: Bool = false
    
    var emotionName: String!
    var tip: String!
    var length: String!
    var link: String!
    
    var body: some View {
        
        ZStack {
            Color("EmoWhite").edgesIgnoringSafeArea(.all)
            
            Image("CityBackground").resizable()
            
            VStack {
                Spacer().frame(height: 10)
                Text("Your \(self.emotionName) Tip")
                    .font(Font.custom(book, size: 27))
                Spacer()
                Text(self.tip).font(Font.custom(bold, size: 20)).multilineTextAlignment(.center).padding(.horizontal, 25)
                                
                Spacer()
                
                Divider()
                
                
                VStack {
                    Button(action: {
                        if let url = URL(string: link) {
                            if #available(iOS 10, *){
                                UIApplication.shared.open(url)
                            }else{
                                UIApplication.shared.openURL(url)
                            }
                            
                        }
                    }) {
                        VStack {
                            Text("Listen on Spotify").font(Font.custom(book, size: 20)).foregroundColor(Color.black)
                            HStack {
                                Spacer()
                                Image("Clock").resizable().scaledToFit().frame(height: 18)
                                Text(length + " Hours").font(Font.custom(book, size: 18)).foregroundColor(Color("Orange"))
                                Spacer()
                            }
                            let albumName = emotionName + "Album"
                            Image(albumName).resizable().scaledToFit().frame(width: 60).cornerRadius(20)
                        }
                        
                    }
                    
                    
                }.buttonStyle(PlainButtonStyle())
                
                Spacer().frame(height: 30).sheet(isPresented: $isSharePresented, onDismiss: {
                }, content: {
                    ActivityViewController(text: self.tip)
                    
                })
            }
            
        }.navigationBarItems(trailing:
                                Button(action: {
                                    self.isSharePresented = true
                                }) {
                                    Image("Share").resizable().scaledToFit().frame(width: 30)
                                }
        )
        
        
        
    }
}

/*
struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(emotionName: "Motivation", tip: "When you’re with someone, actually be with them. Be present. Don’t be texting on your phone or paying attention to something going on around you. Focus on who you’re with and what they’re saying. They’ll notice you’re paying attention and reciprocate, which makes the relationship better for both of you.")
    }
}
*/
