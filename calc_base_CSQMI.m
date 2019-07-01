clear
load stream_for_base_csqmi.mat
path(path,'./rayBoxIntersection');

for az=1:length(thetastream)
    
thetacheck=thetastream(az);
omegacheck=omegastream(az);
ICS(az)=calc_ICS(thetacheck,omegacheck);
az
end

save ICS_stream_base.mat ICS thetastream omegastream
