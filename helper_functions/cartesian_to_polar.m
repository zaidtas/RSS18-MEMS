function [c, theta, omega]=cartesian_to_polar(x,y,z)
omega=atand(y./z);
theta=atand(x./z);
c=sqrt(x.^2+y.^2+z.^2);
end

