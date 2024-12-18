//
//  Model.swift
//  squarify
//
//  Created by Jeffery Widroff on 12/11/24.
//


import Foundation
import UIKit

//TODO: 3 ways to make pieces disappear: 1) Line across the board 2) 7 pieces grouped 3) a group that surrounds pieces

//TODO: Make it that if no pieces can move, the board shakes and nothing happens


//TODO: Make it that if no pieces move on a swipe, no piece is added

//TODO: Make initial text of the game the first time its played say "Swipe in any direction"

//TODO: New issue - When a piece is trapped in another group of pieces, when you swipe in any direction it doesnt move because of the fact that the middle piece cant move (although this may be able to be fixed by the fact that all of those pieces will have been removed anyway

//TODO: Issue regarding the grouping of the pieces together still doesnt seem to be fixed

//TODO: When groups are intertwined, the groups dont seem to move properly. need to perhaps consider identifying these circumstances and then considering them to be one group for that one move and see if all of the pieces can move together (like a "C" shaped pieces around a part thats sticking out from a group of pieces)


//TODO: Put the nextPiece in the center of the board


//MARK: 1) adding a piece needs to happen before the find4square func

// Make chain for connected pieces
//Make counter for number of swippes
//Make a high score for most swipes
//Make a soundtrack
// No pieces should be added if no pieces actually moved
// Change the groupnumber of the 1st piece to zero

protocol ModelDelegate {
    func setUpGameViews(board: Board)
    func setUpControlViews()
    func setUpPiecesView()
    func movePieceView(piece: Piece)
    func moveNextPieceOnToBoard(piece: Piece)
    
    func removeView(view: UIView)
    func runPopUpView(title: String, message: String)
    func clearPiecesAnimation(view: UIView)
    func removeViews()
    func addSwipeGestureRecognizer(view: UIView)
    func enlargePiece(view: UIView)
//    func setupInstructionsView(instructions: Instructions)
    func setUpNextView(nextPiece: Piece)
    func shrinkPiece(view: UIView)
    func animateGrouping(piece: Piece)
    func disableGestures()
    func enableGestures()
    func groupTogether(view: UIView, side: String, color: UIColor)
}

class Model {
    
    var board = Board()
    var delegate: ModelDelegate?
    let defaults = UserDefaults.standard
    var colors = PieceColors()
    var piecesMoved = false
    
    var piecesMovedX = false
    var groupsThatHaveMoved = [Int]()
    var groupsThatHaveMovedBack = [Int]()
    var piecesToMoveBack = [Int]()

    var red = PieceColors().colors["red"]!
    var blue = PieceColors().colors["blue"]!
    var green = PieceColors().colors["green"]!
    var purple = PieceColors().colors["purple"]!
    var yellow = PieceColors().colors["yellow"]!
    var orange = PieceColors().colors["orange"]!
    var groupCount = 0
    var nextPiece = Piece()
//    var groups2Rerun = [[Group]]()
    var groups2Return = [Group]()
    var blockeeAndBlockers = [Int: [Int]]()
    var highestID = 0
    var masterGroupOfGroupsX = [[Int]]()

    
    init(){
        
    }
    
    func setUpGame() {
        
        setLevel()
        setBoard()
        groupPiecesTogether(){}
    }
    
    func setUpControlsAndInstructions() {
        
        delegate?.setUpControlViews()
//        setupInstructions()
        setupNextView()
    }
    
    func setLevel() {
        
        board.heightSpaces = 6
        board.widthSpaces = 6
        
        let piece100 = Piece(indexes: Indexes(x: 0, y: 0), color: red)
        let group100 = Group(pieces: [piece100])//, piece21, piece20, piece23, piece24, piece25])
        group100.id = 0
        
//        let piece101 = Piece(indexes: Indexes(x: 1, y: 0), color: red)
//        let group101 = Group(pieces: [piece101])//, piece21, piece20, piece23, piece24, piece25])
//        group101.id = 101
//
//        let piece102 = Piece(indexes: Indexes(x: 0, y: 1), color: red)
//        let group102 = Group(pieces: [piece102])//, piece21, piece20, piece23, piece24, piece25])
//        group102.id = 102
        
        
        board.pieceGroups = [group100]//, group101, group102]//, group4, group5, group3, group2, group6, group7, group8]

        var number = 0
        
        for group in board.pieceGroups {
            
            for piece in group.pieces {
                
                piece.id = number
                piece.groupNumber = group.id
                board.pieces.append(piece)
                number += 1
                
            }
            
        }
        
        highestID = number
        updateBoard()
    }
    
    func updateBoard() {
        
        board.locationAndIDs.removeAll()
        
        for group in board.pieceGroups {
            
            for piece in group.pieces {
                
                board.locationAndIDs[piece.indexes!] = piece.id
            }
        }
    }
    
    func setBoard() {
        
        delegate?.setUpGameViews(board: self.board)
        delegate?.setUpPiecesView()
    }
    
    func setupNextView() {
        
        nextPiece = Piece(indexes: Indexes(x: nil, y: nil), color: returnRandomColor())
        delegate?.setUpNextView(nextPiece: nextPiece)
    }
    
    func returnRandomColor() -> UIColor {
        
        var color2Return = UIColor()
        let colors = PieceColors()
        let pieceColors = colors.colors
        let randomColors = ["red","blue","green"]//,"purple"]//, "yellow", "orange"]//, "lightBlue", "teal", "purp"]
        let randomIndex = arc4random_uniform(UInt32(randomColors.count))
        color2Return = pieceColors[randomColors[Int(randomIndex)]]!
        return color2Return
    }

    func setPieceID(piece: Piece) {
        
        piece.id = highestID
        highestID += 1
    }
    
    private func setPieceIndex(piece: Piece) {

        let index = Indexes(x: Int(arc4random_uniform(UInt32(board.widthSpaces))), y: Int(arc4random_uniform(UInt32(board.heightSpaces))))

        var useIndexes = true
        
        for group in board.pieceGroups {
            
            if group.pieces.contains(where: { (pieceX) -> Bool in
                pieceX.indexes == index
            }){
                
                useIndexes = false
            }
        }
        
        if useIndexes == true {
            piece.indexes = index
        } else {
            setPieceIndex(piece: piece)
        }
    }
    
    func isNextSpaceBlocked(direction: Direction, indexes: Indexes, pieces: [Piece]) -> Bool {
        
        var bool = true

        switch direction {
        case .up:
            if pieces.contains(where: { (piece) -> Bool in
                piece.indexes == Indexes(x: indexes.x, y: indexes.y! - 1)
            }){
                bool = false
            }
            
        case .down:
            if pieces.contains(where: { (piece) -> Bool in
                piece.indexes == Indexes(x: indexes.x, y: indexes.y! + 1)
            }){
                bool = false
            }
            
        case .left:
            if pieces.contains(where: { (piece) -> Bool in
                piece.indexes == Indexes(x: indexes.x! - 1, y: indexes.y)
            }){
                bool = false
            }
            
        case .right:
            if pieces.contains(where: { (piece) -> Bool in
                piece.indexes == Indexes(x: indexes.x! + 1, y: indexes.y)
            }){
                bool = false
            }
        default:
            break
        }
        return bool
    }
    
    func getPieceInfo(index: Indexes, pieces: [Piece]) -> Piece? {
        
        var piece = Piece()
        
        for pieceX in pieces {
            
            if pieceX.indexes == index {
                
                piece = pieceX
            }
        }
        return piece
    }
    
    func movePiecesHelper(piece: Piece, direction: Direction) {
        
        if let indexes = piece.indexes {
            
            switch direction {
                
            case .up:
                
                    if indexes.y != 0 {
                        piece.indexes?.y = (indexes.y)! - 1
                        piecesMoved = true
                    }
                
            case .down:
                
                    if indexes.y != board.heightSpaces - 1 {
                        piece.indexes?.y = indexes.y! + 1
                        piecesMoved = true
                    }
                
            case .left:
                
                    if indexes.x != 0 {
                        piece.indexes?.x = indexes.x! - 1
                        piecesMoved = true
                    }
                
            case .right:
                
                    if indexes.x != board.widthSpaces - 1 {
                        piece.indexes?.x = indexes.x! + 1
                        piecesMoved = true
                    }
                    
            default:
                break
            }
        }
    }
    
    func pieceIsPartOfAGroup(piece: Piece, groups: [Group]) -> Bool {
        
        var bool = false
        
        for group in groups {
            if group.pieces.contains(where: { pieceX -> Bool in
                piece.indexes == pieceX.indexes
            }) {
                bool = true
            }
        }
        return bool
    }
    
    func resetPieces() {
        
        for piece in board.pieces {
            
            piece.canMoveOneSpace = true
            piecesMovedX = false
            for subviewX in piece.view.subviews {
                piece.view.bringSubviewToFront(subviewX)
            }
        }
    }
    
    func initiateMove(direction: Direction) {
        
        delegate?.disableGestures()
        
        
        sortPieces(direction: direction)
        
//        printVisualDisplay(type: "pieceID")
        
        movePieces(direction: direction) {
            
//            printVisualDisplay(type: "pieceID")

//            if piecesMoved == true {
                
//                piecesMoved = false
                setNextPiece() {
                    

                    
                    groupPiecesTogether() {
                        
                        updateLabels()
                        
                        
                        
                        find4Square() {
                            
                            updateBoard()
                            printVisualDisplay(type: "pieceID")
                            
                            
                            resetPieces()
                            groupsThatHaveMovedBack.removeAll()
                            groups2Return.removeAll()
                            board.locationAndIDs.removeAll() //MARK: NEEDED
                            piecesToMoveBack.removeAll()
                            groupsThatHaveMoved.removeAll()
                            delegate?.enableGestures()
                        }
                        
                        
                        
                    }
                    
                    
                    
                }
                
//            }
            
            
 
            
            
        }
        
        
        
        
        
    }

    func find4Square(completion: () -> Void?) {
        
        var piecesToDelete = [Piece]()
        var group2Delete = [Group]()

        
        for group in board.pieceGroups {
            
            for piece in group.pieces.sorted(by: { (piece1, piece2) in
                (piece1.indexes?.x!)! < (piece2.indexes?.x!)!
            }).sorted(by: { (piece3, piece4) in
                (piece3.indexes?.y!)! < (piece4.indexes?.y!)!
            }) {
                
                if group.pieces.contains(where: { pieceA in
                    pieceA.indexes == Indexes(x: (piece.indexes?.x!)! + 1,y: (piece.indexes?.y!)!)
                }) && group.pieces.contains(where: { pieceA in
                    pieceA.indexes == Indexes(x: (piece.indexes?.x!)!,y: (piece.indexes?.y!)! + 1)
                }) && group.pieces.contains(where: { pieceA in
                    pieceA.indexes == Indexes(x: (piece.indexes?.x!)! + 1, y: (piece.indexes?.y!)! + 1)
                }) {
                    for piece in group.pieces {
                        
                        piecesToDelete.append(piece)

                    }
                    
                    if !group2Delete.contains(where: { (groupZ) in

                        groupZ.id == piece.groupNumber
                    }) {
                        group2Delete.append(group)
//                        print("ADDED Group to delete with a group number of \(group.id)")

                    }
                }
            }
        }
        
        for piece in piecesToDelete {
            
//            print("piece.id to delete \(piece.id)")
            
            

            delegate?.removeView(view: piece.view)

            
//            board.locationAndIDs[piece.indexes!] = nil
            
            board.pieces.removeAll { (pieceB) -> Bool in
                piece.id == pieceB.id

            }
        }
                
        for groupXXX in group2Delete {
            board.pieceGroups.removeAll { (groupAA) in
                groupAA.id == groupXXX.id
            }
        }

        
        updateBoard()
        
        completion()
    }
    
    func movePieces(direction: Direction, completion: () -> Void?) {
        
        setPieceCanMove(direction: direction)
        
//        printVisualDisplay(type: "pieceID")
        
        movePiecesThatShouldMove(direction: direction)
        
//        printVisualDisplay(type: "pieceID")
        
        if piecesMovedX == true {
            movePieces(direction: direction){}
            piecesMoved = true
        }
        
        completion()
    }
    
    var groupIDMax = 0
    
    func setNextPiece(completion: () -> Void?) {
        
        setPieceIndex(piece: nextPiece)
        setPieceID(piece: nextPiece)
        board.pieces.append(nextPiece)
        
        let group = Group(pieces: [nextPiece])
        group.id = groupIDMax + 1
        groupIDMax += 1
        nextPiece.groupNumber = group.id
        board.pieceGroups.append(group)
        
        delegate?.moveNextPieceOnToBoard(piece: nextPiece)
        
//        nextPiece = Piece()
//        setupNextView()
            
        for piece in group.pieces {
            
            board.locationAndIDs[piece.indexes!] = piece.id
        }
        completion()
    }
    
    func setPieceCanMove(direction: Direction) {
//        print("NEW")
        
        
        setIndexes(direction: direction) //Sets the prev, current and next indexes. Also sets whether the piece can move one space
        
        updateBoard()
        
//        print("After Set Indexes")
//        printVisualDisplay(type: "pieceID")
        
//        checkGroup(direction: direction) //checks groups to see if any pieces cant move. If a piece cant move, the whole group is set to not being able to move
        
        
//        print("After check group")
//        printVisualDisplay(type: "pieceID")
        
        setIndexesX(direction: direction) //Sets indexes of pieces
        
//        updateBoard() //MARK: PROBLEM LIES HERE - WHEN THIS FUNC IS HERE THE VISUAL DISPLAY WORKS BUT WHEN SWIPING AFTER PIECES ARE REMOVED, IT STILL THINKS THAT THE PIECES ARE THERE. IF YOU TAKE THIS OUT, THE VISUAL DISPLAY DOESNT WORK BUT THE PIECES MOVE CORRECTLY?
//
//        print("Before move back:")
//        printVisualDisplay(type: "pieceID")
//
//        print()

        moveBack(direction: direction) //Changes the indexes of pieces back when there is overlap
        
        
        
//        updateBoard()
        
//        print("After move back")
//        printVisualDisplay(type: "pieceID")
//        print()
    }
    
    func setIndexesX(direction: Direction) {
        
        switch direction {
            
        case .up:
            
            for piece in board.pieces.sorted(by: { (piece1, piece2) in
                (piece1.indexes?.y!)! < (piece2.indexes?.y!)!
            }) {
                
//                print("piece with piece ID of \(piece.id)")
                
                if piece.canMoveOneSpace == true {
                    
//                    print("Can Move")
                    
                    piece.indexes = piece.nextIndexes
                    
                    
                } else {
                    
//                    print("Cant Move")
                }
            }
            
        case .down:
            
            for piece in board.pieces.sorted(by: { (piece1, piece2) in
                (piece1.indexes?.y!)! > (piece2.indexes?.y!)!
            }) {
                
//                print("piece with piece ID of \(piece.id)")
                
                if piece.canMoveOneSpace == true {
                    
//                    print("Can Move")
                    
                    piece.indexes = piece.nextIndexes
                } else {
                    
//                    print("Cant Move")
                }
            }
            
            
        case .left:
            
            for piece in board.pieces.sorted(by: { (piece1, piece2) in
                (piece1.indexes?.x!)! < (piece2.indexes?.x!)!
            }) {
                
//                print("piece with piece ID of \(piece.id)")
                
                if piece.canMoveOneSpace == true {
                    
//                    print("Can Move")
                    
                    piece.indexes = piece.nextIndexes
                } else {
                    
//                    print("Cant Move")
                }
            }
            
            
        case .right:
            
            for piece in board.pieces.sorted(by: { (piece1, piece2) in
                (piece1.indexes?.x!)! > (piece2.indexes?.x!)!
            }) {
                
//                print("piece with piece ID of \(piece.id)")
                
                if piece.canMoveOneSpace == true {
                    
//                     print("Can Move")
                    
                    piece.indexes = piece.nextIndexes
                } else {
                    
                    
//                    print("Cant Move")
                }
            }
            
        default:
            
            break
        }
        
    }
    
    func moveBack(direction: Direction) {
        
        var recursion = false
        
        for pieceX in board.pieces {
            
//            print("\(pieceX.indexes)")
            
            for pieceY in board.pieces {

                if pieceX.indexes == pieceY.indexes && pieceX.id != pieceY.id {

//                    print("Recursion is TRUE!")
                    
                    recursion = true

                    switch direction {

                    case .up:

                        if (pieceX.nextIndexes?.y)! < (pieceY.nextIndexes?.y)! {

                            pieceY.indexes = pieceY.previousIndex
                            pieceY.canMoveOneSpace = false
//                            board.locationAndIDs[pieceY.indexes!] = pieceY.id
                            
                        } else {

                            pieceX.indexes = pieceX.previousIndex
                            pieceX.canMoveOneSpace = false
                            
//                            board.locationAndIDs[pieceX.indexes!] = pieceX.id

                        }

                    case .down:

                        if (pieceX.nextIndexes?.y)! > (pieceY.nextIndexes?.y)! {

                            pieceY.indexes = pieceY.previousIndex
                            pieceY.canMoveOneSpace = false
                            
//                            board.locationAndIDs[pieceY.indexes!] = pieceY.id

                            
                        } else {
                            pieceX.indexes = pieceX.previousIndex
                            pieceX.canMoveOneSpace = false
                            
//                            board.locationAndIDs[pieceX.indexes!] = pieceX.id

                        }

                    case .left:

                        if (pieceX.nextIndexes?.x)! < (pieceY.nextIndexes?.x)! {

                            pieceY.indexes = pieceY.previousIndex
                            pieceY.canMoveOneSpace = false
                            
//                            board.locationAndIDs[pieceY.indexes!] = pieceY.id

                            
                        } else {
                            pieceX.indexes = pieceX.previousIndex
                            pieceX.canMoveOneSpace = false
                            
//                            board.locationAndIDs[pieceX.indexes!] = pieceX.id

                        }

                    case .right:

                        if (pieceX.nextIndexes?.x)! > (pieceY.nextIndexes?.x)! {

                            pieceY.indexes = pieceY.previousIndex
                            pieceY.canMoveOneSpace = false
                            
//                            board.locationAndIDs[pieceY.indexes!] = pieceY.id

                            
                        } else {

                            pieceX.indexes = pieceX.previousIndex
                            pieceX.canMoveOneSpace = false
//                            board.locationAndIDs[pieceX.indexes!] = pieceX.id

                        }
                        
                    default:

                        break
                    }
                } else {
//                    recursion = false
                }
            }
        }
        
        checkForDuplicatesX(direction: direction) //Makes sure that if part of a group doesnt move, the rest of the group doesnt move either
        
        if recursion == true {
            moveBack(direction: direction)
        }
    }
    
    func movePiecesBack() {
        
        for int in piecesToMoveBack {
            
            let piece = returnPiecesFromID(id: int)
            
            piece.canMoveOneSpace = false
        }
    }
    
    func printVisualDisplay(type: String) {
        
        var verticalLine = [(Int, Int)]()
        var chart = [verticalLine]
        
        for x in 0...board.widthSpaces - 1 {
            
            for y in 0...board.heightSpaces - 1 {
                
                verticalLine.append((x, y))
            }
            
            chart.append(verticalLine)
            verticalLine = [(Int, Int)]()
        }
        
        switch type {
            
        case "canMove":
            
            for row in chart {
                
                var rowToPrint = [String]()
                
                for indexesX in row {
                    
                    if let pieceID = board.locationAndIDs[Indexes(x:indexesX.1 ,y:indexesX.0)] {
                        
                        if returnPiecesFromID(id: pieceID).canMoveOneSpace == true {
                            
                            rowToPrint.append("Y")
                        } else {
                            rowToPrint.append("N")
                        }
                    } else {
                        rowToPrint.append(" ")
                    }
                }
                print(rowToPrint)
                rowToPrint = [String]()
            }
            
        case "boardPieceID":
            
            for row in chart {
                
                var rowToPrint = [String]()

                for indexesX in row {
                    
                    if let pieceID = board.locationAndIDs[Indexes(x:indexesX.1 ,y:indexesX.0)] {
                        
                        if pieceID > 9 {
                            rowToPrint.append(String(pieceID))
                        } else {
                            rowToPrint.append(String(" \(pieceID)"))
                        }
                        
                    } else {
                        rowToPrint.append("  ")
                    }
                }
                print(rowToPrint)
                rowToPrint = [String]()
            }
            
        case "pieceID":
            
            for row in chart {
                
                var rowToPrint = [String]()

                for indexesX in row {
                    
                    if let groupID = board.locationAndIDs[Indexes(x: indexesX.1, y:indexesX.0)] {
                        
                        if String(groupID).count == 1 {
                            
                            let newString = " \(String(groupID))"
                            
                            rowToPrint.append(newString)
                            
                        } else {
                            
                            rowToPrint.append(String(groupID))
                            
                        }
                        
                    } else {
                        
                        rowToPrint.append("  ")
                    }
                }
                print(rowToPrint)
            }
        default:
            
            for row in chart {
                
                print(row)
            }
        }
    }
    
    func returnPiecesFromIndex(indexes: Indexes) -> [Piece] {
        
        var piecesToReturn = [Piece]()
        
        for piece in board.pieces {
            
            if piece.indexes == indexes {
                piecesToReturn.append(piece)
            }
        }
        return piecesToReturn
    }
    
    func returnPiecesFromID(id: Int) -> Piece {
        
        var pieceToReturn = Piece()
        
        for piece in board.pieces {
            
            if piece.id == id {
                pieceToReturn = piece
            }
        }
        return pieceToReturn
    }
    
    func movePiecesThatShouldMove(direction: Direction) {
        
        piecesMovedX = false
        
        for piece in board.pieces {
            
            if piece.canMoveOneSpace == true {
                
                piecesMovedX = true
//                piecesMoved = true
                delegate?.movePieceView(piece: piece)
                
            }
        }
    }
    
    func groupCanMoveX(group: Group, direction: Direction) -> Bool {
                
        var boolToReturn = true
        
        switch direction {
            
        case .up:
            
            for piece in group.pieces{
                
                if piece.indexes?.y != 0 {
                    
                    for groupX in board.pieceGroups {
                        
                        for pieceX in groupX.pieces {
                            
                            if pieceX.indexes == Indexes(x: piece.indexes!.x, y: piece.indexes!.y! - 1) {
                                
                                if !group.pieces.contains(where: { (piece3) in
                                    piece3.indexes == Indexes(x: piece.indexes!.x, y: piece.indexes!.y! - 1)
                                    
                                }) {
                                    boolToReturn = false
                                } else {
//                                        print("Piece is from another group")
                                    
                                }
                            }
                        }
                    }
                } else {
                    
                    boolToReturn = false
                }
            }
            
        case .down:
            
            for piece in group.pieces {
                
                if piece.indexes?.y != board.heightSpaces - 1{
                    
                    for groupX in board.pieceGroups {
                        
                        for pieceX in groupX.pieces {
                            
                            if pieceX.indexes == Indexes(x: piece.indexes!.x, y: piece.indexes!.y! + 1) {
                                
                                if !group.pieces.contains(where: { (piece3) in
                                    piece3.indexes == Indexes(x: piece.indexes!.x, y: piece.indexes!.y! + 1)
                                }) {
                                    
                                    boolToReturn = false
                                    
                                } else {
//                                        print("Piece is from another group")
                                }
                            }
                        }
                    }
                } else {
                    
                    boolToReturn = false
                }
            }
            
        case .left:
            
            for piece in group.pieces{
                
                if piece.indexes?.x != 0 {
                    
                    for groupX in board.pieceGroups {
                        
                        for pieceX in groupX.pieces {
                            
                            if pieceX.indexes == Indexes(x: piece.indexes!.x! - 1, y: piece.indexes!.y) {
                                
                                if !group.pieces.contains(where: { (piece3) in
                                    piece3.indexes == Indexes(x: piece.indexes!.x! - 1, y: piece.indexes!.y)
                                    
                                }) {
                                    boolToReturn = false
                                    
                                } else {
//                                        print("Piece is from another group")
                                }
                            }
                        }
                    }
                } else {
                    
                    boolToReturn = false
                }
//                    print(groupCanMove)
            }
            
        case .right:
            
            for piece in group.pieces{
                
                if piece.indexes?.x != board.widthSpaces - 1 {
                    
                    for groupX in board.pieceGroups {
                        
                        for pieceX in groupX.pieces {
                            
                            if pieceX.indexes == Indexes(x: piece.indexes!.x! + 1, y: piece.indexes!.y) {
                                
                                if !group.pieces.contains(where: { (piece3) in
                                    piece3.indexes == Indexes(x: piece.indexes!.x! + 1, y: piece.indexes!.y)
                                    
                                }) {
                                    boolToReturn = false
                                } else {
//                                        print("Piece is from another group")
                                   
                                }
                            }
                        }
                    }
                } else {
                    
                    boolToReturn = false
                }
//                    print(groupCanMove)
            }
            
        default:
            
            break
            
        }
        
        return boolToReturn
    }
   
    func moveAllGrpPcs(group: Group, direction: Direction) {
        
        switch direction{
            
        case .up:
            
            for piece in group.pieces.sorted(by: { (piece1, piece2) in
                piece1.indexes!.y! < piece2.indexes!.y!
            }) {
                movePiecesHelper(piece: piece, direction: direction)
                self.delegate?.movePieceView(piece: piece)
            }
            
        case .down:
            
            for piece in group.pieces.sorted(by: { (piece1, piece2) in
                piece1.indexes!.y! > piece2.indexes!.y!
            }) {
                movePiecesHelper(piece: piece, direction: direction)
                self.delegate?.movePieceView(piece: piece)
            }
            
        case .left:
            
            for piece in group.pieces.sorted(by: { (piece1, piece2) in
                piece1.indexes!.x! < piece2.indexes!.x!
            }) {
                movePiecesHelper(piece: piece, direction: direction)
                self.delegate?.movePieceView(piece: piece)
            }
            
        case .right:
            
            for piece in group.pieces.sorted(by: { (piece1, piece2) in
                piece1.indexes!.x! > piece2.indexes!.x!
            }) {
                movePiecesHelper(piece: piece, direction: direction)
                self.delegate?.movePieceView(piece: piece)
            }
            
        default:
            
            break
        }
    }
    
    func returnGroup(groupNumber: Int) -> Group {
        
        let pieces = [Piece]()
        var group2Return = Group(pieces: pieces)
        
        for group in board.pieceGroups {
            
            if group.id == groupNumber {
                
                group2Return = group
                
            }
        }
        return group2Return
    }
    
    func groupPiecesTogether(completion: () -> Void?) {
        
        //MARK: The problem that seems to persist is due to the fact that the groups that are being grouped together arent being deleted properly when they join together.
        
        var piecesToSkip = [Piece]()
        
        for piece in board.pieces.sorted(by: { (piece1, piece2) in
            (piece1.indexes?.x!)! < (piece2.indexes?.x!)!
        }).sorted(by: { (piece3, piece4) in
            (piece3.indexes?.y!)! < (piece4.indexes?.y!)!
        }) {
            
            for pieceX in board.pieces.sorted(by: { (piece1, piece2) in
                (piece1.indexes?.x!)! < (piece2.indexes?.x!)!
            }).sorted(by: { (piece3, piece4) in
                (piece3.indexes?.y!)! < (piece4.indexes?.y!)!
            }) {
                
                if !returnGroup(groupNumber: pieceX.groupNumber).pieces.contains(where: { (pieceB) in
                    pieceB.id == piece.id
                }) {
                    
                    //If the piece in question has the same color piece either below it
                    if pieceX.indexes == Indexes(x:piece.indexes?.x, y: (piece.indexes?.y!)! + 1) {
                        
                        if pieceX.color == piece.color {
                            
                            if !piecesToSkip.contains(where: { (pieceA) in
                                pieceA.id == pieceX.id
                            }) {
                                
                                let groupIdToBeDeleted = pieceX.groupNumber
                                
                                let group2Remain = piece.groupNumber
                                
                                
                                var groupPieces = returnGroup(groupNumber: pieceX.groupNumber).pieces
                                
                                for piece1 in groupPieces {
                                    
                                    piece1.groupNumber = piece.groupNumber
                                    piecesToSkip.append(piece1)
                                    
                                    for groupZ in board.pieceGroups {
                                        if groupZ.id == group2Remain {
                                            
                                            groupZ.pieces.append(piece1)
                                        }
                                        
                                        if groupZ.id == groupIdToBeDeleted {
                                            
                                            groupPieces.removeAll { (pieceP) in
                                                pieceP.id == piece1.id
                                            }
                                            
                                            board.pieceGroups.removeAll { (groupABC) in
                                                groupABC.id == groupZ.id
                                            }
                                            
                                        }
                                        
                                        
                                    }
                                }
                                
                                //MARK: THIS CAUSES AN ISSUE FOR TIMING
//                                delegate?.animateGrouping(piece: piece)
//                                delegate?.animateGrouping(piece: pieceX)

                                print("We found a match!")
                                
                            }
                        }
                    }
                    //If the piece in question has the same color piece to the right of it
                    else if pieceX.indexes == Indexes(x:(piece.indexes?.x!)! + 1, y: (piece.indexes?.y!)!) {
                        
                        if pieceX.color == piece.color {
                            
                            if !piecesToSkip.contains(where: { (pieceA) in
                                pieceA.id == pieceX.id
                            }) {
                                
                                let groupIdToBeDeleted = pieceX.groupNumber
                                
                                let group2Remain = piece.groupNumber
                                
                                
                                var groupPieces = returnGroup(groupNumber: pieceX.groupNumber).pieces
                                
                                for piece1 in groupPieces {
                                    
                                    piece1.groupNumber = piece.groupNumber
                                    piecesToSkip.append(piece1)
                                    
                                    for groupZ in board.pieceGroups {
                                        if groupZ.id == group2Remain {
                                            
                                            groupZ.pieces.append(piece1)
                                        }
                                        
                                        if groupZ.id == groupIdToBeDeleted {
                                            
                                            groupPieces.removeAll { (pieceP) in
                                                pieceP.id == piece1.id
                                            }
                                            
                                            board.pieceGroups.removeAll { (groupABC) in
                                                groupABC.id == groupZ.id
                                            }
                                            
                                        }
                                        
                                        
                                    }
                                }
                                
                                //MARK: THIS CAUSES AN ISSUE FOR TIMING

//                                delegate?.animateGrouping(piece: piece)
//                                delegate?.animateGrouping(piece: pieceX)
                                
                                print("We found a match!")
                                
                            }
                        }
                    }
                    
                    
                    
                }
            }
        }
        completion()
    }
 
    func updateLabels() {
        
        for group in board.pieceGroups {
            
            for piece in group.pieces {
                
                piece.view.label.font = UIFont.boldSystemFont(ofSize: 8.0)
                piece.view.label.text = "\(piece.id)"
            }
        }
    }
    
    func animation4GroupingPieces(pieces: [Piece]) {
        
        for piece in pieces {
            
            UIView.animate(withDuration: 0.25) {

                self.delegate?.enlargePiece(view: piece.view)

            } completion: { (true) in

                self.delegate?.shrinkPiece(view: piece.view)
            }
        }
    }
    
    func sortPieces(direction: Direction) {

        switch direction {

        case .up:

            board.pieces.sort { (piece1, piece2) -> Bool in
                (piece1.indexes?.y!)! < (piece2.indexes?.y!)!
            }

        case .down:

            board.pieces.sort { (piece1, piece2) -> Bool in
                (piece1.indexes?.y!)! > (piece2.indexes?.y!)!
            }

        case .left:

            board.pieces.sort { (piece1, piece2) -> Bool in
                (piece1.indexes?.x!)! < (piece2.indexes?.x!)!
            }

        case .right:

            board.pieces.sort { (piece1, piece2) -> Bool in
                (piece1.indexes?.x!)! > (piece2.indexes?.x!)!
            }

        default:
            break
        }
    }
    
    func setNextIndexes(direction: Direction) {
       
        for piece in board.pieces {
            
            piece.canMoveOneSpace = true

            switch direction {
                
            case .up:
                
                if piece.indexes?.y! != 0 {
                    
                    piece.nextIndexes = Indexes(x: (piece.indexes?.x)!, y: (piece.indexes?.y)! - 1)
                } else {
                    piece.canMoveOneSpace = false
                }
                
            case .down:
                
                if piece.indexes?.y! != board.heightSpaces - 1 {
                    
                    piece.nextIndexes = Indexes(x: (piece.indexes?.x)!, y: (piece.indexes?.y)! + 1)
                    
                } else {
                    piece.canMoveOneSpace = false
                }
                
            case .left:
                
                if piece.indexes?.x! != 0 {
                    
                    piece.nextIndexes = Indexes(x: (piece.indexes?.x)! - 1, y: (piece.indexes?.y)!)
                    
                } else {
                    piece.canMoveOneSpace = false
                }
                
            case .right:
                
                if piece.indexes?.x! != board.widthSpaces - 1 {
                    
                    piece.nextIndexes = Indexes(x: (piece.indexes?.x)! + 1, y: (piece.indexes?.y)!)
                    
                } else {
                    piece.canMoveOneSpace = false
                }
                
            default:
                
                break
            }
        }
    }
    
    func setIndexes(direction: Direction) {
        
        switch direction{
            
        case .up:
            
            for piece in board.pieces {
                
                if piece.indexes?.y != 0 {
                    
                    
                    piece.previousIndex = piece.indexes
                    piece.nextIndexes = Indexes(x: (piece.indexes?.x!)! , y: (piece.indexes?.y)! - 1)
                    
//                    if board.locationAndIDs[piece.nextIndexes!] == nil {
//
//                        board.locationAndIDs[piece.nextIndexes!] = piece.id
//                        board.locationAndIDs[piece.indexes!] = nil
//                    } else {
//
//                        piece.canMoveOneSpace = false
//                    }
                } else {
                    
                    
                    piece.previousIndex = piece.indexes
                    piece.nextIndexes = piece.indexes
                    piece.canMoveOneSpace = false
//                    board.locationAndIDs[piece.indexes!] = piece.id
//                    board.locationAndIDs[piece.indexes!] = nil
                }

            }
        case .down:
            
            for piece in board.pieces {
                
                if piece.indexes?.y != board.heightSpaces - 1 {
                    piece.previousIndex = piece.indexes
                    piece.nextIndexes = Indexes(x: (piece.indexes?.x!)! , y: (piece.indexes?.y)! + 1)
                    
//                    if board.locationAndIDs[piece.nextIndexes!] == nil {
//                        board.locationAndIDs[piece.nextIndexes!] = piece.id
//                        board.locationAndIDs[piece.indexes!] = nil
//                    } else {
//                        piece.canMoveOneSpace = false
//                    }
                }  else {
                    piece.previousIndex = piece.indexes
                    piece.nextIndexes = piece.indexes
                    piece.canMoveOneSpace = false
                }
            }
            
        case .left:
            
            for piece in board.pieces {
                
                if piece.indexes?.x != 0 {
                    
                    piece.previousIndex = piece.indexes
                    piece.nextIndexes = Indexes(x: (piece.indexes?.x!)! - 1, y: piece.indexes?.y)
                    
//                    if board.locationAndIDs[piece.nextIndexes!] == nil {
//                        board.locationAndIDs[piece.nextIndexes!] = piece.id
//                        board.locationAndIDs[piece.indexes!] = nil
//                    } else {
//                        piece.canMoveOneSpace = false
//
//                    }
                }  else {
                    piece.previousIndex = piece.indexes
                    piece.nextIndexes = piece.indexes
                    piece.canMoveOneSpace = false
                }

            }
            
        case .right:

        for piece in board.pieces {
            
            if piece.indexes?.x != board.widthSpaces - 1 {
                
                piece.previousIndex = piece.indexes
                piece.nextIndexes = Indexes(x: (piece.indexes?.x!)! + 1, y: piece.indexes?.y)
                
//                if board.locationAndIDs[piece.nextIndexes!] == nil {
//                    board.locationAndIDs[piece.nextIndexes!] = piece.id
//                    board.locationAndIDs[piece.indexes!] = nil
//                } else {
//                    piece.canMoveOneSpace = false
//                }
            } else {
                piece.previousIndex = piece.indexes
                piece.nextIndexes = piece.indexes
                piece.canMoveOneSpace = false
            }
        }
            
        default:
            
            break
        }
    }
    
    func checkForDuplicatesX(direction: Direction) {
        
        for group in board.pieceGroups {
            
            var groupCanMove = true
            
            for pieceX in group.pieces {
                
                if pieceX.canMoveOneSpace == false {

                    groupCanMove = false
                }
            }
            
            if groupCanMove == false {
                
                for piece in group.pieces {
                    
                    piece.canMoveOneSpace = false

                    if piece.indexes == piece.nextIndexes {
//                        board.locationAndIDs[piece.indexes!] = nil
                        piece.indexes = piece.previousIndex
//                        board.locationAndIDs[piece.indexes!] = piece.id
                    }
                }
            }
        }
    }
    
    func checkGroup(direction: Direction) {

        for group in board.pieceGroups {
            
            var canMove = true
            
            for piece in group.pieces {
                
                if piece.canMoveOneSpace == false {
                    
                    canMove = false
                }
            }
            
            if canMove == false {
                
                for pieceX in group.pieces {
                    
                    pieceX.canMoveOneSpace = false
                }
            }
        }
    }
    
    func checkGroup2(direction: Direction) {
        
        for group in board.pieceGroups {
            
            for piece in group.pieces {
                
                if board.locationAndIDs[piece.nextIndexes!] == piece.id {
                    
//                    print("Piece \(piece.id) is able to move because the piece in front is its ID")

                } else {
                    
                    for piece in returnGroup(groupNumber: piece.groupNumber).pieces {
                        
                        piece.canMoveOneSpace = false
                    }

                }
            }
        }
    }
    
    func sortGroups(direction: Direction) {
        
        switch direction {
            
        case .up:
            
            board.pieceGroups = board.pieceGroups.sorted(by: { (group1, group2) in
                group1.pieces.map({($0.indexes?.y)!}).min()! < group2.pieces.map({($0.indexes?.y)!}).min()!
            })

        case .down:
            
            board.pieceGroups = board.pieceGroups.sorted(by: { (group1, group2) in
                group1.pieces.map({($0.indexes?.y)!}).max()! > group2.pieces.map({($0.indexes?.y)!}).max()!
            })
            
        case .left:
            
            board.pieceGroups = board.pieceGroups.sorted(by: { (group1, group2) in
                group1.pieces.map({($0.indexes?.x)!}).min()! < group2.pieces.map({($0.indexes?.x)!}).min()!
            })
            
        case .right:
            
            board.pieceGroups = board.pieceGroups.sorted(by: { (group1, group2) in
                group1.pieces.map({($0.indexes?.x)!}).min()! > group2.pieces.map({($0.indexes?.x)!}).min()!
            })

        default:
            break
        }
    }
}
