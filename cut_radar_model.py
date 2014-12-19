def cut_radar_model(input_file, output_file='model_cut.obj'):
    lines = open(input_file)
    if lines is None:
        assert 'Failed to open file: ' + input_file + '\n'
    print 'Start to cut the model & write to' + output_file + '...'
    output = open(output_file, 'w')

    for line in lines:
        if line[0] == 'v' and float(line[2:].split(' ')[2]) > 0:
            # output.write(rotate(line[2:]) + '\n')
            output.write(line[2:])
        # elif line[0] == 'f':
        #    output.write(line)
        else:
            pass

    output.close()
    lines.close()
    print 'Finished'


cut_radar_model('model_rotated.obj')