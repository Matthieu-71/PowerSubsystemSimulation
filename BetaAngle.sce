//Attitude Definition and Beta Angle
clear; clc; clf
exec(pwd() + '\stlfiles\etc\stlfiles.start',-1) // Execute files needed for STL import
stlpath = get_absolute_file_path("BetaAngle.sce")+'' // Gets the path leading the the desiring STL file, this needs to be changed to fit any user
t = stlread(fullfile(stlpath, "cube.stl"), "binary"); // Imports the STL file
tcolor = 12*ones(1, size(t.x,"c")) // Sets the colour of all surfaces of the file

xIns = t.x; // |
yIns = t.y; // | Model position
zIns = t.z; // |
plot3d(-xIns,yIns,list(zIns,tcolor));
set(gca(),'isoview','on');
xarrows([0 30],[0 0],[0 0],30,color(255,0,0))
xarrows([0 0],[0 30],[0 0],30,color(255,0,0))
xarrows([0 0],[0 0],[0 30],30,color(255,0,0))

function xRot(theta)
R1=[1,0,0;0,cos(theta),sin(theta);0,-sin(theta),cos(theta);];
endfunction

function yRot(theta)
R2= [cos(theta),0,-sin(theta);0,1,0;sin(theta),0,cos(theta);];
endfunction

function zRot(theta)
R3= [cos(theta),sin(theta),0;-sin(theta),cos(theta),0;0,0,1;];
endfunction 
