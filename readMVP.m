%% readMVP extracts the MVP data frame in the data file
function [MVPmat,finalIndex] = readMVP(filecontent,inIndex,x1,x2,y1,y2) %Extract the MVP frame
MVPmat = zeros(95,64);
fileLength = length(filecontent);
i = inIndex;
while i < fileLength-2 %While the end of the file has not been reached
    if filecontent(i) == 77 && filecontent(i+1) == 86 && filecontent(i+2) == 80 %Check if 'MVP' has been reached
        [~,i] = readTill(filecontent,i,10); %If it has been reached, read until a New Line Feed is reached
        i = i+1; %Increment the current index by 1
        [~,i] = readTill(filecontent,i,10);%Repeat the process two more times
        i = i+1;
        [~,i] = readTill(filecontent,i,10);
        i = i+1;
        [~,i] = readTill(filecontent,i,9); %Read until a Horizontal Tab is reached
        i = i+1; %Increment the current index by 1
        for y = y1:y2 %Increment across each row
            for x = x1:x2 %Increment along each element in each row (column)
                [num,i] = readTill(filecontent,i,9); %Read each number, stopping at a Horizontal Tab
                if num == 32 %If the number is a space (blank)
                    num = 48; %Replace it with a zero 
                end
                MVPmat(y,x) = str2num(char(num)); %Set the read number in the appropriate index in the MVP matrix
                i = i+1; %Then increment the index by one and repeat across the row
            end
            [~,i] = readTill(filecontent,i,10); %Increment the index until a New Line Feed is reached
            [~,i] = readTill(filecontent,i,9); %Then increment the index until a Horizontal Tab is reached
            i = i+1; %Then increment past the tab and repeat the whole process for the next line
        end
        break %Break out of the loop when all numbers have been recorded
    end
    i = i + 1; %If 'MVP' has not been reached, increment the index until it is.
end
finalIndex = i; %Return the current index 
end
