import Foundation
/**
 *  // :TODO: Add support for bottom top left right values in normal css values
 *  // :TODO: support for radialGradient: css w3c
 *  // :TODO: // make a pattern for all the w3c color shortcuts svg colors 116 colors
 */
class CSSPropertyParser {
    /**
     * Retuns a css property to a property that can be read by the flash api
     */
    class func property(string:String) -> Any{//:TODO: Long switch statments can be replaced by polymorphism?!?
        switch(true) {
            case StringAsserter.digit(string):return StringParser.digit(string);/*40 or -1 or 1.002 or 12px or 20% or .02px*/
            case StringAsserter.metric(string):return string;
            case StringAsserter.boolean(string):return StringParser.boolean(string);/*true or false*/
            case StringAsserter.color(string):return StringParser.color(string);/*#00ff00 or 00ff00*/
            case StringAsserter.webColor(string):return StringParser.color(string);/*green red etc*/
            
            case RegExp.test(string,"^linear-gradient\\b"):return linearGradient(string);/*linear-gradient*/// :TODO: create a more complte exprrison for this test
            case RegExp.test(string,"^([\\w\\d\\/\\%\\-\\.]+?\\\040)+?(\\b|\\B|$)"):return array(string);/*corner-radius, line-offset-type, margin, padding, offset*/// :TODO: shouldnt the \040 be optional?
            default : fatalError("CSSPropertyParser.property() THE: " + string + " PROPERTY IS NOT SUPPORTED");
        }
    }
    /**
    * // :TODO: possibly use the RegExp.exec to loop the properties!!
    * @param string "linear-gradient(top,gray 1 0,white 1 1);"// 2 color gradient
    * @Note setting the gradientType isnt necessary since its the default setting
    */
    class func linearGradient(string:String)->IGradient{
        var propertyString:String = string.match(/(?<=linear-gradient\().+?(?=\);?)/).toString();
        var properties:Array = propertyString.split(",");
        var rotation:Number = Utils.rotation(properties.shift());/*the first item is always the rotation, top or left or top left etc*/
        var gradient:IGradient = Utils.gradient(properties);/*add colors, opacities and ratios*/
        gradient.rotation = rotation*Trig.RAD;// :TODO: rotations should be applied in the matrix
        return gradient;
    }
    /**
     * Returns an array comprised of values if the individual value is a digit then it is processed as a digit if its not a digit then its just processed as a string
     * // :TODO: does this support comma delimited lists?
     * EXAMPLE: a corner-radius "10 20 10 20"
     */
    class func array(string:String)->Array<Any>{
        let matches:Array<String> = StringModifier.split(string, " ")
        var array:Array<Any> = [];
        for str : String in matches { array.append(StringAsserter.digit(str) ? StringParser.digit(str) : str) }
        return array;
    }
}
