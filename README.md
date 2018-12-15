# configfiles

## Autolinker

autolinker.sh is a script written in bash to automaticly create symbolic links for configuration files based on comments in the file, or a file in a parent directory. You can also define different configs based on platform/unit.

### Linking individual files

If you are only linking a single file you should add a comment in the beginning of the file with the following syntax.

```
 linkto: path
 linkto[platform]: path
```

it is important to have a space between the comment symbol and the linkto syntax.


### Linking whole directories

If you have many config files in the same folder you can use a linkto file. This file is places in the parent directory, and is called linkto. This file has the same syntax as induvidual links.

### Mixing indiuvidual and directory links

If you have a directory with a main linkto file and one or more induvidual links you simply put induvidual links in those files, and autolinker.sh use these instead of the linkto file. 

### Skip linking file, without removing `linkto`

In order to disable the linking of a file without removing the `linkto` path you can add a `nolink` comment in the file. Also here its important to have a space between the comment symbol and `nolink`
