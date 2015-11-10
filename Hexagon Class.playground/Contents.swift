//: Playground - noun: a place where people can play

import UIKit
import XCPlayground

// Background view
let frame = CGRectMake(0, 0, 500, 800)
let view = UIView(frame: frame)
view.backgroundColor = UIColor.whiteColor()
XCPlaygroundPage.currentPage.liveView = view

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
    
//    func grid(rows: Int, columns: Int, offset: Offset, hexSize: CGFloat) -> UIView
//    {
//        
//    }
    
    func flatHexagon(center: CGPoint, size: CGFloat) -> CAShapeLayer {
        return hexagon(center, size: size, pointy: false)
    }
    
    func pointyHexagon(center: CGPoint, size: CGFloat) -> CAShapeLayer {
        return hexagon(center, size: size, pointy: true)
    }
    
    func hexagon(center: CGPoint, size: CGFloat, pointy: Bool) -> CAShapeLayer {
        let firstCorner = hexCorner(center, size: size, corner: 0, pointy: pointy)
        let path = UIBezierPath()
        path.moveToPoint(firstCorner)
        for index in 1...5 {
            let corner = hexCorner(center, size: size, corner: index, pointy: pointy)
            path.addLineToPoint(corner)
        }
        path.addLineToPoint(firstCorner)
        let layer = CAShapeLayer()
        layer.path = path.CGPath
        
        layer.fillColor = fillColor?.CGColor
        layer.strokeColor = strokeColor?.CGColor
        
        return layer
    }
    
    func hexCorner(center: CGPoint, size: CGFloat, corner: Int, pointy: Bool) -> CGPoint
    {
        var angle_deg: CGFloat = CGFloat(60) * CGFloat(corner)
        if pointy {
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
let flatHex = hexFactory.flatHexagon(CGPointMake(200, 200), size: 100)
//view.layer.addSublayer(flatHex)

// Make a pointy hex
let pointyHex = hexFactory.pointyHexagon(CGPointMake(200, 400), size: 100)
//view.layer.addSublayer(pointyHex)

func makeAColumnOfFlatHexes() {
    let size: CGFloat = 100.0
    let width = size * 2
    let height = sqrt(3)/2 * width
    let horiz = width * 3/4
    let vert = height

    // Make a row of flat hexagons
    for index in 0...5 {
        let x: CGFloat = 100
        let y: CGFloat = CGFloat(index) * CGFloat(vert)
        let center = CGPointMake(x, y)
        let flatHex = hexFactory.flatHexagon(center, size: size)
        view.layer.addSublayer(flatHex)
    }
}

func makeARowOfPointyHexes() {
    let size: CGFloat = 100.0
    let height: CGFloat = size * 2
    let vert = height * 3/4
    let width = sqrt(3)/2 * height
    let horiz = width
    
    for index in 0...5 {
        let x: CGFloat = CGFloat(horiz) * CGFloat(index)
        let y: CGFloat = 100
        let center = CGPointMake(x, y)
        let pointyHex = hexFactory.pointyHexagon(center, size: size)
        view.layer.addSublayer(pointyHex)
    }
}
func fillFlatGrid() {
    for yIndex in 0...8 {
        let vert: CGFloat = sqrt(3)/2 * 200
        let yOffset = vert * CGFloat(yIndex)
        makeAColumnOfFlatHexes()
    }
}
//fillFlatGrid()
makeARowOfPointyHexes()
makeAColumnOfFlatHexes()