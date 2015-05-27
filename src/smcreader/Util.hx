package smcreader;

class Util
{
    static public function Trim(str : String, ?trim : String = "\r\n\t ") : String
    {
        if (trim == "") return str;
        var b : Int = 0;
        var e : Int = str.length;

        while( b < e && trim.indexOf(str.charAt(b)) > -1 )
            ++b;
        while( b < e && trim.lastIndexOf(str.charAt(e-1)) > -1)
            --e;

        return str.substr(b, e-b);
    }
}
