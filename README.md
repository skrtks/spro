# Project voorstel SPRO
Sam Kortekaas - 10718095
Programmeerpoject semester 1 2017-2018

## Het probleem
Hou je van [”specialty coffee”](https://en.wikipedia.org/wiki/Specialty_coffee), maar vind je het vaak moeilijk om snel een goed specialty coffee zaakje te vinden? Google Maps laat alleen een onoverzichtelijk geheel van alle plekken zien en op internet naar lijstjes gaan zoeken in ook niet al te makkelijk. Hierdoor verspil je tijd aan zoeken, die je ook aan een fijne koffiepauze had kunnen besteden!

## De oplossing
Deze app laat op een overzichtelijke manier de beste drie (specialty) koffiezaakjes op loopafstand van je huidige locatie zien, zodat je makkelijk een keuze kunt maken. 

### Impressie
![](doc/sproConcept%20(dragged).pdf)
Op de eerste afbeelding is het beginscherm te zien. Dit scherm wordt getoond zodra de app wordt geopend. Op het beginscherm worden de drie dichtstbijzijnde koffiezaakjes weergegeven. Daarnaast is er de mogelijkheid om een zoekactie te doen voor een andere locatie dan de huidige. 

![](sproConcept%20(dragged)-1.pdf "Results view")
Op de resultatenpagina worden de resultaten voor een andere locatie weergegeven. 

![](sproConcept%20(dragged)-2.pdf "Detail view")
Als een resultaat op het beginscherm of op de resultatenpagina wordt geselecteerd dan wordt het detailscherm getoond. Op dit scherm is wat basisinformatie te zien over het koffiezaakje. Daarnaast worden een aantal reviews weergegeven. De knop “Directions” brengt de gebruiker naar de Apple Maps applicatie waar een routebeschrijving wordt gestart. De “View on map” knop brengt de gebruiker naar een nieuw scherm waar de locatie op de kaart wordt weergegeven. 

![](sproConcept%20(dragged)-3.pdf "Map view")
In de kaartweergave wordt de locatie van het koffiezaakje op de kaart weergeven. Ook wordt de huidige locatie van de gebruiker weergegeven. 

### Belangrijkste functies
- Direct laten zien van drie koffiezaakjes in de buurt (MVP).
- Zoeken naar koffiezaakjes op andere locaties dan de huidige.
- Het verkrijgen van meer informatie, zoals openingstijden, foto’s en recenties, in de detailweergave (MVP). 
- De locatie van het koffiezaakje bekijken op een kaart (MVP).
- Een routebeschrijving aanvragen in Apple Maps (MVP).

### Optionele functie
- Indicatie in de detailweergave waarop te zien is of een koffiezaakje fotogeniek is. Op basis van het gemiddelde aantal instagram posts op die locatie. 

## Vereisten
Data voor de locatie, openingstijden, foto’s etc. komt van de [Foursquare Places API](https://developer.foursquare.com/places-api).  De API levert deze data aan als JSON. Om de huidige locatie van de gebruiker te bepalen wordt gebruik gemaakt van het [Core Location Framework](https://developer.apple.com/documentation/corelocation) dat door apple geleverd wordt. Daarnaast moet een kaart worden gegenereerd met de locatie van het gekozen koffiezaakje. Hiervoor zal gebruik gemaakt worden van [MapKit](https://developer.apple.com/documentation/mapkit). 

Optioneel is het bepalen of een koffiezaakje fotogeniek is aan de hand van het aantal instagram posts op die locatie. Om deze data te verkrijgen kan gebruik gemaakt worden van de [location endpoints](https://www.instagram.com/developer/endpoints/locations/) van de Instagram API. 

Een aantal voorbeelden van apps die ongeveer het zelfde doen als deze app zijn Apple Maps, Google Maps, Foursquare en Yelp. Deze apps doen allemaal ongeveer het zelfde, maar op net een andere manier. Wat bij alle apps opvalt, is dat ze vrij veel resultaten laten zien.  Ook resultaten die vrij ver zijn. In deze app is het de bedoeling om de gebruiker niet te overweldigen met resultaten. 

In de onderstaande screenshots is te zien dat Apple Maps en Google Maps een groot aantal resultaten laten zien. 
![](IMG_0230.PNG)
_Apple Maps_
![](IMG_0229.PNG)
_Google Maps_

Als in google maps een resultaat geselecteerd wordt, komt een overzicht tevoorschijn dat erg duidelijk is. Ik wil deze pagina graag als voorbeeld nemen voor deze app. Het is prettig dat de belangrijke informatie in een keer beschikbaar is. Dit is te zien op de onderstaande afbeelding. 
![](IMG_4F972EADFF35-1.jpeg)

Ik verwacht dat het moeilijkste deel van de implementatie het implementeren van de kaart wordt. In het bijzonder het laten zien van een marker die ook nog wat informatie, zoals de afstand tot de gebruiker, laat zien. Daarnaast denk ik dat het nog vrij lastig zal zijn om de UI echt duidelijk te houden. 
