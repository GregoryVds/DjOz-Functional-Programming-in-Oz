% Projet fournit quatre fonctions :
% {Projet.run Interprete Mix Music 'out.wav'} = ok OR error(...) 
% {Projet.readFile FileName} = AudioVector OR error(...)
% {Projet.writeFile FileName AudioVector} = ok OR error(...)
% {Projet.load 'music_file.dj.oz'} = La valeur oz contenue dans le fichier chargé (normalement une <musique>).
% et une constante :
% Projet.hz = 44100, la fréquence d'échantilonnage (nombre de données par seconde)

local
   CWD = {Property.condGet 'testcwd' '/Users/Greg/Desktop/Projet2014/'}
   [Projet] = {Link [CWD#'Projet2014_mozart2.ozf']}
   Testing  = \insert /Users/Greg/Desktop/Projet2014/code/test.oz
   NoteMod  = \insert /Users/Greg/Desktop/Projet2014/code/note.oz
   VoixMod  = \insert /Users/Greg/Desktop/Projet2014/code/voix.oz
   Interprete
   Mix

   HauteurToFrequency
   VoiceToMusic
in   

   % Audio = {Projet.readFile CWD#'wave/animaux/cow.wav'}
   
   
   fun {Interprete Partition}
      Voice
   in
      Voice = case Partition
      of nil then nil
      [] H|T then {Interprete H} | {Interprete T}
      [] etirer(facteur:Factor Part)        then {VoixMod.etirer    {Interprete Part} Factor}
      [] duree(secondes:Duration Part)      then {VoixMod.duree     {Interprete Part} Duration}
      [] muet(Part)                         then {VoixMod.muet      {Interprete Part} }
      [] bourdon(note:Note Part)            then {VoixMod.bourdon   {Interprete Part} {NoteMod.hauteur Note}}
      [] transpose(demitons:HalfSteps Part) then {VoixMod.transpose {Interprete Part} HalfSteps}
      [] Note                               then [{NoteMod.toEchantillon Note}]
      end
      {Flatten Voice}
   end

   fun {HauteurToFrequency Hauteur}
      {Pow 2.0 ({IntToFloat Hauteur}/12.0)} * 440.0
   end
   {Testing.assertEqual HauteurToFrequency 0  440.0}
   {Testing.assertEqual HauteurToFrequency 10 783.99}
   {Testing.assertEqual HauteurToFrequency ~2 392.0}

	
   fun {VoiceToMusic Voice}
      fun {EchantillonToMusic Echantillon}
	 case Echantillon
	 of silence(duree: Duree) then temp
	 [] echantillon(hauteur:Hauteur duree:Duree instrument:Instrument) then temp
	 end
      end
   in
      {Map Voice EchantillonToMusic}
   end
	 	 
   
   fun {Mix Interprete Music}
      case Music
      of nil then nil
      [] H|T then {Mix Interprete H} | {Mix Interprete T}
      [] voix(Voix)      then {VoiceToMusic Voix}
      [] partition(Part) then {Mix Interprete voix({Interprete Part})}
      end 
	 % [] wave(FileName)  then
	 % [] merge(Musics)   then
   end


      
     \ifdef Debug
      % Basic partitions
      {Testing.assertEqual Interprete nil nil}      
      {Testing.assertEqual Interprete b [echantillon(hauteur:2 duree:1.0 instrument:none)] }      
      {Testing.assertEqual Interprete [ [[b] [c d#1]] ]
       [echantillon(hauteur:2 duree:1.0 instrument:none) echantillon(hauteur:~9 duree:1.0 instrument:none) echantillon(hauteur:~42 duree:1.0 instrument:none)] }

      % Etirer
      {Testing.assertEqual Interprete etirer(facteur:3.0 b) [echantillon(hauteur:2 duree:3.0 instrument:none)] }
      {Testing.assertEqual Interprete [ [[b] etirer(facteur:2.0 [c3 d#1])] ]
       [echantillon(hauteur:2 duree:1.0 instrument:none) echantillon(hauteur:~21 duree:2.0 instrument:none) echantillon(hauteur:~42 duree:2.0 instrument:none)] }
      {Testing.assertEqual Interprete [ [b etirer(facteur:2.0 [b etirer(facteur:2.0 b)])] ]
       [echantillon(hauteur:2 duree:1.0 instrument:none) echantillon(hauteur:2 duree:2.0 instrument:none) echantillon(hauteur:2 duree:4.0 instrument:none)] }

      % Duree
      {Testing.assertEqual Interprete duree(secondes:3.0 b) [echantillon(hauteur:2 duree:3.0 instrument:none)] }
      {Testing.assertEqual Interprete duree(secondes:3.0 [b c3])
       [echantillon(hauteur:2 duree:1.5 instrument:none) echantillon(hauteur:~21 duree:1.5 instrument:none)] }
      {Testing.assertEqual Interprete duree(secondes:2.0 duree(secondes:3.0 b)) [echantillon(hauteur:2 duree:2.0 instrument:none)] }
      {Testing.assertEqual Interprete [ [b duree(secondes:2.0 [b duree(secondes:3.0 [b b])])] ]
       [echantillon(hauteur:2 duree:1.0 instrument:none) echantillon(hauteur:2 duree:0.5 instrument:none)
	echantillon(hauteur:2 duree:0.75 instrument:none) echantillon(hauteur:2 duree:0.75 instrument:none)] }

      % Muet
      {Testing.assertEqual Interprete muet(b) [silence(duree:1.0)] }
      {Testing.assertEqual Interprete muet([b c3]) [silence(duree:1.0) silence(duree:1.0)] }
      {Testing.assertEqual Interprete [ [b muet([b c3])] ]
       [echantillon(hauteur:2 duree:1.0 instrument:none) silence(duree:1.0) silence(duree:1.0)] }

      % Bourdon
      {Testing.assertEqual Interprete bourdon(note:silence c) {Interprete muet(c)} }
      {Testing.assertEqual Interprete bourdon(note:silence d) {Interprete muet(a)} }
      {Testing.assertEqual Interprete bourdon(note:c2 [b c2])
       [echantillon(hauteur:~33 duree:1.0 instrument:none) echantillon(hauteur:~33 duree:1.0 instrument:none)] }

      % Transpose
      {Testing.assertEqual Interprete transpose(demitons:2 b) [echantillon(hauteur:4 duree:1.0 instrument:none)] }
      {Testing.assertEqual Interprete transpose(demitons:~2 b) [echantillon(hauteur:0 duree:1.0 instrument:none)] }
      {Testing.assertEqual Interprete transpose(demitons:~2 [a2 a1]) [echantillon(hauteur:~26 duree:1.0 instrument:none) echantillon(hauteur:~38 duree:1.0 instrument:none)] }
      
      % Crazy Mix
      {Testing.assertEqual Interprete etirer(facteur:2.0 duree(secondes:3.0 b)) [echantillon(hauteur:2 duree:6.0 instrument:none)] }
      {Testing.assertEqual Interprete muet([b duree(secondes:2.0 c3)]) [silence(duree:1.0) silence(duree:2.0)]}
      {Testing.assertEqual Interprete [ [c3 bourdon(note:c2 etirer(facteur:2.0 [b c2]))] ]
	[echantillon(hauteur:~21 duree:1.0 instrument:none) echantillon(hauteur:~33 duree:2.0 instrument:none) echantillon(hauteur:~33 duree:2.0 instrument:none)] }   
   \endif

   % Demo Music
   % {Browse {Projet.run Mix Interprete {Projet.load CWD#'joie.dj.oz'} CWD#'out.wav'}}
end
