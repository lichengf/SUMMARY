
# 展讯fota编译步骤

---

## 1.前奏

步骤：

编译软件，编译ota，打包

编译软件：

1.下载软件

2.设置编译环境 `source build/envsetup.sh` `lunch` `kheader`

3.通过make命令全编整个工程, `make -j16 2>&1 | tee buildlog.log`


## 2.编译整包

4.进入`device/sprd/XXX/`目录，**手动建立**`modem_bins`子目录

5.然后将idh.code目录下的`modem_bin`中的文件按照`device/sprd/spXXX/AndroidBoard.mk`中的规定更改名字后拷贝到 `device/sprd/XXX/modem_bins/`目录下

以9832A平台为例：

	idh.code\device\sprd\scx35l\sp9832a_2h11\AndroidBoard.mk

	$(call add-radio-file,modem_bins/wcnmodem.bin)
	$(call add-radio-file,modem_bins/wcnfdl.bin)
	$(call add-radio-file,modem_bins/ltedsp.bin)
	$(call add-radio-file,modem_bins/ltenvitem.bin)
	$(call add-radio-file,modem_bins/pmsys.bin)
	$(call add-radio-file,modem_bins/ltemodem.bin)
	$(call add-radio-file,modem_bins/ltewarm.bin)
	$(call add-radio-file,modem_bins/ltegdsp.bin)

6.通过命令 `make otapackage` 编译ota整包，此命令运行完毕后会在out目录下生成ota整包

以9832A平台为例：

	B9401-fota-Package.zip
	sp9832a_2h11_4mvoltesea_tee-ota-eng.licf.zip

## 3.编译sd卡包

1.下载A版本代码，按照整包制作步骤执行，保存此版本的A-target.zip

2.下载B版本代码，按照整包制作步骤执行，保存此版本的B-target.zip

3.制作差分升级包，执行以下命令，由于user版本和userdebug版本使用的签名的key不同，因此命令也不同，而最终-k后面参数为实际版本的key的放置目录。

编译命令：

userdebug版本:

	./build/tools/releasetools/ota_from_target_files -i A-target.zip -k build/target/product/security/testkey B-target.zip A-B_update.zip

user版本:

	./build/tools/releasetools/ota_from_target_files -i version/V10/ota_target_files.zip -k build/target/product/security/release/releasekey version/V11/ota_target_files.zip AA550_01C_BITEL_B9401_V11_FOTA_UPDATE.zip

	cp AA550_01C_BITEL_B9401_V11_FOTA_UPDATE.zip out/host/linux-x86/framework/

	java -Xmx2048m -Djava.library.path=out/host/linux-x86/lib64 -jar out/host/linux-x86/framework/signapk.jar -w build/target/product/security/release/releasekey.x509.pem build/target/product/security/release/releasekey.pk8 out/host/linux-x86/framework/AA550_01C_BITEL_B9401_V11_FOTA_UPDATE.zip AA550_01C_BITEL_B9401_V11_FOTA_UPDATE_AFTER_SIGN.zip

	md5sum ./AA550_01C_BITEL_B9401_V11_FOTA_UPDATE_AFTER_SIGN.zip | awk '{print $1}' >./md5sum

	zip -r ./update_package.zip ./AA550_01C_BITEL_B9401_V11_FOTA_UPDATE_AFTER_SIGN.zip ./md5sum


## 4.签名

	java -Xmx2048m -Djava.library.path=out/host/linux-x86/lib64 -jar out/host/linux-x86/framework/signapk.jar -w build/target/product/security/release/releasekey.x509.pem build/target/product/security/release/releasekey.pk8 out/host/linux-x86/framework/A-B_update_package.zip A-B_update_package_after_sign.zip



## 5.modem_bins 改名规则

当前用的`modem`在里配置`idh.code\device\sprd\scx35l\sp9832a_2h11\sp9832a_2h11_4mvoltesea_tee.mk`

	CUSTOM_MODEM := BAND_8_CP0_W17.15.4_CP2_W17.10.2

以`9832A`的`BAND_8_CP0_W17.15.4_CP2_W17.10.2` modem为例

命名映射规则：

	EXEC_KERNEL_IMAGE0.bin -> wcnmodem.bin
	fdl1_wcn.bin -> wcnfdl.bin
	LTE_DSP.bin -> ltedsp.bin
	nvitem.bin -> ltenvitem.bin
	PM_sharkls_arm7.bin -> pmsys.bin
	SC9600_sharkl_wphy_5mod_volte_zc.bin -> ltewarm.bin
	SC9600_sharkls_3593_CUST_Base_NV_MIPI.dat -> ltemodem.bin
	SHARKL_DM_DSP.bin -> ltegdsp.bin

	
	
	
	
