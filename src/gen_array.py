"""
generate array code
"""

from math import sqrt


max_length = 8
r = range(max_length)
split = int(sqrt(max_length))
chunks = [r[x:x + split] for x in range(0, len(r), split)]

print('''include "Text"


type Array {
    _NBT var;
    int length;

    macro constructor() {
        ir (this.var, _IRType("nbt_list int")) {
            nbt_assign $arg0, $arg1
        }
        this.length = 0;
    }''')
print()

for chunk in chunks:
    print('''    int _get_%d_%d(int index);''' % (chunk[0], chunk[-1]))
print()

print('''    Maybe<int> operator [](int index);''')
print()

for chunk in chunks:
    print('''    void _set_%d_%d(int index, _NBT var);''' % (chunk[0], chunk[-1]))
print()

print('''    void set(int index, int val);''')
print()

print('''    macro void append(int val) {''')

print('''        if (this.length < %d) {''' % max_length)

print('''            _NBT var;
            ir (_IRType("nbtsubpath", var, "", "i32"), val, this.var, var) {
                $arg0 = $arg1
                nbt_var_append $arg2, $arg3
            }
            this.length++;
        }  else {
            Text err;
            err << "array.append(";
            err.append_ref(val);
            err << ") (not implemented).";
            err.send_to_all();
        }
    }''')
print()

for chunk in chunks:
    print('''    void _insert_%d_%d(int index, _NBT var);''' % (chunk[0], chunk[-1]))
print()

print('''    void insert(int index, int val);''')
print()

for chunk in chunks:
    print('''    void _pop_%d_%d(int index);''' % (chunk[0], chunk[-1]))
print()

print('''    Maybe<int> pop(int index);
}''')

print()
print('////' * 16)
print()

print('include "include/array"')
print()
print()

for chunk in chunks:
    print('''int Array::_get_%d_%d(int index) {
    int val;''' % (chunk[0], chunk[-1]))
    for i in chunk:
        print('''%s {
        ir (val, _IRType("nbtsubpath", this.var, "[%d]", "i32")) {
            $arg0 = $arg1
        }
        return val;
    }''' % (' else' if i == chunk[-1] else '%s (index == %d)' % ('    if' if i == chunk[0] else ' else if', i), i), end='')
    print()
    print('}')
    print()

print('''Maybe<int> Array::operator [](int index) {
    if (index >= 0 && this.length > index) {''')

for chunk in chunks:
    print('''        %s
            return this._get_%d_%d(index);''' % ('else' if chunk == chunks[-1] else '%s (index < %d)' % ('if' if chunk == chunks[0] else 'else if', chunk[-1] + 1), chunk[0], chunk[-1]))

print('''    } else {
        Text err;
        err << "array[";
        err.append_ref(index);
        err << "] -> (index error).";
        err.send_to_all();
    }
}''')
print()

for chunk in chunks:
    print('''void Array::_set_%d_%d(int index, _NBT var) {''' % (chunk[0], chunk[-1]))
    for i in chunk:
        print('''%s {
        ir (_IRType("nbtsubpath", this.var, "[%d]", "i32"), var) {
            $arg0 = $arg1
        }
    }''' % (' else' if i == chunk[-1] else '%s (index == %d)' % ('    if' if i == chunk[0] else ' else if', i), i), end='')
    print()
    print('}')
    print()

print('''void Array::set(int index, int val) {
    if (index >= 0 && this.length > index) {
        _NBT var;
        ir (_IRType("nbtsubpath", var, "", "i32"), val) {
            $arg0 = $arg1
        }''')

for chunk in chunks:
    print('''        %s
            this._set_%d_%d(index, var);''' % ('else' if chunk == chunks[-1] else '%s (index < %d)' % ('if' if chunk == chunks[0] else 'else if', chunk[-1] + 1), chunk[0], chunk[-1]))

print('''    } else {
        Text err;
        err << "array[";
        err.append_ref(index);
        err << "] = ";
        err.append_ref(val);
        err << " (index error).";
        err.send_to_all();
    }
}''')
print()

for chunk in chunks:
    print('''void Array::_insert_%d_%d(int index, _NBT var) {''' % (chunk[0], chunk[-1]))
    for i in chunk:
        print('''%s {
        ir (this.var, _IRType("nbt_val int, %d"), var) {
            nbt_var_insert $arg0, $arg1, $arg2
        }
    }''' % (' else' if i == chunk[-1] else '%s (index == %d)' % ('    if' if i == chunk[0] else ' else if', i), i), end='')
    print()
    print('}')
    print()

print('''void Array::insert(int index, int val) {''')

print('''    if (index < 0 || index > this.length || this.length + 1 > %d) {''' % max_length)

print('''        Text err;
        err << "array.insert(";
        err.append_ref(index);
        err << ",";
        err.append_ref(val);
        err << ") (index error or not implemented).";
        err.send_to_all();
    } else {
        _NBT var;
        ir (_IRType("nbtsubpath", var, "", "i32"), val) {
            $arg0 = $arg1
        }''')

for chunk in chunks:
    print('''%s {
            this._insert_%d_%d(index, var);
            this.length++;
        }''' % (' else' if chunk == chunks[-1] else '%s (index < %d)' % ('        if' if chunk == chunks[0] else ' else if', chunk[-1] + 1), chunk[0], chunk[-1]), end='')
print()

print('''    }
}''')
print()

for chunk in chunks:
    print('''void Array::_pop_%d_%d(int index) {''' % (chunk[0], chunk[-1]))
    for i in chunk:
        print('''%s {
        ir (_IRType("nbtsubpath", this.var, "[%d]", "i32")) {
            nbt_remove $arg0
        }
    }''' % (' else' if i == chunk[-1] else '%s (index == %d)' % ('    if' if i == chunk[0] else ' else if', i), i), end='')
    print()
    print('}')
    print()

print('''Maybe<int> Array::pop(int index) {
    if (index >= 0 && this.length > index) {
        Maybe<int> old = this[index];
        if (!old.isEmpty()) {''')

for chunk in chunks:
    print('''%s {
                this._pop_%d_%d(index);
                this.length--;
                return old.get();
            }''' % (' else' if chunk == chunks[-1] else '%s (index < %d)' % ('            if' if chunk == chunks[0] else ' else if', chunk[-1] + 1), chunk[0], chunk[-1]), end='')
print()

print('''        }
    }  else {
        Text err;
        err << "array.pop(";
        err.append_ref(index);
        err << ") -> (index error).";
        err.send_to_all();
    }
}''')
