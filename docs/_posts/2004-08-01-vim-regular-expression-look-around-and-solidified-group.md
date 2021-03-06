---
layout: post
title: "Vim 环视和固化分组"
categories: 学习笔记
tags: vim
author: 王世东
---

* content
{:toc}

| vim         | Perl   | 意义         |
| ----------- | ------ | ------------ |
| `\@=`       | `(?=`  | 顺序环视     |
| `\@!`       | `(?!`  | 顺序否定环视 |
| `\@<=`      | `(?<=` | 逆序环视     |
| `\@<!`      | `(?<!` | 逆序否定环视 |
| `\@>`       | `(?>`  | 固化分组     |
| `\%(atom\)` | `(?:`  | 非捕获型括号 |

和 perl 稍有不同的是，vim 中的环视和固化分组的模式的位置与 perl 不同。 例如，查找紧跟在 foo 之后的 bar，perl 将模式写在环视的括号内， 而 vim 将模式写在环视的元字符之前。
Perl 的写法

```
/(?<=foo)bar/
```

vim 的写法

```
/\(foo\)\@<=bar
```

**Vim 使用示例**

- 顺序环视
  查找后面是 sql 的 my： `/my\(sql\)\@=`
- 顺序否定环视
  查找后面不是 sql 的 my：`/my\(sql\)\@!`
- 逆序环视
  查找前面是 my 的 sql： `/\(my\)\@<=sql`
- 逆序否定环视
  查找前面不是 my 的 sql： `/\(my\)\@<!sql`
- 固化分组
- 非捕获型括号
  意思是，此分组不捕获，可以理解为不算在分组信息中

```
:%s/\%(my\)sql\(ok\)/\1
```

上面的命令会将 `mysqlok` 替换为 `ok` ，由于 `my` 为捕获在分组中，故组中 `\1` 为 `ok`。
