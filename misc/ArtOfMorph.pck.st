'From Cuis7.5 [latest update: #7387] on 4 August 2025 at 5:02:29 pm'!
'Description '!
!provides: 'ArtOfMorph' 1 13!
!requires: 'UI-Widgets' 1 54 nil!
!requires: 'UI-Panel' 1 130 nil!
SystemOrganization addCategory: #ArtOfMorph!


!classDefinition: #MedicCross category: #ArtOfMorph!
PlacedMorph subclass: #MedicCross
	instanceVariableNames: 'width'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'ArtOfMorph'!
!classDefinition: 'MedicCross class' category: #ArtOfMorph!
MedicCross class
	instanceVariableNames: ''!

!classDefinition: #Ruler category: #ArtOfMorph!
PlacedMorph subclass: #Ruler
	instanceVariableNames: 'length lastHandPosition font'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'ArtOfMorph'!
!classDefinition: 'Ruler class' category: #ArtOfMorph!
Ruler class
	instanceVariableNames: ''!

!classDefinition: #EllipseDemo category: #ArtOfMorph!
ColoredBoxMorph subclass: #EllipseDemo
	instanceVariableNames: 'shrink'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'ArtOfMorph'!
!classDefinition: 'EllipseDemo class' category: #ArtOfMorph!
EllipseDemo class
	instanceVariableNames: ''!

!classDefinition: #FileRequestMorph category: #ArtOfMorph!
StringRequestMorph subclass: #FileRequestMorph
	instanceVariableNames: 'fileBrowser'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'ArtOfMorph'!
!classDefinition: 'FileRequestMorph class' category: #ArtOfMorph!
FileRequestMorph class
	instanceVariableNames: ''!

!classDefinition: #FileSelectorPane category: #ArtOfMorph!
FlowLayoutMorph subclass: #FileSelectorPane
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'ArtOfMorph'!
!classDefinition: 'FileSelectorPane class' category: #ArtOfMorph!
FileSelectorPane class
	instanceVariableNames: ''!


!MedicCross commentStamp: 'hlsf 7/29/2025 15:53:25' prior: 0!
A flashing medical cross

	MedicCross new openInHand

!

!MedicCross methodsFor: 'initialization' stamp: 'hlsf 7/29/2025 15:52:21'!
initialize
	super initialize.
	width := 0! !

!MedicCross methodsFor: 'drawing' stamp: 'hlsf 7/29/2025 15:53:09'!
drawOn: aCanvas
	aCanvas strokeWidth: width color: Color green lighter fillColor: Color green do: [
		aCanvas polyLine: {
			100@0 .	140@0 .	140@100 . 240@100 . 240@140 .140@140 .
			140@240 . 100@240 . 100@140 . 0@140 . 	0@100 . 100@100.
			100@0 } ].! !

!MedicCross methodsFor: 'stepping' stamp: 'hlsf 7/29/2025 22:42:13'!
step
	width := width + 0.2.
	width > 30 ifTrue: [width := 0].
	self redrawNeeded.! !

!MedicCross methodsFor: 'stepping' stamp: 'hlsf 7/29/2025 15:46:34'!
stepTime
	^ 10 ! !

!MedicCross methodsFor: 'stepping' stamp: 'hlsf 7/29/2025 15:52:40'!
wantsSteps
	^ true ! !

!Ruler methodsFor: 'drawing' stamp: 'hlsf 7/31/2025 23:59:02'!
drawOn: canvas
	| grad posX extent step roundedLength |
	roundedLength := length rounded.
	extent := roundedLength * self ppcm + (self ppcm / 2) @ 60.
	
	canvas fillRectangle: (-5@0 corner: extent x @ 25) color: Color yellow.
	canvas fillRectangle: (-5@25 corner: extent ) color: (Color yellow alpha: 0.5).
	canvas frameRectangle: (-5@0 corner: extent) borderWidth: 0.5 color: Color yellow muchDarker .

	step :=  self ppcm / 2. " half centimeter step "
	canvas strokeWidth: 0.8 color: Color black do: [
		posX := 0.
		roundedLength + 1 timesRepeat: [
			canvas moveTo: posX @ 0.5; lineToY: 10.
			canvas moveTo: (posX  + step) @ 0.5 ; lineToY: 6.
			posX := posX + self ppcm] ].

	step := self ppcm / 10. "millimeter step "
	canvas strokeWidth: 0.3 color: Color black do: [
		posX := step.
		roundedLength * 2 + 1 timesRepeat: [
			4 timesRepeat: [
				canvas moveTo: posX @ 0.2; lineToY: 4.
				posX := posX + step].
			posX := posX + step] ].

	grad := posX := 0.
	roundedLength + 1 timesRepeat: [
		canvas drawString: grad asString atCenterX: posX @12 font: font color: Color black.
		grad := grad + 1.
		posX := posX + self ppcm].! !

!Ruler methodsFor: 'accessing' stamp: 'hlsf 7/31/2025 23:53:55'!
length: newLength
	length := newLength max: 1.
	self positioningButtons.
	self redrawNeeded ! !

!Ruler methodsFor: 'accessing' stamp: 'hlsf 7/31/2025 18:34:21'!
ppcm
" pixels per cm "
	^ 50.0! !

!Ruler methodsFor: 'initialization' stamp: 'hlsf 7/31/2025 23:57:21'!
initialize
	super initialize.
	font := FontFamily familyName: FontFamily defaultFamilyName pointSize: 8.
	length := 10 "cm".
	self insertButtons ! !

!Ruler methodsFor: 'initialization' stamp: 'hlsf 7/31/2025 20:28:28'!
insertButtons
| btn buttonExtent |
	buttonExtent := Theme current refreshIcon extent * 1.5. 
	btn := ButtonMorph model: self action: #rotateRuler ::
		actWhen: #buttonStillDown;
		icon: Theme current refreshIcon;
		color: Color transparent;
		selectedColor: Color yellow darker;
		morphExtent: buttonExtent.
	self addMorph: btn.
	btn := ButtonMorph model: self action: #resizeRuler ::
		actWhen: #buttonStillDown;
		icon: (Theme current fetch: #( '16x16' 'actions' 'go-last' ));
		color: Color transparent;
		selectedColor: Color yellow darker;
		morphExtent: buttonExtent.
	self addMorph: btn.
	self positioningButtons 
	! !

!Ruler methodsFor: 'initialization' stamp: 'hlsf 7/31/2025 20:28:28'!
positioningButtons
| buttonWidth position |
	buttonWidth := submorphs first morphWidth.
	position := length rounded * self ppcm -4 @ 30.
	submorphs do: [:btn |
		btn morphPosition: position.
		position :=  position translatedBy:  - 4 - buttonWidth @ 0 ]
		! !

!Ruler methodsFor: 'geometry' stamp: 'hlsf 7/31/2025 14:36:31'!
rotationCenter
	^ `0@0`! !

!Ruler methodsFor: 'as yet unclassified' stamp: 'hlsf 8/1/2025 00:04:38'!
resizeRuler
	| event prev |
	"any thing new to do?"
	event := self activeHand lastMouseEvent.
	event isMove 
		ifTrue: [
			prev := lastHandPosition.
			lastHandPosition := self internalizeFromWorld: event eventPosition.
			self length: length + (lastHandPosition x - prev x / self ppcm)] 
		ifFalse: [lastHandPosition := self internalizeFromWorld: event eventPosition].! !

!Ruler methodsFor: 'as yet unclassified' stamp: 'hlsf 8/1/2025 10:35:11'!
rotateRuler
	| event p1 v1 v2|
	"any thing new to do?"
	event := self activeHand lastMouseEvent.
	event isMove 
		ifTrue: [
			p1 := self externalizeToWorld: self rotationCenter.
			v1 := lastHandPosition - p1.
			lastHandPosition := event eventPosition.
			v2 := lastHandPosition - p1.
			(v1 isZero or: [v2 isZero]) ifTrue: [^self].
			self rotateBy:  ((v1 crossProduct: v2) / (v1 r * v2 r)) arcSin ] 
		ifFalse: [lastHandPosition := event eventPosition].! !

!EllipseDemo methodsFor: 'accessing' stamp: 'hlsf 6/14/2025 12:17:51'!
center
	^  extent / 2.0! !

!EllipseDemo methodsFor: 'accessing' stamp: 'hlsf 6/14/2025 13:32:35'!
semiAxises
" the semi minor and major axis of the ellipse"
	^  (extent / 2.0) - shrink ! !

!EllipseDemo methodsFor: 'initialization' stamp: 'hlsf 6/11/2025 18:54:04'!
defaultExtent
	^ 200@200! !

!EllipseDemo methodsFor: 'initialization' stamp: 'hlsf 6/19/2025 23:45:40'!
initialize
	super initialize.
	color := Color yellow.
	shrink := 0.
	'Hover over the circle to change its color and unhover to change it back.' print.
	'Click it with left or right button to shrink or to grow the ellipse.' print.
	'Move mouse over the circle and press r, g, or b to change its color.' print.! !

!EllipseDemo methodsFor: 'drawing' stamp: 'hlsf 6/14/2025 12:56:07'!
drawOn: aCanvas
	aCanvas fillColor: color do: [
 		aCanvas ellipseCenter: self center radius: self semiAxises ]! !

!EllipseDemo methodsFor: 'event handling testing' stamp: 'hlsf 6/19/2025 23:48:44'!
handlesKeyboard
"This enables the morph to handle key events if it has focus."
    ^ self visible! !

!EllipseDemo methodsFor: 'event handling testing' stamp: 'hlsf 6/14/2025 13:31:52'!
handlesMouseDown: aMouseEvent
"This enables the morph to handle mouse events such as button presses."
    ^ true! !

!EllipseDemo methodsFor: 'event handling testing' stamp: 'hlsf 6/14/2025 12:53:26'!
handlesMouseOver: aMouseEvent
"This enables the morph to handle mouse enter and leave events."
    ^ true! !

!EllipseDemo methodsFor: 'events' stamp: 'hlsf 6/29/2025 12:10:49'!
keyStroke: aKeyEvent
	| character increment h s v |
	super keyStroke: aKeyEvent.
	aKeyEvent wasHandled ifTrue: [^ self].
	character := Character codePoint: aKeyEvent keyValue.
	color := character 
		caseOf: {
			[ $r ] -> [ `Color red` ].
			[ $g ] -> [ `Color green` ].
			[ $b ] -> [ `Color blue` ] }
		otherwise: [color].
	
	h := color hue.
	s := color saturation.
	v := color brightness .
	increment := aKeyEvent controlKeyPressed ifTrue: [-0.1] ifFalse: [0.1].
	character 
		caseOf:   {
			[ $h ] -> [ h := h + (increment * 13) ].
			[ $s ] -> [ s := s + increment ].
			[ $v ] -> [ v := v + increment ]
		} 
		otherwise: [].
	color setHue: h saturation: s brightness: v.
	self redrawNeeded! !

!EllipseDemo methodsFor: 'events' stamp: 'hlsf 6/19/2025 23:52:50'!
mouseButton1Down: aMouseEvent localPosition: aPosition
    shrink := (shrink + 0.5) min: (extent x min: extent y) // 2.
    (Preferences at: #focusFollowsMouse) ifFalse: [aMouseEvent hand newKeyboardFocus: self].
    self redrawNeeded! !

!EllipseDemo methodsFor: 'events' stamp: 'hlsf 6/14/2025 13:33:22'!
mouseButton2Down: aMouseEvent localPosition: aPosition
    shrink := (shrink - 5) max: 0.
    self redrawNeeded! !

!EllipseDemo methodsFor: 'events' stamp: 'hlsf 6/19/2025 23:52:35'!
mouseEnter: aMouseEvent
    color := `Color green`.
    "If the user opted for focus to automatically
     move focus to the morph under the cursor then tell
     the cursor (event hand) to give focus to this morph."
    (Preferences at: #focusFollowsMouse) ifTrue: [aMouseEvent hand newKeyboardFocus: self].
    self redrawNeeded.! !

!EllipseDemo methodsFor: 'events' stamp: 'hlsf 6/28/2025 09:36:28'!
mouseLeave: aMouseEvent
	super mouseLeave: aMouseEvent.
	color := `Color red`.
	self redrawNeeded.! !

!EllipseDemo methodsFor: 'events' stamp: 'hlsf 6/14/2025 13:09:40'!
wantsContour 
	^ true! !

!EllipseDemo methodsFor: 'geometry testing' stamp: 'hlsf 6/11/2025 19:05:04'!
requiresVectorCanvas
	^ true ! !

!FileRequestMorph methodsFor: 'initialization' stamp: 'hlsf 7/27/2025 14:46:09'!
addTextPane
	super addTextPane.
	submorphs first addMorph: 
			((PluggableButtonMorph model: self action: #toggleFileBrowser)
				setBalloonText: 'Browse the file system to select a file or directory';
				icon: (Theme current fetch: #( '16x16' 'places' 'folder' )) )! !

!FileRequestMorph methodsFor: 'accessing' stamp: 'hlsf 7/27/2025 15:10:38'!
directoryEntry
	| editedContents | 
	editedContents := textMorph scroller contents asPlainString.
	^ editedContents asFileEntry exists
		ifTrue: [editedContents asFileEntry parent] 
		ifFalse: [editedContents asDirectoryEntry exists 
			ifTrue: [editedContents asDirectoryEntry ] ifFalse: [editedContents asDirectoryEntry parent] ]! !

!FileRequestMorph methodsFor: 'accessing' stamp: 'hlsf 7/27/2025 14:33:32'!
response: aText
	| answer |
	answer := super response: aText.
	(answer and: [fileBrowser notNil]) ifTrue: [fileBrowser delete].	
	^ answer! !

!FileRequestMorph methodsFor: 'accessing' stamp: 'hlsf 7/27/2025 12:59:21'!
toggleFileBrowser
	fileBrowser ifNotNil: [
		fileBrowser delete.
		fileBrowser := nil.
		^ self].
	fileBrowser := FileSelectorPane new	open: self directoryEntry.
	fileBrowser when: #selectedFile send: #entry: to: self.
	fileBrowser 
		color: (Color white alpha: 0.8);
		morphPosition: self morphPosition + (0 @ (self morphHeight + 5));
		morphExtent: self morphExtent * (1@5);
		openInWorld

	! !

!FileRequestMorph methodsFor: 'events' stamp: 'hlsf 7/29/2025 10:48:13'!
entry: anEntry
	textMorph hasUnacceptedEdits: false.
	response := anEntry asString.
	self changed: #response.
	textMorph hasUnacceptedEdits: true.! !

!FileRequestMorph methodsFor: 'private' stamp: 'hlsf 7/27/2025 12:50:16'!
cancel
	super cancel.
	fileBrowser ifNotNil: [fileBrowser delete]! !

!FileRequestMorph methodsFor: 'private' stamp: 'jmv 7/28/2025 14:40:16'!
ok
	self delete.
	fileBrowser ifNotNil: [fileBrowser delete]! !

!FileRequestMorph class methodsFor: 'as yet unclassified' stamp: 'hlsf 7/27/2025 18:09:49'!
example
"
	FileRequestMorph example	
"
	^ FileRequestMorph 
		request: 'Select a file or directory' 
		initialAnswer: DirectoryEntry userBaseDirectory asString 
		orCancel: nil.
! !

!FileRequestMorph class methodsFor: 'instance creation' stamp: 'hlsf 7/29/2025 10:54:20'!
request: queryString
	^ self request: queryString initialAnswer: DirectoryEntry userBaseDirectory asString! !

!FileSelectorPane methodsFor: 'initialization' stamp: 'hlsf 7/19/2025 13:26:16'!
initialize
	super initialize.
	self open: DirectoryEntry userBaseDirectory
	! !

!FileSelectorPane methodsFor: 'private' stamp: 'hlsf 7/28/2025 23:53:42'!
entryPreviewFor: fileEntry
	| fileView |
	fileView := FilePreviewMorph 
		object: fileEntry 
		image: ((fileEntry isFileEntry 
			ifTrue: [Theme current genericTextIcon] 
			ifFalse: [Theme current fetch: #( '16x16' 'places' 'folder' )]) magnifyTo: 64@64)
		buttons: nil
		label: (fileEntry isRoot ifTrue:['/'] ifFalse: [fileEntry baseName]) ::
		borderColor: Color transparent;
		color: Color transparent.
	fileEntry isDirectoryEntry ifTrue: [
		fileView when: #doubleClick send: #open: to: self with: fileEntry].
	fileView when: #selected send: #toggleSelection: to: self with: fileView.
	^ fileView ! !

!FileSelectorPane methodsFor: 'private' stamp: 'hlsf 7/19/2025 11:57:59'!
previewsFor: entries
	^ (entries sort: [:a :b | a baseName asUppercase < b baseName asUppercase ]) collect: [:anEntry | 
		self entryPreviewFor: anEntry]! !

!FileSelectorPane methodsFor: 'accessing' stamp: 'hlsf 7/29/2025 10:48:53'!
open: aDirectoryEntry
	| entryViews |
	model := aDirectoryEntry.
	entryViews := OrderedCollection new.
	model isRoot ifFalse: [ | parentView |
		parentView := self entryPreviewFor: model parent.
		parentView relabel: '..' bold.
		entryViews add: parentView].
	entryViews 
		addAll: (self previewsFor: model directories);
		addAll: (self previewsFor: model files ).
	self cells: entryViews.
	self updateLayout ! !

!FileSelectorPane methodsFor: 'events' stamp: 'hlsf 7/25/2025 19:22:15'!
toggleSelection: fileView
	| selectedView |
	selectedView := cells detect: [:aFileView | aFileView isSelected] ifNone: [nil].	
	selectedView = fileView
		ifTrue: [
			fileView toggleSelection. " unselect view, no view selected anymore "
			selectedView := nil]			
		ifFalse: [
			selectedView ifNotNil: [selectedView toggleSelection].
			fileView selected: true.
			selectedView := fileView].
	selectedView 
		ifNil: [self triggerEvent: #noSelection]
		ifNotNil: [self triggerEvent: #selectedFile with: selectedView fileEntry]! !
