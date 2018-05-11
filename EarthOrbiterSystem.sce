// EarthOrbiterSystem v 0.0.1
// This program models the orbital trajectory of a CAD model about the Earth
// Authours : Matthieu D. Jessie A. Arvin T.
// Created on 11 May 2018
// Last modified 11 May 2018
// Table of contents 
//  Part 1 : Definition of global variables
//      Part 1a : initialization of orbit related parameters
//      Part 1b : initialization of frame related parameters
//  Part 2 : Definition of proprietary functions
//  Part 3 : Creation of the solar system environment
// celestLab demo are located in C:\Users\matth\AppData\Roaming\Scilab\scilab-5.5.2\atoms\x64\celestlab\3.2.1\demos
clear; clc; clf; // Clear variable list, console, and figures
CL_init(); // Importation of celestLab library   

// Part 1 --- Definition of global variables ----------------------------------
// Part 1a --- initialization of orbit related parameters ---------------------
aa  = 7500;
ec  = 0.01;
in  = 0.00;
ra  = 0.00;
wp  = 0.00;
ta  = 0.00;
KepCoeff = [aa ec in ra wp ta]; // Keplerian elements of the orbit, values are to be retrieved from the user in a later version 
// aa-semimajor axis [km], ec-eccentricity, in-inclination [deg], ra-right ascension of the ascending node [deg], wp-argument of perigee [deg], ta-true anomaly [deg]

// Part 1b --- initialization of frame related parameters ---------------------
AU      = 149597870.700  // Definition of an astronomical unit [km]
RSun    = 695700         // Radius of the Sun [km]
REarth  = 6378           // Radius of the Earht [km]
LSun    = 3.828e26       // Luminosity of the Sun [W/m^2]
frame   = 10e3;          // Dimension of the data bounds [km]


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

//  Part 2b --- trace_sphere function -----------------------------------------
function [] = sphere(r,n,d)
    // Copyright (c) York University 2018   Authors: Matthieu D. and Jessie A. 
    // This function plots the surface of a sphere
    // Inputs: r - radius of the sphere [km], n - number of divisions, d - change in size along axes [km] 
    lat = linspace(-%pi/2,%pi/2,n);
    lon = linspace(0,2*%pi,n);
    x     = r*(cos(lat)'*cos(lon)) + d(1);
    y     = r*(cos(lat)'*sin(lon)) + d(2);
    z     = r*(sin(lat)'*ones(lon)) + d(3);
    plot3d2(x,y,z);
    e = gce();
    e.color_flag = 0; 
    e.color_mode = 12; // Sets the colour of the surfaces
    e.foreground = 18; // Sets the colour of the lines seperating each surface
    trace_traj(r*[cos(lat);zeros(lat);sin(lat)], F=1, col=16, th=1); // Plots meridian  
    trace_traj(r*[cos(lon);sin(lon);zeros(lon)], F=1, col=16, th=1); // Plots equator
endfunction

//  Part 3 --- Creation of the solar system environment -----------------------
//  Part 3a --- Creation of the Earth spheroid --------------------------------

sphere(REarth,50,[0 0 0])
