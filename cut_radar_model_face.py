def cut_radar_model(input_file, output_file='model_cut_face.obj'):
    lines = open(input_file)
    if lines is None:
        assert 'Failed to open file: ' + input_file + '\n'
    print 'Start to cut_face the model & write to' + output_file + '...'
    output = open(output_file, 'w')

    vertices = ['']*20000
    i = 0


    #convert the first 20000 lines to 'cor,cor,cor' mode
    # for line in lines:
    #     vertices[i] = line[2:-1].replace(' ', ',')
    #     i += 1
    #     if i == 20000:
    #         break

    for line in lines:
        if line[0] == 'v': #and float(line[2:].split(' ')[2]) < 0:
            # output.write(rotate(line[2:]) + '\n')
            output.write(line[2:])
        # elif line[0] == 'f':
        #    output.write(line)
        else:
            pass

    output.close()
    lines.close()
    print 'Finished'


cut_radar_model('data.obj')