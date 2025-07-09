'From Cuis7.3 [latest update: #7248] on 29 June 2025 at 11:09:27 pm'!
'Description '!
!provides: 'ArtOfMorph' 1 3!
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
