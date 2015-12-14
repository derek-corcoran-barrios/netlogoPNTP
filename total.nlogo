;;hora del dia es ticks / ticks-to-an-hour mod 24
extensions [ gis ]


globals [ pathation aa bb cc dd]

;;orderW1 las carretas alas torres, orderW2 las torres a las carretas, orderPG Paine grande Grey
patches-own [ path orderW1 orderW2 orderPG orderPP excess atraction]


to load-gis
  set pathation gis:load-dataset "total.asc"
  gis:set-world-envelope-ds gis:envelope-of pathation
end

to get-paths
  ask patches [
    set path gis:raster-sample pathation self
  ]
end


breed [houses house]
breed [tourists tourist]
breed [nodes node]
tourists-own [age origin destination
  ticks-since-here w PG PP]
to setup
reset-ticks
set-default-shape tourists "person"
set-default-shape houses "house"

create-tourists random-normal num-tourists-W1 (num-tourists-W1 / 3.5 )


ask tourists [
  set size 8
  setxy -18 -170
  set origin 2
  set w 1
  set PG 0
  set PP 0
  set color red
   ;pen-down
  ]
create-tourists random-normal num-tourists-W2 (num-tourists-W2 / 3.5 )[ setxy 128 48 set w 2 set PG 0 set PP 0 set destination 3 set color blue set size 8]

create-tourists random-normal num-tourists-PG (num-tourists-PG / 3.5 )[ setxy -18 -170 set w 0 set PG 1 set PP 0 set destination 3 set color yellow set size 8]

create-tourists random-normal num-tourists-PP (num-tourists-PP / 3.5 )[ setxy 128 48 set w 0 set PG 0 set PP 1 set destination patch 115 32 set color cyan set size 8]

ask patches [set orderW1 0 set orderW2 0 set orderPG 0 set orderPP 0 set excess 0 set atraction 1]
ask patches with [ path > 0 ] [set pcolor white ]
ask patches with [ path >= 100 ] [set pcolor red sprout-houses 1 [set color red]]
ask patch -19 -170 [set pcolor red set orderW1 1 set orderW2 13 set orderPG 6]
ask patch -19 -160 [set plabel 1 set plabel-color black]
ask patch -15 -171 [set orderW1 2 set orderW2 0]
ask patch -15 -161 [set plabel 2 set plabel-color black]
ask patch -50 -80 [set orderW1 3 set orderW2 12 set orderPG 3]
ask patch -50 -70 [set plabel 3 set plabel-color black]
ask patch -115 4 [set orderW1 4 set orderW2 11 set orderPG 4]
ask patch -115 14 [set plabel 4 set plabel-color black]
ask patch -48 -78 [set pcolor red set orderW1 5 set orderW2 10 set orderPG 5]
ask patch -48 -68 [set plabel 5 set plabel-color black]
ask patch -11 -17 [set orderW1 6 set orderW2 9]
ask patch -11 -7 [set plabel 6 set plabel-color black]
ask patch -129 64 [set pcolor green]

ask patch -9 -17 [set pcolor green]
ask patch -11 -17 [set pcolor red]
ask patch -5 39 [set pcolor red set orderW1 7 set orderW2 8 set atraction 0.1]
ask patch -5 49 [set plabel 7 set plabel-color black]
ask patch -8 -25 [set pcolor red set orderW1 8 set orderW2 7]
ask patch -8 -15 [set plabel 8 set plabel-color black]
ask patch 22 -21 [set orderW1 9 set orderW2 6]
ask patch 22 -11 [set plabel 9 set plabel-color black]
ask patch 36 -22 [set orderW1 10 set orderW2 5]
ask patch 36 -12 [set plabel 10 set plabel-color black]
ask patch 98 58 [set pcolor green]
ask patch 96 57 [set pcolor red set orderW1 11 set orderW2 4 set orderPP 3]
ask patch 96 67 [set plabel 11 set plabel-color black]
ask patch 77 79 [set pcolor green]
ask patch 73 79 [set pcolor red set orderW1 12 set orderW2 3 set orderPP 2]
ask patch 73 89 [set plabel 12 set plabel-color black]
ask patch 115 32 [set pcolor red set orderW1 13 set orderW2 2 set orderPP 1 set atraction 0.1]
ask patch 115 33 [set pcolor red set orderW1 13 set orderW2 2 set orderPP 4 set atraction 0.1]
ask patch 115 42 [set plabel 13 set plabel-color black]
ask patch 129 54 [set pcolor red set orderW1 14 set orderW2 1 set orderPP 5]
ask patch 129 64 [set plabel 14 set plabel-color black]
;de aca en adelante es para dejarlo solo W
ask patch -76 94 [set pcolor green]
ask patch -30 159 [set pcolor green]
ask patch 114 171 [set pcolor green]
ask patch -129 60 [set pcolor green set orderW1 -1]

ask tourists with [w = 1] [ set destination one-of patches with
      [
        orderW1 = 3   ]
    ]

ask tourists with [w = 2] [ set destination one-of patches with
      [
        orderW2 =   3 ]
    ]

ask tourists with [PG = 1] [ set destination one-of patches with
      [
        orderPG =   3 ]
    ]


;ask tourists with [PP = 1] [ set destination one-of patches with
      ;[
        ;orderPP =   2 ]
    ;]

ask houses [
   set color orange
   set size 10
]

end


to go

 ask patches with [pcolor = green] [if  (((ticks / ticks-to-an-hour) mod 24) = sunset) [set pcolor black]]
 ask patches with [pcolor = black] [if (((ticks / ticks-to-an-hour) mod 24) = sunrise) [set pcolor green]]

 ask turtles-on patch 129 54 [die]
 ask turtles-on patch -19 -170 [die]
 ask tourists [
  set age (age + 1 )
  move

 ]
  ;create-tourists num-tourists


 ask patches with [pcolor = red]
  [
    if count turtles-here > (threshold * atraction) ;; If more than one turtle on a patch they will fight to the death
    [
      set excess (excess + 1)
    ]
  ]

  if (((ticks / ticks-to-an-hour) mod 24) > sunrise) and (((ticks / ticks-to-an-hour) mod 24) < sunset) and ticks mod ticks-to-an-hour = 0 [ create-tourists random-normal ( num-tourists-W1) ((num-tourists-W1) / 3.5 ) [set color red setxy -18 -170 set size 8 set w 1 set PG 0 set PP 0
  set destination one-of patches with
      [
        orderW1 = 2   ]
  ]
]
  if (((ticks / ticks-to-an-hour) mod 24) > sunrise) and (((ticks / ticks-to-an-hour) mod 24) < sunset) and ticks mod ticks-to-an-hour = 0 [ create-tourists random-normal (num-tourists-W2) ((num-tourists-W2) / 3.5 ) [set color blue setxy 128 48 set size 8 set w 2 set PG 0 set PP 0
  set destination one-of patches with
      [
        orderW2 = 2   ]
  ]
]

  if (((ticks / ticks-to-an-hour) mod 24) > sunrise) and (((ticks / ticks-to-an-hour) mod 24) < sunset) and ticks mod ticks-to-an-hour = 0 [ create-tourists random-normal (num-tourists-PG) ((num-tourists-PG) / 3.5 ) [set color yellow setxy -18 -170 set size 8 set w 0 set PG 1 set PP 0
  set destination one-of patches with
      [
        orderPG = 3   ]
  ]
]

    if (((ticks / ticks-to-an-hour) mod 24) > sunrise) and (((ticks / ticks-to-an-hour) mod 24) < sunset) and ticks mod ticks-to-an-hour = 0 [ create-tourists random-normal (num-tourists-PP) ((num-tourists-PP) / 3.5 ) [set color cyan setxy 128 48 set size 8 set w 0 set PG 0 set PP 1
  set destination patch 115 32
  ]
]

 tick
end

to-report ticks-to-stay-on-patch [p]
  if [pcolor] of p = red
    [
      report time-of-stay
    ]
end

to move
  ; Instructions to move the agents around the environment go here
  ; comparing patch standing on to dest, if at dest then  choose random new dest
  ; then more forward towards new dest
  ifelse ( patch-here = destination )
  [
    if ticks - ticks-since-here > ticks-to-stay-on-patch patch-here
    [
      if (((ticks / ticks-to-an-hour) mod 24) > sunrise) and (((ticks / ticks-to-an-hour) mod 24) < sunset) [set ticks-since-here 0]
      if (((ticks / ticks-to-an-hour) mod 24) > sunrise) and (((ticks / ticks-to-an-hour) mod 24) < sunset) [set origin orderW1]
      ask patch-here [set aa orderW1]
      ask patch-here [set bb orderW2]
      ask patch-here [set cc orderPG]
      ask patch-here [set dd orderPP]
      if w = 1 and (((ticks / ticks-to-an-hour) mod 24) > sunrise) and (((ticks / ticks-to-an-hour) mod 24) < sunset) [set destination one-of patches with
      [
        orderW1 = (aa + 1) ]];[set destination min-one-of (patches with [pcolor = red ]) [distance myself]]
      if w = 2 and (((ticks / ticks-to-an-hour) mod 24) > sunrise) and (((ticks / ticks-to-an-hour) mod 24) < sunset)[set destination one-of patches with
      [
        orderW2 = (bb + 1) ]];[set destination min-one-of (patches with [pcolor = red ]) [distance myself]]
      if PG = 1 and (((ticks / ticks-to-an-hour) mod 24) > sunrise) and (((ticks / ticks-to-an-hour) mod 24) < sunset)[set destination one-of patches with
      [
        orderPG = (cc + 1) ]];[set destination min-one-of (patches with [pcolor = red ]) [distance myself]]
      if PP = 1 and (((ticks / ticks-to-an-hour) mod 24) > sunrise) and (((ticks / ticks-to-an-hour) mod 24) < sunset)[set destination one-of patches with
      [
        orderPP = (dd + 1) ]];[set destination min-one-of (patches with [pcolor = red ]) [distance myself]]
  ]
  ]
  [ ifelse (((ticks / ticks-to-an-hour) mod 24) > (sunrise - 2)) and (((ticks / ticks-to-an-hour) mod 24) < (sunset + 2))[ face destination
    forward 1][set destination min-one-of (patches with [pcolor = red ]) [distance myself] face destination fd 1

    ]
    if ( patch-here = destination )
    [
      set ticks-since-here ticks
    ]
    while [pcolor = green or pcolor = black] [back 1 left 90 right (random 180) forward 1]
  ]

end
@#$#@#$#@
GRAPHICS-WINDOW
210
10
738
727
129
171
2.0
1
10
1
1
1
0
0
0
1
-129
129
-171
171
0
0
1
ticks
30.0

BUTTON
28
54
91
87
NIL
setup
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
112
53
175
86
NIL
go
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
29
107
92
140
NIL
go
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SLIDER
23
166
195
199
num-tourists-w1
num-tourists-w1
0
300
5
1
1
NIL
HORIZONTAL

BUTTON
22
11
96
44
NIL
load-gis
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
100
10
205
43
NIL
get-paths
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
108
108
182
141
NIL
clear-all
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SLIDER
24
373
196
406
time-of-stay
time-of-stay
0
180
37
1
1
NIL
HORIZONTAL

PLOT
776
476
1233
626
camp 10
NIL
NIL
0.0
10.0
0.0
10.0
true
true
"" ""
PENS
"Total" 1.0 0 -16777216 true "" "plot count tourists-on patch 36 -22"
"Glaciar" 1.0 0 -1184463 true "" "plot count (tourists-on patch 36 -22) with [color = yellow]"
"W Carr" 1.0 0 -2674135 true "" "plot count (tourists-on patch 36 -22) with [color = red]"
"W Paine" 1.0 0 -13345367 true "" "plot count (tourists-on patch 36 -22) with [color = blue]"
"Exceso" 1.0 0 -13840069 true "" "Plot  (([excess] of patch 36 -22)/ ticks-to-an-hour )"

SLIDER
23
250
200
283
num-tourists-PG
num-tourists-PG
0
100
10
1
1
NIL
HORIZONTAL

SLIDER
26
418
198
451
threshold
threshold
1
400
70
1
1
NIL
HORIZONTAL

SLIDER
27
467
199
500
ticks-to-an-hour
ticks-to-an-hour
38
100
50
1
1
NIL
HORIZONTAL

SLIDER
26
508
198
541
sunrise
sunrise
4
10
6
0.5
1
NIL
HORIZONTAL

SLIDER
22
554
194
587
sunset
sunset
16
24
18
0.5
1
NIL
HORIZONTAL

PLOT
776
12
1233
162
Turistas totales
NIL
NIL
0.0
10.0
0.0
10.0
true
true
"" ""
PENS
"Total" 1.0 0 -16777216 true "" "plot count tourists"
"Glaciar" 1.0 0 -1184463 true "" "plot count tourists with [color = yellow]"
"W Carr" 1.0 0 -2674135 true "" "plot count tourists with [color = red]"
"W Paine" 1.0 0 -13345367 true "" "plot count tourists with [color = blue]"
"Torres" 1.0 0 -11221820 true "" "plot count tourists with [color = cyan]"

SLIDER
25
207
197
240
num-tourists-w2
num-tourists-w2
0
100
5
1
1
NIL
HORIZONTAL

PLOT
779
166
1232
316
Camp 4
NIL
NIL
0.0
10.0
0.0
10.0
true
true
"" ""
PENS
"Total" 1.0 0 -16777216 true "" "plot count tourists-on patch -115 4"
"Glaciar" 1.0 0 -1184463 true "" "plot count (tourists-on patch -115 4) with [color = yellow]"
"W Car" 1.0 0 -2674135 true "" "plot count (tourists-on patch -115 4) with [color = red]"
"W Paine" 1.0 0 -13345367 true "" "plot count (tourists-on patch -115 4) with [color = blue]"
"Torres" 1.0 0 -11221820 true "" "plot count (tourists-on patch -115 4) with [color = cyan]"

PLOT
780
321
1232
471
Camp 7
NIL
NIL
0.0
10.0
0.0
10.0
true
true
"" ""
PENS
"Total" 1.0 0 -16777216 true "" "plot count tourists-on patch -5 39"
"Glaciar" 1.0 0 -1184463 true "" "plot count (tourists-on patch -5 39) with [color = yellow]"
"W Carr" 1.0 0 -2674135 true "" "plot count (tourists-on patch -5 39) with [color = red]"
"W Paine" 1.0 0 -13345367 true "" "plot count (tourists-on patch -5 39) with [color = blue]"
"Exceso" 1.0 0 -13840069 true "" "Plot  (([excess] of patch -5 39)/ ticks-to-an-hour )"

PLOT
779
639
1233
789
Camp 12
NIL
NIL
0.0
10.0
0.0
10.0
true
true
"" ""
PENS
"Total" 1.0 0 -16777216 true "" "plot count tourists-on patch 73 79"
"Glaciar" 1.0 0 -1184463 true "" "plot count (tourists-on patch 73 79) with [color = yellow]"
"W Carr" 1.0 0 -2674135 true "" "plot count (tourists-on patch 73 79) with [color = red]"
"W Paine" 1.0 0 -13345367 true "" "plot count (tourists-on patch 73 79) with [color = blue]"
"Torres" 1.0 0 -11221820 true "" "Plot count (tourists-on patch 73 79) with [color = cyan]"
"exceso" 1.0 0 -13840069 true "" "plot (([excess] of patch 73 79)/ ticks-to-an-hour )"

SLIDER
23
296
195
329
num-tourists-PP
num-tourists-PP
0
100
10
1
1
NIL
HORIZONTAL

@#$#@#$#@
## WHAT IS IT?

(a general understanding of what the model is trying to show or explain)

## HOW IT WORKS

(what rules the agents use to create the overall behavior of the model)

## HOW TO USE IT

(how to use the model, including a description of each of the items in the Interface tab)

## THINGS TO NOTICE

(suggested things for the user to notice while running the model)

## THINGS TO TRY

(suggested things for the user to try to do (move sliders, switches, etc.) with the model)

## EXTENDING THE MODEL

(suggested things to add or change in the Code tab to make the model more complicated, detailed, accurate, etc.)

## NETLOGO FEATURES

(interesting or unusual features of NetLogo that the model uses, particularly in the Code tab; or where workarounds were needed for missing features)

## RELATED MODELS

(models in the NetLogo Models Library and elsewhere which are of related interest)

## CREDITS AND REFERENCES

(a reference to the model's URL on the web if it has one, as well as any other necessary credits, citations, and links)
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270

@#$#@#$#@
NetLogo 5.2.1
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180

@#$#@#$#@
0
@#$#@#$#@
