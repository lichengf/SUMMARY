
# 自动生成apn脚本
---

印度客户的apn要求有1316条，格式排的很给力，可以写脚本搞定，共享如下：

运行 apn\_format.bat， 读取India_APN.csv文件

apn信息会生成到apns-conf_8.xml文件中去

具体代码是apn_format.pl

主要是读取文件，然后逐行读取到数组，然后再逐行打印到输出文件中。





