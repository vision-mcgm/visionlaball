i=1;
clear list;
ape=init_mape(5,5,(0:0.01:10)');
while 1
    v=ape.trialval
    resp=input('?');
    list(i,1)=v;
    list(i,2)=resp;
    ape=mapefunc_finney(i,list,ape);
    i=i+1;
end