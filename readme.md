# pj-hd-smrbmi <br>

## Paper
Iwama, S., Morishige, M., Kodama, M. et al. High-density scalp electroencephalogram dataset during sensorimotor rhythm-based brain-computer interfacing. Sci Data 10, 385 (2023). https://doi.org/10.1038/s41597-023-02260-6


## Dataset 1
https://openneuro.org/datasets/ds004444/versions/1.0.0
## Dataset 2
https://openneuro.org/datasets/ds004446/versions/1.0.0
## Dataset 3
https://openneuro.org/datasets/ds004447/versions/1.0.0
## Dataset 4
https://openneuro.org/datasets/ds004448/versions/1.0.0

## environment <br>
    Mac OSX
    MATLAB2021b
        EEGLAB to load .edf file
        Delorme A, Makeig S. EEGLAB: an open source toolbox for analysis of single-trial EEG dynamics including independent component analysis. J Neurosci Methods. 2004 Mar 15;134(1):9-21. doi: 10.1016/j.jneumeth.2003.10.009. PMID: 15102499.

## Usage
1. modify ```path_DB_parent='path_2_data';``` in p01_main.m (Line 17) to set the local directory where the dataset is saved
3. run ```p01_main.m``` after ```eeglab.m``` was added in your path
4. run ```p02_visualize.m``` to replicate the figures



