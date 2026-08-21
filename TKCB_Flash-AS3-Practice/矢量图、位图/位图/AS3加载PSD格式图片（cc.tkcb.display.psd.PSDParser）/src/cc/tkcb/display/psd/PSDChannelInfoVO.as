/**
 * @author Slavomir Durej
 */

/*
 * 修 改 者：TKCB
 * 修者信息：身高（0.00167公里+）；体重（0.06吨±）；年龄（公元1990后）；籍贯（有兵马俑的地方）；星座（最后一个星座）；血型（万能型）；人生格言（The king come back.）。
 * 交流学习：加QQ群[AS3殿堂之路]（96759336），群里有无数主城、架构、妹子、LOL战友，欢迎交流讨论。
 * 联系方式：QQ（2414268040）；E-mail（tkcb@qq.com）；手机（15029932353)。
 * 个人网站：www.tkcb.cc（来这里关注我吧，这里有我所有的作品，分享的资料，我的介绍和动态，还有更多你想不到的）
 */

/* 
 * @version 版本创建时间和修改说明
 * v1.0.0 2017-2-16
 */

package cc.tkcb.display.psd
{
	import flash.utils.ByteArray;

	/**
	 * PSDChannelInfoVO
	 * @author TKCB（www.tkcb.cc）
	 * @创建时间 未知
	 * @修改时间 2017-2-16
	 * @version 1.0.0
	 */
	public class PSDChannelInfoVO
	{
		public var id: int = 0;
		public var length: uint = 0;

		public function PSDChannelInfoVO(fileData: ByteArray)
		{
			id = fileData.readShort();
			length = fileData.readUnsignedInt();
		}
	}
}