import Foundation
/**
 * CSS: line-alpha:0.5;line:Gray;line-thickness:2px;width:60px;height:60px;
 */
class ProgressIndicator:Element {
    override func resolveSkin() {
        skin = SkinResolver.skin(self)
        
        //get the linestyle from this skin
        //add round end style 
        //center of element
        //radius = width/2
        //wedge = π/12
        //lines = []
        //for i loop 12 lines
            //angle = wedge * i
            //startPos = center.polar(radius/2,angle)
            //endPos = center.polar(radius,angle)
            //line = LineGraphic(startP,endP,basegraphic(lineStyle))
            //addSubView(line)
            //line.draw()
            //lines.append(line)
        
    }
    /**
     * Modulate the progress indicator (For iterative progress or looping animation)
     * PARAM: value: 0 - 1
     */
    func progress(value:CGFloat){
        //for i in 0..<12{alpha = 0.5}//reset all values
        //progress = round(12*value)
        //start = progress
        //end = progress + 7
        //for i in start..<end
            //i = NumberParser.loopClamp(i,0,12)
            //alpha += 0.5 * i (i/7)
            //setStyle(), draw()
        //
    }
    /**
     *
     */
    func onFrame(){
        
    }
    /**
     *
     */
    func start(){
        //assert if animator exist else create animator
        //start anim
    }
}