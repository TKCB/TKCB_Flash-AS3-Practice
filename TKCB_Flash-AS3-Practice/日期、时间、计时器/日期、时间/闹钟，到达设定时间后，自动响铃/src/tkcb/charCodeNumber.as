package tkcb{
	
	// 使用这个函数时需如下类
	import flash.events.KeyboardEvent;
	
	/**
	 * charCodeNumber 全局函数，将键盘按下的键转化为对应的数字，这个函数只针对数字
	 * @param eveNumber 事件，包含键盘按下键的信息
	 * @return 按下键对应的数字
	 * @author TKCB
	 * Creation date 2012-05-27
	 * Modified by ...
	 * Modified date ...
	 */
	public function charCodeNumber(eveNumber:KeyboardEvent):uint
	{
		// 判断按下的键
		switch(eveNumber.charCode)
		{
			// 根据按下的相应键，返回相应的数字
			case 48:
				return 0; 
			case 49:
				return 1; 
			case 50:
				return 2; 
			case 51:
				return 3; 
			case 52:
				return 4; 
			case 53:
				return 5; 
			case 54:
				return 6; 
			case 55:
				return 7; 
			case 56:
				return 8; 
			case 57:
				return 9; 
		}
		
		// 我也不知道为什么要这样写，但是不这样写就是无法编译通过
		return 0;
	}
}

