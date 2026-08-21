## ZipCore介绍
zipcore 由 `AirxZip` 更改而来
采用FileStream进行数据流加载而不需要加载所有数据到内存
修复了加载大文件zip卡死问题(int溢出)
增加了从网络流下载zip文件的能力
增加多个接口如：getAllFileName/getAllDirectoryPath/getAllFilePath
修复了调用多次getEntry会导致Entry数量增加的bug
实现了AS3解析ANE加密zip, 但效率很低, 需要 `addDecrypto(new AESCrypto())`
配合CryptoANE可以实现AES加密zip的快速解析, 需要 `addDecrypto(new ANECrypto())`

**ZipFileWriter没有更改, 可能存在问题, 自行测试**