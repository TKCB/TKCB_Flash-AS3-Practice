package 
{

	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.events.Event;

	public class jlmain extends MovieClip
	{

		private var Px:Array = new Array();
		private var Py:Array = new Array();
		private var m_Point:Array = new Array(Px.length);
		private var m_Test:Array = new Array(Px.length);
		private var jResult:Array = new Array();
		private var jC:Array = new Array();
		private var jr:Number = 30;
		private var jn:int = 3-1;
		private var jmid:Array = new Array();
		private var mi:int = 0;
		private var jsNum:int = 0;
		public function jlmain()
		{
			if ( this.stage ) addedToStage( null );
			else this.addEventListener( Event.ADDED_TO_STAGE, addedToStage );
		}
		
		
		private function addedToStage ( eve:Event ) : void
		{
			if ( eve != null ) this.removeEventListener( Event.ADDED_TO_STAGE, addedToStage );
			
			stage.addEventListener( MouseEvent.MOUSE_DOWN, stageMouse );
			stage.addEventListener(MouseEvent.MOUSE_WHEEL,midclickHandler);
		}
		
		private function midclickHandler(e:MouseEvent)
		{
			stage.removeEventListener( MouseEvent.MOUSE_DOWN, stageMouse);
			stage.removeEventListener(MouseEvent.MOUSE_WHEEL,midclickHandler);
			/*for (var i = 0; i < Px.length; i ++)
			{
				
				m_Point[i] = new jPoint();
				m_Point[i].x = Px[i];
				m_Point[i].y = Py[i];
				addChild(m_Point[i]);
			}*/
			for (var i = 0; i < Px.length; i ++)
			{
				if(jmidTest(i))
				{
					jmid.push(i);
				}
			}
			for (i = 0; i < jmid.length; i ++)
			{
				if(jC.indexOf(i)==-1)
				{
					jC.push(i);
					jResult[jResult.length] = new Array();
					m_Point[i].gotoAndStop(jResult.length+1);
					jDoing(jmid[i],jResult.length);
				}
			}
		}
		private function stageMouse ( eve:MouseEvent ) : void
		{
			
			switch ( eve.type )
			{
				case MouseEvent.MOUSE_DOWN: 
					stage.addEventListener( MouseEvent.MOUSE_MOVE, stageMouse );
					stage.addEventListener( MouseEvent.MOUSE_UP, stageMouse );
					jsNum = 0;
				case MouseEvent.MOUSE_MOVE: 
					if ( jsNum == 0 )
					{
						m_Point[mi] = new jPoint();
						m_Point[mi].x = stage.mouseX;
						m_Point[mi].y = stage.mouseY;
						Px.push(stage.mouseX);
						Py.push(stage.mouseY);
						addChild(m_Point[mi]);
						mi++;
					}
					jsNum++;
					if ( jsNum > 5 ) jsNum = 0;
					break;
				
				case MouseEvent.MOUSE_UP: 
					stage.removeEventListener( MouseEvent.MOUSE_MOVE, stageMouse );
					stage.removeEventListener( MouseEvent.MOUSE_UP, stageMouse );
					break;
			}
			
		}
		private function jDoing(j:int,c:int):void
		{
			for (var i = 0; i < Px.length; i ++)
			{
				if(i!=j&&jC.indexOf(i)==-1)
				{
					if(((m_Point[i].x-m_Point[j].x)*(m_Point[i].x-m_Point[j].x)+(m_Point[i].y-m_Point[j].y)*(m_Point[i].y-m_Point[j].y))<jr*jr)
					{
						jResult[c-1].push(i);
						m_Point[i].gotoAndStop(c+1);
						jC.push(i);
						if(jmid.indexOf(i)!=-1)
						jDoing(i,c);
					}
				}
			}
		}
		private function jmidTest(j:int):Boolean
		{
			var jPn:int = 0;
			for (var i = 0; i < Px.length; i ++)
			{
				if(i!=j)
				{
					if(((m_Point[i].x-m_Point[j].x)*(m_Point[i].x-m_Point[j].x)+(m_Point[i].y-m_Point[j].y)*(m_Point[i].y-m_Point[j].y))<jr*jr)
					{
						jPn++;
					}
				}
			}
			return !(jPn<jn);
		}
	}

}