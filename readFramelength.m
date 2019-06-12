%% readFrame determines from the data file the amount of frames with captured data
function outNum = readFramelength(filecontent)  
pict_No = [80 105 99 116 45 78 111 46 58 32];  %Pict-No.: in ASCII characters
pict_Check = zeros(1,10);
pict_Check(1) = 80;
for i = 1:length(filecontent)-9 %From the start of the file to the end minus the length of Pict-No.:
    if filecontent(i) == 80 %Check if the first character is a P
        for j = 2:10 %If the first character is a P, store the next 8 characters + P in a vector
            pict_Check(j) = filecontent(i + j - 1) ;
        end 
        if isequal(pict_Check,pict_No) %Check if the vector is equal to Pict-No.:
            num_index = i + 10; %Advance the index to just past the word Pict-No.:
            [num,~] = readTill(filecontent,num_index,32); %Read until the function hits a space (32)
            newNum = char(num); %Assign the return vector which is the number of the frame to a variable
            if strcmp(newNum,'MPP') || strcmp(newNum,'MVP') %If Pict-No.: is matched, make sure it is not 
                break                                       %the MPP or MVP frame. If it is, break out of the loop
            else
            outNum = str2num(newNum); %If it's not the MPP or MVP frame, convert the ASCII character to a number
            end
        else
            pict_Check(2:10) = 0; %If the vector does not match Pict-No.:, turn the test vector back to zeros
        end
    end
end %Return the final number 
end
