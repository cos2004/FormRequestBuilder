package com.cos2004.net {
	/**
	 * Build an AS3 form-based http request includes ByteArray
	 * MIT license
	 * Author: cos2004@126.com
	 * Date: 2012.11.21 
	 */
	 
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLRequestHeader;
	import flash.utils.ByteArray;

	public class FormRequestBuilder {
		private const BOUNDARY_CHAR: String = 'Rm9ybVJlcXVlc3RCdWlsZGVyQnljb3MyMDA0';
		private const BOUNDARY: String = '--' + BOUNDARY_CHAR;
		private const ENDLINE: String = BOUNDARY + '--';
		private const BR: String = '\r\n';
		private var isWriteData: Boolean = false;
		private var byteArray: ByteArray;
		private var request: URLRequest;
		
		public function FormRequestBuilder(url: String, contentType: String = 'multipart/form-data') {
			byteArray = new ByteArray();
			request = new URLRequest(url);
			request.contentType = contentType + '; boundary=' + BOUNDARY_CHAR;
			request.method = URLRequestMethod.POST;
			request.requestHeaders.push(new URLRequestHeader( 'Cache-Control', 'no-cache'));
		}
		/**
		 * byteArray writes ByteArray and variables
		 * @param bytes: ByteArray
		 * @param fileName: file name
		 * @param vars: key-value Object
		 */
		public function writeData(bytes: ByteArray, fileName: String, vars: Object = null): void {
			isWriteData = true;
			byteArray.clear();
			var WB = byteArray.writeUTFBytes;
			if (vars) {
				for (var k in vars) {
					writeBoundary();
					writeContentDisposition(k);
					WB(vars[k]);
				}
			}
			writeBoundary();
			writeContentDisposition('Filename');
			WB(fileName);
			writeBoundary();
			writeContentDisposition('Filedata', fileName, 'application/octet-stream');
			byteArray.writeBytes(bytes);
			WB(BR + BR + ENDLINE + BR);
		}
		/**
		 * get URLRequest
		 * @return URLRequest
		 */
		public function getRequest(): URLRequest {
			if (isWriteData) {
				request.data = byteArray;
				return request;
			} else {
				throw new Error('The request body has not write any data yet!');
				return null;
			}
		}
		/**
		 * byteArray writes boundary
		 */
		private function writeBoundary(): void {
			byteArray.writeUTFBytes(BR + BOUNDARY + BR);
		}
		/**
		 * byteArray writes Content-Disposition
		 */
		private function writeContentDisposition(name: String, filename: String = null, contentType: String = null): void {
			var con: String = 'Content-Disposition: form-data; name="' +  name + '"';
			con = filename ? con + '; filename="' + filename + '"' : con;
			con = contentType ? con + BR + 'Content-Type: ' + contentType : con;
			con += BR + BR;
			byteArray.writeUTFBytes(con);
		}
	}
	
}
