FormRequestBuilder
=============

FormRequestBuilder是一个用于构建AS3 http form请求的开源类，即AS3发送二进制数据和其他值对的时候。

###使用方法：

1. 实例化，需要传入地址和contentType，默认为multipart/form-data

2. FormRequestBuilder.writeData(bytes: ByteArray, fileName: String, vars: Object = null)

    bytes为二进制数据，fileName为文件名字，vars是其他需要一起发送的值对

3. 用URLloader加载你构建好的请求：URLloader.load(FormRequestBuilder.getRequest())


**注意：**如果涉及到javascript交互，如URLloader.load是由javascript按钮触发的时候，会报2176安全错误。原因是flashplayer限制了contentType为multipart/*的请求。此时需要绕一下，即在初始化时把contentType设置为application/x-www-form-urlencoded或application/octet-stream等等，当然服务器也要相应进行一点改动
