import Foundation

class ListModifier {
    /**
     * Selects the first item that has @param title as its title
     */
    static func select(list:IList, _ title:String) {
        let index:Int = list.dataProvider.getItemIndex(list.dataProvider.getItem(title)!)
        selectAt(list,index)
    }
    /**
     * Selects an item in the itemContainer
     */
    static func selectAt(list:IList,_ index:Int) {
        let selectable:ISelectable = list.lableContainer!.subviews[index] as! ISelectable;
        if(!selectable.getSelected()) {selectable.setSelected(true)}
        SelectModifier.unSelectAllExcept(selectable, list.lableContainer!)
    }
    /**
     * Scrolls the list to a scalar position (value 0-1)
     */
    static func scrollTo(list:IList,_ progress:CGFloat){
        list.lableContainer!.frame.y = ListModifier.scrollTo(progress, (list as! IElement).height, ListParser.itemsHeight(list))
    }
    /**
     * Returns the y position of a "virtual" list
     */
    static func scrollTo(progress:CGFloat,_ maskHeight:CGFloat,_ itemsHeight:CGFloat)->CGFloat{
        let scrollHeight:CGFloat = itemsHeight - maskHeight/*allItems.height - mask.height*/
        let y:CGFloat = round(progress * scrollHeight)
        return -y
    }
}