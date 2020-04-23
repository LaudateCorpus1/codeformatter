BeginPackage["CodeFormatterTestUtils`"]



formatTest

$HandledException


Begin["`Private`"]

Needs["CodeFormatter`"]
Needs["CodeParser`"]
Needs["CodeParser`Utils`"]
Needs["PacletManager`"]






Options[formatTest] = {
  "FileNamePrefixPattern" -> "",
  "FileSizeLimit" -> {0, Infinity},
  "DryRun" -> False
}

formatTest[file_String, i_Integer, OptionsPattern[]] :=
 Module[{ast, dryRun, prefix, res},
  Catch[
   
   prefix = OptionValue["FileNamePrefixPattern"];
   limit = OptionValue["FileSizeLimit"];
   dryRun = OptionValue["DryRun"];

    If[$Debug, Print["file1: ", file]];
    
    If[FileType[file] === File,
     If[FileByteCount[file] > limit[[2]],
      ast =
      Failure["FileTooLarge", <|"FileName" -> file,
        "FileSize" -> FileSize[file]|>];
     Throw[ast]
     ];
     If[FileByteCount[file] < limit[[1]],
      ast =
      Failure["FileTooSmall", <|"FileName" -> file,
        "FileSize" -> FileSize[file]|>];
     Throw[ast]
     ];
     ];

  Quiet[
  Check[
    res = CodeFormat[File[file]];

    If[FailureQ[res],
      Print[
         Style[Row[{"index: ", i, " ", 
            StringReplace[file, StartOfString ~~ prefix -> ""]}], 
          Red]];
        Print[Style[Row[{"index: ", i, " ", res}], Red]];
      Throw[res, "Uncaught"]
    ];

    If[!StringQ[res],
      Print[
         Style[Row[{"index: ", i, " ", 
            StringReplace[file, StartOfString ~~ prefix -> ""]}], 
          Red]];
        Print[Style[Row[{"index: ", i, " ", res}], Red]];
      Throw[res, "Uncaught"]
    ];

    If[dryRun === False,
      Export[file, res, "Text"]
    ]
    ,
    Print[
       Style[Row[{"index: ", i, " ", 
          StringReplace[fileIn, StartOfString ~~ prefix -> ""]}], 
        Darker[Orange]]];
      Print[
       Style[$MessageList, Darker[Orange]]];
  ]]
]]




End[]

EndPackage[]
