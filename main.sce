clear; clc; clf; // Clear variable list, console, and figures 
//exec(pwd()+'\stlfiles\etc\stlfiles.start',-1); // Load the files needed to import STL files
exec(pwd() + '\stlfiles\etc\stlfiles.start',-1)
exec(pwd() + '\browseSTL.sce',-1) // Executes the file selection GUI
// List of important variables to come out of STL_promt.sce : outFilePath, inFilePath, stlFilePath, isBinary, inUsed

while x == 0
    // This style of loop is used so that the program waits for the previous GUI operations to terminate
    //sleep(1)
end
x = 0;

exec(pwd()+'\solarSurfacesSTL.sce',-1) // Executes the solar panel surface selection GUI
while x == 0
    // This style of loop is used so that the program waits for the previous GUI operations to terminate
    //sleep(1) 
end
save(outFilePath,tcolor,alignVec,constVec)
[xAtt,yAtt,zAtt] = AttitudeAdjust(t.x,t.y,t.z,alignVec,constVec,[],[]);
exec(pwd()+'\AttitudeAdjust.sci',-1) // Executes attitude script
[]
exec(pwd()+'\EarthOrbiterSystem.sce',-1) // Executes computation script
disp('done')

// comments for attitude
//QSW
//x : radially outwards
//y : completes triad (almost RAM) instant velocity
//z : orbit normal (same direction as h vector)
//
//use celestLab functions to convert
//
