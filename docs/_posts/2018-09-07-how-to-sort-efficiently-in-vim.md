---
layout: post
title: "如何在 Vim 内进行高效的排序"
categories: 学习笔记
tags: vim
author: 王世东
---

* content
{:toc}


Vim 分别提供了排序函数 `sort()`、`uniq()` 和排序命令 `:sort`。机遇这两种方式，可以在 Vim 内对文本进行高效的排序。
下面分两部分详细说明下这两种方式的使用方法。

#### 排序命令

`:sort` 命令的用法格式如下：

```
:[range]sor[t][!] [b][f][i][n][o][r][u][x] [/{pattern}/]
```

`[range]` 值得是一个范围，`:sort` 命令会基于这个范围进行排序，当未制定范围时，会对整个文档进行排序。关于 `[range]` 的常用方法有下面几种：

我们看到 `sor[t]` 最后一个字母 `t` 被方括号包围，表示该字母可以省略，即更简单地执行 `:sor` 命令。
在 `:sort`命令紧接其后的感叹号 `!` 表示是否进行反向排序，不带感叹号则是正向排序，带上则反之。
在 `:sort` 命令紧接其后的第一个参数为可选参数，包括 `b`, `f`, `i`, `n`, `o`, `r`, `u`, `x`。首先，需要了解选项 `n` `f` `x` `o` `b` 之间是互斥的，也就是说不可以同时使用这些选项，换句话说。前面的这个五个选项可以和 `i` `r` `u` 这三项组合使用。下面分别说下这些参数的意义：

- 带 `n` 则排序基于每行的第一个十进制数 (在 `{pattern}` 匹配之后或之内)。数值包含前导的 '-'。
- 带 `f` 则排序基于每行的第一个浮点数。浮点值相当于在文本( `{pattern}` 匹配的之后或之内) 上调用 str2float() 函数的结果。仅当 Vim 编译时加入浮点数支持时该标志位才有效。
- 带 `x` 则排序基于每行的第一个十六进制数 (在 `{pattern}` 匹配之后或之内)。忽略该数值前的 "0x" 或 "0X"。但包含前导的 '-'。
- 带 `o` 则排序基于每行的第一个八进制数 (在 `{pattern}` 匹配之后或之内)。
- 带 `b` 则排序基于每行的第一个二进制数 (在 `{pattern}` 匹配之后或之内)。
- 带 `u` (u 代表 unique 唯一) 则只保留完全相同的行的第一行 (如果同时带 `i`，忽略大小写的区别)。没有这个标志位，完全相同的行的序列会按照它们原来的顺序被保留下来。
  注意： 行首和行尾的的空白差异会影响唯一性的判定。

#### 排序函数

Vim 提供两个排序相关的函数 `sort()` 和 `uniq()`，`sort()` 这个函数的用法如下：

```
sort({list} [, {func} [, {dict}]])
```

给定一个 List 经过排序后，返回一个结果，同样也是 List。`sort()` 这一函数第二个参数可以接受如下几种情况：

- `1` 或者 `i`: 表示忽略大小写。
- `n`：按照数值排序，即使用 `strtod()` 解析 List 内的元素，字符串、列表、字典和函数引用均视作 0。
- `f`：按照浮点数值来排序，要求给定的 List 每一个选项都是浮点数。
- 一个 `Funcref` 变量。这个变量表示的是一个函数，则调用该函数来比较项目，该函数会使用两个项目作为参数，根据返回值确定两个项目关系。 0 表示相等，1 或者更高，表示第一个排在第二个之后，-1 或更小代表第一个排在第二个之前。