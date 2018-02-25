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

declare function NewPull(x as integer,y as integer,vid as byte)
declare function DrawPull
declare function TestPull
declare function PKey(code as short)
declare function EnemStart(lev as byte)
declare function DrawEnem(lev as byte)
declare function EnemPull
declare function StolkPull
declare function TestLevel2UndeLevel
dim shared nowl as byte
dim shared dowloadlevel as byte
nowl=0:dowloadlevel=1

'********************
function NewPull(x as integer,y as integer,vid as byte)
s_pull+=1 
  with pull(s_pull)
      
      if vid=1 then       'player
          .x=x+10
          .y=y
          .dy=-5
          .image=1
      elseif vid=2 then    'enem
          .x=x+28
          .y=y+5
          .dy=7
          .image=2
      endif
  end with 
end function  
'********************

'********************
function DrawPull
    
    if s_pull>0 then
        for i=0 to s_pull
        with pull(i)
            if .image<>0 then
            if .image=1 then
                put (.x,.y),@pl2(0),trans
            elseif .image=2 then
                put (.x,.y),@prep6(0),trans
            endif
            .y+=.dy
            endif
            if .y<0 or .y>480 then .image=0
        end with
        next
    endif
end function  
'********************

'********************
function TestPull
    for i=0 to 200
        with pull(i)
         if .image<>0 then t_pull+=1
        end with 
    next
   If s_pull>=200 and t_pull=0 then s_pull=0
   
  if s_pull<200 then 
   return 1
  else 
      return 0 
   endif
   
end function   
'********************

'********************
function PKey(code as short)
     if (multikey(code) or code=1) and code<>0 then
       if timer > (t+0.2) then
           t=timer
           return 1
       else
           return 0
       endif  
     endif
     if code=0 then
         enem_pull+=1
         if enem_pull>10 then
             enem_pull=0
             return 1
         endif
     endif    
end function  
'********************

'********************
function EnemStart(lev as byte)
if lev=2 then
xe=-20:ye=20:d=2  
    for i=0 to 21
         xe+=70
         with enem(i)
            .x=xe
            .y=ye
            .dx=d
            .dy=0
            .image=1
            .l=6
         end with
    if i=7 then xe=20:ye+=70:d=2
    if i=14 then xe=20:ye+=70:d=2
next i
elseif lev=1 then
    xe=-20:ye=20:d=0  
    for i=0 to 21
         xe+=70
         with enem(i)
            .x=xe
            .y=ye
            .dx=d
            .dy=0
            .image=1
            .l=5
         end with
    if i=7 then xe=20:ye+=70:d=0
    if i=14 then xe=20:ye+=70:d=0
    next i
elseif lev=3 then
xe=-20:ye=20:d=2  
    for i=0 to 21
         xe+=70
         with enem(i)
            .x=xe
            .y=ye
            .dx=d
            .dy=0
            .image=1
            .l=7
         end with
    if i=7 then xe=20:ye+=70:d=3
    if i=14 then xe=20:ye+=70:d=6
next i
elseif lev=4 then
    xe=-20:ye=20:d=2  
    for i=0 to 21
         xe+=70
         with enem(i)
            .x=xe
            .y=ye
            .dx=0
            .dy=d
            .image=1
            .l=10
         end with
    if i=7 then xe=20:ye+=70
    if i=14 then xe=20:ye+=70
    if i<7 or i>13 then 
        d=2
    else  
        d=0
    endif    
next i
elseif lev=5 then
    xe=-20:ye=20:d=1  
    for i=0 to 21
         xe+=70
         with enem(i)
    if i=0 or i=8 or i=15  or i=7 or i=14 or i=21 then 
        d=3
    elseif i=1 or i=9 or i=16 or i=6 or i=13 or i=20 then  
        d=2
    elseif i=2 or i=10 or i=17 or i=5 or i=12 or i=19 then
        d=1
    endif   
            .x=xe
            .y=ye
            .dx=0
            .dy=d
            .image=1
            .l=10
         end with
    if i=7 then xe=20:ye+=70
    if i=14 then xe=20:ye+=70
     
next i

elseif lev=0 then
    col_oskolkov+=2
   for i=0 to col_oskolkov
    with enem(i)    
    .x=int(rnd(1)*600)
    .y=int(rnd(1)*400)
    .dx=0'int(rnd(1)*scorost)+1
    .dy=0'int(rnd(1)*scorost)+1
    .image=1
    .l=1
    end with
   next i
endif

end function
'********************

'********************
function DrawEnem(lev as byte)
if level<>3 then
    for i=0 to 21
        with enem(i)
            
         if .image<>0 then
             if .l<=0 then .image=-1
            .x+=.dx
            .y+=.dy
        if lev=3 then
            if .x>640 or .x<0 then .dx=-.dx:.y+=10
        elseif lev=4 then
            if .y>300 or .y<0 then .dy=-.dy    
        elseif lev=2 then
            if .x>600 or .x<0 then .dx=-.dx
        elseif lev=5 then
            if .y>300 or .y<0 then .dy=-.dy
        endif
        
        if RectCollision(xp1,yp1,27,40,.x,.y,62,39,0,0) then
            DrawGet(2)
            PlaySound(m_st)
        endif
        
            if .image=1 then
            put(.x,.y),@ball(0),trans
            elseif .image<0 then 
                put(.x,.y),@prep4(0),trans
                .l=1:.image-=1
                if .image<-3 then
                    .image=0
                    score+=30
                    PlaySound(m_st)
                endif    
            endif
        endif    
        end with
    next i
      
    EnemPull
elseif level=3 then 
   
   for i=0 to col_oskolkov
      with enem(i)
         if .image=1 then
            if PixelCollide(@ball(0),xb,yb,50,50,@prep(0),.x,.y,21,45) then
               .image=-1
               tb-=1
            endif
            put(.x,.y),@prep(0),trans
         elseif .image<0 then 
            put(.x,.y),@prep6(0),trans
            .l=1:.image-=1
               if .image<-10 then
                  .image=0
                  score+=100
                  PlaySound(m_st2)
                endif    
        endif
     end with
   next i
   
endif
if tb=0 then
       DrawGet(1)
       sleep
       tb=0
endif    
end function 
'********************

'********************
function EnemPull
    for i=0 to 21
        with enem(i)
            if .image>0 then
            slush=int(rnd(1)*50)+1
               if xp1>=.x and xp1<=.x+62 and slush=40 and TestPull then 
            NewPull(.x,.y,2)
           endif 
           endif
        end with
    next  
end function    
    
function StolkPull
    if s_pull>0 then
      for i=0 to s_pull
        with pull(i)
            
            if .image=2 and lb<>0 then
               if PixelCollide(@pl1(0),xp1,yp1,27,40,@prep6(0),.x,.y,5,7) then
                    .image=0       'enem_pull & player
                    lb-=20
                    PlaySound(m_st)
                endif
                
            elseif .image=1 then
                
            for j=0 to 21
                with enem(j)
                    if enem(j).image<>0 then
                  if PixelCollide(@ball(0),.x,.y,62,39,@pl2(0),pull(i).x,pull(i).y,5,8) then
                            pull(i).image=0       'enem & player_pull
                            enem(j).l-=1
                         endif
                         
                    endif
                end with 
            next j
            for j=0 to s_ship
                with obj(j)            'ship player_pull
                    if .image=1 and PixelCollide(@prep(0),.x,.y,47,54,@pl2(0),pull(i).x,pull(i).y,5,8) then'RectCollision(.x,.y,47,54,pull(i).x,pull(i).y,5,7,0,0) then
                        obj(j).image=4
                        score+=20
                        pull(i).image=0
                        PlaySound(m_st)
                    endif
                    if .image=2 and RectCollision(.x,.y,32,27,pull(i).x,pull(i).y,5,7,0,0) then
                        obj(j).image=4
                        score+=20
                        pull(i).image=0
                        PlaySound(m_st)
                    endif
                    if .image=3 and RectCollision(.x,.y,32,25,pull(i).x,pull(i).y,5,7,0,0) then
                        obj(j).image=4
                        score+=20
                        pull(i).image=0
                        PlaySound(m_st)
                    endif
                 end with
             next j    
            endif
       end with
     next i
   endif
end function   
'********************

'********************
function TestLevel2UndeLevel
    If dowloadlevel>5 then DrawGet(1):quit=1      '******
    if dowloadlevel>nowl and quit<>1 then
        EnemStart(dowloadlevel)
        for i=0 to 200
         with pull(i)
          .image=0
         end with 
        next i
        s_pull=0
        nowl+=1
        for i=0 to test_s_ship
         with obj(i)
          .l=-1
         end with 
        next i
        lb+=50
        DrawGet(0)
    endif
    if dowloadlevel=nowl then
        DrawEnem(nowl)
    endif
    for i=0 to 21
        with enem(i)
            if .image=0 then kol+=1
        end with
    next i
   
   if kol=21 then dowloadlevel+=1:DrawGet(1)
end function  
'********************