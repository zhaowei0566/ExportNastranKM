% This code was developed to read stiffness and mass matrix exported by
% NASTRAN from punch file .pch through SOL 101/103
% =========================================================================
% These two lines should be added after 'CEND'in NASTRAN input files to 
% output *.pch file for this routine
%
% PARAM,COUPLMASS,1
% PARAM,EXTOUT,DMIGPCH
%
% =========================================================================
% Contact: Wei Zhao (weizhao@vt.edu)
% % 
% THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
% AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
% IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
% DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
% FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
% DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
% SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
% CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
% OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
% OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
% =================== VERSIONS ====================================
% v1: develop for NASTRAN beam/rod model test cases, May 2015

clear all;clc;format long;fclose('all')
% componment in GRDSET
% addpath('Z:\readNastranKM');

GRDSET=[ ];% constrained DOF 

DOF_Aset=setdiff(1:6,GRDSET);

% node label in FEM % TO DO; read from *.bdf file
% nodalabel=[1:10 12:16];
load nodalabel.txt

% leave SPCnodalabel blank for free-free vibration analysis
SPCnodalabel=[];
%===============
Nodes_Aset=setdiff(nodalabel,SPCnodalabel); % nodes label 

%
[filename,filepath]=uigetfile([ '*.pch'],'Select Nastran Output Stiffness and Mass Matrix, .pch');
pchfname=[filepath  filename];

Astiffness=readStiffness(pchfname,DOF_Aset,Nodes_Aset);

Amass=readMass(pchfname,DOF_Aset,Nodes_Aset);
%
%
% Astiffness and Amass are only for lower triangle, to get the full matrix:
for ii=1:size(Astiffness,2)
    
    for jj=ii:size(Astiffness,2)
        
        Astiffness(ii,jj)=Astiffness(jj,ii);
        Amass(ii,jj)=Amass(jj,ii);
    end
    
end

FEM.K=Astiffness;
FEM.M=Amass;

save('FEM_KM.mat','FEM')

%
%
%% Eigenvalue computation
disp('==== The first several mode frequencies (Hz) are: ======');
[modeshape,eigvalue] = eigs(Astiffness,Amass,20,'sm'); % first 10 smallest magnitude value
freq=sqrt(diag(eigvalue))/2/pi;
sort(real(freq))



