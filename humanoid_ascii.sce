stlpath = get_absolute_file_path("humanoid_ascii.sce")

t = stlread(fullfile(stlpath, "humanoid.stl"), "ascii");

figure

tcolor = 2*ones(1, size(t.x,"c"))

plot3d(t.x,t.y,list(t.z,tcolor));

a = gca()
a.isoview = "on"
