class_name Utils

## Wait for each provided signal to emit, then call `callback`.
## `callback` must take a single argument in order to be called.
## The argument to `callback` is a 2D array of each signal's parameters, in the order they were provided in `signals`.
static func wait_for_signals(signals: Array[Signal], callback: Callable):
	var finished = []
	
	# Have to do this ugly stuff for now, probably until GDScript supports variadic functions:
	# https://github.com/godotengine/godot-proposals/issues/1034
#	var fired = func(arg1 = null, arg2 = null, arg3 = null, arg4 = null, arg5 = null, arg6 = null, arg7 = null, arg8 = null, arg9 = null): 
#		finished.push_back([arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9])
#		finished.insert()
#		if finished.size() == signals.size():
#			callback.call_deferred(finished)
			
#	var create_connection = func(index):
#		signals[index].connect(fired, CONNECT_ONE_SHOT)
		
	
	for index in range(signals.size() - 1):
		signals[index].connect(
			func(arg1 = null, arg2 = null, arg3 = null, arg4 = null, arg5 = null, arg6 = null, arg7 = null, arg8 = null, arg9 = null): 
				finished.insert(index, [arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9])
				print(finished)
				if finished.size() == signals.size():
					callback.call_deferred(finished), 
			CONNECT_ONE_SHOT
		)
