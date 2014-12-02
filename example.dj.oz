% Hymne à la joie.
local
   Base  = [c#3 d4 c#3]
   Quick = [etirer(facteur:(2.0/3.0) Base)]
   Slow  = Base
   Intro = [etirer(facteur:0.6 [a1 Slow a1 Quick a2 Slow a2 Quick f#2 Slow f#2 Quick f2 Slow f2 Quick])]

   Top      = [c#2 e1 c#2]
   TopQuick = [etirer(facteur:(2.0/3.0) Top)]
   Chorus = [a3 Top a3 TopQuick c#4 Top c#4 TopQuick e4 Top e4 Top]
   Partition = [Intro Chorus]
   % Ceci n'est pas une musique
in
   [partition(Partition)]
end