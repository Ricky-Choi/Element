import Foundation

class ProgressIndicator:Element {
    override func resolveSkin() {
        skin = SkinResolver.skin(self)
        
        //get the linestyle from this skin
        //add round end style 
        //center of element
        //radius = width/2
        //wedge = π/2
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
     *
     */
    func progress(value:CGFloat){
        
    }
}