//
//  StringScore.swift
//  Stylist
//
//  Created by 田畑リク on 2015/08/10.
//  Copyright (c) 2015年 xxx. All rights reserved.
//


import Foundation

extension String {
	func score(#word:String, fuzziness:Double? = nil) -> Double {
		// 入力された言葉が検索候補の言葉と同じだと、1を返す
		if self == word { return 1 }
		
		//入力された言葉が無い、または候補の言葉が無いと、0を返す
		if word.isEmpty || self.isEmpty { return 0 }
        
		
		var
		runningScore = 0.0,
		charScore = 0.0,
		finalScore = 0.0,
		string = self,
		lString = string.lowercaseString,
		strLength = count(string),
		lWord = word.lowercaseString,
		wordLength = count(word),
		idxOf:String.Index!,
		startAt = lString.startIndex,
		fuzzies = 1.0,
		fuzzyFactor = 0.0,
		fuzzinessIsNil = true
		
		//キャッシュすることにより、動作を早くする
		if let fuzziness = fuzziness {
			fuzzyFactor = 1 - fuzziness
			fuzzinessIsNil = false
		}
		
		for i in 0..<wordLength {
			// 一文字づつ、検索していく
            //Find next first case-insensitive match of word's i-th character.
			// The search in "string" begins at "startAt".
			if let range = lString.rangeOfString(
				String( lWord[advance(lWord.startIndex, i)] as Character ),
				options: nil,
				range: Range<String.Index>( start: startAt, end: lString.endIndex),
				locale: nil
			){
				// start index of word's i-th character in string.
				idxOf = range.startIndex
				if startAt == idxOf {
					// Consecutive letter & start-of-string Bonus
					charScore = 0.7
				} else {
					charScore = 0.1
					
					// Acronym Bonus
					// Weighing Logic: Typing the first character of an acronym is as if you
					// preceded it with two perfect character matches.
					if string[advance(idxOf, -1)] == " " { charScore += 0.8 }
				}
			} else {
				// Character not found.
				if fuzzinessIsNil {
					// Fuzziness is nil. Return 0.
					return 0
				} else {
					fuzzies += fuzzyFactor
					continue
				}
			}
			
			// Same case bonus.
			if ( string[idxOf] == word[advance(word.startIndex, i)] ) {
				charScore += 0.1
			}
			
			// Update scores and startAt position for next round of indexOf
			runningScore += charScore
			startAt = advance(idxOf, 1)
		}
		
		// Reduce penalty for longer strings.
		finalScore = 0.5 * (runningScore / Double(strLength) + runningScore / Double(wordLength)) / fuzzies
		
		if (lWord[lWord.startIndex] == lString[lString.startIndex]) && (finalScore < 0.85) {
			finalScore += 0.15
		}
		
		return finalScore
    }
}