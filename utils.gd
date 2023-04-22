class_name Utils

## Wait for each provided signal to emit, then call `callback`.
## `callback` must take a single argument in order to be called.
## The argument to `callback` is a 2D array of each signal's parameters, in the order they were provided in `signals`.
static func wait_for_signals(signals: Array[Signal], callback: Callable):
	var finished = {}
	
	for index in signals.size():
		signals[index].connect(
			func(arg1 = null, arg2 = null, arg3 = null, arg4 = null, arg5 = null, arg6 = null, arg7 = null, arg8 = null, arg9 = null): 
				finished[index] = [arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9]
				if finished.keys().size() == signals.size():
					callback.call(finished.values()), 
			CONNECT_ONE_SHOT
		)
