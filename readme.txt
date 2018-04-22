1.下载远程仓库：git clone https://github.com/nzj1981/linushell.git
2.查看仓库状态：git status
3.全局配置：git config --global user.email "nzj1981@126.com"
git config --global user.name "nzj1981"
4.增加文件：
git add readme.txt
5.提交文件要加注释：
git commit -m "new add readme-201804221150"
6.比较提交过文件的内容修改
git diff readme.txt
7.通过日志查看指定文件或所有文件的变化
git log --查看所有
git log readmet.txt --单查看readme.txt变化
8.HEAD指向的版本就是当前版本，因此，Git允许我们在版本的历史之间穿梭，使用命令：
git reset --hard commit_id
git reset --hard HEAD^
9.重返未来，用git reflog 查看命令历史，以便确定要回到未来的哪个版本
git reflog commit_id
10.查看工作区和版本库里面最新版本的区别：
git diff HEAD -- readme.txt
11.提交github
git push
Username for 'https://github.com': nzj1981
Password for 'https://nzj1981@github.com': 
12.在工作区的修改全部撤销
git checkout -- readme.txt
13.版本库里删除
git rm
git commit
14.分支管理
Git鼓励大量使用分支：

查看分支：git branch

创建分支：git branch <name>

切换分支：git checkout <name>

创建+切换分支：git checkout -b <name>

合并某分支到当前分支：git merge <name>

删除分支：git branch -d <name>

令牌：jW9oBqsJ2adVnHKibRCB
15.码云：https://gitee.com/autumner/linuxshell

