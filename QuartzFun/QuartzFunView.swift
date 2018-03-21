//
//  QuartzFunView.swift
//  QuartzFun
//
//  Created by Emily on 3/19/18.
//  Copyright © 2018 Emily. All rights reserved.
//

import UIKit

class QuartzFunView: UIView {
    
    enum Shape: Int{
        case line = 0, rect, ellipse, image
    }
    
    enum DrawingColor: Int{
        case red = 0, blue, yellow, green, random
    }
    
    @IBOutlet weak var colorControl: UISegmentedControl!
    @IBOutlet weak var shapeControl: UISegmentedControl!
    var shape = Shape.line
    var currentColor = UIColor.red
    var useRandomColor = false
    
    private let image = UIImage(named: "cat")
    private var firstTouchLocation = CGPoint.zero
    private var lastTouchLocation = CGPoint.zero
    private var redrawRect = CGRect.zero
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    override func draw(_ rect: CGRect){
        let context = UIGraphicsGetCurrentContext()
        context?.setLineWidth(2.0)
        context?.setStrokeColor(currentColor.cgColor)
        context?.setFillColor(currentColor.cgColor)
        let currentRect = CGRect(x: firstTouchLocation.x, y: firstTouchLocation.y, width: lastTouchLocation.x - firstTouchLocation.x, height: lastTouchLocation.y - firstTouchLocation.y)
        
        switch(shape){
        case .line:
            context?.move(to: CGPoint(x: firstTouchLocation.x, y: firstTouchLocation.y))
            context?.addLine(to:CGPoint(x: lastTouchLocation.x, y: lastTouchLocation.y))
            context?.strokePath()
            
        case .rect:
            context?.addRect(currentRect)
            context?.drawPath(using: .fillStroke)
            break
        case .ellipse:
            context?.addEllipse(in: currentRect)
            context?.drawPath(using: .fillStroke)
            break
        case .image:
            let horizontalOffset = image!.size.width / 2
            let verticalOffset = image!.size.height / 2
            let drawPoint = CGPoint(x: lastTouchLocation.x - horizontalOffset, y: lastTouchLocation.y - verticalOffset)
            image!.draw(at: drawPoint)
            break
            
        }
    }
    func currentRect() -> CGRect {
        return CGRect( x: firstTouchLocation.x, y: firstTouchLocation.y, width: lastTouchLocation.x - firstTouchLocation.x, height: lastTouchLocation.y - firstTouchLocation.y)
    }

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        if let touch = touches.first{
            if(useRandomColor){
                currentColor = UIColor.randomColor()
            }
            firstTouchLocation = touch.location(in:self)
            lastTouchLocation = firstTouchLocation
            redrawRect = CGRect.zero
            setNeedsDisplay()
            
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?){
        if let touch = touches.first{
            lastTouchLocation = touch.location(in:self)
            if shape == .image{
                let horizontalOffset = image!.size.width / 2
                let verticalOffset = image!.size.height / 2
                redrawRect = redrawRect.union(CGRect(x: lastTouchLocation.x - horizontalOffset, y: lastTouchLocation.y - verticalOffset, width: image!.size.width, height: image!.size.height))
            }else{
                redrawRect = redrawRect.union(currentRect())
            }
            setNeedsDisplay(redrawRect)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?){
        if let touch = touches.first{
            lastTouchLocation = touch.location(in: self)
            
        if shape == .image{
                let horizontalOffset = image!.size.width / 2
                let verticalOffset = image!.size.height / 2
                redrawRect = redrawRect.union(CGRect(x: lastTouchLocation.x - horizontalOffset, y: lastTouchLocation.y - verticalOffset, width: image!.size.width, height: image!.size.height))
            }else{
                redrawRect = redrawRect.union(currentRect())
            }
            setNeedsDisplay(redrawRect)
        }
    }
    
    @IBAction func changeColor(_ sender: UISegmentedControl) {
            switch(colorControl.selectedSegmentIndex){
            case 0:
                currentColor = UIColor.red
                useRandomColor = false
                break
            case 1:
                currentColor = UIColor.blue
                useRandomColor = false
            case 2:
                currentColor = UIColor.yellow
                useRandomColor = false
            case 3:
                currentColor = UIColor.green
                useRandomColor = false
            case 4:
                useRandomColor = true
            default:
                break
            }
    }
    
    
    @IBAction func changeShape(_ sender: UISegmentedControl) {
        switch(shapeControl.selectedSegmentIndex){
        case 0:
            shape = .line
            break
        case 1:
            shape = .rect
        case 2:
            shape = .ellipse
        case 3:
            shape = .image
        default:
            break
        }
    }

    
}
extension UIColor{
    class func randomColor()-> UIColor{
        let red = CGFloat(Double(arc4random_uniform(255))/255)
        let green = CGFloat(Double(arc4random_uniform(255))/255)
        let blue = CGFloat(Double(arc4random_uniform(255))/255)
        return UIColor(red: red, green:green, blue:blue, alpha:1.0)
    }
}
