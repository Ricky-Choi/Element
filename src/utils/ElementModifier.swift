import Cocoa

class ElementModifier {
    /**
     * Changes the visibility of @param element by @param isVisible
     * // :TODO: what if the state changes? then the StyleManager is queried again and the current display state wont work
     */
    class func hide(element:IElement,_ isVisible:Bool) {
        let display:String = isVisible ? "" : CSSConstants.none
        element.skin!.setStyle(StyleModifier.clone(element.skin!.style!))/*This is a temp fix, an original style must be applied to every skin*/
        var styleProperty:IStyleProperty? = element.skin!.style!.getStyleProperty("display")
        styleProperty != nil ? styleProperty!.value = display : element.skin!.style!.addStyleProperty(StyleProperty("display", display))
        element.skin!.setStyle(element.skin!.style!)
    }
    class func hideAll(elements:Array<IElement>,_ exception:IElement) {
        for element : IElement in elements {ElementModifier.hide(element, (element === exception))}  
    }
    class func hideChildren(view:NSView,_ exception:IElement) {
        let elements:Array<IElement> = ElementParser.children(view,IElement.self)
        hideAll(elements, exception)
    }
    /**
     * Refreshes many elements in @param displayObjectContainer
     * // :TODO: skin should have a dedicated redraw method or a simple workaround
     * @Note keep in mind that this can be Window
     */
    class func refresh(element:IElement, _ method: (IElement)->Void = Utils.setStyle) {//<--setStyle is the default param method
        if(element.skin!.style!.getStyleProperty("display") != nil && (element.skin!.style!.getStyleProperty("display")!.value as! String) == CSSConstants.none) {return} /*Skip refreshing*/
        method(element)
        let container:NSView = element as! NSView//element is Window ? Window(element).view : element as NSView;
        container.subviews.forEach{//<- we could do a .filter here and assert is IElement
            if($0 is IElement) {
                refresh($0 as! IElement,method)/*<--this line makes it recursive*/
            }
        }
    }
    /**
     * new
     */
    class func refreshSkin(element:IElement){
        ElementModifier.refresh(element, Utils.setSkinState)
    }
    /**
     * Resizes many elements in @param view
     * // :TODO: rename to Resize, its less ambigiouse
     */
    class func size(view:NSView,_ size:CGPoint) {
        view.subviews.forEach{
            if($0 is IElement) {($0 as! IElement).setSize(size.x, size.y)}
        }
    }
    /**
     * @Note refloats @param view children that are of type IElement
     * @Note i.e: after hideing of an element, or changing the depth order etc
     */
    class func floatChildren(view:NSView) {
        view.subviews.forEach{
            if($0 is IElement) {
                //Swift.print("text: " + "\((child as! SelectTextButton).getText())")
                SkinModifier.float(($0 as! IElement).skin!)
            }
        }
    }
}
private class Utils{
    class func setStyle(element:IElement){
        element.skin!.setStyle(element.skin!.style!)/*Uses the setStyle since its faster than setSkin*/
    }
    /**
     * This operated directly on the skin before as the element.setSkinState may be removed in the future
     */
    class func setSkinState(element:IElement){
        element.skin!.setSkinState(element.skin!.state)/*<-- was SkinStates.none but re-applying the same skinState is a better option*/
    }
}