# fork项目的步骤：本地分支同步远程分支

1、**fork项目到本地项目，clone到本地**

```
$  git clone https://github.com/yourname/project.git
```

2、**更新代码至本地，与源码保持一致：默认本地为origin，一般远程为upstream**

```
$ git remote add upstream https://github.com/sourcename/project.git
```

3、**查看本地分支和 远程分支对应名称是否正确：即orgin为本地fork的地址，upstream为远程的项目地址**

```
$  git remote -v
```

4、**拉取远程指定的分支dev到本地: 注意每次提交之前都要先进行拉取，防止代码冲突**

```
$  git pull upstream dev
```

5、**最好使用本地分支来对应远程分支，保持一致。项目分支多的话就不会乱。这里我创建了本地dev分支来对应远程dev分支。**

```
$  git checkout -b dev
```

6、**提交本地分支到指定分支：如果本地分支和远程分支只有一个那么只写一个就可以了。**

```
$  git push origin dev:dev 

$  git push origin dev
```

