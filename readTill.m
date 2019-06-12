%% readTill is a utility function used to advance the position of the reading cursor in the data file
function [outVector,outIndex] = readTill(inVector,index1,stopChar)
len = length(inVector);                                            
index2 = 1;                                                        
outVector = [];                                                    
for i = index1:len %From a specified starting position to the end of the supplied vector
    if inVector(i) ~= stopChar %Check if the current ASCII character is a specific character
        outVector(index2) = inVector(i); %#ok<AGROW> If the character doesn't match, place the character in a vector
        index2 = index2 + 1; %then advance the current index by 1 and repeat
    else
        outIndex = i; %If the character does match, return the current index 
        break %then break out of the loop and return the character string and final index
    end
end
end
