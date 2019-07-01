function [scannedx scannedy scannedz]=mems_scan_x_y_z(vector_scan,theta,omega,dirn_with_z)
% MEMS Scanning simulator
rfake=1;
scanx=vector_scan(:,1);
scany=vector_scan(:,2);
scanz=vector_scan(:,3);
[xmems, ymems, zmems]=find_x_y_z(theta,omega,rfake);
if omega<0
    ymems=-ymems;
end

vector_mems=[xmems, ymems, zmems];
z_dirn_vector=[0 0 1];
if vector_mems==0
    angle_mems_with_z=0;
else
angle_mems_with_z=acosd(dot(vector_mems,z_dirn_vector)/(norm(vector_mems)*norm(z_dirn_vector)));
end
index_imp=find(dirn_with_z<=(angle_mems_with_z+0.2) & dirn_with_z>=(angle_mems_with_z-0.2));
i_ctr=1;
for i=index_imp
angle_mems(i_ctr)=acosd(dot(vector_scan(i,:),vector_mems)/(norm(vector_scan(i,:))*norm(vector_mems)));
i_ctr=i_ctr+1;
end
if i_ctr>1
[sort_angle,sort_ind]=sort(angle_mems);

if(sort_angle(1)>1);
   scannedx=0;
   scannedy=0;
   scannedz=0;
else
scannedx1=scanx(index_imp(sort_ind(1)));
scannedy1=scany(index_imp(sort_ind(1)));
scannedz1=scanz(index_imp(sort_ind(1)));

r=sqrt(scannedx1^2+scannedy1^2+scannedz1^2);
[scannedx,scannedy,scannedz]=find_x_y_z(theta,omega,r);

if omega<0
    scannedy=-scannedy;
end

end
else
    scannedx=0;
    scannedy=0;
    scannedz=0;
end
end