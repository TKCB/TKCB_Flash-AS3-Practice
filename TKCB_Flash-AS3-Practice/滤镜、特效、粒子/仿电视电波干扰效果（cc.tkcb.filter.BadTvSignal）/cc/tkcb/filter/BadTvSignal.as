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
 * 修 改 者：TKCB
 * 改者信息：身高（0.00167公里+）；体重（0.06吨±）；年龄（公元1990后）；籍贯（有兵马俑的地方）；星座（最后一个星座）；血型（万能型）；人生格言（The king come back.）。
 * 交流学习：加QQ群[AS3殿堂之路]（96759336），群里有无数主城、架构、妹子、LOL战友，欢迎交流讨论。
 * 联系方式：QQ（2414268040）；E-mail（tkcb@qq.com）；手机（15029932353)。
 * 改者网站：www.tkcb.cc（来这里关注我吧，这里有我所有的作品，分享的资料，我的介绍和动态，还有更多你想不到的）
 *
 * 
 * 获取软件/程序最新版本：www.tkcb.cc
 *
 *
 * 版权协议：请自觉遵守LGPL协议，欢迎复制、转载、传播给更多需要的人。
 * 免责声明：任何因使用此软件导致的纠纷与软件/程序开发者无关。
 */
 

/*
这是一个其他高手写的类库，而我（TKCB）只是作为修改者，是它成为我的类库中的子类而已。
感谢原作者，而我未来也会将我的类库共享给大家，使大家更专注与顶层的设计，更快的设计出更好的产品，而不是总是浪费时间在重复的底层代码（当然底层代码的学习也是很重要的）。
*/


/* 
 * @version 版本创建时间和修改说明
 * v1.0.0 2015-12-4
 */

package cc.tkcb.filter
{
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BitmapDataChannel;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	/**
	 * BadTvSignal 类是一个用于产生干扰效果的特效，如果干扰特效对象和干扰对象在同一个容器，则干扰对象会继承一些遮罩效果。
	 * @author 未知（修改者TKCB（www.tkcb.cc）
	 * @创建时间 未知
	 * @修改时间 2015-12-4
	 * @version 1.0.0
	 */
	public class BadTvSignal extends Sprite
	{
		//************************ ************************* 属　　性 ******************** *********** *** **////
		//Used to keep track if the effect is running or not...
		public static var isRunning:Boolean;
		
		//The display object on which the effect is applied.
		private var _sourceDisplayObject:DisplayObject;
		
		//The final bitmap, the one on which the effect is applied.
		private var _finalBitmap:Bitmap;
		
		//Used as a bitmap data for the final bitmap.
		private var _finalBitmapData:BitmapData;
		
		//Use to create the noise sound.
		private var _sound:Sound;
		
		//Used to play the noise sound.
		private var _soundChannel:SoundChannel;
		
		//Holds a reference to a set of Point instances, used to displace the pixels.
		private var _rgbPoints:Array;
		
		//Used as a random numebr to displace the bitmapData pixels.
		private var  _randomNr:Number;
		
		//Used as an id for the random noise interval.
		private var _stopNoiseDisplayIntervalId:int;
		
		//Used as an id for the random noise interval.
		private var _startNoiseDisplayIntervalId:int;
		
		//Used as a flag to check if the sound is playing.
		private var _isSoundPlaying:Boolean;
		
		
		
		//************************ ************************* 构造函数 ******************** *********** *** **////
		/**
		 * 将用于创造干扰效果的对象（DisplayObject）添加到对象中，以便后面进行创造对象的干扰效果。
		 * 我（TKCB）添加了一个新的参数，noiseSound用于传入声音对象，而不是直接new Flash库中的声音类，这样更方便灵活一些，并且可以不传入该参数
		 */
		public function BadTvSignal ( sourceDisplayObject : DisplayObject, noiseSound : Sound = null )
		{
			_sourceDisplayObject = sourceDisplayObject;
			setProperties();
			if ( noiseSound != null )
			{
				setupSound( noiseSound );
			}
			else
			{
				_sound = null;
			}
		}
		
		
		//************************ ************************* 方　　法 ******************** *********** *** **////
		//SET PROPERTIES.
		private function setProperties():void{
			_rgbPoints = [new Point(0, 0), new Point(0, 0), new Point(0, 0)];
			_randomNr = 3.1;
		}
		
		//SETUP SOUND.
		private function setupSound( noiseSound : Sound ):void{
			_soundChannel = new SoundChannel();
			_sound = noiseSound;
		}
		
		/** Start to play the sound. */
		private function playSound():void{
		    _soundChannel = _sound.play();
		    var st:SoundTransform = new SoundTransform(.5 + Math.random() * .3, -1 + Math.random() * 2 )
		    _soundChannel.soundTransform = st;
			_isSoundPlaying = true;
		    _soundChannel.addEventListener(Event.SOUND_COMPLETE, loopSound);
		}
		
		/** Loop the sound. */
		private function loopSound(e:Event):void {
		    if (_soundChannel != null) {
		        _soundChannel.removeEventListener(Event.SOUND_COMPLETE, loopSound);
				playSound();
		    }
		}
		
		/** Stop the sound. */
		private function stopSound():void {
		    if (_soundChannel != null) {
				_soundChannel.stop();
				_isSoundPlaying = false;
				_soundChannel.removeEventListener(Event.SOUND_COMPLETE, loopSound);
		    }
		}
		
		/**
		 * 开始显示干扰效果
		 */
		public function start():void{
			if ( _sound != null )
			{
				playSound();
			}
			addEventListener(Event.ENTER_FRAME, enterFrameHandler);
			_sourceDisplayObject.visible = false;
			this.visible = true;
		}
		
		/**
		 * 停止干扰效果
		 */
		public function stop():void{
			stopSound();
			clearTimeout(_stopNoiseDisplayIntervalId);
		    clearTimeout(_startNoiseDisplayIntervalId);
			removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
			_sourceDisplayObject.visible = true;
			if(_finalBitmap != null) _finalBitmap.bitmapData.dispose();
			this.visible = false;
			isRunning = false;
		}
		
		/**
		 * 开始随机干扰效果
		 */
		public function startRandom():void{
		    clearTimeout(_stopNoiseDisplayIntervalId);
		    clearTimeout(_startNoiseDisplayIntervalId);
		    
		    _startNoiseDisplayIntervalId = setTimeout(start, randomize(0, 1000));
		    _stopNoiseDisplayIntervalId = setTimeout(stopRandomAndRestart, randomize(1000, 1800));
		}
		
		private function stopRandomAndRestart():void{
			clearTimeout(_stopNoiseDisplayIntervalId);
			stop();
			startRandom();
		}
		
		private function enterFrameHandler(e:Event):void{
			isRunning = true;
			runEffect();
		}
		
		//THIS FUNCTION CREATES THE BAD TV EFFECT.
		private function runEffect():void {
			
			var auxImg1:BitmapData;
			var auxImg2:BitmapData;
			var sourceWidth:Number = _sourceDisplayObject.width;
			var sourceHeight:int =  _sourceDisplayObject.height;
		
			if(_finalBitmapData != null) _finalBitmapData.dispose();
			
			_finalBitmapData = new BitmapData(sourceWidth, sourceHeight, false);
			_finalBitmap = new Bitmap(_finalBitmapData);
			addChild(_finalBitmap);
			
			_finalBitmapData.draw(_sourceDisplayObject);
			
			auxImg1 = _finalBitmapData.clone();
			auxImg2 = _finalBitmapData.clone();
			 
			for (var i:int=0; i<3; i++){
				_rgbPoints[i].x = randomize(-4, 4);
			}
			
			var displacementFactor:Number = (Math.abs(_rgbPoints[0].x) + Math.abs(_rgbPoints[1].x) + Math.abs(_rgbPoints[2].x) + 8) / 4;
			
			for (i = sourceHeight; i>0; i--){
		        var displacementX:Number = Math.sin(i / sourceHeight * (Math.random() / 8 + 1) * _randomNr * 3.1 * 2) * _randomNr * displacementFactor * displacementFactor;
		       
			   	auxImg1.copyPixels(_finalBitmapData, new Rectangle(displacementX, i, sourceWidth - displacementX, 1), new Point(0, i));
		    }
		    
		    if (displacementFactor > 3.5){
		        _randomNr = Math.random() * 2;
		    }
		    
		    auxImg2.noise(int(Math.random() * 1000));
				
		    var colorNoise:Number = displacementFactor * displacementFactor * displacementFactor;
				
		    auxImg1.merge(auxImg2, auxImg1.rect, new Point(0, 0), colorNoise, colorNoise, colorNoise, 0); 
		    
		    _finalBitmapData.copyChannel(auxImg1, _finalBitmapData.rect, _rgbPoints[0], BitmapDataChannel.RED, BitmapDataChannel.RED);
		    _finalBitmapData.copyChannel(auxImg1, _finalBitmapData.rect, _rgbPoints[1], BitmapDataChannel.GREEN, BitmapDataChannel.GREEN);
		    _finalBitmapData.copyChannel(auxImg1, _finalBitmapData.rect, _rgbPoints[2], BitmapDataChannel.BLUE, BitmapDataChannel.BLUE);
		}
		
		//RETURNS A RAMNDOM NUMBER BETWEEN THE MIN AND MAX VALUES.
		function randomize(min:int, max:int):int{
		    var ran:int = Math.floor(Math.random() * (max - min + 1)) + min;
		    return ran;
		}
		
	}
}