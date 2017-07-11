
## 1. 文件及文件目录关系

用到如下包：

	android-cts-7.0_r8-linux_x86-arm.zip
	gts-4.1_r2-3911033.zip
	sdk.zip //sdk用的是25.0.0
	jdk.zip //这里用到的是jdk1.8.0_11

将以上zip解压到/home/licf/CTS/

注意把cts和gts的文件夹名字改一下

如下图：

![gms_filepath_sample](http://o8r7cqsy6.bkt.clouddn.com/gms_filepath_sample.png)


## 2.配置java和adb

### 2.1 java环境搭建

首先把 **jdk1.8.0_11** 拷贝到 **/opt/** 目录下

如下图：

![linux_java_path](http://o8r7cqsy6.bkt.clouddn.com/linux_java_path.png)

然后修改**/etc/profile**文件

命令是：

	root@ubuntu:/# gedit /etc/profile

添加如下**set java environment**和**set adb environment**这两段

注意文件对应路径可能要根据自己的需求修改

	if [ -d /etc/profile.d ]; then
	  for i in /etc/profile.d/*.sh; do
	    if [ -r $i ]; then
	      . $i
	    fi
	  done
	  unset i
	fi
	
	#set java environment
	export JAVA_HOME=/home/licf/CTS/jdk/jdk1.8.0_11
	export JRE_HOME=${JAVA_HOME}/jre
	export CLASSPATH=.:${JAVA_HOME}/lib:${JRE_HOME}/lib
	export PATH=${JAVA_HOME}/bin:$PATH
	
	#set adb environment
	AAPT=/home/licf/CTS/sdk/build-tools/25.0.0
	ADB=/home/licf/CTS/sdk/platform-tools
	export PATH=$AAPT:$ADB:$PATH

最后是验证java环境和adb是否可用

	root@ubuntu:/# source /etc/profile //这步一定得执行
	root@ubuntu:/# java -version //查看java版本是1.8.0_11，说明java环境变量配置ok
	java version "1.8.0_11"
	Java(TM) SE Runtime Environment (build 1.8.0_11-b12)
	Java HotSpot(TM) 64-Bit Server VM (build 25.11-b03, mixed mode)
	root@ubuntu:/# adb devices  //用adb查看有哪些设备已连接，当然要先链接一个Android设备
	List of devices attached
	19097068863637	device
	
**Android设备连不上可能是没有装驱动。**

## 3.linux安装USB驱动

下面写的有点麻烦了，可以直接把附件里的**51-android.rules**和**61-android.rules**复制到
**/etc/udev/rules.d/**然后改个权限就行了。

	sudo touch /etc/udev/rules.d/51-android.rules
	sudo chmod a+rw /etc/udev/rules.d/51-android.rules
	
	cd /etc/udev/rules.d
	Sudo gedit 51-android.rules
	添加代码：
	SUBSYSTEM=="usb",       ENV{DEVTYPE}=="usb device",  MODE="0666"
	SUBSYSTEM=="usb", ATTRS{idVendor}=="0e8d", ATTRS{idProduct}=="2003", MODE="0666" 
	sudo restart udev(所有设备都可以识别到)
	重启电脑

## 4.配置aapt权限

到此GMS测试环境就配好了，但是不一定能用，可能因为sdk里的aapt没权限，

为了以防万一，建议直接给**/home/licf/CTS/sdk**文件夹赋权限

命令如下：

	chmod -R 777 /home/licf/CTS/sdk

## 5. 执行cts和gts命令

首先把附件里的**4.0\_r2.sh**和**7.0\_r8.sh**放到DeskTop

这两个.sh要注意对应目录.


**执行模块命令如下：**

gts举个例子：

	run gts -m GtsHomeHostTestCases -t com.google.android.home.gts.ScreenshotTest#testHomeScreen --skip-preconditions

cts同上，只是把gts改成cts

比如：

	run gts -m XXX -t XXX --skip-preconditions

![gts_terminal_sample](http://o8r7cqsy6.bkt.clouddn.com/gts_terminal_sample.png)

**跑完之后可以看下结果：**

![gms_test_result_sample](http://o8r7cqsy6.bkt.clouddn.com/gms_test_result_sample.png)

## 6.附件

https://pan.baidu.com/s/1qXCLPWo