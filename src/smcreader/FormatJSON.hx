package smcreader;

import Type.ValueType;

class FormatJSON
{
    public function new() {
    }

    static public function Convert(song : Song) : Dynamic
    {
        var result : StringBuf = new StringBuf();
        var fields = Reflect.fields(song);
        var prop : Dynamic;

        result.add("{");

        for (i in 0...fields.length)
        {
            result.add('"' + fields[i] + '"');
            result.add(":");

            if (!Reflect.hasField(song, fields[i]))
            {
                continue;
            }
            prop = Reflect.getProperty(song, fields[i]);

            result.add(GetValue(fields[i], prop));

            //最後の要素では追加しない
            if (i < fields.length-1)
            {
                result.add(",");
            }
        }

        result.add("}");

        return result.toString();
    }

    static private function GetValue(name : String, prop :Dynamic) : String
    {
        var result : StringBuf = new StringBuf();
        var type : ValueType = Type.typeof(prop);
        var childFields : Array<String>;
        var childProp : Dynamic;
        //var propFloat : Null<Float> = Std.parseFloat(prop);

        if (prop == null)
        {
            result.add('""');
        }
        else if (Type.enumEq(type, TInt) || Type.enumEq(type, TFloat))
        {
            result.add(prop);
        }
#if cs
        else if (cast(type, String).indexOf("Double") > -1)
        {
            result.add(prop);
        }
#end
        else if (Type.enumEq(type, TClass(String)))
        {
            var s : String = "";
            //NoteData.chart用
            prop = StringTools.replace(prop, "\r", "\\r");
            prop = StringTools.replace(prop, "\n", "\\n");
            result.add('"' + prop + '"');
        }
        else if (Type.enumEq(type, TClass(Array)))
        {
            result.add("[");
            for (i in 0...cast(prop, Array<Dynamic>).length)
            {
                childProp = GetValue(name, prop[i]);
                result.add(childProp);

                //最後の要素では追加しない
                if (i < prop.length-1)
                {
                    result.add(",");
                }
            }
            result.add("]");
        }
        else if (Type.enumEq(type, TClass(NoteData)))
        {
            childFields = Reflect.fields(prop);
            //childProp : Dynamic;

            result.add("{");
            for (i in 0...childFields.length)
            {
                result.add('"' + childFields[i] + '"');
                result.add(":");

                if (!Reflect.hasField(prop, childFields[i]))
                {
                    continue;
                }
                childProp = Reflect.getProperty(prop, childFields[i]);

                result.add(GetValue(childFields[i], childProp));

                //最後の要素では追加しない
                if (i < childFields.length-1)
                {
                    result.add(",");
                }
            }
            result.add("}");
        }

        return result.toString();
    }
}
