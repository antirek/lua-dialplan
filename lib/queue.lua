
function queue (dbHelper)

	function call_queue (context, extension)
	    local queue = dbHelper.findQueueByExtension(extension);
	    app.noop('queue:'..queue.name);
	    app.queue(queue.name);
	end;

	return {
		["call_queue"] = call_queue;
	};

end;

-- добавить регистрацию/отрегистрацию операторов

return queue;