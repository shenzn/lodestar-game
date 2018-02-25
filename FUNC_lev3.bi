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

inert=0
dim size as short=50*50



declare sub RotateShip(p as byte)
declare sub GlobalDraw
declare sub InitLevel3
redim shared ball(size) as byte ptr
 
dim shared adres as byte ptr
dim shared pdx,pdy,d_in as double
d_in=0.03
pdx=dx:pdy=dy
quit=0


sub  GlobalDraw
     
    if rotate>=360 then 
        rotate=0
    elseif rotate<0 then
        rotate=359
    end if
      
    if multikey(57) then
        RotateShip(0)
            if dx<pdx then
             dx+=2
            elseif dx>pdx then
             dx-=2
            elseif dy<pdy then
             dy+=2
            elseif dy>pdy then
             dy-=2
            endif 
       
            inert+=d_in
            xb+=(dx*inert)\10
            yb+=(dy*inert)\10
    end if
    
    if not multikey(57) then 
        inert-=0.03
        xb+=(dx*inert)\10:yb+=(dy*inert)\10
    end if
    if dx=0 and dy=0 then inert=0
    if inert>30 then inert=30
    if inert<0 then inert=0:dy=pdy:dx=pdx
    
    if xb<-30 then xb+=640
    if yb<-30 then yb+=480
    if xb>640 then xb-=640
    if yb>480 then yb-=480
    
    RotateShip(1)    
    put(xb,yb),adres,trans
         
end sub    

sub RotateShip(p as byte)
    
    if rotate>=0 and rotate<24 then 
        bload "img/rotate/abc1.bmp",@ball(0)
        adres=varptr(ball(0))
        fdx=0:fdy=-40
    elseif rotate>=24 and rotate<48 then 
        bload "img/rotate/abc2.bmp",@ball(0)
        adres=varptr(ball(0))
        fdx=10:fdy=-30
    elseif rotate>=48 and rotate<72 then 
        bload "img/rotate/abc3.bmp",@ball(0)
        adres=varptr(ball(0))
        fdx=20:fdy=-20
    elseif rotate>=72 and rotate<96 then
        bload "img/rotate/abc4.bmp",@ball(0)
        adres=varptr(ball(0))
        fdx=30:fdy=-10
    elseif rotate>=96 and rotate<120 then 
        bload "img/rotate/abc5.bmp",@ball(0)
        adres=varptr(ball(0))
        fdx=40:fdy=0
    elseif rotate>=120 and rotate<144 then 
        bload "img/rotate/abc6.bmp",@ball(0)
        adres=varptr(ball(0))
        fdx=30:fdy=10
    elseif rotate>=144 and rotate<168 then 
        bload "img/rotate/abc7.bmp",@ball(0)
        adres=varptr(ball(0))
        fdx=20:fdy=20
    elseif rotate>=168 and rotate<192 then
        bload "img/rotate/abc8.bmp",@ball(0)
        adres=varptr(ball(0))
        fdx=10:fdy=30
    elseif rotate>=192 and rotate<216 then 
        bload "img/rotate/abc9.bmp",@ball(0)
        adres=varptr(ball(0))
        fdx=0:fdy=40
    elseif rotate>=216 and rotate<240 then
        bload "img/rotate/abc10.bmp",@ball(0)
        adres=varptr(ball(0))
        fdx=-10:fdy=30
    elseif rotate>=240 and rotate<264 then 
        bload "img/rotate/abc11.bmp",@ball(0)
        adres=varptr(ball(0))
        fdx=-20:fdy=20
    elseif rotate>=264 and rotate<288 then 
        bload "img/rotate/abc12.bmp",@ball(0)
        adres=varptr(ball(0))
        fdx=-30:fdy=10
    elseif rotate>=288 and rotate<312 then 
        bload "img/rotate/abc13.bmp",@ball(0)
        adres=varptr(ball(0))
        fdx=-40:fdy=0
    elseif rotate>=312 and rotate<336 then 
        bload "img/rotate/abc14.bmp",@ball(0)
        adres=varptr(ball(0))
        fdx=-30:fdy=-10
    elseif rotate>=336 and rotate<350 then 
        bload "img/rotate/abc15.bmp",@ball(0)
        adres=varptr(ball(0))
        fdx=-20:fdy=-20
    elseif rotate>=350 and rotate<360 then 
        bload "img/rotate/abc16.bmp",@ball(0)
        adres=varptr(ball(0))
        fdx=-10:fdy=-30
    endif
    if p=1 then adres=varptr(ball(0))
    pdx=fdx:pdy=fdy
end sub  

sub InitLevel3
    s_ship=-1
    for i=0 to test_s_ship-1
        with obj(i)
            .image=5
            .l=0
        end with
    next i    
    inert=0
    dx=0:dy=0
    for i=0 to test_s_ship-1 
        NewShip
    next i
    EnemStart(0)
     if col_oskolkov>=10 then
        DrawGet(1)
        quit=1 
    endif
    tb=col_oskolkov+1
end sub

    
    
    
    
    
    
    