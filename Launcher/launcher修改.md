
# Launcher常见修改
---

## 1.移除launcher欢迎页

### 7.0修改

![launcher_welcome_page](http://o8r7cqsy6.bkt.clouddn.com/launcher_welcome_page_delete.png)

	packages\apps\Launcher3\src\com\android\launcher3\LauncherClings.java

	shouldShowFirstRunOrMigrationClings() 返回false即可。
	具体判断在areClingsEnabled()， 这个方法返回false也行。

## 2.Launcher3的搜索框

### 7.0修改

![launcher_welcome_page](http://o8r7cqsy6.bkt.clouddn.com/launcher_quicksearch_bar.png)

* 2.1 如何隐藏搜索框

搜索框简写QSB	
	
	packages\apps\Launcher3\src\com\android\launcher3\Launcher.java

	getOrCreateQsbBar返回null即可。


	比如：

	    public View getOrCreateQsbBar() {
        if (launcherCallbacksProvidesSearch()) {
            return mLauncherCallbacks.getQsbBar();
        }
		//...
		+ if (true) return null;
		//...
		}

## 3.hotseat

### 7.0 

![launcher_welcome_page](http://o8r7cqsy6.bkt.clouddn.com/launcher_hotseat.png)

* 3.1 禁止hotseat拖动

hotseat

	packages\apps\Launcher3\src\com\android\launcher3\Launcher.java

    public boolean onLongClick(View v) {

		//...

        View itemUnderLongClick = null;
        if (v.getTag() instanceof ItemInfo) {
            ItemInfo info = (ItemInfo) v.getTag();
            longClickCellInfo = new CellLayout.CellInfo(v, info);
            itemUnderLongClick = longClickCellInfo.cell;
            resetAddInfo();
        }

		/*cfdroid add */     
		//在此处进行判断是否在hotseat进行长按   
        boolean isHotseatbutton = false;
        if (longClickCellInfo!=null) {
            isHotseatbutton = longClickCellInfo.container == -100 ? false : true;   //每一个Icon都有一个container的属性
			//hostSeat：是-101  其他的是-100 
        }
		android.util.Log.i("lcf_launcher", "Launcher isHotseatbutton : " + isHotseatbutton);
        if (isHotseatbutton) {
            return false;
        }
        /*cfdroid end*/	

        final boolean inHotseat = isHotseatLayout(v);
        
		//...
    }

* 3.2 hotseat不能拖动成文件夹

hotseat虽然不能拖动了，但是可以把wordspace里的拖动到hotseat生成文件夹，因此如果不想生成文件夹按如下修改：

	packages\apps\Launcher3\src\com\android\launcher3\Workspace.java	

	需要修改两点，分别对应桌面抽屉图标移动到hotseat和workspace图标移动到hotseat

	private void manageFolderFeedback(CellLayout targetLayout,
            int[] targetCell, float distance, DragObject dragObject) {
        if (distance > mMaxDistanceForFolderCreation) return;

        final View dragOverView = mDragTargetLayout.getChildAt(mTargetCell[0], mTargetCell[1]);
        ItemInfo info = (ItemInfo) dragObject.dragInfo;
        boolean userFolderPending = willCreateUserFolder(info, dragOverView, false) 
		//cfdroid add
		+		&& !mLauncher.isHotseatLayout(mDragTargetLayout); //这个是判断目标layout是否为hotseat
		//cfdroid end
		//这里要确保userFolderPending为false,这里走的是桌面抽屉图标移动的流程

        if (mDragMode == DRAG_MODE_NONE && userFolderPending &&
                !mFolderCreationAlarm.alarmPending()) {
		//...
	}

	第二点是针对workspace的图标拖动到hotseat

    boolean willCreateUserFolder(ItemInfo info, CellLayout target, int[] targetCell,
            float distance, boolean considerTimeout) {
        if (distance > mMaxDistanceForFolderCreation) return false;
        View dropOverView = target.getChildAt(targetCell[0], targetCell[1]);
		//cfdroid begin
		+if (mLauncher.isHotseatLayout(target)) {
		+	return false;
		+}
		//cfdroid end
        return willCreateUserFolder(info, dropOverView, considerTimeout);
    }


	需要注意的是看网上有改动createUserFolderIfNecessary这个判断container是否为-101的，亲测对于桌面抽屉的
	图标移动没有效果，而且移动过程中还会有folder的图标生成。
	

## 4. Launcher3 长按显示删除，卸载，应用信息按钮操作

![launcher_welcome_page](http://o8r7cqsy6.bkt.clouddn.com/launcher_qsb_button.png)

如图所示：

* 4.1 三个按钮对应的java类分别如下：
	
这三个按钮都继承自`packages\apps\Launcher3\src\com\android\launcher3\ButtonDropTarget.java`

**Remove:** 

	packages\apps\Launcher3\src\com\android\launcher3\DeleteDropTarget.java
	
	//这个方法是表示哪些类型支持Remove
	public static boolean supportsDrop(Object info) {
        return (info instanceof ShortcutInfo) 
                || (info instanceof LauncherAppWidgetInfo)
                || (info instanceof FolderInfo);
    }

	ShortcutInfo：代表Workspace的快捷图标
	LauncherAppWidgetInfo: 代表Workspace中的桌面小部件
	FolderInfo: 代表文件夹
	
	
**UnInstall:**
	
	packages\apps\Launcher3\src\com\android\launcher3\UninstallDropTarget.java

	//这个方法是表示哪些类型支持卸载
    @TargetApi(Build.VERSION_CODES.JELLY_BEAN_MR2)
    public static boolean supportsDrop(Context context, Object info) {
        if (Utilities.ATLEAST_JB_MR2) {
            UserManager userManager = (UserManager) context.getSystemService(Context.USER_SERVICE);
            Bundle restrictions = userManager.getUserRestrictions();
            if (restrictions.getBoolean(UserManager.DISALLOW_APPS_CONTROL, false)
                    || restrictions.getBoolean(UserManager.DISALLOW_UNINSTALL_APPS, false)) {
                return false;
            }
        }

        Pair<ComponentName, Integer> componentInfo = getAppInfoFlags(info);
        return componentInfo != null && (componentInfo.second & AppInfo.DOWNLOADED_FLAG) != 0;
    }
	
	这里的参数info其实就是上面的三种外加桌面抽屉里的图标即AppInfo.
	
**App Info:**

	packages\apps\Launcher3\src\com\android\launcher3\InfoDropTarget.java

	//这个方法表示哪些类型支持查看应用信息
    public static boolean supportsDrop(Context context, Object info) {
        return info instanceof AppInfo || info instanceof PendingAddItemInfo;
    }
	
	PendingAddItemInfo： 看源码介绍是可移动的目标从workspace往别的container移动时用来传递componentName的中继数据。
	
