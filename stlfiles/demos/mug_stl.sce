clear; clc;
stlpath = get_absolute_file_path("mug_stl.sce")
exec("C:\Users\matth\Documents\SciLab_CelestLab_work\stlfiles\etc\stlfiles.start");
t = stlread(fullfile(stlpath, "Mug.stl"), "binary");

figure

tcolor = 2*ones(1, size(t.x,"c"))

plot3d(t.x,t.y,list(t.z,tcolor));

a = gca()
a.isoview = "on"