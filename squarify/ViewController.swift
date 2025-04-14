//
//  ViewController.swift
//  squarify
//
//  Created by Jeffery Widroff on 12/11/24.
//

import UIKit

class ViewController: UIViewController {

    var model = Model()
    var pieceWidth = CGFloat()
    var pieceHeight = CGFloat()
    var boardWidth = CGFloat()
    var boardHeight = CGFloat()
    var distanceFromPieceCenter = CGFloat()
    var deviceIsNarrow = Bool()
    var retryButton = UIButton()
    var menuButton = UIButton()
    var heightCushion = CGFloat()
    var widthCushion = CGFloat()
    var colorTheme = ColorTheme()
    var boardView = UIView()
    var duration4Animation = 0.10
    var topBarView = UIView()
    var instructionsShown = false
//    var nextPiece = Piece()
    var counterLabel = UILabel()
    var nextPieceView = UIView()
//    var swipes = 0
    
    var recognizer = UISwipeGestureRecognizer()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        addGradient()
        model = Model()
        model.delegate = self
        model.board.view.removeFromSuperview()
        model.setUpGame()
//        model.updateLabels()
        model.setUpControlsAndInstructions()
    }
    
    func addGradient() {
        
        let gradient = CAGradientLayer()
        
        //These angle the gradient on the X & Y axis (negative numbers can be used too)
        gradient.startPoint = .init(x: 0.0, y: 0.0)
        gradient.endPoint = .init(x: 0.0, y: 2.0)
        
        //This is the location of where in the middle the colors are together. (the closer they are together, the less they mesh. If its too far, you cant even notice that its 2 colors so it'll just look like one color that the two colors make)
        gradient.locations = [-0.1, 0.5, 1.1]
        
        //This keeps the gradient within the bounds of the view
        gradient.frame = self.view.bounds
        gradient.opacity = 0.5
        //These are the colors of the gradient(that are being passed in)
        gradient.colors = [UIColor.cyan.cgColor, UIColor.white.cgColor, UIColor.blue.cgColor]
        
        //This determines the layer of the view you're setting the gradient (the higher up the number is, the more outer of a layer it is - which is why "gradientColors2" wont show up if gradientColors is higher and vise versa)
        self.view.layer.insertSublayer(gradient, at: 1)
        
        let gradient2 = CAGradientLayer()
        
        //These angle the gradient on the X & Y axis (negative numbers can be used too)
        gradient2.startPoint = .init(x: 0.0, y: 0.0)
        gradient2.endPoint = .init(x: 2.0, y: 0.0)
        
        //This is the location of where in the middle the colors are together. (the closer they are together, the less they mesh. If its too far, you cant even notice that its 2 colors so it'll just look like one color that the two colors make)
        gradient2.locations = [-0.1, 0.5, 1.1]
        
        //This keeps the gradient within the bounds of the view
        gradient2.frame = self.view.bounds
        gradient2.opacity = 0.5
        //These are the colors of the gradient(that are being passed in)
        gradient2.colors = [UIColor.blue.cgColor, UIColor.white.cgColor, UIColor.cyan.cgColor]
        

        //This determines the layer of the view you're setting the gradient (the higher up the number is, the more outer of a layer it is - which is why "gradientColors2" wont show up if gradientColors is higher and vise versa)
        self.view.layer.insertSublayer(gradient2, at: 2)
        
    }
    
    //MARK: Initial Setup
    func setupGrid() { //MARK: This should be in the Model

        let x = 0.0 // (self.model.board.view.frame.width - boardWidth) / 2
        let y = 0.0 //(self.model.board.view.frame.height - boardHeight) / 2
        let frame = CGRect(x: x, y: y, width: boardWidth, height: boardHeight)
        self.model.board.grid = GridPoints(frame: frame, height: self.model.board.heightSpaces, width: self.model.board.widthSpaces).getGrid()
    }
    
    func setupBoard(board: Board) {
        
        var xArray = [CGFloat]()
        var yArray = [CGFloat]()
        
        for point in self.model.board.grid.values {
                        
            if !xArray.contains(point.x) {
                
                xArray.append(point.x)
            }
            
            if !yArray.contains(point.y) {
                
                yArray.append(point.y)
            }
        }
        
        boardView = BoardView(frame: CGRect(), xArray: xArray, yArray: yArray, colorTheme: board.colorTheme)
        self.model.board.view = boardView
        self.addSwipeGestureRecognizer(view: model.board.view)
        view.addSubview(self.model.board.view)
                
        model.board.view.translatesAutoresizingMaskIntoConstraints = false
        var constraints = [NSLayoutConstraint]()
        constraints.append(model.board.view.widthAnchor.constraint(equalToConstant: view.frame.width))// / 10 * 9))
        constraints.append(model.board.view.heightAnchor.constraint(equalToConstant: view.frame.width))// / 10 * 9))
        constraints.append(model.board.view.centerXAnchor.constraint(equalTo: view.centerXAnchor))
        constraints.append(model.board.view.centerYAnchor.constraint(equalTo: view.centerYAnchor))
        NSLayoutConstraint.activate(constraints)
    }
    
    func setSizes(board: Board) {

        boardWidth = view.frame.width// / 10 * 9
        boardHeight = boardWidth
        widthCushion = 0
        heightCushion = 0
        pieceWidth = boardWidth / CGFloat(model.board.widthSpaces)// / 10 * 9.75
        pieceHeight = boardHeight / CGFloat(model.board.heightSpaces)// / 10 * 9.75
        distanceFromPieceCenter = (pieceWidth) / 2
    }
    
    func setupControls() {
        
        setupTopBar()
        setupRetryButton()
        setupMenuButton()
//        setCounterLabel()
    }
    
    
    
    func setupTopBar() {
        
        topBarView.backgroundColor = ColorTheme.boardBackground
        topBarView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(topBarView)
        
        var constraints = [NSLayoutConstraint]()
        constraints.append(topBarView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor))
        constraints.append(topBarView.topAnchor.constraint(equalTo: view.topAnchor))
        constraints.append(topBarView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1.0))
//        constraints.append(topBarView.bottomAnchor.constraint(equalTo: boardView.topAnchor, constant: -100.0))
        constraints.append(topBarView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.1))
        
        
        NSLayoutConstraint.activate(constraints)
        topBarView.layer.masksToBounds = false
        topBarView.layoutIfNeeded()
    }
    
    func setupRetryButton() {
        
        let controlHeight = pieceHeight / 2
        let buttonWidth = (boardWidth / 2) - 10
        let buttonHeight = controlHeight
        
        let retryButtonYFloat = model.board.view.frame.maxY + (controlHeight / 2)
        let retryButtonXFloat = model.board.view.frame.minX + (boardWidth / 2) + 10
        let retryButtonFrame = CGRect(x: retryButtonXFloat, y: retryButtonYFloat, width: buttonWidth, height: buttonHeight)
        retryButton = UIButton(frame: retryButtonFrame)
        retryButton.titleLabel?.adjustsFontSizeToFitWidth = true
        retryButton.setTitleColor(colorTheme.buttonTextColor, for: .normal)
        retryButton.setImage(UIImage(named: "restart"), for: .normal)
        retryButton.addTarget(self, action: #selector(handleTap4Retry(sender:)), for: .touchUpInside)
        view.addSubview(retryButton)
        
        retryButton.translatesAutoresizingMaskIntoConstraints = false
        
        var constraints = [NSLayoutConstraint]()
        constraints.append(retryButton.trailingAnchor.constraint(equalTo: topBarView.safeAreaLayoutGuide.trailingAnchor, constant: -view.frame.width / 25))
        constraints.append(retryButton.bottomAnchor.constraint(equalTo: topBarView.safeAreaLayoutGuide.bottomAnchor))
        constraints.append(retryButton.widthAnchor.constraint(equalTo: topBarView.heightAnchor, multiplier: 0.5))
        constraints.append(retryButton.heightAnchor.constraint(equalTo: topBarView.heightAnchor, multiplier: 0.5))
        NSLayoutConstraint.activate(constraints)
    }
    
    func setupMenuButton() {
        
        let controlHeight = pieceHeight / 2
        let buttonWidth = (boardWidth / 2) - 10
        let buttonHeight = controlHeight
        let menuButtonYFloat = model.board.view.frame.maxY + (controlHeight / 2)
        let menuButtonXFloat = model.board.view.frame.minX
        let menuButtonFrame = CGRect(x: menuButtonXFloat, y: menuButtonYFloat, width: buttonWidth, height: buttonHeight)
        
        menuButton = UIButton(frame: menuButtonFrame)
        menuButton.layer.cornerRadius = menuButton.frame.height / 2
        menuButton.backgroundColor = UIColor.clear
        menuButton.setImage(UIImage(named: "menu"), for: .normal)
        menuButton.addTarget(self, action: #selector(handleTap4Menu(sender:)), for: .touchUpInside)
        view.addSubview(menuButton)
        
        menuButton.translatesAutoresizingMaskIntoConstraints = false
        
        var constraints = [NSLayoutConstraint]()
        constraints.append(menuButton.leadingAnchor.constraint(equalTo: topBarView.safeAreaLayoutGuide.leadingAnchor, constant: view.frame.width / 25))
        constraints.append(menuButton.bottomAnchor.constraint(equalTo: topBarView.safeAreaLayoutGuide.bottomAnchor))
        constraints.append(menuButton.widthAnchor.constraint(equalTo: topBarView.heightAnchor, multiplier: 0.5))
        constraints.append(menuButton.heightAnchor.constraint(equalTo: topBarView.heightAnchor, multiplier: 0.5))
        NSLayoutConstraint.activate(constraints)
    }
    
    @objc func handleSwipe(sender:UISwipeGestureRecognizer) {
        
        
        recognizer = sender
        
        switch sender.direction {
            
        case .up:
            model.initiateMove(direction: .up)
//            model.moveGroups(direction: .up)
        case .down:
            model.initiateMove (direction: .down)
//            model.moveGroups(direction: .down)

            
        case .right:
            model.initiateMove(direction: .right)
//            model.moveGroups(direction: .right)

            
        case .left:
            model.initiateMove(direction: .left)
//            model.moveGroups(direction: .left)

            
        default:
            break
        }
    }
    
    @objc func handleTap4Retry(sender: UITapGestureRecognizer) {
                        
        runPopUpView(title: "Restart", message: "Are you sure you want to restart?")
    }
    
    @objc func handleTap4Menu(sender: UITapGestureRecognizer) {
        
        runMenuView()
    }
    
    func runMenuView() {
        
        let width = self.view.frame.width / 10 * 9.5
        let height = self.view.frame.height / 10 * 9.5
        let x = (self.view.frame.width - width) / 2
        let y = (self.view.frame.height - height) / 2
        let frame = CGRect(x: x, y: y, width: width, height: height)
        let menuView = MenuView(frame: frame, model: model)
        menuView.clipsToBounds = true
        menuView.layer.cornerRadius = 25
        view.addSubview(menuView)
    }

    func radians(degrees: Double) ->  CGFloat {
        
        return CGFloat(degrees * .pi / degrees)
    }
}

extension ViewController: ModelDelegate {
    
    func shakeBoard(direction: Direction) {
        
        
        let originalCenter = CGPoint(x: self.boardView.frame.midX, y: self.boardView.frame.midY)
        
        
        switch direction {
            
        case .up, .down:
            
            UIView.animate(withDuration: 0.10, delay: 0, usingSpringWithDamping: 0.1, initialSpringVelocity: 0.5) {
                
                self.boardView.center = CGPoint(x: self.boardView.frame.midX, y: self.boardView.frame.midY + 20.0)
                
                
            } completion: { (true) in

                UIView.animate(withDuration: 0.1, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0) {
                    
                    self.boardView.center = CGPoint(x: self.boardView.frame.midX, y: self.boardView.frame.midY - 40.0)
                    
                    
                } completion: { (true) in
                    
                    self.boardView.center = originalCenter
                    
                }
                
            }
            
        case .left, .right:
            
            UIView.animate(withDuration: 0.10, delay: 0, usingSpringWithDamping: 0.1, initialSpringVelocity: 0.5) {
                
                self.boardView.center = CGPoint(x: self.boardView.frame.midX + 20.0, y: self.boardView.frame.midY)
                
                
            } completion: { (true) in

                UIView.animate(withDuration: 0.1, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0) {
                    
                    self.boardView.center = CGPoint(x: self.boardView.frame.midX - 40.0, y: self.boardView.frame.midY)
                    
                    
                } completion: { (true) in
                    
                    self.boardView.center = originalCenter
                    
                }
                
            }
            
        default:
            
            
            break
            
            
            
            
        }
        
        

        
        
        
        
    }
    
    
    func updateCounterLabel(num: Int) {
        
        counterLabel.text = "\(num)"
        
        
    }
    
    
    func setCounterLabel() {
        
        let width = pieceWidth * 2
        let height = pieceHeight
        let x = (boardWidth / 2) - (width / 2)
        let y = view.frame.midY / 4
        
        
        let rect = CGRect(x: x, y: y, width: width, height: height)
        counterLabel = UILabel(frame: rect)
        counterLabel.backgroundColor = UIColor.clear //MARK: Change to clear
        counterLabel.text = "0"
        counterLabel.textAlignment = .center
//        let size = CGSize(width: 150.0, height: 150.0)
//        counterLabel.sizeThatFits(size)
        counterLabel.font = UIFont.boldSystemFont(ofSize: pieceHeight / 1.25)
//        counterLabel.adjustsFontSizeToFitWidth
        view.addSubview(counterLabel)
        
    }
    
    
    func enableGestures() {
        
        addSwipeGestureRecognizer(view: model.board.view)
    }
    
    func disableGestures() {
        
        model.board.view.gestureRecognizers?.removeAll()
    }
    
    
    
//    func setupInstructionsView(instructions: Instructions) {
//
//        instructions.view.frame = CGRect(x: 0, y: 0, width: view.frame.width / 10 * 9, height: view.frame.height / 10 * 8)
//        instructions.view.center = view.center
//        view.addSubview(instructions.view)
//    }
    
    func enlargePiece(view: UIView) {
        
        let transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        view.transform = transform
    }
    
    func shrinkPiece(view: UIView) {
        
        let transform = CGAffineTransform.identity
        view.transform = transform
    }
    
    func addSwipeGestureRecognizer(view: UIView) {
        
        var upSwipe = UISwipeGestureRecognizer()
        var downSwipe = UISwipeGestureRecognizer()
        var rightSwipe = UISwipeGestureRecognizer()
        var leftSwipe = UISwipeGestureRecognizer()
        
        upSwipe = UISwipeGestureRecognizer(target: self, action: #selector( handleSwipe(sender:)))
        upSwipe.direction = .up
        view.addGestureRecognizer(upSwipe)
        
        downSwipe = UISwipeGestureRecognizer(target: self, action: #selector( handleSwipe(sender:)))
        downSwipe.direction = .down
        view.addGestureRecognizer(downSwipe)
        
        rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector( handleSwipe(sender:)))
        rightSwipe.direction = .right
        view.addGestureRecognizer(rightSwipe)
        
        leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector( handleSwipe(sender:)))
        leftSwipe.direction = .left
        view.addGestureRecognizer(leftSwipe)
    }
    
    func removeView(view: UIView) {
        
        let scale = CGAffineTransform(scaleX: 2, y: 2)
        let scale2 = CGAffineTransform(scaleX: 0.01, y: 0.01)
        
        let rotate = CGAffineTransform(rotationAngle: CGFloat.pi)
        
        
//        UIView.animate(withDuration: 0.25, delay: 0.5, animations: {
        UIView.animate(withDuration: 0.25,delay: 0.5) {
            
            
            
//            self.model.board.view.layer.mask?.shadowOpacity = 0.2
//            self.model.board.view.bringSubviewToFront(view)
            

//            self.model.board.view.layer.mask?.shadowOpacity = 0.1
//            self.model.board.view.bringSubviewToFront(view)
//            view.transform = scale
            
            view.transform = scale2.rotated(by: CGFloat.pi)

//            view.transform = rotate


        } completion: { (true) in

//            view.transform = scale2.rotated(by: CGFloat.pi)

        }
    }
    
    func groupTogether(view: UIView, side: String, color: UIColor) {
        
        print("Group Together called!")
        
//        for view in views {
            
        
//        "red" : UIColor.init(red: 0.8, green: 0.1, blue: 0.1, alpha: 0.6),
//        "blue" : UIColor.init(red: 0.0, green: 0.1, blue: 0.9, alpha: 0.6),
//        "green" : UIColor.init(red: 0.0, green: 9.0, blue: 0.4, alpha: 0.6),
        var colorX = UIColor()
        
        let pieceColors = PieceColors()
        
        let colors = pieceColors.colors
        switch color {
            
        case .red:
            
            colorX = colors["red"]!
            
        case .blue:
            
            colorX = colors["blue"]!

        case .green:
            
            colorX = colors["green"]!

            
        default:
            
            
            colorX = colors["yellow"]!
        }
        
        
            UIView.animate(withDuration: 1.0, animations: {
                
                //MARK: PLAY WITH THIS TO GET IT PERFECT. The problem seems to be that #1 the view being added is sometimes behind the pieces and also the color needs to be fixed
                
                
                switch side {
                    
                case "right":
                    
                    
                    
                    let bridgeView = UIView(frame: CGRect(x: self.pieceWidth, y: 0, width: self.pieceWidth * 0.025, height: self.pieceHeight))
                    
                    bridgeView.backgroundColor = color
                    
                    
                    view.addSubview(bridgeView)

//
//
//                    view.layer.sublayers?[0].shadowRadius = 0
//
//                    view.layer.sublayers?[0].shadowOffset = CGSize(width: 0, height: 0)
//
//                    view.layer.sublayers?[0].removeFromSuperlayer()

                case "bottom":
                    
                    let bridgeView = UIView(frame: CGRect(x: 0, y: self.pieceHeight , width: self.pieceWidth, height: self.pieceHeight * 0.025))
                    bridgeView.backgroundColor = color
                    
                    view.addSubview(bridgeView)

//                    view.layer.sublayers?[1].shadowOpacity = 0
//                    view.layer.sublayers?[1].shadowColor = UIColor.clear.cgColor
//                    view.layer.sublayers?[1].shadowRadius = 0
//
//                    view.layer.sublayers?[1].shadowOffset = CGSize(width: 0, height: 0)
//
//                    view.layer.sublayers?[1].removeFromSuperlayer()


                case "left":
//
                    
                    let bridgeView = UIView(frame: CGRect(x: -self.pieceWidth * 0.05, y: 0, width: self.pieceWidth * 0.05, height: self.pieceHeight))
                    
                    bridgeView.backgroundColor = colorX
                    
                    
                    view.addSubview(bridgeView)
                    
//                    view.bringSubviewToFront(bridgeView)
                    
//                    let bridgeView = UIView(frame: CGRect(x: -(self.pieceWidth * 0.025) / 2, y: 0, width: self.pieceWidth * 0.025, height: self.pieceHeight))
//                    bridgeView.backgroundColor = UIColor.purple
//
//                    view.addSubview(bridgeView)
//
////                    view.layer.sublayers?[2].shadowOpacity = 0
////                    view.layer.sublayers?[2].shadowRadius = 0
////
////                    view.layer.sublayers?[2].shadowOffset = CGSize(width: 0, height: 0)
////
////                    view.layer.sublayers?[2].removeFromSuperlayer()
//
                case "top":
//
                    let bridgeView = UIView(frame: CGRect(x: 0, y: -self.pieceHeight * 0.05, width: self.pieceWidth, height: self.pieceHeight * 0.05))
                    bridgeView.backgroundColor = colorX
                    
                    view.addSubview(bridgeView)
                    
//                    view.bringSubviewToFront(bridgeView)
//                    let bridgeView = UIView(frame: CGRect(x: 0, y: 0, width: self.pieceWidth * 0.025, height: self.pieceHeight))
//                    bridgeView.backgroundColor = UIColor.purple
//
//                    view.addSubview(bridgeView)
//
////                    view.layer.sublayers?[3].shadowOpacity = 0
////                    view.layer.sublayers?[3].shadowColor = UIColor.clear.cgColor
////                    view.layer.sublayers?[3].shadowRadius = 0
////
////
////                    view.layer.sublayers?[3].shadowOffset = CGSize(width: 0, height: 0)
////
////                    view.layer.sublayers?[3].removeFromSuperlayer()

                default:
                    
                    break
                    
                    
                    
                }
                
                
                
//                for piece in self.model.board.pieces {
                    
//                    if piece.view.center == view.center {
                        
//                view.layer.sublayers?[0].backgroundColor = CGColor.init(red: 0.1, green: 0.2, blue: 0.3, alpha: 1.0)
//                view.layer.sublayers?[1].backgroundColor = CGColor.init(red: 0.1, green: 0.2, blue: 0.3, alpha: 1.0)
//                
//                view.layer.sublayers?[0].shadowOpacity = 0
                
//                view.layer.sublayers?[1].shadowOpacity = 0

//                if let viewQ = view as? ShapeView {
//
//                    print("It's a Shapeview")
//
////                    viewQ.changeColor(color: UIColor.purple)
////                    viewQ.color = UIColor.purple
//
////                    viewQ.subviews[0].backgroundColor = UIColor.purple
////                    viewQ.subviews[1].backgroundColor = UIColor.purple
////
////                    viewQ.backgroundColor = UIColor.purple
////                    viewQ.setNeedsDisplay()
////                    viewQ.setNeedsLayout()
//
//                    viewQ.layer.sublayers?[0].backgroundColor = CGColor.init(red: 0.1, green: 0.2, blue: 0.3, alpha: 1.0)
//                    viewQ.layer.sublayers?[1].backgroundColor = CGColor.init(red: 0.1, green: 0.2, blue: 0.3, alpha: 1.0)
//
//                }
                
//                        view.backgroundColor = UIColor.purple

//                    }
                    
                    
//                }
                
                
//                self.model.board.view.layer.mask?.shadowOpacity = 0.2
//                self.model.board.view.bringSubviewToFront(view)
//                let scale = CGAffineTransform(scaleX: 0.01, y: 0.01)
//                self.model.board.view.layer.mask?.shadowOpacity = 0.1
//                self.model.board.view.bringSubviewToFront(view)
                
//                view.transform = scale
//                view.backgroundColor = .orange
//                view.setNeedsLayout()
//                view.setNeedsDisplay()
                
            }) { (true) in
//                view.backgroundColor = UIColor.orange
            }
            
            
//        }
        
        
        
        
    }
    
    
    func animateGrouping(piece: Piece) {
        
        UIView.animate(withDuration: 0.25, delay: 0.00) {
            let transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            
            piece.view.transform = transform
            
            
        
            
        } completion: { (true) in
            
            UIView.animate(withDuration: 0.25) {
                let transform = CGAffineTransform(scaleX: 1, y: 1)

                piece.view.transform = transform
            }
            
        }
        
        
        
    }
    
    
    func addPieceToBoard(piece: Piece) {
        
        if let indexes = piece.indexes {
            
            
            print("Yes.........")
//            piece.view = self.nextPiece.view
            
            
//            self.nextPiece.view.removeFromSuperview()
            
            piece.center = CGPoint(x: self.model.board.grid[indexes]!.x, y: self.model.board.grid[indexes]!.y)
            
            let center = CGPoint(x: (self.boardWidth / 2) - (self.pieceWidth / 2), y: 500)
        
        var frame = CGRect(x: center.x, y: center.y, width: self.pieceWidth, height: self.pieceHeight)
        
        piece.view = ShapeView(frame: frame, piece: piece, groups: self.model.board.pieceGroups)
        
        
            piece.view.center = piece.center
            
        
            
            
            
            
            UIView.animate(withDuration: 0.25, delay: 0.00, options: .curveEaseIn) {
                
                //            if let indexes = piece.indexes {
                
                
                self.model.board.view.addSubview(piece.view)
                
//                self.nextPiece = Piece()
//                self.model.nextPiece = Piece()
//                self.model.setupNextView()
                
//                self.model.updateLabels()
                
                
//                let transform = CGAffineTransform(scaleX: 2, y: 2)
//
//                piece.view.transform = transform
                //            }
            } completion: { [self] (true) in
//
//                UIView.animate(withDuration: 0.25) {
////                    let transform = CGAffineTransform(scaleX: 1, y: 1)
////
////                    piece.view.transform = transform
//                }
//
//
//
//
            }
        }
        
        
    }
    
    
    
    
    func moveNextPieceOnToBoard(piece: Piece) {

        if let indexes = piece.indexes {
            
            piece.view = self.nextPieceView as! ShapeView
            
            
//            self.nextPiece.view.removeFromSuperview()
            
            
            UIView.animate(withDuration: 0.25, delay: 0.25, options: .curveEaseIn) {
                
                //            if let indexes = piece.indexes {
                
                piece.center = CGPoint(x: self.model.board.grid[indexes]!.x, y: self.model.board.grid[indexes]!.y)
                
                piece.view.center = piece.center
                
                self.nextPieceView = UIView()
//                self.model.nextPiece = Piece()
//                self.model.setupNextView()
                
//                self.model.updateLabels()
                
                
//                let transform = CGAffineTransform(scaleX: 2, y: 2)
//
//                piece.view.transform = transform
                //            }
            } completion: { [self] (true) in
                
                UIView.animate(withDuration: 0.25) {
//                    let transform = CGAffineTransform(scaleX: 1, y: 1)
//
//                    piece.view.transform = transform
                    
//                    self.model.nextPiece = Piece(indexes: Indexes(x: nil, y: nil), color: self.model.returnRandomColor())
//
//
//                    self.setUpNextView(nextPiece: self.model.nextPiece)
                    
                    
                }
                
                
                
                
            }
        }
    }
    
    func movePieceView(piece: Piece) {

        if let indexes = piece.indexes {
            
            if indexes.x! < 0 {
                
                UIView.animate(withDuration: 0.25) {
                    piece.center = CGPoint(x: piece.center.x - (self.distanceFromPieceCenter * 2), y: piece.center.y)
                    piece.view.center = piece.center
                }
                
            } else if indexes.x! > self.model.board.widthSpaces - 1 {
                
                UIView.animate(withDuration: 0.25) {
                    piece.center = CGPoint(x: piece.center.x + (self.distanceFromPieceCenter * 2), y: piece.center.y)
                    piece.view.center = piece.center

                }
                
            } else if indexes.y! < 0 {
                
                UIView.animate(withDuration: 0.25) {
                    piece.center = CGPoint(x: piece.center.x, y: piece.center.y - (self.distanceFromPieceCenter * 2))
                    piece.view.center = piece.center

                }
                
            } else if indexes.y! > self.model.board.heightSpaces - 1 {
                
                UIView.animate(withDuration: 0.25) {
                    piece.center = CGPoint(x: piece.center.x, y: piece.center.y + (self.distanceFromPieceCenter * 2))
                    piece.view.center = piece.center

                }
                
            } else {
                
                //Piece is on the board and therefore execute move regularly
                UIView.animate(withDuration: 0.25) {
                    piece.center = self.model.board.grid[indexes]!
                    piece.view.center = piece.center
                    
                }
            }
        }
    }
    
    func setUpPiecesView() {
        
        var pieces = [Piece]()
        
        let center = CGPoint(x: (self.boardWidth / 2) - (pieceWidth / 2), y: 500)
        
        let counter = 0.0
        
        let pieceGroups = model.board.pieceGroups
        
        for group in pieceGroups {
            for piece in group.pieces {
                pieces.append(piece)
                
            }
        }
        
        for piece in pieces {
            
//            counter += 0.03
            
            UIView.animate(withDuration: 1.0, delay: counter, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.9, options: .curveEaseInOut) {
                
                var frame = CGRect(x: center.x, y: center.y, width: self.pieceWidth, height: self.pieceHeight)
                
                if !self.model.board.pieceGroups.isEmpty {
                    
                    for group in self.model.board.pieceGroups {
                        
                        if group.pieces.contains(where: { (pieceXX) in
                            pieceXX.indexes == piece.indexes
                        }) {
                            frame = CGRect(x: center.x, y: center.y, width: self.pieceWidth / 9 * 9, height: self.pieceHeight / 9 * 9)
                        }
                    }
                }
                
                if let indexes = piece.indexes {
                    
                    piece.view = ShapeView(frame: frame, piece: piece, groups: self.model.board.pieceGroups)
                    piece.center = CGPoint(x: self.model.board.grid[indexes]?.x ?? piece.center.x, y: self.model.board.grid[indexes]?.y ?? piece.center.y)
                    piece.view.center = piece.center
                    self.model.board.view.addSubview(piece.view)
                }
                
            } completion: { (true) in
                
            }
        }
    }
    
    func runPopUpView(title: String, message: String) {
          
        let delayedTime = DispatchTime.now() + .milliseconds(Int(250))
        
        DispatchQueue.main.asyncAfter(deadline: delayedTime) {
        
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .default) { (action) in
                alert.dismiss(animated: true) {
                                                            
                    let delayedTime = DispatchTime.now() + .milliseconds(Int(25))
                    DispatchQueue.main.asyncAfter(deadline: delayedTime) {

                        self.removeViews()
                        self.model.setUpGame()
                        self.model.setUpControlsAndInstructions()
                        
                        DispatchQueue.main.asyncAfter(deadline: delayedTime + 0.25) {
                            //Add code here if you want something to happen after the first wait
                        }
                    }
                }
            }
            
            alert.addAction(action)
            
            if title == "Restart" {
                
                let cancelAction = UIAlertAction(title: "Cancel", style: .default) { (cancelAction) in
                    alert.dismiss(animated: true) {
                        //Add code
                    }
                }
                alert.addAction(cancelAction)
            }
            
            self.present(alert, animated: true) {
                //completion here
            }
        }
    }
    
    func removeViews() {
        
        self.boardView.removeFromSuperview()
        self.retryButton.removeFromSuperview()
        self.menuButton.removeFromSuperview()
    }
    
    func setUpGameViews(board: Board) {
                
        self.setSizes(board: board)
        self.setupGrid()
        self.setupBoard(board: board)
//        g
    }
    
    func setUpNextView(nextPiece: Piece) {
        
        //MARK: Need to make sure that this happens AFTER the original nextPiece goes onto the board.
        
        let nextViewHeight = pieceHeight
        let nextViewWidth = pieceWidth
        let nextViewYFloat = (view.frame.midY)
        let nextViewXFloat = view.center.x - (nextViewWidth / 2)// - (pieceWidth / 2)
        
//        let nextViewXFloat = 0.0

        let frame = CGRect(x: nextViewXFloat, y: nextViewYFloat, width: nextViewWidth, height: nextViewHeight)
        
        self.nextPieceView = ShapeView(frame: frame, piece: nextPiece, groups: nil)
        self.model.board.view.addSubview(self.nextPieceView)
//        self.nextPiece = nextPiece
        
        let transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        let transform2 = CGAffineTransform.identity
        UIView.animate(withDuration: 0.25, delay: 0.25, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0) {
            
//            self.nextPieceView.transform = transform
            
          
//            self.nextPieceView.frame
            
           
            
//            self.boardView.addSubview(self.nextPieceView)

            
            
        }  completion: { [self] (true) in
            
            
//            self.nextPieceView.transform = transform2

            
            
        }
//        makeSoft(view: self.nextPiece.view)
    }
    
    private func makeSoft(view: UIView) {
        
        let shadowRadius: CGFloat = 1
        let darkShadow = CALayer()
        let lightShadow = CALayer()
        
        lightShadow.frame = view.layer.bounds
        lightShadow.backgroundColor = view.backgroundColor?.cgColor
        lightShadow.shadowColor = UIColor.white.cgColor
        lightShadow.shadowOffset = CGSize(width: -shadowRadius, height: -shadowRadius)
        lightShadow.shadowOpacity = 1
        view.layer.insertSublayer(lightShadow, at: 0)

        darkShadow.frame = view.layer.bounds
        darkShadow.backgroundColor = view.backgroundColor?.cgColor
        darkShadow.shadowColor = UIColor.black.cgColor
        darkShadow.shadowOffset = CGSize(width: shadowRadius, height: shadowRadius)
        darkShadow.shadowOpacity = 1
        view.layer.insertSublayer(darkShadow, at: 1)
    }
    
    func setUpControlViews() {
        self.setupControls()
    }
    
    func clearPiecesAnimation(view: UIView) {
        
        UIView.animate(withDuration: 0.25) {
            
            let center = CGPoint(x: self.boardWidth / 2, y: self.boardHeight / 2)
            let translationX = center.x - view.center.x
            let translationY = center.y - view.center.y
            let transform = CGAffineTransform(translationX: translationX, y: translationY)
            
            view.transform = transform
            
        } completion: { (true) in
            
        }
    }
}



