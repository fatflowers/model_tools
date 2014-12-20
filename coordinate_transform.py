import pickle


def coordinate_transform(input_file, output_file='depth_map.depth'):
    lines = open(input_file)
    if lines is None:
        assert 'Failed to open file: ' + input_file + '\n'
    print 'Start to compute depth map of file:' + input_file + '...'
    output = open(output_file, 'w')

    Wp = 2.0
    Hp = 2.0
    Ws = 728.0
    Hs = 728.0

    # coordinate dictionary, input an image coordinate, output a 3D x-y coordinate
    coor_dict_x = {}
    coor_dict_y = {}
    for line in lines:
        coors = line.split(' ')
        for i in range(0, len(coors)):
            coors[i] = float(coors[i])
        x = coors[0]
        y = coors[1]

        # transform to standard coordinate
        coors[0] = -coors[0] / (10.0 - coors[2]) * 1.5
        coors[1] = -coors[1] / (10.0 - coors[2]) * 1.5
        # coors[2] = 2.0 / 3.0 * (coors[2] - 10)

        # xs = (Ws - 1.0) * (coors[0] / Wp + 0.5)
        xs = (Ws - 1.0) * (coors[0] * 2 / Wp + 0.5) + 1
        ys = (Hs - 1.0) * (coors[1] * 2 / Hp + 0.5) + 1

        output.write('%d ' % ys + '%d ' % xs + '%.6f' % coors[2] + '\n')
        coor_dict_x[int(xs)] = x
        coor_dict_y[int(ys)] = y

    output.close()
    lines.close()
    print 'Finished'
    output = open('coor_dict.pkl', 'wb')
    pickle.dump(coor_dict_x, output)
    pickle.dump(coor_dict_y, output)
    output.close()


coordinate_transform('model_cut.obj')