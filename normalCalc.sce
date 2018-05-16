clc
// normalCalc v 0.0.1
// This script computes the normals of the surface selected a solar panels
// Authour : Matthieu D. 
// Created on 16 May 2018
// Last modified 16 May 2018
// Table of contents 
//  Part 1 : Definition of variables

//  Part 2 : Definition of proprietary functions

//  Part 3 : Creation of the solar system environment



//  Part 1 --- Definition of variables ------------------------------
clear xVertices
// Expecting the following : 
//      x : -10 -10 -10 -10  10  10  10  10
//      y :   1   1 -19 -19   1   1 -19 -19
//      z :  -9  11  11  -9  11  11  -9  11
xVertices = t.x(:,activSurfs)
yVertices = t.y(:,activSurfs)
zVertices = t.z(:,activSurfs)
disp(xVertices)
disp(yVertices)
disp(zVertices)

n = zeros(length(activSurfs),3)
for i = 1:length(activSurfs)
    xy = [(xVertices(1,i)-xVertices(2,i)) (yVertices(1,i)-yVertices(2,i)) (zVertices(1,i)-zVertices(2,i))]
    xz = [(xVertices(1,i)-xVertices(3,i)) (yVertices(1,i)-yVertices(3,i)) (zVertices(1,i)-zVertices(3,i))]
    n(i,:) = cross(xy,xz)
    n(i,:) = n(i,:)/sqrt(n(i,1)^2 + n(i,2)^2 + n(i,3)^2);
    disp(n(i,:))
end

