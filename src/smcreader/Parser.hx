package smcreader;

import smcreader.MsdFile;
import smcreader.Song;
import smcreader.NoteData;
import smcreader.Util;

class Parser
{
    private var funcMap : Map<String, Dynamic>;
    private var varMap : Map<String, String>;
    public function new() {
        funcMap = [
            "VERSION" => SetFloat,
            "TITLE" => SetString,
            "SUBTITLE" => SetString,
            "ARTIST" => SetString,
            "TITLETRANSLIT" => SetString,
            "SUBTITLETRANSLIT" => SetString,
            "ARTISTTRANSLIT" => SetString,
            "GENRE" => SetString,
            "ORIGIN" => SetString,
            "CREDIT" => SetString,
            "BANNER" => SetString,
            "BACKGROUND" => SetString,
            "LYRICSPATH" => SetString,
            "CDTITLE" => SetString,
            "MUSIC" => SetString,
// not implemented
//            "INSTRUMENTTRACK" => ,
//            "MUSICLENGTH" => ,
            "OFFSET" => SetFloat,
            "BPMS" => SetFloat2DArray,
            "STOPS" => SetFloat2DArray,
            "FREEZES" => SetFloat2DArray,
            "DELAYS" => SetFloat2DArray,
            "WARPS" => SetFloat2DArray,
            "LABELS" => SetLabels,
            "TIMESIGNATURES" => SetTimeSignatures,
            "TICKCOUNTS" => SetTickCounts,
            "COMBOS" => SetCombos,
            "SPEEDS" => SetSpeeds,
            "SCROLLS" => SetFloat2DArray,
// not implemented
//            "FAKES" => null,
            "SAMPLESTART" => SetFloat,
            "SAMPLELENGTH" => SetFloat,
            "DISPLAYBPM" => SetDisplayBPM,
            "SELECTABLE" => SetString,
// not implemented
//            "LASTSECONDHINT" => .
//            "BGCHANGES" => ,
//            "FGCHANGES" => ,
//            "KEYSOUNDS" => ,
//            "ATTACKS" =>

            "NOTEDATA" => null,
            "NOTES" => null
        ];

        varMap = [
            "VERSION" => "version",
            "TITLE" => "title",
            "SUBTITLE" =>"subtitle",
            "ARTIST" => "artist",
            "TITLETRANSLIT" => "titleTranslit",
            "SUBTITLETRANSLIT" => "subtitleTranslit",
            "ARTISTTRANSLIT" => "artistTranslit",
            "GENRE" => "genre",
            "ORIGIN" => "origin",
            "CREDIT" => "credit",
            "BANNER" => "banner",
            "BACKGROUND" => "background",
            "LYRICSPATH" => "lyricsPath",
            "CDTITLE" => "cdTitle",
            "MUSIC" => "music",
// not implemented
//            "INSTRUMENTTRACK" =>
//            "MUSICLENGTH" =>
            "OFFSET" => "offset",
            "BPMS" => "bpms",
            "STOPS" => "stops",
            "FREEZES" => "stops",
            "DELAYS" => "delays",
            "WARPS" => "warps",
            "LABELS" => "labels",

            "TIMESIGNATURES" => "timeSignatures",
            "TICKCOUNTS" => "tickCounts",
            "COMBOS" => "combos",
            "SPEEDS" => "speeds",
            "SCROLLS" => "scrolls",
// not implemented
//            "FAKES" => null,
            "SAMPLESTART" => "sampleStart",
            "SAMPLELENGTH" => "sampleLength",
            "DISPLAYBPM" => "displayBPM",
            "SELECTABLE" => "selectable"
// not implemented
//            "LASTSECONDHINT" =>
//            "BGCHANGES" =>
//            "FGCHANGES" =>
//            "KEYSOUNDS" =>
//            "ATTACKS" =>
        ];
    }

    public function Parse(filePath : String, ?unescape : Bool = true) : Song
    {
        return new Song();
    }

    private function ReadSimfile ( filePath : String, ?unescape : Bool) : MsdFile
    {
        var msd : MsdFile = new MsdFile();
        msd.ReadFile(filePath, unescape);

        if (msd.GetError() != "")
        {
            throw msd.GetError();
        }
        return msd;
    }

    private function SetInt (classObj : Dynamic, fieldName : String, msdValue : MsdValue) : Void
    {
        var param : Null<Int> = Std.parseInt(msdValue.params[1]);
        if (param == null) param = 0;
        Reflect.setField(classObj, fieldName, param);
    }

    private function SetFloat (classObj : Dynamic, fieldName : String, msdValue : MsdValue) : Void
    {
        var param : Null<Float> = Std.parseFloat(msdValue.params[1]);
        if (param == null) param = 0.0;
        Reflect.setField(classObj, fieldName, param);
    }

    private function SetString (classObj : Dynamic, fieldName : String, msdValue : MsdValue) : Void
    {
        Reflect.setField(classObj, fieldName, msdValue.params[1]);
    }

    //@:generic
    //private function Set2DArray<T:Class, U>(classObj : Class<T>, fieldName : String, msdValue : MsdValue) : Void
    private function SetFloat2DArray(classObj : Dynamic, fieldName : String, msdValue : MsdValue) : Void
    {
        var timmings : Array<String> = msdValue.params[1].split(",");
        var timming : Array<String>;
        var array : Array<Array<Float>>;

        for (i in  0...timmings.length)
        {
            if (timmings[i].indexOf("=") > -1)
            {
                timming = timmings[i].split("=");


                if (timming.length >= 2)
                {
                    array = Reflect.field(classObj, fieldName);
                    array.push([Std.parseFloat(timming[0]), Std.parseFloat(timming[1])]);
                    Reflect.setField(classObj, fieldName, array);
                }
            }
        }
    }

    private function SetLabels(classObj : Dynamic, fieldName : String, msdValue : MsdValue) : Void
    {
        var timmings : Array<String> = msdValue.params[1].split(",");
        var timming : Array<String>;
        var array : Array<Array<Dynamic>>;

        for (i in  0...timmings.length)
        {
            if (timmings[i].indexOf("=") > -1)
            {
                timming = timmings[i].split("=");
                if (timming.length == 2)
                {
                    array = Reflect.field(classObj, fieldName);
                    array.push([Std.parseFloat(timming[0]), timming[1]]);
                    Reflect.setField(classObj, fieldName, array);
                }
            }
        }
    }

    private function SetDisplayBPM (classObj : Dynamic, fieldName : String, msdValue : MsdValue) : Void
    {
        Reflect.setField(classObj, fieldName, msdValue.params[1]);
        if(msdValue.params.length == 3) {
            Reflect.setField(classObj, fieldName, Reflect.field(classObj, fieldName) + ":" + msdValue.params[2]);
            //song.displayBPM + ":" + msdValue.params[2];
        }
    }

    private function SetTimeSignatures(classObj : Dynamic, fieldName : String, msdValue : MsdValue) : Void
    {
        var timmings : Array<String> = msdValue.params[1].split(",");
        var timming : Array<String>;
        var array : Array<Array<Float>>;

        for (i in  0...timmings.length)
        {
            if (timmings[i].indexOf("=") > -1)
            {
                timming = timmings[i].split("=");

                if (timming.length == 3)
                {
                    array = Reflect.field(classObj, fieldName);
                    array.push([Std.parseFloat(timming[0]), Std.parseInt(timming[1]), Std.parseInt(timming[2])]);
                    Reflect.setField(classObj, fieldName, array);
                }
            }
        }
    }

    private function SetTickCounts(classObj : Dynamic, fieldName : String, msdValue : MsdValue) : Void
    {
        var timmings : Array<String> = msdValue.params[1].split(",");
        var timming : Array<String>;
        var array : Array<Array<Float>>;

        for (i in  0...timmings.length)
        {
            if (timmings[i].indexOf("=") > -1)
            {
                timming = timmings[i].split("=");

                if (timming.length == 2)
                {
                    array = Reflect.field(classObj, fieldName);
                    array.push([Std.parseFloat(timming[0]), Std.parseInt(timming[1])]);
                    Reflect.setField(classObj, fieldName, array);
                }
            }
        }
    }

    private function SetCombos(classObj : Dynamic, fieldName : String, msdValue : MsdValue) : Void
    {
        var timmings : Array<String> = msdValue.params[1].split(",");
        var timming : Array<String>;
        var array : Array<Array<Float>>;

        for (i in  0...timmings.length)
        {
            if (timmings[i].indexOf("=") > -1)
            {
                timming = timmings[i].split("=");

                if (timming.length == 2)
                {
                    array = Reflect.field(classObj, fieldName);
                    array.push([Std.parseFloat(timming[0]), Std.parseInt(timming[1])]);
                    Reflect.setField(classObj, fieldName, array);
                }
            }
        }
    }

    private function SetSpeeds(classObj : Dynamic, fieldName : String, msdValue : MsdValue) : Void
    {
        var timmings : Array<String> = msdValue.params[1].split(",");
        var timming : Array<String>;
        var array : Array<Array<Float>>;

        for (i in  0...timmings.length)
        {
            if (timmings[i].indexOf("=") > -1)
            {
                timming = timmings[i].split("=");

                if (timming.length == 4)
                {
                    array = Reflect.field(classObj, fieldName);
                    array.push([Std.parseFloat(timming[0]), Std.parseFloat(timming[1]), Std.parseFloat(timming[2]), Std.parseInt(timming[3])]);
                    Reflect.setField(classObj, fieldName, array);
                }
            }
        }
    }
}
