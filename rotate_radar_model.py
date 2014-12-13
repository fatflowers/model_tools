import math
import copy
__author__ = 'SunLei sunleihit@qq.com'
__doc__ = 'Rotate the model input_file around the X axis by theta1,Y axis by theta2' \
          ' which can be modified in function rorate' \
          'rotate_radar_model is the main function'
def rotate(coor, theta1 = -0.5 * math.pi, theta2 = -math.pi):
    coor = coor.split(' ')
    for i in range(0, len(coor)):
        coor[i] = float(coor[i])
    # rotating around X axis
    #theta1 = -0.5 * math.pi
    # rotating around Y axis
    #theta2 = -math.pi
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


def rotate_radar_model(input_file, output_file='model_rotated.obj', theta1 = -0.5 * math.pi, theta2 = -math.pi):
    lines = open(input_file)
    if lines is None:
        assert 'Failed to open file: ' + input_file + '\n'
    print 'Start to rotate the model & write to' + output_file + '...'
    output = open(output_file, 'w')

    for line in lines:
        if line[0] == 'v':
            output.write('v ' + rotate(line[2:]) + '\n')
        elif line[0] == 'f':
            output.write(line)
        else:
            pass

    output.close()
    lines.close()
    print 'Finished'

rotate_radar_model('data.obj')