# Sed Cheat Sheet

## Command structure

d = delete; p = print; -n suppresses output; s = substitute; -r (-E on mac) turns on Extended Regular Expressions; \1 to \n Capture groups;
multiple commands using '<command>; <command>' or -e 'command' -e 'command'
& means 'pattern found' and can be used as a variable.

- Standard replace

```bash
cat file.txt | sed 's/Shall/SHALL/'
```

- Standard replace only on lines 1 through 5

```bash
cat file.txt | sed '1,5s/But/BUT/'
```

- Replace using the pattern found &

```bash
cat file.txt | sed 's/But/(&)/'
```

- The & can be used multiple times

```bash
cat file.txt | sed 's/But/(&) (&)/'
```

- Using capture groups (Note that the parenthesis are escaped)

```bash
cat file.txt | sed 's/\(sum\) \(my\)/\2-----\1/'
```

- With Extended regular expressions you do not need to escape the parenthesis

```bash
cat file.txt | sed -E 's/(sum) (my)/\2-----\1/'
```
