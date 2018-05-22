clear; clc; clf

function [] = plot_sphere(r,n,d)
    // Copyright (c) York University 2018   Authors: Matthieu D. and Jessie A. 
    // This function plots the surface of a sphere
    // Inputs: r - radius of the sphere [km], n - number of divisions, d - change in size along axes [km] 
//    lat = linspace(-%pi/2,%pi/2,n +1);
//    lon = linspace(0,2*%pi,n*2 + 1);
//    x     = r*(cos(lat)'*cos(lon)) + d(1);
//    y     = r*(cos(lat)'*sin(lon)) + d(2);
//    z     = r*(sin(lat)'*ones(lon)) + d(3);
//    plot3d(x,y,z);
//    e = gce();
//    e.color_flag = 2; 
//    e.color_mode = 12; // Sets the colour of the surfaces
//    e.foreground = 33; // Sets the colour of the lines seperating each surface
//    trace_traj(r*[cos(lat);zeros(lat);sin(lat)], F=1, col=16, th=1); // Plots meridian  
//    trace_traj(r*[cos(lon);sin(lon);zeros(lon)], F=1, col=16, th=1); // Plots equator
//    a = gca();
//    a.isoview = 'on'; // Changes the view to isometric 
//    a.grid = [1 1]; // Adds grid lines to the graphical object
endfunction

deff("[x,y,z]=sph(alp,tet)",[..
"x = r*cos(alp).*cos(tet)+orig(1)*ones(tet)";..
"y = r*cos(alp).*sin(tet)+orig(2)*ones(tet)";..
"z = r*sin(alp)+orig(3)*ones(tet)"]);

r = 6378; // Radius of the Earth [km]
orig = [0 0 0];
div = 200; // Number of divisions, affect resolution of sphere 
[xx,yy,zz]=eval3dp(sph,linspace(-%pi/2,%pi/2,div),linspace(0,%pi*2,div));
[row col] = size(zz);
colour = zeros(1,col);
im = imread(pwd()+'\land_shallow_topo_2048.jpg');
imSize = size(im);

// Compute the latitude and longtide of each surface using the first vertex
tic()
lat = acos(zz(2,:)/r);
lat = lat*(180/%pi);
lon = atan(yy(2,:),xx(2,:)) + %pi;
lon = lon*(180/%pi);



for i = 1:col
    imLat = round(lat(i)*imSize(1)/180) + 1;
    imLon = round(lon(i)*imSize(2)/360);
    r = strtod(string(im(imLat,imLon,1))); // to change from 1x1 to scalar
    g = strtod(string(im(imLat,imLon,2)));
    b = strtod(string(im(imLat,imLon,3)));
    colour(i) = color(r,g,b);

    if (i-fix(i./1000).*1000) == 0
        clc(1)
        s = msprintf('Percentage computed : %0.0f',(i*100/col));
        disp(s)
    end
end
compTime = toc();

clf(); 
plot3d(xx,yy,list(zz,colour))
a = gca();
a.isoview = 'on'; // Changes the view to isometric 
h=get("hdl") //get handle on current entity (here the surface)
h.color_mode = -1;
