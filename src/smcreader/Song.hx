package smcreader;

import smcreader.NoteData;

class Song
{
    public var version:Float;
    public var title : String;
    public var subtitle:String;
    public var artist:String;
    public var titleTranslit:String;
    public var subtitleTranslit:String;
    public var artistTranslit:String;
    public var genre:String;
    public var origin:String;
    public var credit:String;
    public var banner:String;
    public var background:String;
//#PREVIEWVID:;
//#JACKET:;
//#CDIMAGE:;
//#DISCIMAGE:;
    public var lyricsPath:String;
    public var cdTitle:String;
    public var music:String;
    //public var instrumentTrack:String;
    //public var musicLength:Float;
    public var offset:Float;
    public var bpms:Array<Array<Float>>;
    public var stops:Array<Array<Float>>;
    public var delays:Array<Array<Float>>;
    public var warps:Array<Array<Float>>;
    public var labels:Array<Array<Dynamic>>;
    public var timeSignatures:Array<Array<Dynamic>>;
    public var tickCounts:Array<Array<Dynamic>>;
    public var combos:Array<Array<Dynamic>>;
    public var speeds:Array<Array<Dynamic>>;
    public var scrolls:Array<Array<Dynamic>>;
//not implemented
//    public var fakes:Array<Array<Float>>;
    public var sampleStart:Float;
    public var sampleLength:Float;
    public var displayBPM:String;
    public var selectable:String;
    //public var lastSecondHint:String;
//not implemented
    //public var bgChanges:String;
    //public var fgChanges:String;
    //public var keySounds:String;
    //public var attacks:String;

    public var noteData:Array<NoteData>;



    public function new ()
    {
        version = 0.0;
        title = "";
        subtitle = "";
        artist = "";
        titleTranslit = "";
        subtitleTranslit = "";
        artistTranslit = "";
        genre = "";
        origin = "";
        credit = "";
        banner = "";
        background = "";
        lyricsPath = "";
        cdTitle = "";
        music = "";
        //instrumentTrack = "";
        //musicLength = 0.0;
        offset = 0.0;

        bpms = new Array<Array<Float>>();
        stops = new Array<Array<Float>>();
        delays = new Array<Array<Float>>();
        warps = new Array<Array<Float>>();
        labels = new Array<Array<Dynamic>>();
        timeSignatures = new Array<Array<Dynamic>>();
        tickCounts = new Array<Array<Dynamic>>();
        combos = new Array<Array<Dynamic>>();
        speeds = new Array<Array<Dynamic>>();
        scrolls = new Array<Array<Dynamic>>();

        sampleStart = 0.0;
        sampleLength = 0.0;
        displayBPM = "";
        selectable = "";

        noteData = new Array<NoteData>();
    }
}
