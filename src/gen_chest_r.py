"""
generate chest read code
"""

r = range(27)
chunks = [r[x:x + 9] for x in range(0, len(r), 9)]

for chunk in chunks:
    for i in chunk:
        print('macro int _chest_read_%d(_NBT var, _IRType here) {' % i)
        print('''    int val = 0;
    ir (var, here) {
        nbt_modify_var_from $arg0, set, $arg1, "Items[%d].Count"
    }''' % i)
        print('''    ir (val, _IRType("nbtsubpath", var, "", "i32")) {
        $arg0 = $arg1
    }
    return val - 1;''')
        print('}')
        print()
    print('int _chest_read_%d_to_%d(Entity armstand, int slot) {' % (chunk[0], chunk[-1]))
    print('''    _NBT var();
    _IRType here("block_pos", _IRType("rel_pos", 0), _IRType("rel_pos", 0), _IRType("rel_pos", 0));''')
    for i in chunk:
        print(('    if' if i == chunk[0] else ' else if') + ' (slot == %d) {' % i)
        print('        at (armstand) {')
        print('            return _chest_read_%d(var, here);' % i)
        print('        }')
        print('    }', end='')
    print(''' else
        return -1;''')
    print('}')
    print()

print('macro int _chest_read(Entity armstand, int slot) {')
for chunk in chunks:
    print((' else' if chunk == chunks[-1] else (
            (('    if' if chunk == chunks[0] else ' else if') + ' (slot < %d)'
             ) % chunks[chunks.index(chunk) + 1][0])) + ' {')
    print('        return _chest_read_%d_to_%d(armstand, slot);' % (chunk[0], chunk[-1]))
    print('    }', end='')
print()
print('}')
