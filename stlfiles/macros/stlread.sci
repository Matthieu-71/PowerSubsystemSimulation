function t = stlread(filename, fmt)

    [lhs,rhs] = argn(0);
    if rhs < 2 then
        error("Not enough input argument")
    end

    if type(filename) <> 10 | type(fmt) <> 10 then
        error("Arguments must be strings")
    end

    if isfile(filename) == %f then
        error("File not found");
    end

    if members(fmt, ["ascii" "binary"]) == 0 then
        error("Second argument must be ascii or binary")
    end

    t = tlist(["stldata", "header", "x", "y", "z", "normals"], "", [], [], [], [])

    if strcmp(fmt, "ascii", "i") == 0 then

        fd = mopen(filename, "rt")
        [err, msg] = merror(fd)
        if (err <> 0) then 
            error(msg)
        end

        txt = mgetl(fd)

        mclose(fd)

        txt = stripblanks(txt)

        t.header = txt(1)
        if strcmp(part(t.header, 1:5), "solid") == 0 then
            t.header = part(t.header, 7:$)
        end

        res = strstr(txt, "facet normal")

        idx = length(res)<>0

        t.normals = msscanf(-1, res(idx), "facet normal %f%f%f")

        t.normals = matrix(t.normals, 3, -1)

        res = strstr(txt, "vertex ")

        idx = length(res)<>0

        [n, t.x, t.y, t.z] = msscanf(-1, res(idx), "vertex %f%f%f")

        t.x = matrix(t.x, 3, -1)
        t.y = matrix(t.y, 3, -1)
        t.z = matrix(t.z, 3, -1)

    else

        fd = mopen(filename, "rb")
        [err, msg] = merror(fd)
        if (err <> 0) then 
            error(msg)
        end

        t.header = mgetstr(80, fd)

        N = mgeti(1, "i", fd)

        M = zeros(1, 12*N)

        for n = 1:N
            M(12*(n-1)+1:12*n) = mget(12, "f", fd)
            mseek(2, fd, "cur")
        end

        mclose(fd)

        t.normals = [M(1:12:$) ; M(2:12:$) ; M(3:12:$)]

        t.x = [M(4:12:$) ; M(7:12:$) ; M(10:12:$)]
        t.y = [M(5:12:$) ; M(8:12:$) ; M(11:12:$)]
        t.z = [M(6:12:$) ; M(9:12:$) ; M(12:12:$)]

    end

endfunction
