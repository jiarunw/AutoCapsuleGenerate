fileID = fopen('C:\Program Files\Autodesk\Maya2020\model.obj', 'r');
for i = 1:4
    fgetl(fileID);
end
X = cell(1, 100);
part = 0;
while ~feof(fileID)
    str = fgetl(fileID);
    s = strsplit(str,' ');
    if s{1} == 'g'
        part = part + 1;
    end
    if s{1} == 'v'
        X{part} = [X{part};str2num(s{2}), str2num(s{3}), str2num(s{4})];
    end 
end
fclose(fileID);
for i = 1:part
    [R, OR, OL, theta, Oh, OR_vec, OL_vec] = ComputeCapsule(X{i});
    mayaDir = sprintf("C:\\Program Files\\Autodesk\\Maya2020\\genCapsule%d.py", i);
    mayaFile = fopen(mayaDir, 'w'); 
    fprintf(mayaFile, "import maya.cmds as cmds\n");
    fprintf(mayaFile, "def run():\n");
    fprintf(mayaFile, "   cmds.polyCylinder(r=%.4f, h=%.4f, ax=(%.4f, %.4f, %.4f))\n", R, OR - OL, theta(1), theta(2), theta(3));
    fprintf(mayaFile, "   cmds.move(%.4f, %.4f, %.4f)\n", Oh(1), Oh(2), Oh(3));
    fprintf(mayaFile, "   cmds.polySphere(r=%.4f)\n", R);
    fprintf(mayaFile, "   cmds.move(%.4f, %.4f, %.4f)\n", OL_vec(1), OL_vec(2), OL_vec(3));
    fprintf(mayaFile, "   cmds.polySphere(r=%.4f)\n", R);
    fprintf(mayaFile, "   cmds.move(%.4f, %.4f, %.4f)\n", OR_vec(1), OR_vec(2), OR_vec(3));
end
