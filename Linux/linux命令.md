
# Linux命令总结

1.用zip打包，但是不想把绝对路径打包进去

	//将file目录下的文件打包至file.zip但是zip文件中不会包含XXX这个目录
	zip -rqj "./XXX/file.zip" "./XXX/file/" 