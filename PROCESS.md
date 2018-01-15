# Proces App Studio

## vrijdag 12 -01
De eerste stap in het opzetten van het xcode project was een begin maken aan het storyboard in UI builder. Op het beginscherm heb ik gekozen om d drie cellen waarin info over de koffiezaakjes komt te staan op de zetten als knoppen. Een tableview inbouwen met daarin cellen die ver genoeg uit elkaar stonden bleek lastiger dan het leek en ook op Stack Overflow kon ik weinig informatie vinden. 

## maandag 15 - 01
Vandaag wilde ik graag stappen maken in het opvragen en laten zien van details over een coffee bar in de detailViewController.

Het gebruiken van de JSON levert soms wat problemen op m.b.t. optionals. Ik moet er even achter gaan komen hoe dit precies in elkaar steekt. Dat is een goede taak voor morgen. 

API functies worden nu aangeroepen in ViewDidLoad().

Als laatste ben ik bezig geweest met het aanpassen van de kleur van de tekst van de status bar. De code die ik overal vind is:
	override var preferredStatusBarStyle : UIStatusBarStyle {
	return UIStatusBarStyle.default
	}
Ik heb een test App’je van GitHub gehaald en hier werd deze code, maar in mijn eigen project niet… Marijn kon er ook niet achter komen.

![](doc/StatusBar.PNG)
