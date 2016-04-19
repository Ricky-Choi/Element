import Foundation

class PathGraphic:SizeableDecorator{
    var path:IPath
    var fillBoundingBox:CGRect?
    init(_ path:IPath, _ decoratable: IGraphicDecoratable = BaseGraphic(nil,LineStyle())) {
        Swift.print("PathGraphic.init()")
        self.path = path
        super.init(decoratable)
    }
    override func drawFill() {
        Swift.print("PathGraphic.drawFill()")
        let cgPath = DisplayPathUtils.compile(CGPathCreateMutable(), path)
        fillBoundingBox = CGPathGetPathBoundingBox(cgPath)/*there is also CGPathGetPathBoundingBox, CGPathGetBoundingBox, which works a bit different, the difference is probably just support for cruves etc*/
        Swift.print("fillPathBoundingBox: " + "\(fillBoundingBox)")
        graphic.fillShape.frame = fillBoundingBox!
        let offset = CGPoint(-fillBoundingBox!.x,-fillBoundingBox!.y)
        var offsetPath = cgPath.copy()
        graphic.fillShape.path = CGPathModifier.translate(&offsetPath, offset.x, offset.y)
    }
    override func drawLine() {
        Swift.print("PathGraphic.drawLine()")
        var boundingBox:CGRect = PathParser.boundingBox(graphic.fillShape.path, graphic.lineStyle!)/*regardless if the line is inside outside or centered, this will still work, as the path is already exapnded correctly*/
        Swift.print("boundingBox: " + "\(boundingBox)")
        boundingBox += fillBoundingBox!.topLeft
        graphic.lineShape.frame = boundingBox
        let offset = CGPoint(-boundingBox.x,-boundingBox.y)
        var offsetPath = graphic.fillShape.path.copy()
        graphic.lineShape.path = CGPathModifier.translate(&offsetPath, offset.x, offset.y)
    }
}
extension PathGraphic{
    convenience init(_ path:IPath, _ fillStyle:IFillStyle?, _ lineStyle:ILineStyle?) {
        self.init(path, BaseGraphic(fillStyle,lineStyle))
    }
    convenience init(_ path:IPath, _ gradientFillStyle:GradientFillStyle?, _ gradientlineStyle:GradientLineStyle?) {
        self.init(path, GradientGraphic(BaseGraphic(gradientFillStyle,gradientlineStyle)))
    }
}