package smcreader;

import smcreader.MsdFile.MsdValue;
import smcreader.Parser;

class ParserSM extends Parser
{

    override public function new()
    {
        super();
    }

    override public function Parse(filePath : String, ?unescape : Bool = true) : Song
    {
        var song : Song = new Song();
        var msd : MsdFile;
        var numParams : Int;
        var msdValue : MsdValue;
        var valueName : String;

        var tmpArr : Array<String>;
        var noteData : NoteData = null;

        var devNull : Dynamic = null;

        msd = ReadSimfile(filePath, unescape);

        for (i in 0...msd.GetNumValues())
        {
            numParams = msd.GetNumParams(i);
            msdValue = msd.GetValue(i);
            valueName = msdValue.params[0].toUpperCase();

            switch (valueName)
            {
                case "NOTES", "NOTES2":
                    if(numParams < 7) {
                        continue;
                    }
                    noteData = new NoteData();
                    noteData.stepsType = msdValue.params[1];
                    noteData.description = msdValue.params[2];
                    noteData.difficulty = msdValue.params[3];
                    noteData.meter = Std.parseInt(msdValue.params[4]);

                    tmpArr = msdValue.params[5].split(",");
                    if (tmpArr.length >= 5)
                    {
                        noteData.radarValueStream = Std.parseFloat(tmpArr[0]);
                        noteData.radarValueVoltage = Std.parseFloat(tmpArr[1]);
                        noteData.radarValueAir = Std.parseFloat(tmpArr[2]);
                        noteData.radarValueFreeze = Std.parseFloat(tmpArr[3]);
                        noteData.radarValueChaos = Std.parseFloat(tmpArr[4]);
                    }

                    noteData.chart = msdValue.params[6];
                    song.noteData.push(noteData);
                default :
                    if (Reflect.isFunction(funcMap[valueName]))
                    {
                        //Reflect.callMethod(devNull, funcMap[valueName], [song, msdValue]);
                        Reflect.callMethod(devNull, funcMap[valueName], [song, varMap[valueName], msdValue]);
                    }
            }
        }

        return song;
    }

}