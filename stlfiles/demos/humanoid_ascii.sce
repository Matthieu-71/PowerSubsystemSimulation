clear; clc;
aSWriteIndex = 1;

function [activSurfs, deactSurfs,aSWriteIndex,tcolor] = onRightButton(activSurfs, deactSurfs,aSWriteIndex,t,tcolor)
    moveRight = h_deact.value;
    tcolor(deactSurfs(moveRight)) = 9;
    scf(0);
    plot3d(-t.x,t.y,list(t.z,tcolor));
    activSurfs(aSWriteIndex) =  deactSurfs(moveRight);
    deactSurfs(moveRight) = [];
    deactSurfs = mtlb_sort(deactSurfs);
    activSurfs = mtlb_sort(activSurfs);
    s = [];
    for i = 1:length(deactSurfs)
        s = s + msprintf('@surface %0.0f |',deactSurfs(i)),
    end
    set(h_deact, 'string', s)
    s = [];
    for i = 1:length(activSurfs)
        if activSurfs(i) ~= 0
            s = s + msprintf('@surface %0.0f |',activSurfs(i)),
        end
    end
    set(h_activ, 'string', s)
    aSWriteIndex = aSWriteIndex + 1;
endfunction

function [activSurfs, deactSurfs,aSWriteIndex,tcolor] = onLeftButton(activSurfs, deactSurfs,aSWriteIndex,t,tcolor)
    moveLeft = h_activ.value;
    s = msprintf('Actually surface %0.0f is not a solar panel',deactSurfs(moveLeft));
    tcolor(activSurfs(moveLeft)) = 12;
    scf(0);
    plot3d(-t.x,t.y,list(t.z,tcolor));
    deactSurfs(activSurfs(moveLeft)) = activSurfs(moveLeft);
    activSurfs(moveLeft) = [];
    deactSurfs = mtlb_sort(deactSurfs);
    activSurfs = mtlb_sort(activSurfs);
    s = [];
    for i = 1:length(deactSurfs)
        if deactSurfs(i) ~= 0
            s = s + msprintf('@surface %0.0f |',deactSurfs(i)),
        end
    end
    set(h_deact, 'string', s)
    s = [];
    for i = 1:length(activSurfs)
        if activSurfs(i) ~= 0
            s = s + msprintf('@surface %0.0f |',activSurfs(i)),
        end
    end
    set(h_activ, 'string', s)
    aSWriteIndex = aSWriteIndex - 1;

    //disp(activSurfs)
endfunction

function [] = deactiveSelect(t,tcolor,deactSurfs)
    moveRight = h_deact.value;
    tcolor(deactSurfs(moveRight)) = 10;
    scf(0);
    plot3d(-t.x,t.y,list(t.z,tcolor));
endfunction

function [] = activeSelect(t,tcolor,activSurfs)
    moveLeft = h_activ.value;
    tcolor(activSurfs(moveLeft)) = 11;
    scf(0);
    plot3d(-t.x,t.y,list(t.z,tcolor));
endfunction


exec("C:\Users\matth\Documents\SciLab_CelestLab_work\stlfiles\etc\stlfiles.start");
stlpath = get_absolute_file_path("humanoid_ascii.sce")
t = stlread(fullfile(stlpath, "humanoid.stl"), "ascii");
// t.header = "string", changes the string at the begining of the STL file
// t.x(i j) to access values in the x matrix 

figure
tcolor = 12*ones(1, size(t.x,"c"))
// 1 = black | 2 = blue | 3 = green |4 = cyan | 5 = red | 6 = magenta | 7 = yellow 
// 8 = white | 9-12 = shades of blue | 13-15 = shades of green | 16-18 = shades of cyan
// 19-21 = shades of red | 22-24 = shades of purple | 25-27 = shades of brown 
// 28-31 = shades of pink | 32 = yellow | above integers are clear

plot3d(-t.x,t.y,list(t.z,tcolor));

a = gca()
a.isoview = "on"
vec = [0, 0, 0];
dims = a.data_bounds; //  [xmin,ymin,zmin;xmax,ymax,zmax]
xmin = dims(1,1); xmax = dims(2,1);
ymin = dims(1,2); ymax = dims(2,2);
zmin = dims(1,3); zmax = dims(2,3);

//while 1~= 0 
//    vec = xgetmouse()
//    if vec(1) <= xmax & vec(1) >= xmin & vec(2) <= ymax & vec(2) >= ymin 
//        xline = [0 vec(1)];
//        yline = [0 vec(2)];
//        zline = [0 0];
//        colour = [1 1]
//vec = xclick();
//disp(vec);
//        str = [msprintf("%0.5f, %0.5f ",vec(1),vec(2))];
//        xtitle(str)
//plot3d(xline,yline,list(zline, colour));
//    end
//    if vec(3) == -1000 // -1000 = close graphic window
//        break
//    end
//end

solarP = 1:1:20;

//for i = 1:length(t.z)
//    for j = 1:length(solarP)
//        if i == solarP(j)
//            tcolor(i) = 9;
//        end
//    end
//end
//plot3d(-t.x,t.y,list(t.z,tcolor));
//a = gca()
//a.isoview = "on"

// Creation GUI to select solar panel faces

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

f = figure(); // create a figure
f.screen_position = [0 0];
f.axes_size =  [1000 500];
// Definition of uicontrol objects --------------------------------------------
h_title = uicontrol(f,'style','text', 'position', [0 440 350 60]); // GUI object for title
h_text1 = uicontrol(f,'style','text', 'position', [0 400 350 40]); // GUI object for description sentence
h_text2 = uicontrol(f,'style','text', 'position', [350 460 200 40]); // GUI object for deactive panel listbox label
h_text3 = uicontrol(f,'style','text', 'position', [600 460 200 40]); // GUI object for active panel listbox label
h_activ = uicontrol(f,'style','listbox','position', [600 0 200 460],'callback', 'activeSelect(t,tcolor,activSurfs)') // GUI object for active panel listbox
h_deact = uicontrol(f,'style','listbox','position', [350 0 200 460],'callback', ' deactiveSelect(t,tcolor,deactSurfs)') // GUI object for deactive panel listbox
h_pushR = uicontrol(f,'style','pushbutton','position', [550 250 50 50],'callback', '[activSurfs, deactSurfs,aSWriteIndex,tcolor] = onRightButton(activSurfs, deactSurfs,aSWriteIndex,t,tcolor)') // GUI object for pushbutton moving object from left to right 
h_pushL = uicontrol(f,'style','pushbutton','position', [550 200 50 50],'callback', '[activSurfs, deactSurfs,aSWriteIndex,tcolor] = onLeftButton(activSurfs, deactSurfs,aSWriteIndex,t,tcolor)') // GUI object for pushbutton moving object from right to left

// Definition of uicontrol object properties ----------------------------------
set(h_title, 'string', 'Solar Panel Surface Selector', 'fontsize', 24,'horizontalalignment', 'center');
set(h_text1, 'string', msprintf('There are %0.0f surfaces in total, select the ones that are solar panels',length(tcolor)));
set(h_text2, 'string', 'All non-panel surfaces', 'fontsize', 16,'horizontalalignment', 'center');
set(h_text3, 'string', 'All panel surfaces', 'fontsize', 16,'horizontalalignment', 'center');

deactSurfs = 1:1:length(tcolor);
activSurfs = [];//]zeros(1,length(tcolor));
s = [];
for i = 1:length(tcolor)
    if deactSurfs(i) ~= 0
        s = s + msprintf('@surface %0.0f |',deactSurfs(i)),
    end
end
//disp(deactSurfs);
set(h_deact, 'string', s)
set(h_pushR, 'string', '>>');
set(h_pushL, 'string', '<<');
