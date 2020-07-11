---
title: "Publish Library to Jitpack"
date: 2020-07-11T22:33:05+08:00
draft: true
toc: false
images:
tags: 
  - untagged
---

jitpack 早有耳闻，但是因为之前都是把库发布到 jcenter，所以一直没有碰过 jitpack。最近也是因为发布到 jcenter 遇到了问题，然后才转了 jitpack。用了后就感觉很爽。

## jcenter 遇到了啥问题

一般来说发布的jcenter都会用这个插件 `com.novoda.bintray-release` 。自己新建项目([viewbinding-ktx](https://github.com/CoderBuck/viewbinding-ktx))gradle版本默认是6.0以上了，然后这个插件就 [bug](https://github.com/novoda/bintray-release/issues/298) 了，不支持gradle 6.0+ ，导致我发布不了。然后我又不想回退到5.0 ，就去试 jitpack 了。

## jitpack ！！！

我对 jitpack 最初的坏印象很简单，就是使用发布到 jitpack 的库，你必须在项目里手动把 jitpack 的仓库加进去:`maven { url 'https://jitpack.io' }` ,而jcenter 创建项目的时候自动就配置了，而且还是带别名的`jcenter()`。但是这不怪 jitpack ...


发布到 jitpack 的过程真的是超级简单

### 添加插件

#### android library

添加 android-maven 插件
```
// root
classpath 'com.github.dcendents:android-maven-gradle-plugin:2.1'

// module
apply plugin: 'com.github.dcendents.android-maven'

```
> 注意：android-maven 现在维护者不推荐使用了，因为现在 android 插件已经默认提供了 aar 工件的支持。 但是现在还是用 android-maven 更方便，但是 android-maven 相对来说要过时了...

#### java library

添加 maven 插件
```
apply plugin: 'maven'
```
> 注意：官方文档里显示，使用 `maven-publish`插件也是可以的，但是我自己测试至少 gradle 6.0 的项目不行，这个问题也有人提了 [issue](https://github.com/jitpack/jitpack.io/issues/3814)，是默认的 gradlew 脚本出了问题。jitpack官方还是建议使用 `maven` 插件。但是 gradle 官方是不推荐使用 maven插件了，而是推荐使用 maven-publish 插件... 所以说，不要管他们推荐啥，先保证能用再说

最基本的添加了上面的插件就ok，就能顺利发布了。而且发布的时候会默认也把 source.jar 一起发布，所以不需要单独指定 source.jar 工件。

### 发布

代码上传到github（gitlab、gitee也支持），然后在github release，比如release 一个 1.0.0 的版本，然后去 jitpack.io 发布就行了


## 一些"坑"

1. 项目名

比如：`implementation 'com.github.coderbuck:viewbinding-ktx:1.0.0` , viewbinding-ktx 是项目名，所以这种项目名最好是小写的形式

2. 单个项目多个module library

比如：https://github.com/CoderBuck/jitpack  这个项目里有两个 library，lib-aar 和 lib-jar。因为他们在同一个项目里，github release 的时候发布的是整体的版本。所以每次发布到 jitpack 的时候，他们两个都是同时发布的，版本号都是相同的，不能单独发布。而且依赖的名字也会有区别，

```
implementation 'com.github.coderbuck:jitpack:1.0.0  		// lib-aar + lib-jar
implementation 'com.github.coderbuckjitpack:lib-aar:1.0.0	// lib-aar
implementation 'com.github.coderbuckjitpack:lib-jar:1.0.0	// lib-jar
```
这就可能会导致一些问题，
1.想要不同版本怎么办？--再新建一个仓库吧
2.之前项目是一个 library，后面又新增了一个 library，这会导致依赖的名字变化，跟之前版本不符。--尽量不要这么做

3. 发布的东西不方便查看
你需要到 [build.log](https://jitpack.io/com/github/CoderBuck/viewbinding-ktx/1.0.0/build.log) 去查看都发布了什么，没有一个统一管理的地方。
比如：
```
Build artifacts:
com.github.CoderBuck:viewbinding-ktx:1.0.0

Files: 
com/github/CoderBuck/viewbinding-ktx/1.0.0
com/github/CoderBuck/viewbinding-ktx/1.0.0/build.log
com/github/CoderBuck/viewbinding-ktx/1.0.0/viewbinding-ktx-1.0.0-sources.jar
com/github/CoderBuck/viewbinding-ktx/1.0.0/viewbinding-ktx-1.0.0.aar
com/github/CoderBuck/viewbinding-ktx/1.0.0/viewbinding-ktx-1.0.0.pom
com/github/CoderBuck/viewbinding-ktx/1.0.0/viewbinding-ktx-1.0.0.pom.md5
com/github/CoderBuck/viewbinding-ktx/1.0.0/viewbinding-ktx-1.0.0.pom.sha1
```
这种是正常的，然后看看 pom 文件的依赖是否正确。


## 资料

重复的东西就不写了

[JitPack.io 基本使用法](https://juejin.im/post/5c2341cdf265da6134387300)

[使用JitPack发布Android开源库](https://www.gcssloop.com/course/PublishLibraryByJitPack)

[我的demo jitpack](https://github.com/CoderBuck/jitpack)

[simple-stack 是怎么用的](https://github.com/Zhuinden/simple-stack/blob/master/simple-stack/build.gradle.kts)
