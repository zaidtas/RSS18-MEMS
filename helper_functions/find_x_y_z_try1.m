
function [x,y,z] = find_x_y_z_try1(theta1, omega1,c)


thetaz=acosd(sqrt((tand(omega1).^2)/(1+tand(theta1).^2+tand(omega1).^2)));
z=cosd(thetaz)*c;
if thetaz==90
y=c*cosd(theta1);
else

y=abs(z./tand(omega1));
end
x=y.*tand(theta1);

    
temp=z;
z=y;
y=temp;

 if omega1<0 && y>0
     y=-y;
 end
 
  if omega1>0 && y<0
     y=-y;
 end

 

end