'******************************************************************************
'This game's source Lodestar
'**************************************
' website:  www.Lodestar-game.narod.ru
' mail:     lodestar@mail.com
' By:       Shendelyar Evgeniy, 2007 year
'**************************************
'This program is free software; you can redistribute it and/or modify it under
'the terms of the GNU General Public License as published by the Free Software
'Foundation; either version 2 of the License, or (at your option) any later 
'version.
'
'This program is distributed in the hope that it will be useful, but WITHOUT
'ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
'FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
'
'You should have received a copy of the GNU General Public License along with
'this program; if not, write to the Free Software Foundation, Inc., 59 Temple
'Place, Suite 330, Boston, MA 02111-1307 USA.

'******************************************************************************
'********Compiler FreeBasic version 0.16************************************** 
'******************************************************************************

dim flscreen as byte=0 
dim buf_text as string
dim f as integer
f = FREEFILE
OPEN "options.dat" FOR input AS #f
    line input #f,buf_text
    line input #f,buf_text
    line input #f,buf_text
if buf_text="1" then
    flscreen=1
else
    flscreen=0
endif
close #f
'**************************************
'//////////////////////////////////////
WINDOWTITLE "Lodestar"               '*
SCREEN 18, 24,2,flscreen             '*
SCREENSET 1, 0                       '*
randomize timer                      '* 
'//////////////////////////////////////

#include once "fmod.bi"
setmouse ,,0
dim shared setting_key as byte =0      '-***********-
dim shared setting_mus as byte =1
dim shared restart as byte=0
dim shared lb as short=240

dim shared lb_global as byte=3 

dim shared fps as integer
 
type ship_obj
    x as integer
    y as integer
    dy as integer
    dx as integer
    image as byte ptr
    l as integer
end type  

type paralax
  img as byte ptr
  x as integer
  y as integer
end type

dim shared img_mas1(20*20) as byte ptr
dim shared img_mas2(20*20) as byte ptr
dim shared img_mas3(20*20) as byte ptr
dim shared img_mas4(20*20) as byte ptr
dim shared img_mas1_2(20*20) as byte ptr
dim shared img_mas2_2(20*20) as byte ptr
dim shared img_mas3_2(20*20) as byte ptr
dim shared img_mas4_2(20*20) as byte ptr
bload "img/img1.bmp",@img_mas1(0)
bload "img/img2.bmp",@img_mas2(0)
bload "img/img3.bmp",@img_mas3(0)
bload "img/img4.bmp",@img_mas4(0)
bload "img/img1_2.bmp",@img_mas1_2(0)
bload "img/img2_2.bmp",@img_mas2_2(0)
bload "img/img3_2.bmp",@img_mas3_2(0)
bload "img/img4_2.bmp",@img_mas4_2(0)
dim shared size_paralax as ubyte=100
dim shared fon1(size_paralax) as paralax 
dim shared  fon2(size_paralax) as paralax
dim shared fon3(size_paralax) as paralax

dim shared xb,yb,xp1,yp1,xp2,yp2,x0,y0 as double


dim shared tb as ubyte=200
dim shared now_time,ob_time as double 
dim shared now_time_fps,ob_time_fps as double 
dim shared start as byte=1

dim shared test_s_ship as byte=5
dim shared s_ship as byte=-1
dim shared test as byte

dim shared dx,dy,creatship as double

dim shared s,s2s,xs,x2s,ys,y2s as short  
dim shared x_m,y_m,buttons as integer

dim shared osh1,osh2 as byte
dim shared scorost as byte=3 'scorost objectov(ship,asteroids)

dim shared m_fon as FSOUND_STREAM ptr
dim shared m_st as FSOUND_STREAM ptr
dim shared m_st2 as FSOUND_STREAM ptr

dim shared mus as string 
dim shared quit as byte
dim shared level as byte=1

'******************************
'***********level 2************
type pull
    x as integer
    y as integer
    dy as integer 
    image as byte ptr
end type 

type enem
    x as integer
    y as integer
    dy as integer
    dx as integer
    image as integer
    l as integer
end type    

dim shared s_pull as short
dim shared enem_pull as byte
dim shared t as double
dim shared score as short
'*****************************
'*********level 3*************
dim shared rotate as double
dim shared col_oskolkov as byte=1
dim shared inert as double 
'*****************************
'********Level 5**************
dim shared ob_time_ship as double
'*****************************

'$ include: 'MainMenu.bi' 

sleep 1000
StLogo
menu:MainMenu
rt:
lb_global=3
0:
option dynamic
REDIM shared ball(16 * 16) AS byte ptr
BLOAD "img/ball.bmp",@ball(0)

redim shared pl1(50*75+4) as byte ptr
bload "img/samalet.bmp",@pl1(0)

redim shared pl2(50*75+4) as byte ptr
bload "img/samalet2.bmp",@pl2(0)

redim shared prep(75*84) as byte ptr
bload "img/ship3.bmp",@prep(0)

redim shared prep2(48*62) as byte ptr
bload "img/stations.bmp",@prep2(0)

redim shared prep3(32*27) as byte ptr
bload "img/aster.bmp",@prep3(0)

redim shared prep4(27*27) as byte ptr
bload "img/vzruv.bmp",@prep4(0)

redim shared prep5(20*20) as byte ptr
bload "img/lives.bmp",@prep5(0)

redim shared prep6(20*20) as byte ptr
bload "img/time.bmp",@prep6(0)

redim shared load(170*26) as byte ptr
bload "img/load.bmp",@load(0)

redim shared load2(6*8) as byte ptr
bload "img/load2.bmp",@load2(0)

lb=240
tb=200


ob_time=101

score=0
start=1
restart=0
test_s_ship=5
s_ship=-1

xb=320:yb=100:dx=5:dy=5
yp1=240:xp1=10
xp2=590:yp2=240
scorost=6
level=1

redim shared obj(test_s_ship) as ship_obj
redim shared n_liv(2+2) as short    'sozdanie obj shuzni posle steroida 
redim shared p_let(4+2) as byte    'proverka shara po prymoy (tuda suda postoyno<>)
redim shared pull(0) as pull
redim shared enem(30+10) as enem
'*****************************
col_oskolkov=1



'******
#include "FreeFps.bi"
'$ include: 'FUNC_Game.bi'

INIT_DrawParalax(@fon1(0))
INIT_DrawParalax(@fon2(0))
INIT_DrawParalax(@fon3(0)) 
setfps( 70 )
'smooth_percent( 0 )

restart=0
'******////////////////////////////////********

'goto 2   'GO ON OTHER LEVEL

'*******************************************LEVEL 1

ReadPlot(0)
ReadPlot(level)

if setting_mus=1 then
MusicLoad(m_fon,"sounds/m_fon.ogg")
MusicLoad(m_st,"sounds/mus.ogg")
end if
now_time = TIMER
setfps( 80 )
'smooth_percent( 0 )

DrawGet(0)
'*********************
do while quit=0
  cls
  fbegin()
  screensync
  DrawText2
  if start=1 then
     TestTime
  endif
  DrawParalax(@fon1(0),1,1)
  DrawParalax(@fon2(0),2,1)
  DrawParalax(@fon3(0),3,1)
  DrawShip
  DrawLoad
  DrawGlobalObj
  Stolk_Ball_Players
  TestKey
  PlayMusic(m_fon)
  if lb<=0 then DrawGet(2)
  if restart=1 then
     goto rt
  elseif restart=3 then
     goto 0
  elseif restart=2 then
     Fmod_End() 
     goto menu
  endif
	fwait()
	flip
	fend()

loop
'*********************
if setting_mus=1 then
   Music_End(m_st)   
   Music_End(m_fon)
endif
'**********************************************************

1:
'*******************************************LEVEL 2

quit=0
redim shared pl1(27*40+10) as byte ptr
bload "img/samol.bmp",@pl1(0)

redim shared pl2(5*8+10) as byte ptr
bload "img/pull.bmp",@pl2(0)

redim shared ball(62*39+10) as byte ptr
bload "img/andr.bmp",@ball(0)

redim shared prep3(32*25+10) as byte ptr
bload "img/aster2.bmp",@prep3(0)

redim shared prep2(32*27+10) as byte ptr
bload "img/aster.bmp",@prep2(0)

redim shared prep(47*54+10) as byte ptr
bload "img/ship2.bmp",@prep(0)

redim shared prep6(5*7+10) as byte ptr
bload "img/pull2.bmp",@prep6(0)
redim prep5(0) as byte ptr

redim shared obj(test_s_ship+10) as ship_obj
redim shared pull(200+10) as pull

scorost=10
level=2
yp1=436:xp1=300
score+=lb
lb=240
fps=40
restart=0
nowl=0:dowloadlevel=1

ReadPlot(level)
if setting_mus=1 then 
    MusicLoad(m_fon,"sounds/m_fon2.ogg")
    MusicLoad(m_st,"sounds/boom.wav")  'vrezanue protivnikov i vzruv
endif
'*********************
do while quit=0
  cls
  fbegin()
  DrawParalax(@fon1(0),1,1)
  DrawParalax(@fon2(0),2,1)
  DrawParalax(@fon3(0),3,1)
  DrawGlobalObj
  DrawPull
  DrawShip
  TestLevel2UndeLevel
  TestPull
  Stolk_Ball_Players
  StolkPull
  DrawLoad
  DrawText2
  Testkey
  PlayMusic(m_fon)
  if lb<=0 then DrawGet(2)
  if restart=1 then
     goto rt
  elseif restart=3 then
     goto 1   
  elseif restart=2 then
     Fmod_End() 
     goto menu
  endif
  screensync
  fwait()
  flip
  fend()
loop
'**********************
if setting_mus=1 then
Music_End(m_st)
Music_End(m_fon)
endif
'************************************************************

2:
'*******************************************LEVEL 3
redim shared prep2(32*27) as byte ptr
bload "img/aster.bmp",@prep2(0)

redim shared prep3(32*25) as byte ptr
bload "img/aster2.bmp",@prep3(0)  

redim shared prep(21*45) as byte ptr
bload "img/oskolki.bmp",@prep(0)

redim shared prep6(20*20) as byte ptr
bload "img/time.bmp",@prep6(0)

'*Clean*
redim shared prep5(0) as byte ptr
redim shared pl1(0) as byte ptr
redim shared pl2(0) as byte ptr
redim shared pull(0) as pull
'********
test_s_ship=10
redim shared obj(test_s_ship) as ship_obj

tb=0   'On this level tb - colishestvo sobranuh oskolkov 
score+=lb
lb=240
scorost=0
level=3
xb=320:yb=240
fps=40:restart=0
col_oskolkov=0
'*************************
'$ include: 'FUNC_lev3.bi'
'************************
quit=0
ReadPlot(level)

if setting_mus=1 then
   MusicLoad(m_st,"sounds/boom.wav") 
   MusicLoad(m_st2,"sounds/mus.ogg")
   MusicLoad(m_fon,"sounds/m_fon3.ogg")
end if
'*********************
do while quit=0
  cls
  fbegin()
  xb+=1
  if tb=0  then
     InitLevel3
     if tb<=10 then DrawGet(0)
     if quit=1 then cls:exit do
  endif
    PlayMusic(m_fon)
    DrawParalax(@fon1(0),1,3)
    DrawParalax(@fon2(0),2,3)
    DrawParalax(@fon3(0),3,3)
    GlobalDraw
    DS_lev3
    DrawEnem(0)
    TestShip
    DrawLoad
    DrawText2
    Testkey
  if lb<=0 then DrawGet(2)
  if restart=1 then
     goto rt
  elseif restart=3 then
     goto 2 
  elseif restart=2 then
     Fmod_End() 
     goto menu
  endif
    screensync
    fwait()
    flip
    fend()
loop   
'*********************  
if setting_mus=1 then
Music_End(m_st)
Music_End(m_st2)
Music_End(m_fon)
endif
'******************************************************

3:
'*******************************************LEVEL 4
redim shared pl1(195*35) as byte ptr
bload "img/kosm.bmp",@pl1(0)

redim shared ball(21*45) as byte ptr
bload "img/oskolki.bmp",@ball(0)

redim shared pl2(21*45) as byte ptr
bload "img/oskolki2.bmp",@pl2(0)

redim shared prep6(20*20) as byte ptr
bload "img/time.bmp",@prep6(0)

redim shared prep4(27*27) as byte ptr
bload "img/vzruv.bmp",@prep4(0)

redim shared prep3(32*25) as byte ptr
bload "img/aster2.bmp",@prep3(0)

dim shared prep2(32*27) as byte ptr
bload "img/aster.bmp",@prep2(0)
'*Clean
redim shared prep(0) as byte ptr
redim shared prep5(0) as byte ptr
redim shared pull(0) as pull
'*******

test_s_ship=10
redim shared obj(test_s_ship) as ship_obj
scorost=8
score+=lb
lb=240:level=4
ob_time=0:yp1=446:xp1=600
xb=100:yb=0
dy=1:osh2=5      ' osh2 - kolyshestvo racet 
quit=0:rotate=0
fps=40
restart=0

ReadPlot(level)
if setting_mus=1 then
   MusicLoad(m_st2,"sounds/mus.ogg")
   MusicLoad(m_st,"sounds/boom.wav") 
   MusicLoad(m_fon,"sounds/m_fon4.ogg")
endif

DrawGet(0)
NewRocket
'*********************
do while quit=0
    cls
    fbegin()
    DrawParalax(@fon1(0),1,3)
    DrawParalax(@fon2(0),2,3)
    DrawParalax(@fon3(0),3,3)
    DrawGlobalObj 
    DS_lev4
    DrawLoad
    DrawText2
    TestShip
    TestKey
    StolkRocket
    PlayMusic(m_fon)
    if xp1<-195 or lb<=0 then DrawGet(2)
    if restart=1 then
       goto rt
    elseif restart=3 then
     goto 3   
    elseif restart=2 then
       Fmod_End() 
       goto menu
    endif
    screensync
    fwait()
    flip
    fend()
loop
'*********************
if setting_mus=1 then
Music_End(m_st)
Music_End(m_st2)  
Music_End(m_fon)
endif
'*********************************************************

4:
'*******************************************LEVEL 5
redim pl1(640*90) as byte ptr
bload "img/planets.bmp",@pl1(0)
redim ball(31*31) as byte ptr
bload "img/target.bmp",@ball(0)
redim shared prep2(60*61) as byte ptr
bload "img/andr2.bmp",@prep2(0)
redim shared prep3(32*27) as byte ptr
bload "img/aster.bmp",@prep3(0)
redim shared prep(20*66) as byte ptr
bload "img/racet.bmp",@prep(0)
redim shared prep5(48*62) as byte ptr
bload "img/stations.bmp",@prep5(0)
redim shared prep6(128*128) as byte ptr
bload "img/fac.bmp",@prep6(0)
'*********************
quit=0
level=5
score+=lb
lb=240
scorost=4
test_s_ship=15
lb=240:setting_key=1
redim shared obj(test_s_ship) as ship_obj
ob_time=40:xp1=0:yp1=0
fps=40:restart=0

ReadPlot(level)
if setting_mus=1 then
   MusicLoad(m_st2,"sounds/boom2.wav")
   MusicLoad(m_st,"sounds/boom.wav") 
   MusicLoad(m_fon,"sounds/m_fon5.ogg")
endif
DrawGet(0)
'*********************
do while quit=0
    cls
    fbegin()
  DrawParalax(@fon1(0),1,3)
  DrawParalax(@fon2(0),2,3)
  DrawParalax(@fon3(0),3,3)
  if xp1<640 then
     put(xp1,yp1),@prep5(0),trans
     xp1+=1
  endif    
  
  put(0,392),@pl1(0),trans
  DrawShip
  DrawGlobalObj
  DrawText2
  DrawLoad
  TestShip
  TestKey
  PlayMusic(m_fon)
  if lb<=0 then DrawGet(2)
  if restart=1 then
     goto rt
  elseif restart=3 then
     goto 4    
  elseif restart=2 then
     Fmod_End() 
     goto menu
  endif
  screensync
  fwait()
  flip
  fend()
loop
'*********************
if setting_mus=1 then
Music_End(m_st)
Music_End(m_st2)  
endif
'*********************
'****Finish LOGO****
'********************
5:cls
redim shared prep(320*138) as byte ptr  
bload "img/we_victory.bmp",@prep(0)
redim shared prep2(129*33) as byte ptr
bload "img/img_end.bmp",@prep2(0)

 DrawParalax(@fon1(0),1,3)
 DrawParalax(@fon2(0),2,3)
 DrawParalax(@fon3(0),3,3)
 put (150,50),@prep(0),trans
 put (250,250),@prep2(0),trans
 flip
 sleep
 sleep
 f = FREEFILE
 OPEN "score.dat" FOR append AS #f
 PRINT #f, DATE
 print #f,score
 print #f,"***"
'************************************************************************
'************************************************************************  