'From Cuis7.5 [latest update: #7356] on 27 July 2025 at 10:54:25 am'!
'Description '!
!provides: 'ArtOfMorph' 1 6!
!requires: 'UI-Widgets' 1 54 nil!
SystemOrganization addCategory: #ArtOfMorph!


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

!FileRequestMorph methodsFor: 'initialization' stamp: 'hlsf 7/26/2025 16:39:35'!
addTextPane
	"Add a text pane and two buttons."
	
	| controlsContainer |
	textMorph := (TextModelMorph
		textProvider: self
		textGetter: #response
		textSetter: #response:
		selectionGetter: #selectionInterval) emptyTextDisplayMessage: 'Enter response'.
	self
		valueOfProperty: #emptyTextDisplayMessage
		ifPresentDo: [ :msg |
			textMorph emptyTextDisplayMessage: msg ].
	textMorph
		hasUnacceptedEdits: true;
		acceptOnCR: true;
		escAction: [ self cancel ].
	(controlsContainer := LayoutMorph newRow)
		addMorphUseAll: textMorph;
		addMorph: 
			((PluggableButtonMorph model: textMorph scroller action: #toggleFileBrowser)
				setBalloonText: 'Browse the file system to select file or directory' bold;
				icon: (Theme current fetch: #( '16x16' 'places' 'folder' )) );
		addMorph: 
			((PluggableButtonMorph model: textMorph scroller action: #acceptContents)
				setBalloonText: 'OK' bold, ' (accept input)';
				icon: Theme current acceptIcon);
		addMorph:
			((PluggableButtonMorph model: self action: #cancel)
				setBalloonText: 'Cancel' bold, '  (discard input)';
				icon: Theme current cancelIcon).
	self addMorphUseAll: controlsContainer! !

!FileRequestMorph methodsFor: 'initialization' stamp: 'hlsf 7/26/2025 16:24:59'!
setQuery: queryString initialAnswer: initialAnswer
	| titleMorphExtent titleHeight titleWidth requiredLines lineWidth contentsWidth maxLineWidth extraWidth |
	response := initialAnswer.
	titleMorphExtent := self addTitle: queryString.
	titleWidth := 20 * FontFamily defaultPointSize max: titleMorphExtent x.
	titleHeight := titleMorphExtent y + FontFamily defaultLineSpacing. "Some extra room for borders, etc."
	self addTextPane.

	requiredLines := 0.
	"Single line preferred. For instance, for file names and paths."
	(response noneSatisfy: [ :each | each isSeparator ]) ifTrue: [
		maxLineWidth := Display width * 0.8.
		contentsWidth := FontFamily defaultFamilyAndPointSize widthOfString: response asString.
		contentsWidth < maxLineWidth ifTrue: [
			"Will fit in the screen. Ok."
			requiredLines := 1.
			extraWidth := (10 * FontFamily defaultPointSize). "Some extra room for edition plus accept/cancel buttons." ]].

	"May need to be multiple lines"
	requiredLines = 0 ifTrue: [
		maxLineWidth := Display width // 3.
		contentsWidth := 0.
		response linesDo: [ :eachLine |
			lineWidth := FontFamily defaultFamilyAndPointSize widthOfString: eachLine.
			contentsWidth := contentsWidth max: (lineWidth min: maxLineWidth).
			requiredLines := requiredLines + (lineWidth / maxLineWidth) ceiling ].
		extraWidth := (10 * FontFamily defaultPointSize). "Some extra room for edition plus accept/cancel buttons."
		requiredLines := requiredLines min: 20. "Use scrollbars if needed." 		].

	self morphExtent: ((titleWidth max: contentsWidth) + extraWidth)@(titleHeight + (FontFamily defaultLineSpacing * requiredLines)).! !

!FileRequestMorph methodsFor: 'accessing' stamp: 'hlsf 7/26/2025 16:28:25'!
response
	^ response asString
! !

!FileRequestMorph methodsFor: 'accessing' stamp: 'hlsf 7/26/2025 16:35:55'!
response: aText
	" Try to guess if user inputed an existing file or alternatively a directory, existing or not "
	response := aText asFileEntry exists
		ifTrue: [aText asFileEntry]
		ifFalse: [aText asDirectoryEntry]
	
! !

!FileRequestMorph methodsFor: 'accessing' stamp: 'hlsf 7/27/2025 10:53:50'!
toggleFileBrowser
	fileBrowser ifNotNil: [
		fileBrowser delete.
		fileBrowser := nil.
		^ self].
	fileBrowser := FileSelectorPane new	open: response asDirectoryEntry.! !

!FileSelectorPane methodsFor: 'initialization' stamp: 'hlsf 7/19/2025 13:26:16'!
initialize
	super initialize.
	self open: DirectoryEntry userBaseDirectory
	! !

!FileSelectorPane methodsFor: 'private' stamp: 'hlsf 7/25/2025 19:32:39'!
entryPreviewFor: fileEntry
	| fileView |
	fileView := FilePreviewMorph 
		object: fileEntry 
		image: ((fileEntry isFileEntry 
			ifTrue: [Theme current genericTextIcon] 
			ifFalse: [Theme current fetch: #( '16x16' 'places' 'folder' )]) magnifyTo: 48@48)
		buttons: nil
		label: fileEntry baseName ::
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

!FileSelectorPane methodsFor: 'accessing' stamp: 'hlsf 7/19/2025 12:40:15'!
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
	self cells: entryViews ! !

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
