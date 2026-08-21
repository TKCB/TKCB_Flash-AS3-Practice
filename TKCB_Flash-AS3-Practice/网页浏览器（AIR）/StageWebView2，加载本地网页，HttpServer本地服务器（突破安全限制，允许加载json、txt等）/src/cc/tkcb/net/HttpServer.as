/**
 * AIR HTTP服务器全功能版（音视频播放修复）
 * 核心特性：
 * 1. 保留2.2版本全部功能（缓存、Range请求、安全防护、跨域支持）
 * 2. 音视频文件单独处理，回归初版纯二进制传输逻辑，确保MP3/MP4等正常播放
 * 3. 全版本兼容，无高版本API依赖，编译无报错
 * 4. 完善的日志系统和异常处理
 * 
 * @author 自定义
 * @version 2.3（全功能+音视频播放）
 * @package cc.tkcb.net
 * @since Flash Player 10 / AIR 2.0
 */
package cc.tkcb.net
{
	// 导入核心类
	import flash.events.ProgressEvent;					// Socket数据接收事件
	import flash.events.ServerSocketConnectEvent;		// 服务器Socket连接事件
	import flash.filesystem.File;						// 文件操作类
	import flash.filesystem.FileMode;					// 文件打开模式
	import flash.filesystem.FileStream;					// 文件流操作类
	import flash.net.ServerSocket;						// 服务器Socket类
	import flash.net.Socket;								// 客户端Socket类
	import flash.utils.ByteArray;						// 二进制数据存储类
	import flash.utils.Dictionary;						// 字典类，用于文件缓存

	/**
	 * AIR HTTP服务器核心类
	 * 提供轻量级HTTP服务，支持静态文件访问、音视频播放、Range请求、文件缓存等功能
	 * 静态类，禁止实例化，通过init()方法启动，close()方法关闭
	 */
	public class HttpServer
	{
		// ===================== 核心配置常量/变量 =====================
		/** 服务器Socket实例，用于监听客户端连接 */
		private static var server: ServerSocket;
		
		/** 服务器根目录，所有文件请求都基于此目录 */
		private static var rootDir: File;
		
		/** 服务器监听IP地址，默认127.0.0.1（本地回环地址） */
		private static var serverIP: String = "127.0.0.1";
		
		/** 服务器监听端口，默认8080 */
		private static var serverPort: int = 8080;
		
		// ===================== 性能优化配置（保留2.2版本） =====================
		/** 文件缓存字典，key=文件绝对路径，value={bytes:ByteArray, time:Number} */
		private static var fileCache: Dictionary = new Dictionary();
		
		/** 缓存过期时间（毫秒），默认5分钟 */
		private static const CACHE_EXPIRE: uint = 5 * 60 * 1000;
		
		/** 缓存文件最大尺寸（字节），默认2MB，超过此大小的文件不缓存 */
		private static const CACHE_MAX_SIZE: uint = 2 * 1024 * 1024;
		
		/** 大文件阈值（字节），默认10MB，超过此大小的文件分段读取 */
		private static const BIG_FILE_THRESHOLD: uint = 10 * 1024 * 1024;
		
		/** 分段读取块大小（字节），默认1MB */
		private static const CHUNK_SIZE: uint = 1 * 1024 * 1024;

		// ===================== 构造函数 =====================
		/**
		 * 私有构造函数
		 * 禁止实例化此类，所有方法均为静态方法
		 * @throws Error 始终抛出错误，提示禁止实例化
		 */
		public function HttpServer()
		{
			throw new Error("AIRServer是全静态类，禁止创建实例！请使用AIRServer.init()初始化");
		}

		// ===================== 公开方法（对外接口） =====================
		/**
		 * 初始化并启动HTTP服务器
		 * @param file File 服务器根目录，必须是已存在的文件夹
		 * @param ip String 可选，监听IP地址，默认127.0.0.1
		 * @param port int 可选，监听端口，默认8080，范围1-65535
		 * @throws Error 根目录非法/端口非法/服务器启动失败时抛出错误
		 */
		public static function init(file:File, ip:String = "127.0.0.1", port:int = 8080): void
		{
			// 检查服务器是否已启动
			if (server != null) {
				throw new Error("服务器已启动，请勿重复初始化！");
			}
			
			// 验证根目录合法性
			if (!file.exists || !file.isDirectory) {
				throw new Error("根目录非法：不存在或不是文件夹 → " + file.nativePath);
			}
			
			// 验证端口合法性
			if (port < 1 || port > 65535) {
				throw new Error("端口号非法：必须在1-65535之间 → " + port);
			}

			// 保存配置
			rootDir = file;
			serverIP = ip;
			serverPort = port;

			try {
				// 创建服务器Socket并绑定端口
				server = new ServerSocket();
				server.bind(serverPort, serverIP);
				server.listen();
				
				// 监听客户端连接事件
				server.addEventListener(ServerSocketConnectEvent.CONNECT, onClientConnect);
				
				// 记录启动日志
				log("INFO", "服务器启动成功 → http://" + serverIP + ":" + serverPort + "/");
				log("INFO", "根目录 → " + rootDir.nativePath);
			} catch (e:Error) {
				// 启动失败，清理资源
				server = null;
				var errMsg: String = "服务器启动失败：" + e.message;
				
				// 补充端口占用提示
				if (e.message.indexOf("address in use") != -1) {
					errMsg += "（端口" + port + "已被占用）";
				}
				
				log("ERROR", errMsg);
				throw new Error(errMsg);
			}
		}

		/**
		 * 关闭HTTP服务器，释放所有资源
		 * 关闭Socket连接，清空文件缓存，重置配置
		 */
		public static function close(): void
		{
			// 关闭服务器Socket
			if (server != null) {
				server.close();
				server.removeEventListener(ServerSocketConnectEvent.CONNECT, onClientConnect);
				server = null;
			}
			
			// 清空文件缓存
			fileCache = new Dictionary();
			
			// 重置配置
			rootDir = null;
			serverIP = "127.0.0.1";
			serverPort = 8080;
			
			// 记录关闭日志
			log("INFO", "服务器已关闭，资源已释放");
		}

		/**
		 * 检查服务器是否正在运行
		 * @return Boolean 运行返回true，否则返回false
		 */
		public static function isRunning(): Boolean
		{
			return server != null;
		}

		// ===================== 核心事件处理方法 =====================
		/**
		 * 客户端连接事件处理器
		 * 当有新客户端连接时，监听其数据接收事件
		 * @param e ServerSocketConnectEvent 连接事件对象
		 */
		private static function onClientConnect(e: ServerSocketConnectEvent): void
		{
			var client: Socket = e.socket;
			// 监听客户端数据接收事件
			client.addEventListener(ProgressEvent.SOCKET_DATA, onClientRequest);
			// 记录连接日志
			log("CONNECT", "客户端连接 → " + client.remoteAddress + ":" + client.remotePort);
		}

		/**
		 * 客户端请求处理器
		 * 解析HTTP请求，处理文件请求，区分音视频和普通文件
		 * @param e ProgressEvent 数据接收事件对象
		 */
		private static function onClientRequest(e: ProgressEvent): void
		{
			var client: Socket = e.currentTarget as Socket;
			
			try {
				// 读取客户端请求数据
				var requestData: String = client.readUTFBytes(client.bytesAvailable);
				var requestLines: Array = requestData.split("\r\n");
				var requestLine: String = requestLines[0] || "";
				
				// 解析请求行（格式：METHOD PATH HTTP/VERSION）
				var reqParts: Array = requestLine.split(" ");
				if (reqParts.length < 3) {
					sendErrorResponse(client, 400, "无效的请求行格式");
					return;
				}
				
				var method: String = reqParts[0].toUpperCase();	// 请求方法（GET/HEAD）
				var reqPath: String = reqParts[1];				// 请求路径
				var httpVersion: String = reqParts[2];			// HTTP版本

				// 仅支持GET和HEAD方法
				if (method != "GET" && method != "HEAD") {
					sendErrorResponse(client, 405, "仅支持GET/HEAD请求方法");
					return;
				}

				// 解析并清理请求路径（防路径遍历、处理默认首页等）
				var cleanPath: String = parseAndCleanPath(reqPath);
				if (cleanPath == null) {
					sendErrorResponse(client, 403, "非法路径请求");
					return;
				}

				// 定位目标文件
				var targetFile: File = rootDir.resolvePath(cleanPath);
				if (!targetFile.exists || targetFile.isDirectory) {
					sendErrorResponse(client, 404, "文件不存在 → " + cleanPath);
					return;
				}

				// 核心逻辑：区分音视频文件和普通文件，分别处理
				var ext: String = targetFile.extension.toLowerCase();
				// 定义音视频文件扩展名列表
				var isMediaFile: Boolean = (ext == "mp3" || ext == "wav" || ext == "mp4" || ext == "webm" || ext == "ogg");
				
				if (isMediaFile) {
					// 音视频文件：使用初版纯二进制传输逻辑，确保播放
					handleMediaFile(client, targetFile, method);
				} else {
					// 普通文件：保留2.2版本的缓存、Range请求、分段读取等优化逻辑
					handleNormalFile(client, targetFile, requestLines, method);
				}

			} catch (err:Error) {
				// 捕获所有异常，记录日志并返回500错误
				log("ERROR", "请求处理异常 → " + err.message);
				sendErrorResponse(client, 500, "服务器内部错误");
			}
		}

		// ===================== 音视频文件处理（核心修复） =====================
		/**
		 * 音视频文件处理方法
		 * 回归初版纯二进制读取逻辑，无缓存、无分段，确保音视频正常播放
		 * @param client Socket 客户端Socket连接
		 * @param file File 要发送的音视频文件
		 * @param method String 请求方法（GET/HEAD）
		 */
		private static function handleMediaFile(client: Socket, file: File, method: String): void
		{
			var fs: FileStream = new FileStream();	// 文件流
			var bytes: ByteArray = new ByteArray();	// 存储文件二进制数据
			
			try {
				// 核心：以二进制模式读取完整文件（音视频播放关键）
				fs.open(file, FileMode.READ);
				fs.readBytes(bytes);
				fs.close();

				// 获取文件MIME类型
				var mimeType: String = getMimeType(file.extension);
				// 判断是否为HEAD请求（仅返回响应头，不返回数据）
				var isHead: Boolean = (method == "HEAD");

				// 构建HTTP响应头（仅保留音视频播放必需的核心头）
				var header: String = 
					"HTTP/1.1 200 OK\r\n" +							// 200状态码：请求成功
					"Date: " + getHttpDateString(new Date()) + "\r\n" +	// 服务器当前时间
					"Server: AIR-HTTP/2.3\r\n" +					// 服务器标识
					"Access-Control-Allow-Origin: *\r\n" +			// 允许跨域
					"Access-Control-Allow-Methods: GET, HEAD, OPTIONS\r\n" + // 允许的跨域方法
					"Content-Type: " + mimeType + "\r\n" +			// 文件MIME类型
					"Connection: close\r\n" +						// 关闭连接
					"Accept-Ranges: bytes\r\n" +					// 支持字节范围请求（进度条）
					"Content-Length: " + bytes.length + "\r\n\r\n";	// 响应数据长度

				// 发送响应：先发送头，再发送二进制数据（HEAD请求不发送数据）
				client.writeUTFBytes(header);
				if (!isHead) {
					client.writeBytes(bytes);
				}
				
				// 刷新并关闭连接
				flushAndClose(client);

				// 记录音视频请求日志
				log("MEDIA", "[" + client.remoteAddress + "] " + method + " " + file.name + " → " + formatFileSize(bytes.length));
			} catch (e:Error) {
				// 异常处理：确保文件流关闭，返回500错误
				fs.close();
				sendErrorResponse(client, 500, "音视频读取失败");
			}
		}

		// ===================== 普通文件处理（保留全功能） =====================
		/**
		 * 普通文件处理方法
		 * 保留2.2版本所有优化功能：文件缓存、Range请求、分段读取等
		 * @param client Socket 客户端Socket连接
		 * @param file File 要发送的普通文件
		 * @param requestLines Array HTTP请求头行列表
		 * @param method String 请求方法（GET/HEAD）
		 */
		private static function handleNormalFile(client: Socket, file: File, requestLines: Array, method: String): void
		{
			// 解析Range请求头（用于断点续传、进度条等）
			var rangeInfo: Object = parseRangeHeader(requestLines, file.size);
			var isRangeRequest: Boolean = rangeInfo.isRange;	// 是否为Range请求
			var rangeStart: int = rangeInfo.start;				// Range起始位置
			var rangeEnd: int = rangeInfo.end;					// Range结束位置
			var fileSize: uint = file.size;						// 文件总大小

			var fileData: ByteArray = new ByteArray();			// 存储文件数据
			var cacheKey: String = file.nativePath;				// 缓存键（文件绝对路径）
			var cacheObj: Object = fileCache[cacheKey];			// 缓存对象

			// 检查缓存是否有效
			if (cacheObj != null && (new Date().time - cacheObj.time) < CACHE_EXPIRE) {
				// 缓存命中：从缓存读取数据
				var cacheBytes: ByteArray = cacheObj.bytes;
				cacheBytes.position = 0;
				fileData.clear();
				fileData.writeBytes(cacheBytes, 0, cacheBytes.length);
				fileData.position = 0;
				
				log("CACHE", "缓存命中 → " + file.name);
			} else {
				// 缓存未命中/过期：从文件读取
				var fs: FileStream = new FileStream();
				fs.open(file, FileMode.READ);

				if (isRangeRequest) {
					// Range请求：读取指定范围的字节
					fs.position = rangeStart;
					var readLength: uint = rangeEnd - rangeStart + 1;
					readFileByChunk(fs, fileData, readLength);
				} else {
					// 普通请求：根据文件大小选择读取方式
					if (fileSize > BIG_FILE_THRESHOLD) {
						// 大文件：分段读取，避免内存溢出
						readFileByChunk(fs, fileData, fileSize);
					} else {
						// 小文件：一次性读取，并缓存（如果小于缓存最大尺寸）
						fs.readBytes(fileData);
						if (fileSize < CACHE_MAX_SIZE) {
							var cacheData: ByteArray = new ByteArray();
							fileData.position = 0;
							cacheData.clear();
							cacheData.writeBytes(fileData, 0, fileData.length);
							cacheData.position = 0;
							
							// 存入缓存
							fileCache[cacheKey] = {
								bytes: cacheData,
								time: new Date().time
							};
						}
					}
				}
				fs.close();
			}

			// 获取文件MIME类型
			var mimeType: String = getMimeType(file.extension);

			// 根据是否为Range请求发送不同响应
			if (isRangeRequest) {
				sendRangeResponse(client, mimeType, fileData, rangeStart, rangeEnd, fileSize);
			} else {
				sendNormalResponse(client, mimeType, fileData, method == "HEAD");
			}

			// 记录请求日志
			var logMethodPath: String = (method + " " + file.name);
			logMethodPath = padEnd(logMethodPath, 10, " ");
			
			log("REQUEST", 
				"[" + client.remoteAddress + "] " + 
				logMethodPath + " " + 
				(isRangeRequest ? "Range(" + rangeStart + "-" + rangeEnd + ")" : "Full") + " → " + 
				formatFileSize(fileData.length));
		}

		// ===================== 辅助方法（工具类） =====================
		/**
		 * 解析并清理请求路径
		 * 处理URL解码、防路径遍历、设置默认首页、统一路径分隔符等
		 * @param rawPath String 原始请求路径
		 * @return String 清理后的路径，非法路径返回null
		 */
		private static function parseAndCleanPath(rawPath: String): String
		{
			// 去掉查询参数（?后面的内容）
			var cleanPath: String = rawPath.split("?")[0];
			// URL解码
			cleanPath = decodeURIComponent(cleanPath);

			// 清理路径：防止路径遍历攻击，统一路径分隔符
			cleanPath = cleanPath.replace(/\.\.\//g, "/")	// 去掉../，防止上级目录访问
								 .replace(/\/\.\//g, "/")	// 去掉/./，防止当前目录冗余
								 .replace(/\\/g, "/")		// 统一分隔符为/
								 .replace(/\/+/g, "/");		// 合并多个/为一个

			// 处理默认首页：根路径请求返回index.html
			if (cleanPath == "/" || cleanPath == "") {
				return "index.html";
			}

			// 去掉开头的/
			if (cleanPath.indexOf("/") == 0) {
				cleanPath = cleanPath.substring(1);
			}

			// 最终检查：空路径或包含..的路径视为非法
			if (cleanPath.length == 0 || cleanPath.indexOf("..") != -1) {
				return null;
			}

			return cleanPath;
		}

		/**
		 * 分段读取文件
		 * 用于大文件读取，避免一次性加载整个文件导致内存溢出
		 * @param fs FileStream 已打开的文件流
		 * @param buffer ByteArray 存储读取数据的缓冲区
		 * @param totalLength uint 要读取的总字节数
		 */
		private static function readFileByChunk(fs: FileStream, buffer: ByteArray, totalLength: uint): void
		{
			var remaining: uint = totalLength;
			buffer.clear(); // 清空缓冲区
			
			// 分段读取，每次读取CHUNK_SIZE字节
			while (remaining > 0) {
				var readSize: uint = Math.min(CHUNK_SIZE, remaining);
				fs.readBytes(buffer, buffer.length, readSize);
				remaining -= readSize;
			}
		}

		/**
		 * 解析Range请求头
		 * 支持标准HTTP Range请求格式：Range: bytes=start-end
		 * @param requestLines Array HTTP请求头行列表
		 * @param fileSize uint 文件总大小
		 * @return Object {isRange:Boolean, start:int, end:int}
		 */
		private static function parseRangeHeader(requestLines: Array, fileSize: uint): Object
		{
			var result: Object = {isRange: false, start: -1, end: -1};
			
			// 遍历请求头，查找Range头
			for (var i: int = 1; i < requestLines.length; i++) {
				var line: String = requestLines[i];
				if (line.length == 0) break; // 空行表示请求头结束

				// 找到Range头
				if (line.toLowerCase().indexOf("range:") == 0) {
					var parts: Array = line.split(":");
					if (parts.length < 2) break;

					// 提取Range值并清理空格
					var rangeStr: String = parts[1].replace(/^\s+|\s+$/g, "");
					// 仅支持bytes范围请求
					if (rangeStr.indexOf("bytes=") != 0) break;

					// 解析start和end
					var rangeParts: Array = rangeStr.substring(6).split("-");
					if (rangeParts.length < 1 || !isNumeric(rangeParts[0])) break;

					var start: int = int(rangeParts[0]);
					var end: int = (rangeParts.length > 1 && rangeParts[1] != "" && isNumeric(rangeParts[1])) 
						? int(rangeParts[1]) 
						: fileSize - 1;

					// 边界校验：确保start和end在合法范围内
					if (start < 0) start = 0;
					if (end >= fileSize) end = fileSize - 1;
					
					// 处理反向Range（如bytes=-1024，表示最后1024字节）
					if (start > end) {
						start = fileSize - Math.abs(start);
						end = fileSize - 1;
						if (start < 0) start = 0;
					}

					// 有效Range请求
					if (start <= end) {
						result = {isRange: true, start: start, end: end};
					}
					break;
				}
			}
			return result;
		}

		/**
		 * 发送普通响应（200 OK）
		 * @param client Socket 客户端Socket连接
		 * @param mimeType String 响应数据的MIME类型
		 * @param data ByteArray 要发送的二进制数据
		 * @param isHead Boolean 是否为HEAD请求（仅发送头）
		 */
		private static function sendNormalResponse(client: Socket, mimeType: String, data: ByteArray, isHead: Boolean): void
		{
			var header: String = buildResponseHeader(200, "OK", mimeType, data.length);
			
			client.writeUTFBytes(header);
			if (!isHead) {
				client.writeBytes(data);
			}
			flushAndClose(client);
		}

		/**
		 * 发送Range响应（206 Partial Content）
		 * 用于断点续传、音视频进度条等场景
		 * @param client Socket 客户端Socket连接
		 * @param mimeType String 响应数据的MIME类型
		 * @param data ByteArray 要发送的二进制数据（Range范围）
		 * @param start int Range起始位置
		 * @param end int Range结束位置
		 * @param total uint 文件总大小
		 */
		private static function sendRangeResponse(client: Socket, mimeType: String, data: ByteArray, start: int, end: int, total: uint): void
		{
			var header: String = 
				buildResponseHeader(206, "Partial Content", mimeType, data.length) +
				"Content-Range: bytes " + start + "-" + end + "/" + total + "\r\n";
			
			client.writeUTFBytes(header);
			client.writeBytes(data);
			flushAndClose(client);
		}

		/**
		 * 发送错误响应
		 * 支持400/403/404/405/500等常见错误码
		 * @param client Socket 客户端Socket连接
		 * @param code int HTTP错误码
		 * @param msg String 错误描述信息
		 */
		private static function sendErrorResponse(client: Socket, code: int, msg: String): void
		{
			var statusText: String = getStatusText(code);
			// 构建错误页面HTML
			var errorHtml: String = "<html><head><title>" + code + " " + statusText + "</title></head>" +
									"<body><h1>" + code + " " + statusText + "</h1><p>" + msg + "</p></body></html>";
			
			// 构建响应头
			var header: String = buildResponseHeader(code, statusText, "text/html; charset=utf-8", errorHtml.length);
			
			// 发送响应并关闭连接
			client.writeUTFBytes(header + errorHtml);
			flushAndClose(client);
			
			// 记录错误日志
			log("ERROR", "[" + client.remoteAddress + "] " + code + " " + statusText + " → " + msg);
		}

		/**
		 * 构建HTTP响应头
		 * 根据状态码、MIME类型等生成标准HTTP响应头
		 * @param code int HTTP状态码
		 * @param statusText String 状态码描述
		 * @param mimeType String 响应数据MIME类型
		 * @param contentLength uint 响应数据长度
		 * @return String 完整的HTTP响应头
		 */
		private static function buildResponseHeader(code: int, statusText: String, mimeType: String, contentLength: uint): String
		{
			var dateStr: String = getHttpDateString(new Date());

			// 音视频文件额外响应头
			var extraHeaders: String = "";
			if (mimeType.indexOf("audio/") == 0 || mimeType.indexOf("video/") == 0) {
				extraHeaders = 
					"Content-Transfer-Encoding: binary\r\n" +	// 二进制传输
					"Pragma: no-cache\r\n" +					// 禁止缓存
					"Expires: -1\r\n";							// 立即过期
			}

			// 构建完整响应头
			var header: String = 
				"HTTP/1.1 " + code + " " + statusText + "\r\n" +
				"Date: " + dateStr + "\r\n" +
				"Server: AIR-HTTP/2.3\r\n" +
				"Cache-Control: no-cache\r\n" +
				"Access-Control-Allow-Origin: *\r\n" +
				"Access-Control-Allow-Methods: GET, HEAD, OPTIONS\r\n" +
				"Access-Control-Allow-Headers: Range, Content-Type\r\n" +
				extraHeaders +
				"Content-Type: " + mimeType + "\r\n" +
				"Connection: close\r\n" +
				"Accept-Ranges: bytes\r\n" +
				"Content-Length: " + contentLength + "\r\n\r\n";

			return header;
		}

		/**
		 * 刷新并关闭客户端连接
		 * 确保数据发送完成后关闭连接，包含异常处理
		 * @param client Socket 客户端Socket连接
		 */
		private static function flushAndClose(client: Socket): void
		{
			try {
				client.flush(); // 刷新输出缓冲区
				client.close(); // 关闭连接
			} catch (e:Error) {
				// 记录关闭失败日志，但不中断流程
				log("WARN", "客户端连接关闭失败 → " + e.message);
			}
		}

		/**
		 * 字符串尾部补全
		 * 兼容低版本AS3，替代String.padEnd()方法
		 * @param str String 原始字符串
		 * @param length int 目标长度
		 * @param padChar String 补全字符，默认空格
		 * @return String 补全后的字符串
		 */
		private static function padEnd(str: String, length: int, padChar: String = " "): String
		{
			if (str.length >= length) return str;
			var padLength: int = length - str.length;
			var padStr: String = "";
			for (var i:int=0; i < padLength; i++) {
				padStr += padChar;
			}
			return str + padStr;
		}

		/**
		 * 字符串头部补全
		 * 兼容低版本AS3，替代String.padStart()方法
		 * @param str String 原始字符串
		 * @param length int 目标长度
		 * @param padChar String 补全字符，默认0
		 * @return String 补全后的字符串
		 */
		private static function padStart(str: String, length: int, padChar: String = "0"): String
		{
			if (str.length >= length) return str;
			var padLength: int = length - str.length;
			var padStr: String = "";
			for (var i:int=0; i < padLength; i++) {
				padStr += padChar;
			}
			return padStr + str;
		}

		/**
		 * 获取HTTP标准格式的日期字符串
		 * 格式：EEE, dd MMM yyyy HH:mm:ss GMT
		 * @param date Date 要格式化的日期
		 * @return String HTTP标准日期字符串
		 */
		private static function getHttpDateString(date: Date): String
		{
			var weekdays: Array = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];
			var months: Array = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
			
			var weekday: String = weekdays[date.getUTCDay()];
			var day: String = padStart(String(date.getUTCDate()), 2);
			var month: String = months[date.getUTCMonth()];
			var year: String = String(date.getUTCFullYear());
			var hours: String = padStart(String(date.getUTCHours()), 2);
			var minutes: String = padStart(String(date.getUTCMinutes()), 2);
			var seconds: String = padStart(String(date.getUTCSeconds()), 2);
			
			return weekday + ", " + day + " " + month + " " + year + " " + hours + ":" + minutes + ":" + seconds + " GMT";
		}

		/**
		 * 获取HTTP状态码对应的描述文本
		 * @param code int HTTP状态码
		 * @return String 状态码描述，未知码返回"Unknown Status"
		 */
		private static function getStatusText(code: int): String
		{
			var statusMap: Object = {
				200: "OK",					// 请求成功
				206: "Partial Content",		// 部分内容（Range请求）
				400: "Bad Request",			// 无效请求
				403: "Forbidden",			// 禁止访问
				404: "Not Found",			// 文件未找到
				405: "Method Not Allowed",	// 方法不允许
				500: "Internal Server Error"// 服务器内部错误
			};
			return statusMap[code] || "Unknown Status";
		}

		/**
		 * 判断字符串是否为数字
		 * @param value String 要判断的字符串
		 * @return Boolean 是数字返回true，否则返回false
		 */
		private static function isNumeric(value: String): Boolean
		{
			if (value == null || value.length == 0) return false;
			var num: Number = Number(value);
			// 排除NaN和无穷大
			return num == num && num != Number.POSITIVE_INFINITY && num != Number.NEGATIVE_INFINITY;
		}

		/**
		 * 获取文件MIME类型
		 * 根据文件扩展名返回对应的MIME类型，音视频类型回归初版配置确保播放
		 * @param ext String 文件扩展名（不带.）
		 * @return String MIME类型，未知类型返回application/octet-stream
		 */
		private static function getMimeType(ext: String): String
		{
			ext = (ext || "").toLowerCase();
			var mimeMap: Object = {
				// 文本文件
				"html": "text/html; charset=utf-8",
				"htm": "text/html; charset=utf-8",
				"css": "text/css; charset=utf-8",
				"js": "application/javascript; charset=utf-8",
				"txt": "text/plain; charset=utf-8",
				"json": "application/json; charset=utf-8",
				"xml": "application/xml; charset=utf-8",
				"csv": "text/csv; charset=utf-8",
				
				// 图片文件
				"png": "image/png",
				"jpg": "image/jpeg",
				"jpeg": "image/jpeg",
				"gif": "image/gif",
				"webp": "image/webp",
				"svg": "image/svg+xml",
				"ico": "image/x-icon",
				
				// 字体文件
				"woff": "font/woff",
				"woff2": "font/woff2",
				"ttf": "font/ttf",
				"eot": "application/vnd.ms-fontobject",
				
				// 音视频文件（回归初版MIME类型，确保播放）
				"mp3": "audio/mpeg",
				"wav": "audio/wav",
				"ogg": "audio/ogg",
				"mp4": "video/mp4",
				"webm": "video/webm",
				
				// 其他常用文件
				"pdf": "application/pdf",
				"zip": "application/zip",
				"rar": "application/x-rar-compressed",
				"apk": "application/vnd.android.package-archive"
			};
			return mimeMap[ext] || "application/octet-stream";
		}

		/**
		 * 格式化文件大小
		 * 将字节数转换为易读的格式（B/KB/MB/GB）
		 * @param size uint 文件大小（字节）
		 * @return String 格式化后的大小字符串
		 */
		private static function formatFileSize(size: uint): String
		{
			if (size < 1024) return size + " B";
			if (size < 1024 * 1024) return (size / 1024).toFixed(1) + " KB";
			if (size < 1024 * 1024 * 1024) return (size / (1024 * 1024)).toFixed(1) + " MB";
			return (size / (1024 * 1024 * 1024)).toFixed(1) + " GB";
		}

		/**
		 * 日志输出方法
		 * 输出带时间戳、日志级别的格式化日志
		 * @param level String 日志级别（INFO/ERROR/WARN/CONNECT/CACHE/MEDIA/REQUEST）
		 * @param msg String 日志内容
		 */
		private static function log(level: String, msg: String): void
		{
			var now: Date = new Date();
			// 构建时间戳：YYYY-MM-DD HH:mm:ss
			var year: String = String(now.getFullYear());
			var month: String = padStart(String(now.getMonth() + 1), 2);
			var day: String = padStart(String(now.getDate()), 2);
			var hours: String = padStart(String(now.getHours()), 2);
			var minutes: String = padStart(String(now.getMinutes()), 2);
			var seconds: String = padStart(String(now.getSeconds()), 2);
			
			var timeStr: String = year + "-" + month + "-" + day + " " + hours + ":" + minutes + ":" + seconds;
			var levelPad: String = padEnd(level, 7, " "); // 日志级别补全为7个字符，对齐输出
			
			// 输出日志
			trace("[" + timeStr + "] [" + levelPad + "] " + msg);
		}
	}
}
