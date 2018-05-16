function []=%stldata_p(l)
    mprintf(" Summary\n   Header:    %s\n", l(2))
    mprintf("   #faces:    %d triangles\n", size(l(3), "c"))
    mprintf("   #vertices: %d (non unique)\n\n", size(l(3), "c")*3)
    n = 5
    mprintf(" Vertices coordinates [x y z] (first %d only)\n", n)
    mprintf("   %.5f %.5f %.5f\n", [l.x(1:n) l.y(1:n) l.z(1:n)])
    n = 5
    mprintf("   ...\n\n Normals coordinates [x y z] (first %d only)\n", n)
    mprintf("   %.5f %.5f %.5f\n", [l.normals(1:n) l.normals(1:n) l.normals(1:n)])
    mprintf("   ...\n")
endfunction
