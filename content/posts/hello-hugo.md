---
title: "Hello Hugo"
date: 2020-07-11T22:17:12+08:00
draft: false
categories: ['hugo']
---

## 新建文章

```
hugo new posts/my-first-post.md
```
或者直接在 `content/posts`目录手动创建`my-first-post.md`

## Start the Hugo server

```
hugo server -D
```
启动后可以本地预览


## Build static pages

```
hugo -D
```

## 自用主题

极简主义 [yinyang](https://github.com/joway/hugo-theme-yinyang/tree/a91daf5af446687010b969b902a8bf497918a18f)

## 构建脚本

deploy.sh
```
#!/bin/sh

set -e
printf "\033[0;32mDeploying updates to GitHub...\033[0m\n"
hugo -D 

msg="rebuilding site $(date)"
if [ -n "$*" ]; then
	msg="$*"
fi

# coderbuck.github.io
cd public
git add .
git commit -m "$msg"
git push origin master

# blog
git add .
git commit -m "$msg"
git push origin master
```

