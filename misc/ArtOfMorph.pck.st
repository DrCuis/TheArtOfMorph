'From Cuis7.5 [latest update: #7387] on 28 July 2025 at 11:54:23 pm'!
'Description '!
!provides: 'ArtOfMorph' 1 8!
!requires: 'UI-Widgets' 1 54 nil!
!requires: 'UI-Panel' 1 130 nil!
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

!FileRequestMorph methodsFor: 'events' stamp: 'hlsf 7/28/2025 23:49:31'!
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

!FileSelectorPane methodsFor: 'accessing' stamp: 'hlsf 7/27/2025 11:58:21'!
open: aDirectoryEntryorPreview
	| entryViews |
	model := aDirectoryEntryorPreview class = FilePreviewMorph 
		ifTrue: [aDirectoryEntryorPreview fileEntry]
		ifFalse: [aDirectoryEntryorPreview ].
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
