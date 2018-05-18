//Panel Power
//This script will calculate the power produced by the satellite solar panels
//Input: Satellite Model, Attitude, mission time, and panel efficiency
//Output: Power

xVertices = t.x(:,activSurfs) // Gets the x position of the vertices of the solar panel surfaces
yVertices = t.y(:,activSurfs) // Gets the y position of the vertices of the solar panel surfaces
zVertices = t.z(:,activSurfs) // Gets the z position of the vertices of the solar panel surfaces

n = zeros(length(activSurfs),3) // Initialize matrix for storage of normal vectors
for i = 1:length(activSurfs)
    // For each surface this loop computes the normal vector
    xy = [(xVertices(1,i)-xVertices(2,i)) (yVertices(1,i)-yVertices(2,i)) (zVertices(1,i)-zVertices(2,i))]
    xz = [(xVertices(1,i)-xVertices(3,i)) (yVertices(1,i)-yVertices(3,i)) (zVertices(1,i)-zVertices(3,i))]
    yz = [(xVertices(3,i)-xVertices(2,i)) (yVertices(3,i)-yVertices(2,i)) (zVertices(3,i)-zVertices(2,i))]
    n(i,:) = cross(xy,xz)
    n(i,:) = n(i,:)/sqrt(n(i,1)^2 + n(i,2)^2 + n(i,3)^2); // Computes unit vector
   
  Lenxy=norm(xy);// |
  Lenxz=norm(xz);// |Length of each side
  Lenyz=norm(yz);// |
  surfp=(Lenxy+Lenxz+Lenyz)/2;// Half the Perimeter
  SurfArea(i)=sqrt(surfp*(surfp-Lenxy)*(surfp-Lenxz)*(surfp-Lenyz));//Heron's Formula for Area of a triangle
end


//Parameters
S=1366; // [W/m^2] (later change this to function of time)
nu = strtod('5_text6'); //Panel efficiency
//Changing the solar constant to match dimensions of the satellite
if      crntUnitState(1,1) == 1 then
    panelunits='m';
    //S=1366 [W/m^2]
else if crntUnitState(1,2) == 1 then
    panelunits='cm';
    S = S*1e-4; //[W/cm^2]
else
    panelunits='mm';
    S = S*1e-6; //[W/mm^2]           
end
end
//Step 1: Find Area of Solar Panel surfaces
//  I have SurfArea, storing Area of each panel surface
//Step 2: Find Surace Normal Vector
//  I have n , storing the normal for each panel surface
//Step 3: Find Satellite-Sun Vector
//Earth-Sun in ECI
// we have pos_sun = CL_eph_sun(cjd);
//Earth-Sat in ECI
// we have pos_eci
//Sat-Sun in ECI
sat_sun_eci = pos_sun - pos_eci;
//Sat-Sun in QSW
sat_sun_qsw = CL_fr_inertial2qsw(pos_eci,vel_eci,sat_sun_eci)
//Step 4: Compute with P= nu*S*A*cos(theta)
PowerSurf = []; //empty array, power computed by each surface
for i = 1: length(activSurfs)
    for t = 1: length(pos_eci)
    VF = (CL_dot(n(1),sat_sun_qsw(1))/(norm(n(1))*norm(sat_sun_qsw(1)))); //View factor from surface to sun
    PowerSurf(i,t) = nu*S*SurfArea(i)*VF; //Power of each surface at each time step
    end
end



