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

package cc.tkcb.display.bmp
{
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	import flash.display.BitmapData;
	
	/**
	 * BMPAnalytical BMP格式解析类，用于解析BMP格式二进制数据，并且从中获取位图数据信息。 
	 * @author TKCB（www.tkcb.cc）
	 * @创建时间 未知
	 * @修改时间 2017-11-26
	 * @version 1.0.0
	 */
	public class BMPAnalytical
	{
		private var mydata : ByteArray;
		
		//BMP图像数据的地址
		private var bfOffBits : uint;
		
		//BMP图像的宽度，单位像素
		private var biWidth : uint;
		
		//BMP图像的高度，单位像素
		private var biHeight : uint;
		
		//平面数
		private var biPlanes : uint;
		
		//BMP图像的色深，即一个像素用多少位表示，常见有1、4、8、16、24和32，分别对应单色、16色、256色、16位高彩色、24位真彩色和32位增强型真彩色
		private var biBitCount : uint;
		
		//压缩方式，0表示不压缩，1表示RLE8压缩，2表示RLE4压缩，3表示每个像素值由指定的掩码决定
		private var biCompression : uint;
		
		//BMP图像数据大小，必须是4的倍数，图像数据大小不是4的倍数时用0填充补足
		private var biSizeImage : uint;
		
		//水平分辨率
		private var biXPelsPerMeter : uint;
		
		//垂直分辨率
		private var biYPelsPerMeter : uint;
		
		//BMP图像使用的颜色，0表示使用全部颜色，对于256色位图来说，此值为100h = 256
		private var biClrUsed : uint;
		
		//重要的颜色数，此值为0时所有颜色都重要，对于使用调色板的BMP图像来说，当显卡不能够显示所有颜色时，此值将辅助驱动程序显示颜色
		private var biClrImportant : uint;
		
		//调色盘
		private var colorArray : Vector.<uint>;
		
		//位图数据
		private var imagedata : BitmapData;
		
		/**
		 * 构造函数
		 */
		public function BMPAnalytical ()
		{
			
		}
		
		/**
		 * 解析由[Embed()]元素直接获取的图片对象，例如：[Embed(source="4位压缩.bmp",mimeType="application/octet-stream")]
		 */
		public function analyticalClass ( bmpClass:Class ) : void
		{
			// constructor code
			this.mydata = new bmpClass as ByteArray;
			this.mydata.endian = Endian.LITTLE_ENDIAN;
			BITMAPFILEHEADER();
			BITMAPINFOHEADER();
			colortable();
			bitmapdata();
		}
		/**
		 * 解析由URLLoader等方法二进制加载图片对象
		 */
		public function analyticalByteArray ( bmpByteArray:ByteArray ) : void
		{
			this.mydata = bmpByteArray;
			this.mydata.endian = Endian.LITTLE_ENDIAN;
			BITMAPFILEHEADER();
			BITMAPINFOHEADER();
			colortable();
			bitmapdata();
		}
		
		private function BITMAPFILEHEADER () : void
		{
			if ( this.mydata.readUTFBytes(2) != "BM" )
			{
				throw new Error( "不是BMP文件！" )
			}
			if ( this.mydata.readUnsignedInt() != this.mydata.length )
			{
				throw new Error( "文件不全！" );
			}
			this.mydata.position += 4;
			this.bfOffBits = this.mydata.readUnsignedInt();
			//trace( "BMP图像数据的地址：" + this.bfOffBits );
		}
		
		//位图文件头
		private function BITMAPINFOHEADER () : void
		{
			this.mydata.position += 4;
			this.biWidth = this.mydata.readUnsignedInt();
			//trace( "BMP图像的宽度:" + this.biWidth )			
			
			this.biHeight = this.mydata.readUnsignedInt();
			//trace( "BMP图像的高度:" + this.biHeight )
			
			this.biPlanes = this.mydata.readUnsignedShort();						
			this.biBitCount = this.mydata.readUnsignedShort();
			//trace( "BMP图像的色深:" + this.biBitCount );
			
			this.biCompression = this.mydata.readUnsignedInt();
			//trace( "压缩方式:" + this.biCompression );
			
			this.biSizeImage = this.mydata.readUnsignedInt();
			//trace( "BMP图像数据大小:" + this.biSizeImage );
			
			this.biXPelsPerMeter = this.mydata.readUnsignedInt();
			this.biYPelsPerMeter = this.mydata.readUnsignedInt();
			this.biClrUsed = this.mydata.readUnsignedInt();
			this.biClrImportant = this.mydata.readUnsignedInt();
		}
		
		//位图信息头
		private function colortable () : void
		{
			if ( this.biBitCount <= 8 )
			{
				this.colorArray = new Vector.<uint>();
				//trace( "使用调色盘!" )
				var r:uint,g:uint,b:uint,color:uint,i:uint;
				
				var end : uint = Math.pow( 2, this.biBitCount );
				for ( i = 0; i < end; i++ )
				{
					b = this.mydata.readUnsignedByte();
					g = this.mydata.readUnsignedByte();
					r = this.mydata.readUnsignedByte();
					this.mydata.position++;
					color = (r<<16) + (g<<8) + b;					
					this.colorArray[i] = color;					
				}				
			}
			else
			{
				//trace("不使用调色盘!")
			}
		}
		
		//彩色表/调色板
		private function bitmapdata () : void
		{
			this.mydata.position = this.bfOffBits;			
			var Offset : uint;//每行偏移				
			
			var i:uint,j:uint,p:uint,color:uint,r:uint,g:uint,b:uint,a:uint;
			
			var end:uint,bytes1:uint,bytes2:uint,k:uint,x:uint,y:uint;
			
			if ( this.biBitCount <= 8 )
			{
				this.imagedata = new BitmapData( this.biWidth, this.biHeight, false, 0x000000 );
				if ( this.biBitCount == 8 )
				{				
					if ( this.biCompression == 0 )
					{
						Offset = this.biSizeImage / this.biHeight - this.biWidth;//每行偏移				
					    for ( i = 0; i < this.biHeight; i++ )
						{
						    for ( j = 0; j < this.biWidth; j++ )
							{
							    p = this.mydata.readUnsignedByte();
							    color = this.colorArray[p];
							    this.imagedata.setPixel( j, this.biHeight - i - 1, color );
							    if ( j == this.biWidth - 1 )
								{
								    this.mydata.position += Offset;
							    }
						    }
					    }
					//不压缩					
					}
					else
					{
						x = 0;
						y = 0;
						while ( this.mydata.bytesAvailable > 0 )
						{
							bytes1 = this.mydata.readUnsignedByte();							
							bytes2 = this.mydata.readUnsignedByte();															
							if ( bytes1 >= 0x01 )
							{								
								for ( i = 0; i < bytes1; i++ )
								{
									color = this.colorArray[bytes2];
									this.imagedata.setPixel( x, this.biHeight - y - 1, color );
									x++;
								}								
							//每像素8位的BMP文件,连续重复数据以两字节表示,第一个字节记录重复次数,第二字节记录重复数据。
							}
							else
							{								
								if ( bytes2 >= 0x03 )
								{									
									for ( i = 0; i < bytes2; i++ )
									{
										p = this.mydata.readUnsignedByte();
										color = this.colorArray[p];
										this.imagedata.setPixel( x, this.biHeight - y - 1, color );
										x++;
									}								
									if ( this.mydata.readUnsignedByte() == 0x00 )
									{
										//无重复像素结束符
									}
									else
									{
										this.mydata.position--;
									}
								}
								//如果是3个以上不重复的数据字节,第1个字节为00,第2个字节记录该不重复的数据串的长度(以字节为单位)
								else if ( bytes2 == 0x02 )
								{
									x += this.mydata.readUnsignedByte();
									y += this.mydata.readUnsignedByte();
								}
								//像素位置跳转符
								else if ( bytes2 == 0x01 )
								{
									//图像结束符							
									break;
								}
								else
								{
									x = 0;
									y++;
									//换行符
								}
							}
						}
						//压缩
					}
				}
				//8位图像
				var bit:uint,str:String,Num:uint;				
				var p1:uint,p2:uint,p3:uint,p4:uint,p5:uint,p6:uint,p7:uint,p8:uint;
				
				if ( this.biBitCount == 1 )
				{
					Offset = this.biSizeImage / this.biHeight;//每行偏移														
					for ( i = 0; i < this.biHeight; i++ )
					{
						for ( j = 0; j < Offset; j++ )
						{
							bit = this.mydata.readUnsignedByte() + 256;							
							str = bit.toString(2);							
							p1 = uint( str.charAt(1) );
							p2 = uint( str.charAt(2) );
							p3 = uint( str.charAt(3) );
							p4 = uint( str.charAt(4) );
							p5 = uint( str.charAt(5) );
							p6 = uint( str.charAt(6) );
							p7 = uint( str.charAt(7) );
							p8 = uint( str.charAt(8) );							
							this.imagedata.setPixel( j*8,this.biHeight-i-1,this.colorArray[p1] );
							this.imagedata.setPixel( j*8+1,this.biHeight-i-1,this.colorArray[p2] );
							this.imagedata.setPixel( j*8+2,this.biHeight-i-1,this.colorArray[p3] );
							this.imagedata.setPixel( j*8+3,this.biHeight-i-1,this.colorArray[p4] );
							this.imagedata.setPixel( j*8+4,this.biHeight-i-1,this.colorArray[p5] );
							this.imagedata.setPixel( j*8+5,this.biHeight-i-1,this.colorArray[p6] );
							this.imagedata.setPixel( j*8+6,this.biHeight-i-1,this.colorArray[p7] );
							this.imagedata.setPixel( j*8+7,this.biHeight-i-1,this.colorArray[p8] );							
						}
					}				
				}
				//1位图像
				if ( this.biBitCount == 4 )
				{
					if ( this.biCompression == 0 )
					{
						Offset = this.biSizeImage/this.biHeight;//每行偏移	
					    for ( i = 0; i < this.biHeight; i++ )
						{
						    for ( j = 0; j < Offset; j++ )
							{
							    bit = this.mydata.readUnsignedByte();							
							    p2 = bit>>4;
							    p1 = bit-(p2<<4);
							    this.imagedata.setPixel(j*2,this.biHeight-i-1,this.colorArray[p2]);
							    this.imagedata.setPixel(j*2+1,this.biHeight-i-1,this.colorArray[p1]);
						    }
					    }						
						//不压缩
					}
					else
					{
						x = 0;
						y = 0;
						var col1:uint,col2:uint,b1:uint;
						while ( this.mydata.bytesAvailable > 0 )
						{
							bytes1 = this.mydata.readUnsignedByte();
							bytes2 = this.mydata.readUnsignedByte();
							if ( bytes1 >= 0x01 )
							{								
								col2 = bytes2>>4;
								col1 = bytes2-(col2<<4);
								for ( i = 0; i < bytes1; i++ )
								{
									if ( i%2 == 0 )
									{
										p = col2;
									}
									else
									{
										p = col1;
									}
									color = this.colorArray[p];
									this.imagedata.setPixel( x, this.biHeight-y-1, color );
									x++;
								}
								//重复的像素值
							}
							else
							{
								if ( bytes2 >= 0x03 )
								{
									for ( i = 0; i < bytes2; i++ )
									{
										if ( i%2 == 0 )
										{
											b1 = this.mydata.readUnsignedByte();
											col2 = b1>>4;
											col1 = b1-(col2<<4);
											p = col2;
										}
										else
										{
											p = col1;
										}
										color = this.colorArray[p];										
										this.imagedata.setPixel(x,this.biHeight-y-1,color);
										x++;										
									}
									if ( this.mydata.readUnsignedByte() == 0x00 )
									{
										//无重复像素结束符
									}
									else
									{
										this.mydata.position--;
									}
									//如果是3个以上不重复的数据字节,第1个字节为00,第2个字节记录该不重复的数据串的长度(以字节为单位)
									//不重复的像素值
								}
								else if ( bytes2 == 0x02 )
								{
									x += this.mydata.readUnsignedByte();
									y += this.mydata.readUnsignedByte();
									//像素位置跳转符
								}
								else if ( bytes2 == 0x01 )
								{									
									break;
									//图像结束符
								}
								else
								{
									x = 0;
									y++;
									//换行符
								}
							}
						}
						//压缩
					}
				}//4位图像
				//使用调色盘
			}
			else
			{
				if ( this.biBitCount == 32 )
				{
					this.imagedata = new BitmapData(this.biWidth,this.biHeight,true,0xff000000);
					Offset = (this.biSizeImage-this.biWidth*this.biHeight*4)/this.biHeight;
					for ( i = 0; i < this.biHeight; i++ )
					{
						for ( j = 0; j < this.biWidth; j++ )
						{
							b = this.mydata.readUnsignedByte();
							g = this.mydata.readUnsignedByte();
							r = this.mydata.readUnsignedByte();
							a = this.mydata.readUnsignedByte();														
							color = (a<<24)+(r<<16)+(g<<8)+b;
							this.imagedata.setPixel(j,this.biHeight-i-1,color);
							if ( j == this.biWidth-1 )
							{
								this.mydata.position += Offset;
							}
						}
					}
					//有透明度的位图					
				}
				else
				{
					this.imagedata = new BitmapData(this.biWidth,this.biHeight,false,0x000000);
					if ( this.biBitCount == 24 )
					{
						Offset = (this.biSizeImage-this.biWidth*this.biHeight*3)/this.biHeight;
						for ( i = 0; i < this.biHeight; i++ )
						{
							for ( j = 0; j < this.biWidth; j++ )
							{
								b = this.mydata.readUnsignedByte();
								g = this.mydata.readUnsignedByte();
								r = this.mydata.readUnsignedByte();
								color = (r<<16)+(g<<8)+b;
								this.imagedata.setPixel(j,this.biHeight-i-1,color);
								if ( j == this.biWidth-1 )
								{
									this.mydata.position += Offset;
								}
							}
						}
					}//24位图像
					var shortint:uint;
					if ( this.biBitCount == 16 )
					{
						Offset = (this.biSizeImage-this.biWidth*this.biHeight*2)/this.biHeight;						
						if ( this.biCompression == 3 )
						{
							for ( i = 0; i < this.biHeight; i++ )
							{
								for ( j = 0; j < this.biWidth; j++ )
								{
									shortint = this.mydata.readUnsignedShort();
									r = shortint>>11;
									g = (shortint-(b<<11))>>5;
									b = shortint-(b<<11)-(g<<5);
									color = (r<<19)+(g<<10)+(b<<3);
									this.imagedata.setPixel(j,this.biHeight-i-1,color);
									if ( j == this.biWidth-1 )
									{
										this.mydata.position += Offset;
									}
								}
							}
						}//565压缩
						if ( this.biCompression == 0 )
						{							
							for ( i = 0; i < this.biHeight; i++ )
							{
								for ( j = 0; j < this.biWidth; j++ )
								{
									shortint = this.mydata.readUnsignedShort();
									shortint = shortint-((shortint>>15)<<15);
									r = shortint>>10;
									g = (shortint-(b<<10))>>5;
									b = shortint-(b<<10)-(g<<5);
									color = (r<<19)+(g<<11)+(b<<3);
									this.imagedata.setPixel(j,this.biHeight-i-1,color);
									if ( j == this.biWidth-1 )
									{
										this.mydata.position += Offset;
									}
								}
							}
						}//X555压缩
					}//16位图像
					//没有透明度的位图
				}
				//不使用调色盘				
			}
		}//位图数据
		public function get ImageDate() : BitmapData
		{
			return this.imagedata;
		}//返回位图数据
	}
}