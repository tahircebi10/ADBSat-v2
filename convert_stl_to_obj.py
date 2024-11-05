import pymeshlab as ml
import sys

def convert_stl_to_obj(input_file, output_file):
    ms = ml.MeshSet()
    ms.load_new_mesh(input_file)
    ms.save_current_mesh(output_file)

if __name__ == "__main__":
    input_file = sys.argv[1]
    output_file = sys.argv[2]
    convert_stl_to_obj(input_file, output_file)
