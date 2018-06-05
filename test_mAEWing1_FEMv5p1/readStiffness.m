function K=readStiffness(pchfname,DOF_Aset,Nodes_Aset)
% Read analysis set a-set stiffness and mass matrix
% PARAM,COUPLMASS,1
% PARAM,EXTOUT,DMIGPCH
% The output has its strict format, don't change any number below.
% TO DO: use sparse matrix to save stiffness and mass matrices.

nodes_num=length(Nodes_Aset);
%
fid111=fopen(pchfname);
status=fseek(fid111,0,'eof');
EOF=ftell(fid111);
currentFPI=fseek(fid111,0,'bof');
aset_dofs=length(DOF_Aset); % effective nodes, exclude the degrees for nodes in SPC
%
K=[];

while currentFPI<EOF
    
    linef06=fgetl(fid111);currentFPI=ftell(fid111);
    str1=findstr(linef06,'DMIG');
    
    str3=findstr(linef06,'KAAX');
    

    
    % ----------------------------------------------------------------
    %                  Read NASTRAN stiffness matrix
    % ----------------------------------------------------------------
    if length(linef06)>56 && isempty(str1)==0 && isempty(str3)==0
        
        str2num_line_temp = str2num(linef06(17:end)); % first line for stiffness matrix order
        
        stiff_matrix_order=str2num_line_temp(5);
        mass_matrix_order=stiff_matrix_order;
        
        K=zeros(stiff_matrix_order);
        
        % read stiffness
        rowID=0; % Initialize row ID should be less than stiffness matix order
        columnID=0; % Initialize column ID should be less than stiffness matix order
        
        while rowID<stiff_matrix_order && currentFPI<EOF
            
            
            linef06=fgetl(fid111);currentFPI=ftell(fid111);
            
            str2=findstr(linef06,'DMIG*');
            str3=findstr(linef06,'KAAX');
            % They are defined row by row
            
            if isempty(str2)==0 &&  isempty(str3)==0
                
                disp('--------------Stiffness matrix---------------')
                % use nodal label and dof after DMIG* KAAX to identify the
                % rowID
                
                grid_label=str2num(linef06(25:40));
                dof_label=str2num(linef06(41:56));
                
                
                node_num_temp = find(Nodes_Aset==grid_label);
                dof_num_temp = find(DOF_Aset==dof_label);
                
                % use these two parameter to calculate the row number
                
                rowID=(node_num_temp-1)*aset_dofs+dof_num_temp;
                
                
                % use the following information to identify the column
                % information
                
                max_column_label=rowID; % because of the square matrix for stiffness and mass matrices
                
                
                while columnID<max_column_label && currentFPI<EOF
                    
                    linef06=fgetl(fid111);currentFPI=ftell(fid111);
                    
                    grid_label=str2num(linef06(13:24));
                    dof_label=str2num(linef06(25:40));
                    
                    
                    node_num_temp2 = find(Nodes_Aset==grid_label);
                    dof_num_temp2 = find(DOF_Aset==dof_label);
                    
                
                    columnID=(node_num_temp2-1)*aset_dofs+dof_num_temp2;
                    
                    K(rowID,columnID)=str2num(linef06(41:56));
                    
                end
                
            end
        end
        
    end
end