package
{
	import flash.display.Sprite;
	
	import flash.system.Capabilities;
	
	// import flash.media.AudioDecoder;
	
	/**
	 * ...
	 * @author TKCB（QQ 2414268040、E-mail tkcb@qq.com）
	 */
	public class SystemExample extends Sprite
	{
		
		/**
		 * 构造函数
		 */
		public function SystemExample() {
			tf.text = "";
			tf.appendText("【Capabilities类的属性，可用于判断系统设备的功能】");
			
			tf.appendText("\n音频相关：");
			tf.appendText("\nhasAudio - 指定系统是否有音频功能。此属性始终为 true。服务器字符串为 A。————" + Capabilities.hasAudio);
			tf.appendText("\nhasMP3 - 指定系统是否具有 MP3 解码器，如果是，则为 true，否则为 false。服务器字符串为 MP3————" + Capabilities.hasMP3);
			tf.appendText("\nhasAudioEncoder - 指定系统是否可以对音频流（如来自麦克风的音频流）进行编码，如果是，则为 true，否则为 false。服务器字符串为 AE————" + Capabilities.hasAudioEncoder);
			tf.appendText("\nhasStreamingAudio - 指定系统是否可以播放音频流，如果是，则为 true，否则为 false。服务器字符串为 SA————" + Capabilities.hasStreamingAudio);
			
			tf.appendText("\n\n视频相关：");
			tf.appendText("\navHardwareDisable - 指定对用户的摄像头和麦克风的访问是已经通过管理方式禁止 (true) 还是允许 (false)————" + Capabilities.avHardwareDisable);
			tf.appendText("\nhasEmbeddedVideo - 指定系统是否支持嵌入的视频，如果是，则为 true，否则为 false。服务器字符串为 EV————" + Capabilities.hasEmbeddedVideo);
			tf.appendText("\nhasVideoEncoder - 指定系统是否可以对视频流进行编码，如果是，则为 true，否则为 false。服务器字符串为 VE————" + Capabilities.hasVideoEncoder);
			tf.appendText("\nhasStreamingVideo - 指定系统是否可以播放视频流，如果是，则为 true，否则为 false。服务器字符串为 SV————" + Capabilities.hasStreamingVideo);
			
			tf.appendText("\n\n系统相关：");
			tf.appendText("\nos - 指定当前的操作系统（...详细信息，查看API）————" + Capabilities.os);
			tf.appendText("\ncpuArchitecture - 指定当前 CPU 体系结构，cpuArchitecture 属性可以返回以下字符串：“PowerPC”、“x86”、“SPARC”和“ARM”。服务器字符串为 ARCH————" + Capabilities.cpuArchitecture);
			tf.appendText("\nhasAccessibility - 指定系统是否支持与辅助功能通信，如果是，则为 true，否则为 false。服务器字符串为 ACC————" + Capabilities.hasAccessibility);
			tf.appendText("\nlanguage - 指定运行内容的系统的语言代码。语言指定为 ISO 639-1 中的小写双字母语言代码。对于中文，另外使用 ISO 3166 中的大写双字母国家/地区代码，以区分简体中文和繁体中文。语言代码基于语言的英文名称：例如，hu 指定匈牙利语。 \n在英文系统上，此属性仅返回语言代码 (en)，而不返回国家/地区代码。在 Microsoft Windows 系统上，此属性返回用户界面 (UI) 语言，该语言指的是所有菜单、对话框、错误信息和帮助文件所使用的语言。————" + Capabilities.language);
			tf.appendText("\nlanguages（AIR）属性为AIR，所以需使用AIR才可以测试该属性：");
			//tf.appendText("\nlanguages（AIR） - 包含用户的首选用户界面语言相关信息的字符串数组，通过操作系统设置（...详细信息，查看API）————" + Capabilities.languages);
			tf.appendText("\nlocalFileReadDisable - 指定对用户硬盘的读取权限是已经通过管理方式禁止 (true) 还是允许 (false)（...详细信息，查看API）————" + Capabilities.localFileReadDisable);
			tf.appendText("\nmaxLevelIDC - 检索客户端硬件支持的最高 H.264 级 IDC。以此级别运行的媒体不能保证运行；但是，以最高级别运行的媒体可能无法以最高品质运行。此属性对于尝试以客户端的功能为目标的服务器非常有用。使用此属性，服务器可以确定要发送给客户端的视频的级别。 服务器字符串为 ML（...详细信息，查看API）————" + Capabilities.maxLevelIDC);
			tf.appendText("\nsupports32BitProcesses - 指定系统是否支持运行 32 位的进程。服务器字符串为 PR32————" + Capabilities.supports32BitProcesses);
			tf.appendText("\nsupports64BitProcesses - 指定系统是否支持运行 64 位的进程。服务器字符串为 PR64————" + Capabilities.supports64BitProcesses);
			
			tf.appendText("\n\n显示器、触摸相关：");
			tf.appendText("\npixelAspectRatio - 指定屏幕的像素高宽比。服务器字符串为 AR————" + Capabilities.pixelAspectRatio);
			tf.appendText("\nscreenColor - 指定屏幕的颜色。此属性的值可以是“color”、“gray”（代表灰度），或是“bw”（代表黑白）。服务器字符串为 COL。 ————" + Capabilities.screenColor);
			tf.appendText("\nscreenDPI - 指定屏幕的每英寸点数 (dpi) 分辨率，以像素为单位。服务器字符串为 DP————" + Capabilities.screenDPI);
			tf.appendText("\nscreenResolutionX - 指定屏幕的最大水平分辨率。服务器字符串为 R（它返回屏幕的宽度和高度）。此属性不会随用户的屏幕分辨率而更新，而仅指示 Flash Player 或 Adobe AIR 应用程序启动时的分辨率。另外，此值只指定主屏幕。 ————" + Capabilities.screenResolutionX);
			tf.appendText("\nscreenResolutionY - 指定屏幕的最大垂直分辨率。服务器字符串为 R（它返回屏幕的宽度和高度）。此属性不会随用户的屏幕分辨率而更新，而仅指示 Flash Player 或 Adobe AIR 应用程序启动时的分辨率。另外，此值只指定主屏幕。 ————" + Capabilities.screenResolutionY);
			tf.appendText("\ntouchscreenType - 指定支持的触摸屏的类型（如果有）。值是在 flash.system.TouchscreenType 类中定义的————" + Capabilities.touchscreenType);
			
			tf.appendText("\n\nFlash Media Server相关：");
			tf.appendText("\nhasScreenBroadcast - 指定系统是否支持开发通过 Flash Media Server 运行的屏幕广播应用程序，如果是，则为 true，否则为 false。服务器字符串为 SB————" + Capabilities.hasScreenBroadcast);
			tf.appendText("\nhasScreenPlayback - 指定系统是否支持播放通过 Flash Media Server 运行的屏幕广播应用程序，如果是，则为 true，否则为 false。服务器字符串为 SP————" + Capabilities.hasScreenPlayback);
			
			tf.appendText("\n\nFlash Player相关：");
			tf.appendText("\nmanufacturer - 指定 Flash Player 的运行版本或 AIR 运行时的制造商，其格式为“Adobe OSName”（...详细信息，查看API）————" + Capabilities.manufacturer);
			tf.appendText("\nversion - 指定 Flash Player 或 Adobe® AIR® 平台和版本信息。版本号的格式为：平台 (platform)，主版本号 (majorVersion)，次版本号 (minorVersion)、生成版本号 (buildNumber)，内部生成版本号 (internalBuildNumber)。platform 可能的值为 “WIN”、“MAC”、“LNX”和“AND”（...详细信息，查看API）————" + Capabilities.version);
			tf.appendText("\nplayerType - 指定运行时环境的类型（是否是独立播放器、浏览器插件或者其他值）（...详细信息，查看API）————" + Capabilities.playerType);
			tf.appendText("\nisDebugger - 指定系统是特殊的调试版本 (true)，还是正式发布的版本 (false)。服务器字符串为 DEB。在 Flash Player 调试版或 AIR Debug Launcher (ADL) 中运行时，此属性设置为 true————" + Capabilities.isDebugger);
			tf.appendText("\nisEmbeddedInAcrobat - 指定 Flash 运行时是否嵌入用 Acrobat 9.0 或更高版本打开的 PDF 文件中，如果是，则为 true，否则为 false————" + Capabilities.isEmbeddedInAcrobat);
			
			tf.appendText("\n\n其他：");
			tf.appendText("\nhasPrinting - 指定系统是否支持打印，如果是，则为 true，否则为 false。服务器字符串为 PR————" + Capabilities.hasPrinting);
			tf.appendText("\nhasIME - 指定系统是否安装了输入法编辑器 (IME)，如果是，则为 true，否则为 false。服务器字符串为 IME————" + Capabilities.hasIME);
			tf.appendText("\nhasTLS - 指定系统是否通过 NetConnection 支持本机 SSL 套接字，如果是，则为 true，否则为 false。服务器字符串为 TLS————" + Capabilities.hasTLS);
			tf.appendText("\nserverString - URL 编码的字符串，用于指定每个 Capabilities 属性的值————" + Capabilities.serverString);
			
			tf.appendText("\n\n【Capabilities类的方法，可用于判断系统设备的功能】");
			tf.appendText("\nhasMultiChannelAudio()此方法由于一些因素不可使用。");
			// tf.appendText("\nhasMultiChannelAudio() - 指定系统是否支持特定类型的多信道音频。类 flash.media.AudioDecoder 枚举可能的类型（...详细信息，查看API）————" + Capabilities.hasMultiChannelAudio(AudioDecoder.DOLBY_DIGITAL));
		}
		
	}
}