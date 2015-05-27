package smcreader;

import smcreader.MsdFile.MsdValue;
import smcreader.Parser;

class ParserSSC extends Parser
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
        var isNoteDataSection : Bool = false;

        var devNull : Dynamic = null;

        msd = ReadSimfile(filePath, unescape);

        for (i in 0...msd.GetNumValues())
        {
            numParams = msd.GetNumParams(i);
            msdValue = msd.GetValue(i);
            valueName = msdValue.params[0].toUpperCase();

            if (isNoteDataSection)
            {
                switch (valueName)
                {
                    case "NOTEDATA":
                        //isNoteDataSection = true;
                        if (noteData != null)
                        {
                            song.noteData.push(noteData);
                        }

                        noteData = new NoteData();
                    case "CHARTNAME":
                        SetString(noteData, "chartName" , msdValue);
                    case "STEPSTYPE":
                        SetString(noteData, "stepsType" , msdValue);
                    case "DESCRIPTION":
                        SetString(noteData, "description" , msdValue);
                    case "CHARTSTYLE":
                        SetString(noteData, "chartStyle" , msdValue);
                    case "DIFFICULTY":
                        SetString(noteData, "difficulty" , msdValue);
                    case "METER":
                        SetInt(noteData, "meter" , msdValue);
                    case "RADARVALUES":
                        tmpArr = msdValue.params[1].split(",");
                        if (tmpArr.length >= 5)
                        {
                            noteData.radarValueStream = Std.parseFloat(tmpArr[0]);
                            noteData.radarValueVoltage = Std.parseFloat(tmpArr[1]);
                            noteData.radarValueAir = Std.parseFloat(tmpArr[2]);
                            noteData.radarValueFreeze = Std.parseFloat(tmpArr[3]);
                            noteData.radarValueChaos = Std.parseFloat(tmpArr[4]);
                        }
                    case "CREDIT":
                        SetString(noteData, "credit" , msdValue);
                    case "OFFSET":
                        SetFloat(noteData, "offset" , msdValue);
                    case "BPMS":
                        SetFloat2DArray(noteData, "bpms" , msdValue);
                    case "STOPS":
                        SetFloat2DArray(noteData, "stops" , msdValue);
                    case "DELAYS":
                        SetFloat2DArray(noteData, "delays" , msdValue);
                    case "WARPS":
                        SetFloat2DArray(noteData, "warps" , msdValue);
                    case "LABELS":
                        SetLabels(noteData, "labels" , msdValue);
                    case "TIMESIGNATURES":
                        SetTimeSignatures(noteData, "timeSignatures" , msdValue);
                    case "TICKCOUNTS":
                        SetTickCounts(noteData, "tickCounts" , msdValue);
                    case "COMBOS":
                        SetCombos(noteData, "combos" , msdValue);
                    case "SPEEDS":
                        SetSpeeds(noteData, "speeds" , msdValue);
                    case "SCROLLS":
                        SetFloat2DArray(noteData, "scrolls" , msdValue);
                    case "DISPLAYBPM":
                        SetDisplayBPM(noteData, "displayBPM" , msdValue);
                    case "NOTES":
                        SetString(noteData, "chart" , msdValue);
                }
            }
            else
            {
                switch (valueName)
                {
                    case "NOTEDATA":
                        isNoteDataSection = true;
                        if (noteData != null)
                        {
                            song.noteData.push(noteData);
                        }

                        noteData = new NoteData();
                    default :
                        if (Reflect.isFunction(funcMap[valueName]))
                        {
                            Reflect.callMethod(devNull, funcMap[valueName], [song, varMap[valueName], msdValue]);
                        }
                }
            }
        }

        if (noteData != null)
        {
            song.noteData.push(noteData);
        }
        return song;
    }
}
