''
''	Freebasic FPS Independance Library
''	Atosoft++
''	Oz
''	http://www.atosoftpp.digitalblackie.com/
''
''---------------------------------------------------------
''
''	This library is under no license whatsoever, so it
''	is absolutely free!  The only minor catch is that
''	I like to know where my code ends up, so drop me a
''	line if you're using this.  This code is extremely
''	simple, but not many people take variable cpu speeds
''	into account while making a game, so this will help
''	avoid common game-speed problems in a simple and
''	clean way.
''	If you're intrested in the source, also feel free
''	to drop me a line, because I'm more than happy to
''	distribute source - I just lean towards binaries
''	so people don't have to compile them themselves
''	(since most people are pretty lazy....even me)
''
''	NOTE:
''		The method used to make distance per
''		second constant through different fps
''		counts is not 100% accurate by any means but
''		is accurate enough to make things work.  This
''		is not becuase of poor design, but for lack
''		of timing accuracy, which is a pretty tough
''		barrier to break without using memory-wasting
''		threads that aren't nessicarily helpful.
''
''	Anywho, enough jabbering along with me...on to
''	function commenting
'*************************************************************************

'*************************************************************************
'This is a source code (FreeFPS) is not an original. 
'He is changed for compatibility with game Lodestar.
'Thank you creator FreeFps!
'*************************************************************************
#inclib "FreeFps"

#ifndef __freefps__
#define __freefps__	1



	
    
	declare sub setfps( byval framerate as integer )
		' Set the desired frame rate
		' default is 0 (as many frames as possible)
		' the computer does it's best to estimate the frame
		' rate, but is not always accurate

	declare sub smooth_percent( byval smoothval as integer )
		' Sets the number of frame times to keep (to smooth movement out)
		' Not really a percent, but it is a value from 0-100 (overflow if
		' below 0 or above 100)
		' The more smooth the movements, the choppier the update
		' By default, it is 20

	declare sub fbegin()
		' Begins the frame timer
		' should be put at the begining of each drawing-loop to be most effective

	declare sub fend()
		' Ends the frame timer and calculates the fps (real, estimated) and averages
		' frame times
		' Should be called at the end of each drawing loop for best performance

	declare sub fwait()
		' Does a loop until the desired frame rate is reached (set by setfps())
		' If there was not desired frame rate set, the routine will return immediately

	declare function frim( byval distance as single ) as single
		' Calculates a value that is incremented 'distance' amount per second
		' example:
		'	if a variable is increased like this x += FpsCounter::frim( 1 )
		'	x will increase by one in a complete second.  x will increase by
		'	tiny fractions during the elapsing second, aswell

	declare function fps_sub() as integer
		' Displays the real frames per second.
		' the value is update every second

	declare function fts() as single
		' Dislplays the estimated frames per second.
		' The value is determined by taking the averaged
		' time of the last elasped frame and determines
		' how many frames could be shown in one second.

	declare function efps() as single
		' Works similar to fts() but uses the last time
		' instead of a complete average
		' It is likely that this will be quite off
		' the actual fps function.  (1, in terms of fps
		' is considered "quite off")


#endif
