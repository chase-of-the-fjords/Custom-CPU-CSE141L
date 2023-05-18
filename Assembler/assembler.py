import re

def get_reg_number(register, line):
    match register:
        case "0":
            return "000"
        case "1":
            return "001"
        case "2":
            return "010"
        case "3":
            return "011"
        case "4":
            return "100"
        case "5":
            return "101"
        case "6":
            return "110"
        case "7":
            return "111"
        case other:
            raise SyntaxError('Operation has invalid register value on line ' + line)
    return ""

lines = []
line_numbers = []
branches = []
branch_lookups = []

machine_code = []

line_num = 0

input_file = "Assembler/program1.txt"
output_file = "Assembler/mach_code_p1.txt"

with open(input_file) as file:
    for line in file:
        line_num += 1
        line = line.rstrip()
        # Remove empty lines
        if (len(line.split()) > 0):
            # Remove comments
            if (line.split()[0] != "//" and line.split()[0] != "#"):
                lines.append(line.rstrip())
                line_numbers.append(line_num)
    
    line_num = 0

    for index, line in enumerate(lines):
        split = line.split()
        branch = ""
        code = ""
        
        # branches
        if (split[0][len(split[0]) - 1] == ":"):
            branch = split[0][0:(len(split[0]) - 1)]
            branches.append((branch, line_num))
            split = split[1:]

        # setbranch branchname XXXXX
        if (split[0].casefold() == "setbranch".casefold()):
            if len(split) < 3:
                raise SyntaxError('Operation is incomplete on line ' + str(line_numbers[index]))
            if re.search('^[01][01][01][01][01]$', split[2]) is None:
                raise SyntaxError('Operation has invalid lookup table value on line ' + str(line_numbers[index]))
            branch_lookups.append((split[1], split[2]))

        # rxor R#
        if (split[0].casefold() == "rxor".casefold()):
            # Checks for syntax errors
            if len(split) < 2:
                raise SyntaxError('Operation is incomplete on line ' + str(line_numbers[index]))
            if re.search('^[Rr][01234567]$', split[1]) is None:
                raise SyntaxError('Operation has invalid register value on line ' + str(line_numbers[index]))
            
            # Writes the machine code line
            code += "000" # Command value
            code += get_reg_number(split[1][1], line_numbers[index]) # Register value
            code += "111" # 000_000_000 corresponds to done flag

            line_num += 1

        # shift R# XXX
        if (split[0].casefold() == "shift".casefold()):
            # Checks for syntax errors
            if len(split) < 3:
                raise SyntaxError('Operation is incomplete on line ' + str(line_numbers[index]))
            if re.search('^[Rr][01234567],{0,1}$', split[1]) is None:
                raise SyntaxError('Operation has invalid register value on line ' + str(line_numbers[index]))
            if re.search('^[01][01][01]$', split[2]) is None:
                raise SyntaxError('Operation has invalid type value on line ' + str(line_numbers[index]))

            # Writes the machine code line
            code = "001" # Command value
            code += get_reg_number(split[1][1], line_numbers[index]) # Register value
            code += split[2][0:3]

            line_num += 1

        # lshift0 R#
        if (split[0].casefold() == "lshift0".casefold()):
            # Checks for syntax errors
            if len(split) < 2:
                raise SyntaxError('Operation is incomplete on line ' + str(line_numbers[index]))
            if re.search('^[Rr][01234567]$', split[1]) is None:
                raise SyntaxError('Operation has invalid register value on line ' + str(line_numbers[index]))

            # Writes the machine code line
            code = "001" # Command value
            code += get_reg_number(split[1][1], line_numbers[index]) # Register value
            code += "000"

            line_num += 1
        
        # lshift1 R#
        if (split[0].casefold() == "lshift1".casefold()):
            # Checks for syntax errors
            if len(split) < 2:
                raise SyntaxError('Operation is incomplete on line ' + str(line_numbers[index]))
            if re.search('^[Rr][01234567]$', split[1]) is None:
                raise SyntaxError('Operation has invalid register value on line ' + str(line_numbers[index]))

            # Writes the machine code line
            code = "001" # Command value
            code += get_reg_number(split[1][1], line_numbers[index]) # Register value
            code += "001"

            line_num += 1

        # rshift0 R#
        if (split[0].casefold() == "rshift0".casefold()):
            # Checks for syntax errors
            if len(split) < 2:
                raise SyntaxError('Operation is incomplete on line ' + str(line_numbers[index]))
            if re.search('^[Rr][01234567]$', split[1]) is None:
                raise SyntaxError('Operation has invalid register value on line ' + str(line_numbers[index]))

            # Writes the machine code line
            code = "001" # Command value
            code += get_reg_number(split[1][1], line_numbers[index]) # Register value
            code += "010"

            line_num += 1
        
        # rshift1 R#
        if (split[0].casefold() == "rshift1".casefold()):
            # Checks for syntax errors
            if len(split) < 2:
                raise SyntaxError('Operation is incomplete on line ' + str(line_numbers[index]))
            if re.search('^[Rr][01234567]$', split[1]) is None:
                raise SyntaxError('Operation has invalid register value on line ' + str(line_numbers[index]))

            # Writes the machine code line
            code = "001" # Command value
            code += get_reg_number(split[1][1], line_numbers[index]) # Register value
            code += "011"

            line_num += 1
        
        # lshiftc R#
        if (split[0].casefold() == "lshiftc".casefold()):
            # Checks for syntax errors
            if len(split) < 2:
                raise SyntaxError('Operation is incomplete on line ' + str(line_numbers[index]))
            if re.search('^[Rr][01234567]$', split[1]) is None:
                raise SyntaxError('Operation has invalid register value on line ' + str(line_numbers[index]))

            # Writes the machine code line
            code = "001" # Command value
            code += get_reg_number(split[1][1], line_numbers[index]) # Register value
            code += "100"

            line_num += 1
        
        # rshiftc R#
        if (split[0].casefold() == "rshiftc".casefold()):
            # Checks for syntax errors
            if len(split) < 2:
                raise SyntaxError('Operation is incomplete on line ' + str(line_numbers[index]))
            if re.search('^[Rr][01234567]$', split[1]) is None:
                raise SyntaxError('Operation has invalid register value on line ' + str(line_numbers[index]))

            # Writes the machine code line
            code = "001" # Command value
            code += get_reg_number(split[1][1], line_numbers[index]) # Register value
            code += "101"

            line_num += 1

        # decrement R#
        if (split[0].casefold() == "decrement".casefold()):
            # Checks for syntax errors
            if len(split) < 2:
                raise SyntaxError('Operation is incomplete on line ' + str(line_numbers[index]))
            if re.search('^[Rr][01234567]$', split[1]) is None:
                raise SyntaxError('Operation has invalid register value on line ' + str(line_numbers[index]))

            # Writes the machine code line
            code = "001" # Command value
            code += get_reg_number(split[1][1], line_numbers[index]) # Register value
            code += "110"

            line_num += 1
        
        # increment R#
        if (split[0].casefold() == "increment".casefold()):
            # Checks for syntax errors
            if len(split) < 2:
                raise SyntaxError('Operation is incomplete on line ' + str(line_numbers[index]))
            if re.search('^[Rr][01234567]$', split[1]) is None:
                raise SyntaxError('Operation has invalid register value on line ' + str(line_numbers[index]))

            # Writes the machine code line
            code = "001" # Command value
            code += get_reg_number(split[1][1], line_numbers[index]) # Register value
            code += "111"

            line_num += 1

        # mem R# XX
        if (split[0].casefold() == "mem".casefold()):
            # Checks for syntax errors
            if len(split) < 3:
                raise SyntaxError('Operation is incomplete on line ' + str(line_numbers[index]))
            if re.search('^[Rr][01234567],{0,1}$', split[1]) is None:
                raise SyntaxError('Operation has invalid register value on line ' + str(line_numbers[index]))
            if re.search('^[01][01]$', split[2]) is None:
                raise SyntaxError('Operation has invalid type value on line ' + str(line_numbers[index]))

            # Writes the machine code line
            code = "010" # Command value
            code += get_reg_number(split[1][1], line_numbers[index]) # Register value
            code += "0"
            code += split[2][0:2]

            line_num += 1
        
        # store R#
        if (split[0].casefold() == "store".casefold()):
            # Checks for syntax errors
            if len(split) < 2:
                raise SyntaxError('Operation is incomplete on line ' + str(line_numbers[index]))
            if re.search('^[Rr][01234567]$', split[1]) is None:
                raise SyntaxError('Operation has invalid register value on line ' + str(line_numbers[index]))

            # Writes the machine code line
            code += "010" # Command value
            code += get_reg_number(split[1][1], line_numbers[index]) # Register value
            code += "001"

            line_num += 1

        # load R#
        if (split[0].casefold() == "load".casefold()):
            # Checks for syntax errors
            if len(split) < 2:
                raise SyntaxError('Operation is incomplete on line ' + str(line_numbers[index]))
            if re.search('^[Rr][01234567]$', split[1]) is None:
                raise SyntaxError('Operation has invalid register value on line ' + str(line_numbers[index]))

            # Writes the machine code line
            code += "010" # Command value
            code += get_reg_number(split[1][1], line_numbers[index]) # Register value
            code += "000"

            line_num += 1

        # move R# R#
        if (split[0].casefold() == "move".casefold()):
            # Checks for syntax errors
            if len(split) < 3:
                raise SyntaxError('Operation is incomplete on line ' + str(line_numbers[index]))
            if re.search('^[Rr][01234567],{0,1}$', split[1]) is None:
                raise SyntaxError('Operation has invalid register value on line ' + str(line_numbers[index]))
            if re.search('^[Rr][01234567]$', split[2]) is None:
                raise SyntaxError('Operation has invalid register value on line ' + str(line_numbers[index]))

            if (get_reg_number(split[1][1], line_numbers[index]) == '000'):
                code += "010" # Command value
                code += get_reg_number(split[2][1], line_numbers[index]) # Register value
                code += "011"
                line_num += 1
            elif (get_reg_number(split[2][1], line_numbers[index]) == '000'):
                code += "010" # Command value
                code += get_reg_number(split[1][1], line_numbers[index]) # Register value
                code += "010"
                line_num += 1
            else:
                code += "010" # Command value
                code += get_reg_number(split[1][1], line_numbers[index]) # Register value
                code += "010\n"
                code += "010" # Command value
                code += get_reg_number(split[2][1], line_numbers[index]) # Register value
                code += "011"
                line_num += 2
        
        # halfset XXXX
        if (split[0].casefold() == "halfset".casefold()):
            # Checks for syntax errors
            if len(split) < 2:
                raise SyntaxError('Operation is incomplete on line ' + str(line_numbers[index]))
            if re.search('^[01][01][01][01]$', split[1]) is None:
                raise SyntaxError('Operation has invalid immediate value on line ' + str(line_numbers[index]))

            # Writes the machine code line
            code += "100" # Command value
            code += "00"  # Gap
            code += split[1][0:4]

            line_num += 1
        
        # set XXXXXXXX
        if (split[0].casefold() == "set".casefold()):
            # Checks for syntax errors
            if len(split) < 2:
                raise SyntaxError('Operation is incomplete on line ' + str(line_numbers[index]))
            if re.search('^[01][01][01][01][01][01][01][01]$', split[1]) is None:
                raise SyntaxError('Operation has invalid immediate value on line ' + str(line_numbers[index]))

            # Writes the machine code line
            code += "100" # Command value
            code += "00"  # Gap
            code += split[1][0:4]
            code += '\n'
            code += "100" # Command value
            code += "00"  # Gap
            code += split[1][4:8]

            line_num += 2
        
        # and R# R#
        if (split[0].casefold() == "and".casefold()):
            # Checks for syntax errors
            if len(split) < 3:
                raise SyntaxError('Operation is incomplete on line ' + str(line_numbers[index]))
            if re.search('^[Rr][01234567],{0,1}$', split[1]) is None:
                raise SyntaxError('Operation has invalid register value on line ' + str(line_numbers[index]))
            if re.search('^[Rr][01234567]$', split[2]) is None:
                raise SyntaxError('Operation has invalid register value on line ' + str(line_numbers[index]))

            # Writes the machine code line
            code += "101" # Command value
            code += get_reg_number(split[1][1], line_numbers[index]) # Register value
            code += get_reg_number(split[2][1], line_numbers[index]) # Register value

            line_num += 1

        # bneq R# R# branch
        if (split[0].casefold() == "bneq".casefold()):
            # Checks for syntax errors
            if len(split) < 4:
                raise SyntaxError('Operation is incomplete on line ' + str(line_numbers[index]))
            if re.search('^[Rr][01234567],{0,1}$', split[1]) is None:
                raise SyntaxError('Operation has invalid register value on line ' + str(line_numbers[index]))
            if re.search('^[Rr][01234567],{0,1}$', split[2]) is None:
                raise SyntaxError('Operation has invalid register value on line ' + str(line_numbers[index]))

            # Gets the code for the branch
            branch_lookup_code = ""
            for b in branch_lookups:
                if b[0] == split[3]:
                    branch_lookup_code = b[1]

            code += "10000000" + branch_lookup_code[0] + '\n'
            code += "10000" + branch_lookup_code[1:5] + '\n'

            # Writes the machine code line
            code += "011" # Command value
            code += get_reg_number(split[1][1], line_numbers[index]) # Register value
            code += get_reg_number(split[2][1], line_numbers[index]) # Register value

            line_num += 3
        
        # blt R# R# branch
        if (split[0].casefold() == "blt".casefold()):
            # Checks for syntax errors
            if len(split) < 4:
                raise SyntaxError('Operation is incomplete on line ' + str(line_numbers[index]))
            if re.search('^[Rr][01234567],{0,1}$', split[1]) is None:
                raise SyntaxError('Operation has invalid register value on line ' + str(line_numbers[index]))
            if re.search('^[Rr][01234567],{0,1}$', split[2]) is None:
                raise SyntaxError('Operation has invalid register value on line ' + str(line_numbers[index]))

            # Gets the code for the branch
            branch_lookup_code = ""
            for b in branch_lookups:
                if b[0] == split[3]:
                    branch_lookup_code = b[1]

            code += "10000000" + branch_lookup_code[0] + '\n'
            code += "10000" + branch_lookup_code[1:5] + '\n'

            # Writes the machine code line
            code += "110" # Command value
            code += get_reg_number(split[1][1], line_numbers[index]) # Register value
            code += get_reg_number(split[2][1], line_numbers[index]) # Register value

            line_num += 3

        # done
        if (split[0].casefold() == "done".casefold()):
            # Adds the done flag code
            code += "000000000"

            line_num += 1

        print(line)
        if (code != ""):
            print(code)
            machine_code.append(code)

f = open(output_file, "w")

for index, line in enumerate(machine_code):
    if (index != 0): f.write('\n')
    f.write(line)
f.close()

print("\nBranch locations (Starts with line 0):")

for b in branch_lookups:
    for b2 in branches:
        if (b2[0] == b[0]):
            print(b[0] + " (Code " + b[1] + "): Line " + str(b2[1]))