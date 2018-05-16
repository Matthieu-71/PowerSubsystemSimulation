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

exec(pwd()+'\solaSurfacesSTL.sce',-1) // Executes the solar panel surface selection GUI
while x == 0
    // This style of loop is used so that the program waits for the previous GUI operations to terminate
    //sleep(1) 
end
save(outFilePath,tcolor)

exec(pwd()+'\EarthOrbiterSystem.sce',-1) // Executes the main computation program
disp('done')
