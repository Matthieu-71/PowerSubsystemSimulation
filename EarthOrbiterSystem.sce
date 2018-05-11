// EarthOrbiterSystem v 0.0.1
// This program models the orbital trajectory of a CAD model about the Earth
// Authours : Matthieu D. Jessie A. Arvin T.
// Created on 11 May 2018
// Last modified 11 May 2018
// Table of contents 
//  Part 1 : Definition of global variables
//      Part 1a : initialization of orbit related variables
//      Part 1b : initialization of frame related variables
//      Part 1c : initialization of 3D spacecraft model related variables
//  Part 2 : Definition of proprietary functions
//      Part 2a : trace_traj function
//      Part 2b : plot_sphere function
//      Part 2c : Kep2Cart function
//  Part 3 : Creation of the solar system environment
//      Part 3a : Creation of the Earth spheroid
//      Part 3b : Creation of the 'space' environment
//      PART 3c : Insert STL model of spacecraft
//      Part 3d : Insertion of the orbital trajectory
// celestLab demo are located in C:\Users\matth\AppData\Roaming\Scilab\scilab-5.5.2\atoms\x64\celestlab\3.2.1\demos
clear; clc; clf; // Clear variable list, console, and figures
CL_init(); // Importation of celestLab library   

// Part 1 --- Definition of global variables ----------------------------------
// Part 1a --- initialization of orbit related parameters ---------------------
aa  = 10000;
ec  = 0.5;
in  = 0.0;
ra  = 0.0;
wp  = 0.0;
ta  = 0.00;
TA  = linspace(0,2*%pi,1000); // True anomaly values for one orbit [rad]
kepCoeff = [aa ec ra in wp ta]; // Keplerian elements of the orbit, values are to be retrieved from the user in a later version 
// aa-semimajor axis [km], ec-eccentricity, in-inclination [deg], ra-right ascension of the ascending node [deg], wp-argument of perigee [deg], ta-true anomaly [deg]
// Part 1b --- initialization of frame related parameters ---------------------
AU      = 149597870.700  // Definition of an astronomical unit [km]
RSun    = 695700         // Radius of the Sun [km]
REarth  = 6378           // Radius of the Earht [km]
LSun    = 3.828e26       // Luminosity of the Sun [W/m^2]
frame   = 10e3;          // Dimension of the data bounds [km]
//  Part 1c --- initialization of variables related to the 3D model of the spacecraft
enlarge = 100; // Enlargement factor to increase the volume of the model
//  Part 2 --- Definition of proprietary functions ----------------------------
//  Part 2a --- trace_traj function -------------------------------------------
function trace_traj(traj,F,col,th)
    //  Copyright (c) CNES  2008
    //  This software is part of CelestLab, a CNES toolbox for Scilab
    //  This function traces great cr
    param3d(F*traj(1,:), F*traj(2,:), F*traj(3,:)); 
    e=gce();
    e.foreground=col;
    e.thickness=th;
endfunction
//  Part 2b --- plot_sphere function ------------------------------------------
function [] = plot_sphere(r,n,d)
    // Copyright (c) York University 2018   Authors: Matthieu D. and Jessie A. 
    // This function plots the surface of a sphere
    // Inputs: r - radius of the sphere [km], n - number of divisions, d - change in size along axes [km] 
    lat = linspace(-%pi/2,%pi/2,n +1);
    lon = linspace(0,2*%pi,n*2 + 1);
    x     = r*(cos(lat)'*cos(lon)) + d(1);
    y     = r*(cos(lat)'*sin(lon)) + d(2);
    z     = r*(sin(lat)'*ones(lon)) + d(3);
    plot3d2(x,y,z);
    e = gce();
    e.color_flag = 2; 
    e.color_mode = 12; // Sets the colour of the surfaces
    e.foreground = 18; // Sets the colour of the lines seperating each surface
    trace_traj(r*[cos(lat);zeros(lat);sin(lat)], F=1, col=16, th=1); // Plots meridian  
    trace_traj(r*[cos(lon);sin(lon);zeros(lon)], F=1, col=16, th=1); // Plots equator
    
    a = gca();
    a.isoview = 'on'; // Changes the view to isometric 
    a.grid = [1 1]; // Adds grid lines to the graphical object
endfunction
//  Part 2c --- Kep2Cart function ---------------------------------------------
function[r,v] = Kep2Cart(coe)
    // Copyright (c) York University 2018   Authors: Matthieu D. and Jessie A.
    // This function converts Keplerian orbital elements to Cartesian position and velocity state vectors
    // Inputs: coe = [semimajor axis, eccentricity, RAAN, inclination, argument of perigee, true anomaly]
    mu   = 398600; // Standard gravitational parameter of the Earth [km]
    a    = coe(1); // Semimajor axis [km]
    e    = coe(2); // Eccentricity 
    RA   = coe(3)*%pi/180; // Right ascension of the ascending node [rad]
    incl = coe(4)*%pi/180; // Inclination [rad]
    w    = coe(5)*%pi/180; // Argument of perigee [rad]
    TA   = coe(6); // True anomaly

    b = sqrt((a^2)*(1 - e^2)); // Computes the semiminor axis
    p = (b^2)/a; // Computes the semilatus rectum
    r_TA = p/(1 + e*cos(TA)); // Computes the magnitude of radius vector
    v_TA = sqrt(mu*((2/r_TA) - (1/a))); // Computes the magnitude of velocity vector
    h = r_TA*v_TA; // Computes the specific angular momentum of the orbit

    rp = (h^2/mu) * (1/(1 + e*cos(TA))) * (cos(TA)*[1;0;0] + sin(TA)*[0;1;0]);
    vp = (mu/h) * (-sin(TA)*[1;0;0] + (e + cos(TA))*[0;1;0]);

    R3_W = [ cos(RA)  sin(RA)  0
    -sin(RA)  cos(RA)  0
    0 0 1];

    R1_i = [1       0          0
    0   cos(incl)  sin(incl)
    0  -sin(incl)  cos(incl)];

    R3_w = [ cos(w)  sin(w)  0
    -sin(w)  cos(w)  0
    0 0 1];

    Q_pX = (R3_w*R1_i*R3_W)';

    r = Q_pX*rp;
    v = Q_pX*vp;

    r = r'; v = v';
endfunction
//  Part 3 --- Creation of the solar system environment -----------------------
//  Part 3a --- Creation of the Earth spheroid --------------------------------
plot_sphere(REarth,50,[0 0 0]) // Plots the Earth as a sphere
xarrows([0 frame],[0 0],[0 0],20000,color(255,179,0)) //Create Sun-Earth vector
//  Part 3b --- Creation of the 'space' environment ---------------------------
//  PART 3c --- Insertion STL model of spacecraft --------------------------------
exec("C:\Users\matth\Documents\SciLab_CelestLab_work\stlfiles\etc\stlfiles.start"); // Execute files needed for STL import, this needs to be changed to fit any user
stlpath = get_absolute_file_path("EarthOrbiterSystem.sce") // Gets the path leading the the desiring STL file, this needs to be changed to fit any user
t = stlread(fullfile(stlpath, "humanoid.stl"), "ascii"); // Imports the STL file
tcolor = 12*ones(1, size(t.x,"c")) // Sets the colour of all surfaces of the file 
[radV,velV] = Kep2Cart(kepCoeff); // Convert the Kepler coefficients to state vector to place the object in the frame
t.x = (t.x*enlarge) + radV(1); // |
t.y = (t.y*enlarge) + radV(2); // | Changes the position of all vertices to place the object in the frame
t.z = (t.z*enlarge) + radV(3); // |
plot3d(-t.x,t.y,list(t.z,tcolor)); // Plots the STL model in the frame
//  Part 3d --- Insertion of the orbital trajectory ---------------------------
rad = zeros(3,length(TA)); // Matrix storing components of radius vector
vel = zeros(3,length(TA)); // Matrix storing components of velocity vector
for i = 1:length(TA)
    kepCoeff(6) = TA(i); // Changes true anomaly
    [rad_hold,vel_hold] = Kep2Cart(kepCoeff); // Convert the Kepler coefficients to state vector to place the object in the frame
    rad(1,i) = rad_hold(1);
    rad(2,i) = rad_hold(2);
    rad(3,i) = rad_hold(3);
end
param3d(rad(1,:),rad(2,:),rad(3,:));

