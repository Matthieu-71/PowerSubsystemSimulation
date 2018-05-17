//Attitude Definition and Beta Angle
// Authours: Matthieu D. Jessie A. Arvin T.
clear; clc; clf // Remove at implementation

function [] = xRot(vec,theta)
  R1=[1,0,0;0,cos(theta),sin(theta);0,-sin(theta),cos(theta)];
  out=vec*R1;
endfunction

function [] = yRot(vec,theta)
  // Jessie lifts like a daddy
  R2= [cos(theta),0,-sin(theta);0,1,0;sin(theta),0,cos(theta)];
  out=vec*R2;
endfunction

function [] = zRot(vec,theta)
  R3= [cos(theta),sin(theta),0;-sin(theta),cos(theta),0;0,0,1];
  out=vec*R3;
endfunction

// --- Remove when implemented into main --------------------------------------
exec(pwd() + '\stlfiles\etc\stlfiles.start',-1) // Execute files needed for STL import
stlpath = get_absolute_file_path("BetaAngle.sce")+'' // Gets the path leading the the desiring STL file, this needs to be changed to fit any user
t = stlread(fullfile(stlpath, "cube.stl"), "binary"); // Imports the STL file
tcolor = 12*ones(1, size(t.x,"c")) // Sets the colour of all surfaces of the fill
// ----------------------------------------------------------------------------

xIns = t.x; // |
yIns = t.y; // | Model position
zIns = t.z; // |

newx = [];
newy = [];
newz = [];

for i = 1 : max(size(xIns))*min((xIns))
    newx(i) = xRot([xIns(i),yIns(i),zIns(i)],%pi/2);
    newy(i) = yRot([xIns(i),yIns(i),zIns(i)],%pi/2);
    newz(i) = zRot([xIns(i),yIns(i),zIns(i)],%pi/2);
end
plot3d(newx,newy,newz);
set(gca(),'isoview','on');
xarrows([0 30],[0 0],[0 0],30,color(255,0,0))
xarrows([0 0],[0 30],[0 0],30,color(255,0,0))
xarrows([0 0],[0 0],[0 30],30,color(255,0,0))
