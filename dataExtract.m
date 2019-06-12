%% dataExtract reades through each frame in the data file and extracts the data into its own 3D matrix
function [outData,finalIndex] = dataExtract(filecontent,depth,x1,x2,y1,y2) 
data = zeros(95,64,depth); %Pressure Matrix without cropping is 64x95
fileLength = length(filecontent);
i = 1;
while i < fileLength-6 %While the end of the file has not been reached
    if filecontent(i) == 70 && filecontent(i+6) == 10 %Check if the index is at an 'F' and if the 6th character after that is a New Line Feed
        [~,endIndex] = readTill(filecontent,i,9); %If the above is true, read until a tab is hit
        endIndex = endIndex+1; %Increment the index by one past the tab
        for z = 1:depth %For all the frames defined in the data file (Excluding MPP and MVP)
            for y = y1:y2 %Increment through each row 1 by 1
                for x = x1:x2 %Increment through each number in row (increment through column)
                    [num,endIndex] = readTill(filecontent,endIndex,9); %Read until a tab is hit and return the number
                    if num == 32 %If the number is a space (blank)
                        num = 48; %Change it to a zero instead (replacing NaN)
                    end
                    data(y,x,z) = str2num(char(num)); %Put the read number into its corresponding index in the data matrix
                    endIndex = endIndex+1; %Increment the file index by 1
                end
                [~,endIndex] = readTill(filecontent,endIndex,10); %Read until a New Line Feed is hit
                [~,endIndex] = readTill(filecontent,endIndex,9); %Read until a Horizontal Tab is hit
                endIndex = endIndex+1; %Then increment the index by 1
            end
            [~,endIndex] = readTill(filecontent,endIndex,12); %After each row has been parsed, increment the index until the next page
            if z < depth                                      %of the data file is reached (so a new data frame may be read)
                while ~(filecontent(endIndex) == 70 && filecontent(endIndex+6) == 10) %Check if the last frame has been reached and
                    endIndex = endIndex+1; %if not, increment the index until 'Force' in the summed forces column is reached
                end
                [~,endIndex] = readTill(filecontent,endIndex,9); %Then read until a tab is hit, putting the index at the start of the matrix
                endIndex = endIndex+1; %Increment the index by 1 and begin to read each number again
            end
        end
        break %After the last frame is reached, break out of the loop
    end
    i = i+1; %If the index is not at 'F' and a New Line Feed, increment the index by 1
end
outData = data; %Set the data matrix to be spit out by the function
finalIndex = endIndex; %Return the final index to be used for further parsing through the data file
end
