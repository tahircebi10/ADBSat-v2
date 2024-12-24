import pymeshlab as ml
import sys
import os

def create_mtl_file(mtl_file):
 # Create a new mtl file
    with open(mtl_file, 'w') as mtl:
        mtl.write("newmtl SatelliteMaterial\n")
        mtl.write("Ka 0.7 0.7 0.7\n")  # Ambient color
        mtl.write("Kd 0.8 0.8 0.8\n")  # Diffuse color
        mtl.write("Ks 0.5 0.5 0.5\n")  # Specular color
        mtl.write("Ns 10.0\n")         # Shininess
        mtl.write("d 1.0\n")           # Opacity
        mtl.write("illum 2\n")         # Illumination model

def convert_stl_to_obj_with_material(input_file, output_file):
    """
    STL dosyasını OBJ formatına dönüştürür ve malzeme ataması yapar.
    """
    # MTL dosyasının yolu
    output_dir = os.path.dirname(output_file)
    base_name = os.path.splitext(os.path.basename(output_file))[0]
    mtl_file = os.path.join(output_dir, f"{base_name}.mtl")
    
    # MTL dosyasını oluştur
    create_mtl_file(mtl_file)
    
    # MeshLab ile STL'den OBJ'ye dönüştür
    ms = ml.MeshSet()
    ms.load_new_mesh(input_file)
    ms.save_current_mesh(output_file)
    
    # OBJ dosyasına MTL referansı ekle
    with open(output_file, 'r+') as obj:
        content = obj.read()
        obj.seek(0, 0)
        obj.write(f"mtllib {os.path.basename(mtl_file)}\n" + content)
    
    print(f"Conversion completed! OBJ file: {output_file}, MTL file: {mtl_file}")

if __name__ == "__main__":
    input_file = sys.argv[1]
    output_file = sys.argv[2]
    convert_stl_to_obj_with_material(input_file, output_file)
