//
//  ColorTheme.swift
//  squarify
//
//  Created by Jeffery Widroff on 12/11/24.
//

import Foundation
import UIKit

class ColorTheme { //TODO: Make all of these into static vars
    
    var gameBackground = UIColor()
    static var boardBackground = UIColor()
    static var pieceBackground = UIColor()
    static var lockedPieceBackground = UIColor()
    var holeColor = UIColor()
    var gridLineColor = UIColor()
    var lockPieceScrewColor = UIColor()
    var buttonColors = UIColor()
    var buttonTextColor = UIColor()
    
    var gradientBackgroundColor = [UIColor]()
    
    init() {
        
//        gameBackground = UIColor.yellow
//        ColorTheme.boardBackground = UIColor(red: 0.6, green: 0.5, blue: 0.7, alpha: 0.5)
        
        ColorTheme.boardBackground = UIColor(red: 1.0, green: 0.6, blue: 1.0, alpha: 0.1)
        ColorTheme.pieceBackground = UIColor(red: 0.6, green: 0.5, blue: 0.7, alpha: 0.7)
//        pieceBackground = UIColor.clear
        ColorTheme.lockedPieceBackground = UIColor(red: 0.2, green: 0.1, blue: 0.2, alpha: 1.0)
        
        lockPieceScrewColor = UIColor.lightGray
        holeColor = gameBackground
        gridLineColor = gameBackground
        buttonColors = UIColor.white
        buttonTextColor = UIColor.black
        gradientBackgroundColor = [UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0), UIColor.init(red: 0.9, green: 0.1, blue: 0.7, alpha: 1.0)] // DEFAULT
    }
}

class ColorShade {
    
    var color: ColorX
    var shade: Int
    
    
    init(color: ColorX, shade: Int) {
        
        self.color = color
        self.shade = shade
    }
    
    
    func returnColor() -> UIColor {
        
        var colorToReturn = UIColor()
        
        //MARK: Working on this
        let randomNum = CGFloat(Double(Double(arc4random_uniform(UInt32(0.3))) + 0.6))
        
        switch color {
            
            
            
        case .red:
            
            colorToReturn = UIColor.init(red: 0.8, green: 0.1, blue: 0.1, alpha: randomNum)
            
            
        case .blue:
            
            colorToReturn = UIColor.init(red: 0.0, green: 0.1, blue: 0.9, alpha: randomNum)
            
            
        case .green:
            
            colorToReturn = UIColor.init(red: 0.0, green: 0.8, blue: 0.5, alpha: randomNum)
            
        default:
            
            break
            
            
            
        }
        
        
        
        return colorToReturn
    }
    
}



struct PieceColors {
    
    var colors = [
        "red" : UIColor.init(red: 0.8, green: 0.1, blue: 0.1, alpha: 0.3),
        "blue" : UIColor.init(red: 0.0, green: 0.1, blue: 0.9, alpha: 0.3),
        "green" : UIColor.init(red: 0.0, green: 8.0, blue: 0.5, alpha: 0.1),
        "purple" : UIColor.init(red: 0.5, green: 0.0, blue: 0.5, alpha: 0.6),
        "yellow" : UIColor.init(red: 0.9, green: 0.9, blue: 0.3, alpha: 0.6),
        "orange" : UIColor.init(red: 0.9, green: 0.6, blue: 0.0, alpha: 0.6),
        
        "lightBlue" : UIColor.init(red: 0.2, green: 0.3, blue: 0.7, alpha: 0.6),
        
        "teal" : UIColor.init(red: 0.0, green: 0.7, blue: 0.7, alpha: 0.6),
        
        "purp" : UIColor(red: 0.6, green: 0.3, blue: 0.7, alpha: 0.6),
    ]
    
    
    
    
    
}
//    var colors = [
//        "red" : UIColor.init(red: 0.7, green: 0.1, blue: 0.0, alpha: 0.5),
//        "yellow" : UIColor.init(red: 0.9, green: 0.9, blue: 0.3, alpha: 0.5),
//        "blue" : UIColor.init(red: 0.0, green: 0.1, blue: 0.9, alpha: 0.5),
//        "green" : UIColor.init(red: 0.0, green: 9.0, blue: 0.4, alpha: 0.5),
//        "purple" : UIColor.init(red: 0.5, green: 0.0, blue: 0.5, alpha: 0.5),
//        "yellow" : UIColor.init(red: 0.9, green: 0.9, blue: 0.3, alpha: 0.5),
//        "orange" : UIColor.init(red: 0.9, green: 0.6, blue: 0.0, alpha: 0.5),
//
//        "lightBlue" : UIColor.init(red: 0.2, green: 0.3, blue: 0.7, alpha: 0.5),
//
//        "teal" : UIColor.init(red: 0.0, green: 0.7, blue: 0.7, alpha: 0.5),
//
//        "purp" : UIColor(red: 0.6, green: 0.5, blue: 0.7, alpha: 0.5),
//
//    ]
    
    
    
    
//    static var teal = UIColor.systemTeal
////    static var red = UIColor.red
//    static var yellow = UIColor.systemTeal
////    static var green = UIColor.systemTeal
////    static var blue = UIColor.systemTeal
//    static var purple = UIColor.systemTeal
//    static var orange = UIColor.systemTeal
//    static var magenta = UIColor.systemTeal
//    static var indigo = UIColor.systemTeal
//    static var cyan = UIColor.systemTeal
    
    
    //    var groupBackgroundColors = [UIColor.systemTeal, UIColor.red, UIColor.yellow, UIColor.green, UIColor.blue, UIColor.purple, UIColor.orange, UIColor.magenta, UIColor.systemIndigo, UIColor.cyan, UIColor.darkGray, UIColor.lightGray, UIColor.gray, UIColor.brown, UIColor.systemPink, UIColor.white, UIColor.black]
    










enum ColorX {
    
    case red
    case blue
    case green
}



