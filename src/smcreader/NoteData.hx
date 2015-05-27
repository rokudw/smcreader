package smcreader;

class NoteData
{
    public var chartName:String;
    public var stepsType:String;
    public var description:String;
    public var chartStyle:String;
    public var difficulty:String;
    public var meter:Int;
    //public var radarValues:Map<String,Float>;
    public var radarValueStream:Float;
    public var radarValueVoltage:Float;
    public var radarValueAir:Float;
    public var radarValueFreeze:Float;
    public var radarValueChaos:Float;
    public var credit:String;

    // steps-based timingdata
    public var offset:Float;
    public var bpms:Array<Array<Float>>;
    public var stops:Array<Array<Float>>;
    public var delays:Array<Array<Float>>;
    public var warps:Array<Array<Float>>;
    public var timeSignatures:Array<Array<Dynamic>>;
    public var tickCounts:Array<Array<Dynamic>>;
    public var combos:Array<Array<Dynamic>>;
    public var speeds:Array<Array<Dynamic>>;
    public var scrolls:Array<Array<Dynamic>>;
    //public var fakes:Map<Float,Float>;
    public var labels:Array<Array<Dynamic>>;
    //public var attacks:Map<Float,String>;
    public var displayBPM:String;

    public var chart:String;

    public function new()
    {
        chartName = "";
        stepsType = "";
        description = "";
        chartStyle = "";
        difficulty = "";
        meter = 0;

        radarValueStream = 0.0;
        radarValueVoltage = 0.0;
        radarValueAir = 0.0;
        radarValueFreeze = 0.0;
        radarValueChaos = 0.0;

        credit = "";
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
        displayBPM = "";

        chart = "";
    }
}
