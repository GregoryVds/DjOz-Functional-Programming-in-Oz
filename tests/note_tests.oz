\define TestNote

local
   Test = \insert /Users/Greg/Desktop/Projet2014/lib/test.oz
   \insert /Users/Greg/Desktop/Projet2014/code/note.oz

   % ExtendNote
   {Test.assertEqual ExtendNote a3      note(nom:a octave:3 alteration:none)}
   {Test.assertEqual ExtendNote c#2     note(nom:c octave:2 alteration:'#')}
   {Test.assertEqual ExtendNote b3      note(nom:b octave:3 alteration:none)}
   {Test.assertEqual ExtendNote d3      note(nom:d octave:3 alteration:none)}
   {Test.assertEqual ExtendNote c       note(nom:c octave:4 alteration:none)}
   {Test.assertEqual ExtendNote silence note(nom:silence octave:4 alteration:none)}

   % DistanceFromA
   {Test.assertEqual DistanceFromA note(nom:a octave:3 alteration:none) 0}
   {Test.assertEqual DistanceFromA note(nom:c octave:2 alteration:'#')  ~8}
   {Test.assertEqual DistanceFromA note(nom:b octave:3 alteration:none) 2}
   {Test.assertEqual DistanceFromA note(nom:d octave:3 alteration:none) ~7}

   % Hauteur
   {Test.assertEqual Hauteur a     0}
   {Test.assertEqual Hauteur e    ~5}
   {Test.assertEqual Hauteur b     2}
   {Test.assertEqual Hauteur b3  ~10}
   {Test.assertEqual Hauteur d#1 ~42}
   {Test.assertEqual Hauteur a#4   1}
   {Test.assertEqual Hauteur silence silence}

   % ToEchantillon
   {Test.assertEqual NoteToEchantillon [d#2 woody]    echantillon(hauteur:~30  duree:1.0 instrument:woody)}
   {Test.assertEqual NoteToEchantillon [a none]       echantillon(hauteur:0    duree:1.0 instrument:none)}
   {Test.assertEqual NoteToEchantillon [d2 drums]     echantillon(hauteur:~31  duree:1.0 instrument:drums)}
   {Test.assertEqual NoteToEchantillon [silence none] silence(duree:1.0)}

   % HauteurToNote
   {Test.assertEqual HauteurToNote   2 note(nom:b octave:4 alteration:none)}
   {Test.assertEqual HauteurToNote   0 note(nom:a octave:4 alteration:none)}
   {Test.assertEqual HauteurToNote  ~1 note(nom:g octave:4 alteration:'#')}
   {Test.assertEqual HauteurToNote  13 note(nom:a octave:5 alteration:'#')}
   {Test.assertEqual HauteurToNote ~25 note(nom:g octave:2 alteration:'#')}

   % Position in list
   {Test.assertEqual PositionInList [a [a b c]] 0}
   {Test.assertEqual PositionInList [b [a b c]] 1}
   {Test.assertEqual PositionInList [d [a b c]] ~1}
in
   {Browse doneTest}
end
\undef TestNote