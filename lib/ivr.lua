
function ivr (dbHelper)

    function menu (context, extension)
        local menu = dbHelper.findIVRByExtension(extension);
        app.answer();
        app.read('CHOICE', menu.filename);
        local choice = channel['CHOICE']:get();
        app.noop('choice: '..choice);
        if (choice) then
            local i = 1;
            while menu.choices[i] do
                --app.noop(menu.choices[i].key)
                if (menu.choices[i].key == choice) then 
                    break
                end;
                i = i + 1
            end;
            local action = menu.choices[i].action;
            app.noop('action: '..action);
            app["goto"](action);
        end;
    end;

    return {
        ["menu"] = menu;
    };

end;

return ivr;