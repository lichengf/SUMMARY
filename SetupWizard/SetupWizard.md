
# 自定义开机向导

---

## 如何自定义开机向导

在mtk平台有一个自定义开机向导的包，路径是`package/apps/Provision`

## 自定义开机向导的思路

开机向导要先于launcher启动

在AndroidManifest.xml中对启动activity有描述如下

    <application>
        <activity android:name="DefaultActivity"
                android:excludeFromRecents="true"
                android:launchMode="singleTop"
                android:theme="@android:style/Theme.NoTitleBar.Fullscreen">
            <intent-filter android:priority="1">
                <action android:name="android.intent.action.MAIN" />
                <category android:name="android.intent.category.HOME" />
                <category android:name="android.intent.category.DEFAULT" />
                <category android:name="android.intent.category.SETUP_WIZARD" />
            </intent-filter>
        </activity>
    </application>

priority=1，配置了优先级，也就是说它的优先级比我们原生的Launcher优先级还要高，它会在Launcher启动前就运行起来

`android.intent.category.SETUP_WIZARD` 这个系统代码里描述如下：

    /**
     * This is the setup wizard activity, that is the first activity that is displayed
     * when the user sets up the device for the first time.
     * @hide
     */
    @SdkConstant(SdkConstantType.INTENT_CATEGORY)
    public static final String CATEGORY_SETUP_WIZARD = "android.intent.category.SETUP_WIZARD";

表示这个Activity是一个开机向导，并且会在第一次开机是显示。

`Theme.NoTitleBar.Fullscreen` 表示全屏显示, 即不会显示状态栏

## 判断是否是第一次启动

在 DefaultActivity.java里有如下代码

	// Add a persistent setting to allow other apps to know the device has been provisioned.
	Settings.Global.putInt(getContentResolver(), Settings.Global.DEVICE_PROVISIONED, 1);
	Settings.Secure.putInt(getContentResolver(), Settings.Secure.USER_SETUP_COMPLETE, 1);

	// remove this activity from the package manager.
	PackageManager pm = getPackageManager();
	ComponentName name = new ComponentName(DefaultActivity.this, DefaultActivity.class);
	pm.setComponentEnabledSetting(name, PackageManager.COMPONENT_ENABLED_STATE_DISABLED,
			PackageManager.DONT_KILL_APP);



## 通过Provision，可以定制：

 加入一些初始设置项的设定，比如时区/时间初始设定，背景数据是否允许，是否允许安装非Android市场上的程序，等不需要用户干预就可以完成的设置。具体也可看SdkSetup中的DefaultActivity完成的设置，除了多了些设置项的设置，并没有太多区别。

 加入UI设计，引导用户一步步完成需要用户参与选择或输入的设置过程，也就是Setup Wizard的工作。

比如:

我在这个setup wizard中加入了一个隐私说明，同意才能继续，拒绝的话就直接关机

其中的string随意，一个是dialog的title，一个是dialog的内容，还有拒绝和同意两个选项。

	package com.android.provision;
	
	import android.app.Activity;
	import android.content.ComponentName;
	import android.content.pm.PackageManager;
	import android.os.Bundle;
	import android.provider.Settings;
	
	import android.app.AlertDialog;
	import android.app.Dialog;
	import android.content.Context;
	import android.content.DialogInterface;
	import android.content.Intent;
	import android.graphics.PixelFormat;
	import android.os.Bundle;
	import android.os.Handler;
	import android.os.Message;
	import android.os.PowerManager;
	
	import android.util.Log;
	import android.view.Gravity;
	import android.view.WindowManager;
	
	/**
	 * Application that sets the provisioned bit, like SetupWizard does.
	 */
	public class DefaultActivity extends Activity {
		private static final int DIALOG_SHOW_MESSAGE = 1;
		private static final String LOG_TAG = "DefaultActivity";
		private PowerManager mPowerManager = null;
	    @Override
	    protected void onCreate(Bundle icicle) {
	        super.onCreate(icicle);
			mPowerManager = (PowerManager) getSystemService(Context.POWER_SERVICE);
			showDialog(DIALOG_SHOW_MESSAGE);
	    }
		
		@Override
	    protected void onStop() {
	        Log.i(LOG_TAG, "onStop: ");
	        super.onStop();
	        removeDialog(DIALOG_SHOW_MESSAGE);
	        finish();
	    }
		
	    @Override
	    protected Dialog onCreateDialog(int id) {
	        switch (id) {
	            case DIALOG_SHOW_MESSAGE:
	                return new AlertDialog.Builder(this)
	                        .setTitle(R.string.termsandconditions)
	                        .setMessage(R.string.provision)
	                        .setCancelable(false)
	                        .setOnCancelListener(new AlertDialog.OnCancelListener() {
	                            public void onCancel(DialogInterface dialog) {
	                                dialog.dismiss();
	                                finish();
	                            }
	                        })
	                        .setNeutralButton(R.string.action_accept,
	                                new DialogInterface.OnClickListener() {
	                                    public void onClick(DialogInterface dialog, int whichButton) {
											Log.i(LOG_TAG, "accept: ");
											// Add a persistent setting to allow other apps to know the device has been provisioned.
											Settings.Global.putInt(getContentResolver(), Settings.Global.DEVICE_PROVISIONED, 1);
											Settings.Secure.putInt(getContentResolver(), Settings.Secure.USER_SETUP_COMPLETE, 1);
	
											// remove this activity from the package manager.
											PackageManager pm = getPackageManager();
											ComponentName name = new ComponentName(DefaultActivity.this, DefaultActivity.class);
											pm.setComponentEnabledSetting(name, PackageManager.COMPONENT_ENABLED_STATE_DISABLED,
													PackageManager.DONT_KILL_APP);
											
	                                        dialog.dismiss();
	                                        finish();
	                                    }
	                                })
	                        .setNegativeButton(R.string.action_reject, new DialogInterface.OnClickListener() {
	                            @Override
	                            public void onClick(DialogInterface dialog, int which) {
									Log.i(LOG_TAG, "reject: ");
									if (mPowerManager != null) {
										mPowerManager.shutdown(false, null, false);
									}
	                                //dialog.dismiss();
	                                //finish();
	                            }
	                        })
	                        .create();
	
	        }
	        return null;
	    }	
	}
	
