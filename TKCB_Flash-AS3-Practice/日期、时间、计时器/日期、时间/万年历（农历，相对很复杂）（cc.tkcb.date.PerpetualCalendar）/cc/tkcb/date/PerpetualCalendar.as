/*
 * DO NOT ALTER OR REMOVE COPYRIGHT NOTICES OR THIS HEADER.
 *
 * Copyright 2017 TKCB, tkcb@qq.com
 *
 * 
 * This is free software/program/code: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * If not, see <http://www.gnu.org/licenses/>.
 *
 *
 * 这是一个自由软件/程序/代码，您可以自由分发、修改其中的源代码或者重新发布它，
 * 新的任何修改后的重新发布版必须同样在遵守LGPL3或更后续的版本协议下发布。
 * 关于LGPL协议的细则请参考COPYING、COPYING.LESSER文件，
 * 你可以在文件夹中获得LGPL协议的副本，如果没有找到，请连接到 http://www.gnu.org/licenses/ 查看。
 *
 *
 * 作　　者：TKCB
 * 作者信息：身高（0.00167公里+）；体重（0.06吨±）；年龄（公元1990后）；籍贯（有兵马俑的地方）；星座（最后一个星座）；血型（万能型）；人生格言（The king come back.）。
 * 交流学习：加QQ群[AS3殿堂之路]（96759336），群里有无数主城、架构、妹子、LOL战友，欢迎交流讨论。
 * 联系方式：QQ（2414268040）；E-mail（tkcb@qq.com）；手机（15029932353)。
 * 作者网站：www.tkcb.cc（来这里关注我吧，这里有我所有的作品，分享的资料，我的介绍和动态，还有更多你想不到的）
 *
 * 
 * 获取软件/程序最新版本：www.tkcb.cc
 *
 *
 * 版权协议：请自觉遵守LGPL协议，欢迎复制、转载、传播给更多需要的人。
 * 免责声明：任何因使用此软件导致的纠纷与软件/程序开发者无关。
 */


/* 
 * @version 版本创建时间和修改说明
 * v1.0.0 2016-10-25
 */


package cc.tkcb.date
{
	import cc.tkcb.date.FestivalSolarTerm;
	import cc.tkcb.date.GregorianLunarSwitch;
	
	
	/**
	 * PerpetualCalendar 万年历类，用于获取任意日期的当月当日的日历数据，因为农历的原因其实做不到万年历
	 * @author TKCB（www.tkcb.cc）
	 * @创建时间 2016-10-25
	 * @修改时间 2016-10-25
	 * @version 1.0.0
	 */
	public class PerpetualCalendar
	{
		//************************ ************************* 静态属性 ******************** *********** *** **////
		/** 当年年份，外部调用仅用于读取，也可以设置但绝对不推荐这样使用（除非很了解代码） */
		public static var currentYear : int;
		
		/** 当年月份（1-12），外部调用仅用于读取，也可以设置但绝对不推荐这样使用（除非很了解代码） */
		public static var currentMonth : int;
		
		/** 当年日，外部调用仅用于读取，也可以设置但绝对不推荐这样使用（除非很了解代码） */
		public static var currentDay : int;
		
		/** 星期的显示方式切换，默认为true，true=从星期日开始计算，false表示从星期一开始计算 */
		public static var weekArraySwitch : Boolean = true;
		
		
		
		//************************ ************************* 构造函数 ******************** *********** *** **////
		/**
		 * 构造函数...
		 */
		public function PerpetualCalendar ()
		{
			
		}
		
		
		//************************ ************************* 静态方法 ******************** *********** *** **////
		/**
		 * 获取当前系统时间的日历数据对象
		 * @return 日历数据对象
		 */
		public static function getCurrentSystemDate () : Array
		{
			var date : Date = new Date();
			currentYear = date.fullYear;
			currentMonth = date.month + 1;
			currentDay = date.date;
			
			return getDate( currentYear, currentMonth, currentDay );
		}
		
		/**
		 * 获取任意年、月、日的日历数据对象
		 * @param y 年
		 * @param m 月
		 * @param d 日
		 * @return 日历数据对象
		 */
		public static function getAnyYearMonthDayDate ( y:int, m:int, d:int ) : Array
		{
			currentYear = y;
			currentMonth = m;
			currentDay = d;
			
			return getDate( currentYear, currentMonth, currentDay );
		}
		
		/**
		 * 获取当前时间的上一年（更早）的日历数据对象
		 * @return 日历数据对象
		 */
		public static function getPrevYearDate () : Array
		{
			setYMD();
			
			currentYear--;
			
			return getDate( currentYear, currentMonth, currentDay );
		}
		
		/**
		 * 获取当前时间的下一年（未来）的日历数据对象
		 * @return 日历数据对象
		 */
		public static function getNextYearDate () : Array
		{
			setYMD();
			
			currentYear++;
			
			return getDate( currentYear, currentMonth, currentDay );
		}
		
		/**
		 * 获取当前时间的上一月（更早）的日历数据对象
		 * @return 日历数据对象
		 */
		public static function getPrevMonthDate () : Array
		{
			setYMD();
			
			if ( currentMonth > 1 )
			{
				currentMonth--;
			}
			else
			{
				currentYear--;
				currentMonth = 12;
			}
			
			return getDate( currentYear, currentMonth, currentDay );
		}
		
		/**
		 * 获取当前时间的下一月（未来）的日历数据对象
		 * @return 日历数据对象
		 */
		public static function getNextMonthDate () : Array
		{
			setYMD();
			
			if ( currentMonth < 12 )
			{
				currentMonth++;
			}
			else
			{
				currentYear++;
				currentMonth = 1;
			}
			
			return getDate( currentYear, currentMonth, currentDay );
		}
		
		
		//************************ ************************* 公用的获取日历数据的方法 ******************** *********** *** **////
		/**
		 * 设置默认的几个时间变量
		 */
		private static function setYMD () : void
		{
			if ( currentYear == 0 )
			{
				var date : Date = new Date();
				currentYear = date.fullYear;
				currentMonth = date.month;
				currentDay = date.date;
			}
		}
		
		
		
		/**
		 * 获取任意年、月、日的日历数据对象
		 * @param y 年
		 * @param m 月
		 * @param d 日
		 * @return 日历数据对象
		 */
		private static function getDate ( y:int, m:int, d:int ) : Array
		{
			// 星期的总数组，有4-6个子数组，每个数组代表一个星期，每个星期又有固定的七天
			var dateWeekArr : Array = [];
			
			// 日期对象，本月、上月、下月
			var date : Date = new Date( y, m-1 );
			
			// 日期对象，获取本月最大天数
			var date2 : Date = new Date( y, m );
			date2.date -= 1;
			
			// 日期对象，获取当前系统年月日
			var date3 : Date = new Date();
			
			//// 核心算法1：将当前月份的日期写入排列数组中
			var i:int, len:int = date2.date;
			var index1:int, index2:int;
			for ( i = 0; i < len; i++ )
			{
				// 从星期日 到 星期六
				if ( weekArraySwitch )
				{
					if ( i == 0 || date.day == 0 )
					{
						dateWeekArr[ dateWeekArr.length ] = [];
					}
					index1 = dateWeekArr.length > 0 ? dateWeekArr.length - 1 : 0;
					index2 = date.day;
				}
				// 从星期一 到 星期日
				else
				{
					if ( i == 0 || date.day == 1 )
					{
						dateWeekArr[ dateWeekArr.length ] = [];
					}
					index1 = dateWeekArr.length > 0 ? dateWeekArr.length - 1 : 0;
					index2 = (date.day == 0) ? 6 : date.day-1;
				}
				
				dateWeekArr[ index1 ][ index2 ] = getObject( date, date3, d, 0 );
				date.date += 1;
			}
			
			//// 核心算法2：补全开头的日期天数
			if ( dateWeekArr[0][0] == null )
			{
				// 获取上一个月的日期对象
				date = new Date( y, m-1 );
				date.date -= 1;
				
				// 倒着循环补全日期天数，从第六天开始补全
				for ( i = 5; i >= 0; i-- )
				{
					if ( dateWeekArr[0][i] == null )
					{
						dateWeekArr[0][i] = getObject( date, date3, d, -1 );
						date.date -= 1;
					}
				}
			}
			
			//// 核心算法3：补全最后一行
			var arrLen : int = dateWeekArr.length - 1;
			if ( dateWeekArr[ arrLen ][6] == null )
			{
				// 获取上一个月的日期对象
				date = new Date( y, m );
				date.date = 1;
				
				// 正着补全，并不需要新建日期对象，因为下一个月肯定有1-6这几天
				var dateIndex : int = 1;
				for ( i = 1; i <= 6; i++ )
				{
					if ( dateWeekArr[ arrLen ][i] == null )
					{
						dateWeekArr[ arrLen ][i] = getObject( date, date3, d, 1 );
						date.date += 1;
					}
				}
			}
	
			return dateWeekArr;
		}
		
		
		/**
		 * 传入两个日期对象，计算并返回相应的日期（天）的每天的数据对象
		 * @param date 日期对象1
		 * @param date3 日期对象3
		 * @param d 传入的天数日期
		 * @param isCurrentMonth 0=当前月，-1=上一个月，1=下一个月
		 * @return 每天的数据对象
		 */
		private static function getObject ( date:Date, date3:Date, d:int, isCurrentMonth:int ) : Object
		{
			// 每天的数据对象，包括：
			// cYear				公历 年
			// cMonth				公历 月
			// cDay					公历 日
			// lYear				农历 年
			// lMonth				农历 月
			// lDay					农历 日
			// IMonthCn				农历 月
			// IDayCn				农历 日
			// gzYear				天干地支纪年 年
			// gzMonth				天干地支纪年 月
			// gzDay				天干地支纪年 日
			// nWeek				星期（数字形式）
			// ncWeek				星期（汉字形式）
			// Animal				生肖
			// astro				星座
			// isCurrentMonth		0=当前月，-1=上一个月，1=下一个月
			// isSystemToday		是否今天（和系统日期一致），true表示是，false表示不是
			// isCurrentToday		是否传入的日期（天），true表示是，false表示不是
			// gregorianFestival	公历节日
			// lunarFestival		农历节日
			// solarTerm			节气
			var obj : Object = {};
			
			// 获取公历转农历对象
			var mlObj : Object = GregorianLunarSwitch.getInstance().solar2lunar( date.fullYear, date.month+1, date.date );
			
			// 公历年月日
			obj.cYear =  mlObj.cYear;
			obj.cMonth = mlObj.cMonth;
			obj.cDay = mlObj.cDay;
			
			// 农历年月日
			obj.lYear =  mlObj.lYear;
			obj.lMonth = mlObj.lMonth;
			obj.lDay = mlObj.lDay;
			
			// 农历月日（汉字形式）
			obj.IMonthCn =  mlObj.IMonthCn;
			obj.IDayCn = mlObj.IDayCn;
			
			// 天干地支纪年
			obj.gzYear =  mlObj.gzYear;
			obj.gzMonth = mlObj.gzMonth;
			obj.gzDay = mlObj.gzDay;
			
			// 星期（数字形式、汉字形式）
			obj.nWeek =  mlObj.nWeek;
			obj.ncWeek =  mlObj.ncWeek;
			
			// 生肖
			obj.Animal =  mlObj.Animal;
			
			// 星座
			obj.astro =  mlObj.astro;
			
			// 0=当前月，-1=上一个月，1=下一个月
			obj.isCurrentMonth = isCurrentMonth;
			
			// 是否今天（和系统日期一致），true表示是，false表示不是
			obj.isSystemToday = (date3.fullYear == obj.cYear && (date3.month+1) == obj.cMonth && date3.date == obj.cDay) ? true : false;
			
			// 是否传入的日期（天），true表示是，false表示不是
			obj.isCurrentToday = (obj.cDay == d && isCurrentMonth == 0) ? true : false;
			
			// 公历节日、农历节日、节气
			obj.gregorianFestival = FestivalSolarTerm.getDayGregorianFestival( obj.cYear, obj.cMonth, obj.cDay );
			obj.lunarFestival = FestivalSolarTerm.getDayLunarFestival( obj.cYear, obj.cMonth, obj.cDay );
			obj.solarTerm = FestivalSolarTerm.getDaySolarTerm( obj.cYear, obj.cMonth, obj.cDay );
	
			return obj;
		}
	}
}