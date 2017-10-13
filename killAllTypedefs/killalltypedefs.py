#!/usr/bin/python3

# simple script to replace C++ lines like
# '  typedef SOMETHING BLABLA foo;'
# by the newer "using" keyword:
# '  using foo = SOMETHING BLABLA;'

# Usage: ./killalltypedefs FILENAME1 [FILENAME2 ...]

import fileinput

with fileinput.input(inplace=True) as f:
    for line in f:
        if (len(line.split())==0):
            print(line, end='')
            continue

        # TODO: Work-around for multi-line typedefs
        # for now, we're ignoring those
        if (line.strip()[-1] != ";"):
            print(line, end='')
            continue

        if (line.split()[0] == 'typedef'):
            # save intendation
            leading = line[:-len(line.lstrip())-1]
            # save the alias' name
            name = line.rstrip().rstrip(";").split()[-1]
            wordlist = [leading, "using", name, "="]
            # extend by what is going to be aliased
            wordlist.extend(line.strip().split()[1:-1])
            string = " ".join(wordlist)
            print(string+";")
        else:
            print(line, end='')

fileinput.close()

