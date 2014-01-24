function [carry_on]=checkSuccess(tsks,results,jbnum)	% Checks for error messages and completion flag and returns true for success, or false for failure.
	good=1;
	len=size(tsks,2);
	for i=1:len
	    if size(tsks{i}.ErrorMessage,1)
		fprintf('Job %d, task %d has error message %s.\n',jbnum,i,tsks{i}.ErrorMessage);
		good=0;
	    end
	    if size(results,2)
		if results{i,1}~=1
		    fprintf('Job %d, task %d has not set its completion flag!\n',jbnum,i);
		    good=0;
		end
	    end
	end
	if good
	    fprintf('Job %d --------------- All tasks successful.----------------\n',jbnum);
	    carry_on=true;
	else
	    carry_on=false;
	end
end