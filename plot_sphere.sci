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
REarth  = 6378;                   // Radius of the Earth [km]acacqsfsqdf





//plot_sphere(REarth,50,[0 0 0]) // Plots the Earth as a sphere
deff("[x,y,z]=sph(alp,tet)",[..
"x = r*cos(alp).*cos(tet)+orig(1)*ones(tet)";..
"y = r*cos(alp).*sin(tet)+orig(2)*ones(tet)";..
"z = r*sin(alp)+orig(3)*ones(tet)"]);

//deff("[x,y,z] = sph(the,phi)",[..
//     "x=r*sin(the).*cos(phi)+orig(1)*ones(phi)";..
//     "y=r*sin(the).*sin(phi)+orig(2)*ones(phi)";..
//     "z=r*cos(the)+orig(3)*ones(phi)"]);
r = 1; orig=[0 0 0]; div = 100;
//the = linspace(-%pi/2,%pi/2,div); // Latitute
//phi = linspace(0,%pi*2,div); // Longitude
//xx = r*sin(the).*cos(phi);
//yy = r*sin(the).*sin(phi);
//zz = r*cos(the);
////xx = 11;//r*cos(alp).*sin(tet)
[xx,yy,zz]=eval3dp(sph,linspace(-%pi/2,%pi/2,div),linspace(0,%pi*2,div));
//[xx,yy,zz]=eval3dp(sph,linspace(-%pi/2,%pi/2,div),linspace(-%pi,%pi,div));
[row col] = size(zz)
colour = 5*ones(1,col);
im = imread(pwd()+'\land_shallow_topo_350.jpg');
imSize = size(im);
disp(imSize);
disp(max(xx))

// Compute the latitude and longtide of each surface using the first vertex
for i = 1:col
    lat = acos(zz(2,i))/sqrt(xx(2,i)^2 + yy(2,i)^2 + zz(2,i)^2);
    //lat = ((lat*(180/%pi)) - 90)*-1; // Conversion to lat = -90,90
    lat = lat*(180/%pi);
    lon = atan(yy(2,i),xx(2,i)) + %pi;

    lon = lon*(180/%pi);
    lonSave(i) = lon;
    //    //s = msprintf('For col %0.0f, lat = %0.3f, lon = %0.3f',i,lat,lon);
    if (lon == 0)
        colour(i) = 5;
    end
    //    if (lat < 0.5 & lat > -0.5)
    //        colour(i) = 1;
    //    end

    imLat = round(lat*imSize(1)/180) + 1;
    //disp(lon)
    imLon = round((lon)*imSize(2)/360);
    //    disp(round(lon))
    //disp(imLon)
    //    if lon < 0
    //        imLon = 1*(round((lon+90)*imSize(2)/360)) + 1 ;
    //    elseif lon > 0 
    //        imLon = round(lon*imSize(2)/360) + imSize(2)/2 + 1;
    //    else
    //        imLon = round(lon*imSize(2)/360) + 1 ;
    //    end
    r = strtod(string(im(imLat,imLon,1))); // to change from 1x1 to scalar
    g = strtod(string(im(imLat,imLon,2)));
    b = strtod(string(im(imLat,imLon,3)));
    colour(i) = color(r,g,b);
    if (lon == 0)
        colour(i) = 5;
    end
//        clf(); 
//    plot3d(xx,yy,list(zz,colour))
//    a = gca();
//    a.isoview = 'on'; // Changes the view to isometric 
//    h=get("hdl") //get handle on current entity (here the surface)
//    h.color_mode = -1;
    //elseif

    //end

    //disp(s)
end



clf(); 
plot3d(xx,yy,list(zz,colour))
a = gca();
a.isoview = 'on'; // Changes the view to isometric 
h=get("hdl") //get handle on current entity (here the surface)
h.color_mode = -1;
