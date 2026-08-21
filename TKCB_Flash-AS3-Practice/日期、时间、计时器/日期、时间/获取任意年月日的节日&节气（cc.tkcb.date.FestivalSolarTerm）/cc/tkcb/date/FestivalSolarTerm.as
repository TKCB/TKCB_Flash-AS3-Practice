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
	// 用到了另外一个日期工具类
	import cc.tkcb.date.GregorianLunarSwitch;
	
	
	
	/**
	 * FestivalSolarTerm 节日和节气类，可以获取任意公历年月日对应的节日和节气信息，因为节日是很特殊的，每个国家都不一样，想把所有的世界节日都弄上也不现实，所以只挑一些重点和大家都知道的节日，后续如果需要可以任意添加删减
	 * @author TKCB（www.tkcb.cc）
	 * @创建时间 2016-10-7
	 * @修改时间 2016-10-7
	 * @version 1.0.0
	 */
	public class FestivalSolarTerm
	{
		//************************ ************************* 构造函数 ******************** *********** *** **////
		/**
		 * ...
		 */
		public function FestivalSolarTerm ()
		{
			
		}
		
		//************************ ************************* 静态方法 ******************** *********** *** **////
		/**
		 * 获取公历任意年的节日信息列表数组
		 * @param $year 指定年份（公历）
		 * @return 节日信息列表数组
		 * */
		public static function getYearGregorianFestival ( $year:int ) : Array
		{
			var tempArr : Array = [];
			
			// 循环对12个月进行节日查询
			var i:int, len:int = 12;
			for ( i = 1; i <= len; i++ )
			{
				var tempArr2 : Array = FestivalSolarTerm.getMonthGregorianFestival( $year, i );
				// 数组第一个是本月的节日天，第二个是节日的名字
				tempArr.push( [ i, tempArr2 ] );
			}
			
			return tempArr;
		}
		
		/**
		 * 获取公历任意年的农历节日信息列表数组
		 * @param $year 指定年份（公历）
		 * @return 节日信息列表数组
		 * */
		public static function getYearLunarFestival ( $year:int ) : Array
		{
			var tempArr : Array = [];
			
			// 循环对12个月进行节日查询
			var i:int, len:int = 12;
			for ( i = 1; i <= len; i++ )
			{
				var tempArr2 : Array = FestivalSolarTerm.getMonthLunarFestival( $year, i );
				// 数组第一个是本月的节日天，第二个是节日的名字
				tempArr.push( [ i, tempArr2 ] );
			}
			
			return tempArr;
		}
		
		/**
		 * 获取公历任意年的节气信息列表数组
		 * @param $year 指定年份（公历）
		 * @return 节日信息列表数组
		 * */
		public static function getYearSolarTerm ( $year:int ) : Array
		{
			var tempArr : Array = [];
			
			// 循环对12个月进行节气查询
			var i:int, len:int = 12;
			for ( i = 1; i <= len; i++ )
			{
				var tempArr2 : Array = FestivalSolarTerm.getMonthSolarTerm( $year, i );
				// 数组第一个是本月的节气天，第二个是节气的名字
				tempArr.push( [ i, tempArr2 ] );
			}
			
			return tempArr;
		}
		
		/**
		 * 获取公历任意年任意月的节日信息列表数组
		 * @param $year 指定年份（公历）
		 * @param $month 指定月份（公历）
		 * @return 节日信息列表数组
		 * */
		public static function getMonthGregorianFestival ( $year:int, $month:int ) : Array
		{
			var tempArr : Array = [];
			
			// 本月天数
			var mDayNum : int;
			
			switch ( $month )
			{
				// 1月，3月，5月，7月，8月，10月，12月，有31天
				case 1:
				case 3:
				case 5:
				case 7:
				case 8:
				case 10:
				case 12:
					mDayNum = 31;
					break;
				// 4月，6月，9月，11月，有30天
				case 4:
				case 6:
				case 9:
				case 11:
					mDayNum = 30;
					break;
				// 2月，有28天（不是闰年）
				case 2:
					mDayNum = 28;
					break;
			}
			
			
			//// 如果今年是闰年，且当月是2月，则是29天
			// 闰年（只有公历有闰年）
			var isLeapYear : Boolean = false;
			
			// 能被4整除且又不能被100整除 是闰年
			if ( (($year%4) == 0) && (($year%100) != 0) )
			{
				isLeapYear = true;
			}
			// 能直接被400整除也是闰年
			else if ( ($year%400) == 0 )
			{
				isLeapYear = true;
			}
			
			// 不是闰年
			if ( isLeapYear && $month == 2 )
			{
				mDayNum == 29;
			}
			
			// 循环对这个月每天进行节日查询
			var i:int, len:int = mDayNum;
			for ( i = 1; i <= len; i++ )
			{
				var tempArr2 : Array = FestivalSolarTerm.getDayGregorianFestival( $year, $month, i );
				if ( tempArr2.length > 0 )
				{
					// 数组第一个是本月的节日天，第二个是节日的名字
					tempArr.push( [ i, tempArr2 ] );
				}
			}
			
			return tempArr;
		}
		
		/**
		 * 获取公历任意年任意月的农历节日信息列表数组
		 * @param $year 指定年份（公历）
		 * @param $month 指定月份（公历）
		 * @return 节日信息列表数组
		 * */
		public static function getMonthLunarFestival ( $year:int, $month:int ) : Array
		{
			var tempArr : Array = [];
			
			// 本月天数
			var mDayNum : int;
			
			switch ( $month )
			{
				// 1月，3月，5月，7月，8月，10月，12月，有31天
				case 1:
				case 3:
				case 5:
				case 7:
				case 8:
				case 10:
				case 12:
					mDayNum = 31;
					break;
				// 4月，6月，9月，11月，有30天
				case 4:
				case 6:
				case 9:
				case 11:
					mDayNum = 30;
					break;
				// 2月，有28天（不是闰年）
				case 2:
					mDayNum = 28;
					break;
			}
			
			
			//// 如果今年是闰年，且当月是2月，则是29天
			// 闰年（只有公历有闰年）
			var isLeapYear : Boolean = false;
			
			// 能被4整除且又不能被100整除 是闰年
			if ( (($year%4) == 0) && (($year%100) != 0) )
			{
				isLeapYear = true;
			}
			// 能直接被400整除也是闰年
			else if ( ($year%400) == 0 )
			{
				isLeapYear = true;
			}
			
			// 不是闰年
			if ( isLeapYear && $month == 2 )
			{
				mDayNum == 29;
			}
			
			// 循环对这个月每天进行节日查询
			var i:int, len:int = mDayNum;
			for ( i = 1; i <= len; i++ )
			{
				var tempArr2 : Array = FestivalSolarTerm.getDayLunarFestival( $year, $month, i );
				//trace( tempArr2 );
				if ( tempArr2.length > 0 )
				{
					// 数组第一个是本月的节日天，第二个是节日的名字
					tempArr.push( [ i, tempArr2 ] );
				}
			}
			
			return tempArr;
		}
		
		/**
		 * 获取公历任意年任意月的节气信息列表数组
		 * @param $year 指定年份（公历）
		 * @param $month 指定月份（公历）
		 * @return 节日信息列表数组
		 * */
		public static function getMonthSolarTerm ( $year:int, $month:int ) : Array
		{
			var tempArr : Array = [];
			
			// 将公历日期，转换为农历日期，然后判断农历的节日
			var obj : Object = GregorianLunarSwitch.getInstance().solar2lunar( $year, $month, 1 );
			var year : int = obj.lYear;
			var month : int = obj.lMonth;
			
			// 如果是闰月，则获取闰月天数
			var mDayNum : int;
			if ( obj.isLeapMonth )
			{
				mDayNum = GregorianLunarSwitch.getInstance().leapDays( year );
			}
			// 如果不是闰月，则获取正常月天数
			else
			{
				mDayNum = GregorianLunarSwitch.getInstance().monthDays( year, month );
			}
			
			// 循环对这个月每天进行节气查询
			var i:int, len:int = mDayNum;
			for ( i = 1; i <= len; i++ )
			{
				obj = GregorianLunarSwitch.getInstance().solar2lunar( $year, $month, i );
				if ( obj.isTerm )
				{
					// 数组第一个是本月的节气天，第二个是节气的名字
					tempArr.push( [ i, obj.Term ] );
				}
			}
			
			return tempArr;
		}

		/**
		 * 获取公历节日信息数组，需要传入年月日，如何没有节日则返回空数组，如果有多个节日则数组中有多个元素
		 * @param $year 指定年份（公历）
		 * @param $month 指定月份（公历）
		 * @param $date 指定天（公历）
		 * @return 节日信息数组
		 * */
		public static function getDayGregorianFestival ( $year:int, $month:int, $date:int ) : Array
		{
			var tempArr : Array = [];
			var date : Date = new Date( $year, $month-1, $date );
			switch ( $month )
			{
				// 1月
				case 1:
					if ( $date == 1 ) tempArr.push( "元旦" );
					if ( $date == 8 ) tempArr.push( "周恩来逝世日" );
					break;
				// 2月
				case 2:
					if ( $date == 14 ) tempArr.push( "情人节" );
					break;
				// 3月
				case 3:
					if ( $date == 5 ) tempArr.push( "学雷锋纪念日" );
					if ( $date == 8 ) tempArr.push( "妇女节" );
					if ( $date == 12 ) tempArr.push( "植树节", "孙中山逝世日" );
					if ( $date == 14 ) tempArr.push( "白色情人节" );
					if ( $date == 15 ) tempArr.push( "消费者权益日" );
					break;
				// 4月
				case 4:
					if ( $date == 1 ) tempArr.push( "愚人节" );
					if ( $date == 22 ) tempArr.push( "地球日" );
					break;
				// 5月
				case 5:
					if ( $date == 1 ) tempArr.push( "劳动节" );
					if ( $date == 4 ) tempArr.push( "五四青年节" );
					if ( $date == 12 ) tempArr.push( "护士节" );
					if ( $date == 31 ) tempArr.push( "无烟日" );
					// 母亲节（五月第二个星期日）
					if ( Math.ceil($date/7) == 2 && date.day == 0 )
					{
						tempArr.push( "母亲节" );
					}
					break;
				// 6月
				case 6:
					if ( $date == 1 ) tempArr.push( "儿童节" );
					if ( $date == 5 ) tempArr.push( "环境日" );
					if ( $date == 23 ) tempArr.push( "奥林匹克日" );
					// 父亲节（六月第三个星期日）
					if ( Math.ceil($date/7) == 3 && date.day == 0 )
					{
						tempArr.push( "父亲节" );
					}
					break;
				// 7月
				case 7:
					if ( $date == 1 ) tempArr.push( "建党日" );
					break;
				// 8月
				case 8:
					if ( $date == 1 ) tempArr.push( "建军节" );
					break;
				// 9月
				case 9:
					if ( $date == 3 ) tempArr.push( "抗战胜利日" );
					if ( $date == 9 ) tempArr.push( "毛泽东逝世日" );
					if ( $date == 10 ) tempArr.push( "教师节" );
					break;
				// 10月
				case 10:
					if ( $date == 1 ) tempArr.push( "国庆节" );
					break;
				// 11月
				case 11:
					if ( $date == 8 ) tempArr.push( "记者日" );
					if ( $date == 9 ) tempArr.push( "消防宣传日" );
					break;
				// 12月
				case 12:
					if ( $date == 25 ) tempArr.push( "圣诞节" );
					break;
			}
			
			return tempArr;
		}

		/**
		 * 获取公历对应的农历节日信息数组，需要传入年月日，如何没有节日则返回空数组，如果有多个节日则数组中有多个元素
		 * @param $year 指定年份（公历）
		 * @param $month 指定月份（公历）
		 * @param $date 指定天（公历）
		 * @return 节日信息数组
		 * */
		public static function getDayLunarFestival ( $year:int, $month:int, $date:int ) : Array
		{
			var tempArr : Array = [];
			
			// 将公历日期，转换为农历日期，然后判断农历的节日
			var obj : Object = GregorianLunarSwitch.getInstance().solar2lunar( $year, $month, $date );
			$year = obj.lYear;
			$month = obj.lMonth;
			$date = obj.lDay;
			//trace($year, $month, $date );
			
			// 看看农历年是否有闰月
			var rMonth : int = GregorianLunarSwitch.getInstance().leapMonth( $year );
			
			// 如果有闰月，则获取农历闰月天数
			var rmDayNum : int;
			if ( rMonth != 0  )
			{
				rmDayNum = GregorianLunarSwitch.getInstance().leapDays( $year );
			}
			
			// 获取农历十二月的天数（非闰月）
			var mDayNum : int = GregorianLunarSwitch.getInstance().monthDays( $year, 12 );
			
			// 不是闰月（所有的农历节日都不在闰月过，除了闰十二月（闰腊月）的除夕在闰月过）
			
			if ( obj.isLeapMonth == false )
			{
				switch ( $month )
				{
					// 1月
					case 1:
						if ( $date == 1 ) tempArr.push( "春节" );
						if ( $date == 15 ) tempArr.push( "元宵节(上元佳节)" );
						break;
					// 2月
					case 2:
						if ( $date == 2 ) tempArr.push( "龙头节" );
						break;
					// 3月
					case 3:
						// 没有对应节日
						break;
					// 4月
					case 4:
						// 没有对应节日，下面这两个节日已经被合并为现代的清明节（对应的是节气的清明）
						//if ( $date == 4 ) tempArr.push( "寒食" );
						//if ( $date == 5 ) tempArr.push( "清明节(踏青节)" );
						break;
					// 5月
					case 5:
						if ( $date == 5 ) tempArr.push( "端午节" );
						break;
					// 6月
					case 6:
						// 没有对应节日
						break;
					// 7月
					case 7:
						if ( $date == 7 ) tempArr.push( "七夕节" );
						if ( $date == 15 ) tempArr.push( "中元节(鬼节)" );
						break;
					// 8月
					case 8:
						if ( $date == 15 ) tempArr.push( "中秋节" );
						break;
					// 9月
					case 9:
						if ( $date == 9 ) tempArr.push( "重阳节", "敬老节" );
						break;
					// 10月
					case 10:
						if ( $date == 1 ) tempArr.push( "寒衣节" );
						if ( $date == 15 ) tempArr.push( "下元节" );
						break;
					// 11月
					case 11:
						// 没有对应节日
						break;
					// 12月
					case 12:
						if ( $date == 8 ) tempArr.push( "腊八节" );
						break;
				}
			}
			
			// 当前是闰月，并且今年是润十二月
			if ( obj.isLeapMonth && rMonth == 12 && $month == 13 )
			{
				// 12月
				if ( $date == rmDayNum ) tempArr.push( "除夕" );
			}
			// 当前不是闰月，并且今年不是润十二月，当前是十二月
			else if ( obj.isLeapMonth == false && rMonth != 12 && $month == 12 )
			{
				// 12月
				if ( $date == mDayNum ) tempArr.push( "除夕" );
			}
			
			return tempArr;
		}
		
		/**
		 * 获取公历对应的节气信息数组，需要传入年月日，如何没有节气则返回空数组，如果有多个节气则数组中有多个元素
		 * @param $year 指定年份（公历）
		 * @param $month 指定月份（公历）
		 * @param $date 指定天（公历）
		 * @return 节气信息数组
		 * */
		public static function getDaySolarTerm ( $year:int, $month:int, $date:int ) : Array
		{
			var tempArr : Array = [];
			
			// 将公历日期转换为农历，并获取当日的节气信息
			var obj : Object = GregorianLunarSwitch.getInstance().solar2lunar( $year, $month, $date );
			
			// 是否有节气
			if ( obj.isTerm )
			{
				tempArr.push( obj.Term );
			}
			
			return tempArr;
		}
		
	}
}