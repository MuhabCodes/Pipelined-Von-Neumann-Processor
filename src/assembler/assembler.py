import re
import os
import string

file_names = [n.removesuffix(".asm")
              for n in os.listdir("./asm") if n.endswith(".asm")]
opcode = {'NOP': '00000',
          'HLT': '00001',
          'SETC': '00010',
          'RET': '00011',
          'RTI': '00100',
          'PUSH': '01000',
          'POP': '01001',
          'OUT': '01010',
          'IN': '01011',
          'CALL': '01100',
          'INT': '01101',
          'INC': '01110',
          'NOT': '01111',
          'MOV': '10000',
          'SWAP': '10001',
          'ADD': '10010',
          'SUB': '10011',
          'AND': '10100',
          'JZ': '11000',
          'JN': '11001',
          'JC': '11010',
          'JMP': '11011',
          'IADD': '11100',
          'LDM': '11101',
          'LDD': '11110',
          'STD': '11111'}


def parse_instruction(instruction: string):
    part = []
    part.append(opcode[instruction[0].upper()])
    print(instruction)
    # part.append(f'{(int(instruction[1][1],16)):03b}')
    op = part[0]
    if op in (opcode["NOT"], opcode["INC"], opcode["OUT"], opcode["IN"]):
        part.append(f'{(int(instruction[1][1],16)):03b}')
        part.append(f'{(int(instruction[1][1],16)):03b}')
    if op in (opcode["PUSH"], opcode["POP"]):
        part.append(f'{(int(instruction[1][1],16)):03b}')
    if op in (opcode["LDD"], opcode["STD"]):
        # swap offset value and 2nd register
        # from opcode, rd, offset, rs
        # to opcode, rd, rs, offset
        part.append(f'{(int(instruction[1][1],16)):03b}')
        instruction[2], instruction[3] = instruction[3], instruction[2]
        part.append(f'{int(instruction[2][1],16):03b}')
        # Rsrc2 & filler bits, 5 unused bits
        part.append(f'{int("0",16):05b}')
        part.append(f'{int(instruction[3],16):016b}')
    if op in (opcode["MOV"]):
        part.append(f'{int(instruction[2][1],16):03b}')
        part.append(f'{(int(instruction[1][1],16)):03b}')
    if op in (opcode["SWAP"]):
        part.append(f'{(int(instruction[1][1],16)):03b}')
        part.append(f'{int(instruction[2][1],16):03b}')
    if op in (opcode["ADD"], opcode["SUB"], opcode["AND"]):
        part.append(f'{(int(instruction[1][1],16)):03b}')
        part.append(f'{int(instruction[2][1],16):03b}')
        part.append(f'{int(instruction[3][1],16):03b}')
    if op in (opcode["JZ"], opcode["JN"], opcode["JC"], opcode["JMP"], opcode["CALL"]):
        part.append(f'{int(instruction[1],16):016b}')
    if op in (opcode["INT"]):
        part.append(f'{int(instruction[1],16):01b}')
    if op in (opcode["LDM"]):
        part.append(f'{int(instruction[1][1],16):03b}')
        # Rsrc1, Rsrc2 & filler bits, 5 unused bits
        part.append(f'{int("0",16):08b}')
        part.append(f'{int(instruction[2],16):016b}')
    if op in (opcode["IADD"]):
        part.append(f'{int(instruction[1][1],16):03b}')
        part.append(f'{int(instruction[2][1],16):03b}')
        # Rsrc2 & filler bits, 5 unused bits
        part.append(f'{int("0",16):05b}')
        part.append(f'{int(instruction[3],16):016b}')

    print("Part: ", part)
    operation = "".join(part)
    operation = operation.ljust(32, "0")
    return operation


def fill_mem(memory):
    for i in range(max(memory.keys())+6):
        if i not in memory:
            memory[i] = f'{0:032b}'


def write_mem(memory, file_name):
    with open(f"mem/{file_name}.mem", 'w') as f:
        f.write(r'''// memory data file (do not edit the following line - required for mem load use)
// instance=/pipelinedprocessor/Fetch/RAM1/ram
// format=mti addressradix=h dataradix=s version=1.0 wordsperline=1''')
        for k in sorted(memory):
            f.write(f'\n{k:x}: {memory[k][0:32]}')


def asm2mem(file_name: string):
    strings = open(f"asm/{file_name}.asm", 'r').read().splitlines()
    # remove comments, seperators between parameters and brackets around offsetted registers
    instructions = map(lambda x: re.sub(r'[(),]|#.*', ' ', x).split(), strings)
    memory = {}
    address = 0
    iterator = iter(instructions)
    for i in iterator:
        # check for empty strings in file
        if len(i) == 0:
            continue

        # ORG changes address of the following line
        if i[0] == ".ORG":
            address = int(i[1], 16)

        elif all(c in string.hexdigits for c in i[0]):
            # convert hexadecimal to binary and write to mem
            memory[address] = f'{int(i[0], 16):032b}'
            # move address
            address += 1

        # we have passed all special cases in the asm files,
        # now we can get to parsing actual instructions
        else:
            memory[address] = parse_instruction(i)
            address += 1

    fill_mem(memory)
    write_mem(memory, file_name)


for file_name in file_names:
    print("File:", file_name)
    asm2mem(file_name)
