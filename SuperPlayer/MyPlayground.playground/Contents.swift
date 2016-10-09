//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"

struct Point{
    var x = 0.0, y = 0.0
}

struct Size{
    var width = 10.0, height = 10.0
}

struct Rect{
    var origin = Point()
    var size = Size()
    func getCenter() -> (Double, Double) {
        let x = origin.x + (size.width/2)
        let y = origin.y + (size.height/2)
        return (x, y)
    }
}

var rect = Rect(origin: Point(x: 100, y: 100), size: Size(width: 200, height: 100))
var (x, y) = rect.getCenter()

print(x, y)
