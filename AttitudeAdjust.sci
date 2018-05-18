// This function will deal with the intial attitude conditions provided by the user. Here the axes of the STL file will be compared to the QSW frame and will be rotated to allignment. This will set the initial orientation of the spacecraft as it is introduced to the space environment.

function [xAtt,yAtt,zAtt] = AttitudeAdjust(xold,yold,zold,alignVec,constVec,r,v)
    clc // Clear any text from the console

    if r == [] & v==[]
        // PART 1: Create the QSW frame 
        qsw_x = alignVec; // Redefine the aligned vector as the x-axis in QSW
        qsw_z = constVec; // Redefine the contrained vector as the z-axis in QSW
        qsw_y = cross(qsw_x,qsw_z); // Calculate a perpendicular y-axis in QSW
        qsw_z = cross(qsw_x,qsw_y); // Calculate a perpendicular z-axis in QSW

        // PART 2: Transform the QSW axes into unit vectors
        qsw_x = qsw_x/norm(qsw_x); // Make the x-axis in QSW a unit vector
        qsw_y = qsw_y/norm(qsw_y); // Make the y-axis in QSW a unit vector
        qsw_z = qsw_z/norm(qsw_z); // Make the z-axis in QSW a unit vector

        // PART 3: Create the transformation matix
        R = [qsw_x;qsw_y;qsw_z]; // Assemble the transformation matrix

        // PART 4: Rotate the stl model to align with QSW {X,Y,Z}
        [row, col] = size(t.x); // Gather the size of the STL data
        xAtt = xold; // Redefine the STL x data for attitude determination use
        yAtt = yold; // Redefine the STL y datafor attitude determination use
        zAtt = zold; // Redefine the STL z datafor attitude determination use
        for i = 1:(row*col) // Initialize for loop to cycle through STL data
            tempOut = R*[xAtt(i);yAtt(i);zAtt(i)]; // Transform the old data point to be alligned with the QSW frame
            xAtt(i) = tempOut(1); // Distribute output into matrices for x components
            yAtt(i) = tempOut(2); // Distribute output into matrices for y components
            zAtt(i) = tempOut(3); // Distribute output into matrices for z components
        end // End for loop
    else
        // PART 1: Create the QSW frame 
        qsw_x = r; // Redefine the aligned vector as the x-axis in QSW
        qsw_z = cross(r,v); // Redefine the contrained vector as the z-axis in QSW
        qsw_y = cross(qsw_x,qsw_z); // Calculate a perpendicular y-axis in QSW
        qsw_z = cross(qsw_x,qsw_y); // Calculate a perpendicular z-axis in QSW

        // PART 2: Transform the QSW axes into unit vectors
        qsw_x = qsw_x/norm(qsw_x); // Make the x-axis in QSW a unit vector
        qsw_y = qsw_y/norm(qsw_y); // Make the y-axis in QSW a unit vector
        qsw_z = qsw_z/norm(qsw_z); // Make the z-axis in QSW a unit vector

        // PART 3: Create the transformation matix
        R = [qsw_x;qsw_y;qsw_z]; // Assemble the transformation matrix

        // PART 4: Rotate the stl model to align with QSW {X,Y,Z}
        [row, col] = size(t.x); // Gather the size of the STL data
        xAtt = xold; // Redefine the STL x data for attitude determination use
        yAtt = yold; // Redefine the STL y datafor attitude determination use
        zAtt = zold; // Redefine the STL z datafor attitude determination use
        for i = 1:(row*col) // Initialize for loop to cycle through STL data
            tempOut = R*[xAtt(i);yAtt(i);zAtt(i)]; // Transform the old data point to be alligned with the QSW frame
            xAtt(i) = tempOut(1); // Distribute output into matrices for x components
            yAtt(i) = tempOut(2); // Distribute output into matrices for y components
            zAtt(i) = tempOut(3); // Distribute output into matrices for z components
        end // End for loop
    end

    //scf(0); // Sets figure no.0 as the current editable 
    //delete("all") // Replots the figure with the new arrow
    //disp(tcolor)
    //plot3d(-xAtt,yAtt,list(zAtt,tcolor)); // Plot newly rotated STL
    //a = gca(); // Get current axis properties
    //a.isoview = 'on'; // Changes the view to isometric 
endfunction
