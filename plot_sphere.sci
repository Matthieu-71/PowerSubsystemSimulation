clear; clc; clf
function findMid(a,b,c,d)
    // This function finds the centre of a square
    
endfunction

function [] = plot_sphere(r,n,d)
    // Copyright (c) York University 2018   Authors: Matthieu D. and Jessie A. 
    // This function plots the surface of a sphere
    // Inputs: r - radius of the sphere [km], n - number of divisions, d - change in size along axes [km] 
    lat = linspace(-%pi/2,%pi/2,n +1);
    lon = linspace(0,2*%pi,n*2 + 1);
    x     = r*(cos(lat)'*cos(lon)) + d(1);
    y     = r*(cos(lat)'*sin(lon)) + d(2);
    z     = r*(sin(lat)'*ones(lon)) + d(3);
    plot3d(x,y,z);
    e = gce();
    e.color_flag = 2; 
    e.color_mode = 12; // Sets the colour of the surfaces
    e.foreground = 33; // Sets the colour of the lines seperating each surface
    trace_traj(r*[cos(lat);zeros(lat);sin(lat)], F=1, col=16, th=1); // Plots meridian  
    trace_traj(r*[cos(lon);sin(lon);zeros(lon)], F=1, col=16, th=1); // Plots equator
    a = gca();
    a.isoview = 'on'; // Changes the view to isometric 
    a.grid = [1 1]; // Adds grid lines to the graphical object
endfunction
REarth  = 6378                   // Radius of the Earth [km]acacqsfsqdf





//plot_sphere(REarth,50,[0 0 0]) // Plots the Earth as a sphere

//deff("[x,y,z]=sph(alp,tet)",["x=r*cos(alp).*cos(tet)+orig(1)*ones(tet)";..
//     "y=r*cos(alp).*sin(tet)+orig(2)*ones(tet)";..
//     "z=r*sin(alp)+orig(3)*ones(tet)"]);
r = 1; orig=[0 0 0]; div = 100;
xx = r*cos(linspace(-%pi/2,%pi/2,div));
yy = r*sin(linspace(0,%pi*2,div))
xx = 11;//r*cos(alp).*sin(tet)
//[xx,yy,zz]=eval3dp(sph,linspace(-%pi/2,%pi/2,80),linspace(0,%pi*2,80));
[row col] = size(zz)
colour = 5*ones(row,col);
im = imread(pwd()+'\land_shallow_topo_350.jpg');
imSize = size(im);
disp(imSize);
disp(max(xx))

for i = 1:row
    for j = 1:col
        //colour(i,j) = rand();
        if yy(1,j) > 0 
            lat = 
        lat = (yy(1,j)/r)*imSize(1) + 1
        lon = abs(zz(1,j)/r)*imSize(2)
        disp(lat)
        disp(lon)
        disp(im(lat,lon,1))
    end
end



clf();plot3d(xx,yy,list(zz,colour))
    a = gca();
    a.isoview = 'on'; // Changes the view to isometric 
    h=get("hdl") //get handle on current entity (here the surface)
    h.color_mode = -1;
    
