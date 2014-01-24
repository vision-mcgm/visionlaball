%Does ANOVA on the results

clear PSEs;
clear fullPSEs
clear slopes;

adaptIndices=[1,1,1,2,2,2];
inversionIndices=[1,2,3,1,2,3];

adaptFactors={'bottom' 'bottom' 'bottom' 'top' 'top' 'top';};
inversionFactors={'upright' 'inverted' 'opposed' 'upright' 'inverted' 'opposed';};

it=1;
for subject=1:5
    for condition=1:6
        PSEs(it)=structs{subject,condition}.thresholds(2);
        adaptFactorList{it,1}=adaptFactors{condition};
        inversionFactorList{it,1}=inversionFactors{condition};
        
        slopes(it)=structs{subject,condition}.slopes(2);
        fullPSEs(subject,adaptIndices(condition),inversionIndices(condition))=PSEs(it);
        fullSlopes(subject,adaptIndices(condition),inversionIndices(condition))=slopes(it);
        it=it+1;
    end
end


