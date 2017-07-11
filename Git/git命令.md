
**【git 想要查看当前.git的地址】**

	git remote -v
	origin  git@192.168.10.188:MOCORDROID7.0_Trunk_K310_17A_W17.03.2_P1_IDH.git (fetch)
	origin  git@192.168.10.188:MOCORDROID7.0_Trunk_K310_17A_W17.03.2_P1_IDH.git (push)


**【git 回退远端仓库的操作】**

一种是revert，一种是git push -f

revert已一个新的commit-id来回退某条具体的commit

如果当前分支已经push到远端，但是由于某些原因要同时回退本地和远端仓库的某些提交，想让远端仓库和当前的分支保持一致

要用比如：

	git push -f git@192.168.10.188:MOCORDROID7.0_Trunk_K310_17A_W17.03.2_P1_IDH.git master:master
	git push -f origin master 

**【Git怎么推送本地分支到远程新分支上面去？】**

	git push origin local_branch:remote_branch
	
	这个操作，local_branch必须为你本地存在的分支，remote_branch为远程分支，
	如果remote_branch不存在则会自动创建分支。
	
**【Git怎样删除远端分支】**

	git push origin :remote_branch，local_branch留空的话则是删除远程remote_branch分支。

**【git 删除本地分支】**

	git branch -D local_branch
