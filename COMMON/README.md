COMMON
====

Source for common components and functions used throughout all experiments in the paper.

To use:

benchmarks.m:
  - BBOB functions taken from http://coco.gforge.inria.fr/doku.php?id=start
  
calculatePerplexity.m:
  - Calculates the optimal perplexity (used in t-SNE) via an exhaustive search.

dispersion.m:
  - Calculates the dispersion of a given sample.
  - Implemented based on [1]

fast_h_function.m, fast_univariate_bandwidth_estimate_STEPI.m:
  - Solve-the-equation plug-in method for bandwidth estimation. Taken from http://www.umiacs.umd.edu/labs/cvl/pirl/vikas/Software/optimal_bw/optimal_bw_code.htm

FastUnivariateDensityDerivative.mexa64:
  - Compiled http://www.umiacs.umd.edu/labs/cvl/pirl/vikas/Software/optimal_bw/optimal_bw_code.htm used in the experiments. Use either the linux or windows below.
  - Default (i.e. this one) is Windows
  - If you want to use Linux, rename FastUnivariateDensityDerivative_linux.mexa64 to this file 

FastUnivariateDensityDerivative_linux.mexa64:
  - Compiled http://www.umiacs.umd.edu/labs/cvl/pirl/vikas/Software/optimal_bw/optimal_bw_code.htm for linux

FastUnivariateDensityDerivative_windows.mexa64:
  - Compiled http://www.umiacs.umd.edu/labs/cvl/pirl/vikas/Software/optimal_bw/optimal_bw_code.htm for windows

fitnessDistanceCorrelation.m:
  - Calculates fitness distance correlation from sample of data
  - Implemented based on [2]

informationContent.m:
  - Calculates the information content, the partial information content and information stability
  - Implemented based on [3]

lengthScale.m 
  - Calculates the length scales from the samples and measure various statistics.
  - Requirements:
    - The kernel density estimation uses the solve-the-equation plug-in method for bandwidth estimation (line 43).  To do this, I have used the code available at http://www.umiacs.umd.edu/labs/cvl/pirl/vikas/Software/optimal_bw/optimal_bw_code.htm. You will need to compile it and have the fast_univariate_bandwidth_estimate_STEPI.m file and mex file sitting in the same directory as these files.

plotHeatmap.m:
  - Plots a heatmap of the distances provided.

plotShaded.m:
  - Plots the average distribution, with shading of 1 standard deviation.

randomFixedWalk.m:
  - Conducts a random walk of fixed step size.

randomLevyWalk.m:
  - Conducts a random Levy walk.

stblrnd.m:
  - Calculates a random number from a Levy distribution.
  - NOTE: taken from http://math.bu.edu/people/mveillet/html/alphastablepub.html

tsne:
  - Contains the t-SNE implementation taken from http://lvdmaaten.github.io/tsne/

[1] M. Lunacek and D. Whitley. The dispersion metric and the CMA evolution strategy. In Proceedings of the Genetic and Evolutionary Computation Conference (GECCO’06), pages 477–484, New York, USA, 2006. ACM.

[2] T. Jones. Evolutionary algorithms, fitness landscapes and search. PhD thesis, The University of New Mexico, 1995.

[3] V. K. Vassilev, T. C. Fogarty, and J. F. Miller. Information characteristics and the structure of landscapes. Evolutionary Computation, 8:31–60, 2000. 267