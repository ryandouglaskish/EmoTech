//
//  EmotionSetUp.swift
//  EmoTechD4
//
//  Created by Ryan Kish on 10/21/20.
//  Copyright © 2020 Ryan Kish. All rights reserved.
//
import UIKit


let positiveCharacters = ["Happy1","Happy2","Happy3"]
let negativeCharacters = ["Sad1","Sad2"]


class Emotion: Identifiable {
    var id = UUID()
    var emotion: String
    var tips: [String]
    var spotify: String
    var currInd: Int = 0
    var mood: String
    var spotifyLength: String
    
    init(emotion: String, mood: String, tips: [String], spotify: String, spotifyLength: String) {
        self.emotion = emotion
        self.mood = mood
        self.tips = tips
        self.spotify = spotify
        self.spotifyLength = spotifyLength
    }

    func nextTip() -> String {
        currInd += 1
        currInd = currInd % 4
        return tips[currInd]
    }
}


var emotions: [Emotion] = []

var order: Int16 = 0
