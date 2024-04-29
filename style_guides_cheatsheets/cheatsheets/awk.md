# awk Cheatsheets

## Summary

Awk and sed are 2 of those programs that I use often enough to be useful, but not often enough to remember the syntax.  This is a collection of the most common commands I use.

## Command structure

- Useful shebang in rare cases, `#!/bin/awk -f`

- Single quotes surround the awk programs on the command line so the shell will not interpret special characters.
- Variable FNR is number of records read.  Is reset at new file.
- Variable NR records total number of input records read.  Is not reset at new file.
- Records are by default split on newline character.  Variable is RS.
- AWK never modifies a file
- `$n` represents the nth field in the record.  `$0` gives the whole record.  `$NF` represents the final nth record.
- `$1 = $1` will force records to be recalculated
- `OFS = "";` Output Field Separator
- `ORS = "";` Output Record Separator
- `OFMT = ""` contains the format specification default for sprintf().  This is %.6g by default.
- Use `printf` rather than print when you need more specific control over output.
- Format specifiers start with `%` and end with a format control letter telling `printf` how to output one item.
    - `%c = number` as character
    - `$d` or `%i` print a decimal integer
    - `%e` or `%E` exponential notation
    - `%f` floating point
    - `%g` or `%G` exponential or floating point whatever uses fewer characters
    - `%o` unsigned octal
    - `%s` string
    - `%x` or `%X` hex
    - `%%` prints a `%`
    - Optional modifiers between the `%` and format control letter control how much to print.
- Minus (-) cause left justify as in `{printf "%-10s %s\n", $1}`
- A number before the format control letter defines the minimum width as in `{printf "%44s", "Foo"}`
- A period followed by an integer constant specifies the precision. `%d %i %o %u %x %X` means minimum number of digits.
- Redirection of output to files works.  `$1 > var1.file`
- Redirection of output to pipes work.   `$1 | command`
- `~` operator is used for regular expressions in comparisons
- Boolean operators: `&& AND, || OR, ! NOT,`
- Patterns in awk control the execution of rules

```shell
set +H # to disable c interpretation and keep ! from executing
```

```shell
cat file.txt | awk '{print;}'

cat file.txt | awk 'BEGIN {print "Start"}
					{print;}
					END {print "End"}'

cat file.txt | awk 'BEGIN { x=4;
					print "Instance\tGrade1\tGrade2\tGrade3";}
					{print $1,"\t\t",$2,"\t",$3"\t",$NF,x;}
					END {print "Complete"}'

cat file.txt | awk 'BEGIN {x=5;}
					{print $x}'

cat file.txt | awk '{print 7+5;}'

awk 'BEGIN {x=4;}
	{print $x+5;}' file.txt

awk 'BEGIN { print "Don\47t Panic!" }'

awk '{ print ;}' # This is echo

echo 'BEGIN { print "Don\47t Panic!" ;}' > test_awk.awk
awk -f test_awk.awk

awk 'BEGIN { print "Here is a single quote <'"'"'>" }'
awk "BEGIN { print \"Here is a single quote <'>\" }"
awk 'BEGIN { print "Here is a single quote <\47>" }'
awk 'BEGIN { print "Here is a double quote <\42>" }'


# Search for the A user
cat file.txt | awk 'BEGIN {print "Search for the A user details" ;}
					/A/ {print $1, $2, $3, $4 ;}
					END {print "Completed" ;}'

awk 'BEGIN {print "Print each line where the variable 3 has a length greater than 30" ;}
	length($3) > 30' maillist.txt

awk 'BEGIN {print "Print the first variable from each line where the variable 3 has a length greater than 30" ;}
	length($3) > 30 {print $1}' maillist.txt

awk 'BEGIN { print "Example of if/then by printing the longest line" ;}
	{if (length($0) > max) max = length($0)}
	END { print max ;}' maillist.txt

awk 'BEGIN {print "Print each line with at least 1 field";}
	NF > 0
	END {print "Lines Printed"}' maillist.txt

awk 'BEGIN {print "Random Number Basics"; for (i = 1; i <= 7; i++)
			print int(101 * rand())}'

ls -l | awk 'BEGIN {print "Calculate KB of Folder"}
			{x += $5}
			END {print "Total KB ", x / 1024 }'

awk 'BEGIN {print "Multiple Rules"}
	/Amelia/ {print $1, $3}
	/Julie/ {print $1, $3}
	END {print "This prints only the name and the email address"}' maillist.txt

ls -l | awk 'BEGIN {print "Add up file sizes from August"}
			$6 == "Aug" {sum += $5}
			$6 == "Aug" {print $5}
			END { print "Sum: ", sum }'

awk -F ',' 'BEGIN {print "Awk using commas as Field separators"}
			{print $2, $4}' maillist.csv


awk 'BEGIN {print "Multiple regex match"}
	(/50/ || /88/) {print $0}' file.txt

awk 'BEGIN {print "Multiple regex match"}
	(/75/ && /80/) {print $0}' file.txt

awk 'BEGIN {print "Multiple regex match"}
	(/7[0-9]{1}/ && /8[0-9]+/) {print $0}' file.txt

awk 'BEGIN { print "Change the Record Separator.  (newline by default)"
			RS = "u"}
			{print $0}' maillist.txt

awk 'BEGIN {print "(Figure out how to to do this) Using math on the NR variable to get the second to last record"
	n = NR-1}
	{print $n}' maillist.txt

awk 'BEGIN {print "Modify the record (Never the file).  Notice the first entry is +10 of the second"}
			{nboxes = $3
			$3 = $3 - 10
			print $1, nboxes, $3}' inventory-shipped

awk 'BEGIN {print "Create new fields"}
	{$6 = ($5 + $4 + $3 + $2)
	print $1, $2, $3, $4, $5, $6}' inventory-shipped

awk 'BEGIN {print "Force Field Separator to Change.  Use this is separator is not standard whitespace (spaces, TABs, and newlines)"
			FS = ","}
			{print $2}' maillist.csv

awk 'BEGIN {print "You can use regex to separate records!  The regex is greedy"
			FS = "555-[0-9]"}
			{print $2, ":", $1}' maillist.csv

awk 'BEGIN {print "Change the output separator variables to control output formatting"
			OFS = ","
			ORS = " :: "}
			{print $1, $2}' maillist.txt

awk 'BEGIN {print "Change the default sprintf() format variable and print records on separate lines"
			OFMT = "%.0f"
			OFS = "\n"
			print 17.23, 17.54}'

awk 'BEGIN {print "Simple printf() usage"}
	{printf $1, $2, $3}' maillist.txt

awk 'BEGIN {print "printf Formatting examples"}
	{printf "%s %s %s\n", "Dont", "panic", $1}' maillist.txt

awk 'BEGIN {print "Numbers formatting"}
	{printf "%2d " $1, $2, $3}' numbers.txt

awk 'BEGIN {print "Edit string length"}
	{printf "%.4s\n", $1}' maillist.txt

awk 'BEGIN {print "Dealing with phone numbers, Aligns left and forces $1 to be at least 10 characters in length with a header."
			print "----        ------"}
			{printf "%-10s %s\n", $1, $2}' maillist.txt

awk 'BEGIN {print "Format can be stored in a variable.  This makes it easier to adjust the amount of space (22 instead of 10)"
			format = "%-22s %s\n"
			printf format, "Name", "Number"
			printf format, "----", "------"}
			{printf format, $1, $2}' maillist.txt

awk 'BEGIN {print "Redirect output"}
		{print $2 > "phone-list.txt"
		print $1 > "name-list.txt"}' maillist.txt

awk 'BEGIN {print "Redirect via pipes.  Note that the command is in double quotes."}
			{print $1 | "sort"}' maillist.txt

awk 'BEGIN {print "~ Regular expressions"}
			{if ($0 ~ /Broderick/ || $0 ~ /Sam/)
				print $2, "found"}' maillist.txt

awk 'BEGIN {print "Stanard Arithmetic Operators"}
			{sum = $2 + $3 + $4
			avg = sum / 3
			mult = $2 * $3 * $4
			div = $4 / $2
			print $1, mult, div, avg}' numbers.txt

awk 'BEGIN {print "Expressions as patterns.  This fails as there is no one with the exact name of li ($1 == li)"}
			$1 == "li" {print $2}' maillist.txt

awk 'BEGIN {print "Expressions as patterns.  This succeeds because there is a person with li in their name ($1 ~ /li/)"}
			$1 ~ /li/ {print $2}' maillist.txt

awk 'BEGIN {print "Expressions as patterns.  li OR Br in the name record only ($1)"}
			$1 ~ /li/ || $1 ~ /Br/ {print $2}' maillist.txt

awk 'BEGIN {print "Using booleans in regex patterns.  edu AND li"}
			/edu/ && /li/' maillist.txt

awk 'BEGIN {print "Using booleans in regex patterns.  edu OR li"}
			/edu/ || /li/' maillist.txt

```

## Data Files

### inventory-shipped

```csv
Jan 3 25 15 115
Feb 5 32 24 226
Mar 5 24 34 228
```

### maillist.csv

```csv
Amelia,555-5553,amelia.zodiacusque@gmail.com,F
Broderick,555-0542,broderick.aliquotiens@yahoo.com,R
Julie,555-6699,julie.perscrutabor@skeeve.com,F
Samuel,555-3430,samuel.lanceolis@shu.edu,A

### maillist.txt

```tsv
Amelia       555-5553     amelia.zodiacusque@gmail.com    F
Broderick    555-0542     broderick.aliquotiens@yahoo.com R
Julie        555-6699     julie.perscrutabor@skeeve.com   F
Samuel       555-3430     samuel.lanceolis@shu.edu        A
```

### file.txt

```tsv
A 25 27 50
B 35 37 75
C 75 78 80
D 99 88 76
```

### numbers.txt

```tsv
354 354.54 9943.994201 .287169 .4451
995 926.63 1425.545421 .364523 .4735
```
