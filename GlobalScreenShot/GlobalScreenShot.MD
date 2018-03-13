
#GlobalScreenShot 截图总结

## 长按power键添加截图选项

### androidN 7.0实现
---

	frameworks/base/core/res/res/drawable-hdpi/ic_screenshot.png
	
	frameworks/base/core/res/res/values-zh-rCN/strings.xml
	+    <!--add by cfdroid-->
	+    <string name="global_action_screenshot" >屏幕截图</string>
	+    <!--end by cfdroid-->
	
	frameworks/base/core/res/res/values/strings.xml
	+    <!--add by cfdroid -->
	+    <string name="global_action_screenshot" >Screenshot</string>
	+    <!--end cfdroid-->

	frameworks/base/core/res/res/values/symbols.xml
	+  <!--cfdroid begin -->
	+  <java-symbol type="drawable" name="ic_screenshot" />
	+  <java-symbol type="string" name="global_action_screenshot" />


	frameworks/base/services/core/java/com/android/server/policy/GlobalActions.java
	+//add by cfdroid
	+import android.content.ComponentName;
	+import android.content.ServiceConnection;
	+import android.os.IBinder;
	+import android.os.Messenger;
	+import android.os.PowerManager;
	+import static android.view.WindowManager.TAKE_SCREENSHOT_FULLSCREEN;
	+import static android.view.WindowManager.TAKE_SCREENSHOT_SELECTED_REGION;
	+//cfdroid end

	+            if (GLOBAL_ACTION_KEY_POWER.equals(actionKey)) {
	+                mItems.add(new PowerAction());
	+            } else if (GLOBAL_ACTION_KEY_AIRPLANE.equals(actionKey)) {
	+                mItems.add(mAirplaneModeOn);
	+				mItems.add(new ScreenShortAction());  //add by cfdroid				
	+            } else if (GLOBAL_ACTION_KEY_BUGREPORT.equals(actionKey)) {	



	+	//water: lichengfeng begin
	+    private class ScreenshotRunnable implements Runnable {
	+        private int mScreenshotType = TAKE_SCREENSHOT_FULLSCREEN;
	+
	+        public void setScreenshotType(int screenshotType) {
	+            mScreenshotType = screenshotType;
	+        }
	+       
	+        @Override
	+        public void run() {
	+            takeScreenshot(mScreenshotType);
	+        }
	+    }	
	+	
	+    private long getScreenshotChordLongPressDelay() {
	+        return ViewConfiguration.get(mContext).getDeviceGlobalActionKeyTimeout();
	+    }	
	+    final Object mScreenshotLock = new Object();
	+    ServiceConnection mScreenshotConnection = null;
	+    private final ScreenshotRunnable mScreenshotRunnable = new ScreenshotRunnable();
	+	
	+    private static final String SYSUI_PACKAGE = "com.android.systemui";
	+    private static final String SYSUI_SCREENSHOT_SERVICE =
	+            "com.android.systemui.screenshot.TakeScreenshotService";
	+    private static final String SYSUI_SCREENSHOT_ERROR_RECEIVER =
	+            "com.android.systemui.screenshot.ScreenshotServiceErrorReceiver";
	+    final Runnable mScreenshotTimeout = new Runnable() {
	+        @Override public void run() {
	+            synchronized (mScreenshotLock) {
	+                if (mScreenshotConnection != null) {
	+                    mContext.unbindService(mScreenshotConnection);
	+                    mScreenshotConnection = null;
	+                    notifyScreenshotError();
	+                }
	+            }
	+        }
	+    };
	+	
	+    private void takeScreenshot(final int screenshotType) {
	+        synchronized (mScreenshotLock) {
	+            if (mScreenshotConnection != null) {
	+                return;
	+            }
	+            final ComponentName serviceComponent = new ComponentName(SYSUI_PACKAGE,
	+                    SYSUI_SCREENSHOT_SERVICE);
	+            final Intent serviceIntent = new Intent();
	+            serviceIntent.setComponent(serviceComponent);
	+            ServiceConnection conn = new ServiceConnection() {
	+                @Override
	+                public void onServiceConnected(ComponentName name, IBinder service) {
	+                    synchronized (mScreenshotLock) {
	+                        if (mScreenshotConnection != this) {
	+                            return;
	+                        }
	+                        Messenger messenger = new Messenger(service);
	+                        Message msg = Message.obtain(null, screenshotType);
	+                        final ServiceConnection myConn = this;
	+                        Handler h = new Handler(mHandler.getLooper()) {
	+                            @Override
	+                            public void handleMessage(Message msg) {
	+                                synchronized (mScreenshotLock) {
	+                                    if (mScreenshotConnection == myConn) {
	+                                        mContext.unbindService(mScreenshotConnection);
	+                                        mScreenshotConnection = null;
	+                                        mHandler.removeCallbacks(mScreenshotTimeout);
	+                                    }
	+                                }
	+                            }
	+                        };
	+                        msg.replyTo = new Messenger(h);
	+                        msg.arg1 = msg.arg2 = 0;
	+                        //if (mStatusBar != null && mStatusBar.isVisibleLw())
	+                        //    msg.arg1 = 1;
	+                        //if (mNavigationBar != null && mNavigationBar.isVisibleLw())
	+                        //    msg.arg2 = 1;
	+                        try {
	+                            messenger.send(msg);
	+                        } catch (RemoteException e) {
	+                        }
	+                    }
	+                }
	+
	+                @Override
	+                public void onServiceDisconnected(ComponentName name) {
	+                    notifyScreenshotError();
	+                }
	+            };
	+            if (mContext.bindServiceAsUser(serviceIntent, conn,
	+                    Context.BIND_AUTO_CREATE | Context.BIND_FOREGROUND_SERVICE_WHILE_AWAKE,
	+                    UserHandle.CURRENT)) {
	+                mScreenshotConnection = conn;
	+                mHandler.postDelayed(mScreenshotTimeout, 10000);
	+            }
	+        }
	+    }	
	+	
	+    private void notifyScreenshotError() {
	+        // If the service process is killed, then ask it to clean up after itself
	+        final ComponentName errorComponent = new ComponentName(SYSUI_PACKAGE,
	+                SYSUI_SCREENSHOT_ERROR_RECEIVER);
	+        Intent errorIntent = new Intent(Intent.ACTION_USER_PRESENT);
	+        errorIntent.setComponent(errorComponent);
	+        errorIntent.addFlags(Intent.FLAG_RECEIVER_REGISTERED_ONLY_BEFORE_BOOT |
	+                Intent.FLAG_RECEIVER_FOREGROUND);
	+        mContext.sendBroadcastAsUser(errorIntent, UserHandle.CURRENT);
	+    }	
	+    
	+	private final class ScreenShortAction extends SinglePressAction implements LongPressAction {
	+        private ScreenShortAction() {
	+            super(com.android.internal.R.drawable.ic_screenshot,
	+                com.android.internal.R.string.global_action_screenshot);
	+        }
	+
	+        @Override
	+        public boolean onLongPress() {
	+            return true;
	+        }
	+
	+        @Override
	+        public boolean showDuringKeyguard() {
	+            return true;
	+        }
	+
	+        @Override
	+        public boolean showBeforeProvisioning() {
	+            return true;
	+        }
	+		
	+		 @Override
	+        public void onPress() {
	+		    mScreenshotRunnable.setScreenshotType(TAKE_SCREENSHOT_FULLSCREEN);
	+            mHandler.postDelayed(mScreenshotRunnable, getScreenshotChordLongPressDelay());
	+        }
	+    }                     
	+    

### androidN 6.0实现
---

	+import android.content.ComponentName;
	+import android.content.ServiceConnection;
	+import android.os.IBinder;
	+import android.os.Messenger;
	+import android.os.PowerManager;

	+	//cfdroid golbal action screenshot begin
	+	private static final int TAKE_SCREENSHOT_FULLSCREEN = 1;
	+	//cfdroid golbal action screenshot end
	+	
	     private final Context mContext;
	     private final WindowManagerFuncs mWindowManagerFuncs;
	     private final AudioManager mAudioManager;
	@@ -280,6 +293,7 @@ class GlobalActions implements DialogInterface.OnDismissListener, DialogInterfac
	                 mItems.add(new PowerAction());
	             } else if (GLOBAL_ACTION_KEY_AIRPLANE.equals(actionKey)) {
	                 mItems.add(mAirplaneModeOn);
	+				mItems.add(new ScreenShortAction());  //add by cfdroid				
	             } else if (GLOBAL_ACTION_KEY_BUGREPORT.equals(actionKey)) {
	                 if (Settings.Global.getInt(mContext.getContentResolver(),
	                         Settings.Global.BUGREPORT_IN_POWER_MENU, 0) != 0 && isCurrentUserOwner()) {
	@@ -343,6 +357,144 @@ class GlobalActions implements DialogInterface.OnDismissListener, DialogInterfac
	 
	         return dialog;
	     }
	+	
	+	//water: lichengfeng begin
	+    private class ScreenshotRunnable implements Runnable {
	+        private int mScreenshotType = TAKE_SCREENSHOT_FULLSCREEN;
	+
	+        public void setScreenshotType(int screenshotType) {
	+            mScreenshotType = screenshotType;
	+        }
	+
	+        @Override
	+        public void run() {
	+            takeScreenshot(mScreenshotType);
	+        }
	+    }	
	+	
	+    private long getScreenshotChordLongPressDelay() {
	+        return ViewConfiguration.get(mContext).getDeviceGlobalActionKeyTimeout();
	+    }	
	+	
	+    final Object mScreenshotLock = new Object();
	+    ServiceConnection mScreenshotConnection = null;
	+    private final ScreenshotRunnable mScreenshotRunnable = new ScreenshotRunnable();
	+	
	+    private static final String SYSUI_PACKAGE = "com.android.systemui";
	+    private static final String SYSUI_SCREENSHOT_SERVICE =
	+            "com.android.systemui.screenshot.TakeScreenshotService";
	+    private static final String SYSUI_SCREENSHOT_ERROR_RECEIVER =
	+            "com.android.systemui.screenshot.ScreenshotServiceErrorReceiver";
	+
	+    final Runnable mScreenshotTimeout = new Runnable() {
	+        @Override public void run() {
	+            synchronized (mScreenshotLock) {
	+                if (mScreenshotConnection != null) {
	+                    mContext.unbindService(mScreenshotConnection);
	+                    mScreenshotConnection = null;
	+                    //notifyScreenshotError();
	+                }
	+            }
	+        }
	+    };
	+	
	+    private void takeScreenshot(final int screenshotType) {
	+        synchronized (mScreenshotLock) {
	+            if (mScreenshotConnection != null) {
	+                return;
	+            }
	+            final ComponentName serviceComponent = new ComponentName(SYSUI_PACKAGE,
	+                    SYSUI_SCREENSHOT_SERVICE);
	+            final Intent serviceIntent = new Intent();
	+            serviceIntent.setComponent(serviceComponent);
	+            ServiceConnection conn = new ServiceConnection() {
	+                @Override
	+                public void onServiceConnected(ComponentName name, IBinder service) {
	+                    synchronized (mScreenshotLock) {
	+                        if (mScreenshotConnection != this) {
	+                            return;
	+                        }
	+                        Messenger messenger = new Messenger(service);
	+                        Message msg = Message.obtain(null, screenshotType);
	+                        final ServiceConnection myConn = this;
	+                        Handler h = new Handler(mHandler.getLooper()) {
	+                            @Override
	+                            public void handleMessage(Message msg) {
	+                                synchronized (mScreenshotLock) {
	+                                    if (mScreenshotConnection == myConn) {
	+                                        mContext.unbindService(mScreenshotConnection);
	+                                        mScreenshotConnection = null;
	+                                        mHandler.removeCallbacks(mScreenshotTimeout);
	+                                    }
	+                                }
	+                            }
	+                        };
	+                        msg.replyTo = new Messenger(h);
	+                        msg.arg1 = msg.arg2 = 0;
	+                        //if (mStatusBar != null && mStatusBar.isVisibleLw())
	+                        //    msg.arg1 = 1;
	+                        //if (mNavigationBar != null && mNavigationBar.isVisibleLw())
	+                        //    msg.arg2 = 1;
	+                        try {
	+                            messenger.send(msg);
	+                        } catch (RemoteException e) {
	+                        }
	+                    }
	+                }
	+
	+                @Override
	+                public void onServiceDisconnected(ComponentName name) {
	+                    //notifyScreenshotError();
	+                }
	+            };
	+            if (mContext.bindServiceAsUser(serviceIntent, conn,
	+                    Context.BIND_AUTO_CREATE | Context.BIND_FOREGROUND_SERVICE_WHILE_AWAKE,
	+                    UserHandle.CURRENT)) {
	+                mScreenshotConnection = conn;
	+                mHandler.postDelayed(mScreenshotTimeout, 10000);
	+            }
	+        }
	+    }	
	+	
	+    private void notifyScreenshotError() {
	+        // If the service process is killed, then ask it to clean up after itself
	+        final ComponentName errorComponent = new ComponentName(SYSUI_PACKAGE,
	+                SYSUI_SCREENSHOT_ERROR_RECEIVER);
	+        Intent errorIntent = new Intent(Intent.ACTION_USER_PRESENT);
	+        errorIntent.setComponent(errorComponent);
	+        errorIntent.addFlags(Intent.FLAG_RECEIVER_REGISTERED_ONLY_BEFORE_BOOT |
	+                Intent.FLAG_RECEIVER_FOREGROUND);
	+        mContext.sendBroadcastAsUser(errorIntent, UserHandle.CURRENT);
	+    }	
	+	
	+	private final class ScreenShortAction extends SinglePressAction implements LongPressAction {
	+        private ScreenShortAction() {
	+            super(com.android.internal.R.drawable.ic_screenshot,
	+                com.android.internal.R.string.global_action_screenshot);
	+        }
	+
	+        @Override
	+        public boolean onLongPress() {
	+            return true;
	+        }
	+
	+        @Override
	+        public boolean showDuringKeyguard() {
	+            return true;
	+        }
	+
	+        @Override
	+        public boolean showBeforeProvisioning() {
	+            return true;
	+        }
	+		
	+		 @Override
	+        public void onPress() {
	+		    mScreenshotRunnable.setScreenshotType(TAKE_SCREENSHOT_FULLSCREEN);
	+            mHandler.postDelayed(mScreenshotRunnable, getScreenshotChordLongPressDelay());
	+        }
	+    }	