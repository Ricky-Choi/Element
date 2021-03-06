import Cocoa
//SkinParser.width(skin) was used before to create the mask size
//SkinParser.height(skin) was used before to create the mask size
/**
 * NOTE: There is no setSize in this component, for this purpose create a dedicated component I.E: ResizeList.as
 * NOTE: ListParser and ListModifier are usefull utility classes
 * // :TODO: could List have a SelectGroup?
 * // :TODO: xml should be able to hold a propert named selected="true" and then the cooresponding Item should be selected
 * // :TODO: try to get rid of the lableContainer
 * // :TODO: try to make the mask an Element
 * // :TODO: MultipleSelection could be implimented by creating a new Class like MultipleSelectionList, Other possible classes to make: CheckList, ToggleList etc
 * // :TODO: how did you solve the clipping issue in Element? can it be used to mask? make a mask test??!?
 */
class List:Element,IList{
    var itemHeight:CGFloat
    var dataProvider : DataProvider
    var lableContainer  : Container?
    init(_ width: CGFloat, _ height: CGFloat, _ itemHeight:CGFloat = CGFloat.NaN, _ dataProvider:DataProvider? = nil, _ parent: IElement?, _ id: String? = "") {
        self.itemHeight = itemHeight
        self.dataProvider = dataProvider ?? DataProvider()/*<--if it's nil then a DB is created*/
        super.init(width,height,parent,id)
        self.dataProvider.event = onEvent/*Add event handler for the dataProvider*/
        layer!.masksToBounds = true/*masks the children to the frame, I don't think this works, seem to work now*/
    }
    /**
     * Creates the components in the List Component
     */
    override func resolveSkin() {
        super.resolveSkin()
        lableContainer = addSubView(Container(width,height,self,"lable"))
        mergeAt(dataProvider.items, 0)
    }
    /**
     * Creates and adds items to the _lableContainer
     * // :TODO: possibly move into ListModifier, TreeList has its mergeAt in an Utils class see how it does it
     */
    func mergeAt(objects:[Dictionary<String,String>], _ index:Int){// :TODO: possible rename to something better, placeAt? insertAt?
        var i:Int = index
        for object:Dictionary<String,String> in objects {// :TODO: use for i
            let item:SelectTextButton = SelectTextButton(getWidth(), itemHeight ,object["title"]!, false, lableContainer)
            lableContainer!.addSubviewAt(item, i)/*the first index is reserved for the List skin, what?*/
            i++
        }
    }
    /**
     * // :TODO: you need to update the float of the lables after an update
     */
    func onDataProviderEvent(event:DataProviderEvent){
        switch(event.type){
            case DataProviderEvent.add: mergeAt(event.items, event.startIndex);/*This is called when a new item is added to the DataProvider instance*/
            case DataProviderEvent.remove: lableContainer!.removeSubviewAt(event.startIndex); /*This is called when an item is removed form the DataProvider instance*/
            case DataProviderEvent.removeAll: ViewModifier.removeAllOfType(lableContainer!, ISelectable.self/*<--this may not work, see your comparing protocol and class code*/)/*This is called when all item is removed form the DataProvider instance*/
            case DataProviderEvent.sort: DepthModifier.sortByList(lableContainer!,"text","title", dataProvider.items)/*This is called when the items in the DataProvider instance is sorted*/
            case DataProviderEvent.dataChange: /*Not implimented yet*/ break;/*This is called when the items in the DataProvider instance is sorted*/
            case DataProviderEvent.replace: /*This is called when an item is replaced from the DataProvider instance*/
                self.lableContainer!.removeSubviewAt(event.startIndex)
                mergeAt(event.items, event.startIndex)
            default:fatalError("event type not supported"); break;
        }
        ElementModifier.floatChildren(lableContainer!)/*this call re-floats the list items*/
    }
    /**
     * This is called when a item in the _lableContainer has dispatched the ButtonEvent.TRIGGER_DOWN event
     */
    func onUpInside(buttonEvent:ButtonEvent) {
        let selectedIndex:Int = lableContainer!.indexOf(buttonEvent.origin as! NSView)
        //Swift.print("selectedIndex: " + "\(selectedIndex)")
        ListModifier.selectAt(self,selectedIndex)
        super.onEvent(ListEvent(ListEvent.select,selectedIndex,self))
    }
    override func onEvent(event: Event) {
        if(event.type == ButtonEvent.upInside && event.immediate === lableContainer){// :TODO: should listen for SelectEvent here
            onUpInside(event as! ButtonEvent)
        }else if(event is DataProviderEvent){onDataProviderEvent(event as! DataProviderEvent)}
        super.onEvent(event)// we stop propegation by not forwarding events to super. The ListEvents go directly to super so they wont be stopped.
    }
    override func setSize(width : CGFloat, _ height : CGFloat) {
        super.setSize(width, height);
        //skin.setState(skin.state)
        //self.mask.setSize(width, height)
        ElementModifier.refresh(lableContainer!)//was --> SkinModifier.size(_lableContainer,  CGPoint(width,self.itemHeight));
    }
    /**
     * Returns "List"
     * NOTE: This method is used to find the correct class type when synthezing the element cascade
     */
    override func getClassType() -> String {
        return String(List)
    }
    required init?(coder: NSCoder) {fatalError("init(coder:) has not been implemented")}
}

