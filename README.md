# configfiles

## Autolinker syntax

### Linking individual files

If you are only linking a single file you should add a comment in the beginning of the file with the following syntax.

```
 linkto: \[path\]
 linkto[platform]: path
```

it is important to have a space between the comment symbol and the linkto syntax.


### Linking whole directories

If you have many config files in the same folder you can use a linkto file. This file is places in the parent directory, and is called linkto. This file has the same syntax as induvidual links.

### Mixing indiuvidual and directory links

If you have a directory with a main linkto file and one or more induvidual links you simply put induvidual links in those files, and autolinker.sh use these instead of the linkto file. 
