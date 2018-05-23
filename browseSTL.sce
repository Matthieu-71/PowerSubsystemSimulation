function [stlFilePath] = stlEdit()
    // This function changes the file path of the STL file when the editable respective textbox is manipulated
    stlFilePath  = h_edit1.string; // Sets the new filepath to the string object
endfunction

function [outFilePath] = outEdit()
    // This function changes the file path of the output file when the respective editable textbox is manipulated
    outFilePath  = h_edit2.string; // Sets the new filepath to the string object
endfunction

function [inFilePath] = inEdit()
    // This function changes the file path of the input file when the respective editable textbox is manipulated
    inFilePath  = h_edit3.string; // Sets the new filepath to the string object
endfunction

function [stlFilePath] = browseSTLfile(crntPath)
    // This function allows the user to browse the local directories for an STL file
    stlFilePath = uigetfile('*.stl',crntPath); // Opens the current directory for the user to browse 
    set(h_edit1, 'string', stlFilePath, 'fontsize', 12); // Displays the new file path to the respective field
endfunction

function [outFilePath] = browseOUTfile(crntPath)
    // This function allows the user to browse the local directories for an output file
    outFilePath = uigetfile('*.txt',crntPath); // Opens the current directory for the user to browse 
    set(h_edit2, 'string', outFilePath, 'fontsize', 12); // Displays the new file path to the respective field
endfunction

function [inFilePath] = browseINfile(crntPath)
    // This function allows the user to browse the local directories for an input file
    inFilePath = uigetfile('*.txt',crntPath); // Opens the current directory for the user to browse 
    set(h_edit3, 'string', inFilePath, 'fontsize', 12); // Displays the new file path to the respective field
endfunction

function [isBinary] = binCheckBox(isBinary)
    // This function is called when the checkbox for the binary format is used 
    val = h_bnSlt.value // Gets the state of the checkbox
    if val == 1 then
        // If the value is 1 then sets the format to binary 
        isBinary = 'binary';
    elseif val == 0 then 
        // If the value is 0 then sets the format to ascii
        isBinary = 'ascii';
    else
        // Displays an error message if the format is unspecified
        error(1,'Incorrect format selected!');
    end
endfunction

function [inUsed] = inpCheckBox(inUsed)
    // This function is called when the checkbox for the input file presence is used 
    inUsed = h_inSlt.value // Sets the value of the checkbox to the object storing the presence of an input file 
endfunction

function [Xanimate] = inpCheckBox(Xanimate)
    // This function is called when the checkbox for the animation presence is used 
    Xanimate = h_inSlt.value // Sets the value of the checkbox to the object
endfunction


function [x] = nextButton(outFilePath,inFilePath,stlFilePath,inUsed)
    // This function is called when the user pushed the next button, it runs a few checks and allows the program to proceed to the next step
    suffix = part(stlFilePath,(length(stlFilePath)-3:length(stlFilePath))); // Gets the suffix of the stlFilePath
    if suffix == ".stl" then
        // If the suffix is .stl, then the check object is set to one
        runCheck = 1;
    else
        // If the suffix is not .stl, then the check object is set to zero and an error message is displayed
        error(2,'File is not in an STL format!');
        runCheck = 0;
    end

    if inUsed == 1 then
        // This nested if-loop runs iff an input file is used
        suffix = part(inFilePath,(length(inFilePath)-3:length(inFilePath))); // Gets the suffix of the inFilePath
        if suffix == ".txt" then
            // If the suffix is .txt, then the check object is set to one
            runCheck = 1;
        else
            // If the suffix is not .txt, then the check object is set to zero and an error message is displayed
            error(3,'File is not in an txt format!');
            runCheck = 0;
        end
    end


    suffix = part(outFilePath,(length(outFilePath)-3:length(outFilePath))); // Gets the suffix of the outFilePath
    if suffix == ".txt" then
        // If the suffix is .txt, then the check object is set to one
        runCheck = 1;
    else
        // If the suffix is not .txt, then the check object is set to zero and an error message is displayed
        error(4,'File is not in an txt format!');
        runCheck = 0;
    end
    
    //disp(runCheck)
    if runCheck == 1 then
        x = 1;
        close(f)
        //exec C:\Users\matth\Documents\SciLab_CelestLab_work\STL_solarPanelSelect.sce;
//        path1 = strcat([crntPath,"STL_solarPanelSelect.sce"])
//        //disp(path1)
//        exec(path1)
    end
endfunction

function [Xanimate] = aniCheckBox(Xanimate)
    Xanimate = h_anSlt.value;
    disp(Xanimate)
endfunction


x = 0;
crntPath = get_absolute_file_path("browseSTL.sce"); // String of the path where this program is located
inFilePath  = crntPath; // Initializes the input file path to the current path, just so that it has a value
outFilePath = crntPath; // Initializes the output file path to the current path, just so that it has a value
stlFilePath = crntPath; // Initializes the STL file path to the current path, just so that it has a value
isBinary = 'ascii'; // The format of the STL file, by default ascii
inUsed = 0; // Indicates if an input file is used, if == 0 then no input file is used, if == 1 then an input file is used.
Xanimate = 0; // Inidicates if the user wants the orbit animation to be shown, if ==0 not shown.

f = figure(); // Creates a figure
f.screen_position = [0 0]; // Sets the GUI to appear at the top left of the screen
f.axes_size =  [600 200]; // Sets the size of the GUI window
// Definition of uicontrol objects --------------------------------------------
h_title = uicontrol(f,'style','text', 'position', [0 180 600 20]); // GUI object for title
h_text1 = uicontrol(f,'style','text', 'position', [0 160 100 20]); // GUI object for STL file path prompt
h_edit1 = uicontrol(f,'style','edit', 'position', [100 160 425 20],'callback', '[stlFilePath] = stlEdit()'); // GUI object for STL path definition 
h_push1 = uicontrol(f,'style','pushbutton', 'position', [525 160 75 20],'callback', '[stlFilePath] = browseSTLfile(crntPath)'); // GUI object for STL file path browse
h_text2 = uicontrol(f,'style','text', 'position', [0 100 100 20]); // GUI object for output file path prompt
h_edit2 = uicontrol(f,'style','edit', 'position', [100 100 425 20],'callback', '[outFilePath] = outEdit()'); // GUI object for output file path definition 
h_push2 = uicontrol(f,'style','pushbutton', 'position', [525 100 75 20],'callback', '[outFilePath] = browseOUTfile(crntPath)'); // GUI object for output file path browse
h_texta = uicontrol(f,'style','text', 'position', [0 140 600 20]); // GUI object for explanation to output file
h_textb = uicontrol(f,'style','text', 'position', [0 120 600 20]); // GUI object for explanation to output file
h_text3 = uicontrol(f,'style','text', 'position', [0 80 100 20]); // GUI object for input file path prompt
h_edit3 = uicontrol(f,'style','edit', 'position', [100 80 425 20],'callback', '[inFilePath] = inEdit()'); // GUI object for input file path definition 
h_push3 = uicontrol(f,'style','pushbutton', 'position', [525 80 75 20],'callback', '[inFilePath] = browseINfile(crntPath)'); // GUI object for output file path browse
h_text4 = uicontrol(f,'style','text', 'position', [0 60 280 20]); // GUI object for STL format prompt
h_text5 = uicontrol(f,'style','text', 'position', [0 40 280 20]); // GUI object for input file presence prompt
h_text6 = uicontrol(f,'style','text', 'position', [0 20 280 20]); // GUI object for animation prompt
h_bnSlt = uicontrol(f,'style','checkbox', 'position', [280 60 20 20], 'callback', '[isBinary] = binCheckBox(isBinary)'); // GUI object to indicate binary format
h_inSlt = uicontrol(f,'style','checkbox', 'position', [280 40 20 20], 'callback', '[inUsed] = inpCheckBox(inUsed)'); // GUI object to indicate presence of input file
h_anSlt = uicontrol(f,'style','checkbox', 'position', [280 20 20 20], 'callback', '[Xanimate] = aniCheckBox(Xanimate)'); // GUI object to indicate animation desire
h_push4 = uicontrol(f,'style','pushbutton','position', [525 20 75 60],'callback', '[x] = nextButton(outFilePath,inFilePath,stlFilePath,inUsed)'); // GUI object for the pushbutton allowing access to the next part of the program

// Definition of uicontrol object properties ----------------------------------
set(h_title, 'string', 'Simulation files selector', 'fontsize', 14,'horizontalalignment', 'center'); // Writes the header of the 
set(h_texta, 'string', 'The output file is used to store the values of the surfaces that are solar panels. If one already exists, select both the input'); // Explanation for the input and output files
set(h_textb, 'string', 'and the output file. The files must be of .txt format.'); // Part two of the explanation

set(h_text1, 'string', 'STL file path:', 'fontsize', 12); // Prompt for the STL file path
set(h_edit1, 'string', crntPath, 'fontsize', 12); // Default value of the STL file path
set(h_push1, 'string', 'Browse', 'fontsize', 12); // Writes browse to the push button 

set(h_text2, 'string', 'Output file path:', 'fontsize', 12); // Prompt for the output file path
set(h_edit2, 'string', crntPath, 'fontsize', 12); // Default value of the output file path
set(h_push2, 'string', 'Browse', 'fontsize', 12); // Writes browse to the push button 

set(h_text3, 'string', 'Input file path:', 'fontsize', 12); // Prompt for the input file path
set(h_edit3, 'string', crntPath, 'fontsize', 12); // Default value of the input file path
set(h_push3, 'string', 'Browse', 'fontsize', 12); // Writes browse to the push button 

set(h_text4, 'string', 'Check this box if the STL file is in binary format :', 'fontsize', 12); // Prompt for the STL format checkbox
set(h_text5, 'string', 'Check this box if an input file is used : ', 'fontsize', 12); // Prompt for the input file presence checkbox
set(h_text6, 'string', 'Check this box for animation of the orbit : ', 'fontsize', 12); // Prompt for the animation desire checkbox

set(h_push4, 'string', 'Next', 'fontsize', 12); // Write next to the push button
