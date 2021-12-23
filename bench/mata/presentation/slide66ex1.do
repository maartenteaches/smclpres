mata:
mata clear
collection = J(3,1,NULL)
collection[1] = &(1,5,2,5,3)
collection[2] = &( "Hallo, meneer de Uil," \
                   "waar breng je ons naar toe?" \
                   "Naar Fabeltjesland?" \
                   "Eh, ja, naar Fabeltjesland!" \
                   "En lees je ons dan voor" \
                   "uit de Fabeltjeskrant?" \
                   "Ja, ja, uit de Fabeltjeskrant!" \
                   "Want daarin staat precies vermeld" \
                   "hoe het met de dieren is gesteld." \
                   "Echt waar? " \
                   "Echt waar!" \
                   "Echt waar, meneer de Uil?" \
                   "Want dieren zijn precies als mensen" \
                   "Met dezelfde mensen-wensen" \
                   "En dezelfde mensen-streken" \
                   "Dat staan allemaal in de krant van Fabeltjesland," \
                   "van Fabeltjesland" \
                   "De faaabeltjeskrant" )
                   
void greetings(string scalar who)
{
    printf("Hello " + who)
}                  
                   
collection[3] = &greetings()

*collection[1]
*collection[2]
(*collection[3])("world")
end

