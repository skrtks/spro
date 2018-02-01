# Proces App Studio

## Vrijdag 12 -01
De eerste stap in het opzetten van het xcode project was een begin maken aan het storyboard in UI builder. Op het beginscherm heb ik gekozen om d drie cellen waarin info over de koffiezaakjes komt te staan op de zetten als knoppen. Een tableview inbouwen met daarin cellen die ver genoeg uit elkaar stonden bleek lastiger dan het leek en ook op Stack Overflow kon ik weinig informatie vinden. 

## Maandag 15 - 01
Vandaag wilde ik graag stappen maken in het opvragen en laten zien van details over een coffee bar in de detailViewController.

Het gebruiken van de JSON levert soms wat problemen op m.b.t. optionals. Ik moet er even achter gaan komen hoe dit precies in elkaar steekt. Dat is een goede taak voor morgen. 

API functies worden nu aangeroepen in ViewDidLoad().

Als laatste ben ik bezig geweest met het aanpassen van de kleur van de tekst van de status bar. De code die ik overal vind is:
	override var preferredStatusBarStyle : UIStatusBarStyle {
	return UIStatusBarStyle.default
	}
Ik heb een test App’je van GitHub gehaald en hier werd deze code, maar in mijn eigen project niet… Marijn kon er ook niet achter komen.

![](doc/StatusBar.png)

## Dinsdag 16 - 01
Toegevoegde functies:
- Afstand huidige locatie naar venue is zichtbaar in home en detail view.
- Vanuit detail view kan kaart worden opgeroepen met de huidige locatie en locatie van geselecteerde venue. 

Naast het implementeren van deze functies heb ik nog even gekeken naar de manier waarop de JSONs worden uigepakt. Ik heb er voor gezorgd dat optionals niet meer geforceerd worden uitgepakt om crashes te voorkomen. 

## Woensdag 17 - 01
Toegevoegde functies:
- Als de kaartweergave wordt geopend is nu ook meteen een voorgestelde route vanaf de huidig locatie naar
  de koffiezaak zichtbaar.
- In de kaartweergave is nu een knop beschikbaar die de gebruiker naar de Apple Maps applicatie leidt
  voor een echte routebeschrijving.
  
Naast deze nieuwe functies heb ik een aantal UI aanpassing gedaan die de gebruikservaring verbeteren. Daarnaast heb ik
er voor gezorgd dat de interface consistent is op apparaten met verschillende schermgroottes.

## Donderdag 18 - 01
Toegevoegde functionaliteit:
- Als je terug gaat naar het beginscherm word altijd opnieuw de locatie bepaald en de API opnieuw aangesproken voor verse data.

Het blijkt dat als je de kleur van de statusbar tekst wilt aanpassen in een VC die in een nav controller zit, dat op een andere manier moet. Probleem opgelost!

Verder heb ik vandaag nog een beetje mijn code opgeschoont. 

## Vrijdag 19 - 01

Vandaag presentatie gegeven over de voortgang van mijn app. 

Ik had gisteren wat problemen met het laden van de table view in mijn detail view controller. Dat is nu opgelost en ik ben bezig met het goed weergeven van de reviews in de cellen. De grootste uitdaging is dat de grootte van de cell aanpast naar aanleiding van de lengte van de review die moet worden weergegeven. Ik weet op dit moment nog niet of dat mogelijk is, maar ik denk het wel. Edit: dit blijkt heel makkelijk te zijn en gebeurd, zoals we al heel vaak gedaan hebben, als het aantal regels op 0 wordt gezet. 

## Maandag 22 - 01

De groene knop voor het opvragen van een routebeschrijving was moeilijk aan te tikken doordat deze een beetje aan de kleine kan was. Ik heb de knop daarom een stukje verplaatst en groter gemaakt zodat het duidelijk is dat de optie beschikbaar is. 

Ik heb een refreshknop geplaatst op de beginpagina, zodat de huidige locatie en de bijbehorende resultaten opnieuw geladen worden. De functionaliteit werkt echter nog niet helemaal, ik hoop dat morgen op te lossen. 

Om de rating van een plek duidelijk te maken heb ik kleuren toegevoegd die door de API geleverd worden. De API levert HEX waarden en om die te kunnen gebruiken moest een extention worden toegevoegd voor UIColor.

## Dinsdag 23 - 01

- UI Table omgezet in UI View omdat ik nog extra informatie wil geven die niet in een UITableView past
- Return knop start nu een zoekactie
- Keybord kan nu worden verborgen
- Er worden adres suggesties gegeven tijdens het typen

Ik ben op advies van Marijn overgestapt op requestLocation in plaats van startUpdating location omdat je dan zeker weet de de locatie services stoppen als de locatie gevonden is. 

Ik ben even een beetje vastgelopen met de layout van een van mijn custom cellen. Op de een of andere manier wordt het plaatje steeds heel groot.

## Woensdag 24 - 01
Vandaag heb ik het een en ander opgeschoond.
- Zoek knop op home screen verwijdert omdat die eigenlijk overbodig was.
- Aantal interface problemen opgelost.
- Als bepaalde informatie niet beschikbaar is blijft het label niet meer leeg.
- Aantal bugs met het verwerken van de automatisch gegenereerde adressen opgelost. 

## Donderdag 25 - 01

Ik heb vandaag het een en ander geëxperimenteerd met een scroll view die de hele detailpagina laat scrollen, i.p.v. alleen de reviews. Dit blijkt echter nog vrij lastig. Het was denk ik beter geweest als ik dat vanaf het begin had willen doen en er steeds rekening mee had gehouden. Ik ga het idee morgen tijdens de presentaties even voorleggen en aan de hand daarvan bepalen of ik er nog energie in ga stoppen of niet. 

Om toch nog iets nuttigs te doen heb ik een icoontje en een opstartscherm ontworpen voor de app. 

## Vrijdag 26 - 01

Ik heb tijdens de presentaties het idee van gisteren voorgelegd en daar kwam uit dat hoe ik het nu heb eigenlijk helemaal goed is. Dus ik ga het laten.

## Maandag 29 - 01

Kleine probleempjes opgelost met de UI. Het was niet duidelijk als de refresh en map knop werken ingedrukt. 

Ik heb vandaag even goed de feedback van App Studio bekeken en heb die verwerkt in de code van ‘spro’. Daarnaast heb ik even mijn code echt goed nagelopen en nog wat ontbrekende comments toegevoegd. Als laatste heb ik even gekeken naar mijn ToDo list op better code hub en heb ik nog een aantal functies iets korter gemaakt en ik heb een .gitignore toegevoegd.

## Dinsdag 30 - 01

Code review gedaan met David. Bij hem was de code nog niet helemaal op orde en ik heb vooral tips gegeven voor het duidelijker indelen van de code zodat het makkelijker wordt om er achter te komen hoe de code in elkaar zit. David vond mijn code base overzichtelijk en de enige belangrijke opmerking die hij gegeven heeft was dat ik nog even goed naar mijn comments moet kijken. Er zijn nu wat overbodige comments die ik misschien beter weg kan halen. 

Ik heb mijn comments herzien en een aantal functies voorzien van “Swift doc’s” voor iets meer overzicht. 

## Woensdag 31 - 01

Vandaag begonnen aan het maken van het final report en het aanpassen van de readme etc.

## Donderdag 01 - 02

Verder gewerkt aan het verslag.
