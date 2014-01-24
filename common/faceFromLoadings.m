function [f  ] = faceFromLoadings( c,loadings )
%Generates face from loadings, given config file

PCA_path=[rightPath(c,c.dirPCAModel) 'all\PCAModel.mat'];
loaded=load(PCA_path);
PCA=loaded.PCA;
MV_mean=loaded.MorphMean;

MV_rel=PCA * loadings; %Generate rel morph vec

MV_abs=MV_rel + MV_mean; %Add mean morph

f=morphvec2image(c,MV_abs);

end

