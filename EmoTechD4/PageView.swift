//
//  PageView.swift
//  EmoTechD4
//
//  Created by Ryan Kish on 11/5/20.
//  Copyright © 2020 Ryan Kish. All rights reserved.
//
import SwiftUI

struct PageViewData: Identifiable {
    let id = UUID().uuidString
    let imageNamed: String
}


struct CircleButton: View {
    @Binding var isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: {
            self.action()
        }) { Circle()
            .frame(width: 16, height: 16)
            .foregroundColor(self.isSelected ? Color.white : Color.white.opacity(0.5))
        }
    }
}

struct SwiperView: View {
    let pages: [PageViewData]
        
        @Binding var index: Int
        @State private var offset: CGFloat = 0
        @State private var isUserSwiping: Bool = false
    
    var body: some View {
            GeometryReader { geometry in
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(alignment: .center, spacing: 0) {
                        ForEach(self.pages) { viewData in
                            PageView(viewData: viewData)
                                .frame(width: geometry.size.width,
                                       height: geometry.size.height)
                        }
                    }
                }.content
                .offset(x: self.isUserSwiping ? self.offset : CGFloat(self.index) * -geometry.size.width)
                .frame(width: geometry.size.width, alignment: .leading)
                .gesture(
                    DragGesture()
                        .onChanged({ value in
                            self.isUserSwiping = true
                            self.offset = value.translation.width + -geometry.size.width * CGFloat(self.index)
                        })
                        .onEnded({ value in
                            if value.predictedEndTranslation.width < geometry.size.width / 2, self.index < self.pages.count - 1 {
                                self.index += 1
                            }
                            if value.predictedEndTranslation.width > geometry.size.width / 2, self.index > 0 {
                                self.index -= 1
                            }
                            withAnimation {
                                self.isUserSwiping = false
                            }
                        })
                )
                
                
                
            }
    }
}


struct ContentView: View {
    let pages: [PageViewData] = [
        PageViewData(imageNamed: "image1"),
        PageViewData(imageNamed: "image2"),
        PageViewData(imageNamed: "image3")
    ]
    @State private var index: Int = 0
    
    var body: some View {
        ZStack(alignment: .bottom) {
            SwiperView(pages: self.pages, index: self.$index)
            HStack(spacing: 8) {
                ForEach(0..<self.pages.count) { index in
                    CircleButton(isSelected: Binding<Bool>(get: { self.index == index }, set: { _ in })) {
                        withAnimation {
                            self.index = index
                        }
                    }
                }
            }
            .padding(.bottom, 12)
        }
    }
}




struct PageView: View {
    let viewData: PageViewData
    var body: some View {
    Image(viewData.imageNamed)
                .resizable()
                .clipped()
    }
    
}

struct PageView_Previews: PreviewProvider {
    static var previews: some View {
       // PageView(viewData: PageViewData(imageNamed: "HomeSymbol"))
        ContentView()
    }
}

