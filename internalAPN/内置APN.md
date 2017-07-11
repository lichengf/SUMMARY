# MTK
---
## APN路径

	alps\device\mediatek\common\apns-conf.xml

## 内置APN

	在此路径下，在apns-conf.xml文件中，按照之前的模式把客户需要内置的apn预置： 
	alps\vendor\mediatek\proprietary\frameworks\base\telephony\etc\apns-conf.xml
	<apn carrier="中国移动彩信 (China Mobile)"
	mcc="460"    国家代码
	mnc="07"  运营商吗
	apn="cmwap"  apn
	proxy="10.0.0.172" 代理网址
	port="80" 端口
	mmsc="http://mmsc.monternet.com"   短信网址
	mmsproxy="10.0.0.172"  彩信代理网址
	mmsport="80" 彩信端口
	type="mms" 类型
	protocol="IPV4V6" 协议
	roaming_protocol="IPV4V6" 代理协议
	/>
	authenticationtype="PAP"如果需求中存在Authentication：normal。说明没有用户名和密码的话，这个鉴权是不需要的。
	authtype, 需求表中没有注明的情况下置为PAP or CHAP或者空（没有authtype这一项）都可以的。
	authtype这一项未填写，不管有无用户名，会自动默认为PAP or CHAP。
	
	APN 的类型分为web(internet),wap,mms三种类型，用于手机中上网时数据交换的接入点名称配置与显示。
	APN配置的时候，出现的type的值主要有：default，mms,supl,dun。
	Default常用于一般的数据业务，主要有internet,wap,web.mms类型用于彩信接收发送的业务；supl用于gprs上网；dun用于wifi等上网类型。
