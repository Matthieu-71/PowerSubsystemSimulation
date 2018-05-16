function buildmacros()
    macros_path = get_absolute_file_path("buildmacros.sce");
    tbx_build_macros(TOOLBOX_NAME, macros_path);
endfunction

buildmacros();
clear buildmacros; // remove buildmacros on stack
