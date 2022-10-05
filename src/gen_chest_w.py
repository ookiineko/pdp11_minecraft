
"""
generate chest write code
"""


r = range(27)
chunks = [r[x:x+9] for x in range(0, len(r), 9)]

for chunk in chunks:
    for i in chunk:
        print('macro void _chest_write_%d(_IRType here, _NBT var) {' % i)
        print('''    ir (here, var) {
        nbt_modify_from_var $arg0, "Items[%d].Count", set, $arg1
    }''' % i)
        print('}')
        print()
    print('void _chest_write_%d_to_%d(Entity armstand, int slot, int val) {' % (chunk[0], chunk[-1]))
    print('''    int store = val + 1;
    _NBT var();
    ir (_IRType("nbtsubpath", var, "", "i32"), store) {
        $arg0 = $arg1
    }
    _IRType here("block_pos", _IRType("rel_pos", 0), _IRType("rel_pos", 0), _IRType("rel_pos", 0));''')
    for i in chunk:
        print(('    if' if i == chunk[0] else ' else if') + ' (slot == %d) {' % i)
        print('        at (armstand) {')
        print('            _chest_write_%d(here, var);' % i)
        print('        }')
        print('    }', end='')
    print()
    print('}')
    print()

print('//' * 64)
print()

for chunk in chunks:
    print('void _chest_write_%d_to_%d(Entity armstand, int slot, int val);' % (chunk[0], chunk[-1]))
print()

print('macro void _chest_write(Entity armstand, int slot, int val) {')
for chunk in chunks:
    print((' else' if chunk == chunks[-1] else ((('    if' if chunk == chunks[0] else ' else if') + ' (slot < %d)') % chunks[chunks.index(chunk) + 1][0])) + ' {')
    print('        _chest_write_%d_to_%d(armstand, slot, val);' % (chunk[0], chunk[-1]))
    print('    }', end='')
print()
print('}')
