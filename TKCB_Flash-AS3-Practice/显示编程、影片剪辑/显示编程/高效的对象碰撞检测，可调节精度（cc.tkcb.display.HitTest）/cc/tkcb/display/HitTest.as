/*
 * DO NOT ALTER OR REMOVE COPYRIGHT NOTICES OR THIS HEADER.
 *
 * Copyright TKCB, www.tkcb.cc
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
 * v1.0.0 2019-1-23
 */
package cc.tkcb.display
{
    import flash.display.BitmapData;
    import flash.display.BlendMode;
    import flash.display.DisplayObject;
    import flash.display.Sprite;
    
    import flash.geom.ColorTransform;
    import flash.geom.Matrix;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    
	
	/**
	 * ElasticCord 高效的不规则物体碰撞检测类，原作者据说是外国大神
	 * @author TKCB（www.tkcb.cc）
	 * @创建时间 2018-10-23
	 * @修改时间 2018-10-23
	 * @version 1.0.0
	 */
    public class HitTest
    {
		//************************ ************************* 静态方法 ******************** *********** *** **////
        /** 
		 * 判断两物体是否发生碰撞（可调节精度）
		 */
        public static function complexHitTestObject ( target1:DisplayObject, target2:DisplayObject,  accuracy:Number = 1 ) : Boolean
        {
            return complexIntersectionRectangle( target1, target2, accuracy ).width != 0;
        }
        
        /** 
		 * 获取碰撞相交矩形区域
		 */
        public static function intersectionRectangle ( target1:DisplayObject, target2:DisplayObject ) : Rectangle
        {
            // 如果有任一对象没加入显示列表，或者两对象hitTestObject的结果为false，则代表两对象没有发生碰撞
            if( !target1.root || !target2.root || !target1.hitTestObject( target2 ) ) return new Rectangle();
            
            // 分别得到两对象的显示矩形区域
            var bounds1:Rectangle = target1.getBounds( target1.root );
            var bounds2:Rectangle = target2.getBounds( target2.root );
            
            // 得出两对象相交部分的矩形区域
            var intersection:Rectangle = new Rectangle();
            intersection.x   = Math.max( bounds1.x, bounds2.x );
            intersection.y    = Math.max( bounds1.y, bounds2.y );
            intersection.width      = Math.min( ( bounds1.x + bounds1.width ) - intersection.x, ( bounds2.x + bounds2.width ) - intersection.x );
            intersection.height = Math.min( ( bounds1.y + bounds1.height ) - intersection.y, ( bounds2.y + bounds2.height ) - intersection.y );
            
            return intersection;
        }
        
        /** 
		 * 获取碰撞相交矩形区域（可调节精度）
		 */
        public static function complexIntersectionRectangle ( target1:DisplayObject, target2:DisplayObject, accuracy:Number = 1 ) : Rectangle
        {        
            //不允许设置accuracy小于0，会抛出错误
            if( accuracy <= 0 ) throw new Error( "ArgumentError: Error #5001: Invalid value for accurracy", 5001 );
            
            //如果两对象hitTestObject的结果为false，则代表两对象没有发生碰撞
            if( !target1.hitTestObject( target2 ) ) return new Rectangle();
            
            var hitRectangle:Rectangle = intersectionRectangle( target1, target2 );
            // 判断重叠区域的长宽任一是否超过碰撞临界值，没超过则视为两对象没有发生碰撞。临界值默认为1，可根据accuracy调节精度
            if( hitRectangle.width * accuracy <1 || hitRectangle.height * accuracy <1 ) return new Rectangle();
            
            
            //---------------------------------- 核心算法---------------------------------------
            //创建一个用于draw的临时BitmapData对象
            var bitmapData:BitmapData = new BitmapData( hitRectangle.width * accuracy, hitRectangle.height * accuracy, false, 0x000000 ); 
            
            //把target1的不透明处绘制为指定颜色
            bitmapData.draw( target1, HitTest.getDrawMatrix( target1, hitRectangle, accuracy ), new ColorTransform( 1, 1, 1, 1, 255, -255, -255, 255 ) );
            //把target2的不透明处绘制为指定颜色，并将混合模式设置为DIFFERENCE模式
            bitmapData.draw( target2, HitTest.getDrawMatrix( target2, hitRectangle, accuracy ), new ColorTransform( 1, 1, 1, 1, 255, 255, 255, 255 ), BlendMode.DIFFERENCE );
            
            //target1与target2的不透明处如果发生相交，那么相交部分区域的32位颜色信息必为0xFF00FFFF，即得出两对象的像素碰撞区域
            var intersection:Rectangle = bitmapData.getColorBoundsRect( 0xFFFFFFFF,0xFF00FFFF );
            
            bitmapData.dispose();
            //----------------------------------  ---------------------------------------
            
            // Alter width and positions to compensate for accurracy
            //前面是乘以accuracy缩放两对象后，再通过叠加模式计算出相交区域的，因此在此要再除以一次accuracy，恢复原本相交区域大小
            if( accuracy != 1 )
            {
                intersection.x /= accuracy;
                intersection.y /= accuracy;
                intersection.width /= accuracy;
                intersection.height /= accuracy;
            }
            
            intersection.x += hitRectangle.x;
            intersection.y += hitRectangle.y;
            
            return intersection;
        }
        
        
        protected static function getDrawMatrix( target:DisplayObject, hitRectangle:Rectangle, accurracy:Number ):Matrix
        {
            var localToGlobal:Point;
            var matrix:Matrix;
            
            var rootConcatenatedMatrix:Matrix = target.root.transform.concatenatedMatrix;
            
            localToGlobal = target.localToGlobal( new Point( ) );
            matrix = target.transform.concatenatedMatrix;
            matrix.tx = localToGlobal.x - hitRectangle.x;
            matrix.ty = localToGlobal.y - hitRectangle.y;
            
            matrix.a = matrix.a / rootConcatenatedMatrix.a;
            matrix.d = matrix.d / rootConcatenatedMatrix.d;
            if( accurracy != 1 ) matrix.scale( accurracy, accurracy );
            
            return matrix;
        }
		
    }
}