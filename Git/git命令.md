
**【git 想要查看当前.git的地址】**

	git remote -v
	origin  git@192.168.10.188:MOCORDROID7.0_Trunk_K310_17A_W17.03.2_P1_IDH.git (fetch)
	origin  git@192.168.10.188:MOCORDROID7.0_Trunk_K310_17A_W17.03.2_P1_IDH.git (push)


**【git 回退远端仓库的操作】**

一种是revert，一种是git push -f

revert以一个新的commit-id来回退某条具体的commit

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

**【git 修改提交的message】**

* 1 如果这是你最近一次提交并且没有push到远程分支，可用以下命令直接修改：

<<<<<<< HEAD
	git commit --amend -m "your new message"
	
	然后执行

	git push origin master --force 或者 git push origin master -f

	当然这样有可能会丢失别的commit

	最好就是git pull origin master 然后再push

	

* 2 如果是修改历史记录里的message

		git rebase -i commit_id ## 只能修改commit_id 之前的log message
		git rebase -i --root  ## 修改第一次及之前的log message
		git rebase -i HEAD~2   ## 修改倒数第二次及之前的log message
		git rebase -i HEAD~1   ## 修改最后一次提交的log message
	
		pick 62252dd commit file_b
		pick b443d79 commit file_xxxx
		pick dcce1df commit file_d_xxx
	
		# Rebase dcce1df onto b88e1cb (3 command(s))
		#
		# Commands:
		# p, pick = use commit
		# r, reword = use commit, but edit the commit message
		# e, edit = use commit, but stop for amending
		# s, squash = use commit, but meld into previous commit
		# f, fixup = like "squash", but discard this commit's log message
		# x, exec = run command (the rest of the line) using shell
		# d, drop = remove commit
		#
		# These lines can be re-ordered; they are executed from top to bottom.
		#
		# If you remove a line here THAT COMMIT WILL BE LOST.
		#
		# However, if you remove everything, the rebase will be aborted.
		#
		# Note that empty commits are commented out

		修改message信息如下：
		
		commit file_xxxx_reword
		1
		保存后的git log 如下
		
		commit 9942bfeb2cf1415cfb44c83e5ddef13f0351a7b2
		Author: pengganyu <peng_gy@163.com>
		Date:   Tue Aug 29 09:14:10 2017 +0800
		
		    commit file_d_xxx
		
		commit b889d15f9d1b8ee8120c9166a7bbb1d8e84715b1
		Author: pengganyu <peng_gy@163.com>
		Date:   Tue Aug 29 09:14:00 2017 +0800
		
		    commit file_xxxx_reword
		
		commit eb0c217bfcc941c725df4411ee8d7159937c6b1b
		Author: pengganyu <peng_gy@163.com>
		Date:   Tue Aug 29 09:13:45 2017 +0800
		
		    commit file_b
		--------------------- 
		作者：peng_gy 
		来源：CSDN 
		原文：https://blog.csdn.net/yuyan1992/article/details/77673483 
		版权声明：本文为博主原创文章，转载请附上博文链接！

		另外nano编辑器保存方式是
		ctr+o,enter,ctr+x
=======
	git commit --amend -m "your new message"
>>>>>>> 86fafcf... git修改最近一次提交且没有push到远程分支
