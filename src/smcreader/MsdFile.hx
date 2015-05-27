package smcreader;

import haxe.io.Bytes;
import sys.io.File;
import sys.io.FileInput;
import haxe.ds.Vector;
import smcreader.Util;


class MsdFile
{
    private var values : Array<MsdValue>;
    private var error : String;

    public function new()
    {
        values = new Array<MsdValue>();
        error = "";
    }

    /**
	 * @brief Add a new parameter.
	 * @param buf the new parameter.
	 * @param len the length of the new parameter.
	 */
    private function AddParam(buf : Vector<String>, len : Int) : Void
    {
        var param : StringBuf = new StringBuf();
        for ( i in 0...len )
        {
            param.add(buf[i]);
        }

        values[values.length - 1].params.push(param.toString());
    }

    /**
	 * @brief Add a new value.
	 */
    private function AddValue() : Void
    {
        var x : MsdValue = {params : new Array<String>()};
        values.push(x);
    }

    /**
	 * @brief Attempt to read an MSD file from the buffer.
	 * @param buf the buffer containing the MSD file.
	 * @param len the length of the buffer.
	 * @param bUnescape a flag to see if we need to unescape values.
	 */
    private function ReadBuf(buf : String, unescape : Bool) :Void
    {
        var len : Int = buf.length;
        var readingValue : Bool = false;
        var i : Int = 0;
        var processed : Vector<String> = new Vector<String>(len);
        var processedLen : Int = -1;


        while ( i < len )
        {
            if( i+1 < len && buf.charAt(i) == "/" && buf.charAt(i+1) == "/" )
            {
                /* Skip a comment entirely; don't copy the comment to the value/parameter */
                do
                {
                    i++;
                } while( i < len && buf.charAt(i) != "\n" );

                continue;
            }


            if( readingValue && buf.charAt(i) == "#" )
            {
                /* Unfortunately, many of these files are missing ;'s.
                 * If we get a # when we thought we were inside a value, assume we
                 * missed the ;.  Back up and end the value. */
                // Make sure this # is the first non-whitespace character on the line.
                var firstChar : Bool = true;
                var j : Int = processedLen;
                while( j > 0 && processed[j - 1] != "\r" && processed[j - 1] != "\n" )
                {
                    if( processed[j - 1] == " " || processed[j - 1] == "\t" )
                    {
                        --j;
                        continue;
                    }

                    firstChar = false;
                    break;
                }

                if( !firstChar )
                {
                    /* We're not the first char on a line.  Treat it as if it were a normal character. */
                    processed[processedLen++] = buf.charAt(i++);
                    continue;
                }

                /* Skip newlines and whitespace before adding the value. */
                processedLen = j;
                while( processedLen > 0 &&
                ( processed[processedLen - 1] == "\r" || processed[processedLen - 1] == "\n" ||
                processed[processedLen - 1] == " " || processed[processedLen - 1] == "\t" ) )
                    --processedLen;

                AddParam( processed, processedLen );
                processedLen = 0;
                readingValue = false;
            }

            /* # starts a new value. */
            if( !readingValue && buf.charAt(i) == "#" )
            {
                AddValue();
                readingValue=true;
            }

            if( !readingValue )
            {
                if( unescape && buf.charAt(i) == "\\" )
                    i += 2;
                else
                    ++i;
                continue; /* nothing else is meaningful outside of a value */
            }

            /* : and ; end the current param, if any. */
            if( processedLen != -1 && (buf.charAt(i) == ":" || buf.charAt(i) == ";") )
                AddParam( processed, processedLen );

            /* # and : begin new params. */
            if( buf.charAt(i) == "#" || buf.charAt(i) == ":" )
            {
                ++i;
                processedLen = 0;
                continue;
            }

            /* ; ends the current value. */
            if( buf.charAt(i) == ";" )
            {
                readingValue = false;
                ++i;
                continue;
            }

            /* We've gone through all the control characters.  All that is left is either an escaped character,
             * ie \#, \\, \:, etc., or a regular character. */
            if( unescape && i < len && buf.charAt(i) == "\\" )
                ++i;
            if( i < len )
            {
                processed[processedLen++] = buf.charAt(i++);
            }
        }

        /* Add any unterminated value at the very end. */
        if( readingValue )
            AddParam( processed, processedLen );

        //delete [] cProcessed;
    }

    /**
	 * @brief Attempt to read an MSD file.
	 * @param sFilePath the path to the file.
	 * @param bUnescape a flag to see if we need to unescape values.
	 * @return its success or failure.
	 */
    public function ReadFile(newPath : String, unescape : Bool) : Bool
    {
        var f : FileInput;

        if (!sys.FileSystem.exists(newPath))
        {
            error = "File not found.";
            return false;
        }

        if (sys.FileSystem.isDirectory(newPath))
        {
            error = "Path is directory.";
            return false;
        }

        f = sys.io.File.read(newPath, false);

        if ( f == null || f.eof() )
        {
            error = "File couldn't open.";
            return false;
        }

        //var fileString : String;
        var fileString : String;
        fileString = f.readAll().toString();

        ReadBuf(fileString, unescape);

        return true;
    }

    /**
	 * @brief Attempt to read an MSD file.
	 * @param sString the path to the file.
	 * @param bUnescape a flag to see if we need to unescape values.
	 * @return its success or failure.
	 */
    public function ReadFromString( str : String, unescape : Bool) : Void
    {
        ReadBuf(str, unescape);
    }

    /**
	 * @brief Should an error take place, have an easy place to get it.
	 * @return the current error. */
    public function GetError() : String
    {
        return error;
    }

    /**
	 * @brief Retrieve the number of values for each tag.
	 * @return the nmber of values. */
    public function GetNumValues() :Int
    {
        return values.length;
    }

    /**
	 * @brief Get the number of parameters for the current index.
	 * @param val the current value index.
	 * @return the number of params.
	 */
    public function GetNumParams( val : Int ) : Int
    {
        if( val >= GetNumValues() )
            return 0;

        return values[val].params.length;
    }

    /**
	 * @brief Get the specified value.
	 * @param val the current value index.
	 * @return The specified value.
	 */
    public function GetValue( val : Int ) : MsdValue
    {
        //if (val >= GetNumValues())
        //{
        //    throw haxe.io.Error;
        //}

        return values[val];
    }

    /**
	 * @brief Retrieve the specified parameter.
	 * @param val the current value index.
	 * @param par the current parameter index.
	 * @return the parameter in question.
	 */
    public function GetParam(val : Int, par : Int) : String
    {
        if( val >= GetNumValues() || par >= GetNumParams(val) )
            return "";

        return values[val].params[par];
    }


}

typedef MsdValue = {
    //var params : Array<String>;
    var params : Array<MsdParam>;
}

abstract MsdParam(String) from String
{
    @:to
    public function toTrimmingString()
    {
        return Util.Trim(this);
    }

    public function toUpperCase() : String
    {
        return cast(this, String).toUpperCase();
    }

    public function split(demiliter : String) : Dynamic
    {
        return cast(this, String).split(demiliter);
    }
}

//このファイルはStepManiaのソースのMsdFile.cppを改変したものです。
/*
 * (c) 2001-2006 Chris Danford, Glenn Maynard
 *
 * All rights reserved.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a
 * copy of this software and associated documentation files (the
 * "Software"), to deal in the Software without restriction, including
 * without limitation the rights to use, copy, modify, merge, publish,
 * distribute, and/or sell copies of the Software, and to permit persons to
 * whom the Software is furnished to do so, provided that the above
 * copyright notice(s) and this permission notice appear in all copies of
 * the Software and that both the above copyright notice(s) and this
 * permission notice appear in supporting documentation.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
 * OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT OF
 * THIRD PARTY RIGHTS. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR HOLDERS
 * INCLUDED IN THIS NOTICE BE LIABLE FOR ANY CLAIM, OR ANY SPECIAL INDIRECT
 * OR CONSEQUENTIAL DAMAGES, OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS
 * OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR
 * OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR
 * PERFORMANCE OF THIS SOFTWARE.
 */
