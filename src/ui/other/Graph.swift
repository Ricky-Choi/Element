import Cocoa

class Graph:Element {
    var hValues:[CGFloat] = [0,2,7,1,4,0,3]
    var hValNames:[String] = ["A","B","C","D","E","F","G"]/*horizontal items*/
    var vCount:Int = 4/*number of vertical items*/
    var leftBar:Section?
    var bottomBar:Section?
    var graphArea:Section?
    var graphLine:GraphLine?
    var graphPoints:[Element] = []
    override func resolveSkin() {
        super.resolveSkin()
        //createGraphElements()
        
        //create 2 boxes. one that is embedded in the other and is 3:4 ratio
        
        //Swift.print("graph.width: " + "\(width)")
        //Swift.print("graph.height: " + "\(height)")
        let newSize:CGSize = Resizer.fit(CGSize(w,h),4/3)
        Swift.print("newSize: " + "\(newSize)")
        let newPostition:CGPoint = Align.alignmentPoint(newSize, CGSize(width/**/,height/**/), Alignment.centerCenter, Alignment.centerCenter,CGPoint(0,0))
        Swift.print("newPostition: " + "\(newPostition)")
        
        createGraphArea(newSize,newPostition)
        let itemYSpace:CGFloat = createLeftBar(newSize,newPostition)
        let itemXSpace:CGFloat = createBottomBar(newSize,newPostition)
        let spacing:CGSize = CGSize(itemXSpace,itemYSpace)
        
        let graphPts = GraphUtils.points(newSize, newPostition, spacing, hValues)
        //createGraphLine(newSize, newPostition, spacing, graphPts)
        createGraphPoints(newSize,newPostition,spacing,graphPts)
        //alignUI()
    }
    /**
     *
     */
    func createGraphArea(size:CGSize,_ position:CGPoint){
        graphArea = addSubView(Section(size.width,size.height,self,"graphArea"))
        graphArea?.setPosition(position)
    }
    /**
     *
     */
    func createLeftBar(size:CGSize,_ position:CGPoint)->CGFloat{
        leftBar = addSubView(Section(NaN,size.height,self,"leftBar"))//create left bar
        leftBar!.setPosition(CGPoint(0,position.y))
        
        //Continue here: Use TextArea and use margin-top:50%; in Textarea and margin-top: -(fontSize/2)
        
        var maxValue:CGFloat = NumberParser.max(hValues)
        let itemYSpace:CGFloat = size.height/(vCount.cgFloat+1)
        Swift.print("itemYSpace: " + "\(itemYSpace)")
        if(NumberAsserter.odd(maxValue)){
            maxValue += 1//We need even values when we devide later
        }
        Swift.print("maxValue: " + "\(maxValue)")
        var y:CGFloat = itemYSpace
        for i in (0..<vCount).reverse() {
            var num:CGFloat = (maxValue/vCount.cgFloat)*i
            num = round(num)//NumberModifier.toFixed(num, 0)
            let str:String = num.string
            let textArea:TextArea = TextArea(NaN,NaN,str,leftBar!)
            leftBar!.addSubView(textArea)
            textArea.setPosition(CGPoint(0,y))
            y += itemYSpace
            //Tip: use skin.getWidth() if you need to align Element items with Align 
        }
        return itemYSpace
    }
    /**
     *
     */
    func createBottomBar(size:CGSize,_ position:CGPoint)->CGFloat{
        Swift.print("createBottomBar")
        Swift.print("size: " + "\(size)")
        Swift.print("position: " + "\(position)")
        bottomBar = addSubView(Section(size.width,NaN,self,"bottomBar"))//create bottom bar
        bottomBar!.setPosition(CGPoint(position.x,position.y+size.height-bottomBar!.getHeight()))
        
        let hCount:Int = hValNames.count
        Swift.print("hCount: " + "\(hCount)")
        //let itemWidth:CGFloat = size.width / hCount.cgFloat
        let itemXSpace:CGFloat = size.width/(hCount.cgFloat + 1)
        Swift.print("itemXSpace: " + "\(itemXSpace)")
        var x:CGFloat = itemXSpace
        for i in 0..<hCount{
            let str:String = hValNames[i]
            Swift.print("str: " + "\(str)")
            let textArea:TextArea = TextArea(NaN,NaN,str,bottomBar!)
            bottomBar!.addSubView(textArea)
            Swift.print("CGPoint(x,0): " + "\(CGPoint(x,0))")
            textArea.setPosition(CGPoint(x,0))
            x += itemXSpace
        }
        return itemXSpace
    }
    
    /**
     * //onResize
     * //recalc spacing
     * //height should be uniform to the width
     * //Realign components
     */
    func alignUI(){
        //Scale to ratio:
        let newSize:CGSize = Resizer.fit(CGSize(w,h),4/3)
        graphArea!.setSize(newSize.width,newSize.height)
        let alignmentPoint:CGPoint = Align.alignmentPoint(CGSize(graphArea!.frame.width,graphArea!.frame.height), CGSize(width/**/,height/**/), Alignment.centerCenter, Alignment.centerCenter,CGPoint(0,0))
        graphArea?.setPosition(alignmentPoint)
    
    }
  
    func createGraphPoints(size:CGSize,_ position:CGPoint,_ spacing:CGSize, _ graphPts:[CGPoint]){
    
        graphPts.forEach{
            let graphPoint:Element = graphArea!.addSubView(Element(NaN,NaN,graphArea,"graphPoint"))
            graphPoints.append(graphPoint)
            graphPoint.setPosition($0)
            //style the button similar to VolumSlider knob (with a blue center, a shadow and white border, test different designs)
            //set the size as 12px and offset to -6 (so that its centered)
        }
    }
    
    func createGraphLine(size:CGSize,_ position:CGPoint,_ spacing:CGSize, _ graphPts:[CGPoint]){
        let graphPath:IPath = PolyLineGraphicUtils.path(graphPts)/*convert points to a Path*/
        graphLine = graphArea!.addSubView(GraphLine(width,height,graphPath,graphArea))
        
    }
  
    override func setSize(width: CGFloat, _ height: CGFloat) {
        //update different UI elements
    }
}
class GraphLine:Element{
    var line:PathGraphic?//<--we could also use PolyLineGraphic, but we may support curvey Graphs in the future
    var path:IPath
    init(_ width: CGFloat, _ height: CGFloat,_ path:IPath, _ parent: IElement? = nil, _ id: String? = nil) {
        self.path = path
        super.init(width, height, parent, id)
    }
    override func resolveSkin() {
        skin = SkinResolver.skin(self)//you could use let style:IStyle = StyleResolver.style(element), but i think skin has to be created to not cause bugs 
        //I think the most apropriate way is to make a custom skin and add it as a subView wich would implement :ISkin etc, see TextSkin for details
        //Somehow derive the style data and make a basegraphic with it
        let lineStyle:ILineStyle = StylePropertyParser.lineStyle(skin!)!
        let baseGraphic = BaseGraphic(nil,lineStyle)
        line = PathGraphic(path,baseGraphic)
        addSubView(line!.graphic)
        line!.draw()
    }
    override func setSkinState(skinState: String) {
        //update the line
    }
    override func setSize(width: CGFloat, _ height: CGFloat) {
        //update the line
    }
    required init?(coder: NSCoder) {fatalError("init(coder:) has not been implemented") }
}
private class GraphUtils{
    /**
     * Returns graph points
     */
    static func points(size:CGSize,_ position:CGPoint,_ spacing:CGSize, _ hValues:[CGFloat]) -> [CGPoint]{
        var points:[CGPoint] = []
        let hCount:Int = hValues.count
        let x:CGFloat = /*position.x*/ 0
        let y:CGFloat = /*position.y +*/ size.height - spacing.height
        for i in 0..<hCount{//calc the graphPoints:
            var p = CGPoint()
            p.x = x + (i * spacing.width)
            p.y = y + (hValues[i] * spacing.height)
            points.append(p)
        }
        return points
    }
}