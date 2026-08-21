package com.tkcb.interfaces
{
	/**
	 * IDestroy 接口用于销毁对象，然后便可以使用null方法等彻底清除对象引用。
	 * @langversion ActionScript 3.0
	 * @author TKCB（QQ 2414268040、E-mail tkcb@qq.com）
	 * @创建时间 2013-6-28
	 * @修改时间 2013-10-9
	 */
	public interface IDestroy
	{
		/** 回收对象时调用此方法（清除侦听、对象null等）。 */
		function destroy():void;
		
	}
}