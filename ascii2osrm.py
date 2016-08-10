'''Converts ArcGrid ASCII raster data to the very similar format that OSRM
requires: the metadata (first 6 lines) is removed and the data is rounded to
the nearest integer value (meter, usually).'''


def ascii_to_osrm(inpath, outpath):
    f = open(inpath)
    g = open(outpath, 'w')

    # Remove first 6 lines (metadata)
    for i in range(6):
        f.next()

    cols = 0
    rows = 0
    while True:
        try:
            line = f.next()
        except StopIteration:
            print('cols:', cols)
            print('rows:', rows)
            break

        cols = max(cols, len(line.split(' ')) - 1)
        rows += 1

        line_items = []
        for item in line.strip().split(' '):
            # Convert to nearest integer
            line_items.append(str(int(float(item))))
            # Convert to lower precision
            # line_items.append('{:.6f}'.format(float(item)))

        line = ' '.join(line_items) + '\n'

        g.writelines([line])

    f.close()
    g.close()


if __name__ == '__main__':
    import sys
    args = sys.argv
    ascii_to_osrm(sys.argv[1], sys.argv[2])
