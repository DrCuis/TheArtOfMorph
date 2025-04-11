# The Art of Morph

Creating custom Moprhs in Cuis-Smalltalk

## 1. Overview

Cuis offers the possibility to easily design your own Morphs --
widgets you can interact with and later integrate in your GUI
application. There are two ways to design a custom Morph: as an
aggregate of existing Morphs or to design it from scratch.

Building a new Morph with an aggregate of existing Morphs is mainly
about laying out together Morphs and let the aggregated Morphs manage
the low level drawings and input event operations. When there is a
need for a custom Morph, this is the path to investigate first; if
there is no way to do so, then consider designing from scratch a Morph.

Designing from scratch a Morph requires to deal with its appearance
and the handling of the input events; for the former, Cuis offers a
vector graphics anti-aliased canvas, the latter is done with a mechanism
to filter and to handle mouse and keyboard events occurring in the
scope of the custom Morph.

## 2. Design a Morph by reuse

## 3. Design a Morph from scratch

It's easy to create custom morphs.
Just create a subclass of an existing morph class.
Then implement the `drawOn:` method or add and layout submorphs.

Here's an example that draws a circle.
Making it a subclass of `BoxMorphs` gives it an `extent` instance variable
which specifies its width and height.

```smalltalk
BoxMorph subclass: #CircleDemo
    instanceVariableNames: 'radius'
    classVariableNames: ''
    poolDictionaries: ''
    category: 'Demo'

"instance methods"

initialize
    | diameter |

    super initialize.
    diameter := 200.
    self morphExtent: diameter @ diameter.
    radius := diameter / 2.

"This is required in order to use the drawing instance methods, such as
 circleCenter:radius:, that are defined in the AbstractVectorCanvas class."
requiresVectorCanvas
    ^ true

drawOn: aCanvas
    aCanvas fillColor: Color purple do: [
        aCanvas
            circleCenter: radius @ radius
            radius: radius
    ].
```

To render this, open a Workspace and evaluate `CircleDemo new openInWorld`.

## 4. Event Handling

Let's explore how custom morphs can react to
mouse clicks, mouse hovers, and keystrokes.

Building on the previous example, here is a custom morph
whose color toggles between red and green each time it is clicked.

```smalltalk
BoxMorph subclass: #ClickDemo
    instanceVariableNames: 'color offColor onColor radius'
    classVariableNames: ''
    poolDictionaries: ''
    category: 'Demo'

"instance methods"

initialize
    | diameter |

    super initialize.
    offColor := `Color red`.
    onColor := `Color green`.
    color := offColor.

    diameter := 200.
    self morphExtent: diameter @ diameter.
    radius := diameter / 2.
    'Click the circle to toggle its color.' print.

requiresVectorCanvas
    ^ true "enables using drawing methods in drawOn: below"

drawOn: aCanvas
    aCanvas fillColor: color do: [
        aCanvas
            circleCenter: radius @ radius
            radius: radius
    ].

"This enables the morph to handle mouse events such as button presses."
handlesMouseDown: aMouseEvent
    ^ true

mouseButton1Down: aMouseEvent localPosition: aPosition
    color := color = offColor ifTrue: onColor ifFalse: offColor.
    "This informs the morph to redraw itself
     so changes to its state are reflected."
    self redrawNeeded.
```

To render this, open a Workspace and evaluate `ClickDemo new openInWorld`.
Click the circle several times to toggle its color.

Now let's create a similar custom morph that toggles its color
based on whether the mouse cursor is hovering over it.

```smalltalk
BoxMorph subclass: #HoverDemo
    instanceVariableNames: 'color offColor onColor radius'
    classVariableNames: ''
    poolDictionaries: ''
    category: 'Demo'

"instance methods"

initialize
    | diameter |

    super initialize.
    offColor := `Color red`.
    onColor := `Color green`.
    color := offColor.

    diameter := 200.
    self morphExtent: diameter @ diameter.
    radius := diameter / 2.
    'Hover over the circle to change its color and unhover to change it back.' print.

requiresVectorCanvas
    ^ true "enables using drawing methods in drawOn: below"

drawOn: aCanvas
    aCanvas fillColor: color do: [
        aCanvas
            circleCenter: radius @ radius
            radius: radius
    ].

"This enables the morph to handle mouse enter and leave events."
handlesMouseOver: aMouseEvent
    ^ true

mouseEnter: aMouseEvent
    color := onColor.
    self redrawNeeded.

mouseLeave: aMouseEvent
    color := offColor.
    self redrawNeeded.
```

To render this, open a Workspace and evaluate `HoverDemo new openInWorld`.
Hover onto and off of the circle to toggle its color.

One last event handling demo ... let's create a similar custom morph
that changes its color when a key is pressed.

```smalltalk
BoxMorph subclass: #KeyDemo
    instanceVariableNames: 'color radius'
    classVariableNames: ''
    poolDictionaries: ''
    category: 'Demo'

"instance methods"

initialize
    | diameter |

    super initialize.
    color := `Color yellow`.

    diameter := 200.
    self morphExtent: diameter @ diameter.
    radius := diameter / 2.
    'Move mouse over the circle and press r, g, or b to change its color.' print.

requiresVectorCanvas
    ^ true "enables listening for mouse enter events"

drawOn: aCanvas
    aCanvas fillColor: color do: [
        aCanvas
            circleCenter: radius @ radius
            radius: radius
    ].

handlesMouseOver: aMouseEvent
    ^ true

mouseEnter: event
    super mouseEnter: event.

    "If the user opted for focus to automatically
     move focus to the morph under the cursor then tell
     the cursor (event hand) to give focus to this morph."
    Preferences at: #focusFollowsMouse :: ifTrue: [
        event hand newKeyboardFocus: self
    ].

"This enables the morph to handle key events if it has focus."
handlesKeyboard
    ^ self visible

keyStroke: aKeyEvent
    | character |

    character := Character codePoint: aKeyEvent keyValue.
    color := character caseOf: {
        [ $r ] -> [ `Color red` ].
        [ $g ] -> [ `Color green` ].
        [ $b ] -> [ `Color blue` ].
    }.
    self redrawNeeded.
```

To render this, open a Workspace and evaluate `KeyDemo new openInWorld`.
Hover over the circle and press the keys r, g, and b to change its color.
