//Taken from CelestLab >> - Introduction - > Cookbook > Simple orbital simulation
// We should examine this code and observe how it makes excellent use of the 
// Celestlab functions (instead of re-writing everything ourselves)
//
// =====================================================
// Satellite ephemeris
// The orbit is approximately frozen and Sun-synchronous 
// Initial mean local time of ascending node (MLTAN) = 10h30 
// =====================================================

// Date/time of orbital elements (TREF)
cjd0 = CL_dat_cal2cjd(2013,3,1,12,0,0); 

// Keplerian mean orbital elements, frame = ECI
sma = 7200.e3; // semi major axis
ecc = 1.e-3;   // eccentricity
inc = 98 * %pi/180; // inclination
pom = %pi/2; // Argument of perigee
mlh = 10.5; // MLTAN (hours) (mean local time of ascending node))
gom = CL_op_locTime(cjd0, "mlh", mlh, "ra"); // RAAN
anm = 0; // Mean anomaly

kep0 = [sma; ecc; inc; pom; gom; anm]; 

// Simulation dates/times (duration = 1 day)
cjd = cjd0 + (0 : 30/86400 : 1); 

// Propagate with "lydlp" model (output = osculating elements)
kep = CL_ex_propagate("lydlp", "kep", cjd0, kep0, cjd, "o"); 

// Position and velocity in ECI
[pos_eci, vel_eci] = CL_oe_kep2car(kep); 

// Position in ECF
pos_ecf = CL_fr_convert("ECI", "ECF", cjd, pos_eci); 
 
 
// =====================================================
// Other data
// =====================================================

// Ground stations geodetic coordinates: 
// longitude (rad), latitude (rad), altitude (m)
sta1 = [1.499*%pi/180; 43.43*%pi/180; 154.0]; 
sta2 = [-52.64*%pi/180; 5.1*%pi/180; 94.0]; 

// Earth->Sun and Earth->Moon in ECI 
Sun_eci = CL_eph_sun(cjd); 
Moon_eci = CL_eph_moon(cjd);

// =====================================================
// Ground stations visibility
// =====================================================

// Min elevation for visibility
min_elev = 10 * %pi/180;

// Computation of visibility intervals
[tvisi1] = CL_ev_stationVisibility(cjd, pos_ecf, sta1, min_elev);
[tvisi2] = CL_ev_stationVisibility(cjd, pos_ecf, sta2, min_elev);
 
 
// Plot 
scf();
plot2d3(tvisi1(1,:)-cjd0, (tvisi1(2,:)-tvisi1(1,:))*1440, style=2);
plot2d3(tvisi2(1,:)-cjd0, (tvisi2(2,:)-tvisi2(1,:))*1440, style=5);
xtitle("Visibility duration (mn)", "Days");
h = CL_g_select(gca(), "Polyline"); 
h.thickness = 2; 
CL_g_stdaxes();
CL_g_legend(gca(), ["sta1", "sta2"]); 

// Plot East azimuth <-> elevation for sta1
scf();
for k = 1 : size(tvisi1,2)
  tk = linspace(tvisi1(1,k), tvisi1(2,k), 100); 
  [az, el] = CL_gm_stationPointing(sta1, CL_interpLagrange(cjd, pos_ecf, tk));
  plot(-az*180/%pi, el*180/%pi); 
end
xtitle("Satellite elevation from sta1 (deg)", "East azimuth (deg)");
CL_g_stdaxes();

// =====================================================
// (geocentric) Longitude/latitude plot
// =====================================================

scf(); 

// Plot Earth map
CL_plot_earthMap(color_id=color("seagreen")); 

// Plot ground tracks
CL_plot_ephem(pos_ecf, color_id=color("grey50")); 

// Plot visibility "circles"
// min_elev: min elevation for visibility
// rmin/rmax: min/max satellite radius (from Earth center)
min_elev = 10 * %pi/180;
rmin = min(CL_norm(pos_ecf)); 
rmax = max(CL_norm(pos_ecf)); 
az = linspace(0,2*%pi,100); 

CL_plot_ephem(CL_gm_stationVisiLocus(sta1, az, min_elev, rmin), color_id=2); 
CL_plot_ephem(CL_gm_stationVisiLocus(sta1, az, min_elev, rmax), color_id=2); 
CL_plot_ephem(CL_gm_stationVisiLocus(sta2, az, min_elev, rmin), color_id=5); 
CL_plot_ephem(CL_gm_stationVisiLocus(sta2, az, min_elev, rmax), color_id=5);

// =====================================================
// Sun and Moon  in Satellite frame
// Satellite frame supposed to be "qsw"
// =====================================================

M_eci2sat = CL_fr_qswMat(pos_eci, vel_eci); 

// Satellite->Sun and satellite->Moon directions
Sun_dir = M_eci2sat * CL_unitVector(Sun_eci - pos_eci); 
Moon_dir = M_eci2sat * CL_unitVector(Moon_eci - pos_eci); 
 
 
// Plot angles
f=scf();
plot(cjd-cjd0, CL_vectAngle(Sun_dir, [0;0;-1])*180/%pi, "r", "thickness", 2); 
plot(cjd-cjd0, CL_vectAngle(Moon_dir, [0;0;1])*180/%pi, "b", "thickness", 2); 
xtitle("Angle with satellite frame axis (deg)", "Days"); 
CL_g_legend(gca(), ["Sun <-> -Z", "Moon <-> Z"]); 
CL_g_stdaxes();

// =====================================================
// Eclipse periods of Sun by Earth
// =====================================================

// Eclipse intervals (umbra) 
interv = CL_ev_eclipse(cjd, pos_eci, Sun_eci, typ = "umb");
 
// Plot
scf();

dur = (interv(2,:) - interv(1,:)) * 1440; // min
x = [interv(1,:); interv; interv(2,:); %nan * interv(1,:)] - cjd0; 
y = [zeros(dur); dur; dur; zeros(dur); %nan * ones(dur)]; 
plot(x(:)', y(:)', "thickness", 2); 
xtitle("Time in Earth shadow", "Days", "Length (min)"); 
CL_g_stdaxes();
