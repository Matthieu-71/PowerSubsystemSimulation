function stlwrite(t, filename, fmt)

    [lhs,rhs] = argn(0);
    if rhs < 3 then
        error("Not enough input argument")
    end

    if type(t) <> 16 then
        error("First argument must be a typed list (tlist)")
    end

    if strcmp(typeof(t), 'stldata') <> 0 then
        error("First argument must be a stldata tlist")
    end

    if type(filename) <> 10 then
        error("File name must be a string")
    end

    if type(fmt) <> 10 then
        error("STL file format must be a string")
    end

    if members(fmt, ["ascii" "binary"]) == 0 then
        error("...")
    end

    if strcmp(fileext(filename), ".stl") <> 0 then
        filename = filename + ".stl"
    end

    if strcmp(fmt, "ascii", "i") == 0 then

        fd = mopen(filename, "wt")
        [err, msg] = merror(fd)
        if (err <> 0) then 
            error(msg)
        end

        if strcmp(part(t.header, 1:5), "solid") <> 0 then
            mfprintf(fd, "solid %s\n", t.header)
        else
            mfprintf(fd, "%s\n", t.header)
        end

        for n = 1:size(t.x, "c")

            mfprintf(fd, ..
            " facet normal %f %f %f\n  outer loop\n   vertex %f %f %f\n   vertex %f %f %f\n   vertex %f %f %f\n  endloop\n endfacet\n", ..
            t.normals(1,n), t.normals(2,n), t.normals(3,n), ..
            t.x(1,n), t.y(1,n), t.z(1,n), ..
            t.x(2,n), t.y(2,n), t.z(2,n), ..
            t.x(3,n), t.y(3,n), t.z(3,n))

        end

        mfprintf(fd, "endsolid")

        mclose(fd)

    else

        fd = mopen(filename,"wb")
        [err, msg] = merror(fd)
        if (err <> 0) then 
            error(msg)
        end

        if strcmp(part(t.header, 1:5), "solid") == 0 then
            t.header = part(t.header, 7:$)
            mputstr(part(t.header, 7:86), fd)
        else
           mputstr(part(t.header, 1:80), fd) 
        end

        mput(size(t.x, "c"), "ui", fd)

        for n = 1:size(t.x, "c")
            mput([t.normals(1,n) t.normals(2,n) t.normals(3,n)], "f", fd)
            mput([t.x(1,n) t.y(1,n) t.z(1,n)], "f", fd)
            mput([t.x(2,n) t.y(2,n) t.z(2,n)], "f", fd)
            mput([t.x(3,n) t.y(3,n) t.z(3,n)], "f", fd)
            mput(0 , "us", fd)
        end

        mclose(fd)

    end

endfunction
