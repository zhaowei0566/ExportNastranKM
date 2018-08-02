This routine is mainly used to read the stiffness and mass matrices from NASTRAN output file
Go to each test folder, run readKM_test_XXXX.m, select the corresponding *.pch file of interest
when you use it for other model, something you need to change as follow.
Keep improving... (Wei Zhao: weizhao@vt.edu), enjoy!
============================================================================================
1. Change path folder in addpath('') for each case. For example, in test_1 folder,
   change the line 43 folder path to yours where the readMass.m and readStiffness.m locate
2. GRDSET is a vector for degrees of freedom constrained
3. For the test cases here, comment 'PARAM,EXTOUT,matrixpch' when you run them for mode results using NASTRAN SOL103
4. *.PCH includes stiffness and mass matrices. They are directly used in eigenvalue computation. We called A-set
5. *.f06 includes eigenvalues and the corresponding eigenvectors from NASTRAN analysis - sol103
6. For nodal labels, it is better to copy them from *.pch after the line 'DMIG*   VAX                            1               0' and unique these values. 
   because some grids could possibly not considered in FEM when the element between two nodes has no properties, such as RBE2.
===
7. Because Github cannot identify *.pch file automatically, the uploaded stiffness and mass matrices are stored in *.pch1 file.
   change them to *.pch when you download them, and run the program.
=============================================================================================
This work was done as a part of developed optimization program for aircraft wing design in flight dynamics/flutter analysis, please cite my dissertation if you think the
code is useful, many thanks!

@phdthesis{zhao2017optimal,
  title={Optimal Design and Analysis of Bio-inspired, Curvilinearly Stiffened Composite Flexible Wings},
  author={Zhao, Wei},
  year={2017},
  school={Virginia Tech}
}