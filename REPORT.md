# Eindrapport

## Korte beschrijving van de app

Deze app laat op een overzichtelijke manier de beste drie (specialty) koffiezaakjes op loopafstand van je huidige locatie zien, zodat je makkelijk een keuze kunt maken.

<img src="doc/HomeScreen.png" alt="Home Screen" height=“500">

## Technische aspecten
### Globaal overzicht

De app is onderverdeelt in vier view controllers. De ‘HomeViewController’ is het eerste scherm waar de gebruikers terecht komt na het openen van de app. Op dit scherm zijn de drie beste koffiezaakjes in de buurt te zien. Daarnaast is zoekbalk waarmee de gebruiker op de andere locatie kan zoeken. In de bijbehorende klasse is dan ook alle code ondergebracht die nodig is om dit scherm te laten zien en om interactie met de UI elementen te verwerken. 

In de ‘class DetailViewController’ staat alle code die nodig is om het detailscherm te laten zien. Dit scherm bevat meer informatie over een koffiezaak die is geselecteerd op het beginscherm. Vanuit deze view is het mogelijk om de MapView te bereiken.

De ‘class ResultViewController’ wordt gebruikt om zoekresultaten voor een door de gebruiker opgevraagde locatie weer te geven. Vanuit dit scherm kan  ook genavigeerd worden naar het detailscherm. 

De laatste klasse is de ‘class MapViewController’. De code in deze klasse zorgt er voor dat de kaart in de UIMapView op de juiste manier weergegeven wordt en dat er een route van de huidige locatie naar de bestemming wordt weergegeven. Vanuit het Kaartscherm is het mogelijk om een routebeschrijving aan te vragen in de maps applicatie. 

In ‘class RequestController’ staat alle code die nodig is om te communiceren met de API van Foursquare. 

In de onderstaande alinea’s zal een uitgebreid overzicht gegeven worden van de code in de verschillende klassen. 

### View Controllers
#### class HomeViewController
Tijdens het laden van de view die aan deze klasse gekoppeld is, wordt als eerste de huidige locatie opgevraagd met behulp van __CLLocationManager’s requestLocation()__. Zodra deze functie een locatie heeft verkregen, wordt uit de klasse ‘RequestController’ de closure ‘__getCoffeeBars(lat: , lon:)__’  aangeroepen. Zodra de completion handler in deze functie data heeft verkregen wordt deze opgeslagen in de ‘venueList’. De data wordt vervolgens in de ‘main queue’ gebruikt om UIViews te updaten. 

Naast het opvragen van de locatie en informatie over de koffiezaakjes, bevat deze klasse ook code voor het laten zien van suggesties voor adressen en locaties. Hiervoor wordt klasse __MKLocalSearchCompleter()__ gebruikt. De resultaten worden geleverd door searchCompleter.results en worden weergegeven in een tabel die verschijnt zodra de gebruiker begin met typen. 

Ook bevat deze klasse code voor het opvragen van de afstand tussen twee punten. Hiervoor wordt op de huidige locatie de functie __CLLocationDistance()__ aangeroepen. 

Vanuit HomeViewController zijn twee segues mogelijk. De eerste wordt uitgevoerd als de gebruiker één van de drie koffiezaakjes uit de lijst selecteert en leidt naar het detailscherm. De tweede segue wordt uitgevoerd als de gebruiker een zoekactie uitvoert. 

#### class ResultViewController
Deze klasse bevat code voor het zoeken naar koffiezaakjes op een andere locatie dan de huidige. De code in deze klasse lijkt veel op die in de HomeViewController. Het grootste verschil is dat in de resultatentabel in de view controller die aan deze klasse is gekoppeld geen afstand tot het zaakje laat zien, maar het adres dat bij het zaakje hoort. Hier is voor gekozen omdat als een gebruiker zoekt op een andere locatie, er waarschijnlijk meer interesse is voor een adres.

#### class DetailViewController
De segue naar deze controller levert altijd een ‘venueId’ aan. Dit is een uniek ID waarmee meer informatie over een plek uit de Foursquare API kan worden gehaald.  In de code wordt dit ID gebruikt om meer details over de plek te verkrijgen, zoals de openingstijden, en om reviews op te halen. 

De functie __getDetails()__ vraagt eerst details aan de API en slaat die op in ‘venueDetails’. Vervolgens wordt een afbeelding voor de plek verkregen die word opgeslagen in ‘image’. In de main queue worden dan de UI geüpdatet met __updateUI()__. 

Deze klasse bevat eveneens code om een afstand tussen twee punten te bepalen. Soortgelijk aan de code in de HomeViewController. Wanner het detailscherm bereikt wordt via het selecteren van een resultaat in de ‘Result View’, dan wordt geen afstand weergegeven omdat die waarschijnlijk niet relevant is. 

De detail klasse bevat een segue die leidt naar de kaart weergave. 

#### class MapViewController
De kaartweergave wordt aangestuurd door de klasse ‘MapViewController’. Deze klasse is vrij simpel en bevat code voor het schalen en centreren van de kaart en voor het laten zien van een route op de kaart. Als de gebruiker de knop ‘Directions in Apple Maps’ aanklikt wordt de gebruiker naar de Maps applicatie gebracht, waarin vervolgens een stap-voor-stap wandelroute wordt gegenereerd. 

Als de gebruiker terechtkomt in de kaartweergave vanuit een detailweergave die is bereikt vanuit het beginscherm, dan wordt de kaart gecentreerd op de huidige locatie en wordt een route weergegeven. Als de kaartweergave echter bereikt wordt vanuit een detailweergave die bereikt is vanuit het resultatenscherm. Dan wordt de kaart gecentreerd op de locatie van het geselecteerde koffiezaakje en wordt geen route gegeven. Hier is voor gekozen omdat een locatie die gevonden is via een zoekactie waarschijnlijk niet op loopafstand ligt. Het is dan fijner als je gewoon de locatie van het zaakje te zien krijgt en daar niet naar hoeft te zoeken op de kaart. 

### Utility Modules
#### SwiftyJSON
SwiftyJSON vrij toegankelijke ‘library’ die gebruikt wordt om het uitpakken van JSONs makkelijker te maken. 

#### class RequestController
Deze klasse bevat vier functies voor het verkrijgen van data uit de Foursquare API die worden aangeroepen in de ViewControllers. De functies zijn:
- getCoffeeBars(lat: Double, lon: Double)
- getDetails(venueId: String)
- getReviews(venueId: String)
- getImage(suffix: String)

Alle vier de functies zijn gekoppeld aan een completion handler, omdat de API aanvragen asynchroon zijn. Op deze manier komt de data pas beschikbaar als de API aanvraag klaar is. 

### Instances
#### class HomeTableViewCell
De custom cell die wordt gebruikt in de tabel met de koffiezaakjes in de buurt van de huidige locatie op het beginscherm.

#### class ResultsTableViewCell
De custom cell die wordt gebruikt in de tabel met de koffiezaakjes in de buurt van de ingevoerde locatie op het resultatenscherm.

#### class ReviewTableViewCell
Een custom cell die gebruikt wordt om de reviews te laten zien in de detailweergave.

#### class VenueAnnotation
Deze klasse genereert een marker voor een UIMapView. In dit geval worden alleen en titel en de coordinaten meegegeven. 

## Design aanpassingen en problemen

De functionaliteit die aan het begin van het project werd beoogd, is eigenlijk grotendeels beschikbaar. Er is zelfs iets meer functionaliteit: de suggesties tijdens het typen van een adres. Een belangrijk verschil met het design document is dat er geen aparte klasse ‘GeoFunctions’ is gekomen voor de locatie functies. Het bleek handiger om deze functionaliteit direct in de view controllers in te bouwen, omdat die meestal toch maar op een plek gebruikt werd. Alleen het berekenen van de afstand tussen twee punten wordt in twee classen gedaan, maar dat betreft één regel code. 

In het design plan heb ik geen aandacht besteed aan CoreLocation. Dit is echter een belangrijk deel van de applicatie geworden. Tijdens het schrijven van het design plan wist ik echter nog niet dat dit framework bestond en was ik vooral bezig met MapKit. MapKit bleek iets andere functionaliteit te bevatten dan ik aanvankelijk dacht en is echt alleen van belang voor het laten zien en bewerken van een kaart. CoreLocation daarentegen verzorgt alle functionaliteit omtrent het opvragen van de locatie van de gebruiker.

Ik heb af en toe wat problemen gehad met het uitpakken van JSONs. Op de een of andere manier had ik bedacht dat het oke was om optionals the forceren, dit resulteerde echter in een groot aantal crashes. Nu forceer ik nog wel een aantal optionals, maar die zijn altijd ergens anders al op veilig uitgepakt. Dat levert dus geen problemen meer op. 

Daarnaast had ik wat problemen met het aanpassen van de statusbar stijl. Op Stack Overflow werd ongeveer overal geschreven dat je die stijl zou moeten kunnen aanpassen met override var preferredStatusBarStyle : UIStatusBarStyle { return UIStatusBarStyle.default }. Dit werkte in mijn geval niet. Ik heb het toen even gelaten. Later ben ik er gelukkig achter gekomen dat een statusbar die in een ‘Navigation Controller’ zit niet op die manier aangepast kan worden, maar dat de stijl van de navigatiebar moet worden aangepast. 

Wat uiteindelijk niet gelukt is, is het laten scrollen van de gehele detailweergave. Een beetje in de stijl van de detailweergave in google maps. Het probleem is denk ik dat ik de pagina al helemaal had ingedeeld met layout guides en constraints en dat ik dat vervolgens in een scroll view probeerde te stoppen. Het was waarschijnlijk een stuk makkelijker geweest om eerst een scroll view te maken en daar de rest van de pagina in te bouwen. Tijdens de presentatie heb ik de situatie voorgelegd en toen is door de meerderheid van de groep besloten dat het eigenlijk beter was zoals ik het nu heb (alleen de reviews scrollen) dus ik heb het zo gelaten. 

Ik heb ook wat problemen gehad met het implementeren van een refreshknop op het beginscherm. Op de een of andere manier werd de locatie niet opnieuw geladen en was de huidige locatie nooit echt nauwkeurig. Dit bleek uiteindelijk heel makkelijk op te lossen. Ik maakte gebruik van startUpdatingLocation() waardoor de locatie blijft verversen en de eerste de beste locatie wordt gebruikt door de app (vaak niet zo nauwkeurig). Nu gebruik ik requestLocation() die de locatie ophaalt, wacht tot de locatie nauwkeurig genoeg is en dan die locatie beschikbaar maakt. Dit duurt iets langer, maar gebruikt uiteindelijk minder energie en is nauwkeuriger. 

## Verdediging
Mijn eindproduct wijkt uiteindelijk niet veel af van wat ik oorspronkelijk wilde doen. Wat vooral verandert is, is de implementatie van sommige functionaliteit en de UI. De functionaliteit is daar echter niet door verandert. 

De aanpassingen in de UI zijn heel duidelijk. Ik heb er voor gekozen om een ander kleurenschema te gebruiken en ik heb het uiterlijk van de detailpagina aangepast. In het oude ontwerp zag het er heel erg uit alsof er meerdere afbeeldingen beschikbaar waren, terwijl het nu duidelijk is dat er maar één afbeelding is. 

Als ik meer tijd had gehad, was ik waarschijnlijk meer mogelijkheden voor het verfijnen van zoekopdrachten gaan implementeren. Daarnaast zou ik nog wel wat meer mogelijkheden willen implementeren voor het bekijken van meer foto’s.
