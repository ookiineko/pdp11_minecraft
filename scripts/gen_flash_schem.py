"""
generate chest flash schematic with pre-burned data
"""

from argparse import ArgumentParser
from os.path import exists, getsize

import numpy as np
from nbtlib.nbt import File
from nbtlib.schema import schema
from nbtlib.tag import Int, String, IntArray, Compound, Short, ByteArray, List, Byte

# CompoundSchema for schematic metadata
Metadata = schema(
    'Metadata',
    {
        'WEOffsetX': Int,
        'WEOffsetY': Int,
        'WEOffsetZ': Int
    },
    strict=True
)

# CompoundSchema for chest slot
ChestSlot = schema(
    'ChestSlot',
    {
        'Slot': Byte,
        'id': String,
        'Count': Byte
    },
    strict=True
)

# CompoundSchema for chest block entity
ChestBlockEntity = schema(
    'ChestBlockEntity',
    {
        'Items': List[ChestSlot],
        'Id': String,
        'Pos': IntArray
    },
    strict=True
)

# CompoundSchema for Minecraft schematic
Schematic = schema(
    'Schematic',
    {
        'PaletteMax': Int,
        'Palette': Compound,
        'Version': Int,
        'Length': Short,
        'Metadata': Metadata,
        'Height': Short,
        'DataVersion': Int,
        'BlockData': ByteArray,
        'BlockEntities': List[ChestBlockEntity],
        'Width': Short,
        'Offset': IntArray
    },
    strict=True
)


class SchematicFile(File, Schematic):
    """
    NBT file type for Minecraft schematic
    """

    def __init__(self, schematic: dict = None, *args, **kwargs):
        if schematic is None:
            # empty schematic data with default values
            schematic = {
                'PaletteMax': 0,
                'Palette': {},
                'Version': 2,
                'Length': 0,
                'Metadata': {
                    'WEOffsetX': 0,
                    'WEOffsetY': 0,
                    'WEOffsetZ': 0
                },
                'Height': 0,
                'DataVersion': 2586,  # Minecraft Java Edition 1.16.5
                'BlockData': [],
                'BlockEntities': [],
                'Width': 0,
                'Offset': [0, 0, 0]
            }
        super().__init__(schematic, *args, gzipped=True, **kwargs)

    @classmethod
    def load(cls, *args, **kwargs):
        return super().load(*args, gzipped=True, **kwargs)


def print_eta(test_t: float, test_v: int, volume: int):
    """
    print ETA
    :param test_t: test time
    :param test_v: test volume
    :param volume: volume
    """
    test_f = test_t / test_v
    print('this may takes up to about %.2f second(s) or even longer..' % (test_f * volume))


def gen_chest_block_entity(x: int, y: int, z: int) -> ChestBlockEntity:
    """
    generate chest block entity
    :param x: x coordinate
    :param y: y coordinate
    :param z: z coordinate
    :return: empty chest block entity
    """
    return ChestBlockEntity(
        {
            'Id': 'minecraft:chest',
            'Pos': [x, y, z],
            'Items': [
                {
                    'Slot': slot_id,
                    'id': 'minecraft:stone',
                    'Count': 1
                }
                for slot_id in range(27)
            ]
        }
    )


def main():
    """
    entrypoint
    """
    parser = ArgumentParser(description='generate chest flash schematic with pre-burned data',
                            epilog='powered by vberlier/nbtlib.')
    parser.add_argument('--output', '-o', type=str, help='output schematic file name', required=True)
    parser.add_argument('--size', '-s', type=int, nargs=3, help='flash size (width height length)', required=True)
    parser.add_argument('--image', '-i', type=str, help='image file to burn', default=None, required=False)
    ns = parser.parse_args()
    output = ns.output.strip()
    if not output:
        parser.error('empty argument is not allowed')
    width, height, length = ns.size
    assert width > 0
    assert height > 0
    assert length > 0
    volume = width * height * length
    slots = volume * 27
    image = ns.image
    file_bytes = -1
    if image is not None:
        image = image.strip()
        if not image:
            parser.error('empty argument is not allowed')
        if exists(image):
            file_bytes = getsize(image)
            max_bytes = slots // 5
            if file_bytes > max_bytes:
                raise ValueError('image file is too big (%d bytes > %d bytes)' % (file_bytes, max_bytes))
        else:
            raise FileNotFoundError('image file "%s" not found' % image)
    schem = SchematicFile()
    schem['PaletteMax'] = Int(1)
    plt = schem['Palette']
    plt['minecraft:chest[facing=west,type=single,waterlogged=false]'] = Int(0)
    schem['Length'] = Short(width)
    schem['Height'] = Short(length)
    schem['BlockData'] = ByteArray(np.zeros(volume, 'byte'))
    be = schem['BlockEntities']
    if image is None:
        t = 0
        d = volume // 20
        print('zeroing! please wait patiently..')
        print_eta(21.432955265045166, 100352, volume)
        for y in range(length):
            for z in range(height):
                for x in range(width):
                    entity = gen_chest_block_entity(x, y, z)
                    be.append(entity)
                    if t < d:
                        t += 1
                    else:
                        t = 0
                        print('zeroing: %.2f%% completed' % ((y * width * height + z * width + x) / volume * 100))
    else:
        t = 0
        d = file_bytes // 20
        print('flashing! please wait patiently..')
        print_eta(102.41714835166931, 387200, volume)
        with open(image, 'rb') as fd:
            slot_cnt = 0
            x = y = z = 0
            max_x = width - 1
            max_z = height - 1
            entity = gen_chest_block_entity(x, y, z)
            items = entity['Items']
            for bytes_ in iter(lambda: fd.read(1), b''):
                byte = bytes_[0]
                for _ in range(5):  # five slots per byte
                    if byte > 63:
                        s = 63
                    else:
                        s = byte
                    byte -= s
                    items[slot_cnt]['Count'] = s + 1
                    slot_cnt += 1
                    if slot_cnt > 26:
                        be.append(entity)
                        slot_cnt = 0
                        x += 1
                        if x > max_x:
                            x = 0
                            z += 1
                            if z > max_z:
                                z = 0
                                y += 1
                        entity = gen_chest_block_entity(x, y, z)
                        items = entity['Items']
                if t < d:
                    t += 1
                else:
                    t = 0
                    print('flashing: %.2f%% completed' % (
                            (y * width * height + z * width + x) * 27 / 5 / file_bytes * 100))
            # TODO: auto zeroing of flash tail blanks
            # print('zeroing! please wait patiently..')
            if slot_cnt != 0:
                # for i in range(27 - slot_cnt):
                #     items[slot_cnt + i] = 1
                be.append(entity)
    schem['Width'] = Short(height)
    print('saving! please wait patiently..')
    print_eta(75.12273406982422, 100352, volume)
    schem.save(output)


if __name__ == '__main__':
    main()
