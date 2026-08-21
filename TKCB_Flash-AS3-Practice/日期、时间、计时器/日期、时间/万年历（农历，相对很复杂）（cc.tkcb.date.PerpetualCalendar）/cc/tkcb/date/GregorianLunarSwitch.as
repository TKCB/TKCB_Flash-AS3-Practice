/*
 * 原作者的注释信息：
 * @1900-2100区间内的公历、农历互转
 * @charset  UTF-8
 * @Author  Jea杨(JJonline@JJonline.Cn) 
 * @Time    2014-7-21 
 * @Time    2016-8-13 Fixed 2033hex、Attribution Annals
 * @Version 1.0.1
 * @公历转农历：solar2lunar(1987,11,01); //[you can ignore params of prefix 0]
 * @农历转公历：lunar2solar(1987,09,10); //[you can ignore params of prefix 0]
 */

/*
 * 作　　者：TKCB
 * 作者信息：身高（0.00167公里+）；体重（0.06吨±）；年龄（公元1990后）；籍贯（有兵马俑的地方）；星座（最后一个星座）；血型（万能型）；人生格言（The king come back.）。
 * 交流学习：加QQ群[AS3殿堂之路]（96759336）,群里有无数主城、架构、妹子、LOL战友，欢迎交流讨论。
 * 联系方式：QQ（2414268040）；E-mail（tkcb@qq.com）；手机（15029932353)。
 * 个人网站：www.tkcb.cc（来这里关注我吧，这里有我所有的作品，分享的资料，我的介绍和动态，还有更多你想不到的）
 */


package cc.tkcb.date
{
	
	
	/**
	 * GregorianLunarSwitch 公历农历相互转换类，可以获取万年的公历（阳历）信息，和1900-2100年的农历（阴历）信息，可以公历和农历互转
	 * @author TKCB（www.tkcb.cc）
	 * @创建时间 2016-9-20
	 * @修改时间 2016-9-23
	 */
	public class GregorianLunarSwitch
	{
		//************************ ************************* 静态属性 ******************** *********** *** **////
		/** 单例类的唯一实例对象 */
		private static var _instance : GregorianLunarSwitch;
		
		
		//************************ ************************* 静态方法 ******************** *********** *** **////
		/**
		 * 获取唯一的单例类实例对象
		 * @return 返回单例类实例对象
		 */
		public static function getInstance () : GregorianLunarSwitch
		{
			if (_instance == null)
			{
				_instance = new GregorianLunarSwitch(new GregorianLunarSwitchGregorianLunarSwitch());
			}
			return _instance;
		}
		
		//************************ ************************* 属性 ******************** *********** *** **////
		/** 农历1900-2100的润大小信息表 */
		private var lunarInfo : Array;
		
		/** 公历每个月份的天数普通表 */
		private var solarMonth : Array;
		
		/** 天干地支速查表，天干 */
		private var Gan : Array;
		
		/** 天干地支速查表，地支 */
		private var Zhi : Array;
		
		/** 天干地支速查表，生肖 */
		private var Animals : Array;
		
		/** 二十四节气速查表 */
		private var solarTerm : Array;
		
		/** 1900-2100年，二十四节气日期速查表 */
		private var sTermInfo : Array;
		
		/** 数字转中文速查表 */
		private var nStr1 : Array;
		
		/** 日期转农历称呼速查表 */
		private var nStr2 : Array;
		
		/** 月份转农历称呼速查表 */
		private var nStr3 : Array;
		
		/** 小时转时辰称呼速查表 */
		private var nStr4 : Array;
		
		/** 小时转(更/夜)称呼速查表 */
		private var nStr5 : Array;
		
		/** 星座名称速查表 */
		private var constellation : String;
		
		
		
		//************************ ************************* 构造函数 ******************** *********** *** **////
		/**
		 * 构造函数，单例类不需要使用构造函数进行new创建，而是通过getInstance方法进行唯一的单例类创建和获取访问。
		 */
		public function GregorianLunarSwitch ( enforcer:GregorianLunarSwitchGregorianLunarSwitch )
		{
			init();
		}
		
		
		//************************ ************************* 初始化 ******************** *********** *** **////
		/**
		 * 对象初始化
		 */
		private function init () : void
		{
			// 农历1900-2100的润大小信息表
			lunarInfo = [ 0x04bd8,0x04ae0,0x0a570,0x054d5,0x0d260,0x0d950,0x16554,0x056a0,0x09ad0,0x055d2,	// 1900-1909
						  0x04ae0,0x0a5b6,0x0a4d0,0x0d250,0x1d255,0x0b540,0x0d6a0,0x0ada2,0x095b0,0x14977,		// 1910-1919
						  0x04970,0x0a4b0,0x0b4b5,0x06a50,0x06d40,0x1ab54,0x02b60,0x09570,0x052f2,0x04970,		// 1920-1929
						  0x06566,0x0d4a0,0x0ea50,0x06e95,0x05ad0,0x02b60,0x186e3,0x092e0,0x1c8d7,0x0c950,		// 1930-1939
						  0x0d4a0,0x1d8a6,0x0b550,0x056a0,0x1a5b4,0x025d0,0x092d0,0x0d2b2,0x0a950,0x0b557,		// 1940-1949
						  0x06ca0,0x0b550,0x15355,0x04da0,0x0a5b0,0x14573,0x052b0,0x0a9a8,0x0e950,0x06aa0,		// 1950-1959
						  0x0aea6,0x0ab50,0x04b60,0x0aae4,0x0a570,0x05260,0x0f263,0x0d950,0x05b57,0x056a0,		// 1960-1969
						  0x096d0,0x04dd5,0x04ad0,0x0a4d0,0x0d4d4,0x0d250,0x0d558,0x0b540,0x0b6a0,0x195a6,		// 1970-1979
						  0x095b0,0x049b0,0x0a974,0x0a4b0,0x0b27a,0x06a50,0x06d40,0x0af46,0x0ab60,0x09570,		// 1980-1989
						  0x04af5,0x04970,0x064b0,0x074a3,0x0ea50,0x06b58,0x055c0,0x0ab60,0x096d5,0x092e0,		// 1990-1999
						  0x0c960,0x0d954,0x0d4a0,0x0da50,0x07552,0x056a0,0x0abb7,0x025d0,0x092d0,0x0cab5,		// 2000-2009
						  0x0a950,0x0b4a0,0x0baa4,0x0ad50,0x055d9,0x04ba0,0x0a5b0,0x15176,0x052b0,0x0a930,		// 2010-2019
						  0x07954,0x06aa0,0x0ad50,0x05b52,0x04b60,0x0a6e6,0x0a4e0,0x0d260,0x0ea65,0x0d530,		// 2020-2029
						  0x05aa0,0x076a3,0x096d0,0x04afb,0x04ad0,0x0a4d0,0x1d0b6,0x0d250,0x0d520,0x0dd45,		// 2030-2039
						  0x0b5a0,0x056d0,0x055b2,0x049b0,0x0a577,0x0a4b0,0x0aa50,0x1b255,0x06d20,0x0ada0,		// 2040-2049
						  0x14b63,0x09370,0x049f8,0x04970,0x064b0,0x168a6,0x0ea50,0x06b20,0x1a6c4,0x0aae0,		// 2050-2059
						  0x0a2e0,0x0d2e3,0x0c960,0x0d557,0x0d4a0,0x0da50,0x05d55,0x056a0,0x0a6d0,0x055d4,		// 2060-2069
						  0x052d0,0x0a9b8,0x0a950,0x0b4a0,0x0b6a6,0x0ad50,0x055a0,0x0aba4,0x0a5b0,0x052b0,		// 2070-2079
						  0x0b273,0x06930,0x07337,0x06aa0,0x0ad50,0x14b55,0x04b60,0x0a570,0x054e4,0x0d160,		// 2080-2089
						  0x0e968,0x0d520,0x0daa0,0x16aa6,0x056d0,0x04ae0,0x0a9d4,0x0a2d0,0x0d150,0x0f252,		// 2090-2099
						  0x0d520 ];	// 2100
			
			// 公历每个月份的天数普通表
			solarMonth = [ 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 ];
			
			// 天干地支速查表，天干 
			Gan = [ "甲", "乙", "丙", "丁", "戊", "己", "庚", "辛", "壬", "癸" ];
			
			// 天干地支速查表，地支
			Zhi = [ "子", "丑", "寅", "卯", "辰", "巳", "午", "未", "申", "酉", "戌", "亥"];
			
			// 天干地支速查表，生肖
			Animals = [ "鼠", "牛", "虎", "兔", "龙", "蛇", "马", "羊", "猴", "鸡", "狗", "猪" ];
			
			// 二十四节气速查表
			solarTerm = [ "小寒","大寒","立春","雨水","惊蛰","春分","清明","谷雨","立夏","小满","芒种","夏至","小暑","大暑","立秋","处暑","白露","秋分","寒露","霜降","立冬","小雪","大雪","冬至" ];
			
			// 1900-2100年，二十四节气日期速查表
			sTermInfo = [ "9778397bd097c36b0b6fc9274c91aa","97b6b97bd19801ec9210c965cc920e","97bcf97c3598082c95f8c965cc920f","97bd0b06bdb0722c965ce1cfcc920f","b027097bd097c36b0b6fc9274c91aa",	// 1900-1904
						  "97b6b97bd19801ec9210c965cc920e","97bcf97c359801ec95f8c965cc920f","97bd0b06bdb0722c965ce1cfcc920f","b027097bd097c36b0b6fc9274c91aa","97b6b97bd19801ec9210c965cc920e",	// 1905-1909
						  "97bcf97c359801ec95f8c965cc920f","97bd0b06bdb0722c965ce1cfcc920f","b027097bd097c36b0b6fc9274c91aa","9778397bd19801ec9210c965cc920e","97b6b97bd19801ec95f8c965cc920f",	// 1910-1914
						  "97bd09801d98082c95f8e1cfcc920f","97bd097bd097c36b0b6fc9210c8dc2","9778397bd197c36c9210c9274c91aa","97b6b97bd19801ec95f8c965cc920e","97bd09801d98082c95f8e1cfcc920f",	// 1915-1919
						  "97bd097bd097c36b0b6fc9210c8dc2","9778397bd097c36c9210c9274c91aa","97b6b97bd19801ec95f8c965cc920e","97bcf97c3598082c95f8e1cfcc920f","97bd097bd097c36b0b6fc9210c8dc2",	// 1920-1924
						  "9778397bd097c36c9210c9274c91aa","97b6b97bd19801ec9210c965cc920e","97bcf97c3598082c95f8c965cc920f","97bd097bd097c35b0b6fc920fb0722","9778397bd097c36b0b6fc9274c91aa",	// 1925-1929
						  "97b6b97bd19801ec9210c965cc920e","97bcf97c3598082c95f8c965cc920f","97bd097bd097c35b0b6fc920fb0722","9778397bd097c36b0b6fc9274c91aa","97b6b97bd19801ec9210c965cc920e",	// 1930-1934
						  "97bcf97c359801ec95f8c965cc920f","97bd097bd097c35b0b6fc920fb0722","9778397bd097c36b0b6fc9274c91aa","97b6b97bd19801ec9210c965cc920e","97bcf97c359801ec95f8c965cc920f",	// 1935-1939
						  "97bd097bd097c35b0b6fc920fb0722","9778397bd097c36b0b6fc9274c91aa","97b6b97bd19801ec9210c965cc920e","97bcf97c359801ec95f8c965cc920f","97bd097bd07f595b0b6fc920fb0722",	// 1940-1944
						  "9778397bd097c36b0b6fc9210c8dc2","9778397bd19801ec9210c9274c920e","97b6b97bd19801ec95f8c965cc920f","97bd07f5307f595b0b0bc920fb0722","7f0e397bd097c36b0b6fc9210c8dc2",	// 1945-1949
						  "9778397bd097c36c9210c9274c920e","97b6b97bd19801ec95f8c965cc920f","97bd07f5307f595b0b0bc920fb0722","7f0e397bd097c36b0b6fc9210c8dc2","9778397bd097c36c9210c9274c91aa",	// 1950-1954
						  "97b6b97bd19801ec9210c965cc920e","97bd07f1487f595b0b0bc920fb0722","7f0e397bd097c36b0b6fc9210c8dc2","9778397bd097c36b0b6fc9274c91aa","97b6b97bd19801ec9210c965cc920e",	// 1955-1959
						  "97bcf7f1487f595b0b0bb0b6fb0722","7f0e397bd097c35b0b6fc920fb0722","9778397bd097c36b0b6fc9274c91aa","97b6b97bd19801ec9210c965cc920e","97bcf7f1487f595b0b0bb0b6fb0722",	// 1960-1964
						  "7f0e397bd097c35b0b6fc920fb0722","9778397bd097c36b0b6fc9274c91aa","97b6b97bd19801ec9210c965cc920e","97bcf7f1487f531b0b0bb0b6fb0722","7f0e397bd097c35b0b6fc920fb0722",	// 1965-1969
						  "9778397bd097c36b0b6fc9274c91aa","97b6b97bd19801ec9210c965cc920e","97bcf7f1487f531b0b0bb0b6fb0722","7f0e397bd07f595b0b6fc920fb0722","9778397bd097c36b0b6fc9274c91aa",	// 1970-1974
						  "97b6b97bd19801ec9210c9274c920e","97bcf7f0e47f531b0b0bb0b6fb0722","7f0e397bd07f595b0b0bc920fb0722","9778397bd097c36b0b6fc9210c91aa","97b6b97bd197c36c9210c9274c920e",	// 1975-1979
						  "97bcf7f0e47f531b0b0bb0b6fb0722","7f0e397bd07f595b0b0bc920fb0722","9778397bd097c36b0b6fc9210c8dc2","9778397bd097c36c9210c9274c920e","97b6b7f0e47f531b0723b0b6fb0722",	// 1980-1984
						  "7f0e37f5307f595b0b0bc920fb0722","7f0e397bd097c36b0b6fc9210c8dc2","9778397bd097c36b0b70c9274c91aa","97b6b7f0e47f531b0723b0b6fb0721","7f0e37f1487f595b0b0bb0b6fb0722",	// 1985-1989
						  "7f0e397bd097c35b0b6fc9210c8dc2","9778397bd097c36b0b6fc9274c91aa","97b6b7f0e47f531b0723b0b6fb0721","7f0e27f1487f595b0b0bb0b6fb0722","7f0e397bd097c35b0b6fc920fb0722",	// 1990-1994
						  "9778397bd097c36b0b6fc9274c91aa","97b6b7f0e47f531b0723b0b6fb0721","7f0e27f1487f531b0b0bb0b6fb0722","7f0e397bd097c35b0b6fc920fb0722","9778397bd097c36b0b6fc9274c91aa",	// 1995-1999
						  "97b6b7f0e47f531b0723b0b6fb0721","7f0e27f1487f531b0b0bb0b6fb0722","7f0e397bd097c35b0b6fc920fb0722","9778397bd097c36b0b6fc9274c91aa","97b6b7f0e47f531b0723b0b6fb0721",	// 2000-2004
						  "7f0e27f1487f531b0b0bb0b6fb0722","7f0e397bd07f595b0b0bc920fb0722","9778397bd097c36b0b6fc9274c91aa","97b6b7f0e47f531b0723b0787b0721","7f0e27f0e47f531b0b0bb0b6fb0722",	// 2005-2009
						  "7f0e397bd07f595b0b0bc920fb0722","9778397bd097c36b0b6fc9210c91aa","97b6b7f0e47f149b0723b0787b0721","7f0e27f0e47f531b0723b0b6fb0722","7f0e397bd07f595b0b0bc920fb0722",	// 2010-2014
						  "9778397bd097c36b0b6fc9210c8dc2","977837f0e37f149b0723b0787b0721","7f07e7f0e47f531b0723b0b6fb0722","7f0e37f5307f595b0b0bc920fb0722","7f0e397bd097c35b0b6fc9210c8dc2",	// 2015-2019
						  "977837f0e37f14998082b0787b0721","7f07e7f0e47f531b0723b0b6fb0721","7f0e37f1487f595b0b0bb0b6fb0722","7f0e397bd097c35b0b6fc9210c8dc2","977837f0e37f14998082b0787b06bd",	// 2020-2024
						  "7f07e7f0e47f531b0723b0b6fb0721","7f0e27f1487f531b0b0bb0b6fb0722","7f0e397bd097c35b0b6fc920fb0722","977837f0e37f14998082b0787b06bd","7f07e7f0e47f531b0723b0b6fb0721",	// 2025-2029
						  "7f0e27f1487f531b0b0bb0b6fb0722","7f0e397bd097c35b0b6fc920fb0722","977837f0e37f14998082b0787b06bd","7f07e7f0e47f531b0723b0b6fb0721","7f0e27f1487f531b0b0bb0b6fb0722",	// 2030-2034
						  "7f0e397bd07f595b0b0bc920fb0722","977837f0e37f14998082b0787b06bd","7f07e7f0e47f531b0723b0b6fb0721","7f0e27f1487f531b0b0bb0b6fb0722","7f0e397bd07f595b0b0bc920fb0722",	// 2035-2039
						  "977837f0e37f14998082b0787b06bd","7f07e7f0e47f149b0723b0787b0721","7f0e27f0e47f531b0b0bb0b6fb0722","7f0e397bd07f595b0b0bc920fb0722","977837f0e37f14998082b0723b06bd",	// 2040-2044
						  "7f07e7f0e37f149b0723b0787b0721","7f0e27f0e47f531b0723b0b6fb0722","7f0e397bd07f595b0b0bc920fb0722","977837f0e37f14898082b0723b02d5","7ec967f0e37f14998082b0787b0721",	// 2045-2049
						  "7f07e7f0e47f531b0723b0b6fb0722","7f0e37f1487f595b0b0bb0b6fb0722","7f0e37f0e37f14898082b0723b02d5","7ec967f0e37f14998082b0787b0721","7f07e7f0e47f531b0723b0b6fb0722",	// 2050-2054
						  "7f0e37f1487f531b0b0bb0b6fb0722","7f0e37f0e37f14898082b0723b02d5","7ec967f0e37f14998082b0787b06bd","7f07e7f0e47f531b0723b0b6fb0721","7f0e37f1487f531b0b0bb0b6fb0722",	// 2055-2059
						  "7f0e37f0e37f14898082b072297c35","7ec967f0e37f14998082b0787b06bd","7f07e7f0e47f531b0723b0b6fb0721","7f0e27f1487f531b0b0bb0b6fb0722","7f0e37f0e37f14898082b072297c35",	// 2060-2064
						  "7ec967f0e37f14998082b0787b06bd","7f07e7f0e47f531b0723b0b6fb0721","7f0e27f1487f531b0b0bb0b6fb0722","7f0e37f0e366aa89801eb072297c35","7ec967f0e37f14998082b0787b06bd",	// 2065-2069
						  "7f07e7f0e47f149b0723b0787b0721","7f0e27f1487f531b0b0bb0b6fb0722","7f0e37f0e366aa89801eb072297c35","7ec967f0e37f14998082b0723b06bd","7f07e7f0e47f149b0723b0787b0721",	// 2070-2074
						  "7f0e27f0e47f531b0723b0b6fb0722","7f0e37f0e366aa89801eb072297c35","7ec967f0e37f14998082b0723b06bd","7f07e7f0e37f14998083b0787b0721","7f0e27f0e47f531b0723b0b6fb0722",	// 2075-2079
						  "7f0e37f0e366aa89801eb072297c35","7ec967f0e37f14898082b0723b02d5","7f07e7f0e37f14998082b0787b0721","7f07e7f0e47f531b0723b0b6fb0722","7f0e36665b66aa89801e9808297c35",	// 2080-2084
						  "665f67f0e37f14898082b0723b02d5","7ec967f0e37f14998082b0787b0721","7f07e7f0e47f531b0723b0b6fb0722","7f0e36665b66a449801e9808297c35","665f67f0e37f14898082b0723b02d5",	// 2085-2089
						  "7ec967f0e37f14998082b0787b06bd","7f07e7f0e47f531b0723b0b6fb0721","7f0e36665b66a449801e9808297c35","665f67f0e37f14898082b072297c35","7ec967f0e37f14998082b0787b06bd",	// 2090-2094
						  "7f07e7f0e47f531b0723b0b6fb0721","7f0e26665b66a449801e9808297c35","665f67f0e37f1489801eb072297c35","7ec967f0e37f14998082b0787b06bd","7f07e7f0e47f531b0723b0b6fb0721",	// 2095-2099
						  "7f0e27f1487f531b0b0bb0b6fb0722" ];	// 2100
			
			// 数字转中文速查表
			nStr1 = [ "日", "一", "二", "三", "四", "五", "六", "七", "八", "九", "十" ];
			
			// 日期转农历称呼速查表
			nStr2 = [ "初", "十", "廿", "卅" ];
			
			// 月份转农历称呼速查表
			nStr3 = [ "正", "二", "三", "四", "五", "六", "七", "八", "九", "十", "十一", "腊" ];
			
			// 小时转时辰称呼速查表
			nStr4 = [ "子", "丑", "寅", "卯", "辰", "巳", "午", "未", "申", "酉", "戌", "亥" ];
			
			// 小时转(更/夜)称呼速查表
			nStr5 = [ "零", "一", "二", "三", "四", "五" ];
			
			// 星座名称速查表
			constellation = "魔羯水瓶双鱼白羊金牛双子巨蟹狮子处女天秤天蝎射手魔羯";
		}
		
		
		//************************ ************************* 获取阳历阴历的各种方法 ******************** *********** *** **////
		/**
		 * 返回农历y年一整年的总天数
		 * @param y 年
		 * @return 农历y年一整年的总天数
		 */
		public function lYearDays ( y:int ) : int
		{
			var i:int, sum:int = 348;
			for( i = 0x8000; i > 0x8; i >>= 1 )
			{
				sum += ( lunarInfo[y - 1900] & i ) ? 1 : 0;
			}
			return sum + leapDays(y);
		}
		
		/**
		 * 返回农历y年闰月是那个月，若y年没有闰月 则返回0
		 * @param y 年
		 * @return 农历闰月的数据
		 */
		public function leapMonth ( y:int ) : int
		{
			// 闰字编码 \u95f0
			return lunarInfo[y - 1900] & 0xf;
		}
		
		/**
		 * 返回农历y年闰月的天数 若该年没有闰月则返回0
		 * @param y 年
		 * @return 农历闰月的天数 (0、29、30)
		 */
		public function leapDays ( y:int ) : int
		{
			if ( leapMonth(y) )
			{ 
				return (lunarInfo[y-1900] & 0x10000) ? 30 : 29; 
			}
			return(0);
		}
		
		/**
		 * 返回农历y年m月（非闰月）的总天数，计算m为闰月时的天数请使用leapDays方法
		 * @param y 年
		 * @param m 月
		 * @return 非闰月的总天数(-1、29、30)
		 */
		public function monthDays ( y:int, m:int ) : int
		{
			// 月份参数从1至12，参数错误返回-1
			if ( m > 12 || m < 1 )
			{
				return -1;
			}
			return (lunarInfo[y - 1900] & (0x10000 >> m)) ? 30 : 29;
		}
		
		/**
		 * 返回公历y年m月的天数
		 * @param y 年
		 * @param m 月
		 * @return 公历m月的总天数(-1、28、29、30、31)
		 */
		public function solarDays ( y:int, m:int ) : int
		{
			if ( m > 12 || m < 1 )
			{
				return -1;	// 若参数错误 返回-1
			}
			
			var ms = m - 1;
			
			if ( ms == 1 )
			{
				return ((y % 4 == 0) && (y % 100 != 0) || (y % 400 == 0)) ? 29 : 28;		// 2月份的闰平规律测算后确认返回28或29
			}
			else
			{
				return solarMonth[ ms ];
			}
		}
		
		/**
		 * 农历年份转换为干支纪年
		 * @param lYear 农历年的年份数
		 * @return 转换后的干支纪年
		 */
		public function toGanZhiYear ( lYear:int ) : String
		{
			var ganKey = (lYear - 3) % 10;
			var zhiKey = (lYear - 3) % 12;
			
			// 如果余数为0则为最后一个天干
			if ( ganKey == 0 )
			{
				ganKey = 10;
			}
			
			// 如果余数为0则为最后一个地支
			if ( zhiKey == 0 )
			{
				zhiKey = 12;
			}
			return Gan[ganKey - 1] + Zhi[zhiKey - 1];
		}
		
		/**
		 * 公历月、日判断所属星座
		 * @param cMonth 月
		 * @param cDay 日
		 * @return 当前日期所属星座
		 */
		public function toAstro ( cMonth:int, cDay:int ) : String
		{
			var arr = [20,19,21,21,21,22,23,23,23,23,22,22];
			return constellation.substr(cMonth*2 - (cDay < arr[cMonth-1] ? 2 : 0),2) + "座";
		}
		
		/**
		 * 传入offset偏移量返回干支
		 * @param offset 相对甲子的偏移量
		 * @return 干支
		 */
		public function toGanZhi ( offset:int ) : String
		{
			return Gan[offset % 10] + Zhi[offset % 12];
		}
		
		/**
		 * 传入公历y年获得该年第n个节气的公历日期
		 * @param y 公历年(1900-2100)
		 * @param n 二十四节气中的第几个节气(1-24)，从n=1(小寒)算起 
		 * @return 第n个节气的公历日期
		 */
		public function getTerm ( y:int, n:int ) : int
		{
			if ( y < 1900 || y > 2100 )
			{
				return -1;
			}
			if ( n < 1 || n > 24)
			{
				return -1;
			}
			
			var _table = sTermInfo[y - 1900];
			
			var _info = [ parseInt("0x"+_table.substr(0,5)).toString(),
						  parseInt("0x"+_table.substr(5,5)).toString(),
						  parseInt("0x"+_table.substr(10,5)).toString(),
						  parseInt("0x"+_table.substr(15,5)).toString(),
						  parseInt("0x"+_table.substr(20,5)).toString(),
						  parseInt("0x"+_table.substr(25,5)).toString() ];
			
			var _calday = [ _info[0].substr(0,1),
							_info[0].substr(1,2),
							_info[0].substr(3,1),
							_info[0].substr(4,2),
							
							_info[1].substr(0,1),
							_info[1].substr(1,2),
							_info[1].substr(3,1),
							_info[1].substr(4,2),
							
							_info[2].substr(0,1),
							_info[2].substr(1,2),
							_info[2].substr(3,1),
							_info[2].substr(4,2),
							
							_info[3].substr(0,1),
							_info[3].substr(1,2),
							_info[3].substr(3,1),
							_info[3].substr(4,2),
							
							_info[4].substr(0,1),
							_info[4].substr(1,2),
							_info[4].substr(3,1),
							_info[4].substr(4,2),
							
							_info[5].substr(0,1),
							_info[5].substr(1,2),
							_info[5].substr(3,1),
							_info[5].substr(4,2) ];
			
			return parseInt( _calday[n-1] );
		}
		
		/**
		 * 传入农历数字月份返回汉语通俗表示法
		 * @param m 月份
		 * @return 汉语通俗的月份表示字符串
		 */
		public function toChinaMonth ( m:int ) : Object
		{
			if ( m > 12 || m < 1 )
			{
				return -1;	// 若参数错误 返回-1
			}
			var str : String = nStr3[m - 1];
			str += "月";
			return str;
		}
		
		/**
		 * 传入公历小时返回时辰汉语通俗表示法
		 * @param h 公历小时
		 * @return 时辰汉语通俗表示法字符串
		 */
		public function toChinaHour ( h:int ) : Object
		{
			if ( h > 23 || h < 0 )
			{
				return -1;	// 若参数错误 返回-1
			}
			h += 1;
			if ( h == 24 )
			{
				h = 0;
			}
			var str : String = nStr4[int(h/2)];
			str += "时";
			return str;
		}
		
		/**
		 * 传入公历小时返回(更/夜)汉语通俗表示法
		 * @param h 公历小时
		 * @return(更/夜)汉语通俗表示法字符串
		 */
		public function toChinaGeng ( h:int ) : Object
		{
			if ( h > 23 || h < 0 )
			{
				return -1;	// 若参数错误 返回-1
			}
			if ( h > 4 && h < 19 )
			{
				return -1;	// 若参数错误 返回-1
			}
			var index : int;
			switch ( h )
			{
				case 19:
				case 20:
					index = 1;
					break;
				case 21:
				case 22:
					index = 2;
					break;
				case 23:
				case 0:
					index = 3;
					break;
				case 1:
				case 2:
					index = 4;
					break;
				case 3:
				case 4:
					index = 5;
					break;
			}
			var str : String = nStr5[index-1];
			str += "更";
			return str;
		}
		
		/**
		 * 传入公历分钟返回当前刻数汉语通俗表示法（通常为计算午时三刻），
		 * 中国古代的刻并不是简单的一个时辰几刻（通常为八刻），而是把一天分为百刻，所以返回的刻数只是一个约等于的数字
		 * @param m 公历分钟
		 * @return 当前刻数汉语通俗表示法字符串
		 */
		public function toChinaKe ( m:int ) : Object
		{
			if ( m > 59 || m < 0 )
			{
				return -1;	// 若参数错误 返回-1
			}
			
			var index : int = Math.floor(m / 14.4) - 1;
			if ( index < 0 )
			{
				index = 0;
			}
			var str : String = nStr5[index] + "刻";
			return str;
		}
		
		
		/**
		 * 传入农历日期（日）数字返回汉字表示法
		 * @param d 日期（日）
		 * @return 汉语通俗的日期（日）表示字符串
		 */
		public function toChinaDay ( d:int ) : String
		{
			var s;
			switch ( d )
			{
				case 10:
					s = "初十";
					break;
				case 20:
					s = "二十";
					break;
				case 30:
					s = "三十";
					break;
				default:
					s = nStr2[ Math.floor(d/10) ];
					s += nStr1[d % 10];
			}
			return s;
		}
		
		/**
		 * 年份转生肖[!仅能大致转换] => 精确划分生肖分界线是“立春”
		 * @param y 年
		 * @return 该年对应的生肖
		 */
		public function getAnimal ( y:int ) : String
		{
			 return Animals[(y - 4) % 12];
		}
		
		
		/**
		 * 传入公历年月日获得详细的公历、返回农历object信息，参数区间1900.1.31~2100.12.31
		 * @param y 年
		 * @param m 月
		 * @param d 日
		 * @return 对应的农历object信息
		 */
		public function solar2lunar ( y:int, m:int, d:int ) : Object
		{
			if ( y < 1900 || y > 2100 )
			{
				return -1;
			}
			//年份限定、上限
			if ( y == 1900 && m == 1 && d < 31 )
			{
				return -1;	//下限
			}
			//未传参  获得当天
			var objDate : Date;
			if ( !y )
			{
				objDate = new Date();
			}
			else
			{
				objDate = new Date(y, m - 1, d)
			}
			var i, leap = 0, temp = 0;
			//修正ymd参数
			var y = objDate.getFullYear(),
				m = objDate.getMonth() + 1,
				d = objDate.getDate();
			var offset = (Date.UTC(objDate.getFullYear(), objDate.getMonth(), objDate.getDate()) - Date.UTC(1900, 0, 31)) / 86400000;
			for (i = 1900; i < 2101 && offset > 0; i++)
			{
				temp = lYearDays(i);
				offset -= temp;
			}
			if (offset < 0)
			{
				offset += temp;
				i--;
			}

			//是否今天
			var isTodayObj = new Date(),
				isToday = false;
			if (isTodayObj.getFullYear() == y && isTodayObj.getMonth() + 1 == m && isTodayObj.getDate() == d)
			{
				isToday = true;
			}
			//星期几
			var nWeek = objDate.getDay(),
				cWeek = nStr1[nWeek];
			if (nWeek == 0)
			{
				nWeek = 7;
			} //数字表示周几顺应天朝周一开始的惯例
			//农历年
			var year = i;
			
			// 闰月（只有农历有闰月）
			var leap2 = leapMonth(i); //闰哪个月
			var isLeapMonth = false;

			//效验闰月
			for (i = 1; i < 13 && offset > 0; i++)
			{
				//闰月
				if (leap2 > 0 && i == (leap2 + 1) && isLeapMonth == false)
				{
					--i;
					isLeapMonth = true;
					temp = leapDays(year); //计算农历闰月天数
				}
				else
				{
					temp = monthDays(year, i); //计算农历普通月天数
				}
				//解除闰月
				if (isLeapMonth == true && i == (leap2 + 1))
				{
					isLeapMonth = false;
				}
				offset -= temp;
			}

			if (offset == 0 && leap2 > 0 && i == leap2 + 1)
				if (isLeapMonth)
				{
					isLeapMonth = false;
				}
				else
				{
					isLeapMonth = true;
					--i;
				}
			if (offset < 0)
			{
				offset += temp;
				--i;
			}
			//农历月
			var month = i;
			//农历日
			var day = offset + 1;

			//天干地支处理
			var sm = m - 1;
			var gzY = toGanZhiYear(year);

			//月柱 1900年1月小寒以前为 丙子月(60进制12)
			var firstNode = getTerm(year, (m * 2 - 1)); //返回当月「节」为几日开始
			var secondNode = getTerm(year, (m * 2)); //返回当月「节」为几日开始

			//依据12节气修正干支月
			var gzM = toGanZhi((y - 1900) * 12 + m + 11);
			if (d >= firstNode)
			{
				gzM = toGanZhi((y - 1900) * 12 + m + 12);
			}

			//传入的日期的节气与否
			var isTerm = false;
			var Term = null;
			if (firstNode == d)
			{
				isTerm = true;
				Term = solarTerm[m * 2 - 2];
			}
			if (secondNode == d)
			{
				isTerm = true;
				Term = solarTerm[m * 2 - 1];
			}
			//日柱 当月一日与 1900/1/1 相差天数
			var dayCyclical = Date.UTC(y, sm, 1, 0, 0, 0, 0) / 86400000 + 25567 + 10;
			var gzD = toGanZhi(dayCyclical + d - 1);
			//该日期所属的星座
			var astro = toAstro(m, d);
			
			// 闰年（只有公历有闰年）
			var isLeapYear : Boolean = false;
			
			// 能被4整除且又不能被100整除 是闰年
			if ( ((y%4) == 0) && ((y%100) != 0) )
			{
				isLeapYear = true;
			}
			// 能直接被400整除也是闰年
			else if ( (y%400) == 0 )
			{
				isLeapYear = true;
			}
			
			return {
				"cYear": y,
				"cMonth": m,
				"cDay": d,
				"lYear": year,
				"lMonth": month,
				"lDay": day,
				"IMonthCn": (isLeapMonth ? "闰" : "") + toChinaMonth(month),
				"IDayCn": toChinaDay(day),
				"gzYear": gzY,
				"gzMonth": gzM,
				"gzDay": gzD,
				"ncWeek": "星期" + cWeek,
				"Animal": getAnimal(year),
				"astro": astro,
				"isToday": isToday,
				"isLeapYear": isLeapYear,
				"isLeapMonth": isLeapMonth,
				"nWeek": nWeek,
				"isTerm": isTerm,
				"Term": Term
			};
		}
		
		/**
		 * 传入公历年月日以及传入的月份是否闰月获得详细的公历、农历object信息，参数区间1900.1.31~2100.12.1
		 * @param y 年
		 * @param m 月
		 * @param d 日
		 * @param isLeapMonth lunar month is leap or not
		 * @return 对应的农历object信息
		 */
		public function lunar2solar ( y:int, m:int, d:int, isLeapMonth ) : Object
		{
			var leapOffset = 0;
			var leapMonth2 = leapMonth(y);
			var leapDay = leapDays(y);
			
			if (isLeapMonth && (leapMonth2 != m))
			{
				return -1;	//传参要求计算该闰月公历 但该年得出的闰月与传参的月份并不同
			}
			if (y == 2100 && m == 12 && d > 1 || y == 1900 && m == 1 && d < 31)
			{
				return -1;	//超出了最大极限值
			}
			var day = monthDays(y, m);
			if (y < 1900 || y > 2100 || d > day)
			{
				return -1;	//参数合法性效验
			}

			//计算农历的时间差
			var offset = 0;
			var i:int;
			for (i = 1900; i < y; i++)
			{
				offset += lYearDays(i);
			}
			var leap = 0,
				isAdd = false;
			for (i = 1; i < m; i++)
			{
				leap = leapMonth(y);
				if (!isAdd)
				{
					//处理闰月
					if (leap <= i && leap > 0)
					{
						offset += leapDays(y);
						isAdd = true;
					}
				}
				offset += monthDays(y, i);
			}
			//转换闰月农历 需补充该年闰月的前一个月的时差
			if (isLeapMonth)
			{
				offset += day;
			}
			//1900年农历正月一日的公历时间为1900年1月30日0时0分0秒(该时间也是本农历的最开始起始点)
			var stmap = Date.UTC(1900, 1, 30, 0, 0, 0);
			var calObj = new Date((offset + d - 31) * 86400000 + stmap);
			var cY = calObj.getUTCFullYear();
			var cM = calObj.getUTCMonth() + 1;
			var cD = calObj.getUTCDate();
			
			return solar2lunar(cY, cM, cD);
		}
		
		
	}
}
/** 包外类，防止对象被意外新建（new），但仍然无法阻止传递null参数进行new对象 */
class GregorianLunarSwitchGregorianLunarSwitch{ }


