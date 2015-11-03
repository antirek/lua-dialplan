local inspect = require('inspect');

return function (dbHelper)

    function time (context, extension)
        local date = os.date("*t");
        app.noop('day: '..date["day"]);
        local time = dbHelper.findTimeByExtension(extension);
        app.noop('baserules: '..inspect(time.baserules));
        for i, rule in ipairs(time.baserules) do 
            if (rule.day == date["wday"]) then 
                app["goto"](rule.target);
            end; 
        end;

        app["goto"](time.default);
    end;

    return {
        ["time"] = time;
    };
end;