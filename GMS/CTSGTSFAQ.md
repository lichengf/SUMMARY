
# CTS/GTS 常见测试问题


### GTS测试

* testValidSysConfigPresent


**testValidSysConfigPresent**

测试命令：

	run gts -m GtsOsTestCases  -t com.google.android.os.gts.SysConfigTest#testValidSysConfigPresent --skip-preconditions

Fail log：

	07-13 17:44:50.343  7160  7174 I TestRunner: failed: testValidSysConfigPresent(com.google.android.os.gts.SysConfigTest)
	07-13 17:44:50.343  7160  7174 I TestRunner: ----- begin exception -----
	07-13 17:44:50.346  7160  7174 I TestRunner: java.lang.AssertionError: Unknown XML tag (config): is test case up to date?
	07-13 17:44:50.346  7160  7174 I TestRunner: 	at org.junit.Assert.fail(Assert.java:88)
	07-13 17:44:50.346  7160  7174 I TestRunner: 	at com.google.android.os.gts.SysConfigTest$SystemConfig.<init>(SysConfigTest.java:503)
	07-13 17:44:50.346  7160  7174 I TestRunner: 	at com.google.android.os.gts.SysConfigTest.testValidSysConfigPresent(SysConfigTest.java:91)
	07-13 17:44:50.346  7160  7174 I TestRunner: 	at java.lang.reflect.Method.invoke(Native Method)
	07-13 17:44:50.346  7160  7174 I TestRunner: 	at org.junit.runners.model.FrameworkMethod$1.runReflectiveCall(FrameworkMethod.java:50)
	07-13 17:44:50.346  7160  7174 I TestRunner: 	at org.junit.internal.runners.model.ReflectiveCallable.run(ReflectiveCallable.java:12)
	07-13 17:44:50.346  7160  7174 I TestRunner: 	at org.junit.runners.model.FrameworkMethod.invokeExplosively(FrameworkMethod.java:47)
	07-13 17:44:50.346  7160  7174 I TestRunner: 	at org.junit.internal.runners.statements.InvokeMethod.evaluate(InvokeMethod.java:17)
	07-13 17:44:50.346  7160  7174 I TestRunner: 	at org.junit.internal.runners.statements.FailOnTimeout$CallableStatement.call(FailOnTimeout.java:298)
	07-13 17:44:50.346  7160  7174 I TestRunner: 	at org.junit.internal.runners.statements.FailOnTimeout$CallableStatement.call(FailOnTimeout.java:292)
	07-13 17:44:50.346  7160  7174 I TestRunner: 	at java.util.concurrent.FutureTask.run(FutureTask.java:237)
	07-13 17:44:50.346  7160  7174 I TestRunner: 	at java.lang.Thread.run(Thread.java:761)
	07-13 17:44:50.346  7160  7174 I TestRunner: ----- end exception -----

解决方案：

这个问题要用最新的测试项进行测试。

**GtsInstallPackagesWhitelistDeviceTestCases**
	
测试命令：

	run gts -m GtsInstallPackagesWhitelistDeviceTestCases -t com.google.android.installpackageswhitelist.gts.GtsInstallPackagesWhitelistDeviceTest#testInstallerPackagesAgainstWhitelist --skip-preconditions

Fail log：

	01-01 07:12:36.088  5534  5549 I TestRunner: failed: testInstallerPackagesAgainstWhitelist(com.google.android.installpackageswhitelist.gts.GtsInstallPackagesWhitelistDeviceTest)
	01-01 07:12:36.088  5534  5549 I TestRunner: ----- begin exception -----
	01-01 07:12:36.090  5534  5549 I TestRunner: junit.framework.AssertionFailedError: Packages have INSTALL_PACKAGES permission not on whitelist:
	01-01 07:12:36.090  5534  5549 I TestRunner: com.example.app ebfc09e493c457e03b8024d632483c90e3bf3fb2c6b3302b56c7cb7adb73f775
	01-01 07:12:36.090  5534  5549 I TestRunner: 	at junit.framework.Assert.fail(Assert.java:50)
	01-01 07:12:36.090  5534  5549 I TestRunner: 	at junit.framework.Assert.assertTrue(Assert.java:20)
	01-01 07:12:36.090  5534  5549 I TestRunner: 	at com.google.android.installpackageswhitelist.gts.GtsInstallPackagesWhitelistDeviceTest.checkInstallerPackageApps(GtsInstallPackagesWhitelistDeviceTest.java:159)
	01-01 07:12:36.090  5534  5549 I TestRunner: 	at com.google.android.installpackageswhitelist.gts.GtsInstallPackagesWhitelistDeviceTest.testInstallerPackagesAgainstWhitelist(GtsInstallPackagesWhitelistDeviceTest.java:165)
	01-01 07:12:36.090  5534  5549 I TestRunner: 	at java.lang.reflect.Method.invoke(Native Method)
	01-01 07:12:36.090  5534  5549 I TestRunner: 	at android.test.InstrumentationTestCase.runMethod(InstrumentationTestCase.java:220)
	01-01 07:12:36.090  5534  5549 I TestRunner: 	at android.test.InstrumentationTestCase.runTest(InstrumentationTestCase.java:205)
	01-01 07:12:36.090  5534  5549 I TestRunner: 	at junit.framework.TestCase.runBare(TestCase.java:134)
	01-01 07:12:36.090  5534  5549 I TestRunner: 	at junit.framework.TestResult$1.protect(TestResult.java:115)
	01-01 07:12:36.090  5534  5549 I TestRunner: 	at android.support.test.internal.runner.junit3.AndroidTestResult.runProtected(AndroidTestResult.java:77)
	01-01 07:12:36.090  5534  5549 I TestRunner: 	at junit.framework.TestResult.run(TestResult.java:118)
	01-01 07:12:36.090  5534  5549 I TestRunner: 	at android.support.test.internal.runner.junit3.AndroidTestResult.run(AndroidTestResult.java:55)
	01-01 07:12:36.090  5534  5549 I TestRunner: 	at junit.framework.TestCase.run(TestCase.java:124)
	01-01 07:12:36.090  5534  5549 I TestRunner: 	at android.support.test.internal.runner.junit3.NonLeakyTestSuite$NonLeakyTest.run(NonLeakyTestSuite.java:63)
	01-01 07:12:36.090  5534  5549 I TestRunner: 	at android.support.test.internal.runner.junit3.AndroidTestSuite$1.run(AndroidTestSuite.java:97)
	01-01 07:12:36.090  5534  5549 I TestRunner: 	at java.util.concurrent.Executors$RunnableAdapter.call(Executors.java:428)
	01-01 07:12:36.090  5534  5549 I TestRunner: 	at java.util.concurrent.FutureTask.run(FutureTask.java:237)
	01-01 07:12:36.090  5534  5549 I TestRunner: 	at java.util.concurrent.ThreadPoolExecutor.runWorker(ThreadPoolExecutor.java:1133)
	01-01 07:12:36.090  5534  5549 I TestRunner: 	at java.util.concurrent.ThreadPoolExecutor$Worker.run(ThreadPoolExecutor.java:607)
	01-01 07:12:36.090  5534  5549 I TestRunner: 	at java.lang.Thread.run(Thread.java:761)
	01-01 07:12:36.090  5534  5549 I TestRunner: ----- end exception -----
	01-01 07:12:36.092  5534  5549 I TestRunner: finished: testInstallerPackagesAgainstWhitelist(com.google.android.installpackageswhitelist.gts.GtsInstallPackagesWhitelistDeviceTest)

解决方案：

将com.example.app的INSTALL_PACKAGES permission 去掉即可。