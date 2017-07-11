
# 编译apk时遇到的问题汇总

---

## 1. Android.mk不编译某个目录

比如MTK平台，Launcher3中有个mtk自己加的op09目录**`packages/apps/Launcher3/src/com/android/launcher3/op09`**,
在设置-1屏为Google搜索时, 编译Google包中的SearchLauncher, SearchLauncher要覆盖Launcher3, 但是由于Launcher3中有op09, 因此一直提示编译报错。

这个问题后来发现单独编译Launcher3不会报错，但是单独编译SearchLauncher会报错，而且报的是Launcher3里的错。

将Launcher3和SearchLauncher的Android.mk对比分析了一下。发现想要不编译源码的某些目录可以作如下操作：

	Launcher3的Android.mk中有如下代码：
	
	//...
	LOCAL_SRC_FILES := $(call all-java-files-under, src) \
    $(call all-java-files-under, WallpaperPicker/src) \
    $(call all-proto-files-under, protos)
	//...
	SRC_ROOT := src/com/android/launcher3
	OP09_SRC := $(call all-java-files-under, $(SRC_ROOT)/op09)
	LOCAL_SRC_FILES := $(filter-out $(OP09_SRC), $(LOCAL_SRC_FILES)) //这个filter-out会把对应目录比如$(OP09_SRC)从$(LOCAL_SRC_FILES)中删掉
	//...

