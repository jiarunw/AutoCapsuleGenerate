import pandas as pd
import numpy as np
def computeCapsule(objDir):
    data = pd.read_csv(objDir, sep = " ", header = None)
    v = np.array(data[data[:][0]=="v"][[1, 2, 3]], dtype = float)
    center = np.mean(v, axis = 0)
    _, Sigma, vec = np.linalg.svd(v - center)
    p = vec[np.argmax(Sigma), :]
    p /= np.linalg.norm(p)
    proj = np.sum(p * v, axis = 1)
    v_start = v[np.argmin(proj), :]
    v_end = v[np.argmax(proj), :]
    end1 = center - p * np.sum(p * (center - v_start))
    end2 = center + p * np.sum(p * (v_end - center))
    dis = np.linalg.norm(np.cross(v - center, p), axis = 1)
    R = np.max(dis)
    h = np.sum(p * (v_end - v_start))
    p_center = 0.5*(v_start+v_end)
    return R, h, p_center, p
objDir = "C:\Program Files\Autodesk\Maya2020\model.obj"
mayaDir = "C:\Program Files\Autodesk\Maya2020\genCapsule.py"
R, h, p_center, p = computeCapsule(objDir)
with open(mayaDir, "w") as f:
    f.write("import maya.cmds as cmds\n")
    f.write("def run():\n")
    f.write("   cmds.polyCylinder(r=%.4f, h=%.4f, ax=(%.4f, %.4f, %.4f))\n"%(R, h, p[0], p[1], p[2]))
    f.write("   cmds.move(%.4f, %.4f, %.4f)\n"%(p_center[0], p_center[1], p_center[2]))
