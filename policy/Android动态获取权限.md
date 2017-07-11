
# Android动态获取权限

---

自Android6.0之后需要动态申请应用权限，即在AndroidManifest.xml里面配置了权限还不够，还要在app运行时手动赋予权限。

**动态权限要在AndroidManifest.xml配置的基础上，如果只配置动态权限不在AndroidManifest.xml里面添加动态权限第一次申请会失败.**

效果如下图：

![](http://o8r7cqsy6.bkt.clouddn.com/dynamic_permissions.gif)

## 如何动态申请多个权限

	import android.os.Build;
	import android.Manifest;
	import java.util.ArrayList;
	import android.content.pm.PackageManager;
	import android.support.v4.app.ActivityCompat;
	import android.support.v4.content.ContextCompat;

	public final int REQUEST_CODE_ASK_PREMISSIONS = 0;//请求码，值随意
	
	//将所有需要动态申请的权限放到一个数组里面
	String[] permissions = {Manifest.permission.ACCESS_COARSE_LOCATION, 
							Manifest.permission.ACCESS_FINE_LOCATION,
							Manifest.permission.WRITE_EXTERNAL_STORAGE, 
							Manifest.permission.READ_EXTERNAL_STORAGE,
							Manifest.permission.READ_PHONE_STATE,
							Manifest.permission.RECORD_AUDIO};

	@Override
	protected void onResume() {
		// TODO Auto-generated method stub
		super.onResume();
		
		//判断是否为Android6.0即sdk为23以上
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {			
			ArrayList<String> permissionList = new ArrayList<String>();
			for (int i = 0; i < permissions.length; i++) {
				if (ContextCompat.checkSelfPermission(this, permissions[i]) != PackageManager.PERMISSION_GRANTED) {
					//将需要申请的权限放到permissionList数组中
					permissionList.add(permissions[i]);
				}
			}
			
			if (!permissionList.isEmpty()) {
				String[] permission = permissionList.toArray(new String[permissionList.size()]);
				//向系统申请权限
				ActivityCompat.requestPermissions(this, permission, REQUEST_CODE_ASK_PREMISSIONS);			
			}
		}
	}

	@Override
	public void onRequestPermissionsResult(int requestCode, String permissions[], int[] grantResults) {
		switch (requestCode) {
			case REQUEST_CODE_ASK_PREMISSIONS:
				for (int i = 0; i < grantResults.length; i++) {
					if (grantResults[i] != PackageManager.PERMISSION_GRANTED) {
						//如果有权限没有申请成功，直接finish，也有说再重新申请，看需求
						finish();
					}
				}
			break;
		}
	}	