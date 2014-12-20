import math
import copy
import string
import subprocess
import pickle

__author__ = 'sunlei'
__doc__ = 'contact me via email sunleihit@qq.com'


# referred by rotate_radar_model
def rotate(coor, theta1=-0.5 * math.pi, theta2=-math.pi):
    coor = coor.split(' ')
    for i in range(0, len(coor)):
        coor[i] = float(coor[i])
    # rotating around X axis
    # theta1 = -0.5 * math.pi
    # rotating around Y axis
    # theta2 = -math.pi
    coor_new = copy.deepcopy(coor)

    # rotating around X axis
    coor_new[1] = math.cos(theta1) * coor[1] - math.sin(theta1) * coor[2]
    coor_new[2] = math.sin(theta1) * coor[1] + math.cos(theta1) * coor[2]

    coor = copy.deepcopy(coor_new)
    # rotating around Y axis
    coor[0] = math.cos(theta2) * coor_new[0] + math.sin(theta2) * coor_new[2]
    coor[2] = math.cos(theta2) * coor_new[2] - math.sin(theta2) * coor_new[0]

    for i in range(0, len(coor)):
        coor[i] = float('%.6f' % coor[i])
    coor = str(coor)[1:-2].replace(', ', ' ', len(coor) - 1)

    return coor


def rotate_radar_model(input_file='data.obj', output_file='model_rotated.obj', theta1=-0.5 * math.pi, theta2=-math.pi):
    lines = open(input_file)
    if lines is None:
        assert 'Failed to open file: ' + input_file + '\n'
    print 'Start to rotate the model & write to' + output_file + '...'
    output = open(output_file, 'w')
    if output is None:
        assert 'Failed to open file: ' + output_file + '\n'

    for line in lines:
        if line[0] == 'v':
            output.write('v ' + rotate(line[2:], theta1, theta2) + '\n')
        elif line[0] == 'f':
            output.write(line)
        else:
            pass

    output.close()
    lines.close()
    print 'Finished'


def cut_radar_model(input_file='model_rotated.obj', output_file='model_cut.obj'):
    lines = open(input_file)
    if lines is None:
        assert 'Failed to open file: ' + input_file + '\n'
    print 'Start to cut the model & write to' + output_file + '...'
    output = open(output_file, 'w')
    if output is None:
        assert 'Failed to open file: ' + output_file + '\n'

    for line in lines:
        if line[0] == 'v' and float(line[2:].split(' ')[2]) > 0:
            # output.write(rotate(line[2:]) + '\n')
            output.write(line[2:])
        # elif line[0] == 'f':
        # output.write(line)
        else:
            pass

    output.close()
    lines.close()
    print 'Finished'


def coordinate_transform(input_file='model_cut.obj', output_file='depth_map.depth'):
    lines = open(input_file)
    if lines is None:
        assert 'Failed to open file: ' + input_file + '\n'
    print 'Start to compute depth map of file:' + input_file + '...'
    output = open(output_file, 'w')
    if output is None:
        assert 'Failed to open file: ' + output_file + '\n'

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


def modify_3Dmodel(input_file='model_rotated.obj', depth_file='depth_combined.tmp', output_file='modify_3Dmodel.obj'):
    """


    :rtype : object
    :param input_file:
    :param depth_file:
    :param output_file:
    """
    lines = open(input_file)
    if lines is None:
        assert 'Failed to open file: ' + input_file + '\n'
    depth = open(depth_file)
    if depth is None:
        assert 'Failed to open file: ' + depth_file + '\n'
    output = open(output_file, 'w')
    if output is None:
        assert 'Failed to open file: ' + output_file + '\n'

    print 'Start to modify the model' + input_file + ' & write to' + output_file + '...'


    for line in lines:
        if line[0] == 'v' and float(line[2:].split(' ')[2]) > 0:
            output.write(line[:line.rfind(' ') + 1] + '%.6f' % float(depth.readline()) + '\n')
        else:
            output.write(line)

    output.close()
    depth.close()
    lines.close()


def start_matlab_command():
    matlab_root = r"D:\Program Files\MATLAB\R2013a\bin\matlab.exe"

    work_path = r"C:\Users\Administrator\Desktop\toutatis\a"

    log_file = "log.txt"

    the_function = "test"

    return "{0} -wait -automation -logfile {1} -r cd('{2}'){3}".format(matlab_root, log_file, work_path,
                                                                       the_function)
    # dos_cmd = matlab_root + r"\bin\matlab.exe"
    #
    # dos_cmd += " -wait "
    #
    # dos_cmd += " -automation "
    #
    # dos_cmd = "{0} -sd {1}".format(dos_cmd, work_path)

    # dos_cmd = dos_cmd + " -logfile " + log_file
    #
    # dos_cmd = dos_cmd + " -r " + the_function


if __name__ == "__main__":
    rotate_radar_model()
    cut_radar_model()
    coordinate_transform()
    subprocess.Popen(start_matlab_command())
    modify_3Dmodel()