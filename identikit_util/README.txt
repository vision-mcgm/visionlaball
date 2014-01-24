Hi Harry!

files:
firstordergui.fig- GUI button layout file
firstordergui.m- gui code file
guigenface.m- face generation file for the MALE space
guigenfaceFEM.m- face generation file for the FEMALE space

The latter two files are called like guigenface(Input). Input is an n-vector of coefficients which range between 0 and 1; these represent the positions of the sliders. n= number of principal components. They are renormalised to be between 

To install the two spaces you will need to locate the line

load([DirMorphing 'all/PCAModelDirect.mat']);

…in both guigenface files, and change it to the names of the PCA space descriptors for the corresponding genders. Then everything should work.

I worked some global variable magic and reduced the face generation time from 0.2 secs to 6e-6 secs- it was reloading the PCA matrix each time.

TODO: 

-line up all the buttons and images for the correct screen size (can be done on the day).
-Check everything works properly.