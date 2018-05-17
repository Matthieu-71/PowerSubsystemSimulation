//Attitude Definition and Beta Angle
gca();
exec(pwd() + '\stlfiles\etc\stlfiles.start',-1) // Execute files needed for STL import
stlpath = get_absolute_file_path("BetaAngle.sce")+'' // Gets the path leading the the desiring STL file, this needs to be changed to fit any user
t = stlread(fullfile(stlpath, "cube.stl"), "binary"); // Imports the STL file
tcolor = 12*ones(1, size(t.x,"c")) // Sets the colour of all surfaces of the file 

xIns = 0; // |
yIns = 0; // | Model position
zIns = 0; // |
plot3d(-xIns,yIns,zIns);
