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
			if let range = lString.rangeOfString(
				String( lWord[advance(lWord.startIndex, i)] as Character ),
				options: nil,
				range: Range<String.Index>( start: startAt, end: lString.endIndex),
				locale: nil
			){
				idxOf = range.startIndex
				if startAt == idxOf {
					// 最初の文字が同じだと、0.7ポイント
					charScore = 0.7
				} else {
					charScore = 0.1
					
					if string[advance(idxOf, -1)] == " " { charScore += 0.8 }
				}
			} else {
				// 文字が見つからない場合、0点を返す
				if fuzzinessIsNil {
					
					return 0
				} else {
					fuzzies += fuzzyFactor
					continue
				}
			}
			
			if ( string[idxOf] == word[advance(word.startIndex, i)] ) {
				charScore += 0.1
			}
			
			//文字の類似性スコアをアップデートする
			runningScore += charScore
			startAt = advance(idxOf, 1)
		}
		
		// 検索ワードが長い場合は、似ていない際の、削除されるスコアを少なくする
		finalScore = 0.5 * (runningScore / Double(strLength) + runningScore / Double(wordLength)) / fuzzies
		
		if (lWord[lWord.startIndex] == lString[lString.startIndex]) && (finalScore < 0.85) {
			finalScore += 0.15
		}
		
		return finalScore
    }
}