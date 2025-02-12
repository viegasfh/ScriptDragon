import QtQuick 2.0
import Ubuntu.Components 1.3
import QtQuick.Dialogs 1.2 //To avoid confustion: This import is for ColorDialog, not Dialog. That comes from Ubuntu.Components.Popups
import Ubuntu.Components.Popups 1.3
import Ubuntu.Components.ListItems 1.3 as ListItem
import ninja.theopensource.scriptdragon 1.0

//-------------------------BEGIN SECTION: COMMON TO ALL NOTECARDS-----------------------------
//This is stuff that should be common to all notecards of all types. If changes are made here, replicate them elsewhere!!

import ninja.theopensource.scriptdragon 1.0 //for any data that can't be attached directly to a QML Notecard object, this gives us access to the C++-defined NotecardData type

Rectangle {
	width: units.gu( 5 * 6 ) //The 5 is from real notecards, which can be 5x7 inches. The *6 multiplier is to make it usable on my computer screen and was found through experimentation.
	height: width * 1.4 //*1.4 reflects the aspect ratio of 5x7 notecards.
	color: "white"
	border.color: "black"
	id: theCard
	property alias text: textArea.text
	property alias title: titleArea.text
	
	property int associatedID
	property var associatedText: {
		switch( associationType ) {
			case NotecardManager.NONE:
				return "None";
			
			case NotecardManager.CHARACTER:
				return NotecardManager.getCharactersPage().characters[ associatedID ].name;
			
			case NotecardManager.LOCATION:
				return NotecardManager.getLocationsPage().locations[ associatedID ].name;
			
			case NotecardManager.STORYLINE:
				return NotecardManager.getStorylinesPage().storylines[ associatedID ].name;
				
			default:
				return "Association type not in switch statement";
		}
	}
	
	function setAssociatedText( newText ) {
		associatedText = newText
	}

	property int associationType
	
	property bool isDuplicate
	property int idWithinAssociatedThing
	
	onTextChanged: {
		NotecardManager.updateNotecard( this );
	}
	onTitleChanged: {
		NotecardManager.updateNotecard( this );
	}
	onColorChanged: {
		NotecardManager.updateNotecard( this );
	}
	
	ColorDialog {
		id: colorDialog
		title: i18n.tr( "Choose a color for this notecard" )
		showAlphaChannel: false
		color: theCard.color
		currentColor: theCard.color
		
		onAccepted: {
			theCard.color = currentColor //The QT documentation says we should use "color", not "currentColor", but I've found that "color" only works every other time whereas "currentColor" works every time.
		}
	}
	
	Column {
		property real sizeMultiplier: .98 //Added because I want some margins for the color to show through. 98% just seems like a good value.
		width: parent.width * sizeMultiplier
		height: parent.height * sizeMultiplier
		anchors.centerIn: parent
		spacing: units.gu( 1 )
		
		Column {
			id: header
			width: parent.width
			spacing: parent.spacing
			
			TextField {
				placeholderText: i18n.tr( "Notecard Title" )
				color: "black"
				width: parent.width
				horizontalAlignment: TextInput.AlignHCenter
				opacity: 0.9
				id: titleArea
			}
			
			Row {
				width: parent.width
				
				Button {
					text: i18n.tr( "color" );
					id: colorButton
					onClicked: {
						colorDialog.open()
					}
				}
				Button {
					text: i18n.tr( "Hold to delete" )
					iconName: "delete"
					color: UbuntuColors.red
					width: parent.width - colorButton.width
					
					onPressAndHold: {
						NotecardManager.removeNotecard( theCard );
						//theCard.parent.setChildren();
					}
				}
			}
		}
		
		//-------------------------END SECTION: COMMON TO ALL NOTECARDS-----------------------------
		//-------------------------BEGIN SECTION: SPECIFIC TO THIS NOTECARD TYPE-----------------------------
		//This is stuff that should be common to all notecards of this particular type. 
		
		TextArea {
			width: parent.width
			height: parent.height - header.height - associativity.height
			autoSize: false
			maximumLineCount: 0
			opacity: 0.9
			id: textArea
			
			color: "black" //This is the color of the text, not of the text area itself
			
			placeholderText: i18n.tr( "Type a note here" )
		}
		
		//-------------------------END SECTION: SPECIFIC TO THIS NOTECARD TYPE-----------------------------
		//-------------------------BEGIN SECTION: COMMON TO ALL NOTECARDS-----------------------------
		Column {
			id: associativity
			width: parent.width
			height: associativityLabel.height + associatedTextLabel.height + ( linkButton.height * 1.5 )
			Label {
				text: i18n.tr( "Associativity: " )
				id: associativityLabel;
			}
			Label {
				text: associatedText
				id: associatedTextLabel;
			}

			Button {
				id: linkButton
				text: i18n.tr( "Change association" )
				
				enabled: ( NotecardManager.getCharactersPage().characterListModel.count > 0 || NotecardManager.getLocationsPage().locationListModel.count > 0 )
				
				onClicked: {
					//console.log(charactersTab);
					//console.log(NotecardManager.getCharactersPage().characterListModel)
					
					if( associatedID < NotecardManager.getCharactersPage().characters.length ) {
						//characterDialog.selector.selectedIndex = associatedID;
					}
					
					PopupUtils.open( dialogComponent )
				}
				
				Component {
					id: dialogComponent
					Dialog {
						id: dialog
						objectName: "dialog"
						title: i18n.tr( "Choose" )
						
						property var selectedAssociationType;
						property var selectedAssociatedID;
						property var selectedAssociatedText;
						
						ListItem.ItemSelector {
							id: typeSelector
							model: {
								var list = [ i18n.tr( "Select something" ) ];
								
								if( NotecardManager.getCharactersPage().characterListModel.count > 0 ) {
									list.push( i18n.tr( "Character" ) );
								}
								if( NotecardManager.getLocationsPage().locationListModel.count > 0 ) {
									list.push( i18n.tr( "Location" ) );
								}
								
								return list;
							}
							
							onSelectedIndexChanged: {
								console.log( selectedIndex );
								if( model[ selectedIndex ] == i18n.tr( "Select something" ) ) {
									console.log( "'Select something' selected" );
									selector.model = [];
									selectedAssociationType = NotecardManager.NONE;
								} else if( model[ selectedIndex ] == i18n.tr( "Character" ) ) {
									console.log( "Character selected" );
									selector.model = NotecardManager.getCharactersPage().characterListModel;
									selectedAssociationType = NotecardManager.CHARACTER;
									selectedAssociatedText = NotecardManager.getCharactersPage().characters[ selector.selectedIndex ].name
								} else if( model[ selectedIndex ] == i18n.tr( "Location" ) ) {
									console.log( "Location selected" );
									selector.model = NotecardManager.getLocationsPage().locationListModel;
									selectedAssociationType = NotecardManager.LOCATION;
									selectedAssociatedText = NotecardManager.getLocationsPage().locations[ selector.selectedIndex ].name
								}
								
								selectedAssociatedID = selector.selectedIndex;
							}
							
							expanded: false;
						}
						
						ListItem.ItemSelector {
							id: selector
							model: []
							expanded: false
						}
						
						Row {
							Button {
								text: i18n.tr( "OK" )
								onClicked: {
									console.log( "this notecard is a duplicate? " + theCard.isDuplicate );
									
									associationType = selectedAssociationType;
									associatedID = selectedAssociatedID;
									associatedText = selectedAssociatedText;
									
									dialog.parent = theCard.parent
									
									PopupUtils.close( dialog )
									
									dialog.modal = false
									//setTimeout( NotecardManager.associateNotecardWith( theCard, selectedAssociationType, selectedAssociatedID ), 1000 );
									
									NotecardManager.associateNotecardWith( theCard, selectedAssociationType, selectedAssociatedID );
									
								}
							}
							
							Button {
								text: i18n.tr( "Cancel" )
								onClicked: PopupUtils.close( dialog )
							}
						}
					}
				}
			}
		}
	}
}
//-------------------------END SECTION: COMMON TO ALL NOTECARDS-----------------------------
