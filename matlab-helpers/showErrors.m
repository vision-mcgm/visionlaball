function [ ok ] = showErrors( tasks )
%Shows errors of a ROW CELL of tasks

l=size(tasks,2);

acc=0;
for i=1:l
    if size(tasks{i}.errorMessage,1)>0
       ['Task ' num2str(i) ':']
        tasks{i}.errorMessage
        acc=acc+1;
    end
end

['There were ' num2str(acc) ' errors.']

end

