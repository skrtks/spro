# Design document spro
Sam Kortekaas - 10718095
Programmeerpoject semester 1 2017-2018

## Advanced sketch
![](doc/sproAdvancedScetch.jpeg)
## Code indeling
### Utility modules
Utility modules zijn klassen die code bevatten voor het doen van taken die niet thuishoren in de UI controllers. In het geval van deze app zal dat het praten met de Foursquare API zijn. Daarnaast kies ik er ook voor om een klasse te maken die code bevat voor locatie en route doeleinden. Deze klassen komen in twee swift bestanden: FoursquareApiFunctions.swift en GeoFunctions.swift.

### UI View Controllers & klassen
De UI View Controllers besturen de interface elementen van de app. Daarnaast verzorgen ze de overgangen van scherm naar scherm, en het doorgeven van data tussen de classen, mocht dat nodig zijn. De klassen en bestanden die verwacht te gaan gebruiken zijn:
- HomeViewController.swift - class HomeViewController
- ResultViewController.swift - class ResultViewController
- DetailViewController.swift - class DetailViewController
- MapViewController.swift - class MapViewController
- LocationMarker.swift - class LocationMarker (gebruikt om een ‘custom’ marker op de kaart te laten zien, vergelijkbaar met een ‘custom’ cell in een tabel).

### Functies
De benodigde functies zullen waarschijnlijk nog vrij veel veranderen, maar een aantal functies zal zeker aanwezig zijn.
#### In view controllers:
- updateUI: wordt gebruikt voor het updaten van de UI na het veranderen van weer te geven data of na een interactie door de gebruiker. 
- mapView: genereert een kaart op basis van een aantal voorkeuren.
#### In FoursquareApiFunctions:
- getPlaces: praat met de API om een lijst met plekken die voldoen aan de gestelde criteria te verkrijgen.
- getDetails: praat met de API om details over een plek te verkrijgen.
- getTips: praat met de API om een lijst met recensies op te halen.
- getPhotos: praat met de API om de afbeeldingen die horen bij een plek te verkrijgen. 
#### In GeoFunctions:
- getCurrentLocation: deze functie wordt gebruikt om de huidige locatie van het apparaat te bepalen.
- generateRoute: zal gebruikt worden om met MKRoute een route te bepalen.

Hier komen zeker nog functies bij. Daarnaast zijn er nog de functies zoals prepare en viewDidLoad (for segue) die ook gebruikt zullen worden. 

## API’s & Frameworks
### Foursquare API
De Foursquare API zal gebruikt worden voor het zoeken naar plekken en het laten zien van details over die plekken. Als de Foursquare data niet compleet genoeg is kan er voor worden gekozen om nog extra data te halen uit de Yelp API. De Endpoints die naar verwachting gebruikt zullen gaan worden zijn:
- Recommendations: geeft de beste resultaten voor een query of categorie.
- Details: geeft gedetailleerde informatie over de locatie zien.
- Photo’s: vraagt de foto’s op een bepaalde locatie op.
- Tips: vraagt de tips op een bepaalde locatie op. 

### MapKit
MapKit is de library die door apple wordt aangeboden als onderdeel van het IOS platform. Deze library biedt veel mogelijkheden voor het laten zien van kaarten en het genereren van routes tussen twee punten. 

Naar verwachting zullen vooral de volgende onderdelen van MapKit gebruikt gaan worden:
- MKMapView: geeft een kaart weer op het scherm.
- MKPlacemark: geeft een locatie weer op de kaart.
- MKDirectionsRequest: begin en eindpunt van een route + vorm van transport.
- MKRoute: route tussen aangevraagde begin en eindpunt.
