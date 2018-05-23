//clear; clc; clf

body = 'Earth';
// other possible bodies, Mercury, Venus, Earth, Moon, Mars, Jupiter, Saturn, Uranus, Neptune, Pluto?

deff("[x,y,z]=sph(alp,tet)",[..
"x = r*cos(alp).*cos(tet)+orig(1)*ones(tet)";..
"y = r*cos(alp).*sin(tet)+orig(2)*ones(tet)";..
"z = r*sin(alp)+orig(3)*ones(tet)"]);

r = 6378; // Radius of the Earth [km]
orig = [0 0 0];
div = 150; // Number of divisions, affect resolution of sphere 
[xx,yy,zz]=eval3dp(sph,linspace(-%pi/2,%pi/2,div),linspace(0,%pi*2,div));
[row col] = size(zz);
colour = zeros(1,col);
im = imread(pwd()+'\land_shallow_topo_2048.jpg');
//im = imread(pwd()+'\19113660_10212876050593648_171937706493449871_n.jpg');
imSize = size(im);

// Compute the latitude and longtide of each surface using the first vertex
tic()
lat = acos(zz(2,:)/r)*(180/%pi);
lon = (atan(yy(2,:),xx(2,:)) + %pi)*(180/%pi);
imLat = round(lat*imSize(1)/180) + 1;
imLon = round(lon*imSize(2)/360);

for i = 1:col
    r = strtod(string(im(imLat(i),imLon(i),1))); // to change from 1x1 to scalar
    g = strtod(string(im(imLat(i),imLon(i),2)));
    b = strtod(string(im(imLat(i),imLon(i),3)));
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
h = get("hdl") //get handle on current entity (here the surface)
h.color_mode = -1;
