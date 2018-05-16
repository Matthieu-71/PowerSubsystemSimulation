// EarthOrbiterSystem v 0.0.3
// This program models the orbital trajectory of a CAD model about the Earth
// Authours : Arvin T. Matthieu D. Jessie A. 
// Created on 11 May 2018
// Last modified 14 May 2018
// Table of contents 
//  Part 1 : Definition of global variables
//      Part 1a : initialization of orbit related variables
//      Part 1b : initialization of frame related variables
//      Part 1c : time and perturbation related parameters
//      Part 1d : initialization of 3D spacecraft model related variables
//  Part 2 : Definition of proprietary functions
//      Part 2a : trace_traj function
//      Part 2b : plot_sphere function
//  Part 3 : Creation of the solar system environment
//      Part 3a : Creation of the Earth spheroid
//      Part 3b : Creation of the 'space' environment
//      Part 3c : Insertion of the orbital trajectory
//      PART 3d : Insert STL model of spacecraft
//      Part 3e : Motion of the satellite
// celestLab demo are located in C:\Users\matth\AppData\Roaming\Scilab\scilab-5.5.2\atoms\x64\celestlab\3.2.1\demos
clear; clc; clf; // Clear variable list, console, and figures
CL_init(); // Importation of celestLab library   
// Part 1 --- Definition of global variables ----------------------------------
// Part 1a --- initialization of orbit related parameters ---------------------
// This part promts the user to input the Keplerian orbital element, by default the program uses that of the ISS
desc = list(..
CL_defParam("Semimajor axis",           val = 6782.4744,   units=['km']),..
CL_defParam("Eccentricity",             val = 0.0003293),..
CL_defParam("Inclination",              val = 51.6397,     units=['deg']),..
CL_defParam("RAAN",                     val = 196.5549,   units=['deg']),..
CL_defParam("Argument of Perigee",      val = 67.2970, units=['deg']),..
CL_defParam("Mean anomaly at epoch",    val = 292.8531,   units=['deg']));
[aa, ec, in, ra, wp, ma] = CL_inputParam(desc) 
TA  = linspace(ma*%pi/180,ma*%pi/180 + 2*%pi,1000); // True anomaly values for one orbit [rad]
//kepCoeff0 stores the elements in this specific order for the J2 function,
//aa is required to be in metres and all angles in radians
// (we should consider changing the user input to radians and m, although this may be inconvenient for the user...)
kepCoeff0 = [aa*(1e3); ec; in*(%pi)/180; wp*(%pi)/180; ra*(%pi)/180; ma*(%pi)/180]; // Keplerian elements of the orbit
// aa-semimajor axis [km], ec-eccentricity, in-inclination [deg], ra-right ascension of the ascending node [deg], wp-argument of perigee [deg], ma-mean anomaly [deg]
// Part 1b --- initialization of frame related parameters ---------------------
// Use the celestLab constants for these
AU      = CL_dataGet("au")/10^3  // Definition of an astronomical unit [km]
RSun    = 695700                 // Radius of the Sun [km]
REarth  = 6378                   // Radius of the Earth [km]
LSun    = 3.828e26               // Luminosity of the Sun [W/m^2]
frame   = 10e3;                  // Dimension of the data bounds [km]
// Part 1c----time and perturbation related parameters-------------------------
//prompt the user for mission start time, date, and duration
desc2 = list(..
CL_defParam("Year",val = 2018),..
CL_defParam("Start Month",val=5),..//Month is an integer value, 1-Jan,2-Feb etc...
CL_defParam("Day",val=15),..
CL_defParam("Hour",val=12),..
CL_defParam("Minute",val=0),..
CL_defParam("Second",val=0),..
CL_defParam("Mission Duration",val=1,units=['days']),..
CL_defParam("Time Step",val=30,units=['seconds']));//time steps of under 30 seconds may strain weaker computers
[YYYY, MM, DD, HH,tMin,tSec,xduration,tstep] = CL_inputParam(desc2);
 
//cjd0-Mission Start Date
cjd0 = CL_dat_cal2cjd(YYYY,MM,DD,HH,tMin,tSec);//Calendar date to modified Julian Day
//cjd is 1xn array, where n is number of timesteps throughout mission duration
cjd = cjd0 + (0 : tstep/86400 : xduration);

//input initial orbital elements into J2 Perturbation model
//Output is a 6xn array of orbital elements, for n timesteps of mission duration
// i.e stores the changing trajectory at each timestep
kepCoeff= CL_ex_propagate("j2sec", "kep", cjd0, kepCoeff0, cjd, "m"); // "m" for mean, may be changed to "o" for osculating
kepCoeff(1,:)=kepCoeff(1,:)/1000;//restoring semi major axis to kilometres, to keep with dimensions of section 1b
// Part 1d --- initialization of variables related to the 3D model of the spacecraft
enlarge = 10; // Enlargement factor to increase the volume of the model
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

//  Part 3 --- Creation of the solar system and simulation --------------------
//  Part 3a --- Creation of the Earth spheroid --------------------------------
plot_sphere(REarth,50,[0 0 0]) // Plots the Earth as a sphere
//  Part 3b --- Creation of the 'space' environment ---------------------------
xarrows([0 frame],[0 0],[0 0],20000,color(255,179,0)) //Create Sun-Earth vector
//  Part 3c --- Insertion of the orbital trajectory ---------------------------
rad = zeros(3,length(TA)); // Matrix storing components of radius vector
vel = zeros(3,length(TA)); // Matrix storing components of velocity vector
for i = 1:length(TA)
    kepCoeff(6) = TA(i); // Changes true anomaly
    [rad_hold,vel_hold] = CL_oe_kep2car(kepCoeff); // Convert the Kepler coefficients to state vector to place the object in the frame
    rad(1,i) = rad_hold(1); // |
    rad(2,i) = rad_hold(2); // | Sets the values just component to their space in the radius array
    rad(3,i) = rad_hold(3); // |
end
kepCoeff(6) = ma; // Changes true anomaly back to initial value
param3d(rad(1,:),rad(2,:),rad(3,:)); // Plots the entire orbit
//  PART 3d --- Insertion STL model of spacecraft --------------------------------
exec("C:\Scilab\stlfiles\etc\stlfiles.start"); // Execute files needed for STL import, this needs to be changed to fit any user
stlpath = get_absolute_file_path("EarthOrbiterSystem.sce") // Gets the path leading the the desiring STL file, this needs to be changed to fit any user
t = stlread(fullfile(stlpath, "aboutOrigin.stl"), "binary"); // Imports the STL file
tcolor = 12*ones(1, size(t.x,"c")) // Sets the colour of all surfaces of the file 
[radV,velV] = CL_oe_kep2car(kepCoeff); // Convert the Kepler coefficients to state vector to place the object in the frame
xIns = (t.x*enlarge) - radV(1,1); // |
yIns = (t.y*enlarge) + radV(2,1); // | Changes the position of all vertices to place the object in the frame
zIns = (t.z*enlarge) + radV(3,1); // |
plot3d(-xIns,yIns,list(zIns,tcolor)); // Plots the STL model in the frame
// Part 3e --- Motion of the satellite ----------------------------------------
    for i = 1:length(radV) // For mission duration
        delete() // Deletes the last graphical element
        xIns = (t.x*enlarge) - radV(1,i); // |
        yIns = (t.y*enlarge) + radV(2,i); // | Changes the position of all vertices to place the object in the frame
        zIns = (t.z*enlarge) + radV(3,i); // |
        h = gca(); // Gets the current graphic axes
        h.auto_clear = "off"; // Equivalent of MATLAB's hold on command
        plot3d(-xIns,yIns,list(zIns,tcolor)); // Plots the STL model in the frame
        h.isoview="on";//easier on the eyes, isometric view of plot
        sleep(16.66667) // Pauses the loop for 16.6-7 ms (60 Hz animation)
    end
end
