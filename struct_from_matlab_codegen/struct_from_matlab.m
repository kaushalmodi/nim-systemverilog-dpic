%% Example of defining C-export-friendly "types"
% - Run codegen -config:lib -c struct_from_matlab
% - The .c and .h files will be created in ./codegen/lib/struct_from_matlab/

function [x, y] = struct_from_matlab()
%#codegen

% Below is a hack.. assign 'struct' output to a variable and use that variable as a "type".
myStruct = struct('someInt16Arr'  , int16(zeros(1, 5)) ... % short someInt16Arr[5]
                  , 'someDouble'  , double(0)          ... % double someDouble
                  , 'someInt32Arr', int32(zeros(1,10)) ... % int someInt32Arr[10]
                  , 'someFloat'   , single(0)          ... % float someFloat
                  , 'someStr'     , ""                 ... % rtString someStr
                 );

% Now define the struct name you'd like to see in the C Header.
coder.cstructname(myStruct, 'myStruct');

% Pseudo declaration of vars x and y to "type" myStruct.
x = myStruct;
y = myStruct;

% Assigning values to the x and y elements in arbitrary order.
x.someStr = "abc"
x.someFloat = single(7.9)
x.someInt32Arr(8) = 200
x.someInt16Arr(5) = 300
x.someDouble = 1.3
y.someInt32Arr(1) = 100
y.someStr = "def"
y.someFloat = single(4.4)
end

%% References
% https://www.mathworks.com/help/simulink/slref/coder.cstructname.html
% https://www.mathworks.com/help/matlab/data-types.html
