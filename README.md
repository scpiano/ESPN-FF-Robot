# ESPN-FF-Robot
I forgot to set my fantasy lineup one too many times - so I made this! Automatically sets lineups (along with many other things hopefully) in fantasy football on ESPN.
## Process
A lot of this was only possible by looking at the great work others have done on Github on documenting the ESPN fantasy API. 

Aside from a lot of the simpler calls that are done in those repositories, I utilized Fiddler and Charles in order to get the requests needed in order to actually set the lineups.

The logic I use behind actually setting the lineups is pretty simple - I use the projections that ESPN uses as a base, then an amalgamation of both those projections and industry-wide fantasy projections in order to set the final lineups per week.