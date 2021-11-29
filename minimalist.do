// This .do-file is intended to be compiled into a smcl presentation using:
// smclpres using minimalist.do
// ============================================================================

//toctitle A minimalist example presentation

/*toctxt

{center:Maarten Buis}
{center:maarten.buis@uni.kn}
toctxt*/

//section First section
//subsection First subsection

//slide -----------------------------------------------------------------------
//title First slide

/*txt
{pstd}Some interesting text about {help regress}{p_end}
txt*/

//ex
sysuse auto, clear
sum price
//endex
//endslide --------------------------------------------------------------------

//subsection Second subsection
//slide -----------------------------------------------------------------------
//title Second slide

/*txt
{phang}Kwaak, kwaak, kikker kwaak. Als ik grote sprongen maak. Doe ik 
net zo gek als jij, en ik kwaak er ook nog bij.{p_end}
{phang}Kwaak, kwaak, kwaak maar door. Kom maar in het kikker koor. 
Kwaak van dit en kwaak van dat. Kikkers kwaken altijd wat.{p_end}
txt*/
//endslide --------------------------------------------------------------------

//section Second section
//slide -----------------------------------------------------------------------
//title Third slide

/*txt
{phang}
Ia zegt het ezeltje, klim maar op mijn rug. Ik draag jou de hele weg, heen
end weer terug.

{phang}
Ia zegt het ezeltje. Ik loop van hier naar daar, en als je met me mee 
wil hoor ik graag, ia ia.
txt*/

//ex
reg price i.rep78 
//endex
//endslide --------------------------------------------------------------------
