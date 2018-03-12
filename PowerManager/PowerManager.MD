
## 判断是否亮屏以及如果没亮屏则亮屏

	import android.os.SystemClock;
	import android.os.PowerManager;

	PowerManager mPowerManager = (PowerManager) context.getSystemService(Context.POWER_SERVICE);

	if (!mPowerManager.isScreenOn()) {
		android.util.Log.i("lcf_toy", "TcSettingsReceiver case 1.");
		try {
			mPowerManager.wakeUp(SystemClock.uptimeMillis());
		} catch (Exception e) {
		}
	}