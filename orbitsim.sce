//orbit sim.sce
//This code will simulate the orbit of a POINT about the Earth
// *all "!!" comments are notes to self for improvement
//written by Arvin T., adapted from structure by Jessie A.
//for the CHESSER SUMMER 2018
//
//     changelog
//version 0.2 May 11th 2018
//  debugged, fixed eccentric anomaly calculation
//version 0.3 May 11th 2018 -2:18 PM
//-J2 perturbation and orbit precessions
//-GUI for user input
//-more detailed comments


clear
function[r, v] = sv_from_coe(coe)
    //this function determines the position and velocity of the satellite 
    //from the classical orbital elements
mu   = 398600;
h    = coe(1);
e    = coe(2);
RA   = coe(3)*%pi/180;
incl = coe(4)*%pi/180;
w    = coe(5)*%pi/180;
TA   = coe(6);


rp = (h^2/mu) * (1/(1 + e*cos(TA))) * (cos(TA)*[1;0;0] + sin(TA)*[0;1;0]);
vp = (mu/h) * (-sin(TA)*[1;0;0] + (e + cos(TA))*[0;1;0]);

//Rotation matrix about the z-axis through the angle w
R3_W = [ cos(RA)  sin(RA)  0
        -sin(RA)  cos(RA)  0
         0        0        1];
//Rotation matrix about the x-axis through the angle i
R1_i = [1       0          0
        0   cos(incl)  sin(incl)
        0  -sin(incl)  cos(incl)];
//Rotation matrix about the z-axis through the angle RA
R3_w = [ cos(w)  sin(w)  0
        -sin(w)  cos(w)  0
         0       0       1];
//Matrix of the transformation from perifocal to geocentric
Q_pX = (R3_w*R1_i*R3_W)';

r = Q_pX*rp;
v = Q_pX*vp;
//make them into row vectors
r = r'; v = v';
endfunction
    

function [E] = kepler_E(e, M)

//This function uses Newton's method to solve Kepler's
//equation  E - e*sin(E) = M  for the eccentric anomaly,
//given the eccentricity and the mean anomaly.


//error tolerance:
xerror = 1.e-9;

if M < %pi
    E = M + e/2;
else
E = M - e/2;
end

ratio = 1;
while abs(ratio) > xerror
    ratio = (E - e*sin(E) - M)/(1 - e*cos(E));
E = E - ratio;
end
endfunction


//------------Earth Parameters
//AU=149597870.700;//[km]
//G=6.674e-2;//[km^3 kg^-1 s^-2]
//M_earth=5.972e24;//[kg]
R_earth=6378;//avg radius, [km]
mu=398600// [km^3 s^-2]
w = 7.292115e-5;//angular rotation of earth [rad/s]
R_pole = 6356.8;
f = (R_earth-R_pole)/(R_earth);
J2 = ((2*f)/(3))-((R_earth^3*w^2)/(3*mu));

//------------Orbital Elements 
//GUI prompt for user to input orbit information
//default values for the ISS orbit

desc=list(..
CL_defParam("Eccentricity", val=0.0003293),..
CL_defParam("inclination",val=51.6397,units=['deg']),..
CL_defParam("RAAN", val=196.5549,units=['deg']),..
CL_defParam("Argument of Perigee",val=67.2970,units=['deg']),..
CL_defParam("Revolutions per day",val=15.54247857),..
CL_defParam("Mean anomaly at epoch",val=292.8531,units=['deg']));
[e, i, RAAN,omega,n,M, OK] = CL_inputParam(desc) 
 
//------------Calculated Elements
a = (mu/(2*%pi*n/86400)^2)^(1/3);
T = 2*%pi*sqrt(a^3/mu);
rp = a*(1-e);
h = (mu*rp*(1+e))^(1/2);
E = kepler_E(M,e);
theta= acos((cos(E)-e)/(1-e*cos(E)));
dRAAN = -1*((3*sqrt(mu)*J2*R_earth^2)/(2*(1-e^2)^2*a^(7/2)))*cosd(i);
domega = dRAAN*(5/2 * sind(i)^2 - 2)/cosd(i);

//------------Trajectory Simulation
desc=list(..
CL_defParam("How many revolutions to simulate through? ", val=1));..
[orb] = CL_inputParam(desc)
orb = orb*T;

//Loop Parameters
dt = 5;//timestep
ti = 0;//time index
j =  1;//index
while(ti <= orb);
    theta = theta + 2*%pi/T*dt;
    RAAN  = RAAN  +  180/(%pi)*dRAAN*dt ; // |Precession
    omega = omega + 180/(%pi)*domega*dt;  // |
    coe = [h, e, RAAN, i, omega, theta];
    [R, V] = sv_from_coe(coe);

    fi_earth = w*ti;
    Rot = [cos(fi_earth), sin(fi_earth),0;
          -sin(fi_earth),cos(fi_earth), 0;
           0,            0,             1];
    R = Rot*R';
    ti = ti+dt;
    Rv(j,:) = R';
    j = j+1;
end
//plot
param3d(Rv(:,1),Rv(:,2),Rv(:,3));




