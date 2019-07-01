function [dirn_with_z]=  calc_dirn_with_z(vector_scan)

z_dirn_vector=[ 0 0 1];

for i=1:size(vector_scan,1)
   dirn_with_z(i)= acosd(dot(vector_scan(i,:),z_dirn_vector)/(norm(vector_scan(i,:))*norm(z_dirn_vector)));
end
end
