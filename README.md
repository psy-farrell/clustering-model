This directory contains MATLAB code for running simulations reported in Farrell, S. (2012), Temporal clustering and sequencing in short-term memory and episodic memory, Psychological Review. That paper should most certainly be referred to when interpreting the code. Any updates to the code will be posted on Simon Farrell's [web site](http://psy-farrell.github.io).

The file runModel.m is the main calling script. This sets up many of the global variables and parameter values, and calls code to run a specific experiment. Each simulation has it's own .m script to set up particulars of the experiment (e.g., list length, presentation durations, recall type, extra-list competitors). These scripts all eventually end up calling the function model.m, which contains the main model code for actually running the model. This is horribly long and should really be broken up into functions; however, I've found that the code folding in recent versions of MATLAB means that I haven't found this such an issue.

#Editing the files #

The easiest thing to do is type 'go' at the command line and hit enter. This will open up all the .m files for editing so you can quickly switch between them using MATLAB's tabbed editor. I like to keep the tabs on the side of the editor rather than the top/bottom.

#Note about programming #

The code is commented, but the way the simulation is run may not be immediately obvious (it looks the way it does for historical reasons). If you're unsure what's going on, the easiest thing to do is to display the values of various matrices or variables as the simulation unfolds. It really helps to see what PIocc, GIocc and GIw actually look like, for example.

The files that run the individual simulations contain references to a function "prettySPC". This is for production of journal figures, and is not needed to see the results of the simulations.

Simon Farrell
Last updated: 07/04/2014

