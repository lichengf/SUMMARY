
# Android 键值
---

## MTK 

### 7.0

设置release-keys

	build\core\Makefile

	ifeq ($(DEFAULT_SYSTEM_DEV_CERTIFICATE),build/target/product/security/testkey)
	+BUILD_KEYS := release-keys
	else
	+BUILD_KEYS := release-keys
	endif

	Set MTK_SIGNATURE_CUSTOMIZATION = yes and MTK_INTERNAL = no in the ProjectConfig.mk. 


附上 MTK给出的设置release-keys的官方文档

	[DESCRIPTION]
	
	在L上，CTS有个测试项testPackageSignatures ，该测试项会使用google default key里check
	是否使用的是google default key，如果是，则会test fail。
	因此要使用和google default不一样的key。release key不仅可以满足CTS request，还可以满足工信部CATR TAF spec。
	
	
	[SOLUTION]
	
	1.  Genernate the release key
			–development/tools/make_key releasekey       '/C=CN/ST=BeiJing/L=HaiDian/O=MediaTek/OU=WCD/CN=demo/emailAddress=demo@mediatek.com'
	2.  Genernate the platform /media/shared key，the method as follows：
			Generate platform keys：
			development/tools/make_key platform               '/C=CN/ST=BeiJing/L=HaiDian/O=MediaTek/OU=WCD/CN=demo/emailAddress=demo@mediatek.com'
			Generate media keys
			development/tools/make_key media '/C=CN/ST=BeiJing/L=HaiDian/O=MediaTek/OU=WCD/CN=demo/emailAddress=demo@mediatek.com'
			Generate shared keys
			development/tools/make_key shared '/C=CN/ST=BeiJing/L=HaiDian/O=MediaTek/OU=WCD/CN=demo/emailAddress=demo@mediatek.com'
	3.  get the test key from build/target/product/security/
	4.  Move testkey.pk8, testkey.x509.pem,releasekey.pk8, releasekey.x509.pem, media.pk8, media.x509.pem, 	platform.pk8, platform.x509.pem, shared.pk8 and shared.x509.pem to device/mediatek/common/security/${Project} 
	5.  Set MTK_SIGNATURE_CUSTOMIZATION = yes and MTK_INTERNAL = no in the ProjectConfig.mk. 
	6.  Start a normal build, and the binary-released APK will be signed automatically.