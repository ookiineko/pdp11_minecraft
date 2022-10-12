include "include/array"


int Array::_get_0_1(int index) {
    int val;
    if (index == 0) {
        ir (val, _IRType("nbtsubpath", this.var, "[0]", "i32")) {
            $arg0 = $arg1
        }
        return val;
    } else {
        ir (val, _IRType("nbtsubpath", this.var, "[1]", "i32")) {
            $arg0 = $arg1
        }
        return val;
    }
}

int Array::_get_2_3(int index) {
    int val;
    if (index == 2) {
        ir (val, _IRType("nbtsubpath", this.var, "[2]", "i32")) {
            $arg0 = $arg1
        }
        return val;
    } else {
        ir (val, _IRType("nbtsubpath", this.var, "[3]", "i32")) {
            $arg0 = $arg1
        }
        return val;
    }
}

int Array::_get_4_5(int index) {
    int val;
    if (index == 4) {
        ir (val, _IRType("nbtsubpath", this.var, "[4]", "i32")) {
            $arg0 = $arg1
        }
        return val;
    } else {
        ir (val, _IRType("nbtsubpath", this.var, "[5]", "i32")) {
            $arg0 = $arg1
        }
        return val;
    }
}

int Array::_get_6_7(int index) {
    int val;
    if (index == 6) {
        ir (val, _IRType("nbtsubpath", this.var, "[6]", "i32")) {
            $arg0 = $arg1
        }
        return val;
    } else {
        ir (val, _IRType("nbtsubpath", this.var, "[7]", "i32")) {
            $arg0 = $arg1
        }
        return val;
    }
}

Maybe<int> Array::operator [](int index) {
    if (index >= 0 && this.length > index) {
        if (index < 2)
            return this._get_0_1(index);
        else if (index < 4)
            return this._get_2_3(index);
        else if (index < 6)
            return this._get_4_5(index);
        else
            return this._get_6_7(index);
    } else {
        Text err;
        err << "array[";
        err.append_ref(index);
        err << "] -> (index error).";
        err.send_to_all();
    }
}

void Array::_set_0_1(int index, _NBT var) {
    if (index == 0) {
        ir (_IRType("nbtsubpath", this.var, "[0]", "i32"), var) {
            $arg0 = $arg1
        }
    } else {
        ir (_IRType("nbtsubpath", this.var, "[1]", "i32"), var) {
            $arg0 = $arg1
        }
    }
}

void Array::_set_2_3(int index, _NBT var) {
    if (index == 2) {
        ir (_IRType("nbtsubpath", this.var, "[2]", "i32"), var) {
            $arg0 = $arg1
        }
    } else {
        ir (_IRType("nbtsubpath", this.var, "[3]", "i32"), var) {
            $arg0 = $arg1
        }
    }
}

void Array::_set_4_5(int index, _NBT var) {
    if (index == 4) {
        ir (_IRType("nbtsubpath", this.var, "[4]", "i32"), var) {
            $arg0 = $arg1
        }
    } else {
        ir (_IRType("nbtsubpath", this.var, "[5]", "i32"), var) {
            $arg0 = $arg1
        }
    }
}

void Array::_set_6_7(int index, _NBT var) {
    if (index == 6) {
        ir (_IRType("nbtsubpath", this.var, "[6]", "i32"), var) {
            $arg0 = $arg1
        }
    } else {
        ir (_IRType("nbtsubpath", this.var, "[7]", "i32"), var) {
            $arg0 = $arg1
        }
    }
}

void Array::set(int index, int val) {
    if (index >= 0 && this.length > index) {
        _NBT var;
        ir (_IRType("nbtsubpath", var, "", "i32"), val) {
            $arg0 = $arg1
        }
        if (index < 2)
            this._set_0_1(index, var);
        else if (index < 4)
            this._set_2_3(index, var);
        else if (index < 6)
            this._set_4_5(index, var);
        else
            this._set_6_7(index, var);
    } else {
        Text err;
        err << "array[";
        err.append_ref(index);
        err << "] = ";
        err.append_ref(val);
        err << " (index error).";
        err.send_to_all();
    }
}

void Array::_insert_0_1(int index, _NBT var) {
    if (index == 0) {
        ir (this.var, _IRType("nbt_val int, 0"), var) {
            nbt_var_insert $arg0, $arg1, $arg2
        }
    } else {
        ir (this.var, _IRType("nbt_val int, 1"), var) {
            nbt_var_insert $arg0, $arg1, $arg2
        }
    }
}

void Array::_insert_2_3(int index, _NBT var) {
    if (index == 2) {
        ir (this.var, _IRType("nbt_val int, 2"), var) {
            nbt_var_insert $arg0, $arg1, $arg2
        }
    } else {
        ir (this.var, _IRType("nbt_val int, 3"), var) {
            nbt_var_insert $arg0, $arg1, $arg2
        }
    }
}

void Array::_insert_4_5(int index, _NBT var) {
    if (index == 4) {
        ir (this.var, _IRType("nbt_val int, 4"), var) {
            nbt_var_insert $arg0, $arg1, $arg2
        }
    } else {
        ir (this.var, _IRType("nbt_val int, 5"), var) {
            nbt_var_insert $arg0, $arg1, $arg2
        }
    }
}

void Array::_insert_6_7(int index, _NBT var) {
    if (index == 6) {
        ir (this.var, _IRType("nbt_val int, 6"), var) {
            nbt_var_insert $arg0, $arg1, $arg2
        }
    } else {
        ir (this.var, _IRType("nbt_val int, 7"), var) {
            nbt_var_insert $arg0, $arg1, $arg2
        }
    }
}

void Array::insert(int index, int val) {
    if (index < 0 || index > this.length || this.length + 1 > 8) {
        Text err;
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
        }
        if (index < 2) {
            this._insert_0_1(index, var);
            this.length++;
        } else if (index < 4) {
            this._insert_2_3(index, var);
            this.length++;
        } else if (index < 6) {
            this._insert_4_5(index, var);
            this.length++;
        } else {
            this._insert_6_7(index, var);
            this.length++;
        }
    }
}

void Array::_pop_0_1(int index) {
    if (index == 0) {
        ir (_IRType("nbtsubpath", this.var, "[0]", "i32")) {
            nbt_remove $arg0
        }
    } else {
        ir (_IRType("nbtsubpath", this.var, "[1]", "i32")) {
            nbt_remove $arg0
        }
    }
}

void Array::_pop_2_3(int index) {
    if (index == 2) {
        ir (_IRType("nbtsubpath", this.var, "[2]", "i32")) {
            nbt_remove $arg0
        }
    } else {
        ir (_IRType("nbtsubpath", this.var, "[3]", "i32")) {
            nbt_remove $arg0
        }
    }
}

void Array::_pop_4_5(int index) {
    if (index == 4) {
        ir (_IRType("nbtsubpath", this.var, "[4]", "i32")) {
            nbt_remove $arg0
        }
    } else {
        ir (_IRType("nbtsubpath", this.var, "[5]", "i32")) {
            nbt_remove $arg0
        }
    }
}

void Array::_pop_6_7(int index) {
    if (index == 6) {
        ir (_IRType("nbtsubpath", this.var, "[6]", "i32")) {
            nbt_remove $arg0
        }
    } else {
        ir (_IRType("nbtsubpath", this.var, "[7]", "i32")) {
            nbt_remove $arg0
        }
    }
}

Maybe<int> Array::pop(int index) {
    if (index >= 0 && this.length > index) {
        Maybe<int> old = this[index];
        if (!old.isEmpty()) {
            if (index < 2) {
                this._pop_0_1(index);
                this.length--;
                return old.get();
            } else if (index < 4) {
                this._pop_2_3(index);
                this.length--;
                return old.get();
            } else if (index < 6) {
                this._pop_4_5(index);
                this.length--;
                return old.get();
            } else {
                this._pop_6_7(index);
                this.length--;
                return old.get();
            }
        }
    } else {
        Text err;
        err << "array.pop(";
        err.append_ref(index);
        err << ") -> (index error).";
        err.send_to_all();
    }
}
