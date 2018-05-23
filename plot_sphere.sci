deff("[x,y,z] = sph(alp,tet)",[..
"x = r*cos(alp).*cos(tet)+orig(1)*ones(tet)";..
"y = r*cos(alp).*sin(tet)+orig(2)*ones(tet)";..
"z = r*sin(alp)+orig(3)*ones(tet)"]);

select bodyStr
case 'Mercury'
    im = imread(pwd()+'\Images\1_Mercury_ooglobal_view_MESSENGER.jpg');
    r = CL_dataGet("body.Mercury.eqRad")/1000;
case 'Venus'
    im = imread(pwd()+'\Images\2_Venus_ven0aaa2.jpg');
    r = CL_dataGet("body.Venus.eqRad")/1000;
case 'Earth'
    im = imread(pwd()+'\Images\3_Earth_land_shallow_topo_2048.jpg');
    r = CL_dataGet("body.Earth.eqRad")/1000;
case 'Moon'
    im = imread(pwd()+'\Images\4_Moon_2k_moon.jpg');
    r = CL_dataGet("body.Moon.eqRad")/1000;
case 'Mars'
    im = imread(pwd()+'\Images\5_Mars_mar0kuu2.jpg');
    r = CL_dataGet("body.Mars.eqRad")/1000;
case 'Jupiter'
    im = imread(pwd()+'\Images\6_Jupiter_jup0vss1.jpg');
    r = CL_dataGet("body.Jupiter.eqRad")/1000;
case 'Saturn'
    im = imread(pwd()+'\Images\7_Saturn_sat0fds1.jpg');
    r = CL_dataGet("body.Saturn.eqRad")/1000;
case 'Uranus'
    im = imread(pwd()+'\Images\8_Uranus2k_uranus.jpg');  
    r = CL_dataGet("body.Uranus.eqRad")/1000;
case 'Neptune'
    im = imread(pwd()+'\Images\9_Neptune_nep0fds1.jpg');  
    r = CL_dataGet("body.Neptune.eqRad")/1000;
case 'Pluto'
    im = imread(pwd()+'\Images\10_Pluto_plu0rss1.jpg');
    r = CL_dataGet("body.Pluto.eqRad")/1000;
end
imSize = size(im); // Gets the size of the image, in terms of pixels

orig = [0 0 0]; // Origin of the sphere
div = 100; // Number of divisions, affects resolution of sphere 
[xx,yy,zz] = eval3dp(sph,linspace(-%pi/2,%pi/2,div),linspace(0,%pi*2,div)); // Computes the vertices for the sphere's surfaces 
[row col] = size(zz); // Get number of surface (ei. columns)
colour = zeros(1,col); // Initialize the array to store colour values

tic() // Start watchdog timer
lat = acos(zz(2,:)/r)*(180/%pi); // Computes latitude of each surface
lon = (atan(yy(2,:),xx(2,:)) + %pi)*(180/%pi); // Computes longitude of each surface
imLat = round(lat*imSize(1)/180) + 1; // Translates latitude to a x position
imLon = round(lon*imSize(2)/360); // Translates longitude to a y position 

for i = 1:col
    r = strtod(string(im(imLat(i),imLon(i),1))); // 
    g = strtod(string(im(imLat(i),imLon(i),2))); // -- get RGB value for the pixel, need to convert 1x1 to integer
    b = strtod(string(im(imLat(i),imLon(i),3))); //
    colour(i) = color(r,g,b); // Using the RGB values, get the color ID sciLab can use and add it to the colour map

    if (i-fix(i./1000).*1000) == 0
        // Counter to display the percentage of colour that are computed
        clc(1)
        s = msprintf('Percentage computed : %0.0f',(i*100/col)); // Compute percentage computed
        disp(s)
    end
end
compTime = toc(); // Get current timer value 

clf(); 
plot3d(xx,yy,list(zz,colour))
a = gca();
a.isoview = 'on'; // Changes the view to isometric 
h = get("hdl") //get handle on current entity (here the surface)
h.color_mode = -1; // Hides the boundaries between surfaces
