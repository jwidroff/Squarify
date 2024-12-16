//
//  GridPoints.swift
//  squarify
//
//  Created by Jeffery Widroff on 12/11/24.
//

import Foundation
import UIKit

class GridPoints {
    
    var gameFrame = CGRect()
    var height = CGFloat()
    var width = CGFloat()
    var dictionary = [Indexes: CGPoint]()
    var heightPoints = [CGFloat]()
    var widthPoints = [CGFloat]()
    
    

    init() {
        
    }
    
    init(frame: CGRect, height: Int, width: Int) {

        self.height = CGFloat(height)
        self.width = CGFloat(width)
        self.gameFrame = frame
    }
    
    func getGrid() -> [Indexes: CGPoint]{
        
        let heightDistance = (gameFrame.height / height)
        let widthDistance = (gameFrame.width / width)
        var point:CGFloat = (heightDistance / 2)

        //Get the CGFloat for each height and add to array
        for _ in 0..<Int(height) {
            
            heightPoints.append(point)
            point += heightDistance
        }
        
        //Get the CGFloat for each width and add to array
        point = (widthDistance / 2)
        
        for _ in 0..<Int(width) {
            
            widthPoints.append(point)
            point += widthDistance
        }
        
        //Create temp arrays of (Int, CGFloat) for height to be later used to combine with width
        var counter = 0
        var heightArray = [(Int, CGFloat)]()
        for point in heightPoints {

            let pair:(Int, CGFloat) = (counter, point)
            heightArray.append(pair)
            counter += 1
        }
                
        //Create temp arrays of (Int, CGFloat) for width to be later used to combine with height
        counter = 0
        var widthArray = [(Int, CGFloat)]()
        for point in widthPoints {

            let pair:(Int, CGFloat) = (counter, point)
            widthArray.append(pair)
            counter += 1
        }
        
        for verticalSet in heightArray {
            
            for horizontalSet in widthArray {
                
                let floatingPoint = CGPoint(x: horizontalSet.1, y: verticalSet.1)
                
                dictionary[Indexes(x: horizontalSet.0, y: verticalSet.0)] = floatingPoint
                
//                grid.locations.append(Indexes(x: horizontalSet.0, y: verticalSet.0))
            }
        }
        
//        print(grid.locations)
        
        return dictionary
    }
}


struct Indexes {
    var x: Int?
    var y: Int?
}




extension Indexes: Hashable {
    
    static func == (lhs: Indexes, rhs: Indexes) -> Bool {
        return lhs.x == rhs.x && lhs.y == rhs.y
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(x)
        hasher.combine(y)
    }
}
