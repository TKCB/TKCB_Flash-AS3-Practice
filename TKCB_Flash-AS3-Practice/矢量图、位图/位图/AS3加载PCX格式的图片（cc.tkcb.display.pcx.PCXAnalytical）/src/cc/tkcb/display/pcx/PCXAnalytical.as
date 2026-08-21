/*
 * 修 改 者：TKCB
 * 修者信息：身高（0.00167公里+）；体重（0.06吨±）；年龄（公元1990后）；籍贯（有兵马俑的地方）；星座（最后一个星座）；血型（万能型）；人生格言（The king come back.）。
 * 交流学习：加QQ群[AS3殿堂之路]（96759336），群里有无数主城、架构、妹子、LOL战友，欢迎交流讨论。
 * 联系方式：QQ（2414268040）；E-mail（tkcb@qq.com）；手机（15029932353)。
 * 个人网站：www.tkcb.cc（来这里关注我吧，这里有我所有的作品，分享的资料，我的介绍和动态，还有更多你想不到的）
 */

/* 
 * @version 版本创建时间和修改说明
 * v1.0.0 2017-11-26 整理大神的类，并调整格式，修改部分代码
 */

package cc.tkcb.display.pcx
{
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	import flash.display.BitmapData;
	
	/**
	 * PCXAnalytical PCX格式解析类，用于解析PCX格式二进制数据，并且从中获取位图数据信息。 
	 * @author TKCB（www.tkcb.cc）
	 * @创建时间 未知
	 * @修改时间 2017-11-26
	 * @version 1.0.0
	 */
	public class PCXAnalytical
	{
		private var mydata:ByteArray;//数据
		//主数据参数
		private var Digit:uint;//图片的位数
		private var Xmin:int;
		private var Ymin:int;
		private var Xmax:int;
		private var Ymax:int;//图片边界
		private var HorizontalResolution:uint;//水平分辨率
		private var VerticalResolution:uint;//垂直分辨率
		private var FilePalette:Vector.<uint > ;//文件头调色板
		//灰度调色板
		private var planeNumber:uint;//彩色/灰度平面数
		private var NumberOfBytesPerRow:uint;//每行字节数
		private var PaletteInterpretation:uint;//调色板解释
		//1为彩色或黑白，2为灰度
		private var width:uint;
		private var height:uint;//图片的长和宽
		//文件头参数
		private var BitmapDataArray:Vector.<Vector.<uint >  > ;//位图数据数组

		//位图数据参数
		private var VGAArray:Vector.<uint>;
		//VGA调色板		
		private var PixelDigits:uint;//像素位数

		private var imagedata:BitmapData;//位图数据
		
		
		/**
		 * 构造函数
		 */
		public function PCXAnalytical ()
		{
			
		}
		
		/**
		 * 解析由[Embed()]元素直接获取的图片对象，例如：[Embed(source="aaa.pcx",mimeType="application/octet-stream")]
		 */
		public function analyticalClass ( pcxClass:Class ) : void
		{
			// constructor code
			mydata = new pcxClass as ByteArray;
			mydata.endian = Endian.LITTLE_ENDIAN;
			FileHeader();//文件头
			Bitmapdata();//位图数据
		}
		/**
		 * 解析由URLLoader等方法二进制加载图片对象
		 */
		public function analyticalByteArray ( pcxByteArray:ByteArray ) : void
		{
			// constructor code
			mydata = pcxByteArray;
			mydata.endian = Endian.LITTLE_ENDIAN;
			FileHeader();//文件头
			Bitmapdata();//位图数据
		}
		
		private function FileHeader () : void
		{
			if (mydata.readByte() != 10)
			{
				throw new Error("不是PCX文件!");
			}
			//trace("版本号:"+mydata.readByte());
			mydata.readByte()	// 2017.11.26 TKCB 新加代码	
			//trace("PCX游程长度编码:"+mydata.readByte());
			mydata.readByte();	// 2017.11.26 TKCB 新加代码	
			Digit = mydata.readUnsignedByte();
			//trace("图片的位数:"+Digit);
			Xmin = mydata.readShort();
			Ymin = mydata.readShort();
			Xmax = mydata.readShort();
			Ymax = mydata.readShort();
			this.HorizontalResolution = mydata.readUnsignedShort();
			this.VerticalResolution = mydata.readUnsignedShort();
			this.FilePalette = new Vector.<uint > (16,true);
			var i:uint,r:uint,g:uint,b:uint;
			for (i=0; i<16; i++)
			{
				r = mydata.readUnsignedByte();
				g = mydata.readUnsignedByte();
				b = mydata.readUnsignedByte();
				this.FilePalette[i] = (r << 16) + (g << 8) + b;				
			}
			mydata.position++;
			this.planeNumber = mydata.readByte();
			this.NumberOfBytesPerRow = mydata.readUnsignedShort();
			//trace("每行字节数："+this.NumberOfBytesPerRow);
			this.PaletteInterpretation = mydata.readUnsignedShort();
			//trace("调色板解释:"+this.PaletteInterpretation);			
			this.width = mydata.readShort();
			this.height = mydata.readShort();
			this.width = this.Xmax - this.Xmin + 1;
			this.height = this.Ymax - this.Ymin + 1;
			//trace("长:"+this.width+"     宽:"+this.height);			
			mydata.position +=  54;
		}//文件头
		private function Bitmapdata():void
		{
			this.BitmapDataArray=new Vector.<Vector.<uint>>();
			this.imagedata=new BitmapData(this.width,this.height,false,0x000000);
			if(this.Digit==1){
				this.PixelDigits=this.planeNumber;
			}
			if(this.Digit==2){
				if(this.planeNumber==1){
					this.PixelDigits=2;
				}
				if(this.planeNumber==4){
					this.PixelDigits=4;
				}
			}
			if(this.Digit==4&&this.planeNumber==1){
				this.PixelDigits=4;
			}
			if(this.Digit==8){
				this.PixelDigits=8*this.planeNumber;
			}
			//trace("图像最终位数"+this.PixelDigits)
			//图像位数的分析
			var i:uint,j:uint,x:uint=0,y:uint=0,bytes1:uint,bytes2:uint,r:uint,g:uint,b:uint,a:uint,color:uint;
			var b1:uint,b2:uint,str:String,p:uint,num:uint;
			var pa:Vector.<uint>=new Vector.<uint>();
			if(this.PixelDigits<=8){
				if(this.PixelDigits==8){
					for(j=0;j<this.height;j++){
						x=0;
						this.BitmapDataArray[j]=new Vector.<uint>();
						while(x<this.width){
							bytes1=this.mydata.readUnsignedByte();
							b1=bytes1>>6;
							//读取一个字节
							if(b1==0x03){
								num=bytes1-(b1<<6);//重复次数
								p=this.mydata.readUnsignedByte();//重复颜色的索引
								for(i=0;i<num;i++){
									this.BitmapDataArray[j][x]=p;//存入位图索引数据到数组中;
									x++;
								}
								//重复的字节
							}else{
								this.BitmapDataArray[j][x]=bytes1;
								x++;
								//不重复的字节
							}							
						}
						//一行一行的解析,j为枞坐标，x为横坐标						
					}					
					VGAPalette()
					//VGA调色板
					for(i=0;i<this.width;i++){
						for(j=0;j<this.height;j++){
							p=this.BitmapDataArray[j][i];
							color=this.VGAArray[p];
							this.imagedata.setPixel(i,j,color);
						}
					}
					//8位（彩色照片）
				}
				if(this.PixelDigits==4){
					for(j=0;j<this.height;j++){
						x=0;
					}
				}//4位(黑白照片)不需要VGA调色板
				if(this.PixelDigits==1){
					
				}//1位
				//用调色板
			}else{
				if(this.PixelDigits==24){
					var line:Vector.<uint>=new Vector.<uint>();
					for(j=0;j<this.height;j++){
						x=0;
						while(x<this.width){
							bytes1=this.mydata.readUnsignedByte();
							b1=bytes1>>6;
							if(b1==0x03){
								num=bytes1-(b1<<6);
								p=this.mydata.readUnsignedByte();
								p=p<<16
								for(i=0;i<num;i++){
									line[x]=p;
									x++;
								}
							}else{
								line[x]=bytes1<<16;
								x++;
							}
						}
						//第一条扫描线(红色)
						x=0;
						while(x<this.width){
							bytes1=this.mydata.readUnsignedByte();
							b1=bytes1>>6;
							if(b1==0x03){
								num=bytes1-(b1<<6);
								p=this.mydata.readUnsignedByte();
								p=p<<8;
								for(i=0;i<num;i++){
									line[x]+=p;
									x++;
								}
							}else{
								line[x]+=bytes1<<8;
								x++;
							}
						}
						//第二条扫描线(绿色)
						x=0;
						while(x<this.width){
							bytes1=this.mydata.readUnsignedByte();
							b1=bytes1>>6;
							if(b1==0x03){
								num=bytes1-(b1<<6);
								p=this.mydata.readUnsignedByte();								
								for(i=0;i<num;i++){
									line[x]+=p;
									x++;
								}
							}else{
								line[x]+=bytes1;
								x++;
							}
						}
						//第三条扫描线(蓝色)
						for(i=0;i<this.width;i++){
							this.imagedata.setPixel(i,j,line[i]);
						}
						//混合三个通道的颜色
					}
				}//24位				
				//不用调色板
			}
			
		}
		private function VGAPalette():void
		{
			this.VGAArray=new Vector.<uint>();
			this.mydata.position=this.mydata.length-768;
			var i:uint,r:uint,g:uint,b:uint;
			for(i=0;i<256;i++){
				r=this.mydata.readUnsignedByte();
				g=this.mydata.readUnsignedByte();
				b=this.mydata.readUnsignedByte();
				this.VGAArray[i]=(r<<16)+(g<<8)+b;
			}
		}//VGA调色板
		public function get ImageDate():BitmapData
		{
			return this.imagedata;
		}//返回位图数据
	}//位图数据
}


//PCX文件读取