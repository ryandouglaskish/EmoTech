//
//  ChecklistOnboarding.swift
//  EmoTechD4
//
//  Created by Ryan Kish on 11/1/20.
//  Copyright © 2020 Ryan Kish. All rights reserved.
//

import SwiftUI

struct ChecklistOnboarding: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack(spacing: 0)  {
            Spacer().frame(height: 20)
            HStack {
                Spacer().frame(width: 20)
                Text("Checklist").font(Font.custom(bold, size: 30)).multilineTextAlignment(.leading)
                Spacer()
            }
            Spacer().frame(height: 20)
            //Spacer()
            HStack {
                Spacer().frame(width: 20)
                Text("Welcome to your daily checklist! You can set yourself daily goals, objectives, or anything you need to get done. It can be anything from doing your homework to being more grateful for your family, to filing your taxes. Just get it done!").font(Font.custom(book, size: 20)).multilineTextAlignment(.leading)
                Spacer().frame(width: 20)
            }
            Spacer().frame(height: 20)
            HStack {
                Spacer().frame(width: 20)
                Text("When all items are checked, you can complete the list with the buttton on the top right.").font(Font.custom(book, size: 20)).multilineTextAlignment(.leading)
                Spacer().frame(width: 20)
            }
            Spacer()
            ZStack {
                Rectangle().fill(Color.green).frame(width: 300, height: 60).cornerRadius(20)
            Button(action: {
                self.presentationMode.wrappedValue.dismiss()

            }) {
                Text("Continue").font(Font.custom(bold, size: 25)).foregroundColor(.white)
            }
            }
            Spacer()
            
            
        }
    }
}


struct ChecklistOnboarding_Previews: PreviewProvider {
    static var previews: some View {
        ChecklistOnboarding()
    }
}
