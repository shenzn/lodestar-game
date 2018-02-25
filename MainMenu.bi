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

declare sub MainMenu
declare sub OptMenu
declare sub CredMenu
declare sub StLogo
declare sub ReadOpt
Declare sub PlayMusic(stream as FSOUND_STREAM ptr)
declare sub Music_End(stream as FSOUND_STREAM ptr)
declare sub MusicLoad(stream as FSOUND_STREAM ptr,m_name as string)
declare sub InitMusic
declare sub Fmod_End()

'********************
sub MainMenu
  ReadOpt
  if setting_mus=1 then
     MusicLoad(m_fon,"sounds/mus_menu.ogg")
     PlayMusic(m_fon)
  endif

redim l2(320*480) as byte ptr
bload "img/l2.bmp",@l2(0)
redim st(87*31) as byte ptr
bload "img/start.bmp",@st(0)
redim opt(135*36) as byte ptr
bload "img/options.bmp",@opt(0)
redim crd(121*36) as byte ptr
bload "img/credits.bmp",@crd(0)
redim ext(63*29) as byte ptr
bload "img/exit.bmp",@ext(0)
redim bl(16*16) as byte ptr
bload "img/ball.bmp",@bl(0)
x=250:y=250

do while quit=0 
    cls
    bload "img/l1.bmp"
    put(320,0),@l2(0)
    put(270,250),@st(0),trans
    put(270,300),@opt(0),trans
    put(270,350),@crd(0),trans
    put(270,400),@ext(0),trans
    if multikey(72) then
        y-=50
    elseif multikey(80) then
        y+=50
    endif    
    if y>400 then
        y=400
    elseif y<250 then 
        y=250
    endif
    put(x,y+5),@bl(0),trans 

    if multikey(28) then
        if y=250 then
            Music_End(m_fon)
            exit sub
        elseif y=300 then
             OptMenu
             cls
             redim l2(320*480) as byte ptr
             bload "img/l2.bmp",@l2(0)
             redim st(87*31) as byte ptr
             bload "img/start.bmp",@st(0)
             redim opt(135*36) as byte ptr
             bload "img/options.bmp",@opt(0)
             redim crd(121*36) as byte ptr
             bload "img/credits.bmp",@crd(0)
             redim ext(63*29) as byte ptr
             bload "img/exit.bmp",@ext(0)
             redim bl(16*16) as byte ptr
             bload "img/ball.bmp",@bl(0)
             x=250:y=250
             bload "img/l1.bmp"
            put(320,0),@l2(0)
            put(270,250),@st(0),trans
            put(270,300),@opt(0),trans
            put(270,350),@crd(0),trans
            put(270,400),@ext(0),trans
         if multikey(72) then
            y-=50
         elseif multikey(80) then
            y+=50
         endif    
         if y>400 then
            y=400
         elseif y<250 then 
            y=250
         endif
         put(x,y+5),@bl(0),trans 
            flip

         elseif y=350 then
            CredMenu
            cls
redim l2(320*480) as byte ptr
bload "img/l2.bmp",@l2(0)
redim st(87*31) as byte ptr
bload "img/start.bmp",@st(0)
redim opt(135*36) as byte ptr
bload "img/options.bmp",@opt(0)
redim crd(121*36) as byte ptr
bload "img/credits.bmp",@crd(0)
redim ext(63*29) as byte ptr
bload "img/exit.bmp",@ext(0)
redim bl(16*16) as byte ptr
bload "img/ball.bmp",@bl(0)
x=250:y=250
bload "img/l1.bmp"
    put(320,0),@l2(0)
    put(270,250),@st(0),trans
    put(270,300),@opt(0),trans
    put(270,350),@crd(0),trans
    put(270,400),@ext(0),trans
    if multikey(72) then
        y-=50
    elseif multikey(80) then
        y+=50
    endif    
    if y>400 then
        y=400
    elseif y<250 then 
        y=250
    endif
    put(x,y+5),@bl(0),trans 

            flip
       elseif y=400 then
            Music_End(m_fon)    
            end
        endif 
    endif  
    
    screensync
    flip
    sleep
loop
end sub
'********************

'********************
sub OptMenu
    redim l2(320*480) as byte ptr
    bload "img/l2.bmp",@l2(0)
    redim bl(16*16) as byte ptr
    bload "img/ball.bmp",@bl(0)
    dim m1 as string
    dim m as string
    dim k1 as string
    dim k as string
    dim fs as string
    dim fs1 as string
    DIM buf_text AS STRING
    
f = FREEFILE
OPEN "options.dat" FOR input AS #f
    line input #f,buf_text
    if buf_text="0" then
        m1="OFF":m="ON"
    else    
        m1="ON":m="OFF"
    endif
    line input #f,buf_text
    if buf_text="0" then
        k1="Keyboard":k="Mouse"
    else    
        k="Keyboard":k1="Mouse"
    endif    
    line input #f,buf_text
    if buf_text="1" then
        fs1="YES":fs="NO"
    else    
        fs="YES":fs1="NO"
    endif    
close #f 
    q=0
    x=200:y=295
do while q=0
    cls
    if multikey(1) then exit sub
    bload "img/l1.bmp"
    put(320,0),@l2(0)
    put(x,y+5),@bl(0),trans 
    locate 20,30: print "Music:",m1
    locate 23,30: print "Controls:",k1
    locate 26,30: print "Fullscreen:",fs1
    locate 29,30: print "Save and Exit"
        
   screensync
   flip
   sleep
   
   if multikey(72) then
        y-=50
    elseif multikey(80) then
        y+=50
    endif    
    if y>445 then
        y=445
    elseif y<295 then 
        y=295
    endif
    if multikey(28) then
        if y=295 then 
            swap m1,m
        elseif y=345 then
            swap k1,k
        elseif y=395 then
            swap fs1,fs
        elseif y=445 then   
            if m1="OFF" then 
               setting_mus=0'*** 
                Music_End(m_fon)
                Fmod_End()
                m_fon=0
            else 
                setting_mus=1
                if m_fon=0 then MusicLoad(m_fon,"sounds/mus_menu.ogg")
                PlayMusic(m_fon)
            endif
            if k1="Keyboard" then
                setting_key=0
            else 
                setting_key=1
            endif
            if fs1="YES" then
                flscreen=1
            else 
                flscreen=0
            endif
            f = FREEFILE
            OPEN "options.dat" FOR output AS #f
            if m1="OFF" then
                m1="0" 
            else
                m1="1"
            endif
            if k1="Keyboard" then
                k1="0"
            else
                k1="1"
            end if
            if fs1="YES" then
                fs1="1" 
            else
                fs1="0"
            endif
            print  #f,m1
            print  #f,k1
            print  #f,fs1
            close #f
           
            exit sub
        endif 
    endif    
   loop
end sub
'********************

'********************
sub CredMenu
    cls
    redim l2(320*480) as byte ptr
    bload "img/l2.bmp",@l2(0)
    dim names(276*31) as byte ptr
    bload "img/name.bmp",@names(0)
    bload "img/l1.bmp"
    put(320,0),@l2(0)
    put(180,300),@names(0),trans
     
    screensync
    flip
    sleep
end sub   
'********************

'********************
sub StLogo
    flip
    screenset 0
color 0,rgb(255,255,255)
    cls
dim img(282*127) as byte ptr
bload "img/logo3.bmp",@img(0)
    setting_mus=1
    MusicLoad(m_fon,"sounds/mus_logo.ogg")
    PlayMusic(m_fon)
for x=0 to 100 
    put (180,140),@img(0),alpha,x
    sleep 50
next
color rgb(255,255,255),0
    screenset 1,0
    cls
    flip
    sleep 500
    Music_End(m_fon)
    setting_mus=0
end sub
'********************

'********************
sub ReadOpt
    dim m1 as string
    dim m as string
    dim k1 as string
    dim k as string
    DIM buf_text AS STRING
f = FREEFILE
OPEN "options.dat" FOR input AS #f
    line input #f,buf_text
    if buf_text="0" then
        m1="OFF":m="ON"
    else    
        m1="ON":m="OFF"
    endif
    line input #f,buf_text
    if buf_text="0" then
        k1="Keyboard":k="Mouse"
    else    
        k="Keyboard":k1="Mouse"
    endif    
close #f 
            if m1="OFF" then 
                setting_mus=0
            else 
                setting_mus=1
            endif
            if k1="Keyboard" then
                setting_key=0
            else 
                setting_key=1
            endif
end sub    
'********************

'********************
sub InitMusic
if setting_mus=1 then    
    if( FSOUND_Init( 44100, 32, 0 ) = 0 ) then 
      	print "Can't initialize FMOD" 
        sleep
      	end 1
   	end if 
   	FSOUND_Stream_SetBufferSize( 1 )
endif
end sub 
'********************

'********************
sub MusicLoad(stream as FSOUND_STREAM ptr,m_name as string)
if setting_mus=1 then
        InitMusic
        stream = FSOUND_Stream_Open( m_name, FSOUND_MPEGACCURATE, 0, 0 )
        
endif
end sub
'********************

'********************
sub PlayMusic(stream as FSOUND_STREAM ptr)
if setting_mus=1 then    
FSOUND_Stream_Play( FSOUND_FREE, stream )
endif
end sub
'********************

'********************
sub Music_End(stream as FSOUND_STREAM ptr)
if setting_mus=1 then
    FSOUND_Stream_Stop stream
    FSOUND_Stream_Close stream
'	FSOUND_Close 
endif
end sub 
'********************
sub Fmod_End()
    FSOUND_Close
    setting_mus=0
end sub    