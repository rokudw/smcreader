# SMCReader
The cross-platform StepMania chart file parsing and reading program.     
(but now C# and PHP only supports.)

## How to build
To compile the SMCReader requires Haxe compiler. (http://haxe.org/)
+   C# :
```
cd src
haxelib install hxcs
haxe -cs (/Path/to/filename) -main smcreader.SMCReader
```

+   PHP :
```
cd src
haxe -php (/Path/to) -main smcreader.SMCReader
```

## Usage
```
SMCReader.exe (Filepath)
```
Results are returned in JSON format.


## License
MIT License  
  
  
I'm sorry, I am very poor at speaking English.
