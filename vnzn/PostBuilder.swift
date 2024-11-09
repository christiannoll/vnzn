//
//  PostBuilder.swift
//  TestMarkdown
//
//  Created by Christian on 12.10.24.
//

import Foundation

struct PostBuilder {
    
    // Funktion zum Ersetzen von *Text* in **Text**
    func replaceAsterisksWithBold(_ input: String) -> String {
        // Regulärer Ausdruck für *Text*
        let pattern = "(?<!\\*)\\*(?!\\*)(.*?)(?<!\\*)\\*(?!\\*)"
        
        do {
            // Erstellen Sie eine reguläre Expression
            let regex = try NSRegularExpression(pattern: pattern, options: [])
            
            // Ersetzen Sie *Text* durch **Text**
            let modifiedString = regex.stringByReplacingMatches(in: input, options: [], range: NSRange(input.startIndex..., in: input), withTemplate: "**$1**")
            
            return modifiedString
        } catch {
            print("Fehler beim Erstellen des regulären Ausdrucks: \(error)")
            return input
        }
    }
}
