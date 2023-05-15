extends Label

func _process(delta: float) -> void:
	var timeDict =  Time.get_datetime_dict_from_system()
	if timeDict['minute'] < 10:
		text = str(timeDict['hour'])+ ":0" + str(timeDict['minute'])
	else:
		text = str(timeDict['hour'])+ ":" + str(timeDict['minute'])
