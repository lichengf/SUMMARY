
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
	