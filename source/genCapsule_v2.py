with open("C:\Program Files\Autodesk\Maya2020\genCapsuleAll.py", "w") as f:
    f.write("from imp import reload\n")
    for i in range(18):
        f.write("import genCapsule%d\n"%(i+1))
        f.write("reload(genCapsule%d)\n"%(i+1))
        f.write("genCapsule%d.run()\n"%(i+1))