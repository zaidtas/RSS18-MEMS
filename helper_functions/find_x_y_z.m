function [x,y,z] = find_x_y_z(theta1, omega1,c)
% mirror postion
% xm=9.5;
% ym=2.5;

%theta 1 is the angle that light ray makes after the MEMS and from the line
%connecting MEMS and Receiver, it's the input to this function
% theta1=52;

%this is the sum of the distance travelled by light and is another input
% c=250;

%see figure; distance between Receiver and MEMS
% theta1=90-theta1;
%omega1=90-omega1;


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

%  if omega1<0 && y>0
%      y=-y;
%  end
%  
%   if omega1>0 && y<0
%      y=-y;
%  end
end