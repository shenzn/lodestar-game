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

'ALL FUNCTION
'***************************************
declare sub Vush_dx 
'declare function DrawParalax(vid as byte)
declare function DrawLoad
declare sub INIT_DrawParalax(img as paralax ptr)
declare sub DrawParalax(img as paralax ptr,speed as ubyte,vid as ubyte)
Declare function TestTime
Declare function TestKey
Declare function DrawGet(p as byte)
declare function Stolk_Ball_Players
declare function NewShip
declare function DrawShip
declare function TestShip
declare function DrawText2
declare function DrawGlobalObj
declare function DrawStrelki(x as short,y as short,icon as short,frame as single)
declare function RectCollision (x11 as integer,y11 as integer,w1 as integer,h1 as integer,x21 as integer,y21 as integer,w2 as integer,h2 as integer,p as integer,c as integer)
declare function PixelCollide(byval img1 as integer ptr,byval x1 as integer,byval y1 as integer,byval w1 as integer,byval h1 as integer,byval img2 as integer ptr,byval x2 as integer,byval y2 as integer,byval w2 as integer,byval h2 as integer) as byte

declare function QuestionPlayer(v as byte)
declare sub StolkRocket
declare sub NewRocket
declare sub DS_lev4
declare sub DS_lev3
declare sub ReadPlot(lev as byte)



'$ include: 'FUNC_lev2.bi'
'***************************************

'*******************************
sub Vush_dx 
    
    if xb<60 then
    
    temp=yb-yp1
    if temp<20 then dy+=5
    if temp>20 and temp<35 then dy+=3
    if temp>35 and temp<45 then dy=0
    if temp>45 and temp<60 then dy+=3
    if temp>60 and temp<80 then dy+=5
    xb+=5
    p_let(0)=dx:p_let(1)=dy
elseif xb>500 then
        temp=yb-yp2
    if temp<20 then dy-=5
    if temp>20 and temp<35 then dy-=3
    if temp>35 and temp<45 then dy=0
    if temp>45 and temp<60 then dy+=3
    if temp>60 and temp<80 then dy+=5
    xb-=5
    p_let(0)=dx:p_let(1)=dy
    endif
   
   if ((p_let(0)=3 and p_let(1)=0)) or ((p_let(0)=-3 and p_let(1)=0)) then
      p_let(2)+=1 
   endif  
   if p_let(2)>=3 then  
    if xb<60 then
        
        dy+=1
        p_let(2)=0
    elseif xb>500 then
        
        dy+=1
        p_let(2)=0
    endif    
   endif
 if xb<60 then dx=5
 if xb>500 then dx=-5   
end sub  
'*******************************

'*******************************
sub INIT_DrawParalax(img as paralax ptr)
 for i=0 to size_paralax
    with img[i]
        img_rand=int(rnd(1)*6)
        .img=img_rand
        .x=int(rnd(1)*640)
        .y=int(rnd(1)*480)
        for j=0 to size_paralax
           with img[j]
             if ((img[i].x<>img[j].x) or (img[i].y<>img[j].y)) and RectCollision(img[i].x,img[i].y,20,20,.x,.y,20,20,0,0) then .img=0
           end with
        next j    
     
     end with 
next i

end sub
'******************************************************************
sub DrawParalax(img as paralax ptr,speed as ubyte, vid as ubyte)
 for i=0 to size_paralax
    with img[i]
      if .img<>0 then 
        if .img=1 then
            if speed=1 then 
            put(.x,.y),@img_mas1_2(0),alpha,76
            elseif speed=2 then 
            put(.x,.y),@img_mas1(0),alpha,96
            else
            put(.x,.y),@img_mas1(0),trans
            endif
        elseif .img=2 then
            if speed=1 then 
            put(.x,.y),@img_mas2_2(0),alpha,76
            elseif speed=2 then 
            put(.x,.y),@img_mas2(0),alpha,96
            else
            put(.x,.y),@img_mas2(0),trans
            endif
        elseif .img=3 then
            if speed=1 then 
            put(.x,.y),@img_mas3_2(0),alpha,76
            elseif speed=2 then 
            put(.x,.y),@img_mas3(0),alpha,96
            else
            put(.x,.y),@img_mas3(0),trans
            endif
        elseif .img=4 then    
            if speed=1 then 
            put(.x,.y),@img_mas4_2(0),alpha,76
            elseif speed=2 then 
            put(.x,.y),@img_mas4(0),alpha,96
            else
            put(.x,.y),@img_mas4(0),trans
            endif
        else 
            pset(.x,.y),rgb(112,135,184)
        endif    
      endif
      
    if vid=1 then
        .y+=speed    'down
        if .y>480 then 
            .y=-30:.x=int(rnd(1)*640)
            img_rand=int(rnd(1)*6)
            .img=img_rand
            for j=0 to size_paralax
               with img[j]
                if ((img[i].x<>img[j].x) or (img[i].y<>img[j].y)) and RectCollision(img[i].x,img[i].y,20,20,.x,.y,20,20,0,0) then .img=0
               end with
            next j  
        endif
    elseif vid=2 then
        .y-=speed    'up
        if .y<-10 then 
            .y=510:.x=int(rnd(1)*640)
            img_rand=int(rnd(1)*6)
            .img=img_rand
            for j=0 to size_paralax
               with img[j]
                if ((img[i].x<>img[j].x) or (img[i].y<>img[j].y)) and RectCollision(img[i].x,img[i].y,20,20,.x,.y,20,20,0,0) then .img=0
            end with
            next j  
        endif
    elseif vid=3 then
        .x+=speed    'left
        if .x>640 then 
            .x=-30:.y=int(rnd(1)*480)
            img_rand=int(rnd(1)*6)
            .img=img_rand
            for j=0 to size_paralax
              with img[j]
                if ((img[i].x<>img[j].x) or (img[i].y<>img[j].y)) and RectCollision(img[i].x,img[i].y,20,20,.x,.y,20,20,0,0) then .img=0
              end with
            next j  
        endif
    elseif vid=4 then
        .x-=speed    'right
        if .x<-10 then 
            .x=670:.y=int(rnd(1)*480)
            img_rand=int(rnd(1)*6)
            .img=img_rand
            for j=0 to size_paralax
               with img[j]
                if ((img[i].x<>img[j].x) or (img[i].y<>img[j].y)) and RectCollision(img[i].x,img[i].y,20,20,.x,.y,20,20,0,0) then .img=0
               end with
            next j    
         endif
        endif
   
    end with
next i

end sub
'*******************************

'*******************************
function NewShip
   s_ship+=1
if level<>3 and level<>4 then
    with obj(s_ship)
        .x=int(rnd(1)*440)+100
        .y=-20
        if level<>5 then
            .dy=int(rnd(1)*scorost)+1
        else
            .dy=int(rnd(1)*(scorost-2))+3
        endif    
        creatimage=int(rnd(1)*4)
      if creatimage=1 then
        .image=1   
      elseif creatimage=2 then
        .image=2
      elseif creatimage=3 then
        .image=3
      endif    
        .l=1
     if n_liv(0)=1 then
            .x=n_liv(1)
            .y=n_liv(2)
            if s_ship<3 then
            .dy=int(rnd(1)*1)+1
        else
            .dy=int(rnd(1)*1)+1
        endif
            if s_ship>=3 then
            .dx=int(rnd(1)*2)
        else
            .dx=int(rnd(1)*2)
        endif 
        if .dx=0 then
            .dx=-1
        elseif .dy=0 then
            .dy=-1
        endif    
           .l=1
           live_or_time=int(rnd(1)*10)+1
           if live_or_time mod 2=0 then
           .image=6
           else 
           .image=7
           endif
endif    
end with

elseif level=3 then
    with obj(s_ship)
        .x=int(rnd(1)*600)
        .y=int(rnd(1)*400)
     
        if .x>200 and .x<480 and .y>200 and .y<340 then
            .x-=100:.y+=200
        endif    
        .dx=0'int(rnd(1)*scorost)+1
        .dy=0'int(rnd(1)*scorost)+1
          creatimage=int(rnd(1)*4)
        if creatimage=2 or creatimage=3  then 
        .image=2
        else  
        .image=3
        endif
        .l=1
    end with
    
elseif level=4 then
    with obj(s_ship)
        .y=int(rnd(1)*351)+50
        .x=-20
        .dx=int(rnd(1)*scorost)+1
           creatimage=int(rnd(1)*4)
            if creatimage=2 then
              .image=2
            else 
              .image=3
            endif    
        .l=1
     end with   
endif
    
end function
'*******************************

'*******************************
function DrawShip
    
    if s_ship>-1 then
        for i=0 to s_ship
            with obj(i)
                .y+=.dy
                if (level<>3 or level<>5) and (.y>480  or .image=5) and not(.image=6 or .image=7) then .l=0:.image=0
                if (.x<0 or .x>640) and (.image=6 or .image=7) then .l=0:.image=0
               
               if .l>0 then
                    if .image=1 then
                      put(.x,.y),@prep(0),trans
                    elseif .image=2 then
                      put(.x,.y),@prep2(0),trans
                    elseif .image=3 then
                      put(.x,.y),@prep3(0),trans
                    elseif .image=4 then
                      put(.x,.y),@prep4(0),trans
                      .image=5
                    elseif .image=6 then
                        .x+=.dx 
                        if .y>480 or .y<0 then .dy=-.dy
                      put(.x,.y),@prep5(0),trans 
                      
                    elseif .image=7 then
                          .x+=.dx 
                        if .y>480 or .y<0 then .dy=-.dy
                      put(.x,.y),@prep6(0),trans 
                    endif  
                endif
                '******
                
            if level=1 or level=2  then
                if .image=1 then 
               
                 if PixelCollide(@prep(0),.x,.y,75,84,@ball(0),xb,yb,16,16) then
                  if dx>0 then
                    xb-=4 
               else 
                    xb+=4
               endif
                  dy=dy/2 
                   dx=-dx
                   if level<>2 then lb-=1
                  
                
                endif
                if level=2 then 
                   if RectCollision(.x,.y,47,54,xp1,yp1,27,40,0,0) then
                         .image=4
                         lb-=30
                         score-=20
                         PlayMusic(m_st)
                   endif
                endif      
            elseif .image=2 then
              
              if PixelCollide(@prep2(0),.x,.y,48,62,@ball(0),xb,yb,16,16) then
               
               if dx>0 then
                    xb-=4 
               else 
                    xb+=4
               endif
                   dy=dy/2
                   dx=-dx
                   lb-=1
               
                endif
                if level=2 then 
                   if RectCollision(.x,.y,32,27,xp1,yp1,27,40,0,0) then
                         .image=4
                         lb-=30
                         score-=20
                         PlayMusic(m_st)
                   endif
                endif      
           elseif .image=3 then
               if RectCollision(.x,.y,32,27,xb,yb,16,16,0,0) and level=1  then
                   dy=dy/2
                   dx=-dx
                   .image=4
                  n_liv(0)=1
                  n_liv(1)=.x
                  n_liv(2)=.y
                  score+=30
             if s_ship<5 and TestShip then 
                 NewShip
             endif
             n_liv(0)=0:n_liv(1)=0:n_liv(2)=0
                endif
                if level=2 then 
                   if RectCollision(.x,.y,32,25,xp1,yp1,27,40,0,0) then
                         .image=4
                         lb-=30
                         score-=20
                         PlayMusic(m_st)
                   endif
                endif      
          elseif .image=6 then       
              
              if RectCollision(.x,.y,20,20,xp1,yp1,48,75,0,0) then
                    if lb<240 then lb+=30
                    .l=0:.image=0
                    PlayMusic(m_st)
              endif
              if RectCollision(.x,.y,20,20,xp2,yp2,48,75,0,0) then
                    if lb<240 then lb+=30
                    .l=0:.image=0
                    PlayMusic(m_st)
              endif
          elseif .image=7 then  
                  if RectCollision(.x,.y,20,20,xp1,yp1,48,75,0,0) then
                    ob_time-=30
                    .l=0:.image=0
                    lb+=20
                    PlayMusic(m_st)
                  endif
                  if RectCollision(.x,.y,20,20,xp2,yp2,48,75,0,0) then
                    ob_time-=30
                    .l=0:.image=0
                    PlayMusic(m_st)
                  endif
               endif
              elseif level=5 then
                     if .y>460 and .image<>0 then
                         'beep
                         .y=-10:.x=-10
                        .image=0:.l=0
                        lb-=30
                    endif
                if inert>0 and inert<=5 then
                  if .image=1 then
                     if RectCollision(.x,.y,20,60,xb+14,yb+14,4,4,0,0) then
                        .image=4
                        score+=50
                        PlayMusic(m_st)
                     endif
                  elseif .image=2 then 
                     if RectCollision(.x,.y,60,61,xb+14,yb+14,4,4,0,0) then
                        .image=4
                        score+=50
                        PlayMusic(m_st)
                     endif
                  elseif .image=3 then 
                     if RectCollision(.x,.y,32,27,xb+14,yb+14,4,4,0,0) then
                        .image=4
                        score+=50
                        PlayMusic(m_st)
                     endif
                  endif
                  endif
                
            endif
        end with  
                                    
    next i
endif
    
end function
'*******************************

'*******************************
sub DS_lev4
if s_ship>-1 then
        for i=0 to s_ship
            with obj(i)
                if level=4 then .x+=.dx '************ bulo level=3
                if level=4 and (.x>640 or .image=5) then .l=0:.image=0 
                if .l>0 then
                    if .image=2 then
                      put(.x,.y),@prep2(0),trans
                    elseif .image=3 then
                      put(.x,.y),@prep3(0),trans
                    endif  
                endif
                if .l=1 and PixelCollide(@prep2(0),.x,.y,32,27,@ball(0),xb,yb,21,45) then
                   .l=0:.image=0
                   lb-=50
                   put(xb,yb),@prep4(0),trans
                   PlayMusic(m_st)
                   now_time=timer
                   DO
                   LOOP UNTIL TIMER > (now_time + .1)
                   fps=31
                   NewRocket
                endif
                      
            end with
        next i
        endif
end sub
'*******************************

'*******************************
sub DS_lev3
    if s_ship>-1 then
        for i=0 to s_ship
            with obj(i)
               
                if .l>0 then
                    if .image=2 then
                      put(.x,.y),@prep2(0),trans
                    elseif .image=3 then
                      put(.x,.y),@prep3(0),trans
                    elseif .image=4 then
                      put(.x,.y),@prep4(0),trans
                      .image=5
                    endif  
                endif
                
                if .image<>5 then
                  if PixelCollide(@prep2(0),.x,.y,32,27,@ball(0),xb,yb,50,50) then
                    lb-=30
                    .image=4
                    PlayMusic(m_st)
                  endif
                endif
            end with
        next i
    endif
     
end sub  
'*******************************

'*******************************
function TestShip
  test=0
  if s_ship>-1 then
        for i=0 to s_ship
            with obj(i)
                if .l>0 then test+=1
            end with    
        next i
   endif
if test=0 and s_ship=test_s_ship then
   s_ship=-1
   return 1
  
elseif test>-2 and s_ship<test_s_ship then
    return 1
elseif test<>0 and ship<=test_s_ship then
    return 0
else 
  return 0
endif
end function  
'*******************************

'*******************************
function DrawLoad
   if lb>240 then lb=240
   put(0,0),@load(0),trans
   l=int(lb/10)
   x=13:y=11
   for i=1 to l
       put(x,y),@load2(0),pset
       x+=6
   next i
end function   
'*******************************

'*******************************
function TestTime
    
if level=1 then
    t1=timer    
    if t1 > (now_time) then
    ob_time=ob_time-(t1-now_time)
    now_time=timer
    endif
    if ob_time<=0 and lb>0 then ob_time=0: DrawGet(1):quit=1  
    
elseif level=4 then
    
    if timer>ob_time then 
        ob_time=timer+.1:xp1-=1
        creatship=int(rnd(1)*10)+1
        if creatship=4 and s_ship<test_s_ship and TestShip then 
          NewShip
        endif  
     endif
     
elseif level=5 then
t1=timer    
    if t1 > (now_time) then
    ob_time=ob_time-(t1-now_time)
    now_time=timer
    endif
    if ob_time<=0 then 
        ob_time+=20:scorost+=1 
        creatship=int(rnd(1)*5)+1
        if creatship=4 and xp1>620 then 
             yp1=int(rnd(1)*351)+50
             xp1=-20
        endif 
        if scorost>10 then
            if setting_mus=1 then
            FSOUND_Stream_Close(m_fon)
            endif
            sleep 100
            PlayMusic(m_st2)
            put(100,50),@prep6(0),trans
            flip
            PlayMusic(m_st)
            tm=timer
            do until timer>(tm+3)
            loop    
            DrawGet(1)
            quit=1
        endif 
    endif    
if timer>ob_time_ship then 
        ob_time_ship=timer+.1:xp1-=1
        creatship=int(rnd(1)*5)+1
        if creatship=4 and s_ship<test_s_ship and TestShip then 
          NewShip
        endif  
     endif
endif    
end function
'*******************************

'*******************************
function TestKey
    if multikey(1) then questionplayer(2) 
    if multikey(25) then
      locate 28,35
      print "Press SPACE!"
      flip
      'sleep
      'QuestionPlayer(3)
      nw_time=timer
      'sleep
      do while q=0 
        if level=1 then
           t12=timer    
           if t12 > (nw_time) then
           ob_time=ob_time+1'(t12-nw_time)
           nw_time=timer
           endif  
         endif
         if multikey(57) then q=1
         ' k$=inkey$
          'if k$<>"" then q=1 
           'sleep
      loop
     timer_fps_change=timer
    endif  
    
if level=1 then
      
    if setting_key=0 then
    if multikey(72) then yp2+=4:yp1-=4 'key=up
    if multikey(80) then yp2-=4:yp1+=4 'key=down
  else
      
    getmouse x_m,y_m,,buttons  
    if y_m=240 then yp1=x_m:yp2=x_m
    yp1=y_m
    prom=240 - y_m
    yp2=480-y_m
  endif
  
elseif level=2 then
   
  if setting_key=0 then
    if multikey(75) then xp1-=6 
    if multikey(77) then xp1+=6 
    if PKey(57) and TestPull then 
        NewPull(xp1,yp1,1)
           creatship=int(rnd(1)*4)+1
           if (creatship=4 or creatship=2) and s_ship<5 and TestShip then
           NewShip
           endif
           endif
  else 
      
   getmouse x_m,y_m,,buttons
   if buttons=1 and PKey(1) and TestPull then
      NewPull(xp1,yp1,1)
      creatship=int(rnd(1)*4)+1
      if (creatship=4 or creatship=2) and s_ship<5 and TestShip then
           NewShip
      endif
   endif
      
    xp1=x_m
    if xp1>610 then xp1=610
  endif

elseif level=3 then
    
   if setting_key=0 then
        if multikey(75) then rotate-=10 
        if multikey(77) then rotate+=10
   else
        getmouse x_m,y_m,,buttons
        if buttons=1 then rotate-=10
        if buttons=2 then rotate+=10
   endif 
   
elseif level=4 then
    
  if multikey(57) and rotate>0 then
        inert+=.2:osh1=1:rotate-=.2:s_pull+=1
  end if                                                  'osh1 vustupaet v roly
  if not multikey(57) or rotate<=0 then inert-=.1:osh1=0  'indikatora goreniy i ne
                                                           'goreniy ogny u raketky   
 if setting_key=0 then
    if multikey(75) then xb-=2                  
    if multikey(77) then xb+=2
 else
    getmouse x_m,y_m,,buttons
    if buttons=1 then xb-=2
    if buttons=2 then xb+=2
 endif
 
elseif level=5 then
    getmouse x_m,y_m,,buttons
    xb=x_m:yb=y_m
    if buttons=1 then inert+=.1
    if buttons<>1 then inert=0
    if inert>6 then inert=6
endif  
end function
'*******************************

'*******************************
function DrawGet(p as byte)
 if p=2 then lb_global-=1
if p=2 and lb_global>0 then
     questionplayer(1)
     exit function
  endif 
  dim vrem(139*36) as byte ptr
  dim f as single
  
if p=0 then
     bload "img/get_r.bmp",@vrem(0)
elseif p=1 then
    bload "img/ok_d.bmp",@vrem(0)
elseif p=2 then
    if lb_global<=0 then
    bload "img/g_o.bmp",@vrem(0)
    endif
endif

  
  
  dim wrem as double
  dim icon as short

   if setting_key=0 then
          icon=2
      else    
          icon=1
      endif
  wrem=timer
  '*******
  do until timer>(wrem+3.00)
      fbegin()
      'zashita blokov ot uxoda za akran
      if yp1<0 then yp1=0  
      if level<>2 and level<>4 and yp1>400 then yp1=400
      if yp2<0 then yp2=0
      if yp2>400 then yp2=400
      
      f+=.1
      if f>3 then f=-1
      cls
      if level=3 or level=4 or level=5 then
         DrawParalax(@fon1(0),1,3)
         DrawParalax(@fon2(0),2,3)
         DrawParalax(@fon3(0),3,3)
      else
          DrawParalax(@fon1(0),1,1)
          DrawParalax(@fon2(0),2,1)
          DrawParalax(@fon3(0),3,1)
      endif 
      if level=5 then put(0,392),@pl1(0),trans
      if p=1  then
      put (300,140),@vrem(0),trans
      xb=320:yb=240
      else
      put (250,140),@vrem(0),trans
      endif
      if level<>2 then TestKey
      DrawText2
      DrawLoad
      if level<>4 and level<>5 then DrawGlobalObj
      if p=0 then DrawStrelki(320,180,icon,f)
      screensync
      fwait()
      flip
      fend()
  loop
  timer_fps_change=timer
  '**************
   if level=2 then
       for i=0 to 200 
       with pull(i)
           .image=0
       end with
       next
   endif
   if p=2 then
     questionplayer(1)
   endif
end function
'*******************************

'*******************************
function Stolk_Ball_Players
    
if level=1 then
   creatship=int(rnd(1)*50)+1
   if creatship=25 and s_ship<5 and TestShip then 
    NewShip
   endif
xb+=dx:yb+=dy
if yb>460  then yb-=5:dy=-dy
if yb<10  then yb+=5:dy=-dy
if dy<-6 or dy>6 then dy=dy/2
if xb<15 then 
    osh2+=1
    lb-=40
    xb=320:yb=240
    dx=5:dy=3
    if dx=0 then dx=1
    if dy=0 then dy=1
    if lb>0 then
    DrawGet(0)
   
    endif
elseif xb>625 then 
    osh1+=1
    xb=320:yb=240
    lb-=40
    dx=-5:dy=-3
    if dx=0 then dx=1
    if dy=0 then dy=1
    if lb>0 then
    DrawGet(0)
  
    endif
endif
'player1    
if RectCollision(xp1,yp1,48,75,xb,yb,16,16,0,0) then
   score+=10
   dx=-dx
  Vush_dx
endif    

'player2
if RectCollision(xp2,yp2,48,75,xb,yb,16,16,0,0) then 
    score+=10
   dx=-dx
  Vush_dx
endif  
 

if yp1<0 then yp1=0  
if yp1>400 then yp1=400
if yp2<0 then yp2=0
if yp2>400 then yp2=400

elseif level=2 then
    if xp1<=0 then xp1=1
    if xp1>=610 then xp1=610
endif  

end function
'*******************************

'*******************************
function DrawText2
   fps=fps_sub()
   locate 1,70:print "FPS:";fps
if level=1 then
locate 1,40:print "Time:";ob_time
locate 1,55:print "Score:";score

elseif level=2 or level=3 then
    locate 1,55
    print "Score:";score
    
elseif level=4 then
    locate 1,58:print "Score:";score
  '  locate 1,40:print "Fuel:";rotate
    locate 1,30:print "Rocket:";osh2  '***s_pull prumenyetsy kak shetshik v otobrashenii fuel
    line (340,5)-(340+rotate,10),rgb(255-rotate,100+rotate,0),bf
    line (340,5)-(440,10),134,b
    
elseif level=5 then    
    locate 1,55:print "Score:";score
    line (240,5)-(240+(inert*5),10),rgb(100+(inert*10),0,0),bf
    line (240,5)-(270,10),134,b
endif

end function 
'*******************************
        
'*******************************        
function DrawGlobalObj
if level=1 then  
    put(xb,yb),@ball(0),trans
    put(xp2,yp2),@pl2(0),trans
    put(xp1,yp1),@pl1(0),trans
    
elseif level=2 then
    put(xp1,yp1),@pl1(0),trans
    
elseif level=4 then
    put (xp1,yp1),@pl1(0),trans
    TestTime
     if osh1=0 then
      put(xb,yb),@ball(0),trans
     else 
      put(xb,yb),@pl2(0),trans
     endif
    yb+=(dy-inert)
    
elseif level=5 then
   put(xb,yb),@ball(0),trans
   TestTime
endif

end function
'*******************************

'*******************************
function DrawStrelki(x as short,y as short,icon as short,frame as single)
    dim str1(43*43) as byte ptr
    dim str2(32*32) as byte ptr
    
    if icon=1 then
        bload "img/mouse.bmp",@str2(0)
    elseif icon=2 then
        bload "img/key.bmp",@str2(0)
    endif 
    
if level=1 then
    
    if frame<1 then
        bload "img/strelki.bmp",@str1(0)
    elseif frame>1 and frame <2 then   
        bload "img/strelki_2.bmp",@str1(0)
    elseif frame>2 then
        bload "img/strelki_3.bmp",@str1(0)
    endif
    
else 
    
    if frame<1 then
        bload "img/strelki(2).bmp",@str1(0)
    elseif frame>1 and frame <2 then   
        bload "img/strelki_2(2).bmp",@str1(0)
    elseif frame>2 then
        bload "img/strelki_3(2).bmp",@str1(0)
    endif
    
endif

    put (x,y),@str1(0),trans
    put (x+25,y+10),@str2(0),trans
    
end function   
'*******************************

'*******************************
function QuestionPlayer(v as byte)
   
    dim vrem(139*36) as byte ptr
    bload "img/g_o.bmp",@vrem(0)
   
    dim otvet as byte=0
    nw_time=timer
    
    do while otvet=0
      cls
      fbegin()
    if v=1 then
    if lb_global<=0 then    
    locate 15,35:print "Game reset?!"
    locate 17,35:print "Yes(y)--No(n)"
    else
    locate 15,35:print "Level reset?!"
    locate 17,35:print "Yes(y)--No(n)"
    locate 19,35:print "Lives:";lb_global
    endif
    elseif v=3 then
    locate 15,35:print "Pause!"
    else
    locate 15,35:print "Exit?!"
    locate 17,35:print "Yes(y)--No(n)"
    endif
        if multikey(49) then '*N*
            if v=1 then
                restart=2:otvet=1
            'else
            '    restart=3:otvet=1
            endif    
            if v=2 then otvet=1
        elseif multikey(21) then '*Y*
            if v=1 and lb_global<=0 then
                restart=1:otvet=1
            else
                restart=3:otvet=1
            endif    
            if v=2 then otvet=1:restart=2
        endif
        if level=5 then ReadOpt
        if v=1 and lb_global<=0 then put (250,140),@vrem(0),trans
      if level=3 or level=4 or level=5 then
          DrawParalax(@fon1(0),1,3)
          DrawParalax(@fon2(0),2,3)
          DrawParalax(@fon3(0),3,3)
      else
          DrawParalax(@fon1(0),1,1)
          DrawParalax(@fon2(0),2,1)
          DrawParalax(@fon3(0),3,1)
      endif 
      
         if level=1 then
           t12=timer    
           if t12 > (nw_time) then
           ob_time=ob_time+1'(t12-nw_time)
           nw_time=timer
           endif  
         endif
      screensync 
      fwait()
      flip
      fend()
    loop 
timer_fps_change=timer
end function    
'*******************************

'*******************************
sub StolkRocket
    if RectCollision(xp1,yp1,195,35,xb,yb,21,45,0,0) and ((xb>=xp1+40 and xb<=xp1+130) and (yb+45>=444 and yb+45<=448)) and (inert>=-1 and inert<=2)  then
        put(xb+2,yb+10),@prep6(0),trans
        lb+=10
        PlayMusic(m_st2)
        now_time=timer
        DO
        LOOP UNTIL TIMER > (now_time + .1)
        osh2-=1
        NewRocket
    elseif RectCollision(xp1,yp1,195,35,xb,yb,21,45,0,0) and (inert<=-2 or inert>=2)  then
        lb-=50
        put(xb,yb),@prep4(0),trans
        PlayMusic(m_st)
        now_time=timer
        DO
        LOOP UNTIL TIMER > (now_time + .1)
        NewRocket
    elseif RectCollision(xp1,yp1,195,35,xb,yb,21,25,0,0) and not(xb>=xp1+40 and xb<=xp1+130) then
        lb-=50
        put(xb,yb),@prep4(0),trans
        PlayMusic(m_st)
        now_time=timer
        DO
        LOOP UNTIL TIMER > (now_time + .1)
        NewRocket
    elseif yb>440 or yb<-100 or xb<0 or xb>620 then    
        lb-=50
        put(xb,yb),@prep4(0),trans
        PlayMusic(m_st)
        now_time=timer
        DO
        LOOP UNTIL TIMER > (now_time + .1)
        NewRocket
    endif
end sub    
'*******************************

'*******************************
sub NewRocket
    if osh2<=0 then DrawGet(1):quit=1
    yb=-45
    xb=int(rnd(1)*440)+100
    rotate=int(rnd(1)*51)+50
    inert=0
end sub    
'*******************************

'*******************************
sub ReadPlot(lev as byte)

    if setting_mus=1 then
        if lev<>1 then MusicLoad(m_fon,"sounds/suget.ogg")
        PlayMusic(m_fon)
    endif    
sleep 100
  DIM buf_text AS STRING
  dim rd(1) as string
  dim name_image as string
  dim img(320*240) as byte ptr


select case lev
   case 0
      rd(0)="00":rd(1)="01"
      name_image="img/suget0.bmp"
   case 1
      rd(0)="10":rd(1)="11"
      name_image="img/suget1.bmp"
   case 2
      rd(0)="20":rd(1)="21"
      name_image="img/suget2.bmp"
   case 3
      rd(0)="30":rd(1)="31"
      name_image="img/suget3.bmp"
   case 4
      rd(0)="40":rd(1)="41"
      name_image="img/suget4.bmp"
   case 5
      rd(0)="50":rd(1)="51"
      name_image="img/suget5.bmp"
   case else
       print "Error!Given are not discovered!"
       EXIT sub
end select       
cls
for i=0 to 1000
    x=int(rnd(1)*640)
    y=int(rnd(1)*480)
    pset(x,y),-1 
next i

bload name_image,@img(0)
put(150,10),@img(0),trans

f = FREEFILE
OPEN "suget.dat" FOR input AS #f
locate 18,3

do 
input #f,buf_text
loop until rd(0)=buf_text

Do
    
input #f,buf_text

if buf_text="1" then 
    print chr(044);
elseif buf_text="2" then
    print
elseif buf_text="3" then
    print"   ";
elseif buf_text=rd(1) then
else    
print buf_text;
endif

loop until rd(1)=buf_text
  
CLOSE
flip
sleep
screenset 0 
x=0
suget_timer=TIMER
for i=0 to 128
  for j=0 to 480 step 2
   line (0,j)-(x,j),0
  next j
  for j=1 to 480 step 2
   line (640,j)-(640-x,j),0
  next j   x+=5
  if TIMER>(suget_timer+5) then EXIT FOR
    'screensync
   ' flip
   sleep(1)
next i
if setting_mus=1 then
if lev<>0 then Music_End(m_fon)
endif
screenset 1,0
end sub
'*******************************

function RectCollision (x11 as integer,y11 as integer,w1 as integer,h1 as integer,x21 as integer,y21 as integer,w2 as integer,h2 as integer,p as integer,c as integer)

x12=x11+w1
x13=x11+w1
x14=x11
y12=y11
y13=y11+h1
y14=y11+h1

x22=x21+w2
x23=x21+w2
x24=x21
y22=y21
y23=y21+h2
y24=y21+h2

if c<>0 then
    line (x11,y11)-(x13,y13),c,b
    line (x21,y21)-(x23,y23),c,b
endif


if x11>x21 and x11<x22 and y11>y21 and y11<y23 then return 1
if x12>x21 and x12<x22 and y12>y21 and y12<y23 then return 1
if x13>x21 and x13<x22 and y13>y21 and y13<y23 then return 1
if x14>x21 and x14<x22 and y14>y21 and y14<y23 then return 1

if x21>x11 and x21<x12 and y21>y11 and y21<y13 then return 1
if x22>x11 and x22<x12 and y22>y11 and y22<y13 then return 1
if x23>x11 and x23<x12 and y23>y11 and y23<y13 then return 1
if x24>x11 and x24<x12 and y24>y11 and y24<y13 then return 1
    
    return 0

end function


function PixelCollide(byval img1 as integer ptr,byval x1 as integer,byval y1 as integer,byval w1 as integer,byval h1 as integer,byval img2 as integer ptr,byval x2 as integer,byval y2 as integer,byval w2 as integer,byval h2 as integer) as byte 
if RectCollision (x1,y1,w1,h1,x2,y2,w2,h2,0,0) and level<>2 then
for i=0 to h1-1
    for j=0 to w1-1
       x_v1=(x1+j)-x1:y_v1=(y1+i)-y1
        k1=y_v1*w1+x_v1
        'k1+=1
       
       if ((img1[k1])<>16711935) then 
            
        if x1+j>x2 and x1+j<x2+w2 and y1+i>y2 and y1+i<y2+h2 then
           x_v=(x1+j)-x2:y_v=(y1+i)-y2
           k=y_v*w2+x_v
           if ((img2[k])<>16711935) then
             return 1
            
           endif       
        endif
        endif
    next j
   
next i
'k1=0
endif
'line (x1,y1)-(x1+w1,y1+h1),123,b 
if level=2 and RectCollision (x1,y1,w1,h1,x2,y2,w2,h2,0,0) then
    return 1
endif    
    
return 0
end function 
    
    