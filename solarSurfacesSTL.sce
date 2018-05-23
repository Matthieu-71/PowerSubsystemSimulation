aSWriteIndex = 1; // Counter object, used to store the current write index of the active surfaces
alignVec = zeros(1,3); // Object saving the direction vector of the orbit normal
constVec = zeros(1,3); // Object saving the direction vector of the radial outward
crntUnitState = zeros(1,3); // Object saving the states of the units of the model

function [eff] = efficiency()
    eff = strtod(h_edit1.string);
    if eff < 0 | eff > 1 then
        error(9,'Incorrect efficiency value!');
    end
    disp(eff)
endfunction

function [activSurfs, deactSurfs,aSWriteIndex,tcolor] = onRightButton(activSurfs, deactSurfs,aSWriteIndex,t,tcolor)
    // This function moves a surface from the left listbox to the right one, ei. a surface becomes a solar panel
    moveRight = h_deact.value; // Gets the ID of the surface that needs to be moved
    tcolor(deactSurfs(moveRight)) = 9; // Sets the colour of the surface to that of solar panels
    scf(0); // Sets figure no.0 as the current editable 
    plot3d(-t.x,t.y,list(t.z,tcolor)); // Plots the model with the new colour
    a = gca();
    a.isoview = 'on'; // Changes the view to isometric 
    activSurfs(aSWriteIndex) =  deactSurfs(moveRight); // Adds the surface to the list of active ones
    deactSurfs(moveRight) = []; // Removes the surface from the list of deactive ones
    deactSurfs = mtlb_sort(deactSurfs); // Sorts the deactSurfs array
    activSurfs = mtlb_sort(activSurfs); // Sorts the activSurfs array
    s = []; // Resets the string
    for i = 1:length(deactSurfs)
        // Makes the new list to output to the left listbox
        s = s + msprintf('@surface %0.0f |',deactSurfs(i)),
    end
    set(h_deact, 'string', s) // Sets the new list to the left listbox
    s = []; // Resets the string
    for i = 1:length(activSurfs)
        if activSurfs(i) ~= 0
            // Makes the new list to output to the right listbox
            s = s + msprintf('@surface %0.0f |',activSurfs(i)),
        end
    end
    set(h_activ, 'string', s) // Sets the new list to the right listbox
    aSWriteIndex = aSWriteIndex + 1; // Increments the counter object
endfunction

function [activSurfs, deactSurfs,aSWriteIndex,tcolor] = onLeftButton(activSurfs, deactSurfs,aSWriteIndex,t,tcolor)
    // This function moves a surface from the right listbox to the left one, ei. a surface no longer is a solar panel
    moveLeft = h_activ.value; // Gets the ID of the surface that needs to be moved
    tcolor(activSurfs(moveLeft)) = 12; // Sets the colour of the surface to the default colour
    scf(0); // Sets figure no.0 as the current editable 
    plot3d(-t.x,t.y,list(t.z,tcolor)); // Plots the model with the new colour
    a = gca();
    a.isoview = 'on'; // Changes the view to isometric 
    deactSurfs(activSurfs(moveLeft)) = activSurfs(moveLeft); // Adds the surface to the list of deactive ones
    activSurfs(moveLeft) = []; // Removes the surface from the list of active ones
    deactSurfs = mtlb_sort(deactSurfs); // Sorts the deactSurfs array
    activSurfs = mtlb_sort(activSurfs); // Sorts the activSurfs array
    s = []; // Resets the string
    for i = 1:length(deactSurfs)
        if deactSurfs(i) ~= 0
            // Makes the new list to output to the left listbox
            s = s + msprintf('@surface %0.0f |',deactSurfs(i)),
        end
    end
    set(h_deact, 'string', s) // Sets the new list to the left listbox
    s = []; // Resets the string
    for i = 1:length(activSurfs)
        if activSurfs(i) ~= 0
            // Makes the new list to output to the right listbox
            s = s + msprintf('@surface %0.0f |',activSurfs(i)),
        end
    end
    set(h_activ, 'string', s) // Sets the new list to the right listbox
    aSWriteIndex = aSWriteIndex - 1; // Decrements the counter object
endfunction

function [x] = onEndButton()//(crntUnitState,alignVec,constVec)
    // This function allows the user to proceed to the next step of the program
    if norm(crntUnitState) == 0 then
        error(5,'No units selected!');
        x = 0;
    elseif norm(alignVec) == 0 then
        error(6,'Aligned vector is undefined!');
        x = 0;
    elseif norm(constVec) == 0 then
        error(7,'Constraint vector is undefined!');
        x = 0;
    elseif activSurfs == [] then
        error(8,'No solar panels!');
        x = 0;
    else
        x = 1; // Variable needed to proceed to next
        close(g); // Closes the solar panel selector GUI
    end
endfunction

function [] = deactiveSelect(t,tcolor,deactSurfs)
    // This function executes when an item is selected from the left listbox
    // Changes the colour of the selected surface so that the user knows where it is located
    moveRight = h_deact.value; // Gets the ID of the surface to highlight
    tcolor(deactSurfs(moveRight)) = 10; // Changes the colour of the surface 
    scf(0); // Sets figure no.0 as the current editable 
    plot3d(-t.x,t.y,list(t.z,tcolor)); // Plots the model with the new colour
    a = gca();
    a.isoview = 'on'; // Changes the view to isometric 
endfunction

function [] = activeSelect(t,tcolor,activSurfs)
    // This function executes when an item is selected from the right listbox
    // Changes the colour of the selected surface so that the user knows where it is located
    moveLeft = h_activ.value; // Gets the ID of the surface to highlight
    tcolor(activSurfs(moveLeft)) = 11; // Changes the colour of the surface 
    scf(0); // Sets figure no.0 as the current editable 
    plot3d(-t.x,t.y,list(t.z,tcolor)); // Plots the model with the new colour
    a = gca();
    a.isoview = 'on'; // Changes the view to isometric 
endfunction

function [alignVec] = saveRadDir()
    // This function retrieves the components of the radial outward direction and stores them in the appropriate object 
    x = strtod(h_edit2.string); // Retrieves x component from GUI
    y = strtod(h_edit3.string); // Retrieves y component from GUI
    z = strtod(h_edit4.string); // Retrieves z component from GUI
    alignVec = [x y z];

    scf(0); // Sets figure no.0 as the current editable 
    delete("all") // Replots the figure with the new arrow
    plot3d(-t.x,t.y,list(t.z,tcolor)); 
    xarrows([0 x],[0 y],[0 z],10,3); // Plots the new arrow
    xarrows([0 constVec(1)],[0 constVec(2)],[0 constVec(3)],10,2);
    a = gca();
    a.isoview = 'on'; // Changes the view to isometric 
endfunction

function [constVec] = saveOrbDir()
    // This function retrieves the components of the orbit normal direction and stores them in the appropriate object 
    x = strtod(h_edit5.string); // Retrieves x component from GUI
    y = strtod(h_edit6.string); // Retrieves y component from GUI
    z = strtod(h_edit7.string); // Retrieves z component from GUI
    constVec = [x y z];

    scf(0); // Sets figure no.0 as the current editable 
    delete("all") // Replots the figure with the new arrow
    plot3d(-t.x,t.y,list(t.z,tcolor)); 
    xarrows([0 x],[0 y],[0 z],10,2); // Plots the new arrow
    xarrows([0 alignVec(1)],[0 alignVec(2)],[0 alignVec(3)],10,3);
    a = gca();
    a.isoview = 'on'; // Changes the view to isometric 
endfunction

function [crntUnitState] = unitRadioButton(crntUnitState)
    // This function is executed when a radiobutton for units is selected
    // It gets the ID of the chosen radiobutton and sets the other to zero
    isM  = h_metre.value; // |
    isCM = h_centi.value; // | Gets the states of the radiobuttons
    isMM = h_milli.value; // |
    nextState =  [isM isCM isMM] - crntUnitState; // Determines the new state
    for i = 1:3
        // Issues arise if a same radiobutton is selected and then deselected
        // This loop fixes this
        if nextState(i) < 0
            nextState(i) = 0;
        elseif nextState(i) > 1
            nextState(i) = 0;
        end
    end
    set(h_metre,'value',nextState(1)); // | 
    set(h_centi,'value',nextState(2)); // | Sets the radiobuttons to their new state
    set(h_milli,'value',nextState(3)); // |
    crntUnitState = nextState;
endfunction

t = stlread(stlFilePath,isBinary); // Reads the STL file designated in the previous GUI
// t.header = "string", changes the string at the begining of the STL file
// t.x(i j) to access values in the x matrix 

//figure
if inUsed == 1 then
    // In the case that an input file is provided, tcolor is initialized using it 
    load(inFilePath,'tcolor','alignVec','constVec');
elseif inUsed == 0 then
    // in the (default) case that no input file is provided, tcolor is intialized with the default colour
    tcolor = 12*ones(1, size(t.x,"c"));
end
// 1 = black | 2 = blue | 3 = green |4 = cyan | 5 = red | 6 = magenta | 7 = yellow 
// 8 = white | 9-12 = shades of blue | 13-15 = shades of green | 16-18 = shades of cyan
// 19-21 = shades of red | 22-24 = shades of purple | 25-27 = shades of brown 
// 28-31 = shades of pink | 32 = yellow | above integers are clear

scf(0); // Sets figure no.0 as the current editable 
plot3d(-t.x,t.y,list(t.z,tcolor)); // Plots the model
f = get("current_figure") // Gets the handle of the current figure window
scrnSize = get(0, "screensize_px"); // Gets the user's screen size
f.figure_position = [scrnSize(3)/2 0]; // Sets the figure at the top and towards the middel of the user's screen
a = gca()
a.isoview = "on" // Sets the graphic window to an isometric view


// --- Creation GUI to select solar panel faces ---------------------

// The property: style style The available styles are listed below. The style of an uicontrol must be set at creation using the “style" property and can not be changed once the uicontrol is created. 
// Checkbox: a button with two states (Used for multiple independent choices). 
// Edit: an editable string zone. 
// Frame: a container for other uicontrols or axes. 
// Image: a component where a specified image is displayed.
// Listbox: a control representing a list of items that can be scrolled. The items can be selected with the mouse. 
// Popupmenu: a button which make a menu appear when clicked. 
// Pushbutton: a rectangular button generally used to run a callback. 
// Slider: a scale control, that is a slider used to set values between in range with the mouse. 
// Spinner: a component which enables the user to select/edit a value between bounds with a fixed step. 
// Table: an editable table. 
// Text: a text control.
// Radiobutton: a button with two states.  

g = figure(); // Creates a figure for the GUI
g.screen_position = [0 0]; // Sets the position to the top left corner of the user's screen
g.axes_size =  [800 500]; // Sets the size of the screen to x = 800 px and y = 500 px

// --- Definition of uicontrol objects ------------------------------
h_title  = uicontrol(g,'style','text', 'position', [0 440 350 60]); // GUI object for title
h_text1  = uicontrol(g,'style','text', 'position', [0 400 350 40]); // GUI object for description sentence
h_text2  = uicontrol(g,'style','text', 'position', [350 460 200 40]); // GUI object for deactive panel listbox label
h_text3  = uicontrol(g,'style','text', 'position', [600 460 200 40]); // GUI object for active panel listbox label
h_text4  = uicontrol(g,'style','text', 'position', [0 80 175 30]); // GUI object for radial outward surface prompt
h_text5  = uicontrol(g,'style','text', 'position', [0 50 175 30]); // GUI object for orbit normal surface prompt
h_text6  = uicontrol(g,'style','text', 'position', [0 380 290 20]); // GUI object for panel efficiency prompt
h_text7  = uicontrol(g,'style','text', 'position', [175 110  35 20], 'string', 'X','horizontalalignment', 'center'); // GUI object for X column
h_text8  = uicontrol(g,'style','text', 'position', [215 110  35 20], 'string', 'Y','horizontalalignment', 'center'); // GUI object for Y column
h_text9  = uicontrol(g,'style','text', 'position', [255 110  35 20], 'string', 'Z','horizontalalignment', 'center'); // GUI object for Z column
h_text10 = uicontrol(g,'style','text', 'position', [  0 360 180 20]); // GUI object for area units promt

h_edit1 = uicontrol(g,'style','edit', 'position', [290 380 60 20], 'horizontalalignment', 'center', 'callback','[eff] = efficiency()'); // GUI object for entering panel efficiency
h_edit2 = uicontrol(g,'style','edit', 'position', [175  80 35 30], 'horizontalalignment', 'center','string', msprintf("%0.0f",alignVec(1))); // GUI object for entering radial X component
h_edit3 = uicontrol(g,'style','edit', 'position', [215  80 35 30], 'horizontalalignment', 'center','string', msprintf("%0.0f",alignVec(2))); // GUI object for entering radial Y component
h_edit4 = uicontrol(g,'style','edit', 'position', [255  80 35 30], 'horizontalalignment', 'center','string', msprintf("%0.0f",alignVec(3))); // GUI object for entering radial Z component
h_edit5 = uicontrol(g,'style','edit', 'position', [175  50 35 30], 'horizontalalignment', 'center','string', msprintf("%0.0f",constVec(1))); // GUI object for entering orbit normal X component
h_edit6 = uicontrol(g,'style','edit', 'position', [215  50 35 30], 'horizontalalignment', 'center','string', msprintf("%0.0f",constVec(2))); // GUI object for entering orbit normal Y component
h_edit7 = uicontrol(g,'style','edit', 'position', [255  50 35 30], 'horizontalalignment', 'center','string', msprintf("%0.0f",constVec(3))); // GUI object for entering orbit normal Z component

h_activ = uicontrol(g,'style','listbox','position', [600   0 200 460],'callback', 'activeSelect(t,tcolor,activSurfs)') // GUI object for active panel listbox
h_deact = uicontrol(g,'style','listbox','position', [350   0 200 460],'callback', ' deactiveSelect(t,tcolor,deactSurfs)') // GUI object for deactive panel listbox
h_metre = uicontrol(g,'style','radiobutton','position', [180 360  50  20],'string','m' ,'callback','[crntUnitState] = unitRadioButton(crntUnitState)'); // GUI object for m  radiobutton
h_centi = uicontrol(g,'style','radiobutton','position', [230 360  50  20],'string','cm','callback','[crntUnitState] = unitRadioButton(crntUnitState)'); // GUI object for cm radiobutton
h_milli = uicontrol(g,'style','radiobutton','position', [280 360  50  20],'string','mm','callback','[crntUnitState] = unitRadioButton(crntUnitState)'); // GUI object for mm radiobutton

h_pushR = uicontrol(g,'style','pushbutton','position', [550 250  50 50],'callback', '[activSurfs, deactSurfs,aSWriteIndex,tcolor] = onRightButton(activSurfs, deactSurfs,aSWriteIndex,t,tcolor)') // GUI object for moving object right 
h_pushL = uicontrol(g,'style','pushbutton','position', [550 200  50 50],'callback', '[activSurfs, deactSurfs,aSWriteIndex,tcolor] = onLeftButton(activSurfs, deactSurfs,aSWriteIndex,t,tcolor)') // GUI object for moving object left
h_pushE = uicontrol(g,'style','pushbutton','position', [  0   0 350 50],'callback', '[x] = onEndButton()'); // GUI object for pushbutton to next step
h_radSt = uicontrol(g,'style','pushbutton','position', [290  80  60 30],'callback', '[alignVec] = saveRadDir()'); // GUI object for saving radial outward direction
h_orbSt = uicontrol(g,'style','pushbutton','position', [290  50  60 30],'callback', '[constVec] = saveOrbDir()'); // GUI object for saving orbit normal direction

// --- Definition of uicontrol object properties --------------------
set(h_title, 'string', 'Solar Panel Surface Selector', 'fontsize', 24,'horizontalalignment', 'center'); // Writes the title

set(h_text1, 'string', msprintf('There are %0.0f surfaces in total, select the ones that are solar panels',length(tcolor))); // Writes the description sentence 
set(h_text2, 'string', 'Non-solar-panel surfaces', 'fontsize', 16,'horizontalalignment', 'center'); // Writes the header of the left listbox
set(h_text3, 'string', 'Solar panel surfaces', 'fontsize', 16,'horizontalalignment', 'center'); // Wrties the header of the right listbox
set(h_text4, 'string', ' Zenith Direction : ', 'fontsize', 12); // Wrties the prompt for the radial outward surface 
set(h_text5, 'string', ' Orbit Normal direction : ', 'fontsize', 12); // Wrties the prompt for the orbit normal surface 
set(h_text6, 'string', ' Solar Panel Efficiency, number between 0 and 1 : ', 'fontsize', 12); // Wrties the prompt for the panel efficiency
set(h_text10,'string', 'Select the units of the model : ', 'fontsize', 12); // Wrties the prompt for area units

set(h_pushR, 'string', '>>'); // Writes to the right pushbutton
set(h_pushL, 'string', '<<'); // Writes to the left pushbutton
set(h_pushE, 'string', ' End Selection Process'); // Write to the end pushbutton
set(h_radSt, 'string', 'Save' ) // Writes to pushbutton
set(h_orbSt, 'string', 'Save' ) // Writes to pushbutton

// --- Initialization of surface related objects and uicontrols -----
allSurface = 1:1:length(tcolor); // Initializes the allSurface array, this object stores the IDs of all the surface on the spacecraft
deactSurfs = 1:1:length(tcolor); // Initializes the deactSurfs array, this object stores the IDs of the surfaces that are not solar panels
activSurfs = []; // Initializes the activSurfs array, this object stores the IDs of the surface that are solar panels 
for i = 1:length(tcolor)
    // If the colour of a surface is not the default, removes it from the deactSurfs array and adds it to the activSurfs
    // Needed when an input file is used
    if tcolor(i) ~= 12
        activSurfs(aSWriteIndex) = deactSurfs(i); // Adds to the activSurfs array
        aSWriteIndex = aSWriteIndex + 1; // Increments counter object
    end
end
deactSurfs(activSurfs) = []; // Removes the said surfaces from deactSurfs
deactSurfs = mtlb_sort(deactSurfs); // Sorts the deactSurfs array
activSurfs = mtlb_sort(activSurfs); // Sorts the activSurfs array

s = []; // Resets the string 
for i = 1:length(deactSurfs)
    if deactSurfs(i) ~= 0
        // Makes the new list to output to the left listbox
        s = s + msprintf('@surface %0.0f |',deactSurfs(i)),
    end
end
set(h_deact, 'string', s) // Sets the new list to the left listbox

s = []; // Resets the string 
for i = 1:length(activSurfs)
    if activSurfs(i) ~= 0
        // Makes the new list to output to the right listbox
        s = s + msprintf('@surface %0.0f |',activSurfs(i)),
    end
end
set(h_activ, 'string', s) // Sets the new list to the right listbox

s = []; // Resets the string 
for i = 1:length(allSurface)
    // Makes the new list to output to the direction listboxs
    s = s + msprintf('@s %0.0f |',allSurface(i)),
end
