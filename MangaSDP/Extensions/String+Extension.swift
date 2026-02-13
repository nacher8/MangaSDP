//
//  String+Extension.swift
//  MangaSDP
//
//  Created by IGNACIO HERNAIZ IZQUIERDO on 31/1/26.
//

import SwiftUI

extension String {
    nonisolated var removingSquareBracketContent: String {
        replacingOccurrences(
            of: "\\s*\\[.*?\\]|\\s*\\(Source:.*?\\)",
            with: "",
            options: .regularExpression
        )
        .replacingOccurrences(
            of: "\\n{2,}",
            with: "\n",
            options: .regularExpression
        )
        .trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    var roleIcon: String {
        switch self.lowercased() {
        case "story":
            return "story"
        case "art":
            return "art"
        case "story & art":
            return "storyAndArt"
        default:
            return "noData"
        }
    }
}
