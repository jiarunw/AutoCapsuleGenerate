fileID = fopen('C:\Program Files\Autodesk\Maya2020\model2.obj', 'r');
for i = 1:7
    fgetl(fileID);
end
X = [];
while ~feof(fileID)
    str = fgetl(fileID);
    s = strsplit(str,' ');
    if s{1} == 'v'
        X = [X;str2num(s{2}), str2num(s{3}), str2num(s{4})];
    end 
end
fclose(fileID);
[U, S, V] = svd(X, 'econ');
[M, I] = max(max(S));
theta = V(:, I)';
O = mean(X, 1);
OX = X - O;
[N, ~] = size(OX);
Theta = sum(repmat(theta, N, 1) .* OX, 2);
r = sqrt(sum(cross(repmat(theta, N, 1), OX, 2).^2, 2));
R = max(max(r));
OR = max(Theta - sqrt(R^2 - r.^2));
OL = min(Theta + sqrt(R^2 - r.^2));
OL_vec = O + OL * theta;
OR_vec = O + OR * theta;  
Oh = O + 0.5 * (OR + OL) * theta;
mayaDir = "C:\Program Files\Autodesk\Maya2020\genCapsule.py";
mayaFile = fopen(mayaDir, 'w'); 
fprintf(mayaFile, "import maya.cmds as cmds\n");
fprintf(mayaFile, "def run():\n");
fprintf(mayaFile, "   cmds.polyCylinder(r=%.4f, h=%.4f, ax=(%.4f, %.4f, %.4f))\n", R, OR - OL, theta(1), theta(2), theta(3));
fprintf(mayaFile, "   cmds.move(%.4f, %.4f, %.4f)\n", Oh(1), Oh(2), Oh(3));
fprintf(mayaFile, "   cmds.polySphere(r=%.4f)\n", R);
fprintf(mayaFile, "   cmds.move(%.4f, %.4f, %.4f)\n", OL_vec(1), OL_vec(2), OL_vec(3));
fprintf(mayaFile, "   cmds.polySphere(r=%.4f)\n", R);
fprintf(mayaFile, "   cmds.move(%.4f, %.4f, %.4f)\n", OR_vec(1), OR_vec(2), OR_vec(3));
