//
//  StepsOnboarding.swift
//  EmoTechD4
//
//  Created by Ryan Kish on 11/5/20.
//  Copyright © 2020 Ryan Kish. All rights reserved.
//

import SwiftUI

struct StepsOnboarding: View {
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
                //Spacer().frame(width: 20)
                Text("Welcome to your step tracker! Here you can observe your daily steps by linking to the Health App. At the end of the week (Sunday), see if you got the goal number of steps that experts recommend.").font(Font.custom(book, size: 20)).multilineTextAlignment(.leading).frame(width: 300)
               // Spacer().frame(width: 20)
            }
            Spacer().frame(height: 20)
            HStack {
               // Spacer().frame(width: 20)
                Text("The reason tracking your activity level is so  important is because being  active is a vital part of sustaind happiness.").font(Font.custom(book, size: 20)).multilineTextAlignment(.leading).frame(width: 300)
                //Spacer().frame(width: 20)
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

struct StepsOnboarding_Previews: PreviewProvider {
    static var previews: some View {
        StepsOnboarding()
    }
}
