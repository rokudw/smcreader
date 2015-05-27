package smcreader;

import smcreader.Song;
import smcreader.ParserSM;
import smcreader.FormatJSON;

class SMCReader
{
    public function new()
    {
    }

    static function main() : Void
    {
        var args : Array<String> = Sys.args();
        var result : Dynamic = null;
        var smcreader : SMCReader;

        if (args.length == 1)
        {
            smcreader = new SMCReader();
            result = smcreader.Read(args[0]);
        }
        else if (args.length == 2)
        {
            smcreader = new SMCReader();
            result = smcreader.Read(args[0], args[1]);
        }
        else if (args.length >= 3)
        {
            result = "Invalid argument.";
        }

        if (result != null)
            Sys.print(result);
    }

    public function Read(filePath : String, ?convFormat = "json") : Dynamic
    {
        var result : Dynamic;

        var formatType = filePath.substr(filePath.lastIndexOf(".") + 1).toLowerCase();
        var parser : Parser = new Parser();
        var unescape : Bool = true;
        var song :Song = null;

        switch(formatType.toLowerCase())
        {
            case "sm":
                parser = new ParserSM();
            case "ssc":
                parser = new ParserSSC();
            default:
                return "Invalid StepMania chart format type.";
        }

        try
        {
            song = parser.Parse( filePath, unescape);
        }
        catch(e : Dynamic)
        {
            return Std.string(e);
        }


        if (song == null)
            return "";

        switch(convFormat.toLowerCase())
        {
            case "json":
                result = FormatJSON.Convert(song);
            default:
                return "Invalid convert format.";
        }

        return result;
    }
}
