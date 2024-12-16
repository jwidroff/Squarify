//
//  Board.swift
//  squarify
//
//  Created by Jeffery Widroff on 12/11/24.
//

import Foundation
import UIKit


class Board {
    
    var grid = [Indexes: CGPoint]()
    var view = UIView()
    var pieces = [Piece]()
    var heightSpaces = Int()
    var widthSpaces = Int()
    var colorTheme = ColorTheme()
//    var instructions: Instructions?
    var pieceGroups = [Group]()
    
    var locationAndIDs = [Indexes: Int]()
//    var idsAndLocations = [Int: Indexes]()

    var indexArrayOfIntsDict = [Indexes: [Int]]()
    
//    func spaceIsOccupied(indexes: Indexes, id: Int) {
//
//        for (indexX, idX) in locationAndIDs {
//
//            if indexX == indexes {
//
//
//
//
//
//
//
//            }
//        }
//    }
    
    
}








class BoardView : UIView {
    
    var context = UIGraphicsGetCurrentContext()
    var xArray = [CGFloat]()
    var yArray = [CGFloat]()
    var colorTheme = ColorTheme()

    override init(frame: CGRect) {
        
        super.init(frame: frame)
        self.frame = frame
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(frame: CGRect, xArray: [CGFloat], yArray: [CGFloat], colorTheme: ColorTheme) {
        
        super.init(frame: frame)
        self.colorTheme = colorTheme
        self.xArray = xArray.sorted(by: { (x1, x2) -> Bool in
            x1 < x2
        })
        self.yArray = yArray.sorted(by: { (y1, y2) -> Bool in
            y1 < y2
        })
        
        addBoardTiles()
    }
    
    private func addGridLines(context: CGContext) {
        
        let point1 = CGPoint(x: xArray[0], y: yArray[0])
        let point2 = CGPoint(x: xArray[1], y: yArray[1])
        let halfX = (point1.x - point2.x) / 2
        let halfY = (point1.y - point2.y) / 2
        
        context.setLineWidth(2.0)
        context.beginPath()
        context.move(to: CGPoint(x: 0, y: 0))
        context.addLine(to: CGPoint(x: 0, y: frame.maxY))
        context.strokePath()
        
        context.beginPath()
        context.move(to: CGPoint(x: frame.maxX, y: 0))
        context.addLine(to: CGPoint(x: 0, y: 0))
        context.strokePath()
        
        for x in xArray {
                        
            context.beginPath()
            context.move(to: CGPoint(x: x + halfX, y: yArray.first! + halfY))
            context.addLine(to: CGPoint(x: x + halfX, y: yArray.last! - halfY))
            context.strokePath()
        }
        
        context.beginPath()
        context.move(to: CGPoint(x: frame.width, y: 0))
        context.addLine(to: CGPoint(x: frame.width, y: frame.height))
        context.strokePath()
        
        for y in yArray {
            
            context.beginPath()
            context.move(to: CGPoint(x: xArray.first! + halfX, y: y + halfY))
            context.addLine(to: CGPoint(x: xArray.last! - halfX, y: y + halfY))
            context.strokePath()
        }
        
        context.beginPath()
        context.move(to: CGPoint(x: 0, y: frame.height))
        context.addLine(to: CGPoint(x: frame.width, y: frame.height))
        context.strokePath()

        setNeedsDisplay()
        self.context = context
    }
    
    private func addBoardTiles() {
        let widthAndHeight = (xArray[1] - xArray [0])
        
        var xCount = 0

        for x in xArray {
            
            var yCount = 0

            for y in yArray {
                
//                if !holeLocations.contains(where: { (indexesX) -> Bool in
//                    self.xArray[indexesX.x!] == x && self.yArray[indexesX.y!] == y
//                }) {
                    let x1 = x - (widthAndHeight / 2)
                    let y1 = y - (widthAndHeight / 2)

                    let rect = CGRect(x: x1, y: y1, width: widthAndHeight, height: widthAndHeight)
                    let viewX = UIView(frame: rect)
//                    viewX.center = CGPoint(x: x, y: y)
                    addSubview(viewX)
                    makeSoft(view: viewX)
                    
                    //MARK: THIS IS ONLY FOR TESTING AND LEVEL SET UP PURPOSES
                    addLocationLabel(view: viewX, xIndex: xCount, yIndex: yCount)
//                }
                yCount += 1
            }
            xCount += 1
        }
    }
    
    private func addLocationLabel(view: UIView, xIndex: Int, yIndex: Int) {
//MARK: This will print the grid locations to the actual location (the x and y axis)
//        let labelView = UILabel(frame: view.frame)
//        labelView.text = "(\(xIndex),\(yIndex))"
//        labelView.font = .systemFont(ofSize: labelView.frame.width / 2.5)
//        labelView.textAlignment = .center
//        self.addSubview(labelView)
    }
    
    private func makeSoft(view: UIView) {
        
        view.backgroundColor = ColorTheme.boardBackground
        let shadowRadius: CGFloat = 1
        let darkShadow = CALayer()

        darkShadow.frame = view.layer.bounds
        darkShadow.backgroundColor = ColorTheme.boardBackground.cgColor
        darkShadow.shadowColor = UIColor.black.cgColor
        darkShadow.shadowOffset = CGSize(width: shadowRadius, height: shadowRadius)
        darkShadow.shadowOpacity = 1
        view.layer.insertSublayer(darkShadow, at: 1)
    }
}

