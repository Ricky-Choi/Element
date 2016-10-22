import Cocoa

class Graph:Element {
    var hValues:[Int] = [0,2,7,1,4,0,3]
    var hValNames:[String] = ["A,B,C,D,E,F,G"]/*horizontal items*/
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
        let newPostition:CGPoint = Align.alignmentPoint(newSize, CGSize(width/**/,height/**/), Alignment.centerCenter, Alignment.centerCenter,CGPoint(0,0))
        createGraphArea(newSize,newPostition)
        createLeftBar(newSize,newPostition)
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
    func createLeftBar(size:CGSize,_ position:CGPoint){
        leftBar = addSubView(Section(NaN,size.height,self,"leftBar"))//create left bar
        leftBar!.setPosition(CGPoint(0,position.y))
        
        //Continue here: Use TextArea and use margin-top:50%; in Textarea and margin-top: -(fontSize/2)
        
        var maxValue:Int = IntParser.max(hValues)
        let itemHeight:CGFloat = size.height/vCount.cgFloat
        Swift.print("itemHeight: " + "\(itemHeight)")
        if(NumberAsserter.odd(maxValue.cgFloat)){
            maxValue += 1//We need even values when we devide later
        }
        Swift.print("maxValue: " + "\(maxValue)")
        for i in (0..<vCount).reverse() {
            var num:CGFloat = ((maxValue/vCount)*i).cgFloat
            num = round(num)//NumberModifier.toFixed(num, 0)
            let str:String = num.string
            let text:TextArea = TextArea(NaN,itemHeight,str,leftBar!)
            leftBar!.addSubView(text)
        }
        /**/
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
    /**
     *
     */
    func createGraphElements(){
        /*LeftBar*/
        let itemHeight:CGFloat = height/vCount.cgFloat
        
        bottomBar = Section(NaN,NaN,self,"bottomBar")//create bottom bar
        let hCount = hValNames.count
        let itemWidth:CGFloat = width/hCount.cgFloat
        for i in 0..<hCount{
            let str:String = hValNames[i]
            let text:Text = Text(itemWidth,NaN,str,bottomBar!)
            bottomBar!.addSubView(text)
        }
        
        graphArea = Section(NaN,NaN,self,"graphArea")
        
        var graphPts:[CGPoint] = []
        
        for i in 0..<hCount{//calc the graphPoints:
            var p = CGPoint()
            p.x = i * itemWidth
            p.y = hValues[i] * itemHeight
            graphPts.append(p)
        }
        
        let graphPath:IPath = PolyLineGraphicUtils.path(graphPts)/*convert points to a Path*/
        graphLine = graphArea!.addSubView(GraphLine(width,height,graphPath,graphArea))
        
        graphPts.forEach{
            let graphPoint:Element = graphArea!.addSubView(Element(NaN,NaN,graphArea,"graphPoint"))
            graphPoint.setPosition($0)
            graphPoints.append(graphPoint)
            //style the button similar to VolumSlider knob (with a blue center, a shadow and white border, test different designs)
            //set the size as 12px and offset to -6 (so that its centered)
        }
        
        align()
    }
    /**
     * Aligns UI elements
     * NOTE: we align/scale everything dynamically not via css
     */
    func align(){
        //align things, remember constraints
        
        //4:3 layout ratio
        let h:CGFloat = round((w/4)*3)
        
        var leftBarPos:CGPoint = CGPoint(0,0)
        leftBarPos.y = (height-h)/2
        var bottomBarPos:CGPoint = CGPoint(0,0)
        bottomBarPos.y = height//we use offset in css to move it back into the visible area
        leftBar!.setPosition(leftBarPos)
        bottomBar!.setPosition(bottomBarPos)
        
        //align the graphPoints
        
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
