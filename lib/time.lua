return function (dbHelper)

    function time (context, extension)
        local time = dbHelper.findTimeByExtension(extension);        
        app["goto"](time.default);
    end;

    return {
        ["time"] = time;
    };
end;