//
//  BrandScoreStyleKit.swift
//  Stylist
//
//  Created by 田畑リク on 2015/08/10.
//  Copyright (c) 2015年 xxx. All rights reserved.
//

import UIKit

public class BrandScoreStyleKit : NSObject {
	
	class var mainFont:UIFont {
		return UIFont(name: "HelveticaNeue-LightItalic", size: 20)!
	}
	
	//キャッシュ
	
	private struct Cache {
		static var imageDict : [String:UIImage] = Dictionary()
	}
	
	//各ボックスの仕様を設定
	public class func draw(#string:String) {
		let context = UIGraphicsGetCurrentContext()
		
		let textRect = CGRectMake(0, 0, 25, 25)
		var textTextContent = NSString(string: string)
		let textStyle = NSMutableParagraphStyle.defaultParagraphStyle().mutableCopy() as! NSMutableParagraphStyle
		textStyle.alignment = NSTextAlignment.Center
		
		let textFontAttributes = [NSFontAttributeName: BrandScoreStyleKit.mainFont, NSForegroundColorAttributeName: UIColor.blackColor(), NSParagraphStyleAttributeName: textStyle]
		
		let textTextHeight: CGFloat = textTextContent.boundingRectWithSize(CGSizeMake(textRect.width, CGFloat.infinity), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: textFontAttributes, context: nil).size.height
		CGContextSaveGState(context)
		CGContextClipToRect(context, textRect);
		textTextContent.drawInRect(CGRectMake(textRect.minX, textRect.minY + (textRect.height - textTextHeight) / 2, textRect.width, textTextHeight), withAttributes: textFontAttributes)
		CGContextRestoreGState(context)
	}
	
	
	public class func imageOf(#string:String) -> UIImage {
		if let image = Cache.imageDict[string] {
			return image
		}
		
		UIGraphicsBeginImageContextWithOptions(CGSizeMake(25, 25), false, 0)
		BrandScoreStyleKit.draw(string: string)
		
		let image = UIGraphicsGetImageFromCurrentImageContext()!
		UIGraphicsEndImageContext()
		
		Cache.imageDict[string] = image
		
		return image
	}
    

	
}