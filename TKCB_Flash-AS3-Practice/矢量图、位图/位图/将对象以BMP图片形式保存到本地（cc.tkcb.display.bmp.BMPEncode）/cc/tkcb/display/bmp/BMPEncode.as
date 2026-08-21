/*
 * 修 改 者：TKCB
 * 修者信息：身高（0.00167公里+）；体重（0.06吨±）；年龄（公元1990后）；籍贯（有兵马俑的地方）；星座（最后一个星座）；血型（万能型）；人生格言（The king come back.）。
 * 交流学习：加QQ群[AS3殿堂之路]（96759336），群里有无数主城、架构、妹子、LOL战友，欢迎交流讨论。
 * 联系方式：QQ（2414268040）；E-mail（tkcb@qq.com）；手机（15029932353)。
 * 个人网站：www.tkcb.cc（来这里关注我吧，这里有我所有的作品，分享的资料，我的介绍和动态，还有更多你想不到的）
 */

/* 
 * @version 版本创建时间和修改说明
 * v1.0.0 2017-11-26
 */

package cc.tkcb.display.bmp
{
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	import flash.display.BitmapData;
	
	/**
	 * BMPEncode BMP格式编码 类，用于对位图进行BMP格式编码，然后可以使用保存代码将图像保存为BMP格式了
	 * @author TKCB（www.tkcb.cc）
	 * @创建时间 未知
	 * @修改时间 2017-11-26
	 * @version 1.0.0
	 */
	public class BMPEncode
	{
		private var mydata:ByteArray;
		//文件数据
		private var mybitmap:BitmapData;
		//图像数据
		private var shulian:uint=0;
		//计数
		private var biWidth:uint;//BMP图像的宽度，单位像素
		private var biHeight:uint;//BMP图像的高度，单位像素
		
		private var wenjianchangdu:uint;//文件长度
		private var tuxianshujudaxiao:uint;//图像数据大小
		private var tuxianshujudizhi:uint;//图像数据地址
		private var Offset:uint;//每行偏移 
		
		public function BMPEncode() {
			// constructor code			
			
		}
		//构造函数
		private function BITMAPFILEHEADER():void
		{
			this.biWidth=this.mybitmap.width;
			this.biHeight=this.mybitmap.height;
			var Offset:uint;//每行偏移
			Offset=(this.biWidth*3)&0x3;
			if(Offset>0){
				Offset=4-Offset;
			}
			//计算每行偏移
			this.tuxianshujudaxiao=this.biHeight*(this.biWidth*3+Offset);
			//计算位图数据的大小
			this.wenjianchangdu=54+this.tuxianshujudaxiao;
			//计算文件的长度
			this.mydata.writeUTFBytes("BM");
			//跳过文件长度
			this.mydata.writeUnsignedInt(this.wenjianchangdu);
			//写入文件的长度
			this.mydata.writeShort(0);
			this.mydata.writeShort(0);
			//跳过BMP图像数据的地址			
			this.tuxianshujudizhi=54;
			this.mydata.writeUnsignedInt(this.tuxianshujudizhi);
			//写入图像数据地址
		}//位图文件头
		private function BITMAPINFOHEADER():void
		{		
			this.mydata.writeUnsignedInt(40);
			this.mydata.writeUnsignedInt(this.mybitmap.width);
			this.mydata.writeUnsignedInt(this.mybitmap.height);
			this.mydata.writeShort(1);
			this.mydata.writeShort(24);
			this.mydata.writeUnsignedInt(0);
			//跳过BMP图像数据大小			
			this.mydata.writeUnsignedInt(this.tuxianshujudaxiao);
			//写入图像数据大小
			this.mydata.writeUnsignedInt(2834);
			this.mydata.writeUnsignedInt(2834);
			//72像素每英寸
			this.mydata.writeUnsignedInt(0);
			this.mydata.writeUnsignedInt(0);			
		}//位图信息头40个字节
		
		
		// 对图片进行BMP格式编码
		public function encode ( bitmapData:BitmapData ) : ByteArray
		{
			this.mydata = new ByteArray();
			this.mydata.endian = Endian.LITTLE_ENDIAN;
			this.mybitmap = bitmapData;
			this.mydata.clear();
			BITMAPFILEHEADER();
			BITMAPINFOHEADER();
			bitmapdata();
			return this.mydata;
		}
		
		//设置保存数据
		private function bitmapdata():void
		{
			var i:uint,j:uint,p:uint,color:uint,r:uint,g:uint,b:uint,k:uint;			
			for(i=0;i<this.biHeight;i++){
				for(j=0;j<this.biWidth;j++)
				{					
					color=this.mybitmap.getPixel(j,this.biHeight-i-1);
					b=color&0xff;
					g=(color>>8)&0xff;
					r=color>>16;
					this.mydata.writeByte(b);
					this.mydata.writeByte(g);
					this.mydata.writeByte(r);					
					if(j==this.biWidth-1&&Offset!=0){						
						for(k=0;k<Offset;k++){
							this.mydata.writeByte(0);
						}
					}
				}
			}
		}
		//图像数据
	}
}
//写入BMP文件
//BMP文件格式：24位图像
		