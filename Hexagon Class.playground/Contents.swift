//: Playground - noun: a place where people can play

import UIKit
import XCPlayground

// Background view
let frame = CGRectMake(0, 0, 500, 800)
let view = UIView(frame: frame)
view.backgroundColor = UIColor.whiteColor()
//XCPlaygroundPage.currentPage.liveView = view

// Class HexagonFactory
class HexagonFactory: NSObject {
    var fillColor: UIColor?
    var strokeColor: UIColor?
    
    enum Offset {
        case Even
        case Odd
    }
    
    enum HexType {
        case Flat
        case Pointy
    }
    
    func grid(rows: Int, columns: Int, offset: Offset, hexSize: CGFloat, type: HexType) -> UIView
    {
        let gridWidth: CGFloat = 500
        let gridHeight: CGFloat = 800
        let view = UIView(frame: CGRect(x: 0, y: 0, width: gridWidth, height: gridHeight))
        
        let hexWidth: CGFloat
        let hexHeight: CGFloat
        let horiz: CGFloat
        let vert: CGFloat
        
        if type == .Flat {
            hexWidth = hexSize * 2
            hexHeight = sqrt(3)/2 * hexWidth
            horiz = hexWidth * 3/4
            vert = hexHeight
        }
        else {
            hexHeight = hexSize * 2
            hexWidth = sqrt(3)/2 * hexHeight
            vert = hexHeight * 3/4
            horiz = hexWidth
        }
        
        for rowIndex in 0..<rows
        {
            var xOffset: CGFloat = 0
            if type == .Pointy {
                if rowIndex % 2 == 1 && offset == .Odd {
                    xOffset = horiz * 0.5
                }
                else if rowIndex % 2 == 0 && offset == .Even {
                    xOffset = horiz * 0.5
                }
            }
            
            for columnIndex in 0..<columns
            {
                let x: CGFloat = CGFloat(columnIndex) * horiz + xOffset
                var y: CGFloat = CGFloat(rowIndex) * vert
                
                if type == .Flat {
                    // Calculate y Offset
                    let yOffset: CGFloat
                
                    if columnIndex % 2 == 1 && offset == .Odd {
                        yOffset = vert * 0.5
                    }
                    else if columnIndex % 2 == 0 && offset == .Even {
                        yOffset = vert * 0.5
                    }
                    else {
                        yOffset = 0
                    }
                    y += yOffset
                }
                
                let center: CGPoint = CGPoint(x: x, y: y)
                view.layer.addSublayer(hexagon(center, size: hexSize, type: type))
            }
        }
        
        return view
    }
    
    func hexagon(center: CGPoint, size: CGFloat, type: HexType) -> CAShapeLayer {
        let firstCorner = hexCorner(center, size: size, corner: 0, type: type)
        let path = UIBezierPath()
        path.moveToPoint(firstCorner)
        for index in 1...5 {
            let corner = hexCorner(center, size: size, corner: index, type: type)
            path.addLineToPoint(corner)
        }
        path.addLineToPoint(firstCorner)
        let layer = CAShapeLayer()
        layer.path = path.CGPath
        
        layer.fillColor = fillColor?.CGColor
        layer.strokeColor = strokeColor?.CGColor
        
        return layer
    }
    
    func hexCorner(center: CGPoint, size: CGFloat, corner: Int, type: HexType) -> CGPoint
    {
        var angle_deg: CGFloat = CGFloat(60) * CGFloat(corner)
        if type == .Pointy {
            angle_deg += 30
        }
        let angle_rad: CGFloat = CGFloat(M_PI / 180) * angle_deg
        let x: CGFloat = center.x + size * cos(angle_rad)
        let y: CGFloat = center.y + size * sin(angle_rad)
        return CGPointMake(x, y)
    }
}

// Create HexagonFactory
let hexFactory = HexagonFactory()
//hexFactory.fillColor = UIColor.orangeColor()
hexFactory.strokeColor = UIColor.blackColor()

// Make a Flat hex
let flatHex = hexFactory.hexagon(CGPointMake(200, 200), size: 100, type: .Flat)
//view.layer.addSublayer(flatHex)

// Make a pointy hex
let pointyHex = hexFactory.hexagon(CGPointMake(200, 400), size: 100, type: .Pointy)
//view.layer.addSublayer(pointyHex)

func makeAColumnOfFlatHexes(columnIndex: Int) {
    let size: CGFloat = 100.0
    let width = size * 2
    let height = sqrt(3)/2 * width
    let horiz = width * 3/4
    let vert = height

    // Make a row of flat hexagons
    for index in 0...5 {
        let x: CGFloat = CGFloat(columnIndex) * horiz
        var y: CGFloat = CGFloat(index) * CGFloat(vert)
        if columnIndex % 2 == 1 {
            y += vert * 0.5
        }
        let center = CGPointMake(x, y)
        let flatHex = hexFactory.hexagon(center, size: size, type: .Flat)
        view.layer.addSublayer(flatHex)
    }
}

func makeARowOfPointyHexes(rowIndex: Int) {
    let size: CGFloat = 100.0
    let height: CGFloat = size * 2
    let vert = height * 3/4
    let width = sqrt(3)/2 * height
    let horiz = width
    
    for index in 0..<3 {
        var x: CGFloat = CGFloat(horiz) * CGFloat(index)
        let y: CGFloat = CGFloat(rowIndex) * vert
        if rowIndex % 2 == 1 {
            x += horiz * 0.5
        }
        let center = CGPointMake(x, y)
        let pointyHex = hexFactory.hexagon(center, size: size, type: .Pointy)
        view.layer.addSublayer(pointyHex)
    }
}
hexFactory.fillColor = UIColor.orangeColor()

XCPlaygroundPage.currentPage.liveView = hexFactory.grid(6, columns: 4, offset: .Odd, hexSize: 40, type: .Pointy)
